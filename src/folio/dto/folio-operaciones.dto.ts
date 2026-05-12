import {
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
  IsIn,
  IsArray,
  ArrayMinSize,
  ValidateNested,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

/**
 * DTO para CERRAR FOLIO
 * Cierra un folio ACTIVO antes de cobrar
 * Validación: no permite cerrar folio con cargos pendientes de cobro
 */
export class CerrarFolioDto {
  @ApiProperty({
    description: 'ID de la habitación',
    example: 101,
    type: Number,
  })
  @Type(() => Number)
  @IsNotEmpty({ message: 'ID de habitación es requerido' })
  @IsNumber({}, { message: 'ID debe ser número' })
  @IsPositive({ message: 'ID debe ser positivo' })
  idHabitacion: number;

  @ApiPropertyOptional({
    description: 'Observaciones de cierre de folio',
    example: 'Huésped solicita aclaración de cargos',
    maxLength: 300,
  })
  @IsOptional()
  @IsString({ message: 'Observaciones debe ser texto' })
  @MaxLength(300, { message: 'Observaciones no puede exceder 300 caracteres' })
  observacionesCierre?: string;
}

/**
 * DTO para COBRAR FOLIO
 * Cobra un folio CERRADO y proporciona recepción de pago
 * Crea automáticamente factura si no existe
 * Registra medio de pago para trazabilidad
 */
export class CobrarFolioDto {
  @ApiProperty({
    description: 'ID de la habitación',
    example: 101,
    type: Number,
  })
  @Type(() => Number)
  @IsNotEmpty({ message: 'ID de habitación es requerido' })
  @IsNumber({}, { message: 'ID debe ser número' })
  @IsPositive({ message: 'ID debe ser positivo' })
  idHabitacion: number;

  @ApiProperty({
    description: 'ID del medio de pago (efectivo, tarjeta, cheque, etc)',
    example: 1,
    type: Number,
  })
  @Type(() => Number)
  @IsNotEmpty({ message: 'ID de medio pago es requerido' })
  @IsNumber({}, { message: 'ID de medio pago debe ser número' })
  @IsPositive({ message: 'ID de medio pago debe ser positivo' })
  idMedioPago: number;

  @ApiProperty({
    description: 'Monto total a cobrar',
    example: 250000,
    type: Number,
  })
  @Type(() => Number)
  @IsNotEmpty({ message: 'Monto a cobrar es requerido' })
  @IsNumber({}, { message: 'Monto debe ser número' })
  @IsPositive({ message: 'Monto debe ser positivo' })
  montoCobrar: number;

  @ApiPropertyOptional({
    description: 'Monto recibido del cliente (para efectivo, calcula vuelto)',
    example: 260000,
    type: Number,
  })
  @Type(() => Number)
  @IsOptional()
  @IsNumber({}, { message: 'Monto recibido debe ser número' })
  @IsPositive({ message: 'Monto recibido debe ser positivo' })
  montoRecibido?: number;

  @ApiPropertyOptional({
    description: 'Referencia de pago (número cheque, transacción TDC, etc)',
    example: 'TRANS-2026-04-05-001',
    minLength: 3,
    maxLength: 50,
  })
  @IsOptional()
  @IsString({ message: 'Referencia debe ser texto' })
  @MinLength(3, { message: 'Referencia debe tener mín 3 caracteres' })
  @MaxLength(50, { message: 'Referencia no puede exceder 50 caracteres' })
  referenciaPago?: string;

  @ApiPropertyOptional({
    description: 'Observaciones del cobro',
    example: 'Cliente pagó con descuento de cortesía',
    maxLength: 300,
  })
  @IsOptional()
  @IsString({ message: 'Observaciones debe ser texto' })
  @MaxLength(300, { message: 'Observaciones no puede exceder 300 caracteres' })
  observacionesCobro?: string;

  @ApiPropertyOptional({
    description: 'Nombre de quién realiza el cobro',
    example: 'Juan Pérez (Recepcionista)',
    maxLength: 100,
  })
  @IsOptional()
  @IsString({ message: 'Cobrador debe ser texto' })
  @MaxLength(100, { message: 'Cobrador no puede exceder 100 caracteres' })
  cobrador?: string;
}

export class CobrarFolioMixtoLineaDto {
  @ApiProperty({ description: 'ID del medio de pago', example: 1, type: Number })
  @Type(() => Number)
  @IsNotEmpty({ message: 'ID de medio pago es requerido' })
  @IsNumber({}, { message: 'ID de medio pago debe ser numero' })
  @IsPositive({ message: 'ID de medio pago debe ser positivo' })
  idMedioPago: number;

  @ApiProperty({ description: 'Monto aplicado a esta linea de pago', example: 50000, type: Number })
  @Type(() => Number)
  @IsNotEmpty({ message: 'Monto a cobrar es requerido' })
  @IsNumber({}, { message: 'Monto debe ser numero' })
  @IsPositive({ message: 'Monto debe ser positivo' })
  montoCobrar: number;

  @ApiPropertyOptional({ description: 'Monto recibido del cliente para efectivo', example: 60000, type: Number })
  @Type(() => Number)
  @IsOptional()
  @IsNumber({}, { message: 'Monto recibido debe ser numero' })
  @Min(0, { message: 'Monto recibido debe ser mayor o igual a 0' })
  montoRecibido?: number;

  @ApiPropertyOptional({ description: 'Referencia de pago', example: 'TRX-12345', maxLength: 80 })
  @IsOptional()
  @IsString({ message: 'Referencia debe ser texto' })
  @MaxLength(80, { message: 'Referencia no puede exceder 80 caracteres' })
  referenciaPago?: string;

  @ApiPropertyOptional({ description: 'Observaciones de la linea', maxLength: 180 })
  @IsOptional()
  @IsString({ message: 'Observaciones debe ser texto' })
  @MaxLength(180, { message: 'Observaciones no puede exceder 180 caracteres' })
  observaciones?: string;
}

export class CobrarFolioMixtoDto {
  @ApiProperty({ description: 'ID de la habitacion', example: 101, type: Number })
  @Type(() => Number)
  @IsNotEmpty({ message: 'ID de habitacion es requerido' })
  @IsNumber({}, { message: 'ID debe ser numero' })
  @IsPositive({ message: 'ID debe ser positivo' })
  idHabitacion: number;

  @ApiProperty({ description: 'Lineas de pago', type: [CobrarFolioMixtoLineaDto] })
  @IsArray({ message: 'Pagos debe ser una lista' })
  @ArrayMinSize(2, { message: 'Un pago mixto requiere al menos dos lineas' })
  @ValidateNested({ each: true })
  @Type(() => CobrarFolioMixtoLineaDto)
  pagos: CobrarFolioMixtoLineaDto[];

  @ApiPropertyOptional({ description: 'Observaciones generales del cobro', maxLength: 300 })
  @IsOptional()
  @IsString({ message: 'Observaciones debe ser texto' })
  @MaxLength(300, { message: 'Observaciones no puede exceder 300 caracteres' })
  observacionesCobro?: string;

  @ApiPropertyOptional({ description: 'Nombre de quien realiza el cobro', maxLength: 100 })
  @IsOptional()
  @IsString({ message: 'Cobrador debe ser texto' })
  @MaxLength(100, { message: 'Cobrador no puede exceder 100 caracteres' })
  cobrador?: string;
}