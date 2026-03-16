import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ReservaService } from './reserva.service';
import { ReservaController } from './reserva.controller';
import { Reserva } from './entities/reserva.entity';
import { Habitacion } from '../habitacion/entities/habitacion.entity';
import { TipoHabitacion } from '../tipo-habitacion/entities/tipo-habitacion.entity';
import { Cliente } from '../cliente/entities/cliente.entity';
import { FacturaModule } from '../factura/factura.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Reserva, Habitacion, TipoHabitacion, Cliente]),
    forwardRef(() => FacturaModule),
  ],
  controllers: [ReservaController],
  providers: [ReservaService],
  exports: [ReservaService],
})
export class ReservaModule {}
