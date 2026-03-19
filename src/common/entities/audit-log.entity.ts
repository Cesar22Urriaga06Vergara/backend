import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('audit_logs')
@Index(['entidad', 'idEntidad', 'fecha'])
@Index(['usuarioId', 'fecha'])
@Index(['operacion'])
@Index(['fecha'])
export class AuditLog {
  @PrimaryGeneratedColumn()
  id: number;

  // Nombre de la entidad (ej: 'Reserva', 'Cliente', 'Empleado', 'Factura')
  @Column({ type: 'varchar', length: 100 })
  entidad: string;

  // ID del registro afectado en esa entidad
  @Column({ name: 'id_entidad', type: 'int' })
  idEntidad: number;

  // Operación realizada: 'CREATE' | 'UPDATE' | 'DELETE' | 'RESTORE'
  @Column({
    type: 'enum',
    enum: ['CREATE', 'UPDATE', 'DELETE', 'RESTORE'],
  })
  operacion: string;

  // ID del usuario que realizó la operación
  @Column({ name: 'usuario_id', nullable: true })
  usuarioId?: number;

  // Email o nombre del usuario (snapshot para auditoría histórica)
  @Column({ name: 'usuario_email', nullable: true })
  usuarioEmail?: string;

  // Rol del usuario en el momento de la operación
  @Column({ name: 'usuario_rol', nullable: true })
  usuarioRol?: string;

  // Cambios realizados (JSON con antes/después)
  // Formato: { campo: { antes: valor_anterior, despues: valor_nuevo } }
  // Para DELETE: el registro completo
  @Column({ name: 'cambios', type: 'longtext', nullable: true })
  cambios?: string;

  // Descripción legible (ej: "Cambio estado de 'reservada' a 'confirmada'")
  @Column({ type: 'text', nullable: true })
  descripcion?: string;

  // Dirección IP del cliente (si aplica)
  @Column({ name: 'ip_address', nullable: true })
  ipAddress?: string;

  // User Agent (navegador/app)
  @Column({ name: 'user_agent', nullable: true, type: 'varchar', length: 500 })
  userAgent?: string;

  // Endpoint o acción que disparó el cambio
  @Column({ name: 'accion', nullable: true, type: 'varchar', length: 255 })
  accion?: string;

  @CreateDateColumn({ name: 'fecha' })
  fecha: Date;
}
