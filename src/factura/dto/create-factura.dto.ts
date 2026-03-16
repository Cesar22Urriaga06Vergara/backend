import { IsNumber, IsOptional } from 'class-validator';

export class CreateFacturaDto {
  @IsNumber()
  idReserva: number;

  @IsOptional()
  @IsNumber()
  porcentajeIva?: number; // default 19

  @IsOptional()
  observaciones?: string;
}
