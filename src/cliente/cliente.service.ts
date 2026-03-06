import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cliente } from './entities/cliente.entity';
import { User } from '../user/entities/user.entity';
import { CreateClienteDto } from './dto/create-cliente.dto';

@Injectable()
export class ClienteService {
  constructor(
    @InjectRepository(Cliente)
    private clienteRepository: Repository<Cliente>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  /**
   * Crear un nuevo cliente
   */
  async create(createClienteDto: CreateClienteDto): Promise<Cliente> {
    const cliente = this.clienteRepository.create(createClienteDto);
    return await this.clienteRepository.save(cliente);
  }

  /**
   * Obtener todos los clientes
   */
  async findAll(): Promise<Cliente[]> {
    return await this.clienteRepository.find();
  }

  /**
   * Obtener un cliente por ID
   */
  async findOne(id: number): Promise<Cliente> {
    const cliente = await this.clienteRepository.findOne({ where: { id } });

    if (!cliente) {
      throw new NotFoundException(`Cliente con ID ${id} no encontrado`);
    }

    return cliente;
  }

  /**
   * Obtener un cliente por ID de usuario
   */
  async findByUsuarioId(idUsuario: number): Promise<Cliente | null> {
    return await this.clienteRepository.findOne({ where: { idUsuario } });
  }

  /**
   * Actualizar un cliente y sincronizar con usuario
   */
  async update(id: number, updateClienteDto: Partial<Cliente>): Promise<Cliente> {
    const cliente = await this.findOne(id);
    Object.assign(cliente, updateClienteDto);
    const clienteActualizado = await this.clienteRepository.save(cliente);

    // Sincronizar con tabla users si se actualiza nombre o apellido
    if (updateClienteDto.nombre || updateClienteDto.apellido) {
      const usuario = await this.userRepository.findOne({ where: { idCliente: id } });
      if (usuario) {
        const nombre = updateClienteDto.nombre || cliente.nombre;
        const apellido = updateClienteDto.apellido || cliente.apellido;
        usuario.fullName = `${nombre} ${apellido}`.trim();
        await this.userRepository.save(usuario);
      }
    }

    return clienteActualizado;
  }

  /**
   * Eliminar un cliente
   */
  async remove(id: number): Promise<void> {
    const cliente = await this.findOne(id);
    await this.clienteRepository.remove(cliente);
  }
}
