import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Factura } from './entities/factura.entity';
import { DetalleFactura } from './entities/detalle-factura.entity';
import { CreateFacturaDto } from './dto/create-factura.dto';
import { UpdateFacturaDto } from './dto/update-factura.dto';
import { ReservaService } from '../reserva/reserva.service';
import { Reserva } from '../reserva/entities/reserva.entity';
import { Pedido } from '../servicio/entities/pedido.entity';
import { PedidoItem } from '../servicio/entities/pedido-item.entity';

@Injectable()
export class FacturaService {
  constructor(
    @InjectRepository(Factura)
    private facturaRepository: Repository<Factura>,
    @InjectRepository(DetalleFactura)
    private detalleFacturaRepository: Repository<DetalleFactura>,
    @InjectRepository(Pedido)
    private pedidoRepository: Repository<Pedido>,
    @InjectRepository(PedidoItem)
    private pedidoItemRepository: Repository<PedidoItem>,
    private dataSource: DataSource,
    private reservaService: ReservaService,
  ) {}

  /**
   * Generar número de factura secuencial
   * Formato: FAC-{AÑO}-{SECUENCIA_5_DÍGITOS}
   * Ejemplo: FAC-2026-00001
   */
  private async generarNumeroFactura(): Promise<string> {
    const año = new Date().getFullYear();

    // Buscar la última factura creada
    const ultimaFactura = await this.facturaRepository.findOne({
      order: { id: 'DESC' },
    });

    const siguiente = (ultimaFactura?.id ?? 0) + 1;
    return `FAC-${año}-${String(siguiente).padStart(5, '0')}`;
  }

  /**
   * Generar factura desde una reserva completada
   * Calcula:
   *  - Línea de habitación (noches * precio/noche)
   *  - Líneas de servicios entregados (items de pedidos entregados)
   * Retorna la factura con detalles y cálculos de IVA
   */
  async generarDesdeReserva(reserva: Reserva): Promise<Factura> {
    // Validar que no exista ya una factura para esta reserva
    const facturaExistente = await this.facturaRepository.findOne({
      where: { idReserva: reserva.id },
    });

    if (facturaExistente) {
      throw new ConflictException(
        `Ya existe una factura para la reserva ${reserva.id}`,
      );
    }

    // Iniciar transacción para garantizar integridad del número secuencial
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Generar número de factura dentro de la transacción
      const numeroFactura = await this.generarNumeroFactura();

      // Calcular número de noches
      const checkin = reserva.checkinReal || reserva.checkinPrevisto;
      const checkout = reserva.checkoutReal || reserva.checkoutPrevisto;
      const numeroNoches = Math.ceil(
        (new Date(checkout).getTime() - new Date(checkin).getTime()) /
          (1000 * 60 * 60 * 24),
      );

      // Preparar arreglo de detalles
      const detalles: Partial<DetalleFactura>[] = [];

      // 1. Línea por habitación
      const subtotalHabitacion =
        numeroNoches * Number(reserva.precioNocheSnapshot);
      const formatCheckin = new Date(checkin).toLocaleDateString('es-CO');
      const formatCheckout = new Date(checkout).toLocaleDateString('es-CO');

      detalles.push({
        tipoConcepto: 'habitacion',
        descripcion: `Habitación ${reserva.habitacion?.numeroHabitacion || 'N/A'} - ${numeroNoches} noche(s) (${formatCheckin} al ${formatCheckout})`,
        cantidad: numeroNoches,
        precioUnitario: Number(reserva.precioNocheSnapshot),
        subtotal: subtotalHabitacion,
        descuento: 0,
        total: subtotalHabitacion,
        idReferencia: reserva.idHabitacion,
      });

      // 2. Líneas por servicios entregados
      const pedidosEntregados = await this.pedidoRepository.find({
        where: {
          idReserva: reserva.id,
          estadoPedido: 'entregado',
        },
        relations: ['items'],
      });

      for (const pedido of pedidosEntregados) {
        for (const item of pedido.items) {
          const subtotalServicio =
            Number(item.cantidad) * Number(item.precioUnitarioSnapshot);

          detalles.push({
            tipoConcepto: 'servicio',
            descripcion: `${item.nombreServicioSnapshot} (${new Date(pedido.fechaPedido).toLocaleDateString('es-CO')})`,
            cantidad: item.cantidad,
            precioUnitario: Number(item.precioUnitarioSnapshot),
            subtotal: subtotalServicio,
            descuento: 0,
            total: subtotalServicio,
            idReferencia: item.id,
          });
        }
      }

      // 3. Calcular totales
      const subtotal = detalles.reduce((sum, d) => sum + Number(d.total), 0);
      const porcentajeIva = 19; // IVA estándar Colombia
      const montoIva = subtotal * (porcentajeIva / 100);
      const total = subtotal + montoIva;

      // 4. Crear factura
      const factura = new Factura();
      factura.numeroFactura = numeroFactura;
      factura.idReserva = reserva.id;
      factura.idCliente = reserva.idCliente;
      factura.nombreCliente = reserva.nombreCliente;
      factura.cedulaCliente = reserva.cedulaCliente;
      factura.emailCliente = reserva.emailCliente;
      factura.idHotel = reserva.idHotel;
      factura.subtotal = subtotal;
      factura.porcentajeIva = porcentajeIva;
      factura.montoIva = montoIva;
      factura.total = total;
      factura.estado = 'pendiente';
      factura.observaciones = '';

      // 5. Guardar factura y detalles
      const facturaGuardada = await queryRunner.manager.save(factura);

      const detallesConFactura = detalles.map((d) => ({
        ...d,
        idFactura: facturaGuardada.id,
      }));

      await queryRunner.manager.save(DetalleFactura, detallesConFactura);

      // Recargar factura con detalles
      const facturaCompleta = await queryRunner.manager.findOne(Factura, {
        where: { id: facturaGuardada.id },
        relations: ['detalles'],
      });

      await queryRunner.commitTransaction();

      return facturaCompleta;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  /**
   * Obtener todas las facturas con filtros opcionales
   */
  async findAll(filters?: {
    idHotel?: number;
    estado?: string;
    idCliente?: number;
  }): Promise<Factura[]> {
    const query = this.facturaRepository.createQueryBuilder('f');

    if (filters?.idHotel) {
      query.where('f.idHotel = :idHotel', { idHotel: filters.idHotel });
    }

    if (filters?.estado) {
      if (!query.parameters.length) {
        query.where('f.estado = :estado', { estado: filters.estado });
      } else {
        query.andWhere('f.estado = :estado', { estado: filters.estado });
      }
    }

    if (filters?.idCliente) {
      if (!query.parameters.length) {
        query.where('f.idCliente = :idCliente', { idCliente: filters.idCliente });
      } else {
        query.andWhere('f.idCliente = :idCliente', { idCliente: filters.idCliente });
      }
    }

    query.leftJoinAndSelect('f.detalles', 'detalles');
    query.leftJoinAndSelect('f.pagos', 'pagos');
    query.leftJoinAndSelect('f.reserva', 'reserva');
    query.orderBy('f.createdAt', 'DESC');

    return query.getMany();
  }

  /**
   * Obtener una factura por ID
   */
  async findOne(id: number): Promise<Factura> {
    const factura = await this.facturaRepository.findOne({
      where: { id },
      relations: ['detalles', 'pagos', 'reserva'],
    });

    if (!factura) {
      throw new NotFoundException(`Factura con ID ${id} no encontrada`);
    }

    return factura;
  }

  /**
   * Obtener factura por ID de reserva
   */
  async findByReserva(idReserva: number): Promise<Factura> {
    const factura = await this.facturaRepository.findOne({
      where: { idReserva },
      relations: ['detalles', 'pagos', 'reserva'],
    });

    if (!factura) {
      throw new NotFoundException(
        `No se encontró factura para la reserva ${idReserva}`,
      );
    }

    return factura;
  }

  /**
   * Obtener todas las facturas de un cliente
   */
  async findByCliente(idCliente: number): Promise<Factura[]> {
    return this.facturaRepository.find({
      where: { idCliente },
      relations: ['detalles', 'pagos', 'reserva'],
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Emitir factura (cambiar estado a 'emitida')
   */
  async emitir(id: number): Promise<Factura> {
    const factura = await this.findOne(id);

    if (!['pendiente', 'pagada'].includes(factura.estado)) {
      throw new BadRequestException(
        `No se puede emitir una factura en estado ${factura.estado}`,
      );
    }

    factura.estado = 'emitida';
    factura.fechaEmision = new Date();
    factura.fechaVencimiento = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 días

    return this.facturaRepository.save(factura);
  }

  /**
   * Anular factura
   */
  async anular(id: number, motivo: string): Promise<Factura> {
    const factura = await this.findOne(id);

    // No se puede anular si ya tiene pagos completados
    const pagosCompletados = factura.pagos?.filter(
      (p) => p.estado === 'completado',
    );

    if (pagosCompletados && pagosCompletados.length > 0) {
      throw new BadRequestException(
        'No se puede anular una factura que ya tiene pagos registrados',
      );
    }

    factura.estado = 'anulada';
    factura.observaciones = `ANULADA: ${motivo}`;

    return this.facturaRepository.save(factura);
  }

  /**
   * Actualizar factura (datos globales, no detalles)
   */
  async update(id: number, dto: UpdateFacturaDto): Promise<Factura> {
    const factura = await this.findOne(id);

    if (dto.estado) {
      factura.estado = dto.estado;
    }
    if (dto.observaciones) {
      factura.observaciones = dto.observaciones;
    }
    if (dto.cufe) {
      factura.cufe = dto.cufe;
    }

    return this.facturaRepository.save(factura);
  }
}
