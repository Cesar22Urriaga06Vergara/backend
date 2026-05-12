import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Reserva } from '../../reserva/entities/reserva.entity';
import { Habitacion } from '../../habitacion/entities/habitacion.entity';
import { Factura } from '../../factura/entities/factura.entity';
import { Hotel } from '../../hotel/entities/hotel.entity';
import { Empleado } from '../../empleado/entities/empleado.entity';
import { CajaTurno } from '../../caja/entities/caja-turno.entity';
import { CajaMovimiento } from '../../caja/entities/caja-movimiento.entity';
import { roundMoney } from '../utils/money.util';

@Injectable()
export class KpisService {
  constructor(
    @InjectRepository(Reserva)
    private readonly reservaRepository: Repository<Reserva>,
    @InjectRepository(Habitacion)
    private readonly habitacionRepository: Repository<Habitacion>,
    @InjectRepository(Factura)
    private readonly facturaRepository: Repository<Factura>,
    @InjectRepository(Hotel)
    private readonly hotelRepository: Repository<Hotel>,
    @InjectRepository(Empleado)
    private readonly empleadoRepository: Repository<Empleado>,
    @InjectRepository(CajaTurno)
    private readonly cajaTurnoRepository: Repository<CajaTurno>,
    @InjectRepository(CajaMovimiento)
    private readonly cajaMovimientoRepository: Repository<CajaMovimiento>,
  ) {}

  private rangoHoy() {
    const desde = new Date();
    desde.setHours(0, 0, 0, 0);
    const hasta = new Date(desde);
    hasta.setDate(hasta.getDate() + 1);
    return { desde, hasta };
  }

  private inicioMes() {
    const ahora = new Date();
    return new Date(ahora.getFullYear(), ahora.getMonth(), 1);
  }

  private inicioPeriodo(periodo: string) {
    const ahora = new Date();
    if (periodo === 'trimestre') {
      const trimestre = Math.floor(ahora.getMonth() / 3);
      return new Date(ahora.getFullYear(), trimestre * 3, 1);
    }
    if (periodo === 'año' || periodo === 'anio' || periodo === 'aÃ±o') {
      return new Date(ahora.getFullYear(), 0, 1);
    }
    return new Date(ahora.getFullYear(), ahora.getMonth(), 1);
  }

  async getFlujoDiaRecepcionista(idHotel: number) {
    const { desde, hasta } = this.rangoHoy();

    const [
      pendientesCheckin,
      pendientesCheckout,
      checkinsRealizados,
      checkoutsRealizados,
    ] = await Promise.all([
      this.reservaRepository
        .createQueryBuilder('reserva')
        .where('reserva.idHotel = :idHotel', { idHotel })
        .andWhere('reserva.checkinPrevisto >= :desde AND reserva.checkinPrevisto < :hasta', { desde, hasta })
        .andWhere('reserva.checkinReal IS NULL')
        .andWhere('reserva.estadoReserva IN (:...estados)', { estados: ['reservada', 'confirmada'] })
        .getCount(),
      this.reservaRepository
        .createQueryBuilder('reserva')
        .where('reserva.idHotel = :idHotel', { idHotel })
        .andWhere('reserva.checkoutPrevisto >= :desde AND reserva.checkoutPrevisto < :hasta', { desde, hasta })
        .andWhere('reserva.checkoutReal IS NULL')
        .andWhere('reserva.checkinReal IS NOT NULL')
        .andWhere('reserva.estadoReserva NOT IN (:...estados)', { estados: ['cancelada', 'rechazada', 'completada'] })
        .getCount(),
      this.reservaRepository
        .createQueryBuilder('reserva')
        .where('reserva.idHotel = :idHotel', { idHotel })
        .andWhere('reserva.checkinReal >= :desde AND reserva.checkinReal < :hasta', { desde, hasta })
        .getCount(),
      this.reservaRepository
        .createQueryBuilder('reserva')
        .where('reserva.idHotel = :idHotel', { idHotel })
        .andWhere('reserva.checkoutReal >= :desde AND reserva.checkoutReal < :hasta', { desde, hasta })
        .getCount(),
    ]);

    return {
      pendientesCheckin,
      pendientesCheckout,
      checkinsRealizados,
      checkoutsRealizados,
      timestamp: new Date().toISOString(),
    };
  }

  async getCajaDiaRecepcionista(idHotel: number) {
    const { desde, hasta } = this.rangoHoy();

    const [movimientos, turnoAbierto] = await Promise.all([
      this.cajaMovimientoRepository
        .createQueryBuilder('movimiento')
        .select('movimiento.tipo', 'tipo')
        .addSelect('COUNT(*)', 'cantidad')
        .addSelect('COALESCE(SUM(movimiento.monto), 0)', 'total')
        .where('movimiento.idHotel = :idHotel', { idHotel })
        .andWhere('movimiento.fechaMovimiento >= :desde AND movimiento.fechaMovimiento < :hasta', { desde, hasta })
        .groupBy('movimiento.tipo')
        .getRawMany<{ tipo: string; cantidad: string; total: string }>(),
      this.cajaTurnoRepository.findOne({
        where: { idHotel, estado: 'ABIERTA' },
        order: { fechaApertura: 'DESC' },
      }),
    ]);

    let ingresoTotal = 0;
    let egresos = 0;
    let movimientosHoy = 0;

    for (const movimiento of movimientos) {
      const total = Number(movimiento.total || 0);
      movimientosHoy += Number(movimiento.cantidad || 0);
      if (movimiento.tipo === 'INGRESO') {
        ingresoTotal += total;
      } else if (movimiento.tipo === 'EGRESO') {
        egresos += total;
      }
    }

    return {
      movimientosHoy,
      ingresoTotal: roundMoney(ingresoTotal),
      egresos: roundMoney(egresos),
      saldo: roundMoney(ingresoTotal - egresos),
      turnoAbierto: turnoAbierto
        ? {
            id: turnoAbierto.id,
            montoInicial: roundMoney(turnoAbierto.montoInicial),
            totalEsperado: roundMoney(turnoAbierto.totalEsperado),
            fechaApertura: turnoAbierto.fechaApertura,
          }
        : null,
      timestamp: new Date().toISOString(),
    };
  }

  async getEstadoHotel(idHotel: number) {
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);
    const en7Dias = new Date(hoy);
    en7Dias.setDate(en7Dias.getDate() + 7);
    const mesInicio = this.inicioMes();

    const [habitacionesPorEstado, reservasProximas7dias, ingresosMesRaw] = await Promise.all([
      this.habitacionRepository
        .createQueryBuilder('habitacion')
        .select('COALESCE(habitacion.estado, :sinEstado)', 'estado')
        .addSelect('COUNT(*)', 'cantidad')
        .where('habitacion.idHotel = :idHotel', { idHotel, sinEstado: 'sin_estado' })
        .groupBy('habitacion.estado')
        .getRawMany<{ estado: string; cantidad: string }>(),
      this.reservaRepository
        .createQueryBuilder('reserva')
        .where('reserva.idHotel = :idHotel', { idHotel })
        .andWhere('reserva.checkinPrevisto >= :hoy AND reserva.checkinPrevisto < :en7Dias', { hoy, en7Dias })
        .andWhere('reserva.estadoReserva IN (:...estados)', { estados: ['reservada', 'confirmada'] })
        .getCount(),
      this.facturaRepository
        .createQueryBuilder('factura')
        .select('COALESCE(SUM(factura.total), 0)', 'total')
        .where('factura.idHotel = :idHotel', { idHotel })
        .andWhere('factura.createdAt >= :mesInicio', { mesInicio })
        .andWhere('factura.estadoFactura != :anulada', { anulada: 'ANULADA' })
        .getRawOne<{ total: string }>(),
    ]);

    const estados = habitacionesPorEstado.reduce<Record<string, number>>((acc, row) => {
      acc[String(row.estado || 'sin_estado').toLowerCase()] = Number(row.cantidad || 0);
      return acc;
    }, {});
    const totalHabitaciones = Object.values(estados).reduce((sum, value) => sum + value, 0);
    const ocupadas = estados.ocupada || 0;

    return {
      ocupacionActual: totalHabitaciones > 0 ? roundMoney((ocupadas / totalHabitaciones) * 100) : 0,
      habitaciones: {
        total: totalHabitaciones,
        disponibles: estados.disponible || 0,
        ocupadas,
        limpieza: estados.limpieza || 0,
        mantenimiento: estados.mantenimiento || 0,
        bloqueadas: estados.bloqueada || 0,
      },
      reservasProximas7dias,
      ingresosMes: roundMoney(ingresosMesRaw?.total || 0),
      estado: 'operativo',
      timestamp: new Date().toISOString(),
    };
  }

  async getMetricasPlataforma() {
    const [hotelesActivos, usuariosTotales, facturasRaw] = await Promise.all([
      this.hotelRepository.count({ where: { estado: 'activo' } }),
      this.empleadoRepository.count(),
      this.facturaRepository
        .createQueryBuilder('factura')
        .select('COUNT(*)', 'facturas')
        .addSelect('COALESCE(SUM(factura.total), 0)', 'ingresos')
        .where('factura.estadoFactura != :anulada', { anulada: 'ANULADA' })
        .getRawOne<{ facturas: string; ingresos: string }>(),
    ]);

    return {
      hotelesActivos,
      usuariosTotales,
      ingresosTotales: roundMoney(facturasRaw?.ingresos || 0),
      facturasEmitidas: Number(facturasRaw?.facturas || 0),
      timestamp: new Date().toISOString(),
    };
  }

  async getCrecimientoPlataforma(periodo: string = 'mes') {
    const fechaInicio = this.inicioPeriodo(periodo);

    const [hotelesNuevos, usuariosNuevos, ingresosRaw] = await Promise.all([
      this.hotelRepository
        .createQueryBuilder('hotel')
        .where('hotel.fechaRegistro >= :fechaInicio', { fechaInicio })
        .getCount(),
      this.empleadoRepository
        .createQueryBuilder('empleado')
        .where('empleado.createdAt >= :fechaInicio', { fechaInicio })
        .getCount(),
      this.facturaRepository
        .createQueryBuilder('factura')
        .select('COALESCE(SUM(factura.total), 0)', 'total')
        .where('factura.createdAt >= :fechaInicio', { fechaInicio })
        .andWhere('factura.estadoFactura != :anulada', { anulada: 'ANULADA' })
        .getRawOne<{ total: string }>(),
    ]);

    return {
      hotelesNuevos,
      usuariosNuevos,
      ingresosPeriodo: roundMoney(ingresosRaw?.total || 0),
      periodo,
      timestamp: new Date().toISOString(),
    };
  }
}