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
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { HabitacionService } from './habitacion.service';
import { CreateHabitacionDto } from './dto/create-habitacion.dto';
import { UpdateHabitacionDto } from './dto/update-habitacion.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Habitaciones')
@ApiBearerAuth()
@Controller('habitaciones')
@UseGuards(JwtAuthGuard)
export class HabitacionController {
  constructor(private readonly habitacionService: HabitacionService) {}

  /**
   * POST /habitaciones
   * Crear una nueva habitación
   */
  @Post()
  @ApiOperation({ summary: 'Crear una nueva habitación' })
  @ApiBody({ type: CreateHabitacionDto })
  @ApiResponse({ status: 201, description: 'Habitación creada exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos inválidos' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  create(@Body() createHabitacionDto: CreateHabitacionDto) {
    return this.habitacionService.create(createHabitacionDto);
  }

  /**
   * GET /habitaciones
   * Obtener todas las habitaciones
   */
  @Get()
  @ApiOperation({ summary: 'Obtener todas las habitaciones' })
  @ApiQuery({ name: 'idHotel', required: false, type: Number, description: 'Filtrar por ID del hotel' })
  @ApiQuery({ name: 'idTipoHabitacion', required: false, type: Number, description: 'Filtrar por ID del tipo de habitación' })
  @ApiResponse({ status: 200, description: 'Habitaciones obtenidas exitosamente' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  findAll(
    @Query('idHotel') idHotel?: string,
    @Query('idTipoHabitacion') idTipoHabitacion?: string,
  ) {
    if (idHotel) {
      return this.habitacionService.findByHotel(parseInt(idHotel));
    }
    if (idTipoHabitacion) {
      return this.habitacionService.findByTipo(parseInt(idTipoHabitacion));
    }
    return this.habitacionService.findAll();
  }

  /**
   * GET /habitaciones/:id
   * Obtener una habitación por ID
   */
  @Get(':id')
  @ApiOperation({ summary: 'Obtener una habitación por ID' })
  @ApiParam({ name: 'id', type: Number, description: 'ID de la habitación' })
  @ApiResponse({ status: 200, description: 'Habitación obtenida exitosamente' })
  @ApiResponse({ status: 404, description: 'Habitación no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.habitacionService.findOne(id);
  }

  /**
   * PATCH /habitaciones/:id
   * Actualizar una habitación
   */
  @Patch(':id')
  @ApiOperation({ summary: 'Actualizar una habitación' })
  @ApiParam({ name: 'id', type: Number, description: 'ID de la habitación' })
  @ApiBody({ type: UpdateHabitacionDto })
  @ApiResponse({ status: 200, description: 'Habitación actualizada exitosamente' })
  @ApiResponse({ status: 404, description: 'Habitación no encontrada' })
  @ApiResponse({ status: 400, description: 'Datos inválidos' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateHabitacionDto: UpdateHabitacionDto,
  ) {
    return this.habitacionService.update(id, updateHabitacionDto);
  }

  /**
   * DELETE /habitaciones/:id
   * Eliminar una habitación
   */
  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar una habitación' })
  @ApiParam({ name: 'id', type: Number, description: 'ID de la habitación' })
  @ApiResponse({ status: 200, description: 'Habitación eliminada exitosamente' })
  @ApiResponse({ status: 404, description: 'Habitación no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.habitacionService.remove(id);
  }
}
