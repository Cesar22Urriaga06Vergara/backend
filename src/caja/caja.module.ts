import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CajaController } from './caja.controller';
import { CajaService } from './caja.service';
import { CajaTurno } from './entities/caja-turno.entity';
import { CajaMovimiento } from './entities/caja-movimiento.entity';

@Module({
  imports: [TypeOrmModule.forFeature([CajaTurno, CajaMovimiento])],
  controllers: [CajaController],
  providers: [CajaService],
  exports: [CajaService],
})
export class CajaModule {}