import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MedioPagoService } from './medio-pago.service';
import { MedioPagoController } from './medio-pago.controller';
import { MedioPago } from './entities/medio-pago.entity';

@Module({
  imports: [TypeOrmModule.forFeature([MedioPago])],
  controllers: [MedioPagoController],
  providers: [MedioPagoService],
  exports: [MedioPagoService],
})
export class MedioPagoModule {}
