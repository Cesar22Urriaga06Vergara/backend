import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsDateString,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
  Min,
} from 'class-validator';

export class CreateResolucionFacturacionDto {
  @ApiPropertyOptional({ example: 1, description: 'Solo superadmin puede indicar otro hotel' })
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  idHotel?: number;

  @ApiProperty({ example: 'PRUEBA-VALHALLA-2026' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(80)
  numeroResolucion: string;

  @ApiProperty({ example: 'FV' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  prefijo: string;

  @ApiPropertyOptional({ example: '2026-01-01' })
  @IsOptional()
  @IsDateString()
  fechaResolucion?: string;

  @ApiProperty({ example: '2026-01-01' })
  @IsDateString()
  fechaInicio: string;

  @ApiProperty({ example: '2026-12-31' })
  @IsDateString()
  fechaFin: string;

  @ApiProperty({ example: 1 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  rangoDesde: number;

  @ApiProperty({ example: 999999 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  rangoHasta: number;

  @ApiPropertyOptional({ example: 0 })
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(0)
  numeroActual?: number;

  @ApiPropertyOptional({ example: 'factura_venta' })
  @IsOptional()
  @IsString()
  @MaxLength(40)
  tipoDocumento?: string;

  @ApiPropertyOptional({ enum: ['desarrollo', 'produccion'], example: 'desarrollo' })
  @IsOptional()
  @IsIn(['desarrollo', 'produccion'])
  ambiente?: 'desarrollo' | 'produccion';

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  observaciones?: string;
}

export class UpdateResolucionFacturacionDto {
  @ApiPropertyOptional({ enum: ['activa', 'inactiva', 'vencida', 'agotada'] })
  @IsOptional()
  @IsIn(['activa', 'inactiva', 'vencida', 'agotada'])
  estado?: 'activa' | 'inactiva' | 'vencida' | 'agotada';

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  observaciones?: string;
}