import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { AmenidadModule } from './amenidad/amenidad.module';
import { TipoHabitacionModule } from './tipo-habitacion/tipo-habitacion.module';
import { HabitacionModule } from './habitacion/habitacion.module';
import { CloudinaryModule } from './cloudinary/cloudinary.module';
import { ReservaModule } from './reserva/reserva.module';
import { ClienteModule } from './cliente/cliente.module';
import { EmpleadoModule } from './empleado/empleado.module';
import { HotelModule } from './hotel/hotel.module';
import { ServicioModule } from './servicio/servicio.module';
import { FacturaModule } from './factura/factura.module';
import { MedioPagoModule } from './medio-pago/medio-pago.module';
import { PagoModule } from './pago/pago.module';
import { CommonModule } from './common/common.module';
import { IncidenciaModule } from './incidencia/incidencia.module';
import { CategoriaServiciosModule } from './categoria-servicios/categoria-servicios.module';
import { TaxRatesModule } from './tax-rates/tax-rates.module';
import { ImpuestoModule } from './impuesto/impuesto.module';
import { AdminAccessMiddleware } from './common/middleware/admin-access.middleware';
import { FolioModule } from './folio/folio.module';
import { HuespedesModule } from './huespedes/huespedes.module';
import { SuperadminModule } from './superadmin/superadmin.module';
import { CajaModule } from './caja/caja.module';

@Module({
  imports: [
    // Configuración de variables de entorno
    // isGlobal: true hace que ConfigModule esté disponible en toda la app
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // Event Emitter para comunicación entre servicios
    EventEmitterModule.forRoot(),

    // Configuración de TypeORM con MySQL
    // useFactory permite inyectar ConfigService para leer variables de entorno
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => {
        const databaseUrl = [
          configService.get<string>('MYSQL_URL'),
          configService.get<string>('DATABASE_URL'),
        ].find((url) => url && /^mysql:\/\//i.test(url));

        return {
          type: 'mysql',
          ...(databaseUrl
            ? { url: databaseUrl }
            : {
                host:
                  configService.get<string>('MYSQLHOST') ||
                  configService.get<string>('DB_HOST'),
                port: Number(
                  configService.get<string>('MYSQLPORT') ||
                    configService.get<string>('DB_PORT') ||
                    3306,
                ),
                username:
                  configService.get<string>('MYSQLUSER') ||
                  configService.get<string>('DB_USERNAME'),
                password:
                  configService.get<string>('MYSQLPASSWORD') ||
                  configService.get<string>('DB_PASSWORD'),
                database:
                  configService.get<string>('MYSQLDATABASE') ||
                  configService.get<string>('DB_DATABASE'),
              }),
          entities: [__dirname + '/**/*.entity{.ts,.js}'],
          synchronize:
            configService.get<string>('TYPEORM_SYNCHRONIZE') === 'true',
          logging: configService.get<string>('TYPEORM_LOGGING') === 'true',
        };
      },
      inject: [ConfigService],
    }),

    AuthModule,

    // Módulo de Cloudinary
    CloudinaryModule,

    // Módulos de la aplicación
    CommonModule,
    IncidenciaModule,
    CategoriaServiciosModule,
    TaxRatesModule,
    ImpuestoModule,
    AmenidadModule,
    HotelModule,
    TipoHabitacionModule,
    HabitacionModule,
    ReservaModule,
    ClienteModule,
    EmpleadoModule,
    ServicioModule,
    FacturaModule,
    MedioPagoModule,
    PagoModule,
    FolioModule,
    HuespedesModule,
    SuperadminModule,
    CajaModule,

  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(AdminAccessMiddleware).forRoutes(
      '/users',
      '/usuarios',
      '/habitaciones',
      '/empleados',
      '/hoteles',
      '/amenidades',
      '/medios-pago',
      '/tipos-habitacion',
      '/folios',
      '/caja',
      '/huespedes',
    );
  }
}
