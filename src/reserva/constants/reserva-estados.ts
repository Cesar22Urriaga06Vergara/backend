/**
 * Estados de Reserva - Máquina de Estados
 * Define transiciones válidas entre estados de reserva
 */

export enum ReservaEstado {
  RESERVADA = 'reservada',
  CONFIRMADA = 'confirmada',
  COMPLETADA = 'completada',
  CANCELADA = 'cancelada',
  RECHAZADA = 'rechazada',
}

/**
 * Transiciones permitidas entre estados
 * Clave: estado actual → Valores: estados permitidos a los que transicionar
 */
export const TRANSICIONES_VALIDAS: Record<ReservaEstado, ReservaEstado[]> = {
  [ReservaEstado.RESERVADA]: [
    ReservaEstado.CONFIRMADA,
    ReservaEstado.CANCELADA,
    ReservaEstado.RECHAZADA,
  ],
  [ReservaEstado.CONFIRMADA]: [
    ReservaEstado.COMPLETADA,
    ReservaEstado.CANCELADA,
  ],
  [ReservaEstado.COMPLETADA]: [], // Terminal
  [ReservaEstado.CANCELADA]: [], // Terminal
  [ReservaEstado.RECHAZADA]: [], // Terminal
};

/**
 * Estados terminales - no se puede transicionar desde estos
 */
export const ESTADOS_TERMINALES = [
  ReservaEstado.COMPLETADA,
  ReservaEstado.CANCELADA,
  ReservaEstado.RECHAZADA,
];

/**
 * Validar si una transición de estado es válida
 * @param estadoActual Estado actual de la reserva
 * @param estadoNuevo Estado al que se quiere transicionar
 * @returns true si la transición es válida, false si no
 */
export function esTransicionValida(
  estadoActual: string,
  estadoNuevo: string,
): boolean {
  const estadosValidos = TRANSICIONES_VALIDAS[estadoActual as ReservaEstado];
  return estadosValidos?.includes(estadoNuevo as ReservaEstado) ?? false;
}

/**
 * Obtener todos los estados permitidos desde un estado actual
 * @param estadoActual Estado actual
 * @returns Array de estados válidos a los que se puede transicionar
 */
export function obtenerEstadosValidos(estadoActual: string): ReservaEstado[] {
  return TRANSICIONES_VALIDAS[estadoActual as ReservaEstado] || [];
}
