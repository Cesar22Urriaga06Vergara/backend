-- ========================================
-- MIGRACIÓN 007: Sistema de Incidencias
-- ========================================
-- Fecha: 2026-03-16
-- Descripción: Crear tabla para reportar y 
-- gestionar incidencias en habitaciones
-- ========================================

CREATE TABLE IF NOT EXISTS `room_incidents` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_reserva` INT(11) NOT NULL,
  `id_habitacion` INT(11) NOT NULL,
  `tipo` ENUM('daño', 'mantenimiento', 'limpieza', 'cliente_complaint', 'otros') NOT NULL DEFAULT 'otros',
  `estado` ENUM('reported', 'in_progress', 'resolved', 'cancelled') NOT NULL DEFAULT 'reported',
  `descripcion` TEXT NOT NULL,
  `id_reportador` INT(11) NULL,
  `tipo_reportador` VARCHAR(50) NULL,
  `id_empleado_atiende` INT(11) NULL,
  `nota_resolucion` TEXT NULL,
  `prioridad` ENUM('baja', 'media', 'alta', 'urgente') NOT NULL DEFAULT 'media',
  `cargo_adicional` DECIMAL(12, 2) NULL,
  `descripcion_cargo` VARCHAR(255) NULL,
  `fecha_reporte` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `fecha_resolucion` DATETIME NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `FK_room_incidents_reserva` (`id_reserva`),
  KEY `FK_room_incidents_habitacion` (`id_habitacion`),
  KEY `IDX_room_incidents_estado` (`estado`),
  KEY `IDX_room_incidents_tipo` (`tipo`),
  CONSTRAINT `FK_room_incidents_reserva` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_room_incidents_habitacion` FOREIGN KEY (`id_habitacion`) REFERENCES `habitaciones` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ========================================
-- Índices para búsquedas comunes
-- ========================================
CREATE INDEX `IDX_room_incidents_reserva_estado` ON `room_incidents` (`id_reserva`, `estado`);
CREATE INDEX `IDX_room_incidents_habitacion_estado` ON `room_incidents` (`id_habitacion`, `estado`);
CREATE INDEX `IDX_room_incidents_fecha_estado` ON `room_incidents` (`fecha_reporte`, `estado`);

-- ========================================
-- Nota: Sistema de incidencias permite:
-- 1. Reportar daños, mantenimiento, limpieza
-- 2. Registrar quejas de clientes
-- 3. Asignar empleados para resolver
-- 4. Cargar monto adicional en factura
-- ========================================
