import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from '../entities/audit-log.entity';

export interface AuditLogData {
  entidad: string;
  idEntidad: number;
  operacion: 'CREATE' | 'UPDATE' | 'DELETE' | 'RESTORE';
  usuarioId?: number;
  usuarioEmail?: string;
  usuarioRol?: string;
  cambios?: Record<string, any>;
  descripcion?: string;
  ipAddress?: string;
  userAgent?: string;
  accion?: string;
}

@Injectable()
export class AuditLogService {
  constructor(
    @InjectRepository(AuditLog)
    private auditLogRepository: Repository<AuditLog>,
  ) {}

  /**
   * Registrar un cambio en la auditoría
   */
  async registrar(data: AuditLogData): Promise<AuditLog> {
    const auditLog = new AuditLog();
    auditLog.entidad = data.entidad;
    auditLog.idEntidad = data.idEntidad;
    auditLog.operacion = data.operacion;
    auditLog.usuarioId = data.usuarioId;
    auditLog.usuarioEmail = data.usuarioEmail;
    auditLog.usuarioRol = data.usuarioRol;
    auditLog.cambios = data.cambios ? JSON.stringify(data.cambios) : undefined;
    auditLog.descripcion = data.descripcion;
    auditLog.ipAddress = data.ipAddress;
    auditLog.userAgent = data.userAgent;
    auditLog.accion = data.accion;

    return await this.auditLogRepository.save(auditLog);
  }

  /**
   * Obtener auditoría de una entidad
   */
  async obtenerPorEntidad(entidad: string, idEntidad: number): Promise<AuditLog[]> {
    return await this.auditLogRepository.find({
      where: {
        entidad,
        idEntidad,
      },
      order: { fecha: 'DESC' },
    });
  }

  /**
   * Obtener cambios por usuario
   */
  async obtenerPorUsuario(usuarioId: number, dias?: number): Promise<AuditLog[]> {
    let query = this.auditLogRepository.createQueryBuilder('al');

    query = query.where('al.usuarioId = :usuarioId', { usuarioId });

    if (dias) {
      const fechaDesde = new Date();
      fechaDesde.setDate(fechaDesde.getDate() - dias);
      query = query.andWhere('al.fecha >= :fechaDesde', { fechaDesde });
    }

    return await query.orderBy('al.fecha', 'DESC').getMany();
  }

  /**
   * Obtener auditoría por operación (CREATE, UPDATE, DELETE, RESTORE)
   */
  async obtenerPorOperacion(operacion: 'CREATE' | 'UPDATE' | 'DELETE' | 'RESTORE'): Promise<AuditLog[]> {
    return await this.auditLogRepository.find({
      where: { operacion },
      order: { fecha: 'DESC' },
      take: 100,
    });
  }

  /**
   * Obtener auditoría de un período
   */
  async obtenerPorPeriodo(fechaDesde: Date, fechaHasta: Date): Promise<AuditLog[]> {
    return await this.auditLogRepository
      .createQueryBuilder('al')
      .where('al.fecha BETWEEN :fechaDesde AND :fechaHasta', {
        fechaDesde,
        fechaHasta,
      })
      .orderBy('al.fecha', 'DESC')
      .getMany();
  }

  /**
   * Obtener todos los logs (solo para SuperAdmin)
   */
  async obtenerTodos(filtros?: {
    entidad?: string;
    operacion?: string;
    usuarioId?: number;
    fechaDesde?: Date;
    fechaHasta?: Date;
  }): Promise<AuditLog[]> {
    let query = this.auditLogRepository.createQueryBuilder('al');

    if (filtros?.entidad) {
      query = query.where('al.entidad = :entidad', { entidad: filtros.entidad });
    }

    if (filtros?.operacion) {
      if (filtros?.entidad) {
        query = query.andWhere('al.operacion = :operacion', { operacion: filtros.operacion });
      } else {
        query = query.where('al.operacion = :operacion', { operacion: filtros.operacion });
      }
    }

    if (filtros?.usuarioId) {
      if (filtros?.entidad || filtros?.operacion) {
        query = query.andWhere('al.usuarioId = :usuarioId', { usuarioId: filtros.usuarioId });
      } else {
        query = query.where('al.usuarioId = :usuarioId', { usuarioId: filtros.usuarioId });
      }
    }

    if (filtros?.fechaDesde) {
      if (filtros?.entidad || filtros?.operacion || filtros?.usuarioId) {
        query = query.andWhere('al.fecha >= :fechaDesde', { fechaDesde: filtros.fechaDesde });
      } else {
        query = query.where('al.fecha >= :fechaDesde', { fechaDesde: filtros.fechaDesde });
      }
    }

    if (filtros?.fechaHasta) {
      query = query.andWhere('al.fecha <= :fechaHasta', { fechaHasta: filtros.fechaHasta });
    }

    return await query.orderBy('al.fecha', 'DESC').getMany();
  }

  /**
   * Calcular diferencias entre dos objetos (para comparar antes/después)
   */
  static calcularDiferencias(antes: any, despues: any): Record<string, any> {
    const cambios: Record<string, any> = {};
    const todasLasClaves = new Set([
      ...Object.keys(antes || {}),
      ...Object.keys(despues || {}),
    ]);

    todasLasClaves.forEach((clave) => {
      const valAnte = antes?.[clave];
      const valDespu = despues?.[clave];

      // Ignorar campos técnicos
      if (['createdAt', 'updatedAt', 'id'].includes(clave)) {
        return;
      }

      if (valAnte !== valDespu) {
        cambios[clave] = {
          antes: valAnte,
          despues: valDespu,
        };
      }
    });

    return cambios;
  }
}
