import {
  Controller,
  Get,
  Param,
  Query,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { AuditLogService } from '../services/audit-log.service';
import { AuditLog } from '../entities/audit-log.entity';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { RolesGuard } from '../../auth/guards/roles.guard';

@ApiTags('Auditoría')
@Controller('auditoria')
export class AuditLogController {
  constructor(private readonly auditLogService: AuditLogService) {}

  /**
   * GET /auditoria
   * Obtener todos los logs (solo SuperAdmin)
   */
  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener todos los logs de auditoría' })
  @ApiQuery({ name: 'entidad', type: String, required: false })
  @ApiQuery({ name: 'operacion', type: String, required: false })
  @ApiQuery({ name: 'usuarioId', type: Number, required: false })
  @ApiQuery({ name: 'fechaDesde', type: String, required: false })
  @ApiQuery({ name: 'fechaHasta', type: String, required: false })
  @ApiResponse({ status: 200, description: 'Logs obtenidos' })
  async obtenerTodos(
    @Query('entidad') entidad?: string,
    @Query('operacion') operacion?: string,
    @Query('usuarioId', new ParseIntPipe({ optional: true })) usuarioId?: number,
    @Query('fechaDesde') fechaDesde?: string,
    @Query('fechaHasta') fechaHasta?: string,
  ): Promise<AuditLog[]> {
    return this.auditLogService.obtenerTodos({
      entidad,
      operacion,
      usuarioId,
      fechaDesde: fechaDesde ? new Date(fechaDesde) : undefined,
      fechaHasta: fechaHasta ? new Date(fechaHasta) : undefined,
    });
  }

  /**
   * GET /auditoria/entidad/:entidad/:idEntidad
   * Obtener auditoría de una entidad específica
   */
  @Get('entidad/:entidad/:idEntidad')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener auditoría de una entidad' })
  @ApiParam({ name: 'entidad', type: String })
  @ApiParam({ name: 'idEntidad', type: Number })
  @ApiResponse({ status: 200, description: 'Auditoría obtenida' })
  async obtenerPorEntidad(
    @Param('entidad') entidad: string,
    @Param('idEntidad', ParseIntPipe) idEntidad: number,
  ): Promise<AuditLog[]> {
    return this.auditLogService.obtenerPorEntidad(entidad, idEntidad);
  }

  /**
   * GET /auditoria/usuario/:usuarioId
   * Obtener cambios realizados por un usuario
   */
  @Get('usuario/:usuarioId')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener cambios de un usuario' })
  @ApiParam({ name: 'usuarioId', type: Number })
  @ApiQuery({ name: 'dias', type: Number, required: false })
  @ApiResponse({ status: 200, description: 'Cambios obtenidos' })
  async obtenerPorUsuario(
    @Param('usuarioId', ParseIntPipe) usuarioId: number,
    @Query('dias', new ParseIntPipe({ optional: true })) dias?: number,
  ): Promise<AuditLog[]> {
    return this.auditLogService.obtenerPorUsuario(usuarioId, dias);
  }

  /**
   * GET /auditoria/operacion/:operacion
   * Obtener logs por operación (CREATE, UPDATE, DELETE, RESTORE)
   */
  @Get('operacion/:operacion')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener logs por operación' })
  @ApiParam({ name: 'operacion', type: String })
  @ApiResponse({ status: 200, description: 'Logs obtenidos' })
  async obtenerPorOperacion(
    @Param('operacion') operacion: 'CREATE' | 'UPDATE' | 'DELETE' | 'RESTORE',
  ): Promise<AuditLog[]> {
    return this.auditLogService.obtenerPorOperacion(operacion);
  }
}
