import {
  Controller,
  Get,
  Patch,
  Delete,
  Param,
  Body,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiParam,
  ApiBody,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { ClienteService } from './cliente.service';
import { UpdateClienteDto } from './dto/update-cliente.dto';
import { Cliente } from './entities/cliente.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Clientes')
@Controller('clientes')
export class ClienteController {
  constructor(private readonly clienteService: ClienteService) {}

  /**
   * GET /clientes/:id
   * Obtener un cliente por ID
   */
  @Get(':id')
  @ApiOperation({ summary: 'Obtener un cliente por ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Cliente encontrado' })
  @ApiResponse({ status: 404, description: 'Cliente no encontrado' })
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Cliente> {
    return await this.clienteService.findOne(id);
  }

  /**
   * PATCH /clientes/:id
   * Actualizar un cliente (PROTEGIDA)
   */
  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Actualizar datos de un cliente' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateClienteDto })
  @ApiResponse({ status: 200, description: 'Cliente actualizado exitosamente' })
  @ApiResponse({ status: 404, description: 'Cliente no encontrado' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateClienteDto: UpdateClienteDto,
  ): Promise<Cliente> {
    // Convertir strings de fecha a Date si existen
    const updateData = {
      ...updateClienteDto,
      fechaNacimiento: updateClienteDto.fechaNacimiento ? new Date(updateClienteDto.fechaNacimiento) : undefined,
      visaExpira: updateClienteDto.visaExpira ? new Date(updateClienteDto.visaExpira) : undefined,
    };
    
    return await this.clienteService.update(id, updateData);
  }

  /**
   * DELETE /clientes/:id
   * Eliminar un cliente (PROTEGIDA)
   */
  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Eliminar un cliente' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Cliente eliminado exitosamente' })
  @ApiResponse({ status: 404, description: 'Cliente no encontrado' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<{ message: string }> {
    await this.clienteService.remove(id);
    return { message: 'Cliente eliminado correctamente' };
  }
}
