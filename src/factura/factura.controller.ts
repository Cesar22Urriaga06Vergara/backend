import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Body,
  ParseIntPipe,
  UseGuards,
  Query,
  BadRequestException,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { FacturaService } from './factura.service';
import { CreateFacturaDto } from './dto/create-factura.dto';
import { UpdateFacturaDto } from './dto/update-factura.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Factura } from './entities/factura.entity';

@ApiTags('Facturas')
@Controller('facturas')
export class FacturaController {
  constructor(private readonly facturaService: FacturaService) {}

  /**
   * POST /facturas/generar/:idReserva
   * Generar factura desde una reserva
   */
  @Post('generar/:idReserva')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Generar factura desde una reserva' })
  @ApiParam({ name: 'idReserva', type: Number, description: 'ID de la reserva' })
  @ApiResponse({ status: 201, description: 'Factura generada exitosamente' })
  @ApiResponse({ status: 404, description: 'Reserva no encontrada' })
  @ApiResponse({ status: 409, description: 'Ya existe factura para esta reserva' })
  async generarDesdeReserva(
    @Param('idReserva', ParseIntPipe) idReserva: number,
  ): Promise<Factura> {
    // En una aplicación real, verificaríamos que la reserva existe
    // Por ahora, asumimos que la lógica del servicio maneja eso
    const reserva = { id: idReserva } as any;
    return this.facturaService.generarDesdeReserva(reserva);
  }

  /**
   * GET /facturas
   * Obtener todas las facturas con filtros
   */
  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener todas las facturas' })
  @ApiQuery({ name: 'idHotel', type: Number, required: false })
  @ApiQuery({ name: 'estado', type: String, required: false })
  @ApiQuery({ name: 'idCliente', type: Number, required: false })
  @ApiResponse({ status: 200, description: 'Facturas obtenidas exitosamente' })
  async findAll(
    @Query('idHotel') idHotel?: string,
    @Query('estado') estado?: string,
    @Query('idCliente') idCliente?: string,
  ): Promise<Factura[]> {
    const filters = {
      idHotel: idHotel ? Number(idHotel) : undefined,
      estado,
      idCliente: idCliente ? Number(idCliente) : undefined,
    };

    return this.facturaService.findAll(filters);
  }

  /**
   * GET /facturas/:id
   * Obtener una factura por ID
   */
  @Get(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin', 'cliente')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener una factura por ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Factura obtenida exitosamente' })
  @ApiResponse({ status: 404, description: 'Factura no encontrada' })
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Factura> {
    return this.facturaService.findOne(id);
  }

  /**
   * GET /facturas/reserva/:idReserva
   * Obtener factura por ID de reserva
   */
  @Get('reserva/:idReserva')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin', 'cliente')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener factura por ID de reserva' })
  @ApiParam({ name: 'idReserva', type: Number })
  @ApiResponse({ status: 200, description: 'Factura obtenida exitosamente' })
  @ApiResponse({ status: 404, description: 'Factura no encontrada' })
  async findByReserva(
    @Param('idReserva', ParseIntPipe) idReserva: number,
  ): Promise<Factura> {
    return this.facturaService.findByReserva(idReserva);
  }

  /**
   * GET /facturas/cliente/:idCliente
   * Obtener todas las facturas de un cliente
   */
  @Get('cliente/:idCliente')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin', 'cliente')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener facturas de un cliente' })
  @ApiParam({ name: 'idCliente', type: Number })
  @ApiResponse({ status: 200, description: 'Facturas obtenidas exitosamente' })
  async findByCliente(
    @Param('idCliente', ParseIntPipe) idCliente: number,
  ): Promise<Factura[]> {
    return this.facturaService.findByCliente(idCliente);
  }

  /**
   * PATCH /facturas/:id/emitir
   * Emitir factura
   */
  @Patch(':id/emitir')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Emitir factura' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Factura emitida exitosamente' })
  @ApiResponse({ status: 404, description: 'Factura no encontrada' })
  async emitir(@Param('id', ParseIntPipe) id: number): Promise<Factura> {
    return this.facturaService.emitir(id);
  }

  /**
   * PATCH /facturas/:id/anular
   * Anular factura
   */
  @Patch(':id/anular')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Anular factura' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Factura anulada exitosamente' })
  @ApiResponse({ status: 404, description: 'Factura no encontrada' })
  async anular(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: { motivo: string },
  ): Promise<Factura> {
    if (!body.motivo) {
      throw new BadRequestException('El motivo de anulación es requerido');
    }
    return this.facturaService.anular(id, body.motivo);
  }
}
