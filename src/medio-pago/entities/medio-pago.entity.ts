import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('medios_pago')
export class MedioPago {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  nombre: string;
  // Valores posibles: 'efectivo', 'tarjeta_credito', 'tarjeta_debito',
  // 'transferencia_bancaria', 'nequi', 'daviplata', 'pse'

  @Column({ nullable: true })
  descripcion: string;

  @Column({ default: true })
  activo: boolean;

  // Si el cajero debe ingresar número de referencia al registrar el pago
  @Column({ name: 'requiere_referencia', default: false })
  requiereReferencia: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}
