/**
 * DTO para respuesta operacional de pedidos en las áreas
 * ✅ SEGURO: Sin datos financieros ni personales
 * Usado en: GET /servicios/pedidos/area/:idHotel/:categoria
 * Roles: cafeteria, lavanderia, spa, room_service, admin, superadmin
 */
export class PedidoAreaResponseDto {
  id: number;

  // Referencia a reserva (para contexto de QR/habitación)
  idReserva: number;

  // Tipo de entrega (forma operacional de trabajo)
  tipoEntrega: 'delivery' | 'recogida';

  // Estado del pedido (para workflow)
  estadoPedido: 'pendiente' | 'en_preparacion' | 'listo' | 'entregado' | 'cancelado';

  // Categoría del área (redundante pero útil para filtros)
  categoria: string;

  // Notas del cliente (pueden contener instrucciones importantes)
  notaCliente?: string;

  // Notas del empleado (para coordinación interna)
  notaEmpleado?: string;

  // Timestamp operacional
  fechaPedido: Date;

  // Items SIN información de precios
  items: {
    id: number;
    idServicio: number;
    nombreServicioSnapshot: string;
    cantidad: number;
    observacion?: string;
  }[];

  // ❌ EXCLUIDOS INTENCIONALMENTE:
  // - totalPedido (dato financiero)
  // - idCliente (dato personal)
  // - precioUnitarioSnapshot en items (dato financiero)
  // - subtotal en items (dato financiero)
}
