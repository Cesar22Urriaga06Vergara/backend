import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditLog } from './entities/audit-log.entity';
import { AuditLogService } from './services/audit-log.service';
import { AuditLogController } from './controllers/audit-log.controller';
import { ApiResponseService } from './services/api-response.service';
import { KpisService } from './services/kpis.service';
import { KpisController } from './controllers/kpis.controller';
import { RateAdjustmentService } from './services/rate-adjustment.service';
import { Reserva } from '../reserva/entities/reserva.entity';
import { Habitacion } from '../habitacion/entities/habitacion.entity';
import { Factura } from '../factura/entities/factura.entity';
import { Hotel } from '../hotel/entities/hotel.entity';
import { Empleado } from '../empleado/entities/empleado.entity';
import { CajaTurno } from '../caja/entities/caja-turno.entity';
import { CajaMovimiento } from '../caja/entities/caja-movimiento.entity';

@Module({
  imports: [TypeOrmModule.forFeature([AuditLog, Reserva, Habitacion, Factura, Hotel, Empleado, CajaTurno, CajaMovimiento])],
  providers: [AuditLogService, ApiResponseService, KpisService, RateAdjustmentService],
  controllers: [AuditLogController, KpisController],
  exports: [AuditLogService, ApiResponseService, KpisService, RateAdjustmentService],
})
export class CommonModule {}
