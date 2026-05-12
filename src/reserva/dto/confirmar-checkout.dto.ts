import { IsIn, IsNumber, IsOptional, IsPositive, IsString, MaxLength } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

const ESTADOS_LIMPIEZA = ['LIMPIO', 'SUCIO', 'PENDIENTE_LIMPIEZA', 'EN_LIMPIEZA'] as const;

export class ConfirmarCheckoutDto {
  @ApiPropertyOptional({ description: 'ID de la reserva', example: 42 })
  @Type(() => Number)
  @IsOptional()
  @IsNumber({}, { message: 'ID de reserva debe ser numero' })
  @IsPositive({ message: 'ID de reserva debe ser positivo' })
  idReserva?: number;

  @ApiPropertyOptional({ description: 'ID de la habitacion', example: 12 })
  @Type(() => Number)
  @IsOptional()
  @IsNumber({}, { message: 'ID de habitacion debe ser numero' })
  @IsPositive({ message: 'ID de habitacion debe ser positivo' })
  idHabitacion?: number;

  @ApiPropertyOptional({
    description: 'Estado operativo de la habitacion despues del check-out',
    enum: ESTADOS_LIMPIEZA,
    example: 'PENDIENTE_LIMPIEZA',
  })
  @IsOptional()
  @IsIn(ESTADOS_LIMPIEZA, { message: 'Estado de limpieza invalido' })
  estadoLimpieza?: typeof ESTADOS_LIMPIEZA[number];

  @ApiPropertyOptional({
    description: 'Observaciones del check-out',
    example: 'Sin novedades. Control remoto entregado.',
    maxLength: 500,
  })
  @IsOptional()
  @IsString({ message: 'Observaciones debe ser texto' })
  @MaxLength(500, { message: 'Observaciones no puede exceder 500 caracteres' })
  observacionesCheckout?: string;

  @ApiPropertyOptional({
    description: 'Hora local del check-out en formato HH:mm',
    example: '11:05',
    maxLength: 5,
  })
  @IsOptional()
  @IsString({ message: 'Hora de check-out debe ser texto' })
  @MaxLength(5, { message: 'Hora de check-out no puede exceder 5 caracteres' })
  horaCheckout?: string;
}