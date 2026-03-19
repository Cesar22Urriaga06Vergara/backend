-- ========================================
-- MIGRACIÓN 006: INC (Impuestos Colombia) 
-- y Control de Cambio (Efectivo)
-- ========================================
-- Fecha: 2026-03-16
-- Descripción: 
--   1. Agregar campo es_alcoholico a servicios
--   2. Agregar campos INC a detalle_facturas
--   3. Agregar campos INC a facturas
--   4. Agregar campos de cambio a pagos
-- ========================================

-- 1. Servicios: Marcar bebidas alcohólicas
ALTER TABLE `servicios` 
ADD COLUMN `es_alcoholico` TINYINT(1) NOT NULL DEFAULT 0 AFTER `categoria`;

-- Marcar bebidas alcohólicas existentes (Cerveza en minibar = ID 23)
UPDATE `servicios` SET `es_alcoholico` = 1 WHERE `id` = 23;

-- 2. Detalle de Facturas: Campos para INC por línea
ALTER TABLE `detalle_facturas` 
ADD COLUMN `porcentaje_inc` DECIMAL(5, 2) NULL DEFAULT NULL AFTER `total`,
ADD COLUMN `monto_inc` DECIMAL(12, 2) NULL DEFAULT 0.00 AFTER `porcentaje_inc`;

-- 3. Facturas: Montos de impuestos separados
ALTER TABLE `facturas`
ADD COLUMN `monto_inc` DECIMAL(12, 2) NULL DEFAULT 0.00 AFTER `monto_iva`,
ADD COLUMN `porcentaje_inc` DECIMAL(5, 2) NULL DEFAULT NULL AFTER `porcentaje_iva`;

-- 4. Pagos: Control de cambio (efectivo)
ALTER TABLE `pagos`
ADD COLUMN `monto_recibido` DECIMAL(12, 2) NULL DEFAULT NULL AFTER `monto`,
ADD COLUMN `cambio_devuelto` DECIMAL(12, 2) NULL DEFAULT 0.00 AFTER `monto_recibido`;

-- Índice para búsquedas de servicios alcohólicos
CREATE INDEX `IDX_servicios_alcoholico` ON `servicios` (`es_alcoholico`);

-- ========================================
-- Nota sobre INC en Colombia:
-- El INC (Impuesto Nacional al Consumo) 
-- se aplica a bebidas alcohólicas con 8%
-- Cálculo: subtotal_alcoholico * 0.08
-- ========================================
