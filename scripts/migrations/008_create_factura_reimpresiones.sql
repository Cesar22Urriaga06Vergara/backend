-- ADUS Hospitality OS: auditoria de reimpresiones/descargas de facturas y tickets.

CREATE TABLE IF NOT EXISTS factura_reimpresiones (
  id INT NOT NULL AUTO_INCREMENT,
  id_factura INT NOT NULL,
  id_usuario INT NULL,
  usuario_rol VARCHAR(40) NULL,
  formato ENUM('ticket_pos', 'pdf_pos', 'pdf_a4') NOT NULL DEFAULT 'ticket_pos',
  tamano_pos VARCHAR(4) NULL,
  motivo VARCHAR(200) NULL,
  ip_origen VARCHAR(64) NULL,
  user_agent VARCHAR(500) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  INDEX idx_factura_reimpresiones_factura_fecha (id_factura, created_at),
  CONSTRAINT fk_factura_reimpresiones_facturas
    FOREIGN KEY (id_factura) REFERENCES facturas(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;