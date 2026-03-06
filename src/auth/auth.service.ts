import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UserService } from '../user/user.service';
import { ClienteService } from '../cliente/cliente.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { JwtPayload } from 'src/auth/interfaces/jwt-payload.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly clienteService: ClienteService,
    private readonly jwtService: JwtService,
  ) {}

  /**
   * Registrar un nuevo usuario
   * Crea el usuario y retorna un token JWT
   */
  async register(registerDto: RegisterDto) {
    // Crear el usuario usando el servicio de usuarios
    let user = await this.userService.create(registerDto);

    // Si es cliente, crear automáticamente un registro en la tabla de clientes
    if (user.role === 'cliente') {
      const cliente = await this.clienteService.create({
        idUsuario: user.id,
        cedula: `TEMP_${user.id}`, // Temporal, puede ser actualizado luego
        nombre: user.fullName || 'Cliente',
        apellido: '',
        email: user.email,
      });

      // Actualizar el usuario con el idCliente
      user.idCliente = cliente.id;
      user = await this.userService.update(user.id, { idCliente: cliente.id } as any);
    }

    // Generar el token JWT y refreshToken
    const token = await this.generateToken(user.id, user.email, user.role);
    const refreshToken = await this.generateToken(user.id, user.email, user.role);

    return {
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        isActive: user.isActive,
        idEmpleado: user.idEmpleado,
        idCliente: user.idCliente,
      },
      token,
      refreshToken,
    };
  }

  /**
   * Login de usuario
   * Valida credenciales y retorna un token JWT
   */
  async login(loginDto: LoginDto) {
    const { email, password } = loginDto;

    // Buscar usuario por email (incluye password)
    let user = await this.userService.findOneByEmail(email);

    // Verificar si el usuario existe
    if (!user) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    // Verificar si el usuario está activo
    if (!user.isActive) {
      throw new UnauthorizedException('Usuario inactivo');
    }

    // Comparar contraseñas
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    // Si es cliente pero no tiene idCliente, crear uno automáticamente
    if (user.role === 'cliente' && !user.idCliente) {
      const cliente = await this.clienteService.create({
        idUsuario: user.id,
        cedula: `TEMP_${user.id}`,
        nombre: user.fullName || 'Cliente',
        apellido: '',
        email: user.email,
      });

      user.idCliente = cliente.id;
      user = await this.userService.update(user.id, { idCliente: cliente.id } as any);
    }

    // Generar el token JWT y refreshToken
    const token = await this.generateToken(user.id, user.email, user.role);
    const refreshToken = await this.generateToken(user.id, user.email, user.role);

    return {
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        isActive: user.isActive,
        idEmpleado: user.idEmpleado,
        idCliente: user.idCliente,
      },
      token,
      refreshToken,
    };
  }

  /**
   * Generar token JWT
   * Crea un token con el payload especificado
   */
  private async generateToken(
    userId: number,
    email: string,
    role: string,
  ): Promise <string> {
    const payload: JwtPayload = {
      sub: userId,
      email,
      role,
    };

    // Firmar y retornar el token
    return await this.jwtService.signAsync(payload);
  }

  /**
   * Validar token y retornar información del usuario
   */
  async validateToken(token: string) {
    try {
      const payload = await this.jwtService.verifyAsync(token);
      const user = await this.userService.findOne(payload.sub);
      return user;
    } catch (error) {
      throw new UnauthorizedException('Token inválido');
    }
  }
}