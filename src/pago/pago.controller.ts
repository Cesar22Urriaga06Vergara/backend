import {
  Controller,
  Post,
  Get,
  Patch,
  Param,
  Body,
  ParseIntPipe,
  UseGuards,
  Query,
  Request,
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
import { PagoService } from './pago.service';
import { CreatePagoDto } from './dto/create-pago.dto';
import { Pago } from './entities/pago.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';

@ApiTags('Pagos')
@Controller('pagos')
export class PagoController {
  constructor(private readonly pagoService: PagoService) {}

  /**
   * POST /pagos
   * Registrar un nuevo pago para una factura
   */
  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Registrar nuevo pago' })
  @ApiResponse({ status: 201, description: 'Pago registrado exitosamente' })
  @ApiResponse({ status: 404, description: 'Factura o medio de pago no encontrado' })
  @ApiResponse({ status: 400, description: 'Datos inválidos' })
  async registrarPago(
    @Body() dto: CreatePagoDto,
    @Request() req: any,
  ): Promise<Pago> {
    return this.pagoService.registrarPago(dto, req.user?.id);
  }

  /**
   * GET /pagos/factura/:idFactura
   * Obtener todos los pagos de una factura
   */
  @Get('factura/:idFactura')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin', 'cliente')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener pagos de una factura' })
  @ApiParam({ name: 'idFactura', type: Number })
  @ApiResponse({ status: 200, description: 'Pagos obtenidos exitosamente' })
  async findByFactura(
    @Param('idFactura', ParseIntPipe) idFactura: number,
  ): Promise<Pago[]> {
    return this.pagoService.findByFactura(idFactura);
  }

  /**
   * GET /pagos
   * Obtener todos los pagos con filtros
   */
  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener todos los pagos' })
  @ApiQuery({ name: 'fechaDesde', type: String, required: false })
  @ApiQuery({ name: 'fechaHasta', type: String, required: false })
  @ApiResponse({ status: 200, description: 'Pagos obtenidos exitosamente' })
  async findAll(
    @Query('fechaDesde') fechaDesde?: string,
    @Query('fechaHasta') fechaHasta?: string,
  ): Promise<Pago[]> {
    const filters = {
      fechaDesde: fechaDesde ? new Date(fechaDesde) : undefined,
      fechaHasta: fechaHasta ? new Date(fechaHasta) : undefined,
    };

    return this.pagoService.findAll(filters);
  }

  /**
   * PATCH /pagos/:id/devolver
   * Devolver un pago
   */
  @Patch(':id/devolver')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Devolver un pago' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Pago devuelto exitosamente' })
  @ApiResponse({ status: 404, description: 'Pago no encontrado' })
  async devolverPago(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: { motivo: string },
  ): Promise<Pago> {
    if (!body.motivo) {
      throw new BadRequestException('El motivo de devolución es requerido');
    }
    return this.pagoService.devolverPago(id, body.motivo);
  }
}
