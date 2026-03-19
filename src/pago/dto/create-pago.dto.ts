import { IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class CreatePagoDto {
  @IsNumber()
  idFactura: number;

  @IsNumber()
  idMedioPago: number;

  @IsNumber()
  @Min(0.01)
  monto: number;

  // Monto recibido en efectivo (solo requerido si medioPago = 'efectivo')
  @IsOptional()
  @IsNumber()
  @Min(0)
  montoRecibido?: number;

  @IsOptional()
  @IsString()
  referenciaPago?: string;

  @IsOptional()
  @IsString()
  observaciones?: string;
}
