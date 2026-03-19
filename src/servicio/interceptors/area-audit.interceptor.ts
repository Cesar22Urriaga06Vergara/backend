/**
 * Interceptor de Auditoría para Reportes Financieros
 * Logea acceso a datos sensibles por áreas
 *
 * Uso: Aplicar a controladores que expongan datos financieros
 * Ejemplo: @UseInterceptors(new AreaAuditInterceptor())
 */

import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class AreaAuditInterceptor implements NestInterceptor {
  private readonly logger = new Logger('AreaAudit');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { user } = request;
    const { method, url, params, query } = request;

    const startTime = Date.now();

    return next.handle().pipe(
      tap(
        (data) => {
          const duration = Date.now() - startTime;

          // Log de acceso a datos sensibles
          this.logger.log(
            JSON.stringify({
              timestamp: new Date().toISOString(),
              usuario: {
                id: user?.id,
                rol: user?.rol,
                idEmpleado: user?.idEmpleado,
                idHotel: user?.idHotel,
              },
              accion: `${method} ${url}`,
              parametros: {
                ...params,
                ...query,
              },
              resultados: {
                registros: Array.isArray(data) ? data.length : 1,
                duracionMs: duration,
              },
              detalles: `Acceso a reportes financieros de área: ${params.categoria || 'N/A'}`,
            }),
          );
        },
        (error) => {
          const duration = Date.now() - startTime;

          // Log de intentos fallidos
          this.logger.warn(
            JSON.stringify({
              timestamp: new Date().toISOString(),
              usuario: {
                id: user?.id,
                rol: user?.rol,
                idHotel: user?.idHotel,
              },
              accion: `${method} ${url}`,
              error: error.message,
              duracionMs: duration,
              detalles: `Intento fallido de acceso a reportes: ${params.categoria || 'N/A'}`,
            }),
          );
        },
      ),
    );
  }
}
