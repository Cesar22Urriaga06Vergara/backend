import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Habitacion } from './entities/habitacion.entity';
import { CreateHabitacionDto } from './dto/create-habitacion.dto';
import { UpdateHabitacionDto } from './dto/update-habitacion.dto';

@Injectable()
export class HabitacionService {
  constructor(
    @InjectRepository(Habitacion)
    private habitacionRepository: Repository<Habitacion>,
  ) {}

  async create(createHabitacionDto: CreateHabitacionDto): Promise<Habitacion> {
    const habitacion = this.habitacionRepository.create({
      ...createHabitacionDto,
      estado: createHabitacionDto.estado || 'disponible',
    });
    return await this.habitacionRepository.save(habitacion);
  }

  async findAll(): Promise<Habitacion[]> {
    return await this.habitacionRepository.find({
      relations: ['tipoHabitacion', 'tipoHabitacion.amenidades'],
      order: { numeroHabitacion: 'ASC' },
    });
  }

  async findByHotel(idHotel: number): Promise<Habitacion[]> {
    return await this.habitacionRepository.find({
      where: { idHotel },
      relations: ['tipoHabitacion', 'tipoHabitacion.amenidades'],
      order: { numeroHabitacion: 'ASC' },
    });
  }

  async findByTipo(idTipoHabitacion: number): Promise<Habitacion[]> {
    return await this.habitacionRepository.find({
      where: { idTipoHabitacion },
      relations: ['tipoHabitacion', 'tipoHabitacion.amenidades'],
      order: { numeroHabitacion: 'ASC' },
    });
  }

  async findOne(id: number): Promise<Habitacion> {
    const habitacion = await this.habitacionRepository.findOne({
      where: { id },
      relations: ['tipoHabitacion', 'tipoHabitacion.amenidades'],
    });
    
    if (!habitacion) {
      throw new NotFoundException(`Habitación con ID ${id} no encontrada`);
    }
    
    return habitacion;
  }

  async update(id: number, updateHabitacionDto: UpdateHabitacionDto): Promise<Habitacion> {
    const habitacion = await this.findOne(id);
    Object.assign(habitacion, updateHabitacionDto);
    habitacion.fechaActualizacion = new Date();
    return await this.habitacionRepository.save(habitacion);
  }

  async remove(id: number): Promise<void> {
    const habitacion = await this.findOne(id);
    await this.habitacionRepository.remove(habitacion);
  }
}
