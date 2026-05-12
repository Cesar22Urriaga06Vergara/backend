-- ADUS Hospitality OS: resoluciones de facturacion por hotel/sucursal.
-- Permite probar facturacion en desarrollo sin datos DIAN reales.
-- Los documentos comerciales usan datos del hotel, no la marca del software.

CREATE TABLE IF NOT EXISTS resoluciones_facturacion (
  id INT NOT NULL AUTO_INCREMENT,
  id_hotel INT NOT NULL,
  numero_resolucion VARCHAR(80) NOT NULL,
  prefijo VARCHAR(20) NOT NULL,
  fecha_resolucion DATE NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  rango_desde INT NOT NULL,
  rango_hasta INT NOT NULL,
  numero_actual INT NOT NULL DEFAULT 0,
  tipo_documento VARCHAR(40) NOT NULL DEFAULT 'factura_venta',
  ambiente ENUM('desarrollo', 'produccion') NOT NULL DEFAULT 'desarrollo',
  estado ENUM('activa', 'inactiva', 'vencida', 'agotada') NOT NULL DEFAULT 'activa',
  observaciones TEXT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  INDEX idx_resoluciones_hotel_estado (id_hotel, estado),
  INDEX idx_resoluciones_hotel_prefijo (id_hotel, prefijo),
  CONSTRAINT fk_resoluciones_facturacion_hoteles
    FOREIGN KEY (id_hotel) REFERENCES hoteles(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP PROCEDURE IF EXISTS add_factura_column_if_missing;

DELIMITER $$
CREATE PROCEDURE add_factura_column_if_missing(
  IN column_name_to_add VARCHAR(64),
  IN ddl_fragment TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'facturas'
      AND COLUMN_NAME = column_name_to_add
  ) THEN
    SET @ddl = CONCAT('ALTER TABLE facturas ', ddl_fragment);
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END$$
DELIMITER ;

CALL add_factura_column_if_missing('id_resolucion_facturacion', 'ADD COLUMN id_resolucion_facturacion INT NULL AFTER id_hotel');
CALL add_factura_column_if_missing('prefijo_factura', 'ADD COLUMN prefijo_factura VARCHAR(20) NULL AFTER id_resolucion_facturacion');
CALL add_factura_column_if_missing('consecutivo_factura', 'ADD COLUMN consecutivo_factura INT NULL AFTER prefijo_factura');
CALL add_factura_column_if_missing('resolucion_numero', 'ADD COLUMN resolucion_numero VARCHAR(80) NULL AFTER consecutivo_factura');

DROP PROCEDURE IF EXISTS add_factura_column_if_missing;

DROP PROCEDURE IF EXISTS add_index_if_missing;

DELIMITER $$
CREATE PROCEDURE add_index_if_missing(
  IN table_name_to_alter VARCHAR(64),
  IN index_name_to_add VARCHAR(64),
  IN index_columns TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = table_name_to_alter
      AND INDEX_NAME = index_name_to_add
  ) THEN
    SET @ddl = CONCAT('ALTER TABLE ', table_name_to_alter, ' ADD INDEX ', index_name_to_add, ' (', index_columns, ')');
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END$$
DELIMITER ;

CALL add_index_if_missing('facturas', 'idx_facturas_resolucion', 'id_resolucion_facturacion');
CALL add_index_if_missing('facturas', 'idx_facturas_prefijo_consecutivo', 'prefijo_factura, consecutivo_factura');

DROP PROCEDURE IF EXISTS add_index_if_missing;

DROP PROCEDURE IF EXISTS add_fk_if_missing;

DELIMITER $$
CREATE PROCEDURE add_fk_if_missing(
  IN table_name_to_alter VARCHAR(64),
  IN constraint_name_to_add VARCHAR(64),
  IN ddl_fragment TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = table_name_to_alter
      AND CONSTRAINT_NAME = constraint_name_to_add
  ) THEN
    SET @ddl = CONCAT('ALTER TABLE ', table_name_to_alter, ' ADD CONSTRAINT ', constraint_name_to_add, ' ', ddl_fragment);
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END$$
DELIMITER ;

CALL add_fk_if_missing(
  'facturas',
  'fk_facturas_resolucion_facturacion',
  'FOREIGN KEY (id_resolucion_facturacion) REFERENCES resoluciones_facturacion(id) ON UPDATE CASCADE ON DELETE SET NULL'
);

DROP PROCEDURE IF EXISTS add_fk_if_missing;

SET @hotel_valhalla_id := (SELECT id FROM hoteles WHERE nombre = 'Hotel Valhalla' ORDER BY id LIMIT 1);
SET @hotel_valhalla_id := COALESCE(@hotel_valhalla_id, 1);

INSERT INTO resoluciones_facturacion (
  id_hotel,
  numero_resolucion,
  prefijo,
  fecha_resolucion,
  fecha_inicio,
  fecha_fin,
  rango_desde,
  rango_hasta,
  numero_actual,
  tipo_documento,
  ambiente,
  estado,
  observaciones
)
SELECT
  @hotel_valhalla_id,
  'DEV-VALHALLA-2026',
  'FV',
  '2026-01-01',
  '2026-01-01',
  '2030-12-31',
  1,
  999999,
  0,
  'factura_venta',
  'desarrollo',
  'activa',
  'Resolucion ficticia para desarrollo local. No usar como dato fiscal real.'
WHERE EXISTS (SELECT 1 FROM hoteles WHERE id = @hotel_valhalla_id)
  AND NOT EXISTS (
    SELECT 1
    FROM resoluciones_facturacion
    WHERE id_hotel = @hotel_valhalla_id
      AND estado = 'activa'
  );