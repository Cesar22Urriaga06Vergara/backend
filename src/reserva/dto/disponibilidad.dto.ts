export class HabitacionDisponibleDto {
  id: number;
  numeroHabitacion: string;
  piso?: string;
  imagenes?: string;
  tipoHabitacionId: number;
  tipoHabitacionNombre: string;
  capacidadPersonas: number;
  precioBase: number;
  amenidades: {
    id: number;
    nombre: string;
    icono?: string;
  }[];
  disponibleDesde: Date;
  disponibleHasta: Date;
}

export class DisponibilidadResponseDto {
  idHotel: number;
  checkinFecha: Date;
  checkoutFecha: Date;
  numeroNoches: number;
  habitacionesDisponibles: HabitacionDisponibleDto[];
  totalDisponibles: number;
  tiposHabitacionDisponibles: {
    id: number;
    nombre: string;
    cantidad: number;
  }[];
}
