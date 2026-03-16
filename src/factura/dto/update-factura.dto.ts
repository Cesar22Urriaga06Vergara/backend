import { IsOptional, IsString } from 'class-validator';

export class UpdateFacturaDto {
  @IsOptional()
  @IsString()
  estado?: string;

  @IsOptional()
  @IsString()
  observaciones?: string;

  @IsOptional()
  @IsString()
  cufe?: string;

  @IsOptional()
  fechaEmision?: Date;
}
