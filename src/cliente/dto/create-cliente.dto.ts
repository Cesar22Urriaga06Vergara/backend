import { IsNumber, IsString, IsOptional, IsEmail, IsDateString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateClienteDto {
  @ApiProperty({ description: 'ID del usuario' })
  @IsNumber()
  idUsuario: number;

  @ApiPropertyOptional({ description: 'Tipo de documento' })
  @IsOptional()
  @IsString()
  tipoDocumento?: string;

  @ApiProperty({ description: 'Número de cédula' })
  @IsString()
  cedula: string;

  @ApiProperty({ description: 'Nombre del cliente' })
  @IsString()
  nombre: string;

  @ApiProperty({ description: 'Apellido del cliente' })
  @IsString()
  apellido: string;

  @ApiPropertyOptional({ description: 'Teléfono' })
  @IsOptional()
  @IsString()
  telefono?: string;

  @ApiPropertyOptional({ description: 'Email' })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ description: 'Dirección' })
  @IsOptional()
  @IsString()
  direccion?: string;

  @ApiPropertyOptional({ description: 'País de nacionalidad' })
  @IsOptional()
  @IsString()
  paisNacionalidad?: string;

  @ApiPropertyOptional({ description: 'País de residencia' })
  @IsOptional()
  @IsString()
  paisResidencia?: string;

  @ApiPropertyOptional({ description: 'Idioma preferido' })
  @IsOptional()
  @IsString()
  idiomaPreferido?: string;

  @ApiPropertyOptional({ description: 'Fecha de nacimiento' })
  @IsOptional()
  @IsDateString()
  fechaNacimiento?: string;

  @ApiPropertyOptional({ description: 'Tipo de visa' })
  @IsOptional()
  @IsString()
  tipoVisa?: string;

  @ApiPropertyOptional({ description: 'Número de visa' })
  @IsOptional()
  @IsString()
  numeroVisa?: string;

  @ApiPropertyOptional({ description: 'Fecha de expiración de visa' })
  @IsOptional()
  @IsDateString()
  visaExpira?: string;
}
