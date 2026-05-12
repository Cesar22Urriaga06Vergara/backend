import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('hoteles')
export class Hotel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 100, nullable: false })
  nombre: string;

  @Column({ type: 'varchar', length: 20, nullable: false, unique: true })
  nit: string;

  @Column({ name: 'razon_social', type: 'varchar', length: 150, nullable: true })
  razonSocial?: string;

  @Column({ type: 'varchar', length: 200, nullable: true })
  direccion: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  ciudad: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  pais: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  telefono: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  email: string;

  @Column({ type: 'int', nullable: true })
  estrellas: number;

  @Column({ type: 'text', nullable: true })
  descripcion: string;

  @Column({ name: 'logo_url', type: 'varchar', length: 500, nullable: true })
  logoUrl?: string;

  @Column({ name: 'resolucion_facturacion', type: 'varchar', length: 255, nullable: true })
  resolucionFacturacion?: string;

  @Column({ name: 'prefijo_facturacion', type: 'varchar', length: 20, nullable: true })
  prefijoFacturacion?: string;

  @Column({ name: 'pie_factura', type: 'text', nullable: true })
  pieFactura?: string;

  @Column({ type: 'varchar', length: 3, default: 'COP' })
  moneda: string;

  @Column({ name: 'pos_formato_default', type: 'varchar', length: 4, default: '80mm' })
  posFormatoDefault: '58mm' | '80mm';

  @Column({ type: 'enum', enum: ['activo', 'suspendido'], default: 'activo' })
  estado: 'activo' | 'suspendido';

  @CreateDateColumn({ name: 'fecha_registro' })
  fechaRegistro: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
