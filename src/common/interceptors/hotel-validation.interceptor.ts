import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  ForbiddenException,
} from '@nestjs/common';
import { Observable } from 'rxjs';

/**
 * Interceptor que valida multi-tenancy de hoteles
 * Asegura que los usuarios (especialmente admin) solo accedan a recursos de su hotel
 *
 * Validaciones:
 * - Recepcionista: solo su hotel
 * - Admin: solo su hotel
 * - SuperAdmin: todos los hoteles
 * - Cliente: tiene acceso derivado de sus reservas
 */
@Injectable()
export class HotelValidationInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    // Si no hay usuario, no validar (dejará a otros guards decidir)
    if (!user) {
      return next.handle();
    }

    // SuperAdmin accede a todo
    if (user.rol === 'superadmin') {
      return next.handle();
    }

    // Para admin y recepcionista, validar que accedan solo a su hotel
    if (['admin', 'recepcionista'].includes(user.rol)) {
      const idHotelParam = request.params.idHotel;
      const idHotelQuery = request.query.idHotel;
      const idHotel = idHotelParam || idHotelQuery;

      // Si hay parámetro de hotel en la solicitud, validar que coincida
      if (idHotel && parseInt(idHotel) !== user.idHotel) {
        throw new ForbiddenException(
          `No tiene autorización para acceder a recursos del hotel ${idHotel}. Su hotel es: ${user.idHotel}`,
        );
      }
    }

    // Cliente: sin validación directa aquí (validado en servicios)
    return next.handle();
  }
}
