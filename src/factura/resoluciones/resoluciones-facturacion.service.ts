import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { ResolucionFacturacion } from './entities/resolucion-facturacion.entity';
import { CreateResolucionFacturacionDto, UpdateResolucionFacturacionDto } from './dto/resolucion-facturacion.dto';

@Injectable()
export class ResolucionesFacturacionService {
  constructor(
    @InjectRepository(ResolucionFacturacion)
    private readonly resolucionRepository: Repository<ResolucionFacturacion>,
  ) {}

  async listar(idHotel: number) {
    return this.resolucionRepository.find({
      where: { idHotel },
      order: { estado: 'ASC', createdAt: 'DESC' },
    });
  }

  async obtenerActiva(idHotel: number) {
    return this.resolucionRepository.findOne({
      where: { idHotel, estado: 'activa' },
      order: { createdAt: 'DESC' },
    });
  }

  async crear(idHotel: number, dto: CreateResolucionFacturacionDto) {
    if (dto.rangoHasta < dto.rangoDesde) {
      throw new BadRequestException('El rango hasta no puede ser menor que el rango desde');
    }

    const fechaInicio = new Date(dto.fechaInicio);
    const fechaFin = new Date(dto.fechaFin);
    if (fechaFin < fechaInicio) {
      throw new BadRequestException('La fecha fin no puede ser anterior a la fecha inicio');
    }

    const activa = await this.obtenerActiva(idHotel);
    if (activa) {
      activa.estado = 'inactiva';
      await this.resolucionRepository.save(activa);
    }

    const numeroActual = dto.numeroActual ?? dto.rangoDesde - 1;
    if (numeroActual < dto.rangoDesde - 1 || numeroActual > dto.rangoHasta) {
      throw new BadRequestException('El numero actual debe estar dentro del rango autorizado');
    }

    const resolucion = this.resolucionRepository.create({
      idHotel,
      numeroResolucion: dto.numeroResolucion,
      prefijo: dto.prefijo.toUpperCase().trim(),
      fechaResolucion: dto.fechaResolucion ? new Date(dto.fechaResolucion) : null,
      fechaInicio,
      fechaFin,
      rangoDesde: dto.rangoDesde,
      rangoHasta: dto.rangoHasta,
      numeroActual,
      tipoDocumento: dto.tipoDocumento || 'factura_venta',
      ambiente: dto.ambiente || 'desarrollo',
      estado: 'activa',
      observaciones: dto.observaciones || null,
    });

    return this.resolucionRepository.save(resolucion);
  }

  async actualizar(idHotel: number, id: number, dto: UpdateResolucionFacturacionDto) {
    const resolucion = await this.resolucionRepository.findOne({ where: { id, idHotel } });
    if (!resolucion) {
      throw new NotFoundException('Resolucion de facturacion no encontrada');
    }

    if (dto.estado) {
      if (dto.estado === 'activa') {
        await this.resolucionRepository.update({ idHotel, estado: 'activa' }, { estado: 'inactiva' });
      }
      resolucion.estado = dto.estado;
    }

    if (dto.observaciones !== undefined) {
      resolucion.observaciones = dto.observaciones;
    }

    return this.resolucionRepository.save(resolucion);
  }

  async reservarConsecutivo(
    idHotel: number,
    manager: EntityManager,
  ): Promise<{ resolucion: ResolucionFacturacion; consecutivo: number; numeroFactura: string }> {
    const findOptions: any = {
      where: { idHotel, estado: 'activa' },
      order: { createdAt: 'DESC' },
    };

    if ((manager as any).queryRunner?.isTransactionActive) {
      findOptions.lock = { mode: 'pessimistic_write' };
    }

    const resolucion = await manager.findOne(ResolucionFacturacion, findOptions);

    if (!resolucion) {
      throw new BadRequestException('No hay resolucion de facturacion activa para este hotel');
    }

    const hoy = new Date();
    const fechaInicio = new Date(resolucion.fechaInicio);
    const fechaFin = new Date(resolucion.fechaFin);
    fechaInicio.setHours(0, 0, 0, 0);
    fechaFin.setHours(23, 59, 59, 999);

    if (hoy < fechaInicio || hoy > fechaFin) {
      resolucion.estado = 'vencida';
      await manager.save(ResolucionFacturacion, resolucion);
      throw new BadRequestException('La resolucion de facturacion activa esta fuera de vigencia');
    }

    const siguiente = Number(resolucion.numeroActual || 0) + 1;
    if (siguiente < resolucion.rangoDesde || siguiente > resolucion.rangoHasta) {
      resolucion.estado = 'agotada';
      await manager.save(ResolucionFacturacion, resolucion);
      throw new BadRequestException('La resolucion de facturacion activa agoto su rango autorizado');
    }

    resolucion.numeroActual = siguiente;
    await manager.save(ResolucionFacturacion, resolucion);

    return {
      resolucion,
      consecutivo: siguiente,
      numeroFactura: `${resolucion.prefijo}-${String(siguiente).padStart(6, '0')}`,
    };
  }
}