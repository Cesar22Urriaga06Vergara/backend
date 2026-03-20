import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Folio } from './entities/folio.entity';
import { FolioService } from './folio.service';
import { FolioController } from './folio.controller';
import { Reserva } from '../reserva/entities/reserva.entity';
import { Pedido } from '../servicio/entities/pedido.entity';
import { FacturaModule } from '../factura/factura.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Folio, Reserva, Pedido]),
    forwardRef(() => FacturaModule),
  ],
  controllers: [FolioController],
  providers: [FolioService],
  exports: [FolioService],
})
export class FolioModule {}
