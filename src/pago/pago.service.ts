import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Pago } from './entities/pago.entity';
import { CreatePagoDto } from './dto/create-pago.dto';
import { FacturaService } from '../factura/factura.service';
import { MedioPagoService } from '../medio-pago/medio-pago.service';

@Injectable()
export class PagoService {
  constructor(
    @InjectRepository(Pago)
    private pagoRepository: Repository<Pago>,
    private facturaService: FacturaService,
    private medioPagoService: MedioPagoService,
  ) {}

  /**
   * Registrar un pago para una factura
   * Valida que el medio de pago exista y que si requiere referencia, sea proporcionada
   * Recalcula el estado de la factura basado en el total pagado
   */
  async registrarPago(
    dto: CreatePagoDto,
    idEmpleado?: number,
  ): Promise<Pago> {
    // Verificar que la factura exista y no esté anulada
    const factura = await this.facturaService.findOne(dto.idFactura);

    if (factura.estado === 'anulada') {
      throw new BadRequestException('No se puede registrar pago en factura anulada');
    }

    // Verificar que el monto es positivo
    if (dto.monto <= 0) {
      throw new BadRequestException('El monto debe ser mayor a cero');
    }

    // Verificar que el medio de pago existe
    const medioPago = await this.medioPagoService.findOne(dto.idMedioPago);

    // Validar que si el medio requiere referencia, sea proporcionada
    if (medioPago.requiereReferencia && !dto.referenciaPago) {
      throw new BadRequestException(
        `El medio de pago "${medioPago.nombre}" requiere número de referencia`,
      );
    }

    // Crear y guardar el pago
    const pagoBd = await this.pagoRepository.save({
      idFactura: dto.idFactura,
      idMedioPago: dto.idMedioPago,
      monto: dto.monto,
      referenciaPago: dto.referenciaPago || null,
      idEmpleadoRegistro: idEmpleado || null,
      estado: 'completado',
      observaciones: dto.observaciones || null,
    } as any);

    // Recalcular estado de la factura
    const pagosCompletados = await this.pagoRepository.find({
      where: { idFactura: dto.idFactura, estado: 'completado' },
    });

    const totalPagado = pagosCompletados.reduce(
      (sum, p) => sum + Number(p.monto),
      0,
    );

    // Si el total pagado >= factura.total, marcar como pagada (si no estaba ya)
    if (totalPagado >= Number(factura.total) && factura.estado !== 'pagada') {
      factura.estado = 'pagada';
      await this.facturaService['facturaRepository'].save(factura);
    }

    const pagoGuardado = await this.pagoRepository.findOne({
      where: { id: pagoBd.id },
      relations: ['medioPago', 'factura'],
    });

    if (!pagoGuardado) {
      throw new BadRequestException('Error al guardar el pago');
    }

    return pagoGuardado;
  }

  /**
   * Obtener todos los pagos de una factura
   */
  async findByFactura(idFactura: number): Promise<Pago[]> {
    return this.pagoRepository.find({
      where: { idFactura },
      relations: ['medioPago'],
      order: { fechaPago: 'DESC' },
    });
  }

  /**
   * Obtener todos los pagos con filtros
   */
  async findAll(filters?: {
    idHotel?: number;
    fechaDesde?: Date;
    fechaHasta?: Date;
  }): Promise<Pago[]> {
    let query = this.pagoRepository.createQueryBuilder('p');

    if (filters?.fechaDesde) {
      query = query.andWhere('p.fechaPago >= :fechaDesde', {
        fechaDesde: filters.fechaDesde,
      });
    }

    if (filters?.fechaHasta) {
      query = query.andWhere('p.fechaPago <= :fechaHasta', {
        fechaHasta: filters.fechaHasta,
      });
    }

    query = query
      .leftJoinAndSelect('p.medioPago', 'medioPago')
      .leftJoinAndSelect('p.factura', 'factura')
      .orderBy('p.fechaPago', 'DESC');

    return query.getMany();
  }

  /**
   * Devolver un pago (cambiar estado a 'devuelto')
   * Revertir el estado de la factura si es necesario
   */
  async devolverPago(id: number, motivo: string): Promise<Pago> {
    const pago = await this.pagoRepository.findOne({
      where: { id },
      relations: ['factura'],
    });

    if (!pago) {
      throw new NotFoundException(`Pago con ID ${id} no encontrado`);
    }

    // Cambiar estado del pago
    pago.estado = 'devuelto';
    pago.observaciones = `DEVUELTO: ${motivo}`;

    const pagoDev = await this.pagoRepository.save(pago);

    // Recalcular estado de la factura
    const pagosCompletados = await this.pagoRepository.find({
      where: { idFactura: pago.idFactura, estado: 'completado' },
    });

    const totalPagado = pagosCompletados.reduce(
      (sum, p) => sum + Number(p.monto),
      0,
    );

    // Si el total pagado < factura.total, revertir a 'emitida' o 'pendiente'
    const factura = pago.factura;
    if (totalPagado < Number(factura.total)) {
      factura.estado = factura.estado === 'pagada' ? 'emitida' : factura.estado;
      await this.pagoRepository.manager.save(factura);
    }

    const pagoDevoluto = await this.pagoRepository.findOne({
      where: { id: pagoDev.id },
      relations: ['medioPago', 'factura'],
    });

    if (!pagoDevoluto) {
      throw new BadRequestException('Error al procesar la devolución');
    }

    return pagoDevoluto;
  }
}
