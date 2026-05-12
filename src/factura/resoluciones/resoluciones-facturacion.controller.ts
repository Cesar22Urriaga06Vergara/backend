import { BadRequestException, Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { CreateResolucionFacturacionDto, UpdateResolucionFacturacionDto } from './dto/resolucion-facturacion.dto';
import { ResolucionesFacturacionService } from './resoluciones-facturacion.service';

@ApiTags('Resoluciones de facturacion')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('facturacion/resoluciones')
export class ResolucionesFacturacionController {
  constructor(private readonly resolucionesService: ResolucionesFacturacionService) {}

  private resolverHotel(req: any, idHotelDto?: number, idHotelQuery?: string): number {
    const rol = String(req.user?.rol || req.user?.role || '').toLowerCase();
    if (rol === 'superadmin') {
      const idHotel = Number(idHotelDto || idHotelQuery || 0);
      if (!idHotel) {
        throw new BadRequestException('Superadmin debe indicar idHotel');
      }
      return idHotel;
    }

    const idHotel = Number(req.user?.idHotel || 0);
    if (!idHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel');
    }
    return idHotel;
  }

  @Get()
  @Roles('admin', 'superadmin')
  @ApiOperation({ summary: 'Listar resoluciones de facturacion del hotel' })
  @ApiQuery({ name: 'idHotel', required: false, type: Number })
  async listar(@Request() req: any, @Query('idHotel') idHotel?: string) {
    return this.resolucionesService.listar(this.resolverHotel(req, undefined, idHotel));
  }

  @Get('activa')
  @Roles('admin', 'superadmin')
  @ApiOperation({ summary: 'Obtener resolucion activa del hotel' })
  @ApiQuery({ name: 'idHotel', required: false, type: Number })
  async activa(@Request() req: any, @Query('idHotel') idHotel?: string) {
    return this.resolucionesService.obtenerActiva(this.resolverHotel(req, undefined, idHotel));
  }

  @Post()
  @Roles('admin', 'superadmin')
  @ApiOperation({ summary: 'Crear resolucion de facturacion y dejarla activa' })
  async crear(@Request() req: any, @Body() dto: CreateResolucionFacturacionDto) {
    return this.resolucionesService.crear(this.resolverHotel(req, dto.idHotel), dto);
  }

  @Patch(':id')
  @Roles('admin', 'superadmin')
  @ApiOperation({ summary: 'Actualizar estado/observaciones de una resolucion' })
  async actualizar(
    @Request() req: any,
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateResolucionFacturacionDto,
    @Query('idHotel') idHotel?: string,
  ) {
    return this.resolucionesService.actualizar(this.resolverHotel(req, undefined, idHotel), id, dto);
  }
}