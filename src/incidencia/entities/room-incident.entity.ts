import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Reserva } from '../../reserva/entities/reserva.entity';
import { Habitacion } from '../../habitacion/entities/habitacion.entity';

@Entity('room_incidents')
@Index(['idReserva'])
@Index(['idHabitacion'])
@Index(['idCliente'])
@Index(['estado'])
@Index(['tipo'])
@Index(['areaAsignada'])
export class RoomIncident {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_reserva', nullable: true })
  idReserva?: number;

  @ManyToOne(() => Reserva, { nullable: true })
  @JoinColumn({ name: 'id_reserva' })
  reserva?: Reserva;

  @Column({ name: 'id_habitacion' })
  idHabitacion: number;

  @ManyToOne(() => Habitacion)
  @JoinColumn({ name: 'id_habitacion' })
  habitacion: Habitacion;

  @Column({ name: 'id_cliente', nullable: true })
  idCliente?: number;

  // Tipo: 'daño' | 'mantenimiento' | 'limpieza' | 'cliente_complaint' | 'otros'
  @Column({
    type: 'enum',
    enum: ['daño', 'mantenimiento', 'limpieza', 'cliente_complaint', 'otros'],
    default: 'otros',
  })
  tipo: string;

  // Estado: 'reported' | 'in_progress' | 'resolved' | 'cancelled'
  @Column({
    type: 'enum',
    enum: ['reported', 'in_progress', 'resolved', 'cancelled'],
    default: 'reported',
  })
  estado: string;

  // Descripción detallada del incidente
  @Column({ type: 'text' })
  descripcion: string;

  // Recepcionista que reporta/crea la incidencia
  @Column({ name: 'id_empleado_reporta' })
  idEmpleadoReporta: number;

  @Column({ name: 'nombre_empleado_reporta', length: 100 })
  nombreEmpleadoReporta: string;

  // Tipo: 'cliente' | 'empleado'
  @Column({ name: 'tipo_reportador' })
  tipoReportador: string;

  // Área a la que se asigna: mantenimiento, plomería, limpieza, electricidad, seguridad, otro
  @Column({ name: 'area_asignada', length: 50 })
  areaAsignada: string;

  // ID del empleado del área que atiende
  @Column({ name: 'id_empleado_atiende', nullable: true })
  idEmpleadoAtiende?: number;

  @Column({ name: 'nombre_empleado_atiende', length: 100, nullable: true })
  nombreEmpleadoAtiende?: string;

  // Nota de resolución
  @Column({ name: 'nota_resolucion', type: 'text', nullable: true })
  notaResolucion?: string;

  // Prioridad: 'baja' | 'media' | 'alta' | 'urgente'
  @Column({
    type: 'enum',
    enum: ['baja', 'media', 'alta', 'urgente'],
    default: 'media',
  })
  prioridad: string;

  // ¿La incidencia es responsabilidad del cliente? (debe pagar)
  @Column({ name: 'es_responsabilidad_cliente', default: false })
  esResponsabilidadCliente: boolean;

  // Si genera cargo adicional en la factura (daños causados por cliente)
  @Column({ name: 'cargo_adicional', type: 'decimal', precision: 12, scale: 2, nullable: true })
  cargoAdicional?: number;

  // Descripción del cargo (ej: "Reparación espejo roto")
  @Column({ name: 'descripcion_cargo', nullable: true })
  descripcionCargo?: string;

  @CreateDateColumn({ name: 'fecha_reporte' })
  fechaReporte: Date;

  @Column({ name: 'fecha_resolucion', nullable: true })
  fechaResolucion?: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
