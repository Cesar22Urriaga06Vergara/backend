import {
  Controller,
  Post,
  Get,
  Put,
  Delete,
  Param,
  Body,
  UseGuards,
  Request,
  ParseIntPipe,
  Query,
  BadRequestException,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { FolioService } from './folio.service';
import { CreateFolioDto, AgregarCargoDto, CobrarFolioDto, CobrarFolioMixtoDto, EliminarCargoDto } from './dto/folio.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Folio } from './entities/folio.entity';

@ApiTags('Folios / Caja')
@Controller('folios')
export class FolioController {
  constructor(private readonly folioService: FolioService) {}

  private obtenerIdHotelFiltro(req: any, idHotel?: string): number | undefined {
    const rol = req.user?.rol;
    const userIdHotel = req.user?.idHotel;

    if (rol === 'superadmin') {
      if (idHotel === undefined) {
        return undefined;
      }

      const parsed = Number(idHotel);
      if (Number.isNaN(parsed) || parsed <= 0) {
        throw new BadRequestException('idHotel debe ser un numero valido');
      }

      return parsed;
    }

    if (!userIdHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel');
    }

    return Number(userIdHotel);
  }

  /**
   * POST /folios
   * Crear un nuevo folio para una habitación (abre en checkin)
   */
  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Crear nuevo folio de habitación' })
  @ApiResponse({ status: 201, description: 'Folio creado exitosamente' })
  @ApiResponse({ status: 400, description: 'Ya existe un folio activo para esta habitación' })
  async crearFolio(
    @Body() dto: CreateFolioDto,
    @Request() req: any,
  ): Promise<any> {
    await this.folioService.crearFolio(
      dto.idHabitacion,
      dto.idReserva,
      req.user?.id,
    );

    return await this.folioService.obtenerResumenFolio(dto.idHabitacion);
  }

  /**
   * GET /folios/historial
   * Obtener historial de folios (cerrados/pagados/activos) con filtros opcionales
   */
  @Get('historial')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener historial de folios' })
  @ApiQuery({ name: 'idHotel', type: Number, required: false })
  @ApiQuery({ name: 'estado', type: String, required: false })
  @ApiQuery({ name: 'fechaDesde', type: String, required: false })
  @ApiQuery({ name: 'fechaHasta', type: String, required: false })
  @ApiResponse({ status: 200, description: 'Historial obtenido exitosamente' })
  async obtenerHistorial(
    @Request() req: any,
    @Query('idHotel') idHotel?: string,
    @Query('estado') estado?: string,
    @Query('fechaDesde') fechaDesde?: string,
    @Query('fechaHasta') fechaHasta?: string,
  ): Promise<any[]> {
    const rol = req.user?.rol;
    const userIdHotel = req.user?.idHotel;
    let idHotelFiltro: number | undefined;

    if (rol === 'superadmin') {
      if (idHotel !== undefined) {
        const parsed = Number(idHotel);
        if (Number.isNaN(parsed) || parsed <= 0) {
          throw new BadRequestException('idHotel debe ser un número válido');
        }
        idHotelFiltro = parsed;
      }
    } else {
      if (!userIdHotel) {
        throw new BadRequestException('Usuario debe estar asignado a un hotel');
      }

      idHotelFiltro = Number(userIdHotel);
    }

    return await this.folioService.obtenerHistorial({
      idHotel: idHotelFiltro,
      estado,
      fechaDesde,
      fechaHasta,
    });
  }

  /**
   * GET /folios/cedula/:cedula
   * Obtener folio por cedula del cliente
   */
  @Get('cedula/:cedula')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener folio por cedula del cliente' })
  @ApiParam({ name: 'cedula', type: String })
  @ApiQuery({ name: 'idHotel', type: Number, required: false })
  @ApiResponse({ status: 200, description: 'Folio obtenido exitosamente' })
  @ApiResponse({ status: 404, description: 'Folio no encontrado para la cedula' })
  async obtenerFolioPorCedula(
    @Param('cedula') cedula: string,
    @Request() req: any,
    @Query('idHotel') idHotel?: string,
  ): Promise<any> {
    const idHotelFiltro = this.obtenerIdHotelFiltro(req, idHotel);
    return await this.folioService.obtenerResumenFolioPorCedula(cedula, idHotelFiltro);
  }

  /**
   * GET /folios/:idHabitacion
   * Obtener folio actual de una habitación
   */
  @Get(':idHabitacion')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener folio de habitación' })
  @ApiParam({ name: 'idHabitacion', type: Number })
  @ApiResponse({ status: 200, description: 'Folio obtenido exitosamente' })
  @ApiResponse({ status: 404, description: 'Folio no encontrado' })
  async obtenerFolio(
    @Param('idHabitacion', ParseIntPipe) idHabitacion: number,
  ): Promise<any> {
    return await this.folioService.obtenerResumenFolio(idHabitacion);
  }

  /**
   * POST /folios/:idHabitacion/cargos
   * Agregar un cargo al folio
   */
  @Post(':idHabitacion/cargos')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin', 'cafeteria', 'lavanderia', 'spa', 'room_service')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Agregar cargo al folio (servicio, adicional, etc.)' })
  @ApiParam({ name: 'idHabitacion', type: Number })
  @ApiResponse({ status: 200, description: 'Cargo agregado exitosamente' })
  @ApiResponse({ status: 404, description: 'Folio no encontrado' })
  async agregarCargo(
    @Param('idHabitacion', ParseIntPipe) idHabitacion: number,
    @Body() dto: AgregarCargoDto,
    @Request() req: any,
  ): Promise<any> {
    await this.folioService.agregarCargo(
      idHabitacion,
      dto,
      req.user?.fullName || req.user?.nombre || 'Sistema',
    );

    return await this.folioService.obtenerResumenFolio(idHabitacion);
  }

  /**
   * DELETE /folios/:idHabitacion/cargos/:idCargo
   * Eliminar un cargo del folio
   */
  @Delete(':idHabitacion/cargos/:idCargo')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Eliminar cargo del folio' })
  @ApiParam({ name: 'idHabitacion', type: Number })
  @ApiParam({ name: 'idCargo', type: String })
  @ApiResponse({ status: 200, description: 'Cargo eliminado exitosamente' })
  @ApiResponse({ status: 404, description: 'Folio o cargo no encontrado' })
  async eliminarCargo(
    @Param('idHabitacion', ParseIntPipe) idHabitacion: number,
    @Param('idCargo') idCargo: string,
  ): Promise<any> {
    await this.folioService.eliminarCargo(idHabitacion, idCargo);

    return await this.folioService.obtenerResumenFolio(idHabitacion);
  }

  /**
   * PUT /folios/:idHabitacion/cerrar
   * Cerrar folio (preparar para checkout)
   */
  @Put(':idHabitacion/cerrar')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Cerrar folio (antes de cobrar)' })
  @ApiParam({ name: 'idHabitacion', type: Number })
  @ApiResponse({ status: 200, description: 'Folio cerrado exitosamente' })
  @ApiResponse({ status: 404, description: 'Folio no encontrado' })
  async cerrarFolio(
    @Param('idHabitacion', ParseIntPipe) idHabitacion: number,
  ): Promise<any> {
    await this.folioService.cerrarFolio(idHabitacion);

    return await this.folioService.obtenerResumenFolio(idHabitacion);
  }

  /**
   * POST /folios/:idHabitacion/cobrar
   * Cobrar y cerrar folio (registra pago)
   */
  @Post(':idHabitacion/cobrar')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'cajero', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Cobrar folio (registra pago y marca como PAGADO)',
    description:
      'IMPORTANTE: Solo RECEPCIONISTA y SUPERADMIN pueden cobrar (segregación de funciones)',
  })
  @ApiParam({ name: 'idHabitacion', type: Number })
  @ApiResponse({ status: 200, description: 'Folio cobrado y cerrado exitosamente' })
  @ApiResponse({ status: 404, description: 'Folio no encontrado' })
  @ApiResponse({ status: 400, description: 'Monto insuficiente o folio ya pagado' })
  async cobrarFolio(
    @Param('idHabitacion', ParseIntPipe) idHabitacion: number,
    @Body() dto: CobrarFolioDto,
    @Request() req: any,
  ): Promise<any> {
    const respuesta = await this.folioService.cobrarFolio(idHabitacion, dto, Number(req.user?.idEmpleado || req.user?.id || req.user?.sub || 0));

    // Intentar obtener resumen enriquecido, pero si falla, retornar lo que tengo
    try {
      const folioResumen = await this.folioService.obtenerResumenFolio(idHabitacion);
      return {
        ...respuesta,
        folio: folioResumen,
      };
    } catch (error) {
      // Si falla enriquecimiento, retorna al menos lo que tenemos
      console.warn('Advertencia: No se pudo enriquecer folio en response:', error.message);
      return respuesta;
    }
  }
}
