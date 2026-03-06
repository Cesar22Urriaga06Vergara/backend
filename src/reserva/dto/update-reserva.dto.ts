import { IsString, IsOptional, IsDateString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateReservaDto {
  @ApiPropertyOptional({
    description: 'Nuevo estado de la reserva',
    example: 'confirmada',
    enum: ['pendiente', 'confirmada', 'cancelada', 'rechazada', 'completada'],
  })
  @IsString()
  @IsOptional()
  estadoReserva?: string;

  @ApiPropertyOptional({
    description: 'Observaciones adicionales',
    example: 'Cliente solicita cambio de habitación',
  })
  @IsString()
  @IsOptional()
  observaciones?: string;

  @ApiPropertyOptional({
    description: 'Nueva fecha de check-in (si aplica)',
    example: '2026-03-11',
  })
  @IsDateString()
  @IsOptional()
  checkinPrevisto?: string;

  @ApiPropertyOptional({
    description: 'Nueva fecha de check-out (si aplica)',
    example: '2026-03-13',
  })
  @IsDateString()
  @IsOptional()
  checkoutPrevisto?: string;
}
