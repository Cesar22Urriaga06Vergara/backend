import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Body,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
  ApiParam,
} from '@nestjs/swagger';
import { MedioPagoService } from './medio-pago.service';
import { CreateMedioPagoDto } from './dto/create-medio-pago.dto';
import { MedioPago } from './entities/medio-pago.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';

@ApiTags('Medios de Pago')
@Controller('medios-pago')
export class MedioPagoController {
  constructor(private readonly medioPagoService: MedioPagoService) {}

  /**
   * GET /medios-pago
   * Obtener todos los medios de pago activos
   */
  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('recepcionista', 'admin', 'superadmin', 'cliente')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener medios de pago activos' })
  @ApiResponse({ status: 200, description: 'Medios de pago obtenidos exitosamente' })
  async findAll(): Promise<MedioPago[]> {
    return this.medioPagoService.findAll();
  }

  /**
   * POST /medios-pago
   * Crear un nuevo medio de pago (solo superadmin)
   */
  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Crear nuevo medio de pago' })
  @ApiResponse({ status: 201, description: 'Medio de pago creado exitosamente' })
  async create(@Body() dto: CreateMedioPagoDto): Promise<MedioPago> {
    return this.medioPagoService.create(dto);
  }

  /**
   * PATCH /medios-pago/:id/toggle
   * Activar o desactivar un medio de pago
   */
  @Patch(':id/toggle')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin', 'superadmin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Alternar estado activo/inactivo de un medio de pago' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Estado actualizado exitosamente' })
  @ApiResponse({ status: 404, description: 'Medio de pago no encontrado' })
  async toggleActivo(@Param('id', ParseIntPipe) id: number): Promise<MedioPago> {
    return this.medioPagoService.toggleActivo(id);
  }
}
