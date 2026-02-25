import { PartialType } from '@nestjs/swagger';
import { CreateAmenidadDto } from './create-amenidad.dto';

export class UpdateAmenidadDto extends PartialType(CreateAmenidadDto) {}
