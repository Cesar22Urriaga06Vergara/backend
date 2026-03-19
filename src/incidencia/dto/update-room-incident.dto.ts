import { IsOptional, IsEnum, IsString, IsNumber, IsBoolean, Min } from 'class-validator';

export class UpdateRoomIncidentDto {
  @IsOptional()
  @IsEnum(['reported', 'in_progress', 'resolved', 'cancelled'])
  estado?: string;

  @IsOptional()
  @IsEnum(['baja', 'media', 'alta', 'urgente'])
  prioridad?: string;

  @IsOptional()
  @IsEnum(['mantenimiento', 'plomeria', 'limpieza', 'electricidad', 'seguridad', 'otro'])
  areaAsignada?: string;

  @IsOptional()
  @IsNumber()
  idEmpleadoAtiende?: number;

  @IsOptional()
  @IsString()
  nombreEmpleadoAtiende?: string;

  @IsOptional()
  @IsString()
  notaResolucion?: string;

  @IsOptional()
  @IsBoolean()
  esResponsabilidadCliente?: boolean;

  @IsOptional()
  @IsNumber()
  @Min(0)
  cargoAdicional?: number;

  @IsOptional()
  @IsString()
  descripcionCargo?: string;
}
