import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { JwtPayload } from '../interfaces/jwt-payload.interface';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET') || 'secret',
    } as any);
  }

  async validate(payload: JwtPayload) {
    console.log('🔐 JWT Strategy - Validating token:', { 
      sub: payload.sub, 
      email: payload.email, 
      rol: payload.rol 
    });
    
    if (!payload.sub || !payload.email || !payload.rol) {
      console.error('❌ JWT Strategy - Token validation failed: missing fields', payload);
      throw new UnauthorizedException('Token inválido');
    }

    const user = {
      id: payload.sub,
      sub: payload.sub,
      email: payload.email,
      rol: payload.rol,
      idHotel: payload.idHotel,
      idCliente: payload.idCliente,
      idEmpleado: payload.idEmpleado,
    };
    
    console.log('✅ JWT Strategy - Token validated, user:', user);
    return user;
  }
}
