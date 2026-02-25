import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { TipoHabitacion } from './entities/tipo-habitacion.entity';
import { Amenidad } from '../amenidad/entities/amenidad.entity';
import { CreateTipoHabitacionDto } from './dto/create-tipo-habitacion.dto';
import { UpdateTipoHabitacionDto } from './dto/update-tipo-habitacion.dto';

@Injectable()
export class TipoHabitacionService {
  constructor(
    @InjectRepository(TipoHabitacion)
    private tipoHabitacionRepository: Repository<TipoHabitacion>,
    @InjectRepository(Amenidad)
    private amenidadRepository: Repository<Amenidad>,
  ) {}

  async create(createTipoHabitacionDto: CreateTipoHabitacionDto): Promise<TipoHabitacion> {
    const { amenidadesIds, ...tipoHabitacionData } = createTipoHabitacionDto;
    
    const tipoHabitacion = this.tipoHabitacionRepository.create(tipoHabitacionData);
    
    if (amenidadesIds && amenidadesIds.length > 0) {
      const amenidades = await this.amenidadRepository.findBy({ id: In(amenidadesIds) });
      tipoHabitacion.amenidades = amenidades;
    }
    
    return await this.tipoHabitacionRepository.save(tipoHabitacion);
  }

  async findAll(): Promise<TipoHabitacion[]> {
    return await this.tipoHabitacionRepository.find({
      relations: ['amenidades'],
      order: { nombreTipo: 'ASC' },
    });
  }

  async findByHotel(idHotel: number): Promise<TipoHabitacion[]> {
    return await this.tipoHabitacionRepository.find({
      where: { idHotel },
      relations: ['amenidades'],
      order: { nombreTipo: 'ASC' },
    });
  }

  async findOne(id: number): Promise<TipoHabitacion> {
    const tipoHabitacion = await this.tipoHabitacionRepository.findOne({
      where: { id },
      relations: ['amenidades'],
    });
    
    if (!tipoHabitacion) {
      throw new NotFoundException(`Tipo de habitación con ID ${id} no encontrado`);
    }
    
    return tipoHabitacion;
  }

  async update(id: number, updateTipoHabitacionDto: UpdateTipoHabitacionDto): Promise<TipoHabitacion> {
    const tipoHabitacion = await this.findOne(id);
    const { amenidadesIds, ...tipoHabitacionData } = updateTipoHabitacionDto;
    
    Object.assign(tipoHabitacion, tipoHabitacionData);
    
    if (amenidadesIds !== undefined) {
      if (amenidadesIds.length > 0) {
        const amenidades = await this.amenidadRepository.findBy({ id: In(amenidadesIds) });
        tipoHabitacion.amenidades = amenidades;
      } else {
        tipoHabitacion.amenidades = [];
      }
    }
    
    return await this.tipoHabitacionRepository.save(tipoHabitacion);
  }

  async remove(id: number): Promise<void> {
    const tipoHabitacion = await this.findOne(id);
    await this.tipoHabitacionRepository.remove(tipoHabitacion);
  }
}
