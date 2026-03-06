import { IsNumber, IsDateString, IsNotEmpty, IsOptional, IsString, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateReservaDto {
  @ApiProperty({
    description: 'ID del cliente que realiza la reserva',
    example: 1,
  })
  @IsNumber()
  @IsNotEmpty()
  idCliente: number;

  @ApiProperty({
    description: 'ID del hotel donde se realiza la reserva',
    example: 1,
  })
  @IsNumber()
  @IsNotEmpty()
  idHotel: number;

  @ApiProperty({
    description: 'ID del tipo de habitación',
    example: 1,
  })
  @IsNumber()
  @IsNotEmpty()
  idTipoHabitacion: number;

  @ApiProperty({
    description: 'Fecha de check-in (YYYY-MM-DD)',
    example: '2026-03-10',
  })
  @IsDateString()
  @IsNotEmpty()
  checkinPrevisto: string;

  @ApiProperty({
    description: 'Fecha de check-out (YYYY-MM-DD)',
    example: '2026-03-12',
  })
  @IsDateString()
  @IsNotEmpty()
  checkoutPrevisto: string;

  @ApiProperty({
    description: 'Número de huéspedes',
    example: 2,
  })
  @IsNumber()
  @Min(1)
  @IsNotEmpty()
  numeroHuespedes: number;

  @ApiPropertyOptional({
    description: 'Observaciones adicionales',
    example: 'Quiero vista al mar',
  })
  @IsString()
  @IsOptional()
  observaciones?: string;
}
