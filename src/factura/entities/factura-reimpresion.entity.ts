import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Factura } from './factura.entity';

export type FacturaReimpresionFormato = 'ticket_pos' | 'pdf_pos' | 'pdf_a4';

@Entity('factura_reimpresiones')
@Index(['idFactura', 'createdAt'])
export class FacturaReimpresion {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'id_factura', type: 'int' })
  idFactura: number;

  @ManyToOne(() => Factura)
  @JoinColumn({ name: 'id_factura' })
  factura: Factura;

  @Column({ name: 'id_usuario', type: 'int', nullable: true })
  idUsuario?: number | null;

  @Column({ name: 'usuario_rol', type: 'varchar', length: 40, nullable: true })
  usuarioRol?: string | null;

  @Column({ type: 'enum', enum: ['ticket_pos', 'pdf_pos', 'pdf_a4'], default: 'ticket_pos' })
  formato: FacturaReimpresionFormato;

  @Column({ name: 'tamano_pos', type: 'varchar', length: 4, nullable: true })
  tamanoPos?: '58mm' | '80mm' | null;

  @Column({ type: 'varchar', length: 200, nullable: true })
  motivo?: string | null;

  @Column({ name: 'ip_origen', type: 'varchar', length: 64, nullable: true })
  ipOrigen?: string | null;

  @Column({ name: 'user_agent', type: 'varchar', length: 500, nullable: true })
  userAgent?: string | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}