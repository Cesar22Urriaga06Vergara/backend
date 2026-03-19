import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cliente } from '../cliente/entities/cliente.entity';
import { Reserva } from '../reserva/entities/reserva.entity';
import { Pedido } from '../servicio/entities/pedido.entity';
import { Factura } from '../factura/entities/factura.entity';

export interface HistorialClienteDto {
  cliente: {
    id: number;
    nombre: string;
    email: string;
    cedula: string;
  };
  totalReservas: number;
  totalGastado: number;
  reservasActuales: any[];
  reservasPasadas: any[];
  serviciosMasConsumidos: Array<{
    nombre: string;
    cantidad: number;
    montoTotal: number;
  }>;
  estadisticas: {
    promedioGastoPorReserva: number;
    reservasCompletadas: number;
    reservasCanceladas: number;
    ultimaVisita: Date | null;
    primerRegistro: Date;
  };
}

@Injectable()
export class HistorialClienteService {
  constructor(
    @InjectRepository(Cliente)
    private clienteRepository: Repository<Cliente>,
    @InjectRepository(Reserva)
    private reservaRepository: Repository<Reserva>,
    @InjectRepository(Pedido)
    private pedidoRepository: Repository<Pedido>,
    @InjectRepository(Factura)
    private facturaRepository: Repository<Factura>,
  ) {}

  /**
   * Obtener historial completo de un cliente
   * Si es admin, solo obtiene historial si cliente tiene reservas en su hotel
   */
  async obtenerHistorial(
    idCliente: number,
    userIdHotel?: number,
    userRole?: string,
  ): Promise<HistorialClienteDto> {
    // Verificar que el cliente existe
    const cliente = await this.clienteRepository.findOne({
      where: { id: idCliente },
    });

    if (!cliente) {
      throw new NotFoundException(`Cliente con ID ${idCliente} no encontrado`);
    }

    // Si es admin, validar que cliente tiene reservas en su hotel
    if (userRole === 'admin' && userIdHotel) {
      const tieneReservasEnHotel = await this.reservaRepository.findOne({
        where: {
          idCliente,
          idHotel: userIdHotel,
        },
      });

      if (!tieneReservasEnHotel) {
        throw new NotFoundException(
          `Cliente ${idCliente} no tiene reservas en su hotel`,
        );
      }
    }

    // Obtener todas las reservas del cliente
    const reservas = await this.reservaRepository.find({
      where: { idCliente },
      relations: ['habitacion', 'tipoHabitacion'],
      order: { createdAt: 'DESC' },
    });

    // Separar reservas actuales y pasadas
    const ahora = new Date();
    const reservasActuales = reservas.filter(
      r => new Date(r.checkoutPrevisto) > ahora && r.estadoReserva !== 'cancelada',
    );
    const reservasPasadas = reservas.filter(
      r => new Date(r.checkoutPrevisto) <= ahora || r.estadoReserva === 'cancelada',
    );

    // Obtener facturas para calcular gasto total
    const facturas = await this.facturaRepository.find({
      where: { idCliente },
    });

    const totalGastado = facturas.reduce((sum, f) => sum + Number(f.total), 0);

    // Obtener servicios consumidos
    const pedidos = await this.pedidoRepository.find({
      where: { idCliente },
      relations: ['items'],
    });

    const serviciosMap = new Map<string, { cantidad: number; monto: number }>();
    for (const pedido of pedidos) {
      for (const item of pedido.items) {
        const key = item.nombreServicioSnapshot;
        const actual = serviciosMap.get(key) || { cantidad: 0, monto: 0 };
        serviciosMap.set(key, {
          cantidad: actual.cantidad + item.cantidad,
          monto: actual.monto + Number(item.subtotal),
        });
      }
    }

    const serviciosMasConsumidos = Array.from(serviciosMap.entries())
      .map(([nombre, data]) => ({
        nombre,
        cantidad: data.cantidad,
        montoTotal: data.monto,
      }))
      .sort((a, b) => b.cantidad - a.cantidad)
      .slice(0, 10);

    // Calcular estadísticas
    const reservasCompletadas = reservas.filter(
      r => r.estadoReserva === 'completada',
    ).length;
    const reservasCanceladas = reservas.filter(
      r => r.estadoReserva === 'cancelada',
    ).length;
    const ultimaVisita =
      reservasPasadas.length > 0 ? new Date(reservasPasadas[0].checkoutReal) : null;
    const promedioGastoPorReserva =
      reservasCompletadas > 0 ? totalGastado / reservasCompletadas : 0;

    return {
      cliente: {
        id: cliente.id,
        nombre: cliente.nombre,
        email: cliente.email,
        cedula: cliente.cedula,
      },
      totalReservas: reservas.length,
      totalGastado,
      reservasActuales: reservasActuales.map(r => ({
        id: r.id,
        codigoConfirmacion: r.codigoConfirmacion,
        checkinPrevisto: r.checkinPrevisto,
        checkoutPrevisto: r.checkoutPrevisto,
        estado: r.estadoReserva,
        habitacion: r.habitacion?.numeroHabitacion,
        tipoHabitacion: r.tipoHabitacion?.nombreTipo,
      })),
      reservasPasadas: reservasPasadas.slice(0, 10).map(r => ({
        id: r.id,
        codigoConfirmacion: r.codigoConfirmacion,
        checkin: r.checkinReal || r.checkinPrevisto,
        checkout: r.checkoutReal || r.checkoutPrevisto,
        estado: r.estadoReserva,
        habitacion: r.habitacion?.numeroHabitacion,
        tipoHabitacion: r.tipoHabitacion?.nombreTipo,
      })),
      serviciosMasConsumidos,
      estadisticas: {
        promedioGastoPorReserva: Math.round(promedioGastoPorReserva * 100) / 100,
        reservasCompletadas,
        reservasCanceladas,
        ultimaVisita,
        primerRegistro: cliente.createdAt,
      },
    };
  }

  /**
   * Obtener resumen de cliente (para dashboard de admin)
   */
  async obtenerResumen(idCliente: number) {
    const historial = await this.obtenerHistorial(idCliente);

    return {
      cliente: historial.cliente,
      totalReservas: historial.totalReservas,
      totalGastado: historial.totalGastado,
      estadisticas: historial.estadisticas,
      serviciosFavoritos: historial.serviciosMasConsumidos.slice(0, 5),
    };
  }

  /**
   * Obtener clientes VIP (más de X reservas o más de Y gasto)
   * Si es admin, solo ve VIPs del su hotel
   */
  async obtenerClientesVIP(
    minReservas: number = 5,
    minGasto: number = 1000000,
    userIdHotel?: number,
    userRole?: string,
  ) {
    let facturas = await this.facturaRepository.find();
    let reservas = await this.reservaRepository.find();

    // Si es admin, filtrar por hotel
    if (userRole === 'admin' && userIdHotel) {
      facturas = facturas.filter(f => f.idHotel === userIdHotel);
      reservas = reservas.filter(r => r.idHotel === userIdHotel);
    }

    const gastosPorCliente = new Map<number, number>();
    facturas.forEach(f => {
      const actual = gastosPorCliente.get(f.idCliente) || 0;
      gastosPorCliente.set(f.idCliente, actual + Number(f.total));
    });

    const reservasPorCliente = new Map<number, number>();
    reservas.forEach(r => {
      const actual = reservasPorCliente.get(r.idCliente) || 0;
      reservasPorCliente.set(r.idCliente, actual + 1);
    });

    const clientesVIP: Array<{
      idCliente: number;
      reservas: number;
      gasto: number;
    }> = [];

    gastosPorCliente.forEach((gasto, idCliente) => {
      const reservasCount = reservasPorCliente.get(idCliente) || 0;
      if (reservasCount >= minReservas || gasto >= minGasto) {
        clientesVIP.push({ idCliente, reservas: reservasCount, gasto });
      }
    });

    return clientesVIP.sort((a, b) => b.gasto - a.gasto);
  }
}
