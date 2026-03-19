-- ========================================
-- MIGRACIÓN 008: Soft-Delete + Auditoría
-- ========================================
-- Fecha: 2026-03-16
-- Descripción: 
--   1. Agregar campos deleted_at y deleted_by a entidades
--   2. Crear tabla audit_logs para auditoría de cambios
--   3. Crear índices para soft-delete queries
-- ========================================

-- 1. Tabla de auditoría
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `entidad` VARCHAR(100) NOT NULL,
  `id_entidad` INT(11) NOT NULL,
  `operacion` ENUM('CREATE', 'UPDATE', 'DELETE', 'RESTORE') NOT NULL,
  `usuario_id` INT(11) NULL,
  `usuario_email` VARCHAR(255) NULL,
  `usuario_rol` VARCHAR(100) NULL,
  `cambios` LONGTEXT NULL,
  `descripcion` TEXT NULL,
  `ip_address` VARCHAR(50) NULL,
  `user_agent` VARCHAR(500) NULL,
  `accion` VARCHAR(255) NULL,
  `fecha` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_audit_entidad` (`entidad`, `id_entidad`, `fecha`),
  KEY `IDX_audit_usuario` (`usuario_id`, `fecha`),
  KEY `IDX_audit_operacion` (`operacion`),
  KEY `IDX_audit_fecha` (`fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. Agregar campos de soft-delete a clientes
ALTER TABLE `clientes` 
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updatedAt`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_clientes_deleted_at` ON `clientes` (`deleted_at`);

-- 3. Agregar soft-delete a empleados
ALTER TABLE `empleados`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updatedAt`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_empleados_deleted_at` ON `empleados` (`deleted_at`);

-- 4. Agregar soft-delete a servicios
ALTER TABLE `servicios`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updated_at`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_servicios_deleted_at` ON `servicios` (`deleted_at`);

-- 5. Agregar soft-delete a reservas
ALTER TABLE `reservas`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updated_at`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_reservas_deleted_at` ON `reservas` (`deleted_at`);

-- 6. Agregar soft-delete a pedidos
ALTER TABLE `pedidos`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `fecha_actualizacion`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_pedidos_deleted_at` ON `pedidos` (`deleted_at`);

-- 7. Agregar soft-delete a facturas
ALTER TABLE `facturas`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updated_at`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_facturas_deleted_at` ON `facturas` (`deleted_at`);

-- 8. Agregar soft-delete a pagos
ALTER TABLE `pagos`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL,
ADD COLUMN `deleted_by` INT(11) NULL;

CREATE INDEX `IDX_pagos_deleted_at` ON `pagos` (`deleted_at`);

-- 9. Agregar soft-delete a habitaciones
ALTER TABLE `habitaciones`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updated_at`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_habitaciones_deleted_at` ON `habitaciones` (`deleted_at`);

-- 10. Agregar soft-delete a tipos_habitacion
ALTER TABLE `tipos_habitacion`
ADD COLUMN `deleted_at` DATETIME NULL DEFAULT NULL AFTER `updated_at`,
ADD COLUMN `deleted_by` INT(11) NULL AFTER `deleted_at`;

CREATE INDEX `IDX_tipos_habitacion_deleted_at` ON `tipos_habitacion` (`deleted_at`);

-- ========================================
-- Patrón de consulta para Soft-Delete:
-- SELECT * FROM tabla WHERE deleted_at IS NULL
-- 
-- Para ver eliminados:
-- SELECT * FROM tabla WHERE deleted_at IS NOT NULL
-- 
-- Solo SuperAdmin ve registros eliminados
-- ========================================
