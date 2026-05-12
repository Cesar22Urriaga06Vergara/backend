-- FASE CAJA: Crear turnos y movimientos de caja
-- ADUS Hospitality OS - caja operativa basica por hotel/turno

CREATE TABLE IF NOT EXISTS caja_turnos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_hotel INT NOT NULL,
  id_usuario_apertura INT NOT NULL,
  id_usuario_cierre INT DEFAULT NULL,
  estado ENUM('ABIERTA', 'CERRADA') NOT NULL DEFAULT 'ABIERTA',
  monto_inicial DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_ingresos DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_egresos DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_esperado DECIMAL(12,2) NOT NULL DEFAULT 0,
  monto_contado DECIMAL(12,2) DEFAULT NULL,
  diferencia DECIMAL(12,2) DEFAULT NULL,
  observaciones_apertura TEXT DEFAULT NULL,
  observaciones_cierre TEXT DEFAULT NULL,
  fecha_apertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_cierre DATETIME DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_caja_turnos_hotel FOREIGN KEY (id_hotel) REFERENCES hoteles(id) ON DELETE RESTRICT,
  CONSTRAINT fk_caja_turnos_usuario_apertura FOREIGN KEY (id_usuario_apertura) REFERENCES empleados(id) ON DELETE RESTRICT,
  CONSTRAINT fk_caja_turnos_usuario_cierre FOREIGN KEY (id_usuario_cierre) REFERENCES empleados(id) ON DELETE SET NULL,

  INDEX idx_caja_turnos_hotel_estado (id_hotel, estado),
  INDEX idx_caja_turnos_fecha_apertura (fecha_apertura)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS caja_movimientos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_turno INT NOT NULL,
  id_hotel INT NOT NULL,
  id_usuario INT NOT NULL,
  tipo ENUM('INGRESO', 'EGRESO') NOT NULL,
  origen ENUM('MANUAL', 'FOLIO', 'FACTURA', 'DEVOLUCION', 'AJUSTE') NOT NULL DEFAULT 'MANUAL',
  monto DECIMAL(12,2) NOT NULL,
  id_medio_pago INT DEFAULT NULL,
  metodo_pago VARCHAR(60) DEFAULT NULL,
  concepto VARCHAR(180) NOT NULL,
  referencia VARCHAR(120) DEFAULT NULL,
  id_folio INT DEFAULT NULL,
  id_factura INT DEFAULT NULL,
  observaciones TEXT DEFAULT NULL,
  fecha_movimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_caja_movimientos_turno FOREIGN KEY (id_turno) REFERENCES caja_turnos(id) ON DELETE RESTRICT,
  CONSTRAINT fk_caja_movimientos_hotel FOREIGN KEY (id_hotel) REFERENCES hoteles(id) ON DELETE RESTRICT,
  CONSTRAINT fk_caja_movimientos_usuario FOREIGN KEY (id_usuario) REFERENCES empleados(id) ON DELETE RESTRICT,
  CONSTRAINT fk_caja_movimientos_medio_pago FOREIGN KEY (id_medio_pago) REFERENCES medios_pago(id) ON DELETE SET NULL,
  CONSTRAINT fk_caja_movimientos_folio FOREIGN KEY (id_folio) REFERENCES folios(id) ON DELETE SET NULL,
  CONSTRAINT fk_caja_movimientos_factura FOREIGN KEY (id_factura) REFERENCES facturas(id) ON DELETE SET NULL,

  INDEX idx_caja_movimientos_hotel_fecha (id_hotel, fecha_movimiento),
  INDEX idx_caja_movimientos_turno_tipo (id_turno, tipo),
  INDEX idx_caja_movimientos_origen (origen)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;