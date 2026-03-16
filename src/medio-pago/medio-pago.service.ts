import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MedioPago } from './entities/medio-pago.entity';
import { CreateMedioPagoDto } from './dto/create-medio-pago.dto';

@Injectable()
export class MedioPagoService {
  constructor(
    @InjectRepository(MedioPago)
    private medioPagoRepository: Repository<MedioPago>,
  ) {}

  /**
   * Inicializar medios de pago por defecto al arrancar el módulo
   */
  async onModuleInit() {
    const count = await this.medioPagoRepository.count();

    if (count === 0) {
      const mediosPorDefecto = [
        { nombre: 'efectivo', requiereReferencia: false },
        { nombre: 'tarjeta_credito', requiereReferencia: true },
        { nombre: 'tarjeta_debito', requiereReferencia: true },
        { nombre: 'transferencia_bancaria', requiereReferencia: true },
        { nombre: 'nequi', requiereReferencia: true },
        { nombre: 'daviplata', requiereReferencia: true },
        { nombre: 'pse', requiereReferencia: true },
      ];

      await this.medioPagoRepository.save(mediosPorDefecto);
    }
  }

  /**
   * Obtener todos los medios de pago activos
   */
  async findAll(): Promise<MedioPago[]> {
    return this.medioPagoRepository.find({
      where: { activo: true },
      order: { nombre: 'ASC' },
    });
  }

  /**
   * Obtener un medio de pago por ID
   */
  async findOne(id: number): Promise<MedioPago> {
    const medioPago = await this.medioPagoRepository.findOne({ where: { id } });

    if (!medioPago) {
      throw new NotFoundException(`Medio de pago con ID ${id} no encontrado`);
    }

    return medioPago;
  }

  /**
   * Crear un nuevo medio de pago
   */
  async create(dto: CreateMedioPagoDto): Promise<MedioPago> {
    const medioPago = this.medioPagoRepository.create({
      nombre: dto.nombre.toLowerCase(),
      descripcion: dto.descripcion || '',
      requiereReferencia: dto.requiereReferencia || false,
      activo: true,
    });

    return this.medioPagoRepository.save(medioPago);
  }

  /**
   * Activar o desactivar un medio de pago
   */
  async toggleActivo(id: number): Promise<MedioPago> {
    const medioPago = await this.findOne(id);
    medioPago.activo = !medioPago.activo;
    return this.medioPagoRepository.save(medioPago);
  }
}
