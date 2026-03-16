import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Factura } from '../../factura/entities/factura.entity';
import { MedioPago } from '../../medio-pago/entities/medio-pago.entity';

@Entity('pagos')
export class Pago {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_factura' })
  idFactura: number;

  @ManyToOne(() => Factura, (f) => f.pagos)
  @JoinColumn({ name: 'id_factura' })
  factura: Factura;

  @Column({ name: 'id_medio_pago' })
  idMedioPago: number;

  @ManyToOne(() => MedioPago)
  @JoinColumn({ name: 'id_medio_pago' })
  medioPago: MedioPago;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  monto: number;

  // Número de aprobación, referencia bancaria, nro. transacción, etc.
  @Column({ name: 'referencia_pago', nullable: true })
  referenciaPago: string;

  // Empleado que registró el pago en el sistema
  @Column({ name: 'id_empleado_registro', nullable: true })
  idEmpleadoRegistro: number;

  // 'completado' | 'rechazado' | 'devuelto'
  @Column({ default: 'completado' })
  estado: string;

  @Column({ nullable: true, type: 'text' })
  observaciones: string;

  @CreateDateColumn({ name: 'fecha_pago' })
  fechaPago: Date;
}
