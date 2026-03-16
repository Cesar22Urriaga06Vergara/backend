import { IsString, IsOptional, IsBoolean } from 'class-validator';

export class CreateMedioPagoDto {
  @IsString()
  nombre: string;

  @IsOptional()
  @IsString()
  descripcion?: string;

  @IsOptional()
  @IsBoolean()
  requiereReferencia?: boolean;
}
