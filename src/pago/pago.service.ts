import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Pago } from './entities/pago.entity';
import { CreatePagoDto } from './dto/create-pago.dto';
import { DevolverPagoDto } from './dto/devolver-pago.dto';
import { CreatePagoMixtoDto } from './dto/create-pago-mixto.dto';
import { FacturaService } from '../factura/factura.service';
import { MedioPagoService } from '../medio-pago/medio-pago.service';
import { roundMoney } from '../common/utils/money.util';
import { CajaTurno } from '../caja/entities/caja-turno.entity';
import { CajaMovimiento } from '../caja/entities/caja-movimiento.entity';

@Injectable()
export class PagoService {
  constructor(
    @InjectRepository(Pago)
    private pagoRepository: Repository<Pago>,
    private facturaService: FacturaService,
    private medioPagoService: MedioPagoService,
    private dataSource: DataSource,
  ) {}

  /**
   * Registrar un pago para una factura
   * Valida:
   *  - Que la factura exista y no esté anulada
   *  - Que el medio de pago exista
   *  - Que si requiere referencia, sea proporcionada
   *  - Si es efectivo: que montoRecibido >= monto (cambio no negativo)
   *  - Que el monto pagado + pagos anteriores no exceda el total de la factura
   * Recalcula el estado de la factura basado en el total pagado
   */
  async registrarPago(
    dto: CreatePagoDto,
    idEmpleado?: number,
    scope?: { rol?: string; idHotel?: number },
  ): Promise<Pago> {
    // Verificar que la factura exista y no esté anulada
    const factura = await this.facturaService.findOne(dto.idFactura);

    if (['recepcionista', 'cajero'].includes(scope?.rol || '') && !scope?.idHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel');
    }

    if (['recepcionista', 'cajero'].includes(scope?.rol || '') && factura.idHotel !== scope?.idHotel) {
      throw new ForbiddenException('No tiene autorizacion para registrar pagos de otro hotel');
    }

    if (factura.estado === 'anulada') {
      throw new BadRequestException('No se puede registrar pago en factura anulada');
    }

    // Verificar que el monto es positivo
    if (dto.montoCobrar <= 0) {
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

    // Validar que no se pague más del total de la factura
    const pagosCompletados = await this.pagoRepository.find({
      where: { idFactura: dto.idFactura, estado: 'completado' },
    });

    const totalPagoPrevio = pagosCompletados.reduce(
      (sum, p) => sum + Number(p.monto),
      0,
    );

    const totalPagoNuevo = roundMoney(totalPagoPrevio + dto.montoCobrar);
    const totalFactura = roundMoney(factura.total);

    if (totalPagoNuevo > totalFactura) {
      throw new BadRequestException(
        `El monto especificado ($${dto.montoCobrar}) sumado a pagos previos ($${totalPagoPrevio}) excede el total de la factura ($${totalFactura}). Máximo permitido: $${totalFactura - totalPagoPrevio}`,
      );
    }

    // Validaciones específicas para efectivo
    let cambioDevuelto = 0;
    if (medioPago.nombre === 'efectivo') {
      if (!dto.montoRecibido || dto.montoRecibido < 0) {
        throw new BadRequestException(
          'Para pagos en efectivo, debe especificar el monto recibido',
        );
      }

      if (dto.montoRecibido < dto.montoCobrar) {
        throw new BadRequestException(
          `Efectivo insuficiente. Total: $${dto.montoCobrar}, Recibido: $${dto.montoRecibido}`,
        );
      }

      cambioDevuelto = roundMoney(dto.montoRecibido - dto.montoCobrar);
    }

    const pagoGuardado = await this.dataSource.transaction(async (manager) => {
      const turno = await manager.findOne(CajaTurno, {
        where: { idHotel: factura.idHotel, estado: 'ABIERTA' },
        lock: { mode: 'pessimistic_write' },
      });

      if (!turno) {
        throw new BadRequestException('Debe abrir caja antes de registrar pagos');
      }

      const pagoBd = await manager.save(Pago, {
        idFactura: dto.idFactura,
        idMedioPago: dto.idMedioPago,
        monto: dto.montoCobrar,
        montoRecibido: dto.montoRecibido || null,
        cambioDevuelto,
        referenciaPago: dto.referenciaPago || null,
        idEmpleadoRegistro: idEmpleado || null,
        estado: 'completado',
        observaciones: dto.observaciones || null,
      } as any);

      const movimiento = manager.create(CajaMovimiento, {
        idTurno: turno.id,
        idHotel: factura.idHotel,
        idUsuario: idEmpleado || 0,
        tipo: 'INGRESO',
        origen: 'FACTURA',
        monto: roundMoney(dto.montoCobrar),
        idMedioPago: dto.idMedioPago,
        metodoPago: medioPago.nombre,
        concepto: `Pago factura ${factura.numeroFactura}`,
        referencia: dto.referenciaPago || `PAGO-${pagoBd.id}`,
        idFactura: dto.idFactura,
        observaciones: dto.observaciones || null,
      });

      await manager.save(CajaMovimiento, movimiento);

      turno.totalIngresos = roundMoney(Number(turno.totalIngresos || 0) + Number(dto.montoCobrar || 0));
      turno.totalEsperado = roundMoney(
        Number(turno.montoInicial || 0) + Number(turno.totalIngresos || 0) - Number(turno.totalEgresos || 0),
      );
      await manager.save(CajaTurno, turno);

      // Recalcular y actualizar estado de la factura segun total pagado
      if (totalPagoNuevo >= totalFactura && factura.estado !== 'pagada') {
        const estadoAnterior = factura.estadoFactura || 'EMITIDA';
        factura.estado = 'pagada';
        factura.estadoFactura = 'PAGADA';
        await manager.save(factura);

        try {
          const FacturaCambiosRepo = manager.getRepository('FacturaCambio');
          await FacturaCambiosRepo.save({
            idFactura: dto.idFactura,
            usuarioId: idEmpleado || null,
            tipoCambio: 'CAMBIO_ESTADO',
            descripcion: `Pago aplicado - Factura pagada. Monto: $${dto.montoCobrar}. Total pagado: $${totalPagoNuevo}`,
            valorAnterior: JSON.stringify({ estado: factura.estado, estadoFactura: estadoAnterior }),
            valorNuevo: JSON.stringify({ estado: 'pagada', estadoFactura: 'PAGADA' }),
          });
        } catch (error) {
          console.warn('Error registrando cambio en auditoria:', error.message);
        }
      } else if (totalPagoNuevo > 0 && totalPagoNuevo < totalFactura && factura.estado !== 'parcialmente_pagada') {
        const estadoAnterior = factura.estadoFactura || 'EMITIDA';
        factura.estado = 'parcialmente_pagada';
        factura.estadoFactura = 'EMITIDA';
        await manager.save(factura);

        try {
          const FacturaCambiosRepo = manager.getRepository('FacturaCambio');
          await FacturaCambiosRepo.save({
            idFactura: dto.idFactura,
            usuarioId: idEmpleado || null,
            tipoCambio: 'CAMBIO_ESTADO',
            descripcion: `Pago parcial aplicado. Monto: $${dto.montoCobrar}. Total pagado: $${totalPagoNuevo} de $${totalFactura}`,
            valorAnterior: JSON.stringify({ estado: factura.estado, estadoFactura: estadoAnterior }),
            valorNuevo: JSON.stringify({ estado: 'parcialmente_pagada', estadoFactura: 'EMITIDA' }),
          });
        } catch (error) {
          console.warn('Error registrando cambio en auditoria:', error.message);
        }
      }

      return manager.findOne(Pago, {
        where: { id: pagoBd.id },
        relations: ['medioPago', 'factura'],
      });
    });

    if (!pagoGuardado) {
      throw new BadRequestException('Error al guardar el pago');
    }

    return pagoGuardado;
  }

  /**
   * Registrar varias lineas de pago para una factura en una sola transaccion.
   * Si una linea falla, no se guarda ningun pago ni movimiento de caja.
   */
  async registrarPagoMixto(
    dto: CreatePagoMixtoDto,
    idEmpleado?: number,
    scope?: { rol?: string; idHotel?: number },
  ): Promise<Pago[]> {
    const factura = await this.facturaService.findOne(dto.idFactura);

    if (['recepcionista', 'cajero'].includes(scope?.rol || '') && !scope?.idHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel');
    }

    if (['recepcionista', 'cajero'].includes(scope?.rol || '') && factura.idHotel !== scope?.idHotel) {
      throw new ForbiddenException('No tiene autorizacion para registrar pagos de otro hotel');
    }

    if (factura.estado === 'anulada') {
      throw new BadRequestException('No se puede registrar pago en factura anulada');
    }

    const pagosCompletados = await this.pagoRepository.find({
      where: { idFactura: dto.idFactura, estado: 'completado' },
    });

    const totalPagoPrevio = roundMoney(
      pagosCompletados.reduce((sum, p) => sum + Number(p.monto || 0), 0),
    );
    const totalNuevo = roundMoney(
      totalPagoPrevio + dto.pagos.reduce((sum, p) => sum + Number(p.montoCobrar || 0), 0),
    );
    const totalFactura = roundMoney(Number(factura.total || 0));

    if (totalNuevo > totalFactura) {
      throw new BadRequestException(
        `El pago mixto excede el saldo de la factura. Saldo permitido: $${roundMoney(totalFactura - totalPagoPrevio)}`,
      );
    }

    const lineas = [] as Array<{
      idMedioPago: number;
      montoCobrar: number;
      montoRecibido?: number;
      cambioDevuelto: number;
      referenciaPago?: string;
      observaciones?: string;
      medioPagoNombre: string;
    }>;

    for (const linea of dto.pagos) {
      const medioPago = await this.medioPagoService.findOne(linea.idMedioPago);

      if (medioPago.requiereReferencia && !linea.referenciaPago) {
        throw new BadRequestException(
          `El medio de pago "${medioPago.nombre}" requiere numero de referencia`,
        );
      }

      let cambioDevuelto = 0;
      if (medioPago.nombre === 'efectivo') {
        if (linea.montoRecibido === undefined || linea.montoRecibido < 0) {
          throw new BadRequestException('Para pagos en efectivo, debe especificar el monto recibido');
        }
        if (linea.montoRecibido < linea.montoCobrar) {
          throw new BadRequestException(
            `Efectivo insuficiente. Total: $${linea.montoCobrar}, Recibido: $${linea.montoRecibido}`,
          );
        }
        cambioDevuelto = roundMoney(linea.montoRecibido - linea.montoCobrar);
      }

      lineas.push({
        idMedioPago: linea.idMedioPago,
        montoCobrar: roundMoney(linea.montoCobrar),
        montoRecibido: linea.montoRecibido,
        cambioDevuelto,
        referenciaPago: linea.referenciaPago,
        observaciones: linea.observaciones,
        medioPagoNombre: medioPago.nombre,
      });
    }

    const pagosGuardados = await this.dataSource.transaction(async (manager) => {
      const turno = await manager.findOne(CajaTurno, {
        where: { idHotel: factura.idHotel, estado: 'ABIERTA' },
        lock: { mode: 'pessimistic_write' },
      });

      if (!turno) {
        throw new BadRequestException('Debe abrir caja antes de registrar pagos');
      }

      const pagos: Pago[] = [];
      for (const linea of lineas) {
        const pagoBd = await manager.save(Pago, {
          idFactura: dto.idFactura,
          idMedioPago: linea.idMedioPago,
          monto: linea.montoCobrar,
          montoRecibido: linea.montoRecibido ?? null,
          cambioDevuelto: linea.cambioDevuelto,
          referenciaPago: linea.referenciaPago || null,
          idEmpleadoRegistro: idEmpleado || null,
          estado: 'completado',
          observaciones: linea.observaciones || dto.observaciones || null,
        } as any);

        const movimiento = manager.create(CajaMovimiento, {
          idTurno: turno.id,
          idHotel: factura.idHotel,
          idUsuario: idEmpleado || 0,
          tipo: 'INGRESO',
          origen: 'FACTURA',
          monto: linea.montoCobrar,
          idMedioPago: linea.idMedioPago,
          metodoPago: linea.medioPagoNombre,
          concepto: `Pago mixto factura ${factura.numeroFactura}`,
          referencia: linea.referenciaPago || `PAGO-${pagoBd.id}`,
          idFactura: dto.idFactura,
          observaciones: linea.observaciones || dto.observaciones || null,
        });
        await manager.save(CajaMovimiento, movimiento);
        pagos.push(pagoBd as Pago);
      }

      const totalLineas = roundMoney(lineas.reduce((sum, p) => sum + p.montoCobrar, 0));
      turno.totalIngresos = roundMoney(Number(turno.totalIngresos || 0) + totalLineas);
      turno.totalEsperado = roundMoney(
        Number(turno.montoInicial || 0) + Number(turno.totalIngresos || 0) - Number(turno.totalEgresos || 0),
      );
      await manager.save(CajaTurno, turno);

      const estadoAnterior = factura.estadoFactura || 'EMITIDA';
      if (totalNuevo >= totalFactura) {
        factura.estado = 'pagada';
        factura.estadoFactura = 'PAGADA';
      } else if (totalNuevo > 0) {
        factura.estado = 'parcialmente_pagada';
        factura.estadoFactura = 'EMITIDA';
      }
      await manager.save(factura);

      try {
        const FacturaCambiosRepo = manager.getRepository('FacturaCambio');
        await FacturaCambiosRepo.save({
          idFactura: dto.idFactura,
          usuarioId: idEmpleado || null,
          tipoCambio: 'PAGO_MIXTO',
          descripcion: `Pago mixto aplicado. Lineas: ${lineas.length}. Total aplicado: $${totalLineas}. Total pagado: $${totalNuevo}`,
          valorAnterior: JSON.stringify({ estadoFactura: estadoAnterior }),
          valorNuevo: JSON.stringify({ estadoFactura: factura.estadoFactura, lineas: lineas.length, monto: totalLineas }),
        });
      } catch (error) {
        console.warn('Error registrando cambio en auditoria:', (error as Error).message);
      }

      return manager.find(Pago, {
        where: { idFactura: dto.idFactura, estado: 'completado' },
        relations: ['medioPago', 'factura'],
        order: { fechaPago: 'DESC' },
      });
    });

    return pagosGuardados;
  }
  /**
   * Obtener todos los pagos de una factura
   */
  async findByFactura(
    idFactura: number,
    scope?: { rol?: string; idHotel?: number; idCliente?: number },
  ): Promise<Pago[]> {
    const query = this.pagoRepository
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.medioPago', 'medioPago')
      .leftJoinAndSelect('p.factura', 'factura')
      .where('p.idFactura = :idFactura', { idFactura })
      .orderBy('p.fechaPago', 'DESC');

    if (scope?.rol === 'cliente') {
      query.andWhere('factura.idCliente = :idCliente', { idCliente: scope.idCliente });
    }

    if (['admin', 'recepcionista', 'cajero'].includes(scope?.rol || '')) {
      if (!scope?.idHotel) {
        throw new BadRequestException('Usuario debe estar asignado a un hotel');
      }
      query.andWhere('factura.idHotel = :idHotel', { idHotel: scope.idHotel });
    }

    return query.getMany();
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
   * FASE 5: Validar que no se haya devuelto previamente (solo una devolución por pago)
   */
  async devolverPago(
    id: number,
    dto: DevolverPagoDto,
    idUsuario?: number,
    scope?: { rol?: string; idHotel?: number },
  ): Promise<Pago> {
    if (dto.idPago && dto.idPago !== id) {
      throw new BadRequestException('El ID de pago de la ruta no coincide con el cuerpo de la solicitud');
    }

    const pagoDevuelto = await this.dataSource.transaction(async (manager) => {
      const pago = await manager.findOne(Pago, {
        where: { id },
        relations: ['factura', 'medioPago'],
        lock: { mode: 'pessimistic_write' },
      });

      if (!pago) {
        throw new NotFoundException(`Pago con ID ${id} no encontrado`);
      }

      if (pago.estado === 'devuelto') {
        throw new BadRequestException(
          `El pago #${id} ya fue devuelto previamente en ${pago.fechaPago?.toLocaleDateString()}. ` +
          `No se puede devolver multiples veces. Motivo anterior: ${pago.observaciones}`,
        );
      }

      if (!pago.factura) {
        throw new BadRequestException('El pago no tiene factura asociada');
      }

      if (scope?.rol === 'admin' && !scope.idHotel) {
        throw new BadRequestException('Usuario debe estar asignado a un hotel');
      }

      if (scope?.rol === 'admin' && pago.factura.idHotel !== scope.idHotel) {
        throw new ForbiddenException('No tiene autorizacion para devolver pagos de otro hotel');
      }

      const montoPago = roundMoney(Number(pago.monto || 0));
      const montoDevolver = roundMoney(Number(dto.montoDevolver || 0));

      if (montoDevolver <= 0) {
        throw new BadRequestException('El monto a devolver debe ser mayor a cero');
      }

      if (montoDevolver !== montoPago) {
        throw new BadRequestException(
          'Por ahora la devolucion debe ser por el valor total del pago. Para devoluciones parciales, registre pagos separados.',
        );
      }

      const turno = await manager.findOne(CajaTurno, {
        where: { idHotel: pago.factura.idHotel, estado: 'ABIERTA' },
        lock: { mode: 'pessimistic_write' },
      });

      if (!turno) {
        throw new BadRequestException('Debe abrir caja antes de devolver pagos');
      }

      pago.estado = 'devuelto';
      pago.observaciones = [
        `DEVUELTO: ${dto.motivo}`,
        dto.referenciaDevolucion ? `Referencia: ${dto.referenciaDevolucion}` : null,
        dto.autorizadoPor ? `Autorizado por: ${dto.autorizadoPor}` : null,
        dto.observaciones ? `Observaciones: ${dto.observaciones}` : null,
      ].filter(Boolean).join(' | ');
      const pagoActualizado = await manager.save(Pago, pago);

      const movimiento = manager.create(CajaMovimiento, {
        idTurno: turno.id,
        idHotel: pago.factura.idHotel,
        idUsuario: idUsuario || 0,
        tipo: 'EGRESO',
        origen: 'DEVOLUCION',
        monto: montoDevolver,
        idMedioPago: pago.idMedioPago,
        metodoPago: pago.medioPago?.nombre || null,
        concepto: `Devolucion pago factura ${pago.factura.numeroFactura}`,
        referencia: dto.referenciaDevolucion || `DEV-PAGO-${pago.id}`,
        idFactura: pago.idFactura,
        observaciones: pago.observaciones,
      });
      await manager.save(CajaMovimiento, movimiento);

      turno.totalEgresos = roundMoney(Number(turno.totalEgresos || 0) + montoDevolver);
      turno.totalEsperado = roundMoney(
        Number(turno.montoInicial || 0) + Number(turno.totalIngresos || 0) - Number(turno.totalEgresos || 0),
      );
      await manager.save(CajaTurno, turno);

      const pagosCompletados = await manager.find(Pago, {
        where: { idFactura: pago.idFactura, estado: 'completado' },
      });

      const totalPagado = roundMoney(
        pagosCompletados.reduce((sum, p) => sum + Number(p.monto || 0), 0),
      );
      const totalFactura = roundMoney(Number(pago.factura.total || 0));
      const estadoAnterior = pago.factura.estadoFactura || 'EMITIDA';

      if (totalPagado >= totalFactura) {
        pago.factura.estado = 'pagada';
        pago.factura.estadoFactura = 'PAGADA';
      } else if (totalPagado > 0) {
        pago.factura.estado = 'parcialmente_pagada';
        pago.factura.estadoFactura = 'EMITIDA';
      } else {
        pago.factura.estado = 'emitida';
        pago.factura.estadoFactura = 'EMITIDA';
      }

      await manager.save(pago.factura);

      try {
        const FacturaCambiosRepo = manager.getRepository('FacturaCambio');
        await FacturaCambiosRepo.save({
          idFactura: pago.idFactura,
          usuarioId: idUsuario || null,
          tipoCambio: 'DEVOLUCION_PAGO',
          descripcion: `Pago devuelto. Monto: ${montoDevolver}. Total pagado vigente: ${totalPagado}`,
          valorAnterior: JSON.stringify({ estadoFactura: estadoAnterior, pagoEstado: 'completado' }),
          valorNuevo: JSON.stringify({ estadoFactura: pago.factura.estadoFactura, pagoEstado: 'devuelto' }),
        });
      } catch (error) {
        console.warn('Error registrando cambio en auditoria:', (error as Error).message);
      }

      return manager.findOne(Pago, {
        where: { id: pagoActualizado.id },
        relations: ['medioPago', 'factura'],
      });
    });

    if (!pagoDevuelto) {
      throw new BadRequestException('Error al procesar la devolucion');
    }

    return pagoDevuelto;
  }
}
