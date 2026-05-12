import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { CajaMovimiento } from './caja-movimiento.entity';

export type CajaTurnoEstado = 'ABIERTA' | 'CERRADA';

@Entity('caja_turnos')
@Index(['idHotel', 'estado'])
export class CajaTurno {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_hotel', type: 'int' })
  idHotel: number;

  @Column({ name: 'id_usuario_apertura', type: 'int' })
  idUsuarioApertura: number;

  @Column({ name: 'id_usuario_cierre', type: 'int', nullable: true })
  idUsuarioCierre?: number | null;

  @Column({ type: 'enum', enum: ['ABIERTA', 'CERRADA'], default: 'ABIERTA' })
  estado: CajaTurnoEstado;

  @Column({ name: 'monto_inicial', type: 'decimal', precision: 12, scale: 2, default: 0 })
  montoInicial: number;

  @Column({ name: 'total_ingresos', type: 'decimal', precision: 12, scale: 2, default: 0 })
  totalIngresos: number;

  @Column({ name: 'total_egresos', type: 'decimal', precision: 12, scale: 2, default: 0 })
  totalEgresos: number;

  @Column({ name: 'total_esperado', type: 'decimal', precision: 12, scale: 2, default: 0 })
  totalEsperado: number;

  @Column({ name: 'monto_contado', type: 'decimal', precision: 12, scale: 2, nullable: true })
  montoContado?: number | null;

  @Column({ type: 'decimal', precision: 12, scale: 2, nullable: true })
  diferencia?: number | null;

  @Column({ name: 'observaciones_apertura', type: 'text', nullable: true })
  observacionesApertura?: string | null;

  @Column({ name: 'observaciones_cierre', type: 'text', nullable: true })
  observacionesCierre?: string | null;

  @CreateDateColumn({ name: 'fecha_apertura' })
  fechaApertura: Date;

  @Column({ name: 'fecha_cierre', type: 'datetime', nullable: true })
  fechaCierre?: Date | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @OneToMany(() => CajaMovimiento, (movimiento) => movimiento.turno)
  movimientos: CajaMovimiento[];
}