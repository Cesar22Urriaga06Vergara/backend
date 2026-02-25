import { IsString, IsOptional, IsNotEmpty } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateAmenidadDto {
  @ApiProperty({
    description: 'Nombre de la amenidad',
    example: 'WiFi Gratis',
  })
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @ApiPropertyOptional({
    description: 'Ícono de Material Design Icons',
    example: 'mdi-wifi',
  })
  @IsString()
  @IsOptional()
  icono?: string;

  @ApiPropertyOptional({
    description: 'Categoría de la amenidad',
    example: 'Tecnología',
    enum: ['Servicios básicos', 'Entretenimiento', 'Comodidad', 'Higiene', 'Tecnología', 'Otros'],
  })
  @IsString()
  @IsOptional()
  categoria?: string;

  @ApiPropertyOptional({
    description: 'Descripción detallada de la amenidad',
    example: 'Conexión WiFi de alta velocidad disponible en toda la habitación',
  })
  @IsString()
  @IsOptional()
  descripcion?: string;
}
