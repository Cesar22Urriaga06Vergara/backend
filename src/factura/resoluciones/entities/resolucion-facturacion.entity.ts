import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Hotel } from '../../../hotel/entities/hotel.entity';
import { Factura } from '../../entities/factura.entity';

export type ResolucionFacturacionEstado = 'activa' | 'inactiva' | 'vencida' | 'agotada';
export type ResolucionFacturacionAmbiente = 'desarrollo' | 'produccion';

@Entity('resoluciones_facturacion')
@Index(['idHotel', 'estado'])
@Index(['idHotel', 'prefijo'])
export class ResolucionFacturacion {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_hotel', type: 'int' })
  idHotel: number;

  @ManyToOne(() => Hotel)
  @JoinColumn({ name: 'id_hotel' })
  hotel: Hotel;

  @Column({ name: 'numero_resolucion', type: 'varchar', length: 80 })
  numeroResolucion: string;

  @Column({ type: 'varchar', length: 20 })
  prefijo: string;

  @Column({ name: 'fecha_resolucion', type: 'date', nullable: true })
  fechaResolucion?: Date | null;

  @Column({ name: 'fecha_inicio', type: 'date' })
  fechaInicio: Date;

  @Column({ name: 'fecha_fin', type: 'date' })
  fechaFin: Date;

  @Column({ name: 'rango_desde', type: 'int' })
  rangoDesde: number;

  @Column({ name: 'rango_hasta', type: 'int' })
  rangoHasta: number;

  @Column({ name: 'numero_actual', type: 'int', default: 0 })
  numeroActual: number;

  @Column({ name: 'tipo_documento', type: 'varchar', length: 40, default: 'factura_venta' })
  tipoDocumento: string;

  @Column({ type: 'enum', enum: ['desarrollo', 'produccion'], default: 'desarrollo' })
  ambiente: ResolucionFacturacionAmbiente;

  @Column({ type: 'enum', enum: ['activa', 'inactiva', 'vencida', 'agotada'], default: 'activa' })
  estado: ResolucionFacturacionEstado;

  @Column({ type: 'text', nullable: true })
  observaciones?: string | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @OneToMany(() => Factura, (factura) => factura.resolucionFacturacion)
  facturas: Factura[];
}