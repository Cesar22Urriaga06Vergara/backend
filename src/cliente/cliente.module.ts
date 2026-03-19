import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClienteService } from './cliente.service';
import { ClienteController } from './cliente.controller';
import { HistorialClienteService } from './historial-cliente.service';
import { Cliente } from './entities/cliente.entity';
import { Reserva } from '../reserva/entities/reserva.entity';
import { Pedido } from '../servicio/entities/pedido.entity';
import { Factura } from '../factura/entities/factura.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Cliente, Reserva, Pedido, Factura])],
  controllers: [ClienteController],
  providers: [ClienteService, HistorialClienteService],
  exports: [ClienteService, HistorialClienteService],
})
export class ClienteModule {}
