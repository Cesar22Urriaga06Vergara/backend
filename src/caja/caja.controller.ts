import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CajaService } from './caja.service';
import { AbrirCajaTurnoDto, CerrarCajaTurnoDto, CrearCajaMovimientoDto } from './dto/caja.dto';

@ApiTags('Caja')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('caja')
export class CajaController {
  constructor(private readonly cajaService: CajaService) {}

  private obtenerIdUsuario(req: any): number {
    return Number(req.user?.idEmpleado || req.user?.id || req.user?.sub || 0);
  }

  private resolverHotel(req: any, idHotelDto?: number): number {
    const rol = String(req.user?.rol || req.user?.role || '').toLowerCase();

    if (rol === 'superadmin') {
      const idHotel = Number(idHotelDto || req.query?.idHotel || 0);
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

  @Post('turnos/abrir')
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiOperation({ summary: 'Abrir turno de caja' })
  async abrirTurno(@Body() dto: AbrirCajaTurnoDto, @Request() req: any) {
    return this.cajaService.abrirTurno(
      this.resolverHotel(req, dto.idHotel),
      this.obtenerIdUsuario(req),
      dto,
    );
  }

  @Get('turnos/actual')
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiOperation({ summary: 'Obtener caja abierta del hotel' })
  @ApiQuery({ name: 'idHotel', required: false, type: Number })
  async obtenerActual(@Request() req: any) {
    return this.cajaService.obtenerTurnoAbierto(this.resolverHotel(req));
  }

  @Get('turnos')
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiOperation({ summary: 'Listar turnos de caja recientes' })
  @ApiQuery({ name: 'idHotel', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  async listarTurnos(@Request() req: any, @Query('limit') limit?: string) {
    return this.cajaService.listarTurnos(
      this.resolverHotel(req),
      Number(limit || 50),
    );
  }

  @Get('turnos/:id')
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiOperation({ summary: 'Obtener resumen de turno de caja' })
  async obtenerTurno(@Param('id', ParseIntPipe) id: number) {
    return this.cajaService.obtenerResumenTurno(id);
  }

  @Post('movimientos')
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiOperation({ summary: 'Registrar movimiento manual de caja' })
  async registrarMovimiento(@Body() dto: CrearCajaMovimientoDto, @Request() req: any) {
    return this.cajaService.registrarMovimiento(
      this.resolverHotel(req),
      this.obtenerIdUsuario(req),
      dto,
    );
  }

  @Post('turnos/:id/cerrar')
  @Roles('recepcionista', 'cajero', 'admin', 'superadmin')
  @ApiOperation({ summary: 'Cerrar turno de caja con arqueo' })
  async cerrarTurno(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: CerrarCajaTurnoDto,
    @Request() req: any,
  ) {
    return this.cajaService.cerrarTurno(
      this.resolverHotel(req),
      this.obtenerIdUsuario(req),
      id,
      dto,
    );
  }
}