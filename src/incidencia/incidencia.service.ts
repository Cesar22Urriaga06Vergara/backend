import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RoomIncident } from './entities/room-incident.entity';
import { CreateRoomIncidentDto } from './dto/create-room-incident.dto';
import { UpdateRoomIncidentDto } from './dto/update-room-incident.dto';

@Injectable()
export class RoomIncidentService {
  constructor(
    @InjectRepository(RoomIncident)
    private roomIncidentRepository: Repository<RoomIncident>,
  ) {}

  /**
   * Reportar una nueva incidencia en una habitación
   */
  async crearIncidencia(
    dto: CreateRoomIncidentDto,
    idEmpleado: number,
    nombreEmpleado: string,
  ): Promise<RoomIncident> {
    const incidencia = this.roomIncidentRepository.create({
      ...dto,
      prioridad: dto.prioridad || 'media',
      estado: 'reported',
      idEmpleadoReporta: idEmpleado,
      nombreEmpleadoReporta: nombreEmpleado,
      tipoReportador: dto.idCliente ? 'cliente' : 'empleado',
      esResponsabilidadCliente: dto.esResponsabilidadCliente || false,
      fechaReporte: new Date(),
    });

    return await this.roomIncidentRepository.save(incidencia);
  }

  /**
   * Obtener incidencias de una reserva
   */
  async obtenerPorReserva(idReserva: number): Promise<RoomIncident[]> {
    return await this.roomIncidentRepository.find({
      where: { idReserva },
      relations: ['reserva', 'habitacion'],
      order: { fechaReporte: 'DESC' },
    });
  }

  /**
   * Obtener incidencias de una habitación
   */
  async obtenerPorHabitacion(idHabitacion: number): Promise<RoomIncident[]> {
    return await this.roomIncidentRepository.find({
      where: { idHabitacion },
      relations: ['reserva', 'habitacion'],
      order: { fechaReporte: 'DESC' },
    });
  }

  /**
   * Obtener incidencias de un área específica
   */
  async obtenerPorArea(areaAsignada: string): Promise<RoomIncident[]> {
    return await this.roomIncidentRepository.find({
      where: { areaAsignada },
      relations: ['reserva', 'habitacion'],
      order: { prioridad: 'DESC', fechaReporte: 'DESC' },
    });
  }

  /**
   * Obtener incidencias activas (pendientes o en progreso)
   */
  async obtenerActivas(): Promise<RoomIncident[]> {
    return await this.roomIncidentRepository.find({
      where: [
        { estado: 'reported' },
        { estado: 'in_progress' },
      ],
      relations: ['reserva', 'habitacion'],
      order: { prioridad: 'DESC', fechaReporte: 'DESC' },
    });
  }

  /**
   * Obtener incidencias por área de un hotel
   */
  async obtenerPorAreaYHotel(
    areaAsignada: string,
    filtros?: { estado?: string; prioridad?: string },
  ): Promise<RoomIncident[]> {
    let query = this.roomIncidentRepository
      .createQueryBuilder('ri')
      .where('ri.areaAsignada = :areaAsignada', { areaAsignada });

    if (filtros?.estado) {
      query = query.andWhere('ri.estado = :estado', { estado: filtros.estado });
    }

    if (filtros?.prioridad) {
      query = query.andWhere('ri.prioridad = :prioridad', { prioridad: filtros.prioridad });
    }

    return query
      .leftJoinAndSelect('ri.reserva', 'reserva')
      .leftJoinAndSelect('ri.habitacion', 'habitacion')
      .orderBy('ri.prioridad', 'DESC')
      .addOrderBy('ri.fechaReporte', 'DESC')
      .getMany();
  }

  /**
   * Obtener incidencia por ID
   */
  async obtenerPorId(id: number): Promise<RoomIncident> {
    const incidencia = await this.roomIncidentRepository.findOne({
      where: { id },
      relations: ['reserva', 'habitacion'],
    });

    if (!incidencia) {
      throw new NotFoundException(`Incidencia con ID ${id} no encontrada`);
    }

    return incidencia;
  }

  /**
   * Actualizar incidencia (cambiar estado, asignar empleado, resolver, etc.)
   */
  async actualizar(
    id: number,
    dto: UpdateRoomIncidentDto,
  ): Promise<RoomIncident> {
    const incidencia = await this.obtenerPorId(id);

    // Si se resuelve, guardar fecha de resolución
    if (dto.estado === 'resolved' && incidencia.estado !== 'resolved') {
      incidencia.fechaResolucion = new Date();
    }

    // Actualizar campos
    Object.assign(incidencia, dto);

    return await this.roomIncidentRepository.save(incidencia);
  }

  /**
   * Cancelar una incidencia
   */
  async cancelar(id: number, razon?: string): Promise<RoomIncident> {
    const incidencia = await this.obtenerPorId(id);

    if (incidencia.estado === 'resolved') {
      throw new BadRequestException('No se puede cancelar una incidencia resuelta');
    }

    incidencia.estado = 'cancelled';
    if (razon) {
      incidencia.notaResolucion = `Cancelada: ${razon}`;
    }

    return await this.roomIncidentRepository.save(incidencia);
  }

  /**
   * Obtener incidencias con cargo adicional (daños responsabilidad del cliente)
   */
  async obtenerConCargo(): Promise<RoomIncident[]> {
    return await this.roomIncidentRepository
      .createQueryBuilder('ri')
      .where('ri.esResponsabilidadCliente = :esResponsabilidad', { esResponsabilidad: true })
      .andWhere('ri.cargoAdicional IS NOT NULL')
      .leftJoinAndSelect('ri.reserva', 'reserva')
      .leftJoinAndSelect('ri.habitacion', 'habitacion')
      .orderBy('ri.fechaReporte', 'DESC')
      .getMany();
  }

  /**
   * Obtener todas las incidencias (con filtros opcionales)
   */
  async obtenerTodas(filtros?: {
    estado?: string;
    tipo?: string;
    prioridad?: string;
    areaAsignada?: string;
    esResponsabilidadCliente?: boolean;
  }): Promise<RoomIncident[]> {
    let query = this.roomIncidentRepository
      .createQueryBuilder('ri')
      .leftJoinAndSelect('ri.reserva', 'reserva')
      .leftJoinAndSelect('ri.habitacion', 'habitacion');

    if (filtros?.estado) {
      query = query.where('ri.estado = :estado', { estado: filtros.estado });
    }

    if (filtros?.tipo) {
      if (filtros?.estado) {
        query = query.andWhere('ri.tipo = :tipo', { tipo: filtros.tipo });
      } else {
        query = query.where('ri.tipo = :tipo', { tipo: filtros.tipo });
      }
    }

    if (filtros?.prioridad) {
      const condition = filtros?.estado || filtros?.tipo ? 'andWhere' : 'where';
      query = query[condition]('ri.prioridad = :prioridad', { prioridad: filtros.prioridad });
    }

    if (filtros?.areaAsignada) {
      const condition = filtros?.estado || filtros?.tipo || filtros?.prioridad ? 'andWhere' : 'where';
      query = query[condition]('ri.areaAsignada = :areaAsignada', { areaAsignada: filtros.areaAsignada });
    }

    if (filtros?.esResponsabilidadCliente !== undefined) {
      const condition = filtros?.estado || filtros?.tipo || filtros?.prioridad || filtros?.areaAsignada ? 'andWhere' : 'where';
      query = query[condition]('ri.esResponsabilidadCliente = :esResponsabilidad', { esResponsabilidad: filtros.esResponsabilidadCliente });
    }

    return query
      .orderBy('ri.prioridad', 'DESC')
      .addOrderBy('ri.fechaReporte', 'DESC')
      .getMany();
  }

  /**
   * Obtener estadísticas de incidencias
   */
  async obtenerEstadisticas(desde?: Date, hasta?: Date) {
    let query = this.roomIncidentRepository.createQueryBuilder('ri');

    if (desde) {
      query = query.where('ri.fechaReporte >= :desde', { desde });
    }

    if (hasta) {
      query = query.andWhere('ri.fechaReporte <= :hasta', { hasta });
    }

    const todasIncidencias = await query.getMany();

    // Estadísticas generales
    const totalIncidencias = todasIncidencias.length;
    const incidenciasResueltas = todasIncidencias.filter(i => i.estado === 'resolved').length;
    const incidenciasActivas = todasIncidencias.filter(i => ['reported', 'in_progress'].includes(i.estado)).length;
    
    // Por estado
    const incidenciasPorEstado = {
      reported: todasIncidencias.filter(i => i.estado === 'reported').length,
      in_progress: todasIncidencias.filter(i => i.estado === 'in_progress').length,
      resolved: incidenciasResueltas,
      cancelled: todasIncidencias.filter(i => i.estado === 'cancelled').length,
    };

    // Por área
    const incidenciasPorArea = {};
    todasIncidencias.forEach(inc => {
      if (!incidenciasPorArea[inc.areaAsignada]) {
        incidenciasPorArea[inc.areaAsignada] = {
          total: 0,
          resueltas: 0,
          activas: 0,
          cargoTotal: 0,
        };
      }
      incidenciasPorArea[inc.areaAsignada].total++;
      if (inc.estado === 'resolved') {
        incidenciasPorArea[inc.areaAsignada].resueltas++;
      }
      if (['reported', 'in_progress'].includes(inc.estado)) {
        incidenciasPorArea[inc.areaAsignada].activas++;
      }
      if (inc.cargoAdicional) {
        incidenciasPorArea[inc.areaAsignada].cargoTotal += Number(inc.cargoAdicional);
      }
    });

    // Por tipo
    const incidenciasPorTipo = {};
    todasIncidencias.forEach(inc => {
      if (!incidenciasPorTipo[inc.tipo]) {
        incidenciasPorTipo[inc.tipo] = { total: 0, resueltas: 0 };
      }
      incidenciasPorTipo[inc.tipo].total++;
      if (inc.estado === 'resolved') {
        incidenciasPorTipo[inc.tipo].resueltas++;
      }
    });

    // Tiempo promedio de resolución
    const incidenciasResueltas_lista = todasIncidencias.filter(i => i.estado === 'resolved');
    let tiempoPromedioResolucion = 0;
    if (incidenciasResueltas_lista.length > 0) {
      const tiemposResolucion = incidenciasResueltas_lista
        .filter(inc => inc.fechaResolucion && inc.fechaReporte)
        .map(inc => {
          const tiempoMs = inc.fechaResolucion!.getTime() - inc.fechaReporte.getTime();
          return tiempoMs / (1000 * 60 * 60); // Convertir a horas
        });
      if (tiemposResolucion.length > 0) {
        tiempoPromedioResolucion = tiemposResolucion.reduce((a, b) => a + b, 0) / tiemposResolucion.length;
      }
    }

    // Cargos a clientes
    const cargoTotal = todasIncidencias
      .filter(i => i.cargoAdicional)
      .reduce((sum, i) => sum + Number(i.cargoAdicional), 0);

    return {
      kpis: {
        totalIncidencias,
        incidenciasActivas,
        incidenciasResueltas,
        tiempoPromedioResolucion: Math.round(tiempoPromedioResolucion * 10) / 10,
        cargoTotal,
      },
      incidenciasPorEstado,
      incidenciasPorArea,
      incidenciasPorTipo,
    };
  }
}
