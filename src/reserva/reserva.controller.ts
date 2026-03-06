import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseIntPipe,
  UseGuards,
  Query,
  BadRequestException,
  Request,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
  ApiQuery,
} from '@nestjs/swagger';
import { ReservaService } from './reserva.service';
import { CreateReservaDto } from './dto/create-reserva.dto';
import { UpdateReservaDto } from './dto/update-reserva.dto';
import { DisponibilidadQueryDto } from './dto/disponibilidad-query.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Reserva } from './entities/reserva.entity';

@ApiTags('Reservas')
@Controller('reservas')
export class ReservaController {
  constructor(private readonly reservaService: ReservaService) {}

  /**
   * GET /reservas/disponibilidad
   * Consultar habitaciones disponibles para un rango de fechas (PÚBLICO)
   */
  @Get('disponibilidad')
  @ApiOperation({
    summary: 'Consultar disponibilidad de habitaciones',
    description:
      'Obtiene las habitaciones disponibles para un rango de fechas específico',
  })
  @ApiQuery({ name: 'idHotel', type: Number, required: true })
  @ApiQuery({ name: 'checkinFecha', type: String, required: true })
  @ApiQuery({ name: 'checkoutFecha', type: String, required: true })
  @ApiQuery({ name: 'idTipoHabitacion', type: Number, required: false })
  @ApiResponse({ status: 200, description: 'Disponibilidad consultada exitosamente' })
  @ApiResponse({ status: 400, description: 'Parámetros inválidos' })
  async consultarDisponibilidad(@Query() query: any) {
    // Convertir strings a números
    const disponibilidadQuery: DisponibilidadQueryDto = {
      idHotel: Number(query.idHotel),
      checkinFecha: query.checkinFecha,
      checkoutFecha: query.checkoutFecha,
      idTipoHabitacion: query.idTipoHabitacion ? Number(query.idTipoHabitacion) : undefined,
    };

    // Validaciones
    if (!disponibilidadQuery.idHotel || !disponibilidadQuery.checkinFecha || !disponibilidadQuery.checkoutFecha) {
      throw new BadRequestException('idHotel, checkinFecha y checkoutFecha son requeridos');
    }

    return await this.reservaService.consultarDisponibilidad(disponibilidadQuery);
  }

  /**
   * POST /reservas
   * Crear una nueva reserva (PROTEGIDA)
   */
  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Crear una nueva reserva' })
  @ApiBody({ type: CreateReservaDto })
  @ApiResponse({ status: 201, description: 'Reserva creada exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos inválidos' })
  @ApiResponse({ status: 409, description: 'No hay disponibilidad' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async create(@Body() createReservaDto: CreateReservaDto, @Request() req): Promise<Reserva> {
    // Obtener el idCliente del usuario autenticado (del JWT)
    createReservaDto.idCliente = req.user.idCliente;
    return await this.reservaService.create(createReservaDto);
  }

  /**
   * GET /reservas/codigo/:codigo
   * Obtener una reserva por código de confirmación (PÚBLICA)
   */
  @Get('codigo/:codigoConfirmacion')
  @ApiOperation({ summary: 'Obtener reserva por código de confirmación' })
  @ApiParam({ name: 'codigoConfirmacion', type: String })
  @ApiResponse({ status: 200, description: 'Reserva encontrada' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  async findByCodigoConfirmacion(
    @Param('codigoConfirmacion') codigoConfirmacion: string,
  ): Promise<Reserva> {
    return await this.reservaService.findByCodigoConfirmacion(codigoConfirmacion);
  }

  /**
   * GET /reservas/cliente/:idCliente
   * Obtener todas las reservas de un cliente (PROTEGIDA)
   */
  @Get('cliente/:idCliente')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener reservas de un cliente' })
  @ApiParam({ name: 'idCliente', type: Number })
  @ApiResponse({ status: 200, description: 'Reservas encontradas' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async findByCliente(
    @Param('idCliente', ParseIntPipe) idCliente: number,
  ): Promise<Reserva[]> {
    return await this.reservaService.findByCliente(idCliente);
  }

  /**
   * GET /reservas/hotel/:idHotel
   * Obtener todas las reservas de un hotel (PROTEGIDA)
   */
  @Get('hotel/:idHotel')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener reservas de un hotel' })
  @ApiParam({ name: 'idHotel', type: Number })
  @ApiResponse({ status: 200, description: 'Reservas encontradas' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async findByHotel(
    @Param('idHotel', ParseIntPipe) idHotel: number,
  ): Promise<Reserva[]> {
    return await this.reservaService.findByHotel(idHotel);
  }

  /**
   * GET /reservas/:id
   * Obtener una reserva por ID (PROTEGIDA)
   */
  @Get(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener detalle de una reserva' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Reserva encontrada' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Reserva> {
    return await this.reservaService.findOne(id);
  }

  /**
   * PATCH /reservas/:id
   * Actualizar una reserva (PROTEGIDA)
   */
  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Actualizar una reserva' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateReservaDto })
  @ApiResponse({ status: 200, description: 'Reserva actualizada exitosamente' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateReservaDto: UpdateReservaDto,
  ): Promise<Reserva> {
    return await this.reservaService.update(id, updateReservaDto);
  }

  /**
   * POST /reservas/:id/cancelar
   * Cancelar una reserva (PROTEGIDA)
   */
  @Post(':id/cancelar')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Cancelar una reserva' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ schema: { type: 'object', properties: { motivo: { type: 'string' } } } })
  @ApiResponse({ status: 200, description: 'Reserva cancelada exitosamente' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async cancelar(
    @Param('id', ParseIntPipe) id: number,
    @Body('motivo') motivo?: string,
  ): Promise<Reserva> {
    return await this.reservaService.cancelar(id, motivo);
  }

  /**
   * POST /reservas/:id/checkin
   * Confirmar check-in (PROTEGIDA)
   */
  @Post(':id/checkin')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Confirmar check-in' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Check-in confirmado exitosamente' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async confirmarCheckin(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<Reserva> {
    return await this.reservaService.confirmarCheckin(id);
  }

  /**
   * POST /reservas/:id/checkout
   * Confirmar check-out (PROTEGIDA)
   */
  @Post(':id/checkout')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Confirmar check-out' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Check-out confirmado exitosamente' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async confirmarCheckout(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<Reserva> {
    return await this.reservaService.confirmarCheckout(id);
  }

  /**
   * DELETE /reservas/:id
   * Eliminar una reserva (solo si no tiene check-in) (PROTEGIDA)
   */
  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Eliminar una reserva' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Reserva eliminada exitosamente' })
  @ApiResponse({ status: 400, description: 'No se puede eliminar la reserva' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<{ message: string }> {
    await this.reservaService.remove(id);
    return { message: 'Reserva eliminada correctamente' };
  }
}
