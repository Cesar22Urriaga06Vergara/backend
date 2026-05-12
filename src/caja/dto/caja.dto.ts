import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPositive,
  IsString,
  MaxLength,
  Min,
} from 'class-validator';
import type { CajaMovimientoOrigen, CajaMovimientoTipo } from '../entities/caja-movimiento.entity';

export class AbrirCajaTurnoDto {
  @ApiProperty({ example: 100000, description: 'Base inicial del turno' })
  @Type(() => Number)
  @IsNumber({}, { message: 'El monto inicial debe ser numerico' })
  @Min(0, { message: 'El monto inicial no puede ser negativo' })
  montoInicial: number;

  @ApiPropertyOptional({ example: 1, description: 'Solo superadmin puede abrir caja para otro hotel' })
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @IsPositive()
  idHotel?: number;

  @ApiPropertyOptional({ maxLength: 300 })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  observaciones?: string;
}

export class CrearCajaMovimientoDto {
  @ApiProperty({ enum: ['INGRESO', 'EGRESO'], example: 'INGRESO' })
  @IsIn(['INGRESO', 'EGRESO'])
  tipo: CajaMovimientoTipo;

  @ApiPropertyOptional({ enum: ['MANUAL', 'FOLIO', 'FACTURA', 'DEVOLUCION', 'AJUSTE'], example: 'MANUAL' })
  @IsOptional()
  @IsIn(['MANUAL', 'FOLIO', 'FACTURA', 'DEVOLUCION', 'AJUSTE'])
  origen?: CajaMovimientoOrigen;

  @ApiProperty({ example: 50000 })
  @Type(() => Number)
  @IsNumber({}, { message: 'El monto debe ser numerico' })
  @IsPositive({ message: 'El monto debe ser mayor a cero' })
  monto: number;

  @ApiProperty({ example: 'Ingreso por venta mostrador', maxLength: 180 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(180)
  concepto: string;

  @ApiPropertyOptional({ example: 1 })
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @IsPositive()
  idMedioPago?: number;

  @ApiPropertyOptional({ example: 'efectivo', maxLength: 60 })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  metodoPago?: string;

  @ApiPropertyOptional({ example: 'TX-12345', maxLength: 120 })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  referencia?: string;

  @ApiPropertyOptional({ example: 55 })
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @IsPositive()
  idFolio?: number;

  @ApiPropertyOptional({ example: 88 })
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @IsPositive()
  idFactura?: number;

  @ApiPropertyOptional({ maxLength: 300 })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  observaciones?: string;
}

export class CerrarCajaTurnoDto {
  @ApiProperty({ example: 350000, description: 'Valor contado fisicamente al cierre' })
  @Type(() => Number)
  @IsNumber({}, { message: 'El monto contado debe ser numerico' })
  @Min(0, { message: 'El monto contado no puede ser negativo' })
  montoContado: number;

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  observaciones?: string;
}