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
  UseInterceptors,
  UploadedFiles,
  BadRequestException,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
  ApiTags,
  ApiConsumes,
} from '@nestjs/swagger';
import { FilesInterceptor } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';
import { HabitacionService } from './habitacion.service';
import { CreateHabitacionDto } from './dto/create-habitacion.dto';
import { UpdateHabitacionDto } from './dto/update-habitacion.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Habitaciones')
@Controller('habitaciones')
export class HabitacionController {
  constructor(private readonly habitacionService: HabitacionService) {}

  /**
   * POST /habitaciones
   * Crear una nueva habitación (sin imágenes)
   */
  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
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
   * Obtener todas las habitaciones (PÚBLICO)
   */
  @Get()
  @ApiOperation({ summary: 'Obtener todas las habitaciones' })
  @ApiQuery({ name: 'idHotel', required: false, type: Number, description: 'Filtrar por ID del hotel' })
  @ApiQuery({ name: 'idTipoHabitacion', required: false, type: Number, description: 'Filtrar por ID del tipo de habitación' })
  @ApiQuery({ name: 'disponibles', required: false, type: Boolean, description: 'Solo habitaciones disponibles (por defecto true si idHotel es proporcionado)' })
  @ApiResponse({ status: 200, description: 'Habitaciones obtenidas exitosamente' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  findAll(
    @Query('idHotel') idHotel?: string,
    @Query('idTipoHabitacion') idTipoHabitacion?: string,
    @Query('disponibles') disponibles?: string,
  ) {
    if (idHotel) {
      const soloDisponibles = disponibles !== 'false'; // Por defecto true
      return this.habitacionService.findByHotel(parseInt(idHotel), soloDisponibles);
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
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
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
   * PATCH /habitaciones/:id/imagenes
   * Subir/actualizar imágenes de una habitación
   */
  @Patch(':id/imagenes')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @UseInterceptors(FilesInterceptor('imagenes', 5, { storage: memoryStorage() }))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Subir o actualizar imágenes a una habitación' })
  @ApiParam({ name: 'id', type: Number, description: 'ID de la habitación' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['imagenes'],
      properties: {
        imagenes: {
          type: 'array',
          items: { type: 'string', format: 'binary' },
          description: 'Imágenes de la habitación (máximo 5)',
        },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'Imágenes subidas exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos inválidos o archivo no válido' })
  @ApiResponse({ status: 404, description: 'Habitación no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  uploadImages(
    @Param('id', ParseIntPipe) id: number,
    @UploadedFiles() files?: Express.Multer.File[],
  ) {
    // Validar que se proporcionaron archivos
    if (!files || files.length === 0) {
      throw new BadRequestException('Debes proporcionar al menos una imagen');
    }

    // Validar que los archivos sean imágenes
    const allowedMimes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    const invalidFiles = files.filter((file) => !allowedMimes.includes(file.mimetype));

    if (invalidFiles.length > 0) {
      throw new BadRequestException(
        'Solo se permiten archivos de imagen (JPEG, PNG, WebP, GIF)',
      );
    }

    return this.habitacionService.uploadImages(id, files);
  }

  /**
   * DELETE /habitaciones/:id
   * Eliminar una habitación
   */
  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Eliminar una habitación' })
  @ApiParam({ name: 'id', type: Number, description: 'ID de la habitación' })
  @ApiResponse({ status: 200, description: 'Habitación eliminada exitosamente' })
  @ApiResponse({ status: 404, description: 'Habitación no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.habitacionService.remove(id);
  }
}
