import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AmenidadService } from './amenidad.service';
import { AmenidadController } from './amenidad.controller';
import { Amenidad } from './entities/amenidad.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Amenidad])],
  controllers: [AmenidadController],
  providers: [AmenidadService],
  exports: [AmenidadService, TypeOrmModule],
})
export class AmenidadModule {}
