-- ADUS Hospitality OS: configuracion fiscal/POS dinamica del hotel
-- Requerido para separar marca del software y datos comerciales del hotel.
-- Idempotente para MySQL/MariaDB mediante INFORMATION_SCHEMA.

DROP PROCEDURE IF EXISTS add_hotel_column_if_missing;

DELIMITER $$
CREATE PROCEDURE add_hotel_column_if_missing(
  IN column_name_to_add VARCHAR(64),
  IN ddl_fragment TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'hoteles'
      AND COLUMN_NAME = column_name_to_add
  ) THEN
    SET @ddl = CONCAT('ALTER TABLE hoteles ', ddl_fragment);
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END$$
DELIMITER ;

CALL add_hotel_column_if_missing('razon_social', 'ADD COLUMN razon_social VARCHAR(150) NULL AFTER nit');
CALL add_hotel_column_if_missing('logo_url', 'ADD COLUMN logo_url VARCHAR(500) NULL AFTER descripcion');
CALL add_hotel_column_if_missing('resolucion_facturacion', 'ADD COLUMN resolucion_facturacion VARCHAR(255) NULL AFTER logo_url');
CALL add_hotel_column_if_missing('prefijo_facturacion', 'ADD COLUMN prefijo_facturacion VARCHAR(20) NULL AFTER resolucion_facturacion');
CALL add_hotel_column_if_missing('pie_factura', 'ADD COLUMN pie_factura TEXT NULL AFTER prefijo_facturacion');
CALL add_hotel_column_if_missing('moneda', "ADD COLUMN moneda VARCHAR(3) NOT NULL DEFAULT 'COP' AFTER pie_factura");
CALL add_hotel_column_if_missing('pos_formato_default', "ADD COLUMN pos_formato_default VARCHAR(4) NOT NULL DEFAULT '80mm' AFTER moneda");

DROP PROCEDURE IF EXISTS add_hotel_column_if_missing;