import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('clientes')
export class Cliente {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_usuario', nullable: false })
  idUsuario: number;

  @Column({ nullable: true })
  tipoDocumento: string;

  @Column({ unique: true, nullable: false })
  cedula: string;

  @Column({ nullable: false })
  nombre: string;

  @Column({ nullable: false })
  apellido: string;

  @Column({ nullable: true })
  telefono: string;

  @Column({ nullable: true })
  email: string;

  @Column({ nullable: true })
  direccion: string;

  @Column({ nullable: true })
  paisNacionalidad: string;

  @Column({ nullable: true })
  paisResidencia: string;

  @Column({ nullable: true })
  idiomaPreferido: string;

  @Column({ nullable: true })
  fechaNacimiento: Date;

  @Column({ nullable: true })
  tipoVisa: string;

  @Column({ nullable: true })
  numeroVisa: string;

  @Column({ nullable: true })
  visaExpira: Date;

  @CreateDateColumn({ name: 'fecha_registro' })
  fechaRegistro: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
