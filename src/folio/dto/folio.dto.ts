import { IsNumber, IsNotEmpty, IsString, IsOptional, Min, MaxLength, IsIn } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateFolioDto {
  @IsNumber()
  @IsNotEmpty()
  @Type(() => Number)
  @Min(1)
  idHabitacion: number;

  @IsNumber()
  @IsOptional()
  @Type(() => Number)
  @Min(1)
  idReserva?: number;
}

export class AgregarCargoDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(180)
  descripcion: string;

  @IsNumber()
  @IsNotEmpty()
  @Type(() => Number)
  @Min(0.01)
  cantidad: number;

  @IsNumber()
  @IsNotEmpty()
  @Type(() => Number)
  @Min(0)
  precioUnitario: number;

  @IsString()
  @IsNotEmpty()
  @IsIn(['SERVICIO', 'ADICIONAL', 'INCIDENCIA', 'OTRO'])
  categoria: 'SERVICIO' | 'ADICIONAL' | 'INCIDENCIA' | 'OTRO';
}

// FASE 5: Importar del nuevo archivo de operaciones para trazabilidad mejorada
export { CobrarFolioDto, CerrarFolioDto, CobrarFolioMixtoDto, CobrarFolioMixtoLineaDto } from './folio-operaciones.dto';

export class EliminarCargoDto {
  @IsString()
  @IsNotEmpty()
  idCargo: string;
}
