import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { TipoHabitacion } from '../../tipo-habitacion/entities/tipo-habitacion.entity';

@Entity('habitaciones')
export class Habitacion {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_hotel' })
  idHotel: number;

  @Column({ name: 'numero_habitacion' })
  numeroHabitacion: string;

  @Column({ nullable: true })
  piso: string;

  @Column({ nullable: true })
  estado: string;

  @Column({ name: 'id_tipo_habitacion' })
  idTipoHabitacion: number;

  @Column({ name: 'fecha_actualizacion', nullable: true })
  fechaActualizacion: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @ManyToOne(() => TipoHabitacion, (tipoHabitacion) => tipoHabitacion.habitaciones, { eager: true })
  @JoinColumn({ name: 'id_tipo_habitacion' })
  tipoHabitacion: TipoHabitacion;
}
