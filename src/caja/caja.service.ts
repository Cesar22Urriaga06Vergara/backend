import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { roundMoney } from '../common/utils/money.util';
import { CajaTurno } from './entities/caja-turno.entity';
import { CajaMovimiento } from './entities/caja-movimiento.entity';
import { AbrirCajaTurnoDto, CerrarCajaTurnoDto, CrearCajaMovimientoDto } from './dto/caja.dto';

@Injectable()
export class CajaService {
  constructor(
    @InjectRepository(CajaTurno)
    private readonly turnoRepository: Repository<CajaTurno>,
    @InjectRepository(CajaMovimiento)
    private readonly movimientoRepository: Repository<CajaMovimiento>,
    private readonly dataSource: DataSource,
  ) {}

  async abrirTurno(idHotel: number, idUsuario: number, dto: AbrirCajaTurnoDto) {
    if (!idHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel para abrir caja');
    }

    const existente = await this.turnoRepository.findOne({
      where: { idHotel, estado: 'ABIERTA' },
    });

    if (existente) {
      throw new BadRequestException('Ya existe una caja abierta para este hotel');
    }

    const montoInicial = roundMoney(dto.montoInicial);
    const turno = this.turnoRepository.create({
      idHotel,
      idUsuarioApertura: idUsuario,
      estado: 'ABIERTA',
      montoInicial,
      totalIngresos: 0,
      totalEgresos: 0,
      totalEsperado: montoInicial,
      observacionesApertura: dto.observaciones || null,
    });

    const guardado = await this.turnoRepository.save(turno);
    return this.obtenerResumenTurno(guardado.id);
  }

  async obtenerTurnoAbierto(idHotel: number) {
    if (!idHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel');
    }

    const turno = await this.turnoRepository.findOne({
      where: { idHotel, estado: 'ABIERTA' },
      order: { fechaApertura: 'DESC' },
    });

    if (!turno) {
      return null;
    }

    return this.obtenerResumenTurno(turno.id);
  }

  async obtenerResumenTurno(idTurno: number) {
    const turno = await this.turnoRepository.findOne({
      where: { id: idTurno },
      relations: ['movimientos'],
    });

    if (!turno) {
      throw new NotFoundException('Turno de caja no encontrado');
    }

    const movimientos = [...(turno.movimientos || [])].sort(
      (a, b) => new Date(b.fechaMovimiento).getTime() - new Date(a.fechaMovimiento).getTime(),
    );
    const totalIngresos = roundMoney(
      movimientos
        .filter((movimiento) => movimiento.tipo === 'INGRESO')
        .reduce((sum, movimiento) => sum + Number(movimiento.monto || 0), 0),
    );
    const totalEgresos = roundMoney(
      movimientos
        .filter((movimiento) => movimiento.tipo === 'EGRESO')
        .reduce((sum, movimiento) => sum + Number(movimiento.monto || 0), 0),
    );
    const totalEsperado = roundMoney(Number(turno.montoInicial || 0) + totalIngresos - totalEgresos);

    return {
      ...turno,
      montoInicial: roundMoney(turno.montoInicial),
      totalIngresos,
      totalEgresos,
      totalEsperado,
      montoContado: turno.montoContado == null ? null : roundMoney(turno.montoContado),
      diferencia: turno.diferencia == null ? null : roundMoney(turno.diferencia),
      movimientos: movimientos.map((movimiento) => ({
        ...movimiento,
        monto: roundMoney(movimiento.monto),
      })),
    };
  }

  async listarTurnos(idHotel: number, limit = 50) {
    const turnos = await this.turnoRepository.find({
      where: { idHotel },
      order: { fechaApertura: 'DESC' },
      take: Math.min(Math.max(limit, 1), 100),
    });

    return turnos.map((turno) => ({
      ...turno,
      montoInicial: roundMoney(turno.montoInicial),
      totalIngresos: roundMoney(turno.totalIngresos),
      totalEgresos: roundMoney(turno.totalEgresos),
      totalEsperado: roundMoney(turno.totalEsperado),
      montoContado: turno.montoContado == null ? null : roundMoney(turno.montoContado),
      diferencia: turno.diferencia == null ? null : roundMoney(turno.diferencia),
    }));
  }

  async registrarMovimiento(idHotel: number, idUsuario: number, dto: CrearCajaMovimientoDto) {
    return this.registrarMovimientoEnTurno(idHotel, idUsuario, dto);
  }

  async registrarMovimientoSistema(
    idHotel: number,
    idUsuario: number,
    dto: CrearCajaMovimientoDto,
  ) {
    return this.registrarMovimientoEnTurno(idHotel, idUsuario, dto);
  }

  private async registrarMovimientoEnTurno(
    idHotel: number,
    idUsuario: number,
    dto: CrearCajaMovimientoDto,
  ) {
    if (!idHotel) {
      throw new BadRequestException('Usuario debe estar asignado a un hotel');
    }

    const monto = roundMoney(dto.monto);
    if (monto <= 0) {
      throw new BadRequestException('El movimiento debe tener monto mayor a cero');
    }

    return this.dataSource.transaction(async (manager) => {
      const turno = await manager.findOne(CajaTurno, {
        where: { idHotel, estado: 'ABIERTA' },
        lock: { mode: 'pessimistic_write' },
      });

      if (!turno) {
        throw new BadRequestException('Debe abrir caja antes de registrar pagos o movimientos');
      }

      const movimiento = manager.create(CajaMovimiento, {
        idTurno: turno.id,
        idHotel,
        idUsuario,
        tipo: dto.tipo,
        origen: dto.origen || 'MANUAL',
        monto,
        idMedioPago: dto.idMedioPago || null,
        metodoPago: dto.metodoPago || null,
        concepto: dto.concepto,
        referencia: dto.referencia || null,
        idFolio: dto.idFolio || null,
        idFactura: dto.idFactura || null,
        observaciones: dto.observaciones || null,
      });

      const guardado = await manager.save(CajaMovimiento, movimiento);

      if (dto.tipo === 'INGRESO') {
        turno.totalIngresos = roundMoney(Number(turno.totalIngresos || 0) + monto);
      } else {
        turno.totalEgresos = roundMoney(Number(turno.totalEgresos || 0) + monto);
      }
      turno.totalEsperado = roundMoney(
        Number(turno.montoInicial || 0) + Number(turno.totalIngresos || 0) - Number(turno.totalEgresos || 0),
      );

      await manager.save(CajaTurno, turno);

      return {
        ...guardado,
        monto: roundMoney(guardado.monto),
        turno: {
          id: turno.id,
          estado: turno.estado,
          totalIngresos: roundMoney(turno.totalIngresos),
          totalEgresos: roundMoney(turno.totalEgresos),
          totalEsperado: roundMoney(turno.totalEsperado),
        },
      };
    });
  }

  async cerrarTurno(idHotel: number, idUsuario: number, idTurno: number, dto: CerrarCajaTurnoDto) {
    return this.dataSource.transaction(async (manager) => {
      const turno = await manager.findOne(CajaTurno, {
        where: { id: idTurno, idHotel },
        relations: ['movimientos'],
        lock: { mode: 'pessimistic_write' },
      });

      if (!turno) {
        throw new NotFoundException('Turno de caja no encontrado');
      }

      if (turno.estado === 'CERRADA') {
        throw new BadRequestException('El turno ya esta cerrado');
      }

      const movimientos = turno.movimientos || [];
      const totalIngresos = roundMoney(
        movimientos
          .filter((movimiento) => movimiento.tipo === 'INGRESO')
          .reduce((sum, movimiento) => sum + Number(movimiento.monto || 0), 0),
      );
      const totalEgresos = roundMoney(
        movimientos
          .filter((movimiento) => movimiento.tipo === 'EGRESO')
          .reduce((sum, movimiento) => sum + Number(movimiento.monto || 0), 0),
      );
      const totalEsperado = roundMoney(Number(turno.montoInicial || 0) + totalIngresos - totalEgresos);
      const montoContado = roundMoney(dto.montoContado);

      turno.estado = 'CERRADA';
      turno.idUsuarioCierre = idUsuario;
      turno.fechaCierre = new Date();
      turno.totalIngresos = totalIngresos;
      turno.totalEgresos = totalEgresos;
      turno.totalEsperado = totalEsperado;
      turno.montoContado = montoContado;
      turno.diferencia = roundMoney(montoContado - totalEsperado);
      turno.observacionesCierre = dto.observaciones || null;

      const guardado = await manager.save(CajaTurno, turno);
      return this.obtenerResumenTurno(guardado.id);
    });
  }
}