import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToMany,
} from 'typeorm';
import { TipoHabitacion } from '../../tipo-habitacion/entities/tipo-habitacion.entity';

@Entity('amenidades')
export class Amenidad {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  nombre: string;

  @Column({ nullable: true })
  icono: string;

  @Column({ nullable: true })
  categoria: string;

  @Column({ type: 'text', nullable: true })
  descripcion: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @ManyToMany(() => TipoHabitacion, (tipoHabitacion) => tipoHabitacion.amenidades)
  tiposHabitacion: TipoHabitacion[];
}
