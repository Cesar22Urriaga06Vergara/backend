import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';

/**
 * Guard que valida que el usuario solo acceda a recursos que le pertenecen
 * Previene enumeration attacks y acceso no autorizado a datos de otros usuarios
 *
 * Uso: @UseGuards(ResourceOwnershipGuard)
 * En params: idCliente, idFactura, idReserva, idPedido, etc.
 */
@Injectable()
export class ResourceOwnershipGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    // Solo validar para clientes. Admin/Recepcionista/Superadmin pueden ver todo de su hotel
    if (!user || user.rol !== 'cliente') {
      return true;
    }

    const params = request.params;
    const query = request.query;

    // Validar que el cliente acceda solo a sus propios recursos
    // Buscar parámetro idCliente en la URL o query
    const idClienteParam = params.idCliente || query.idCliente;

    if (idClienteParam && parseInt(idClienteParam) !== user.idCliente) {
      throw new ForbiddenException('No tiene autorización para acceder a este recurso');
    }

    // Para endpoints que exponen idReserva, idFactura, idPedido, etc.
    // El controlador debe verificar que pertenecen al cliente
    // Este guard simplemente previene acceso si el param idCliente no coincide

    return true;
  }
}
