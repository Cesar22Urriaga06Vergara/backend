import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { CajaTurno } from './caja-turno.entity';

export type CajaMovimientoTipo = 'INGRESO' | 'EGRESO';
export type CajaMovimientoOrigen = 'MANUAL' | 'FOLIO' | 'FACTURA' | 'DEVOLUCION' | 'AJUSTE';

@Entity('caja_movimientos')
@Index(['idHotel', 'fechaMovimiento'])
@Index(['idTurno', 'tipo'])
export class CajaMovimiento {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_turno', type: 'int' })
  idTurno: number;

  @ManyToOne(() => CajaTurno, (turno) => turno.movimientos)
  @JoinColumn({ name: 'id_turno' })
  turno: CajaTurno;

  @Column({ name: 'id_hotel', type: 'int' })
  idHotel: number;

  @Column({ name: 'id_usuario', type: 'int' })
  idUsuario: number;

  @Column({ type: 'enum', enum: ['INGRESO', 'EGRESO'] })
  tipo: CajaMovimientoTipo;

  @Column({ type: 'enum', enum: ['MANUAL', 'FOLIO', 'FACTURA', 'DEVOLUCION', 'AJUSTE'], default: 'MANUAL' })
  origen: CajaMovimientoOrigen;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  monto: number;

  @Column({ name: 'id_medio_pago', type: 'int', nullable: true })
  idMedioPago?: number | null;

  @Column({ name: 'metodo_pago', type: 'varchar', length: 60, nullable: true })
  metodoPago?: string | null;

  @Column({ length: 180 })
  concepto: string;

  @Column({ type: 'varchar', length: 120, nullable: true })
  referencia?: string | null;

  @Column({ name: 'id_folio', type: 'int', nullable: true })
  idFolio?: number | null;

  @Column({ name: 'id_factura', type: 'int', nullable: true })
  idFactura?: number | null;

  @Column({ type: 'text', nullable: true })
  observaciones?: string | null;

  @CreateDateColumn({ name: 'fecha_movimiento' })
  fechaMovimiento: Date;
}