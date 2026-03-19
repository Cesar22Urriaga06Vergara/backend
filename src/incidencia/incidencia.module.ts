import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RoomIncident } from './entities/room-incident.entity';
import { RoomIncidentService } from './incidencia.service';
import { IncidenciaController } from './incidencia.controller';

@Module({
  imports: [TypeOrmModule.forFeature([RoomIncident])],
  providers: [RoomIncidentService],
  controllers: [IncidenciaController],
  exports: [RoomIncidentService],
})
export class IncidenciaModule {}
