/**
 * DTOs para reportes consolidados a nivel HOTEL
 * Usados por: Admin para ver todas las áreas en un dashboard
 *
 * SEGURIDAD: Requiere rol admin o superadmin
 * AUDITORÍA: Registra acceso a datos consolidados
 */

/**
 * Resumen de un área individual (para consolidado)
 */
export class AreaResumenDto {
  categoria: string;
  totalPedidos: number;
  ingresoTotal: number;
  ingresoEntregado: number;
  ingresoPendiente: number;
  ticketPromedio: number;
  tasaEntrega: number; // porcentaje
  tipoPrefijo: 'delivery' | 'recogida';
  contadores: {
    pendiente: number;
    en_preparacion: number;
    listo: number;
    entregado: number;
    cancelado: number;
  };
}

/**
 * KPI global del hotel
 */
export class HotelKpisDto {
  totalPedidos: number;
  totalIngresos: number;
  ingresoEntregado: number;
  ingresoPendiente: number;
  ticketPromedio: number;
  pedidosPorDia: number;
  tasaEntregaGlobal: number;
  areaConMasIngresos: {
    categoria: string;
    ingresos: number;
  };
  pedidosHoy: number;
  ingresosHoy: number;
  periodo: {
    desde: Date;
    hasta: Date;
  };
}

/**
 * Top N áreas por ingresos
 */
export class TopAreaDto {
  ranking: number;
  categoria: string;
  ingresos: number;
  pedidos: number;
  ticketPromedio: number;
  porcentajeDelTotal: number;
}

/**
 * Estadísticas de entrega (delivery vs recogida)
 */
export class EstadisticasEntregaConsolidadoDto {
  delivery: {
    cantidad: number;
    ingresos: number;
    porcentaje: number;
  };
  recogida: {
    cantidad: number;
    ingresos: number;
    porcentaje: number;
  };
}

/**
 * Respuesta PRINCIPAL para reportes consolidados del hotel
 */
export class HotelReportConsolidadoDto {
  idHotel: number;

  // KPIs principales
  kpis: HotelKpisDto;

  // Top 5 áreas
  topAreas: TopAreaDto[];

  // Desglose por área
  areasDetalle: AreaResumenDto[];

  // Estadísticas de entrega global
  estadisticasEntrega: EstadisticasEntregaConsolidadoDto;

  // Datos para gráfica de tendencia (últimos 30 días)
  tendencias: Array<{
    fecha: Date;
    pedidos: number;
    ingresos: number;
  }>;

  // Auditoría
  consultadoEn: Date;
  consultadoPor: {
    idEmpleado?: number;
    idAdmin: number;
    rol: string;
  };
}
