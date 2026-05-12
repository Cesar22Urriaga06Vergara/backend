import {
  ArrayMinSize,
  IsArray,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPositive,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreatePagoMixtoLineaDto {
  @Type(() => Number)
  @IsNumber({}, { message: 'ID de medio pago debe ser numero' })
  @IsPositive({ message: 'ID de medio pago debe ser positivo' })
  idMedioPago: number;

  @Type(() => Number)
  @IsNumber({}, { message: 'Monto a cobrar debe ser numero' })
  @IsPositive({ message: 'Monto a cobrar debe ser positivo' })
  montoCobrar: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber({}, { message: 'Monto recibido debe ser numero' })
  @Min(0, { message: 'Monto recibido debe ser mayor o igual a 0' })
  montoRecibido?: number;

  @IsOptional()
  @IsString()
  referenciaPago?: string;

  @IsOptional()
  @IsString()
  observaciones?: string;
}

export class CreatePagoMixtoDto {
  @Type(() => Number)
  @IsNotEmpty({ message: 'ID de factura es requerido' })
  @IsNumber({}, { message: 'ID de factura debe ser numero' })
  @IsPositive({ message: 'ID de factura debe ser positivo' })
  idFactura: number;

  @IsArray({ message: 'Pagos debe ser una lista' })
  @ArrayMinSize(2, { message: 'Un pago mixto requiere al menos dos lineas de pago' })
  @ValidateNested({ each: true })
  @Type(() => CreatePagoMixtoLineaDto)
  pagos: CreatePagoMixtoLineaDto[];

  @IsOptional()
  @IsString()
  observaciones?: string;
}