import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { AuditLogService } from '../services/audit-log.service';

/**
 * TASK 2.3: Middleware de Auditoría para Acceso a Endpoints Admin
 * Registra TODOS los accesos a endpoints administrativos
 * 
 * Endpoints monitoreados:
 * - /users (gestión de usuarios)
 * - /habitaciones (gestión de habitaciones)
 * - /empleados (gestión de empleados)
 * - /hoteles (gestión de hoteles)
 * - /amenidades (gestión de amenidades)
 * - /medios-pago (gestión de medios de pago)
 */
@Injectable()
export class AdminAccessMiddleware implements NestMiddleware {
  private readonly logger = new Logger('AdminAccess');

  constructor(private auditLogService: AuditLogService) {}

  async use(req: Request, res: Response, next: NextFunction) {
    const startTime = Date.now();
    const user = (req as any).user;

    // Rutas administrativas monitoreadas
    const adminRoutes = [
      '/users',
      '/usuarios',
      '/habitaciones',
      '/empleados',
      '/hoteles',
      '/amenidades',
      '/medios-pago',
      '/tipos-habitacion',
    ];

    const isAdminRoute = adminRoutes.some((route) => req.path.startsWith(route));

    // Si no es ruta admin o no hay usuario, continuar sin registrar
    if (!isAdminRoute || !user) {
      return next();
    }

    // Obtener información de la solicitud
    const metodo = req.method;
    const ruta = req.path;
    const ipAddress = req.ip || req.connection.remoteAddress || 'desconocida';
    const userAgent = req.get('user-agent') || 'desconocido';

    const accionDescriptiva = `${metodo} ${ruta}`;

    // Registrar intento de acceso en auditoría
    try {
      await this.auditLogService.registrar({
        entidad: 'AdminAccess',
        idEntidad: user.id || 0,
        operacion: 'CREATE', // Usamos CREATE para registrar acceso
        usuarioId: user.id,
        usuarioEmail: user.email,
        usuarioRol: user.role,
        ipAddress,
        userAgent,
        accion: accionDescriptiva,
        descripcion: `Acceso a endpoint admin: ${accionDescriptiva} por ${user.email}`,
        cambios: {
          usuario: user.email,
          rol: user.role,
          metodo,
          ruta,
          parametros: { ...req.params, ...req.query },
        },
      });

      this.logger.log(
        `✅ [ADMIN] ${user.email} (${user.role}) - ${accionDescriptiva}`,
      );
    } catch (error: any) {
      this.logger.error(
        `❌ Error registrando acceso admin: ${error.message}`,
        error.stack,
      );
      // No bloqueamos la solicitud si falla el audit log
    }

    // Interceptar respuesta para registrar resultado
    const originalSend = res.send;
    let responseStatus = res.statusCode;

    res.send = function (data: any) {
      responseStatus = res.statusCode;
      const duration = Date.now() - startTime;

      // Registrar resultado en logs
      const exitoOError = responseStatus >= 400 ? '❌ ERROR' : '✅ OK';
      console.log(
        `[ADMIN_AUDIT] ${exitoOError} ${user.email} - ${metodo} ${ruta} - Status: ${responseStatus} - ${duration}ms`,
      );

      // Llamar el método send original
      return originalSend.call(this, data);
    };

    next();
  }
}
