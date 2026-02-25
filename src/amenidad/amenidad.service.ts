import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Amenidad } from './entities/amenidad.entity';
import { CreateAmenidadDto } from './dto/create-amenidad.dto';
import { UpdateAmenidadDto } from './dto/update-amenidad.dto';

@Injectable()
export class AmenidadService {
  constructor(
    @InjectRepository(Amenidad)
    private amenidadRepository: Repository<Amenidad>,
  ) {}

  async create(createAmenidadDto: CreateAmenidadDto): Promise<Amenidad> {
    const amenidad = this.amenidadRepository.create(createAmenidadDto);
    return await this.amenidadRepository.save(amenidad);
  }

  async findAll(): Promise<Amenidad[]> {
    return await this.amenidadRepository.find({
      order: { nombre: 'ASC' },
    });
  }

  async findOne(id: number): Promise<Amenidad> {
    const amenidad = await this.amenidadRepository.findOne({ where: { id } });
    if (!amenidad) {
      throw new NotFoundException(`Amenidad con ID ${id} no encontrada`);
    }
    return amenidad;
  }

  async update(id: number, updateAmenidadDto: UpdateAmenidadDto): Promise<Amenidad> {
    const amenidad = await this.findOne(id);
    Object.assign(amenidad, updateAmenidadDto);
    return await this.amenidadRepository.save(amenidad);
  }

  async remove(id: number): Promise<void> {
    const amenidad = await this.findOne(id);
    await this.amenidadRepository.remove(amenidad);
  }
}
