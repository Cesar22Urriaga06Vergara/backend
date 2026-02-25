import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TipoHabitacionService } from './tipo-habitacion.service';
import { TipoHabitacionController } from './tipo-habitacion.controller';
import { TipoHabitacion } from './entities/tipo-habitacion.entity';
import { AmenidadModule } from '../amenidad/amenidad.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([TipoHabitacion]),
    AmenidadModule,
  ],
  controllers: [TipoHabitacionController],
  providers: [TipoHabitacionService],
  exports: [TipoHabitacionService, TypeOrmModule],
})
export class TipoHabitacionModule {}
