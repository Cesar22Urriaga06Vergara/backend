import { IsNumber, IsString, IsOptional, IsEnum, IsBoolean, Min } from 'class-validator';

export class CreateRoomIncidentDto {
  @IsNumber()
  idHabitacion: number;

  @IsOptional()
  @IsNumber()
  idReserva?: number;

  @IsOptional()
  @IsNumber()
  idCliente?: number;

  @IsEnum(['daño', 'mantenimiento', 'limpieza', 'cliente_complaint', 'otros'])
  tipo: string;

  @IsString()
  descripcion: string;

  // Area asignada: mantenimiento, plomería, limpieza, electricidad, seguridad, otro
  @IsEnum(['mantenimiento', 'plomeria', 'limpieza', 'electricidad', 'seguridad', 'otro'])
  areaAsignada: string;

  @IsOptional()
  @IsEnum(['baja', 'media', 'alta', 'urgente'])
  prioridad?: string;

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
