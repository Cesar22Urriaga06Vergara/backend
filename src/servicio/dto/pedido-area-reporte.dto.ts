/**
 * DTO para respuesta de reportes financieros de áreas
 * ⚠️ SENSIBLE: Incluye datos financieros
 * Usado en: GET /servicios/reportes/area/:idHotel/:categoria (endpoint segregado)
 * Roles: cafeteria, lavanderia, spa, room_service (su categoría), admin, superadmin
 *
 * IMPORTANTE: Este endpoint logea acceso a nivel de auditoría
 * (quién, cuándo, qué datos precisos consultó)
 */
export class PedidoAreaReporteDto {
  id: number;

  // Referencia a reserva
  idReserva: number;

  // Tipo de entrega
  tipoEntrega: 'delivery' | 'recogida';

  // Estado del pedido
  estadoPedido: 'pendiente' | 'en_preparacion' | 'listo' | 'entregado' | 'cancelado';

  // Categoría del área
  categoria: string;

  // Notas
  notaCliente?: string;
  notaEmpleado?: string;

  // Timestamp
  fechaPedido: Date;

  // ✅ INCLUIDO EN REPORTES: Totales para análisis financiero
  totalPedido: number; // Agregado total del pedido

  // Items CON información de precios
  items: {
    id: number;
    idServicio: number;
    nombreServicioSnapshot: string;
    cantidad: number;
    precioUnitarioSnapshot: number; // ← Incluido en reportes
    subtotal: number; // ← Incluido en reportes
    observacion?: string;
  }[];

  // ⚠️ NOTA IMPORTANTE sobre idCliente:
  // NO se incluye incluso en reportes, es dato personal sensible
  // Las áreas reportan por categoría, no por cliente individual
  // Si necesitan analytics por cliente → requiere endpoint especial + autorización
}

/**
 * Respuesta agregada de reportes de área
 * Agrupa información para dashboards y análisis
 */
export class AreaReportsResumenDto {
  categoria: string;
  periodo: {
    desde: Date;
    hasta: Date;
  };

  // Contadores por estado
  contadores: {
    total: number;
    pendiente: number;
    en_preparacion: number;
    listo: number;
    entregado: number;
    cancelado: number;
  };

  // Análisis financiero
  financiero: {
    ingresoTotal: number; // Suma de todos los totalPedido completados
    ingresoPendiente: number; // Suma de pedidos pendientes/preparacion (proyectado)
    ingresoEntregado: number; // Suma de pedidos entregados
    promedioPorPedido: number;
    ticketPromedio: number;
  };

  // Top productos vendidos
  topProductos: Array<{
    idServicio: number;
    nombre: string;
    cantidadVendida: number;
    ingresoGenerado: number;
  }>;

  // Tipo de entrega preferido
  estadisticasEntrega: {
    delivery: { cantidad: number; ingresos: number };
    recogida: { cantidad: number; ingresos: number };
  };

  // Timestamp de consulta (auditoría)
  consultadoEn: Date;
  consultadoPor: {
    idEmpleado?: number;
    rol: string; // cafeteria, admin, etc.
  };
}
