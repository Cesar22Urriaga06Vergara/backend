import {
  IsString,
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  Min,
  Max,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateHotelDto {
  @ApiProperty({
    example: 'ADUS Hotel Bogotá',
    description: 'Nombre del hotel',
  })
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @ApiProperty({
    example: '123456789',
    description: 'NIT único del hotel',
  })
  @IsString()
  @IsNotEmpty()
  nit: string;

  @ApiPropertyOptional({
    example: 'Calle 10 No. 5-50',
    description: 'Dirección del hotel',
  })
  @IsOptional()
  @IsString()
  direccion?: string;

  @ApiPropertyOptional({
    example: 'Bogotá',
    description: 'Ciudad donde está ubicado el hotel',
  })
  @IsOptional()
  @IsString()
  ciudad?: string;

  @ApiPropertyOptional({
    example: 'Colombia',
    description: 'País donde está ubicado el hotel',
  })
  @IsOptional()
  @IsString()
  pais?: string;

  @ApiPropertyOptional({
    example: '+57 1 1234567',
    description: 'Teléfono de contacto del hotel',
  })
  @IsOptional()
  @IsString()
  telefono?: string;

  @ApiPropertyOptional({
    example: 'info@hotelsena.com',
    description: 'Email de contacto del hotel',
  })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({
    example: 5,
    description: 'Calificación en estrellas (1-5)',
    minimum: 1,
    maximum: 5,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  @Max(5)
  estrellas?: number;

  @ApiPropertyOptional({
    example: 'Hotel 5 estrellas con servicios premium',
    description: 'Descripción del hotel',
  })
  @IsOptional()
  @IsString()
  descripcion?: string;
  @ApiPropertyOptional({
    example: 'Hotel Mirador del Lago S.A.S.',
    description: 'Razon social usada en documentos fiscales si difiere del nombre comercial',
  })
  @IsOptional()
  @IsString()
  razonSocial?: string;

  @ApiPropertyOptional({ example: 'https://cdn.hotel.com/logo.png' })
  @IsOptional()
  @IsString()
  logoUrl?: string;

  @ApiPropertyOptional({ example: 'Resolucion DIAN 18764000000000 de 2026' })
  @IsOptional()
  @IsString()
  resolucionFacturacion?: string;

  @ApiPropertyOptional({ example: 'FV' })
  @IsOptional()
  @IsString()
  prefijoFacturacion?: string;

  @ApiPropertyOptional({ example: 'Gracias por su visita' })
  @IsOptional()
  @IsString()
  pieFactura?: string;

  @ApiPropertyOptional({ example: 'COP' })
  @IsOptional()
  @IsString()
  moneda?: string;

  @ApiPropertyOptional({ example: '80mm', enum: ['58mm', '80mm'] })
  @IsOptional()
  @IsString()
  posFormatoDefault?: '58mm' | '80mm';
}
