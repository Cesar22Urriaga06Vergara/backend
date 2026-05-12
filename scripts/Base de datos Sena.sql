-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.32-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.14.0.7169
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para hotel
CREATE DATABASE IF NOT EXISTS `hotel` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `hotel`;

-- Volcando estructura para tabla hotel.amenidades
CREATE TABLE IF NOT EXISTS `amenidades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `icono` varchar(255) DEFAULT NULL,
  `categoria` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_1ce2145a419f1331705a65196b` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.amenidades: ~10 rows (aproximadamente)
INSERT INTO `amenidades` (`id`, `nombre`, `icono`, `categoria`, `descripcion`, `created_at`, `updated_at`) VALUES
	(1, 'WiFi', 'mdi-wifi', 'Conectividad', 'Internet de alta velocidad', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(2, 'Aire acondicionado', 'mdi-air-conditioner', 'Clima', 'Control de temperatura', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(3, 'Televisor', 'mdi-television', 'Entretenimiento', 'TV pantalla plana', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(4, 'Baño privado', 'mdi-shower', 'Baño', 'Baño privado con ducha', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(5, 'Caja fuerte', 'mdi-lock', 'Seguridad', 'Caja de seguridad digital', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(6, 'Escritorio', 'mdi-desk', 'Trabajo', 'Área de trabajo ejecutiva', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(7, 'Closet', 'mdi-hanger', 'Muebles', 'Armario amplio', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(8, 'Balcón', 'mdi-balcony', 'Extras', 'Balcón privado', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(9, 'Jacuzzi', 'mdi-hot-tub', 'Lujo', 'Jacuzzi privado', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659'),
	(10, 'Sala', 'mdi-sofa', 'Lujo', 'Sala independiente', '2026-03-16 18:44:25.123659', '2026-03-16 18:44:25.123659');

-- Volcando estructura para tabla hotel.audit_logs
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entidad` varchar(100) NOT NULL,
  `id_entidad` int(11) NOT NULL,
  `operacion` enum('CREATE','UPDATE','DELETE','RESTORE') NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `usuario_email` varchar(255) DEFAULT NULL,
  `usuario_rol` varchar(255) DEFAULT NULL,
  `cambios` longtext DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `accion` varchar(255) DEFAULT NULL,
  `fecha` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `IDX_45db6eae248cdbe43a0a6b6ae7` (`fecha`),
  KEY `IDX_74a563e1de1019ff09ae26fcef` (`operacion`),
  KEY `IDX_af37712a5badb8f6d003c5b628` (`entidad`,`id_entidad`,`fecha`),
  KEY `IDX_d952d588cf9c12c9297c2e9161` (`usuario_id`,`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.audit_logs: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.caja_movimientos
CREATE TABLE IF NOT EXISTS `caja_movimientos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_turno` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo` enum('INGRESO','EGRESO') NOT NULL,
  `origen` enum('MANUAL','FOLIO','FACTURA','DEVOLUCION','AJUSTE') NOT NULL DEFAULT 'MANUAL',
  `monto` decimal(12,2) NOT NULL,
  `id_medio_pago` int(11) DEFAULT NULL,
  `metodo_pago` varchar(60) DEFAULT NULL,
  `concepto` varchar(180) NOT NULL,
  `referencia` varchar(120) DEFAULT NULL,
  `id_folio` int(11) DEFAULT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `fecha_movimiento` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_caja_movimientos_usuario` (`id_usuario`),
  KEY `fk_caja_movimientos_medio_pago` (`id_medio_pago`),
  KEY `fk_caja_movimientos_folio` (`id_folio`),
  KEY `fk_caja_movimientos_factura` (`id_factura`),
  KEY `idx_caja_movimientos_hotel_fecha` (`id_hotel`,`fecha_movimiento`),
  KEY `idx_caja_movimientos_turno_tipo` (`id_turno`,`tipo`),
  KEY `idx_caja_movimientos_origen` (`origen`),
  CONSTRAINT `fk_caja_movimientos_factura` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_caja_movimientos_folio` FOREIGN KEY (`id_folio`) REFERENCES `folios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_caja_movimientos_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id`),
  CONSTRAINT `fk_caja_movimientos_medio_pago` FOREIGN KEY (`id_medio_pago`) REFERENCES `medios_pago` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_caja_movimientos_turno` FOREIGN KEY (`id_turno`) REFERENCES `caja_turnos` (`id`),
  CONSTRAINT `fk_caja_movimientos_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `empleados` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla hotel.caja_movimientos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.caja_turnos
CREATE TABLE IF NOT EXISTS `caja_turnos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `id_usuario_apertura` int(11) NOT NULL,
  `id_usuario_cierre` int(11) DEFAULT NULL,
  `estado` enum('ABIERTA','CERRADA') NOT NULL DEFAULT 'ABIERTA',
  `monto_inicial` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_ingresos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_egresos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_esperado` decimal(12,2) NOT NULL DEFAULT 0.00,
  `monto_contado` decimal(12,2) DEFAULT NULL,
  `diferencia` decimal(12,2) DEFAULT NULL,
  `observaciones_apertura` text DEFAULT NULL,
  `observaciones_cierre` text DEFAULT NULL,
  `fecha_apertura` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_cierre` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_caja_turnos_usuario_apertura` (`id_usuario_apertura`),
  KEY `fk_caja_turnos_usuario_cierre` (`id_usuario_cierre`),
  KEY `idx_caja_turnos_hotel_estado` (`id_hotel`,`estado`),
  KEY `idx_caja_turnos_fecha_apertura` (`fecha_apertura`),
  CONSTRAINT `fk_caja_turnos_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id`),
  CONSTRAINT `fk_caja_turnos_usuario_apertura` FOREIGN KEY (`id_usuario_apertura`) REFERENCES `empleados` (`id`),
  CONSTRAINT `fk_caja_turnos_usuario_cierre` FOREIGN KEY (`id_usuario_cierre`) REFERENCES `empleados` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla hotel.caja_turnos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.categoria_servicios
CREATE TABLE IF NOT EXISTS `categoria_servicios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `codigo` varchar(50) NOT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_60f1e1714015ac845aee6781e7` (`codigo`),
  KEY `IDX_7b847dfaa13ab311a9007e6c34` (`activa`),
  KEY `IDX_52acf4ce9acb1afb5f718a1d4d` (`id_hotel`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.categoria_servicios: ~10 rows (aproximadamente)
INSERT INTO `categoria_servicios` (`id`, `id_hotel`, `nombre`, `descripcion`, `codigo`, `activa`, `created_at`, `updated_at`, `deleted_at`, `deleted_by`) VALUES
	(1, 1, 'Alojamiento', 'Hospedaje en habitaciones del hotel', 'ALOJAMIENTO', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(2, 1, 'Restaurante/Cafetería', 'Servicios de comidas y bebidas', 'RESTAURANTE', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(3, 1, 'Minibar/Tienda', 'Minibar, tienda y productos básicos', 'MINIBAR', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(4, 1, 'Lavandería', 'Servicios de lavado y planchado', 'LAVANDERIA', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(5, 1, 'Spa', 'Servicios de bienestar y masajes', 'SPA', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(6, 1, 'Room Service', 'Servicio a habitación (comidas, etc.)', 'ROOM_SERVICE', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(7, 1, 'Transporte', 'Transporte y traslados', 'TRANSPORTE', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(8, 1, 'Tours', 'Tours y excursiones', 'TOURS', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(9, 1, 'Eventos', 'Salonería, salones para eventos', 'EVENTOS', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL),
	(10, 1, 'Mantenimiento', 'Servicios internos de mantenimiento', 'MANTENIMIENTO', 1, '2026-03-19 15:17:47.334795', '2026-03-19 15:17:47.334795', NULL, NULL);

-- Volcando estructura para tabla hotel.clientes
CREATE TABLE IF NOT EXISTS `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cedula` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `tipoDocumento` varchar(255) DEFAULT NULL,
  `rol` varchar(255) NOT NULL DEFAULT 'cliente',
  `direccion` varchar(255) DEFAULT NULL,
  `paisNacionalidad` varchar(255) DEFAULT NULL,
  `paisResidencia` varchar(255) DEFAULT NULL,
  `idiomaPreferido` varchar(255) DEFAULT NULL,
  `fechaNacimiento` datetime DEFAULT NULL,
  `tipoVisa` varchar(255) DEFAULT NULL,
  `numeroVisa` varchar(255) DEFAULT NULL,
  `visaExpira` datetime DEFAULT NULL,
  `tax_profile` enum('RESIDENT','FOREIGN_TOURIST','ENTITY') NOT NULL DEFAULT 'RESIDENT',
  `tipo_documento_estandar` varchar(50) DEFAULT NULL,
  `documento_validado` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_validacion_documento` datetime DEFAULT NULL,
  `validado_por_usuario_id` int(11) DEFAULT NULL,
  `googleId` varchar(255) DEFAULT NULL,
  `photoUrl` varchar(255) DEFAULT NULL,
  `authProvider` varchar(255) NOT NULL DEFAULT 'local',
  `fecha_registro` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_28fa93cdc380ac510988890cce` (`cedula`),
  UNIQUE KEY `IDX_3cd5652ab34ca1a0a2c7a25531` (`email`),
  UNIQUE KEY `IDX_180e285c672066d3cca2ce1a8d` (`googleId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.clientes: ~0 rows (aproximadamente)
INSERT INTO `clientes` (`id`, `cedula`, `nombre`, `apellido`, `email`, `password`, `telefono`, `tipoDocumento`, `rol`, `direccion`, `paisNacionalidad`, `paisResidencia`, `idiomaPreferido`, `fechaNacimiento`, `tipoVisa`, `numeroVisa`, `visaExpira`, `tax_profile`, `tipo_documento_estandar`, `documento_validado`, `fecha_validacion_documento`, `validado_por_usuario_id`, `googleId`, `photoUrl`, `authProvider`, `fecha_registro`, `createdAt`, `updatedAt`, `deleted_at`, `deleted_by`) VALUES
	(1, '50919231', 'Juan', 'Sena', 'sena@gmail.com', '$2b$10$ImXMdOFf2..dji8vwaLq3./yeVrFmg5nE82Puqdc8IxlFNR7TBk76', '', 'CC', 'cliente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RESIDENT', NULL, 0, NULL, NULL, NULL, NULL, 'local', '2026-03-14 13:15:17.154991', '2026-03-14 13:15:17.154991', '2026-04-06 01:14:22.000000', NULL, NULL);

-- Volcando estructura para tabla hotel.detalle_factura_cambios
CREATE TABLE IF NOT EXISTS `detalle_factura_cambios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_detalle` int(11) NOT NULL,
  `tipo_cambio` enum('CAMBIO_ESTADO','CAMBIO_MONTO','CAMBIO_CANTIDAD','CREACION','ELIMINACION') NOT NULL,
  `descripcion` text NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `fecha` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `valor_anterior` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valor_anterior`)),
  `valor_nuevo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valor_nuevo`)),
  PRIMARY KEY (`id`),
  KEY `idx_detalle_fecha` (`id_detalle`,`fecha`),
  KEY `idx_tipo_cambio` (`tipo_cambio`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_detalle` (`id_detalle`),
  CONSTRAINT `FK_b1fc3f5f06918a3b710fa82a20d` FOREIGN KEY (`id_detalle`) REFERENCES `detalle_facturas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.detalle_factura_cambios: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.detalle_facturas
CREATE TABLE IF NOT EXISTS `detalle_facturas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) NOT NULL,
  `tipo_concepto` varchar(255) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `id_referencia` int(11) DEFAULT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `descuento` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL,
  `porcentaje_inc` decimal(5,2) DEFAULT NULL,
  `monto_inc` decimal(12,2) NOT NULL DEFAULT 0.00,
  `categoria_servicios_id` int(11) DEFAULT NULL,
  `categoria_nombre` varchar(255) DEFAULT NULL,
  `monto_iva` decimal(12,2) NOT NULL DEFAULT 0.00,
  `id_pedido` int(11) DEFAULT NULL,
  `estado` enum('PENDIENTE','ENTREGADO','CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (`id`),
  KEY `idx_factura_estado` (`id_factura`,`estado`),
  KEY `idx_estado` (`estado`),
  KEY `idx_pedido` (`id_pedido`),
  KEY `idx_factura` (`id_factura`),
  CONSTRAINT `FK_36f066d39e2deb62413491fa205` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_8c0face38acb83d9b55adb0e807` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.detalle_facturas: ~52 rows (aproximadamente)
INSERT INTO `detalle_facturas` (`id`, `id_factura`, `tipo_concepto`, `descripcion`, `id_referencia`, `cantidad`, `precio_unitario`, `subtotal`, `descuento`, `total`, `porcentaje_inc`, `monto_inc`, `categoria_servicios_id`, `categoria_nombre`, `monto_iva`, `id_pedido`, `estado`) VALUES
	(1, 2, 'habitacion', 'Habitación 101 - 1 noche(s) (16/3/2026 al 16/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(2, 3, 'habitacion', 'Habitación 101 - 1 noche(s) (16/3/2026 al 16/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(3, 3, 'servicio', 'Agua mineral (16/3/2026)', 1, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(4, 3, 'servicio', 'Café americano (16/3/2026)', 2, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(5, 3, 'servicio', 'Té aromático (16/3/2026)', 3, 1.00, 7000.00, 7000.00, 0.00, 7000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(6, 9, 'habitacion', 'Habitación 101 - 1 noche(s) (16/3/2026 al 17/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(7, 9, 'servicio', 'Agua mineral (17/3/2026)', 4, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(8, 9, 'servicio', 'Café americano (17/3/2026)', 5, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(9, 9, 'servicio', 'Cappuccino (17/3/2026)', 6, 1.00, 12000.00, 12000.00, 0.00, 12000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(10, 9, 'servicio', 'Chocolate caliente (17/3/2026)', 7, 1.00, 10000.00, 10000.00, 0.00, 10000.00, NULL, 0.00, NULL, NULL, 0.00, NULL, 'PENDIENTE'),
	(11, 10, 'habitacion', 'Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(12, 10, 'servicio', 'Agua mineral (19/3/2026)', 8, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(13, 10, 'servicio', 'Café americano (19/3/2026)', 9, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(14, 10, 'servicio', 'Cappuccino (19/3/2026)', 10, 1.00, 12000.00, 12000.00, 0.00, 12000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(15, 10, 'servicio', 'Chocolate caliente (19/3/2026)', 11, 1.00, 10000.00, 10000.00, 0.00, 10000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(16, 11, 'habitacion', 'Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(17, 12, 'habitacion', 'Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(18, 13, 'habitacion', 'Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(19, 14, 'habitacion', 'Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(20, 15, 'habitacion', 'Habitación 101 - 7 noche(s) (19/3/2026 al 26/3/2026)', 1, 7.00, 80000.00, 560000.00, 0.00, 560000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(21, 15, 'servicio', 'Agua mineral (19/3/2026)', 12, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(22, 15, 'servicio', 'Café americano (19/3/2026)', 13, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(23, 15, 'servicio', 'Cappuccino (19/3/2026)', 14, 1.00, 12000.00, 12000.00, 0.00, 12000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(24, 15, 'servicio', 'Chocolate caliente (19/3/2026)', 15, 1.00, 10000.00, 10000.00, 0.00, 10000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(25, 16, 'habitacion', 'Habitación 102 - 1 noche(s) (19/3/2026 al 20/3/2026)', 2, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(26, 16, 'servicio', 'Agua mineral (19/3/2026)', 16, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(27, 16, 'servicio', 'Café americano (19/3/2026)', 17, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(28, 16, 'servicio', 'Cappuccino (19/3/2026)', 18, 1.00, 12000.00, 12000.00, 0.00, 12000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(29, 16, 'servicio', 'Chocolate caliente (19/3/2026)', 19, 1.00, 10000.00, 10000.00, 0.00, 10000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(30, 17, 'habitacion', 'Habitación 101 - 1 noche(s) (19/3/2026 al 20/3/2026)', 1, 1.00, 80000.00, 80000.00, 0.00, 80000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(31, 17, 'servicio', 'Agua mineral (19/3/2026)', 20, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(32, 17, 'servicio', 'Café americano (19/3/2026)', 21, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(33, 17, 'servicio', 'Cappuccino (19/3/2026)', 22, 1.00, 12000.00, 12000.00, 0.00, 12000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(34, 17, 'servicio', 'Chocolate caliente (19/3/2026)', 23, 1.00, 10000.00, 10000.00, 0.00, 10000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(35, 18, 'habitacion', 'Habitación 101 - 0 noche(s) (20/3/2026 al 19/3/2026)', 1, 0.00, 80000.00, 0.00, 0.00, 0.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(36, 18, 'servicio', 'Agua mineral (20/3/2026)', 28, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(37, 18, 'servicio', 'Café americano (20/3/2026)', 29, 3.00, 8000.00, 24000.00, 0.00, 24000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(38, 18, 'servicio', 'Cappuccino (20/3/2026)', 30, 3.00, 12000.00, 36000.00, 0.00, 36000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(39, 18, 'servicio', 'Chocolate caliente (20/3/2026)', 31, 1.00, 10000.00, 10000.00, 0.00, 10000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(40, 19, 'habitacion', 'Habitación 101 - 2 noche(s) (2/4/2026 al 3/4/2026)', 1, 2.00, 80000.00, 160000.00, 0.00, 160000.00, NULL, 0.00, 1, NULL, 0.00, NULL, 'PENDIENTE'),
	(41, 19, 'servicio', 'Agua mineral (2/4/2026)', 32, 1.00, 5000.00, 5000.00, 0.00, 5000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(42, 19, 'servicio', 'Café americano (2/4/2026)', 33, 1.00, 8000.00, 8000.00, 0.00, 8000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(43, 19, 'servicio', 'Croissant (2/4/2026)', 34, 1.00, 6000.00, 6000.00, 0.00, 6000.00, NULL, 0.00, 2, NULL, 0.00, NULL, 'PENDIENTE'),
	(44, 20, 'habitacion', 'Habitación 101 - 3 noche(s) (6/4/2026 al 8/4/2026)', 1, 3.00, 80000.00, 240000.00, 0.00, 285600.00, NULL, 0.00, 1, 'Alojamiento', 45600.00, NULL, 'PENDIENTE'),
	(45, 20, 'servicio', 'Agua mineral (6/4/2026)', 35, 1.00, 5000.00, 5000.00, 0.00, 5400.00, 8.00, 400.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(46, 20, 'servicio', 'Té aromático (6/4/2026)', 36, 1.00, 7000.00, 7000.00, 0.00, 7560.00, 8.00, 560.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(47, 20, 'servicio', 'Agua mineral (6/4/2026)', 37, 1.00, 5000.00, 5000.00, 0.00, 5400.00, 8.00, 400.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(48, 20, 'servicio', 'Té aromático (6/4/2026)', 38, 1.00, 7000.00, 7000.00, 0.00, 7560.00, 8.00, 560.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(49, 20, 'servicio', 'Agua mineral (6/4/2026)', 39, 1.00, 5000.00, 5000.00, 0.00, 5400.00, 8.00, 400.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(50, 20, 'servicio', 'Té aromático (6/4/2026)', 40, 1.00, 7000.00, 7000.00, 0.00, 7560.00, 8.00, 560.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(51, 20, 'servicio', 'Cappuccino (6/4/2026)', 42, 1.00, 12000.00, 12000.00, 0.00, 12960.00, 8.00, 960.00, 2, 'Restaurante/Cafetería', 0.00, NULL, 'PENDIENTE'),
	(52, 20, 'servicio', 'Tour de aventura (6/4/2026)', 41, 1.00, 180000.00, 180000.00, 0.00, 214200.00, NULL, 0.00, 8, 'Tours', 34200.00, NULL, 'PENDIENTE');

-- Volcando estructura para tabla hotel.empleados
CREATE TABLE IF NOT EXISTS `empleados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) DEFAULT NULL,
  `cedula` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` varchar(255) NOT NULL,
  `tax_profile` enum('RESIDENT','FOREIGN_TOURIST','ENTITY') NOT NULL DEFAULT 'RESIDENT',
  `estado` varchar(255) NOT NULL DEFAULT 'activo',
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_531b62206ec48fc3ba88593af3` (`cedula`),
  UNIQUE KEY `IDX_a5c9113abdd7c58a2290208119` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.empleados: ~13 rows (aproximadamente)
INSERT INTO `empleados` (`id`, `id_hotel`, `cedula`, `nombre`, `apellido`, `email`, `password`, `rol`, `tax_profile`, `estado`, `createdAt`, `updatedAt`, `deleted_at`, `deleted_by`) VALUES
	(1, NULL, '1003001750', 'Cesar', 'Urriaga', 'urriagac44@gmail.com', '$2b$10$OJ1eEny.HEuGrLI.bsDZUOVcOF9aqR/LYjyqRMBwWNuLldjfV3Msy', 'superadmin', 'RESIDENT', 'activo', '2026-03-14 12:52:05.423254', '2026-03-14 13:02:41.926290', NULL, NULL),
	(2, 1, '123456789', 'Juan', 'Sena', 'recepcionista@gmail.com', '$2b$10$wXPhbqO8u3obk4/2iKbGYO.YbCMw3bPZlUaBEcKMoBOJiz0YvTCFy', 'recepcionista', 'RESIDENT', 'activo', '2026-03-14 13:13:37.300321', '2026-03-14 13:13:37.300321', NULL, NULL),
	(3, 1, '1003001751', 'Cesar', 'Urriaga', 'admin@gmail.com', '$2b$10$2RQOr05vUfP4ikrygcpAgem0VHaeEoQtnvcHjaio/RjZgatQ0Emg2', 'admin', 'RESIDENT', 'activo', '2026-03-15 11:41:23.766228', '2026-03-15 11:41:23.766228', NULL, NULL),
	(6, 1, '234567890', 'Camilo Torres', '', 'camilo@gmail.com', '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'cafeteria', 'RESIDENT', 'activo', '2026-03-15 20:14:42.287163', '2026-03-15 20:14:42.287163', NULL, NULL),
	(8, 1, '300000001', 'Empleado', 'Lavandería', 'lavanderia@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'lavanderia', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(9, 1, '300000002', 'Empleado', 'Spa', 'spa@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'spa', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(10, 1, '300000003', 'Empleado', 'Room Service', 'roomservice@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'room_service', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(11, 1, '300000004', 'Empleado', 'Minibar', 'minibar@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'minibar', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(12, 1, '300000005', 'Empleado', 'Transporte', 'transporte@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'transporte', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(13, 1, '300000006', 'Empleado', 'Tours', 'tours@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'tours', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(14, 1, '300000007', 'Empleado', 'Eventos', 'eventos@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'eventos', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL),
	(15, 1, '300000008', 'Empleado', 'Mantenimiento', 'mantenimiento@gmail.com', '$2b$10$NXVLWoOYQJ2ydkrSLTPWMOljida0nAXDtXymq8dg2AbSoqci42eI6', 'mantenimiento', 'RESIDENT', 'activo', '2026-04-05 19:08:44.000000', '2026-04-05 19:08:44.000000', NULL, NULL);

-- Volcando estructura para tabla hotel.factura_cambios
CREATE TABLE IF NOT EXISTS `factura_cambios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `usuario_email` varchar(255) DEFAULT NULL,
  `valor_anterior` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valor_anterior`)),
  `valor_nuevo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valor_nuevo`)),
  `tipo_cambio` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_factura_fecha` (`id_factura`,`fecha`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_factura` (`id_factura`),
  KEY `IDX_b35bcfd26ae9a3a1e840a3e79b` (`fecha`),
  KEY `IDX_4e120e83961a11aeb95e298844` (`usuario_id`),
  KEY `IDX_fc8307ef08263e27b2f8e171fb` (`id_factura`),
  CONSTRAINT `FK_fc8307ef08263e27b2f8e171fb8` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.factura_cambios: ~0 rows (aproximadamente)
INSERT INTO `factura_cambios` (`id`, `id_factura`, `usuario_id`, `descripcion`, `fecha`, `usuario_email`, `valor_anterior`, `valor_nuevo`, `tipo_cambio`) VALUES
	(1, 18, 3, 'Factura emitida - Cambio de estado BORRADOR → EMITIDA', '2026-04-02 00:08:09.643000', NULL, NULL, NULL, '');

-- Volcando estructura para tabla hotel.factura_reimpresiones
CREATE TABLE IF NOT EXISTS `factura_reimpresiones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `usuario_rol` varchar(40) DEFAULT NULL,
  `formato` enum('ticket_pos','pdf_pos','pdf_a4') NOT NULL DEFAULT 'ticket_pos',
  `tamano_pos` varchar(4) DEFAULT NULL,
  `motivo` varchar(200) DEFAULT NULL,
  `ip_origen` varchar(64) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `idx_factura_reimpresiones_factura_fecha` (`id_factura`,`created_at`),
  CONSTRAINT `fk_factura_reimpresiones_facturas` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla hotel.factura_reimpresiones: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.facturas
CREATE TABLE IF NOT EXISTS `facturas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_factura` varchar(255) NOT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `id_reserva` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `nombre_cliente` varchar(255) NOT NULL,
  `cedula_cliente` varchar(255) NOT NULL,
  `email_cliente` varchar(255) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `id_resolucion_facturacion` int(11) DEFAULT NULL,
  `prefijo_factura` varchar(20) DEFAULT NULL,
  `consecutivo_factura` int(11) DEFAULT NULL,
  `resolucion_numero` varchar(80) DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `porcentaje_iva` decimal(5,2) NOT NULL DEFAULT 19.00,
  `porcentaje_inc` decimal(5,2) DEFAULT NULL,
  `monto_iva` decimal(12,2) NOT NULL,
  `monto_inc` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL,
  `estado` varchar(255) NOT NULL DEFAULT 'pendiente',
  `estado_factura` enum('BORRADOR','EDITABLE','EMITIDA','PAGADA','ANULADA') NOT NULL DEFAULT 'BORRADOR',
  `fecha_emision` datetime DEFAULT NULL,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `xml_data` longtext DEFAULT NULL,
  `json_data` longtext DEFAULT NULL,
  `cufe` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `desglose_impuestos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`desglose_impuestos`)),
  `desglose_monetario` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`desglose_monetario`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_0e316c27f9738f9c065b08220b` (`numero_factura`),
  UNIQUE KEY `IDX_f955080f9b27de038fb57af965` (`uuid`),
  KEY `FK_8b3f69e871b3d6c02de6c6d03e5` (`id_reserva`),
  KEY `idx_facturas_resolucion` (`id_resolucion_facturacion`),
  KEY `idx_facturas_prefijo_consecutivo` (`prefijo_factura`,`consecutivo_factura`),
  CONSTRAINT `FK_8b3f69e871b3d6c02de6c6d03e5` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_facturas_resolucion_facturacion` FOREIGN KEY (`id_resolucion_facturacion`) REFERENCES `resoluciones_facturacion` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.facturas: ~14 rows (aproximadamente)
INSERT INTO `facturas` (`id`, `numero_factura`, `uuid`, `id_reserva`, `id_cliente`, `nombre_cliente`, `cedula_cliente`, `email_cliente`, `id_hotel`, `id_resolucion_facturacion`, `prefijo_factura`, `consecutivo_factura`, `resolucion_numero`, `subtotal`, `porcentaje_iva`, `porcentaje_inc`, `monto_iva`, `monto_inc`, `total`, `estado`, `estado_factura`, `fecha_emision`, `fecha_vencimiento`, `observaciones`, `xml_data`, `json_data`, `cufe`, `created_at`, `updated_at`, `deleted_at`, `deleted_by`, `desglose_impuestos`, `desglose_monetario`) VALUES
	(2, 'FAC-2026-00001', '5bc6f2c8-8795-49c1-849b-b964fa9f2749', 2, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 80000.00, 19.00, NULL, 15200.00, 0.00, 95200.00, 'pendiente', 'BORRADOR', '2026-03-16 18:54:50', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:UUID>5bc6f2c8-8795-49c1-849b-b964fa9f2749</cbc:UUID>\n  <cbc:IssueDate>2026-03-16</cbc:IssueDate>\n  <cbc:IssueTime>23:54:50</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-16</cbc:StartDate>\n    <cbc:EndDate>2026-03-16</cbc:EndDate>\n  </cac:InvoicePeriod>\n  <cac:OrderReference>\n    <cbc:ID>FAC-2026-00001</cbc:ID>\n  </cac:OrderReference>\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID>50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">80000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Percent>19</cbc:Percent>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">80000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">95200.00</cbc:TaxInclusiveAmount>\n    <cbc:PayableAmount currencyID="COP">95200.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (16/3/2026 al 16/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n      <cac:LineExtensionAmount currencyID="COP">80000.00</cac:LineExtensionAmount>\n    </cac:InvoiceLine>\n  <!-- AVISO: Documento generado electrónicamente -->\n  <!-- Simulación para preparación DIAN - No válido fiscalmente sin firma digital -->\n</Invoice>', '{"numeroFactura":"FAC-2026-00001","uuid":"5bc6f2c8-8795-49c1-849b-b964fa9f2749","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (16/3/2026 al 16/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1}],"montos":{"subtotal":80000,"porcentajeIva":19,"montoIva":15200,"total":95200},"fechaEmision":"2026-03-16T23:54:50.166Z"}', NULL, '2026-03-16 18:54:50.182987', '2026-03-16 18:54:50.182987', NULL, NULL, NULL, NULL),
	(3, 'FAC-2026-00003', '6ec0759c-f1b2-4806-92eb-deb899282f3a', 3, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 100000.00, 19.00, NULL, 19000.00, 0.00, 119000.00, 'pendiente', 'BORRADOR', '2026-03-16 19:12:29', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:UUID>6ec0759c-f1b2-4806-92eb-deb899282f3a</cbc:UUID>\n  <cbc:IssueDate>2026-03-17</cbc:IssueDate>\n  <cbc:IssueTime>00:12:29</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-17</cbc:StartDate>\n    <cbc:EndDate>2026-03-17</cbc:EndDate>\n  </cac:InvoicePeriod>\n  <cac:OrderReference>\n    <cbc:ID>FAC-2026-00003</cbc:ID>\n  </cac:OrderReference>\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID>50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">19000.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">100000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">19000.00</cbc:TaxAmount>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Percent>19</cbc:Percent>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">100000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">100000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">119000.00</cbc:TaxInclusiveAmount>\n    <cbc:PayableAmount currencyID="COP">119000.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (16/3/2026 al 16/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n      <cac:LineExtensionAmount currencyID="COP">80000.00</cac:LineExtensionAmount>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cac:Item>\n        <cbc:Description>Agua mineral (16/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n      <cac:LineExtensionAmount currencyID="COP">5000.00</cac:LineExtensionAmount>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cac:Item>\n        <cbc:Description>Café americano (16/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n      <cac:LineExtensionAmount currencyID="COP">8000.00</cac:LineExtensionAmount>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cac:Item>\n        <cbc:Description>Té aromático (16/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">7000.00</cbc:PriceAmount>\n      </cac:Price>\n      <cac:LineExtensionAmount currencyID="COP">7000.00</cac:LineExtensionAmount>\n    </cac:InvoiceLine>\n  <!-- AVISO: Documento generado electrónicamente -->\n  <!-- Simulación para preparación DIAN - No válido fiscalmente sin firma digital -->\n</Invoice>', '{"numeroFactura":"FAC-2026-00003","uuid":"6ec0759c-f1b2-4806-92eb-deb899282f3a","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (16/3/2026 al 16/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1},{"tipoConcepto":"servicio","descripcion":"Agua mineral (16/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"descuento":0,"total":5000,"idReferencia":1},{"tipoConcepto":"servicio","descripcion":"Café americano (16/3/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"descuento":0,"total":8000,"idReferencia":2},{"tipoConcepto":"servicio","descripcion":"Té aromático (16/3/2026)","cantidad":1,"precioUnitario":7000,"subtotal":7000,"descuento":0,"total":7000,"idReferencia":3}],"montos":{"subtotal":100000,"porcentajeIva":19,"montoIva":19000,"total":119000},"fechaEmision":"2026-03-17T00:12:29.453Z"}', NULL, '2026-03-16 19:12:29.456791', '2026-03-16 19:12:29.456791', NULL, NULL, NULL, NULL),
	(9, 'FAC-2026-00004', '78c614f6-4c87-4737-9006-c468ffb86627', 4, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 115000.00, 19.00, NULL, 21850.00, 0.00, 136850.00, 'pendiente', 'BORRADOR', '2026-03-17 18:56:21', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00004</cbc:ID>\n  <cbc:UUID>78c614f6-4c87-4737-9006-c468ffb86627</cbc:UUID>\n  <cbc:IssueDate>2026-03-17</cbc:IssueDate>\n  <cbc:IssueTime>23:56:21</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-17</cbc:StartDate>\n    <cbc:EndDate>2026-03-17</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00004</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">21850.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">115000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">21850.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">115000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">115000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">136850.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">136850.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (16/3/2026 al 17/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (17/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">8000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (17/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">12000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (17/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">10000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Chocolate caliente (17/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">10000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00004","uuid":"78c614f6-4c87-4737-9006-c468ffb86627","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (16/3/2026 al 17/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1},{"tipoConcepto":"servicio","descripcion":"Agua mineral (17/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"descuento":0,"total":5000,"montoInc":0,"idReferencia":4},{"tipoConcepto":"servicio","descripcion":"Café americano (17/3/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"descuento":0,"total":8000,"montoInc":0,"idReferencia":5},{"tipoConcepto":"servicio","descripcion":"Cappuccino (17/3/2026)","cantidad":1,"precioUnitario":12000,"subtotal":12000,"descuento":0,"total":12000,"montoInc":0,"idReferencia":6},{"tipoConcepto":"servicio","descripcion":"Chocolate caliente (17/3/2026)","cantidad":1,"precioUnitario":10000,"subtotal":10000,"descuento":0,"total":10000,"montoInc":0,"idReferencia":7}],"montos":{"subtotal":115000,"montoInc":0,"porcentajeIncAplicado":null,"porcentajeIva":19,"montoIva":21850,"total":136850},"fechaEmision":"2026-03-17T23:56:21.017Z"}', NULL, '2026-03-17 18:56:21.033706', '2026-03-17 18:56:21.033706', NULL, NULL, NULL, NULL),
	(10, 'FAC-2026-00010', '0c418c2d-126a-4d34-a45d-3d8c4e6fcd40', 5, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 115000.00, 19.00, 8.00, 15200.00, 2800.00, 133000.00, 'pendiente', 'BORRADOR', '2026-03-19 20:16:46', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00010</cbc:ID>\n  <cbc:UUID>0c418c2d-126a-4d34-a45d-3d8c4e6fcd40</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>01:16:46</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00010</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">115000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">115000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">115000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">133000.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">133000.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">8000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">12000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">10000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Chocolate caliente (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">10000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00010","uuid":"0c418c2d-126a-4d34-a45d-3d8c4e6fcd40","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1,"categoriaServiciosId":1},{"tipoConcepto":"servicio","descripcion":"Agua mineral (19/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"descuento":0,"total":5000,"montoInc":0,"idReferencia":8,"categoriaServiciosId":2},{"tipoConcepto":"servicio","descripcion":"Café americano (19/3/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"descuento":0,"total":8000,"montoInc":0,"idReferencia":9,"categoriaServiciosId":2},{"tipoConcepto":"servicio","descripcion":"Cappuccino (19/3/2026)","cantidad":1,"precioUnitario":12000,"subtotal":12000,"descuento":0,"total":12000,"montoInc":0,"idReferencia":10,"categoriaServiciosId":2},{"tipoConcepto":"servicio","descripcion":"Chocolate caliente (19/3/2026)","cantidad":1,"precioUnitario":10000,"subtotal":10000,"descuento":0,"total":10000,"montoInc":0,"idReferencia":11,"categoriaServiciosId":2}],"montos":{"subtotal":115000,"montoInc":2800,"porcentajeIncAplicado":8,"porcentajeIva":19,"montoIva":15200,"total":133000},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200},"Categoría 2":{"monto":35000,"iva":0,"inc":2800,"otros":0,"total":37800}},"desgloseMonetario":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200},"Categoría 2":{"monto":35000,"iva":0,"inc":2800,"otros":0,"total":37800}},"fechaEmision":"2026-03-20T01:16:46.428Z"}', NULL, '2026-03-19 20:16:46.431871', '2026-03-19 20:16:46.431871', NULL, NULL, NULL, NULL),
	(11, 'FAC-2026-00011', '64e521f5-3f20-4073-8ca3-2b9b202c6795', 6, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 80000.00, 19.00, NULL, 15200.00, 0.00, 95200.00, 'pendiente', 'BORRADOR', '2026-03-19 20:25:14', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00011</cbc:ID>\n  <cbc:UUID>64e521f5-3f20-4073-8ca3-2b9b202c6795</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>01:25:14</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00011</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">80000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">80000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">95200.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">95200.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00011","uuid":"64e521f5-3f20-4073-8ca3-2b9b202c6795","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1,"categoriaServiciosId":1}],"montos":{"subtotal":80000,"montoInc":0,"porcentajeIncAplicado":null,"porcentajeIva":19,"montoIva":15200,"total":95200},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"desgloseMonetario":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"fechaEmision":"2026-03-20T01:25:14.502Z"}', NULL, '2026-03-19 20:25:14.509583', '2026-03-19 20:25:14.509583', NULL, NULL, NULL, NULL),
	(12, 'FAC-2026-00012', '17937d91-0699-43c1-80c9-66edc243d4ee', 7, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 80000.00, 19.00, NULL, 15200.00, 0.00, 95200.00, 'pendiente', 'BORRADOR', '2026-03-19 20:45:30', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00012</cbc:ID>\n  <cbc:UUID>17937d91-0699-43c1-80c9-66edc243d4ee</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>01:45:30</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00012</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">80000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">80000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">95200.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">95200.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00012","uuid":"17937d91-0699-43c1-80c9-66edc243d4ee","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1,"categoriaServiciosId":1}],"montos":{"subtotal":80000,"montoInc":0,"porcentajeIncAplicado":null,"porcentajeIva":19,"montoIva":15200,"total":95200},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"desgloseMonetario":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"fechaEmision":"2026-03-20T01:45:30.213Z"}', NULL, '2026-03-19 20:45:30.215649', '2026-03-19 20:45:30.215649', NULL, NULL, NULL, NULL),
	(13, 'FAC-2026-00013', 'a479f35d-53ac-46d9-9d00-2b509e328906', 8, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 80000.00, 19.00, NULL, 15200.00, 0.00, 95200.00, 'pendiente', 'BORRADOR', '2026-03-19 21:02:47', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00013</cbc:ID>\n  <cbc:UUID>a479f35d-53ac-46d9-9d00-2b509e328906</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>02:02:47</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00013</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">80000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">80000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">95200.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">95200.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00013","uuid":"a479f35d-53ac-46d9-9d00-2b509e328906","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1,"categoriaServiciosId":1}],"montos":{"subtotal":80000,"montoInc":0,"porcentajeIncAplicado":null,"porcentajeIva":19,"montoIva":15200,"total":95200},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"desgloseMonetario":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"fechaEmision":"2026-03-20T02:02:47.589Z"}', NULL, '2026-03-19 21:02:47.600903', '2026-03-19 21:02:47.600903', NULL, NULL, NULL, NULL),
	(14, 'FAC-2026-00014', '62b618fb-8043-4c68-bffd-ffce5b5a8d0b', 9, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 80000.00, 19.00, NULL, 15200.00, 0.00, 95200.00, 'pendiente', 'BORRADOR', '2026-03-19 22:26:15', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00014</cbc:ID>\n  <cbc:UUID>62b618fb-8043-4c68-bffd-ffce5b5a8d0b</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>03:26:15</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00014</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">80000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">80000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">95200.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">95200.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00014","uuid":"62b618fb-8043-4c68-bffd-ffce5b5a8d0b","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 1 noche(s) (19/3/2026 al 19/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"descuento":0,"total":80000,"idReferencia":1,"categoriaServiciosId":1}],"montos":{"subtotal":80000,"montoInc":0,"porcentajeIncAplicado":null,"porcentajeIva":19,"montoIva":15200,"total":95200},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"desgloseMonetario":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200}},"fechaEmision":"2026-03-20T03:26:15.733Z"}', NULL, '2026-03-19 22:26:15.744508', '2026-03-19 22:26:15.744508', NULL, NULL, NULL, NULL),
	(15, 'FAC-2026-00015', '0d033bf8-3111-4acb-9368-5e38f5f43809', 10, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 595000.00, 19.00, 8.00, 106400.00, 2800.00, 704200.00, 'pendiente', 'BORRADOR', '2026-03-19 23:24:09', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00015</cbc:ID>\n  <cbc:UUID>0d033bf8-3111-4acb-9368-5e38f5f43809</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>04:24:09</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00015</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">106400.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">595000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">106400.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">595000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">595000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">704200.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">704200.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">7</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">560000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 7 noche(s) (19/3/2026 al 26/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">8000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">12000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">10000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Chocolate caliente (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">10000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00015","uuid":"0d033bf8-3111-4acb-9368-5e38f5f43809","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com"},"detalles":[{"tipoConcepto":"habitacion","descripcion":"Habitación 101 - 7 noche(s) (19/3/2026 al 26/3/2026)","cantidad":7,"precioUnitario":80000,"subtotal":560000,"descuento":0,"total":560000,"idReferencia":1,"categoriaServiciosId":1},{"tipoConcepto":"servicio","descripcion":"Agua mineral (19/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"descuento":0,"total":5000,"montoInc":0,"idReferencia":12,"categoriaServiciosId":2},{"tipoConcepto":"servicio","descripcion":"Café americano (19/3/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"descuento":0,"total":8000,"montoInc":0,"idReferencia":13,"categoriaServiciosId":2},{"tipoConcepto":"servicio","descripcion":"Cappuccino (19/3/2026)","cantidad":1,"precioUnitario":12000,"subtotal":12000,"descuento":0,"total":12000,"montoInc":0,"idReferencia":14,"categoriaServiciosId":2},{"tipoConcepto":"servicio","descripcion":"Chocolate caliente (19/3/2026)","cantidad":1,"precioUnitario":10000,"subtotal":10000,"descuento":0,"total":10000,"montoInc":0,"idReferencia":15,"categoriaServiciosId":2}],"montos":{"subtotal":595000,"montoInc":2800,"porcentajeIncAplicado":8,"porcentajeIva":19,"montoIva":106400,"total":704200},"desgloseImpuestos":{"Categoría 1":{"monto":560000,"iva":106400,"inc":0,"otros":0,"total":666400},"Categoría 2":{"monto":35000,"iva":0,"inc":2800,"otros":0,"total":37800}},"desgloseMonetario":{"Categoría 1":{"monto":560000,"iva":106400,"inc":0,"otros":0,"total":666400},"Categoría 2":{"monto":35000,"iva":0,"inc":2800,"otros":0,"total":37800}},"fechaEmision":"2026-03-20T04:24:09.856Z"}', NULL, '2026-03-19 23:24:09.864814', '2026-03-19 23:24:09.864814', NULL, NULL, NULL, NULL),
	(16, 'FAC-2026-00016', 'fc56db1a-fadd-49ca-9263-8e5113f80ccb', 11, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 115000.00, 19.00, 8.00, 15200.00, 2800.00, 133000.00, 'pendiente', 'BORRADOR', '2026-03-19 23:33:08', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00016</cbc:ID>\n  <cbc:UUID>fc56db1a-fadd-49ca-9263-8e5113f80ccb</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>04:33:08</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00016</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">115000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">115000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">115000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">133000.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">133000.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 102 - 1 noche(s) (19/3/2026 al 20/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">8000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">12000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">10000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Chocolate caliente (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">10000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00016","uuid":"fc56db1a-fadd-49ca-9263-8e5113f80ccb","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com","taxProfile":"RESIDENT"},"detalles":[{"descripcion":"Habitación 102 - 1 noche(s) (19/3/2026 al 20/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"categoria":"Alojamiento"},{"descripcion":"Agua mineral (19/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"categoria":"Cafetería"},{"descripcion":"Café americano (19/3/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"categoria":"Cafetería"},{"descripcion":"Cappuccino (19/3/2026)","cantidad":1,"precioUnitario":12000,"subtotal":12000,"categoria":"Cafetería"},{"descripcion":"Chocolate caliente (19/3/2026)","cantidad":1,"precioUnitario":10000,"subtotal":10000,"categoria":"Cafetería"}],"montos":{"subtotal":115000,"iva":15200,"porcentajeIva":19,"inc":2800,"porcentajeInc":8,"total":133000},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200},"Categoría 2":{"monto":35000,"iva":0,"inc":2800,"otros":0,"total":37800}},"fechaEmision":"2026-03-20T04:33:08.670Z"}', NULL, '2026-03-19 23:33:08.674237', '2026-03-19 23:33:08.674237', NULL, NULL, NULL, NULL),
	(17, 'FAC-2026-00017', 'a701e313-1c2e-4294-a976-6ef111c107de', 12, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 115000.00, 19.00, 8.00, 15200.00, 2800.00, 133000.00, 'pendiente', 'BORRADOR', '2026-03-19 23:48:11', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00017</cbc:ID>\n  <cbc:UUID>a701e313-1c2e-4294-a976-6ef111c107de</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>04:48:11</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00017</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">115000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">15200.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">115000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">115000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">133000.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">133000.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">80000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 1 noche(s) (19/3/2026 al 20/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">8000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">12000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">10000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Chocolate caliente (19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">10000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00017","uuid":"a701e313-1c2e-4294-a976-6ef111c107de","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com","taxProfile":"RESIDENT"},"detalles":[{"descripcion":"Habitación 101 - 1 noche(s) (19/3/2026 al 20/3/2026)","cantidad":1,"precioUnitario":80000,"subtotal":80000,"categoria":"Alojamiento"},{"descripcion":"Agua mineral (19/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"categoria":"Cafetería"},{"descripcion":"Café americano (19/3/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"categoria":"Cafetería"},{"descripcion":"Cappuccino (19/3/2026)","cantidad":1,"precioUnitario":12000,"subtotal":12000,"categoria":"Cafetería"},{"descripcion":"Chocolate caliente (19/3/2026)","cantidad":1,"precioUnitario":10000,"subtotal":10000,"categoria":"Cafetería"}],"montos":{"subtotal":115000,"iva":15200,"porcentajeIva":19,"inc":2800,"porcentajeInc":8,"total":133000},"desgloseImpuestos":{"Categoría 1":{"monto":80000,"iva":15200,"inc":0,"otros":0,"total":95200},"Categoría 2":{"monto":35000,"iva":0,"inc":2800,"otros":0,"total":37800}},"fechaEmision":"2026-03-20T04:48:11.477Z"}', NULL, '2026-03-19 23:48:11.481665', '2026-03-19 23:48:11.481665', NULL, NULL, NULL, NULL),
	(18, 'FAC-2026-00018', '07549d89-061a-4f62-959a-1c8dc70a8ad0', 13, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 75000.00, 19.00, 8.00, 0.00, 6000.00, 81000.00, 'emitida', 'EMITIDA', '2026-04-02 00:08:09', '2026-05-02 00:08:09', '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00018</cbc:ID>\n  <cbc:UUID>07549d89-061a-4f62-959a-1c8dc70a8ad0</cbc:UUID>\n  <cbc:IssueDate>2026-03-20</cbc:IssueDate>\n  <cbc:IssueTime>05:26:06</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-03-20</cbc:StartDate>\n    <cbc:EndDate>2026-03-20</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00018</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">0.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">75000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">0.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">75000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">75000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">81000.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">81000.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">0</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">0.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 0 noche(s) (20/3/2026 al 19/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (20/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">3</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">24000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (20/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">3</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">36000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (20/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">10000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Chocolate caliente (20/3/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">10000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00018","uuid":"07549d89-061a-4f62-959a-1c8dc70a8ad0","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com","taxProfile":"RESIDENT"},"detalles":[{"descripcion":"Habitación 101 - 0 noche(s) (20/3/2026 al 19/3/2026)","cantidad":0,"precioUnitario":80000,"subtotal":0,"categoria":"Alojamiento"},{"descripcion":"Agua mineral (20/3/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"categoria":"Cafetería"},{"descripcion":"Café americano (20/3/2026)","cantidad":3,"precioUnitario":8000,"subtotal":24000,"categoria":"Cafetería"},{"descripcion":"Cappuccino (20/3/2026)","cantidad":3,"precioUnitario":12000,"subtotal":36000,"categoria":"Cafetería"},{"descripcion":"Chocolate caliente (20/3/2026)","cantidad":1,"precioUnitario":10000,"subtotal":10000,"categoria":"Cafetería"}],"montos":{"subtotal":75000,"iva":0,"porcentajeIva":19,"inc":6000,"porcentajeInc":8,"total":81000},"desgloseImpuestos":{"Categoría 1":{"monto":0,"iva":0,"inc":0,"otros":0,"total":0},"Categoría 2":{"monto":75000,"iva":0,"inc":6000,"otros":0,"total":81000}},"fechaEmision":"2026-03-20T05:26:06.225Z"}', NULL, '2026-03-20 00:26:06.230668', '2026-04-02 00:08:09.000000', NULL, NULL, NULL, NULL),
	(19, 'FAC-2026-00019', '0d2f180a-5465-4ab3-a256-128a1d5e148f', 14, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 179000.00, 19.00, 8.00, 30400.00, 1520.00, 210920.00, 'pendiente', 'BORRADOR', '2026-04-02 00:11:32', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00019</cbc:ID>\n  <cbc:UUID>0d2f180a-5465-4ab3-a256-128a1d5e148f</cbc:UUID>\n  <cbc:IssueDate>2026-04-02</cbc:IssueDate>\n  <cbc:IssueTime>05:11:32</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-04-02</cbc:StartDate>\n    <cbc:EndDate>2026-04-02</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00019</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel Sena) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>HOTEL SENA 2026</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>\n        <cbc:CityName>Bogotá</cbc:CityName>\n        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>CO</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">30400.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">179000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">30400.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">179000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">179000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">210920.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">210920.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">2</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">160000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 2 noche(s) (2/4/2026 al 3/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (2/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">8000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Café americano (2/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">8000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">6000.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Croissant (2/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">6000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00019","uuid":"0d2f180a-5465-4ab3-a256-128a1d5e148f","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com","taxProfile":"RESIDENT"},"detalles":[{"descripcion":"Habitación 101 - 2 noche(s) (2/4/2026 al 3/4/2026)","cantidad":2,"precioUnitario":80000,"subtotal":160000,"categoria":"Alojamiento"},{"descripcion":"Agua mineral (2/4/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"categoria":"Cafetería"},{"descripcion":"Café americano (2/4/2026)","cantidad":1,"precioUnitario":8000,"subtotal":8000,"categoria":"Cafetería"},{"descripcion":"Croissant (2/4/2026)","cantidad":1,"precioUnitario":6000,"subtotal":6000,"categoria":"Cafetería"}],"montos":{"subtotal":179000,"iva":30400,"porcentajeIva":19,"inc":1520,"porcentajeInc":8,"total":210920},"desgloseImpuestos":{"Categoría 1":{"monto":160000,"iva":30400,"inc":0,"otros":0,"total":190400},"Categoría 2":{"monto":19000,"iva":0,"inc":1520,"otros":0,"total":20520}},"fechaEmision":"2026-04-02T05:11:32.941Z"}', NULL, '2026-04-02 00:11:32.944230', '2026-04-02 00:11:32.944230', NULL, NULL, NULL, NULL),
	(20, 'FAC-2026-00020', 'a6f41b8b-3aca-43de-9695-8f946e40de26', 15, 1, 'Juan', '50919231', 'sena@gmail.com', 1, NULL, NULL, NULL, NULL, 468000.00, 19.00, 8.00, 79800.00, 3840.00, 551640.00, 'pendiente', 'BORRADOR', '2026-04-20 19:05:45', NULL, '', '<?xml version="1.0" encoding="UTF-8"?>\n<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"\n         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"\n         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"\n         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">\n  <!-- METADATOS DIAN -->\n  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>\n  <cbc:CustomizationID>05</cbc:CustomizationID>\n  <cbc:ProfileID>dian</cbc:ProfileID>\n  <cbc:ID>FV-FAC-2026-00020</cbc:ID>\n  <cbc:UUID>a6f41b8b-3aca-43de-9695-8f946e40de26</cbc:UUID>\n  <cbc:IssueDate>2026-04-21</cbc:IssueDate>\n  <cbc:IssueTime>00:05:45</cbc:IssueTime>\n  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>\n  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>\n  \n  <!-- PERÍODO -->\n  <cac:InvoicePeriod>\n    <cbc:StartDate>2026-04-21</cbc:StartDate>\n    <cbc:EndDate>2026-04-21</cbc:EndDate>\n  </cac:InvoicePeriod>\n  \n  <!-- REFERENCIA A ORDEN -->\n  <cac:OrderReference>\n    <cbc:ID>FV-FAC-2026-00020</cbc:ID>\n  </cac:OrderReference>\n  \n  <!-- PROVEEDOR (Hotel) -->\n  <cac:AccountingSupplierParty>\n    <cac:Party>\n      <cbc:Name>Hotel Valhalla</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="NIT">123456789</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:PostalAddress>\n        <cbc:StreetName>Calle 10 No. 5-50</cbc:StreetName>\n        <cbc:CityName>Monteria</cbc:CityName>\n        <cbc:CountrySubentity>Monteria</cbc:CountrySubentity>\n        <cac:Country>\n          <cbc:IdentificationCode>Colombia</cbc:IdentificationCode>\n        </cac:Country>\n      </cac:PostalAddress>\n      <cac:PartyTaxScheme>\n        <cbc:RegistrationName>Hotel Valhalla</cbc:RegistrationName>\n        <cbc:CompanyID schemeID="NIT">123456789</cbc:CompanyID>\n        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:PartyTaxScheme>\n    </cac:Party>\n  </cac:AccountingSupplierParty>\n  \n  <!-- CLIENTE (Huésped) -->\n  <cac:AccountingCustomerParty>\n    <cac:Party>\n      <cbc:Name>Juan</cbc:Name>\n      <cac:PartyIdentification>\n        <cbc:ID schemeID="CC">50919231</cbc:ID>\n      </cac:PartyIdentification>\n      <cac:Contact>\n        <cbc:ElectronicMail>sena@gmail.com</cbc:ElectronicMail>\n      </cac:Contact>\n    </cac:Party>\n  </cac:AccountingCustomerParty>\n  \n  <!-- TOTALES IMPUESTOS -->\n  <cac:TaxTotal>\n    <cbc:TaxAmount currencyID="COP">79800.00</cbc:TaxAmount>\n    <cac:TaxSubtotal>\n      <cbc:TaxableAmount currencyID="COP">468000.00</cbc:TaxableAmount>\n      <cbc:TaxAmount currencyID="COP">79800.00</cbc:TaxAmount>\n      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>\n      <cac:TaxCategory>\n        <cbc:ID>S</cbc:ID>\n        <cbc:Name>IVA</cbc:Name>\n        <cbc:Percent>19</cbc:Percent>\n        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>\n        <cac:TaxScheme>\n          <cbc:ID>01</cbc:ID>\n          <cbc:Name>IVA</cbc:Name>\n        </cac:TaxScheme>\n      </cac:TaxCategory>\n    </cac:TaxSubtotal>\n  </cac:TaxTotal>\n  \n  <!-- TOTALES MONETARIOS -->\n  <cac:LegalMonetaryTotal>\n    <cbc:LineExtensionAmount currencyID="COP">468000.00</cbc:LineExtensionAmount>\n    <cbc:TaxExclusiveAmount currencyID="COP">468000.00</cbc:TaxExclusiveAmount>\n    <cbc:TaxInclusiveAmount currencyID="COP">551640.00</cbc:TaxInclusiveAmount>\n    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>\n    <cbc:PayableAmount currencyID="COP">551640.00</cbc:PayableAmount>\n  </cac:LegalMonetaryTotal>\n  \n  <!-- LÍNEAS DE FACTURA -->\n  \n    <cac:InvoiceLine>\n      <cbc:ID>1</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">3</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">285600.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Habitación 101 - 3 noche(s) (6/4/2026 al 8/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">80000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>2</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5400.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>3</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">7560.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Té aromático (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">7000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>4</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5400.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>5</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">7560.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Té aromático (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">7000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>6</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">5400.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Agua mineral (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">5000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>7</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">7560.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Té aromático (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">7000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>8</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">12960.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Cappuccino (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">12000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n\n    <cac:InvoiceLine>\n      <cbc:ID>9</cbc:ID>\n      <cbc:InvoicedQuantity unitCode="EA">1</cbc:InvoicedQuantity>\n      <cbc:LineExtensionAmount currencyID="COP">214200.00</cbc:LineExtensionAmount>\n      <cac:Item>\n        <cbc:Description>Tour de aventura (6/4/2026)</cbc:Description>\n      </cac:Item>\n      <cac:Price>\n        <cbc:PriceAmount currencyID="COP">180000.00</cbc:PriceAmount>\n      </cac:Price>\n    </cac:InvoiceLine>\n  \n  <!-- NOTAS -->\n  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>\n  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>\n</Invoice>', '{"numeroFactura":"FAC-2026-00020","uuid":"a6f41b8b-3aca-43de-9695-8f946e40de26","cliente":{"nombre":"Juan","cedula":"50919231","email":"sena@gmail.com","taxProfile":"RESIDENT"},"detalles":[{"descripcion":"Habitación 101 - 3 noche(s) (6/4/2026 al 8/4/2026)","cantidad":3,"precioUnitario":80000,"subtotal":240000,"iva":45600,"inc":0,"total":285600,"categoria":"Alojamiento"},{"descripcion":"Agua mineral (6/4/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"iva":0,"inc":400,"total":5400,"categoria":"Restaurante/Cafetería"},{"descripcion":"Té aromático (6/4/2026)","cantidad":1,"precioUnitario":7000,"subtotal":7000,"iva":0,"inc":560,"total":7560,"categoria":"Restaurante/Cafetería"},{"descripcion":"Agua mineral (6/4/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"iva":0,"inc":400,"total":5400,"categoria":"Restaurante/Cafetería"},{"descripcion":"Té aromático (6/4/2026)","cantidad":1,"precioUnitario":7000,"subtotal":7000,"iva":0,"inc":560,"total":7560,"categoria":"Restaurante/Cafetería"},{"descripcion":"Agua mineral (6/4/2026)","cantidad":1,"precioUnitario":5000,"subtotal":5000,"iva":0,"inc":400,"total":5400,"categoria":"Restaurante/Cafetería"},{"descripcion":"Té aromático (6/4/2026)","cantidad":1,"precioUnitario":7000,"subtotal":7000,"iva":0,"inc":560,"total":7560,"categoria":"Restaurante/Cafetería"},{"descripcion":"Cappuccino (6/4/2026)","cantidad":1,"precioUnitario":12000,"subtotal":12000,"iva":0,"inc":960,"total":12960,"categoria":"Restaurante/Cafetería"},{"descripcion":"Tour de aventura (6/4/2026)","cantidad":1,"precioUnitario":180000,"subtotal":180000,"iva":34200,"inc":0,"total":214200,"categoria":"Tours"}],"montos":{"subtotal":468000,"iva":79800,"porcentajeIva":19,"inc":3840,"porcentajeInc":8,"total":551640},"desgloseImpuestos":{"Alojamiento":{"subtotal":240000,"iva":45600,"inc":0,"total":285600},"Restaurante/Cafetería":{"subtotal":48000,"iva":0,"inc":3840,"total":51840},"Tours":{"subtotal":180000,"iva":34200,"inc":0,"total":214200}},"fechaEmision":"2026-04-21T00:05:45.124Z"}', NULL, '2026-04-20 19:05:45.138792', '2026-04-20 19:05:45.138792', NULL, NULL, NULL, NULL);

-- Volcando estructura para tabla hotel.folios
CREATE TABLE IF NOT EXISTS `folios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idHabitacion` int(11) NOT NULL,
  `idReserva` int(11) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `cargos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '[]' CHECK (json_valid(`cargos`)),
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estadoPago` enum('ACTIVO','CERRADO','PAGADO') NOT NULL DEFAULT 'ACTIVO',
  `fechaApertura` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `fechaCierre` datetime DEFAULT NULL,
  `registradoPor` int(11) DEFAULT NULL,
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `idMedioPago` int(11) DEFAULT NULL,
  `referenciaPago` varchar(100) DEFAULT NULL,
  `historicosPagos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`historicosPagos`)),
  PRIMARY KEY (`id`),
  KEY `FK_360d4b3ac1015efc2ef0d12202d` (`idHabitacion`),
  KEY `FK_ce3b67b4d7def014722ef871b5e` (`idReserva`),
  CONSTRAINT `FK_360d4b3ac1015efc2ef0d12202d` FOREIGN KEY (`idHabitacion`) REFERENCES `habitaciones` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ce3b67b4d7def014722ef871b5e` FOREIGN KEY (`idReserva`) REFERENCES `reservas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.folios: ~7 rows (aproximadamente)
INSERT INTO `folios` (`id`, `idHabitacion`, `idReserva`, `subtotal`, `cargos`, `total`, `estadoPago`, `fechaApertura`, `fechaCierre`, `registradoPor`, `updatedAt`, `idMedioPago`, `referenciaPago`, `historicosPagos`) VALUES
	(1, 1, 6, 80000.00, '[{"idCargo":"AUTO_HAB_6","descripcion":"Alojamiento habitación 101","cantidad":1,"precioUnitario":80000,"monto":80000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-03-20T01:24:57.000Z","agregadoPor":"Sistema","referencia":"RES-MMY7TXRB-0NZCBH","automatico":true}]', 80000.00, 'PAGADO', '2026-03-19 20:24:57.927181', '2026-03-19 22:26:09', NULL, '2026-03-19 22:26:09.000000', NULL, NULL, NULL),
	(2, 1, 10, 115000.00, '[{"idCargo":"AUTO_HAB_10","descripcion":"Alojamiento habitación 101","cantidad":1,"precioUnitario":80000,"monto":80000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-03-20T03:41:50.000Z","agregadoPor":"Sistema","referencia":"RES-MMYCQXLF-URD8YG","automatico":true},{"idCargo":"AUTO_PED_4_ITEM_12","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T03:42:28.644Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_4_ITEM_13","descripcion":"Cafetería - Café americano","cantidad":1,"precioUnitario":8000,"monto":8000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T03:42:28.650Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_4_ITEM_14","descripcion":"Cafetería - Cappuccino","cantidad":1,"precioUnitario":12000,"monto":12000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T03:42:28.653Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_4_ITEM_15","descripcion":"Cafetería - Chocolate caliente","cantidad":1,"precioUnitario":10000,"monto":10000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T03:42:28.658Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true}]', 115000.00, 'PAGADO', '2026-03-19 22:41:50.878623', '2026-03-19 23:24:09', NULL, '2026-03-19 23:47:54.000000', NULL, NULL, NULL),
	(3, 2, 11, 115000.00, '[{"idCargo":"AUTO_HAB_11","descripcion":"Alojamiento habitación 102","cantidad":1,"precioUnitario":80000,"monto":80000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-03-20T04:31:21.000Z","agregadoPor":"Sistema","referencia":"RES-MMYEIILD-IAC9ZJ","automatico":true},{"idCargo":"AUTO_PED_5_ITEM_16","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:32:05.990Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_5_ITEM_17","descripcion":"Cafetería - Café americano","cantidad":1,"precioUnitario":8000,"monto":8000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:32:05.996Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_5_ITEM_18","descripcion":"Cafetería - Cappuccino","cantidad":1,"precioUnitario":12000,"monto":12000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:32:06.000Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_5_ITEM_19","descripcion":"Cafetería - Chocolate caliente","cantidad":1,"precioUnitario":10000,"monto":10000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:32:06.007Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true}]', 115000.00, 'PAGADO', '2026-03-19 23:31:21.728290', '2026-03-19 23:33:08', NULL, '2026-03-19 23:33:08.000000', NULL, NULL, NULL),
	(4, 1, 12, 163000.00, '[{"idCargo":"AUTO_HAB_12","descripcion":"Alojamiento habitación 101","cantidad":1,"precioUnitario":80000,"monto":80000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-03-20T04:46:55.000Z","agregadoPor":"Sistema","referencia":"RES-MMYF2ED7-JUURX8","automatico":true},{"idCargo":"AUTO_PED_6_ITEM_20","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:47:18.778Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_6_ITEM_21","descripcion":"Cafetería - Café americano","cantidad":1,"precioUnitario":8000,"monto":8000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:47:18.782Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_6_ITEM_22","descripcion":"Cafetería - Cappuccino","cantidad":1,"precioUnitario":12000,"monto":12000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:47:18.785Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_6_ITEM_23","descripcion":"Cafetería - Chocolate caliente","cantidad":1,"precioUnitario":10000,"monto":10000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T04:47:18.789Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_7_ITEM_24","descripcion":"Cafetería - Croissant","cantidad":1,"precioUnitario":6000,"monto":6000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:23:28.154Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_7_ITEM_25","descripcion":"Cafetería - Jugo natural","cantidad":2,"precioUnitario":9000,"monto":18000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:23:28.163Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_7_ITEM_26","descripcion":"Cafetería - Latte","cantidad":1,"precioUnitario":13000,"monto":13000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:23:28.168Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_7_ITEM_27","descripcion":"Cafetería - Postre del día","cantidad":1,"precioUnitario":11000,"monto":11000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:23:28.173Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true}]', 163000.00, 'PAGADO', '2026-03-19 23:46:55.278512', '2026-03-19 23:48:11', NULL, '2026-03-20 00:23:43.000000', NULL, NULL, NULL),
	(5, 1, 13, 155000.00, '[{"idCargo":"AUTO_HAB_13","descripcion":"Alojamiento habitación 101","cantidad":1,"precioUnitario":80000,"monto":80000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-03-20T05:25:03.000Z","agregadoPor":"Sistema","referencia":"RES-MMYGFRJJ-9IPK93","automatico":true},{"idCargo":"AUTO_PED_8_ITEM_28","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:25:31.444Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_8_ITEM_29","descripcion":"Cafetería - Café americano","cantidad":3,"precioUnitario":8000,"monto":24000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:25:31.449Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_8_ITEM_30","descripcion":"Cafetería - Cappuccino","cantidad":3,"precioUnitario":12000,"monto":36000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:25:31.453Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_8_ITEM_31","descripcion":"Cafetería - Chocolate caliente","cantidad":1,"precioUnitario":10000,"monto":10000,"categoria":"CAFETERIA","fechaAñadido":"2026-03-20T05:25:31.457Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true}]', 155000.00, 'PAGADO', '2026-03-20 00:25:03.932492', '2026-03-20 00:26:06', NULL, '2026-03-20 00:26:06.000000', NULL, NULL, NULL),
	(6, 1, 14, 99000.00, '[{"idCargo":"AUTO_HAB_14","descripcion":"Alojamiento habitación 101","cantidad":1,"precioUnitario":80000,"monto":80000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-04-02T05:04:14.000Z","agregadoPor":"Sistema","referencia":"RES-MNH0DA2J-344R2K","automatico":true},{"idCargo":"AUTO_PED_9_ITEM_32","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-02T05:05:17.718Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_9_ITEM_33","descripcion":"Cafetería - Café americano","cantidad":1,"precioUnitario":8000,"monto":8000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-02T05:05:17.726Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_9_ITEM_34","descripcion":"Cafetería - Croissant","cantidad":1,"precioUnitario":6000,"monto":6000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-02T05:05:17.732Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true}]', 99000.00, 'PAGADO', '2026-04-02 00:04:14.751995', '2026-04-02 00:11:32', NULL, '2026-04-02 01:02:30.000000', NULL, NULL, NULL),
	(7, 1, 15, 468000.00, '[{"idCargo":"AUTO_HAB_15","descripcion":"Alojamiento habitación 101","cantidad":3,"precioUnitario":80000,"monto":240000,"categoria":"ALOJAMIENTO","fechaAñadido":"2026-04-06T06:25:15.000Z","agregadoPor":"Sistema","referencia":"RES-MNMSOW4R-3KGVPA","automatico":true},{"idCargo":"AUTO_PED_10_ITEM_35","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:43:30.293Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_10_ITEM_36","descripcion":"Cafetería - Té aromático","cantidad":1,"precioUnitario":7000,"monto":7000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:43:30.305Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_11_ITEM_37","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:43:54.041Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_11_ITEM_38","descripcion":"Cafetería - Té aromático","cantidad":1,"precioUnitario":7000,"monto":7000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:43:54.070Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_12_ITEM_39","descripcion":"Cafetería - Agua mineral","cantidad":1,"precioUnitario":5000,"monto":5000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:44:09.182Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_12_ITEM_40","descripcion":"Cafetería - Té aromático","cantidad":1,"precioUnitario":7000,"monto":7000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:44:09.202Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_13_ITEM_42","descripcion":"Cafetería - Cappuccino","cantidad":1,"precioUnitario":12000,"monto":12000,"categoria":"CAFETERIA","fechaAñadido":"2026-04-06T06:46:37.514Z","agregadoPor":"Sistema","referencia":"delivery","automatico":true},{"idCargo":"AUTO_PED_14_ITEM_41","descripcion":"Servicio - Tour de aventura","cantidad":1,"precioUnitario":180000,"monto":180000,"categoria":"TOURS","fechaAñadido":"2026-04-06T06:46:37.512Z","agregadoPor":"Sistema","referencia":"recogida","automatico":true}]', 468000.00, 'PAGADO', '2026-04-06 01:25:15.087977', '2026-04-20 19:05:45', NULL, '2026-05-08 21:43:55.000000', 1, NULL, NULL);

-- Volcando estructura para tabla hotel.habitaciones
CREATE TABLE IF NOT EXISTS `habitaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `numero_habitacion` varchar(255) NOT NULL,
  `piso` varchar(255) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `id_tipo_habitacion` int(11) NOT NULL,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `imagenes` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `FK_650d02efbfcd318350a416e027c` (`id_tipo_habitacion`),
  CONSTRAINT `FK_650d02efbfcd318350a416e027c` FOREIGN KEY (`id_tipo_habitacion`) REFERENCES `tipos_habitacion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.habitaciones: ~50 rows (aproximadamente)
INSERT INTO `habitaciones` (`id`, `id_hotel`, `numero_habitacion`, `piso`, `estado`, `id_tipo_habitacion`, `fecha_actualizacion`, `imagenes`, `created_at`, `updated_at`) VALUES
	(1, 1, '101', '1', 'limpieza', 1, '2026-05-08 23:18:59', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-05-08 23:18:59.000000'),
	(2, 1, '102', '1', 'disponible', 1, '2026-03-17 20:22:24', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:24.000000'),
	(3, 1, '103', '1', 'disponible', 1, '2026-03-17 20:22:24', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:24.000000'),
	(4, 1, '104', '1', 'disponible', 1, '2026-03-17 20:22:24', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:24.000000'),
	(5, 1, '105', '1', 'disponible', 1, '2026-03-17 20:22:24', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:24.000000'),
	(6, 1, '106', '1', 'disponible', 1, '2026-03-17 20:22:24', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:24.000000'),
	(7, 1, '107', '1', 'disponible', 1, '2026-03-17 20:22:24', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:25.000000'),
	(8, 1, '108', '1', 'disponible', 1, '2026-03-17 20:22:25', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:25.000000'),
	(9, 1, '109', '1', 'disponible', 1, '2026-03-17 20:22:25', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:25.000000'),
	(10, 1, '110', '1', 'disponible', 1, '2026-03-17 20:22:25', 'https://res.cloudinary.com/dlgsmttw4/image/upload/v1773796936/imghotel/nlxiteenli5eyr8ezl9d.jpg', '2026-03-16 18:44:25.231468', '2026-03-17 20:22:25.000000'),
	(11, 1, '201', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(12, 1, '202', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(13, 1, '203', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(14, 1, '204', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(15, 1, '205', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(16, 1, '206', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(17, 1, '207', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(18, 1, '208', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(19, 1, '209', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(20, 1, '210', '2', 'disponible', 2, NULL, NULL, '2026-03-16 18:44:25.245088', '2026-03-16 18:44:25.245088'),
	(21, 1, '301', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(22, 1, '302', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(23, 1, '303', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(24, 1, '304', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(25, 1, '305', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(26, 1, '306', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(27, 1, '307', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(28, 1, '308', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(29, 1, '309', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(30, 1, '310', '3', 'disponible', 3, NULL, NULL, '2026-03-16 18:44:25.264803', '2026-03-16 18:44:25.264803'),
	(31, 1, '401', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(32, 1, '402', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(33, 1, '403', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(34, 1, '404', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(35, 1, '405', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(36, 1, '406', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(37, 1, '407', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(38, 1, '408', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(39, 1, '409', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(40, 1, '410', '4', 'disponible', 4, NULL, NULL, '2026-03-16 18:44:25.293308', '2026-03-16 18:44:25.293308'),
	(41, 1, '501', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(42, 1, '502', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(43, 1, '503', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(44, 1, '504', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(45, 1, '505', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(46, 1, '506', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(47, 1, '507', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(48, 1, '508', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(49, 1, '509', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093'),
	(50, 1, '510', '5', 'disponible', 5, NULL, NULL, '2026-03-16 18:44:25.309093', '2026-03-16 18:44:25.309093');

-- Volcando estructura para tabla hotel.hoteles
CREATE TABLE IF NOT EXISTS `hoteles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `nit` varchar(20) NOT NULL,
  `razon_social` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `estrellas` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `logo_url` varchar(500) DEFAULT NULL,
  `resolucion_facturacion` varchar(255) DEFAULT NULL,
  `prefijo_facturacion` varchar(20) DEFAULT NULL,
  `pie_factura` text DEFAULT NULL,
  `moneda` varchar(3) NOT NULL DEFAULT 'COP',
  `pos_formato_default` varchar(4) NOT NULL DEFAULT '80mm',
  `fecha_registro` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `estado` enum('activo','suspendido') NOT NULL DEFAULT 'activo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_8158adae354184821ad5b24c09` (`nit`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.hoteles: ~0 rows (aproximadamente)
INSERT INTO `hoteles` (`id`, `nombre`, `nit`, `razon_social`, `direccion`, `ciudad`, `pais`, `telefono`, `email`, `estrellas`, `descripcion`, `logo_url`, `resolucion_facturacion`, `prefijo_facturacion`, `pie_factura`, `moneda`, `pos_formato_default`, `fecha_registro`, `createdAt`, `updatedAt`, `estado`) VALUES
	(1, 'Hotel Valhalla', '123456789', NULL, 'Calle 10 No. 5-50', 'Monteria', 'Colombia', '+57 1 1234567', 'info@hotelvalhalla.com', 5, 'Hotel 5 estrellas con servicios premium', NULL, NULL, NULL, NULL, 'COP', '80mm', '2026-03-14 13:08:09.434758', '2026-03-14 13:08:09.434758', '2026-03-14 13:08:09.434758', 'activo');

-- Volcando estructura para tabla hotel.medios_pago
CREATE TABLE IF NOT EXISTS `medios_pago` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  `requiere_referencia` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_beeebc04aa15c1104f74d39ed5` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.medios_pago: ~7 rows (aproximadamente)
INSERT INTO `medios_pago` (`id`, `nombre`, `descripcion`, `activo`, `requiere_referencia`, `created_at`) VALUES
	(1, 'efectivo', NULL, 1, 0, '2026-03-16 18:33:33.021174'),
	(2, 'tarjeta_credito', NULL, 1, 1, '2026-03-16 18:33:33.027964'),
	(3, 'tarjeta_debito', NULL, 1, 1, '2026-03-16 18:33:33.031024'),
	(4, 'transferencia_bancaria', NULL, 1, 1, '2026-03-16 18:33:33.032384'),
	(5, 'nequi', NULL, 1, 1, '2026-03-16 18:33:33.033826'),
	(6, 'daviplata', NULL, 1, 1, '2026-03-16 18:33:33.035052'),
	(7, 'pse', NULL, 1, 1, '2026-03-16 18:33:33.037164');

-- Volcando estructura para tabla hotel.pagos
CREATE TABLE IF NOT EXISTS `pagos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) NOT NULL,
  `id_medio_pago` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `monto_recibido` decimal(12,2) DEFAULT NULL,
  `cambio_devuelto` decimal(12,2) NOT NULL DEFAULT 0.00,
  `referencia_pago` varchar(255) DEFAULT NULL,
  `id_empleado_registro` int(11) DEFAULT NULL,
  `estado` varchar(255) NOT NULL DEFAULT 'completado',
  `observaciones` text DEFAULT NULL,
  `fecha_pago` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_a5401e3f720431de8d3ad940713` (`id_factura`),
  KEY `FK_4e18b9822619a42675ee57bce6a` (`id_medio_pago`),
  CONSTRAINT `FK_4e18b9822619a42675ee57bce6a` FOREIGN KEY (`id_medio_pago`) REFERENCES `medios_pago` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_a5401e3f720431de8d3ad940713` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.pagos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.pedido_cambios
CREATE TABLE IF NOT EXISTS `pedido_cambios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `estado_anterior` enum('pendiente','en_preparacion','listo','entregado','cancelado') NOT NULL,
  `estado_nuevo` enum('pendiente','en_preparacion','listo','entregado','cancelado') NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `razon_cambio` text DEFAULT NULL,
  `timestamp` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_pedido` (`id_pedido`),
  CONSTRAINT `FK_0286c87a617b0fd8ca4f74a65fc` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.pedido_cambios: ~10 rows (aproximadamente)
INSERT INTO `pedido_cambios` (`id`, `id_pedido`, `estado_anterior`, `estado_nuevo`, `usuario_id`, `razon_cambio`, `timestamp`) VALUES
	(1, 14, 'pendiente', 'en_preparacion', 13, NULL, '2026-04-06 01:52:55.413706'),
	(2, 14, 'en_preparacion', 'entregado', 13, NULL, '2026-04-06 01:52:59.682607'),
	(3, 13, 'pendiente', 'en_preparacion', 6, NULL, '2026-04-06 01:54:13.124846'),
	(4, 12, 'pendiente', 'en_preparacion', 6, NULL, '2026-04-06 01:54:15.602336'),
	(5, 11, 'pendiente', 'en_preparacion', 6, NULL, '2026-04-06 01:54:17.787690'),
	(6, 10, 'pendiente', 'en_preparacion', 6, NULL, '2026-04-06 01:54:19.170678'),
	(7, 13, 'en_preparacion', 'entregado', 6, NULL, '2026-04-06 01:54:21.139868'),
	(8, 12, 'en_preparacion', 'entregado', 6, NULL, '2026-04-06 01:54:23.390142'),
	(9, 11, 'en_preparacion', 'entregado', 6, NULL, '2026-04-06 01:54:25.315567'),
	(10, 10, 'en_preparacion', 'entregado', 6, NULL, '2026-04-06 01:54:27.215513');

-- Volcando estructura para tabla hotel.pedido_items
CREATE TABLE IF NOT EXISTS `pedido_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `id_servicio` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `precio_unitario_snapshot` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `nombre_servicio_snapshot` varchar(150) NOT NULL,
  `observacion` varchar(300) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `FK_7ba7b59a72913982e3dc3217796` (`id_pedido`),
  KEY `FK_4a06c038d0e1feeaf700c93a916` (`id_servicio`),
  CONSTRAINT `FK_4a06c038d0e1feeaf700c93a916` FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_7ba7b59a72913982e3dc3217796` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.pedido_items: ~39 rows (aproximadamente)
INSERT INTO `pedido_items` (`id`, `id_pedido`, `id_servicio`, `cantidad`, `precio_unitario_snapshot`, `subtotal`, `nombre_servicio_snapshot`, `observacion`, `created_at`) VALUES
	(1, 1, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-16 19:11:43.978660'),
	(2, 1, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-03-16 19:11:43.985090'),
	(3, 1, 5, 1, 7000.00, 7000.00, 'Té aromático', NULL, '2026-03-16 19:11:43.993662'),
	(4, 2, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-17 18:49:25.083237'),
	(5, 2, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-03-17 18:49:25.090675'),
	(6, 2, 2, 1, 12000.00, 12000.00, 'Cappuccino', NULL, '2026-03-17 18:49:25.098936'),
	(7, 2, 4, 1, 10000.00, 10000.00, 'Chocolate caliente', NULL, '2026-03-17 18:49:25.103505'),
	(8, 3, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-19 20:06:24.486568'),
	(9, 3, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-03-19 20:06:24.493603'),
	(10, 3, 2, 1, 12000.00, 12000.00, 'Cappuccino', NULL, '2026-03-19 20:06:24.499746'),
	(11, 3, 4, 1, 10000.00, 10000.00, 'Chocolate caliente', NULL, '2026-03-19 20:06:24.505597'),
	(12, 4, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-19 22:42:28.644544'),
	(13, 4, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-03-19 22:42:28.650051'),
	(14, 4, 2, 1, 12000.00, 12000.00, 'Cappuccino', NULL, '2026-03-19 22:42:28.653200'),
	(15, 4, 4, 1, 10000.00, 10000.00, 'Chocolate caliente', NULL, '2026-03-19 22:42:28.658681'),
	(16, 5, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-19 23:32:05.990898'),
	(17, 5, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-03-19 23:32:05.996897'),
	(18, 5, 2, 1, 12000.00, 12000.00, 'Cappuccino', NULL, '2026-03-19 23:32:06.000815'),
	(19, 5, 4, 1, 10000.00, 10000.00, 'Chocolate caliente', NULL, '2026-03-19 23:32:06.007342'),
	(20, 6, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-19 23:47:18.778944'),
	(21, 6, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-03-19 23:47:18.782734'),
	(22, 6, 2, 1, 12000.00, 12000.00, 'Cappuccino', NULL, '2026-03-19 23:47:18.785853'),
	(23, 6, 4, 1, 10000.00, 10000.00, 'Chocolate caliente', NULL, '2026-03-19 23:47:18.789594'),
	(24, 7, 8, 1, 6000.00, 6000.00, 'Croissant', NULL, '2026-03-20 00:23:28.154374'),
	(25, 7, 6, 2, 9000.00, 18000.00, 'Jugo natural', NULL, '2026-03-20 00:23:28.163420'),
	(26, 7, 3, 1, 13000.00, 13000.00, 'Latte', NULL, '2026-03-20 00:23:28.168471'),
	(27, 7, 9, 1, 11000.00, 11000.00, 'Postre del día', NULL, '2026-03-20 00:23:28.173976'),
	(28, 8, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-03-20 00:25:31.444855'),
	(29, 8, 1, 3, 8000.00, 24000.00, 'Café americano', NULL, '2026-03-20 00:25:31.449813'),
	(30, 8, 2, 3, 12000.00, 36000.00, 'Cappuccino', NULL, '2026-03-20 00:25:31.453484'),
	(31, 8, 4, 1, 10000.00, 10000.00, 'Chocolate caliente', NULL, '2026-03-20 00:25:31.457093'),
	(32, 9, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-04-02 00:05:17.718300'),
	(33, 9, 1, 1, 8000.00, 8000.00, 'Café americano', NULL, '2026-04-02 00:05:17.726340'),
	(34, 9, 8, 1, 6000.00, 6000.00, 'Croissant', NULL, '2026-04-02 00:05:17.732986'),
	(35, 10, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-04-06 01:43:30.293424'),
	(36, 10, 5, 1, 7000.00, 7000.00, 'Té aromático', NULL, '2026-04-06 01:43:30.305389'),
	(37, 11, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-04-06 01:43:54.041953'),
	(38, 11, 5, 1, 7000.00, 7000.00, 'Té aromático', NULL, '2026-04-06 01:43:54.070578'),
	(39, 12, 10, 1, 5000.00, 5000.00, 'Agua mineral', NULL, '2026-04-06 01:44:09.182418'),
	(40, 12, 5, 1, 7000.00, 7000.00, 'Té aromático', NULL, '2026-04-06 01:44:09.202968'),
	(41, 14, 58, 1, 180000.00, 180000.00, 'Tour de aventura', NULL, '2026-04-06 01:46:37.512640'),
	(42, 13, 2, 1, 12000.00, 12000.00, 'Cappuccino', NULL, '2026-04-06 01:46:37.514164');

-- Volcando estructura para tabla hotel.pedidos
CREATE TABLE IF NOT EXISTS `pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_reserva` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `tipo_entrega` enum('delivery','recogida') NOT NULL DEFAULT 'delivery',
  `estado_pedido` enum('pendiente','en_preparacion','listo','entregado','cancelado') NOT NULL DEFAULT 'pendiente',
  `categoria` varchar(50) NOT NULL,
  `nota_cliente` text DEFAULT NULL,
  `nota_empleado` text DEFAULT NULL,
  `id_empleado_atiende` int(11) DEFAULT NULL,
  `total_pedido` decimal(12,2) NOT NULL DEFAULT 0.00,
  `fecha_pedido` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `fecha_actualizacion` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `fecha_entrega` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_283ef166465066aa1a16c1656f` (`categoria`),
  KEY `IDX_fe4047d5c52db9ed3bf173ff6c` (`estado_pedido`),
  KEY `IDX_913871948e8bdc9b98c3912117` (`id_hotel`),
  KEY `IDX_2cbd06849c6ee82a099e00dd35` (`id_reserva`),
  KEY `FK_084336bed940d710a81fa96e59c` (`id_cliente`),
  CONSTRAINT `FK_084336bed940d710a81fa96e59c` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_2cbd06849c6ee82a099e00dd353` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.pedidos: ~14 rows (aproximadamente)
INSERT INTO `pedidos` (`id`, `id_reserva`, `id_cliente`, `id_hotel`, `tipo_entrega`, `estado_pedido`, `categoria`, `nota_cliente`, `nota_empleado`, `id_empleado_atiende`, `total_pedido`, `fecha_pedido`, `fecha_actualizacion`, `fecha_entrega`) VALUES
	(1, 3, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 20000.00, '2026-03-16 19:11:43.969659', '2026-03-16 19:12:00.000000', NULL),
	(2, 4, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 35000.00, '2026-03-17 18:49:25.069990', '2026-03-17 18:50:15.000000', NULL),
	(3, 5, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 35000.00, '2026-03-19 20:06:24.465331', '2026-03-19 20:10:43.000000', NULL),
	(4, 10, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 35000.00, '2026-03-19 22:42:28.639427', '2026-03-19 22:42:42.000000', NULL),
	(5, 11, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 35000.00, '2026-03-19 23:32:05.985313', '2026-03-19 23:32:24.000000', NULL),
	(6, 12, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 35000.00, '2026-03-19 23:47:18.773515', '2026-03-19 23:47:33.000000', NULL),
	(7, 12, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 48000.00, '2026-03-20 00:23:28.142852', '2026-03-20 00:23:36.000000', NULL),
	(8, 13, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 75000.00, '2026-03-20 00:25:31.428476', '2026-03-20 00:25:46.000000', NULL),
	(9, 14, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 19000.00, '2026-04-02 00:05:17.711904', '2026-04-02 00:09:16.000000', NULL),
	(10, 15, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 12000.00, '2026-04-06 01:43:30.275464', '2026-04-06 01:54:27.000000', '2026-04-06 01:54:27'),
	(11, 15, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 12000.00, '2026-04-06 01:43:54.029067', '2026-04-06 01:54:25.000000', '2026-04-06 01:54:25'),
	(12, 15, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 12000.00, '2026-04-06 01:44:09.175902', '2026-04-06 01:54:23.000000', '2026-04-06 01:54:23'),
	(13, 15, 1, 1, 'delivery', 'entregado', 'cafeteria', NULL, NULL, 6, 12000.00, '2026-04-06 01:46:37.489270', '2026-04-06 01:54:21.000000', '2026-04-06 01:54:21'),
	(14, 15, 1, 1, 'recogida', 'entregado', 'tours', NULL, NULL, 13, 180000.00, '2026-04-06 01:46:37.490134', '2026-04-06 01:52:59.000000', '2026-04-06 01:52:59');

-- Volcando estructura para tabla hotel.refresh_tokens
CREATE TABLE IF NOT EXISTS `refresh_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(500) NOT NULL,
  `userId` int(11) NOT NULL,
  `userType` varchar(255) NOT NULL,
  `expiresAt` datetime NOT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `isRevoked` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_4542dd2f38a61354a040ba9fd5` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.refresh_tokens: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.reservas
CREATE TABLE IF NOT EXISTS `reservas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `id_tipo_habitacion` int(11) DEFAULT NULL,
  `id_habitacion` int(11) DEFAULT NULL,
  `checkin_previsto` date NOT NULL,
  `checkout_previsto` date NOT NULL,
  `checkin_real` datetime DEFAULT NULL,
  `checkout_real` datetime DEFAULT NULL,
  `numero_huespedes` smallint(6) NOT NULL,
  `estado_reserva` varchar(255) NOT NULL DEFAULT 'reservada',
  `origen_reserva` varchar(255) NOT NULL DEFAULT 'web',
  `codigo_confirmacion` varchar(255) NOT NULL,
  `precio_noche_snapshot` decimal(12,2) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `cedula_cliente` varchar(255) DEFAULT NULL,
  `nombre_cliente` varchar(255) DEFAULT NULL,
  `email_cliente` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_60979d0c88cb5bbb92b7d4c9c8` (`codigo_confirmacion`),
  KEY `FK_3380e97aa0b9269b7b27a498749` (`id_cliente`),
  KEY `FK_ba8b7873a80b6362ff118da7d24` (`id_habitacion`),
  KEY `FK_ec5e6d36f1a0d2188ec75546617` (`id_tipo_habitacion`),
  CONSTRAINT `FK_3380e97aa0b9269b7b27a498749` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ba8b7873a80b6362ff118da7d24` FOREIGN KEY (`id_habitacion`) REFERENCES `habitaciones` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ec5e6d36f1a0d2188ec75546617` FOREIGN KEY (`id_tipo_habitacion`) REFERENCES `tipos_habitacion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.reservas: ~15 rows (aproximadamente)
INSERT INTO `reservas` (`id`, `id_cliente`, `id_hotel`, `id_tipo_habitacion`, `id_habitacion`, `checkin_previsto`, `checkout_previsto`, `checkin_real`, `checkout_real`, `numero_huespedes`, `estado_reserva`, `origen_reserva`, `codigo_confirmacion`, `precio_noche_snapshot`, `observaciones`, `cedula_cliente`, `nombre_cliente`, `email_cliente`, `created_at`, `updated_at`, `deleted_at`, `deleted_by`) VALUES
	(1, 1, 1, 1, 1, '2026-03-15', '2026-03-21', NULL, NULL, 1, 'cancelada', 'web', 'RES-MMTTZM5O-QW4WPJ', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-16 18:45:11.154089', '2026-03-16 18:50:49.000000', NULL, NULL),
	(2, 1, 1, 1, 1, '2026-03-15', '2026-03-21', '2026-03-16 18:51:24', '2026-03-16 18:54:50', 1, 'completada', 'web', 'RES-MMTU741F-FR6TN6', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-16 18:51:00.920990', '2026-03-16 18:54:50.000000', NULL, NULL),
	(3, 1, 1, 1, 1, '2026-03-16', '2026-03-21', '2026-03-16 19:10:35', '2026-03-16 19:12:29', 1, 'completada', 'web', 'RES-MMTUVQLJ-ROQPOK', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-16 19:10:09.907073', '2026-03-16 19:12:29.000000', NULL, NULL),
	(4, 1, 1, 1, 1, '2026-03-16', '2026-03-21', '2026-03-16 20:07:10', '2026-03-17 18:56:20', 1, 'completada', 'web', 'RES-MMTWWKYB-LA728A', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-16 20:06:48.472746', '2026-03-17 18:56:20.000000', NULL, NULL),
	(5, 1, 1, 1, 1, '2026-03-19', '2026-03-24', '2026-03-19 19:56:27', '2026-03-19 20:16:46', 1, 'completada', 'web', 'RES-MMY6TWTA-UKHFA4', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 19:55:44.744149', '2026-03-19 20:16:46.000000', NULL, NULL),
	(6, 1, 1, 1, 1, '2026-03-19', '2026-03-24', '2026-03-19 20:24:57', '2026-03-19 20:25:14', 1, 'completada', 'web', 'RES-MMY7TXRB-0NZCBH', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 20:23:45.584854', '2026-03-19 20:25:14.000000', NULL, NULL),
	(7, 1, 1, 1, 1, '2026-03-19', '2026-03-28', '2026-03-19 20:45:07', '2026-03-19 20:45:30', 1, 'completada', 'web', 'RES-MMY83QSN-2J1P0J', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 20:31:23.118021', '2026-03-19 20:45:30.000000', NULL, NULL),
	(8, 1, 1, 1, 1, '2026-03-19', '2026-03-21', '2026-03-19 20:58:07', '2026-03-19 21:02:47', 1, 'completada', 'web', 'RES-MMY91H8D-Q3V6FA', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 20:57:37.041290', '2026-03-19 21:02:47.000000', NULL, NULL),
	(9, 1, 1, 1, 1, '2026-03-19', '2026-03-21', '2026-03-19 22:08:23', '2026-03-19 22:26:15', 1, 'completada', 'web', 'RES-MMYBJNHZ-CVDUXH', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 22:07:44.196788', '2026-03-19 22:26:15.000000', NULL, NULL),
	(10, 1, 1, 1, 1, '2026-03-19', '2026-03-27', '2026-03-19 22:41:50', '2026-03-19 23:45:46', 1, 'completada', 'web', 'RES-MMYCQXLF-URD8YG', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 22:41:23.482067', '2026-03-19 23:45:46.000000', NULL, NULL),
	(11, 1, 1, 1, 2, '2026-03-19', '2026-03-21', '2026-03-19 23:31:21', '2026-03-19 23:45:53', 1, 'completada', 'web', 'RES-MMYEIILD-IAC9ZJ', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 23:30:50.024593', '2026-03-19 23:45:53.000000', NULL, NULL),
	(12, 1, 1, 1, 1, '2026-03-19', '2026-03-21', '2026-03-19 23:46:55', '2026-03-20 00:23:58', 1, 'completada', 'web', 'RES-MMYF2ED7-JUURX8', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-19 23:46:17.662886', '2026-03-20 00:23:58.000000', NULL, NULL),
	(13, 1, 1, 1, 1, '2026-03-19', '2026-03-20', '2026-03-20 00:25:03', '2026-03-20 00:27:10', 1, 'completada', 'web', 'RES-MMYGFRJJ-9IPK93', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-03-20 00:24:40.882131', '2026-03-20 00:27:10.000000', NULL, NULL),
	(14, 1, 1, 1, 1, '2026-04-01', '2026-04-04', '2026-04-02 00:04:14', '2026-04-02 00:12:48', 1, 'completada', 'web', 'RES-MNH0DA2J-344R2K', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-04-02 00:02:28.422569', '2026-04-02 00:12:48.000000', NULL, NULL),
	(15, 1, 1, 1, 1, '2026-04-05', '2026-04-09', '2026-04-06 01:25:15', '2026-05-08 23:18:59', 1, 'completada', 'web', 'RES-MNMSOW4R-3KGVPA', 80000.00, NULL, '50919231', 'Juan', 'sena@gmail.com', '2026-04-06 01:14:10.354779', '2026-05-08 23:18:59.000000', NULL, NULL);

-- Volcando estructura para tabla hotel.resoluciones_facturacion
CREATE TABLE IF NOT EXISTS `resoluciones_facturacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `numero_resolucion` varchar(80) NOT NULL,
  `prefijo` varchar(20) NOT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `rango_desde` int(11) NOT NULL,
  `rango_hasta` int(11) NOT NULL,
  `numero_actual` int(11) NOT NULL DEFAULT 0,
  `tipo_documento` varchar(40) NOT NULL DEFAULT 'factura_venta',
  `ambiente` enum('desarrollo','produccion') NOT NULL DEFAULT 'desarrollo',
  `estado` enum('activa','inactiva','vencida','agotada') NOT NULL DEFAULT 'activa',
  `observaciones` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `idx_resoluciones_hotel_estado` (`id_hotel`,`estado`),
  KEY `idx_resoluciones_hotel_prefijo` (`id_hotel`,`prefijo`),
  CONSTRAINT `fk_resoluciones_facturacion_hoteles` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla hotel.resoluciones_facturacion: ~0 rows (aproximadamente)
INSERT INTO `resoluciones_facturacion` (`id`, `id_hotel`, `numero_resolucion`, `prefijo`, `fecha_resolucion`, `fecha_inicio`, `fecha_fin`, `rango_desde`, `rango_hasta`, `numero_actual`, `tipo_documento`, `ambiente`, `estado`, `observaciones`, `created_at`, `updated_at`) VALUES
	(1, 1, 'DEV-VALHALLA-2026', 'FV', '2026-01-01', '2026-01-01', '2030-12-31', 1, 999999, 0, 'factura_venta', 'desarrollo', 'activa', 'Resolucion ficticia para desarrollo local. No usar como dato fiscal real.', '2026-05-08 22:56:26.724561', '2026-05-08 22:56:26.724561');

-- Volcando estructura para tabla hotel.room_incidents
CREATE TABLE IF NOT EXISTS `room_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_reserva` int(11) DEFAULT NULL,
  `id_habitacion` int(11) NOT NULL,
  `tipo` enum('daño','mantenimiento','limpieza','cliente_complaint','otros') NOT NULL DEFAULT 'otros',
  `estado` enum('reported','in_progress','resolved','cancelled') NOT NULL DEFAULT 'reported',
  `descripcion` text NOT NULL,
  `tipo_reportador` varchar(255) NOT NULL,
  `id_empleado_atiende` int(11) DEFAULT NULL,
  `nota_resolucion` text DEFAULT NULL,
  `prioridad` enum('baja','media','alta','urgente') NOT NULL DEFAULT 'media',
  `cargo_adicional` decimal(12,2) DEFAULT NULL,
  `descripcion_cargo` varchar(255) DEFAULT NULL,
  `fecha_reporte` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `fecha_resolucion` datetime DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `id_cliente` int(11) DEFAULT NULL,
  `id_empleado_reporta` int(11) NOT NULL,
  `nombre_empleado_reporta` varchar(100) NOT NULL,
  `area_asignada` varchar(50) NOT NULL,
  `nombre_empleado_atiende` varchar(100) DEFAULT NULL,
  `es_responsabilidad_cliente` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `IDX_278d5affdb28e8cf0be586a546` (`tipo`),
  KEY `IDX_79f50bef89d407ad90c0b0a0fb` (`estado`),
  KEY `IDX_55f5140708259d519bc6b2ba04` (`id_habitacion`),
  KEY `IDX_cf3831526f1d77090738dbafaf` (`id_reserva`),
  KEY `IDX_cd9f95a15fbef1ef154471154e` (`area_asignada`),
  KEY `IDX_b3802ffd424d730fc5d5c02677` (`id_cliente`),
  CONSTRAINT `FK_55f5140708259d519bc6b2ba043` FOREIGN KEY (`id_habitacion`) REFERENCES `habitaciones` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_cf3831526f1d77090738dbafafe` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.room_incidents: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.servicios
CREATE TABLE IF NOT EXISTS `servicios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria` enum('cafeteria','lavanderia','spa','room_service','minibar','transporte','tours','eventos','mantenimiento','otros') NOT NULL DEFAULT 'otros',
  `es_alcoholico` tinyint(1) NOT NULL DEFAULT 0,
  `precio_unitario` decimal(12,2) NOT NULL,
  `unidad_medida` varchar(50) NOT NULL DEFAULT 'unidad',
  `imagen_url` varchar(500) DEFAULT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  `disponible_delivery` tinyint(4) NOT NULL DEFAULT 1,
  `disponible_recogida` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `id_categoria_servicios` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_78f42e31050b44ccf6f2e28e07` (`categoria`),
  KEY `IDX_cd924a156b46a432f6e906edda` (`id_hotel`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.servicios: ~71 rows (aproximadamente)
INSERT INTO `servicios` (`id`, `id_hotel`, `nombre`, `descripcion`, `categoria`, `es_alcoholico`, `precio_unitario`, `unidad_medida`, `imagen_url`, `activo`, `disponible_delivery`, `disponible_recogida`, `created_at`, `updated_at`, `id_categoria_servicios`) VALUES
	(1, 1, 'Café americano', 'Café tradicional', 'cafeteria', 0, 8000.00, 'taza', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(2, 1, 'Cappuccino', 'Café con leche', 'cafeteria', 0, 12000.00, 'taza', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(3, 1, 'Latte', 'Café latte', 'cafeteria', 0, 13000.00, 'taza', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(4, 1, 'Chocolate caliente', 'Bebida caliente', 'cafeteria', 0, 10000.00, 'taza', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(5, 1, 'Té aromático', 'Infusión natural', 'cafeteria', 0, 7000.00, 'taza', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(6, 1, 'Jugo natural', 'Jugo de frutas', 'cafeteria', 0, 9000.00, 'vaso', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(7, 1, 'Sandwich mixto', 'Jamón y queso', 'cafeteria', 0, 15000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(8, 1, 'Croissant', 'Panadería', 'cafeteria', 0, 6000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(9, 1, 'Postre del día', 'Postre especial', 'cafeteria', 0, 11000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(10, 1, 'Agua mineral', 'Agua embotellada', 'cafeteria', 0, 5000.00, 'botella', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.418773', NULL),
	(11, 1, 'Desayuno americano', 'Huevos café pan', 'room_service', 0, 25000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(12, 1, 'Desayuno continental', 'Pan frutas café', 'room_service', 0, 22000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(13, 1, 'Almuerzo ejecutivo', 'Menú del día', 'room_service', 0, 35000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(14, 1, 'Cena gourmet', 'Cena especial', 'room_service', 0, 45000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(15, 1, 'Hamburguesa', 'Hamburguesa premium', 'room_service', 0, 30000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(16, 1, 'Pizza personal', 'Pizza individual', 'room_service', 0, 28000.00, 'unidad', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(17, 1, 'Ensalada', 'Ensalada saludable', 'room_service', 0, 20000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(18, 1, 'Sopa del día', 'Sopa caliente', 'room_service', 0, 15000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(19, 1, 'Fruta fresca', 'Fruta picada', 'room_service', 0, 12000.00, 'plato', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(20, 1, 'Bebida gaseosa', 'Refresco', 'room_service', 0, 6000.00, 'unidad', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.446415', NULL),
	(21, 1, 'Agua minibar', 'Agua pequeña', 'minibar', 0, 5000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(22, 1, 'Gaseosa', 'Refresco lata', 'minibar', 0, 7000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(23, 1, 'Cerveza', 'Cerveza nacional', 'minibar', 1, 9000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(24, 1, 'Chocolate', 'Snack dulce', 'minibar', 0, 6000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(25, 1, 'Papas fritas', 'Snack salado', 'minibar', 0, 8000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(26, 1, 'Maní', 'Snack', 'minibar', 0, 5000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(27, 1, 'Jugo caja', 'Jugo procesado', 'minibar', 0, 6000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(28, 1, 'Galletas', 'Snack dulce', 'minibar', 0, 7000.00, 'unidad', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.452679', NULL),
	(29, 1, 'Masaje relajante', 'Masaje corporal', 'spa', 0, 90000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(30, 1, 'Masaje terapéutico', 'Masaje especializado', 'spa', 0, 120000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(31, 1, 'Sauna', 'Acceso sauna', 'spa', 0, 30000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(32, 1, 'Jacuzzi spa', 'Jacuzzi relajante', 'spa', 0, 40000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(33, 1, 'Limpieza facial', 'Tratamiento facial', 'spa', 0, 80000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(34, 1, 'Manicure', 'Cuidado uñas', 'spa', 0, 35000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(35, 1, 'Pedicure', 'Cuidado pies', 'spa', 0, 35000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(36, 1, 'Aromaterapia', 'Relajación', 'spa', 0, 50000.00, 'sesion', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.437150', NULL),
	(37, 1, 'Lavado básico', 'Lavado ropa', 'lavanderia', 0, 25000.00, 'kg', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(38, 1, 'Lavado express', 'Lavado rápido', 'lavanderia', 0, 40000.00, 'kg', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(39, 1, 'Planchado', 'Planchado', 'lavanderia', 0, 10000.00, 'prenda', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(40, 1, 'Lavado en seco', 'Ropa delicada', 'lavanderia', 0, 30000.00, 'prenda', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(41, 1, 'Lavado cobijas', 'Cobertores', 'lavanderia', 0, 45000.00, 'unidad', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(42, 1, 'Reparación ropa', 'Arreglos', 'lavanderia', 0, 20000.00, 'prenda', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(43, 1, 'Servicio premium', 'Lavado VIP', 'lavanderia', 0, 60000.00, 'kg', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-03-19 15:17:47.430514', NULL),
	(44, 1, 'Servicio taxi', 'Taxi en la ciudad', 'transporte', 0, 30000.00, 'viaje', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 7),
	(45, 1, 'Tour ciudad', 'Gu??a tur??stico por la ciudad', 'tours', 0, 150000.00, 'dia', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 8),
	(46, 1, 'Alquiler bicicleta', 'Bicicleta', 'transporte', 0, 25000.00, 'dia', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 7),
	(47, 1, 'Traslado aeropuerto', 'Transporte aeropuerto', 'transporte', 0, 80000.00, 'viaje', NULL, 1, 1, 0, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 7),
	(48, 1, 'Impresiones y fotocopias', 'Documentos', 'mantenimiento', 0, 2000.00, 'hoja', NULL, 1, 1, 1, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 10),
	(49, 1, 'Sal??n de reuniones', 'Sala empresarial por hora', 'eventos', 0, 100000.00, 'hora', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 9),
	(50, 1, 'Servicio despertador', 'Wake up call', 'mantenimiento', 0, 0.00, 'servicio', NULL, 1, 0, 1, '2026-03-16 19:07:35.873453', '2026-04-06 00:35:58.000000', 10),
	(51, 1, 'Taxi ejecutivo', 'Taxi de lujo con chofer', 'transporte', 0, 60000.00, 'viaje', NULL, 1, 1, 0, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 7),
	(52, 1, 'Van grupal', 'Transporte para grupos hasta 10 personas', 'transporte', 0, 120000.00, 'viaje', NULL, 1, 1, 0, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 7),
	(53, 1, 'Alquiler moto', 'Moto por d??a para recorridos', 'transporte', 0, 45000.00, 'dia', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 7),
	(54, 1, 'Servicio nocturno', 'Transporte nocturno con recargo', 'transporte', 0, 50000.00, 'viaje', NULL, 1, 1, 0, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 7),
	(55, 1, 'Traslado interurbano', 'Transporte a ciudades cercanas', 'transporte', 0, 200000.00, 'viaje', NULL, 1, 1, 0, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 7),
	(56, 1, 'Tour hist??rico', 'Recorrido por lugares hist??ricos', 'tours', 0, 120000.00, 'persona', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 8),
	(57, 1, 'Tour gastron??mico', 'Degustaci??n de comida local y regional', 'tours', 0, 95000.00, 'persona', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 8),
	(58, 1, 'Tour de aventura', 'Actividades outdoor y senderismo', 'tours', 0, 180000.00, 'persona', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 8),
	(59, 1, 'Tour nocturno', 'Recorrido nocturno por la ciudad', 'tours', 0, 75000.00, 'persona', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 8),
	(60, 1, 'Tour en lancha', 'Paseo fluvial guiado', 'tours', 0, 140000.00, 'persona', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 8),
	(61, 1, 'Sal??n de banquetes', 'Sal??n grande para celebraciones', 'eventos', 0, 500000.00, 'evento', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 9),
	(62, 1, 'Decoraci??n b??sica', 'Paquete decoraci??n est??ndar', 'eventos', 0, 250000.00, 'evento', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 9),
	(63, 1, 'Decoraci??n premium', 'Decoraci??n personalizada de lujo', 'eventos', 0, 600000.00, 'evento', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 9),
	(64, 1, 'Catering b??sico', 'Servicio de alimentaci??n para evento', 'eventos', 0, 35000.00, 'persona', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 9),
	(65, 1, 'Equipo audiovisual', 'Proyector, sonido y pantalla', 'eventos', 0, 200000.00, 'evento', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 9),
	(66, 1, 'Paquete cumplea??os', 'Decoraci??n, torta y atenci??n especial', 'eventos', 0, 350000.00, 'evento', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 9),
	(67, 1, 'Planchado de ropa', 'Plancha disponible en habitaci??n', 'mantenimiento', 0, 15000.00, 'servicio', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 10),
	(68, 1, 'Secador de cabello', 'Pr??stamo de secador profesional', 'mantenimiento', 0, 0.00, 'servicio', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 10),
	(69, 1, 'Kit de costura', 'Kit b??sico de costura y reparaciones', 'mantenimiento', 0, 0.00, 'servicio', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 10),
	(70, 1, 'Adaptador el??ctrico', 'Adaptador universal de corriente', 'mantenimiento', 0, 0.00, 'servicio', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 10),
	(71, 1, 'Solicitud mantenimiento', 'Reporte de da??o o solicitud de reparaci??n', 'mantenimiento', 0, 0.00, 'servicio', NULL, 1, 0, 1, '2026-04-06 00:35:58.000000', '2026-04-06 00:35:58.000000', 10);

-- Volcando estructura para tabla hotel.tax_profile_audit
CREATE TABLE IF NOT EXISTS `tax_profile_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entidad` varchar(50) NOT NULL,
  `id_entidad` int(11) NOT NULL,
  `tax_profile_anterior` varchar(50) DEFAULT NULL,
  `tax_profile_nuevo` varchar(50) NOT NULL,
  `razon_cambio` text DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `usuario_email` varchar(255) DEFAULT NULL,
  `fecha` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `ip_address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_ce25448b1f6c3d66ed3194882a` (`fecha`),
  KEY `IDX_4a21fce030f59fd7be730897e4` (`usuario_id`),
  KEY `IDX_96aae1f552cbb5090e4462aa91` (`id_entidad`),
  KEY `IDX_12dac26ca58599f620433c8243` (`entidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.tax_profile_audit: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.tax_rates
CREATE TABLE IF NOT EXISTS `tax_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `categoria_servicios_id` int(11) NOT NULL,
  `tipo_impuesto` enum('IVA','INC','OTROS') NOT NULL DEFAULT 'IVA',
  `tasa_porcentaje` decimal(5,2) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `aplica_a_residentes` tinyint(1) NOT NULL DEFAULT 1,
  `aplica_a_extranjeros` tinyint(1) NOT NULL DEFAULT 1,
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_vigencia_inicio` date NOT NULL DEFAULT curdate(),
  `fecha_vigencia_fin` date DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_1ec57dfc79ce416b4be25e8565` (`activa`),
  KEY `IDX_28bdbc0313f443f9ac1299c01b` (`tipo_impuesto`),
  KEY `IDX_136d30f7c4007e1a5ff0d4fcc8` (`categoria_servicios_id`),
  KEY `IDX_bcd0b0d4f3b284218c895558d1` (`id_hotel`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.tax_rates: ~13 rows (aproximadamente)
INSERT INTO `tax_rates` (`id`, `id_hotel`, `categoria_servicios_id`, `tipo_impuesto`, `tasa_porcentaje`, `descripcion`, `aplica_a_residentes`, `aplica_a_extranjeros`, `activa`, `fecha_vigencia_inicio`, `fecha_vigencia_fin`, `notas`, `created_at`, `updated_at`, `deleted_at`, `deleted_by`) VALUES
	(1, 1, 1, 'IVA', 19.00, 'IVA Alojamiento - Residentes', 1, 0, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.351731', '2026-03-19 15:17:47.351731', NULL, NULL),
	(2, 1, 1, 'IVA', 0.00, 'IVA Alojamiento - Extranjeros no residentes', 0, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.351731', '2026-03-19 15:17:47.351731', NULL, NULL),
	(3, 1, 2, 'INC', 8.00, 'INC Restaurante/Cafetería - Impuesto Nacional al Consumo', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.361443', '2026-03-19 15:17:47.361443', NULL, NULL),
	(4, 1, 3, 'IVA', 19.00, 'IVA Minibar - Productos normales (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.367604', '2026-03-19 15:17:47.367604', NULL, NULL),
	(5, 1, 3, 'IVA', 0.00, 'IVA Minibar - Productos básicos excluidos (0%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.367604', '2026-03-19 15:17:47.367604', NULL, NULL),
	(6, 1, 4, 'IVA', 19.00, 'IVA Lavandería (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.375771', '2026-03-19 15:17:47.375771', NULL, NULL),
	(7, 1, 5, 'IVA', 19.00, 'IVA Spa - Servicios de bienestar (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.381374', '2026-03-19 15:17:47.381374', NULL, NULL),
	(8, 1, 6, 'IVA', 19.00, 'IVA Room Service - Comidas sólidas (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.384580', '2026-03-19 15:17:47.384580', NULL, NULL),
	(9, 1, 6, 'INC', 8.00, 'INC Room Service - Bebidas alcohólicas/no alcohólicas (8%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.384580', '2026-03-19 15:17:47.384580', NULL, NULL),
	(10, 1, 7, 'IVA', 19.00, 'IVA Transporte - Traslados (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.389002', '2026-03-19 15:17:47.389002', NULL, NULL),
	(11, 1, 8, 'IVA', 19.00, 'IVA Tours - Excursiones (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.396362', '2026-03-19 15:17:47.396362', NULL, NULL),
	(12, 1, 9, 'IVA', 19.00, 'IVA Eventos - Salonería (19%)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.404094', '2026-03-19 15:17:47.404094', NULL, NULL),
	(13, 1, 10, 'IVA', 0.00, 'Mantenimiento - Servicio interno (No aplica impuesto)', 1, 1, 1, '2026-03-19', NULL, NULL, '2026-03-19 15:17:47.412333', '2026-03-19 15:17:47.412333', NULL, NULL);

-- Volcando estructura para tabla hotel.tax_rates_audit
CREATE TABLE IF NOT EXISTS `tax_rates_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tax_rates_id` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `operacion` enum('CREATE','UPDATE','DELETE') NOT NULL,
  `tasa_anterior` decimal(5,2) DEFAULT NULL,
  `tasa_nueva` decimal(5,2) DEFAULT NULL,
  `razon_cambio` text DEFAULT NULL,
  `fecha` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `IDX_tax_rates_audit_hotel` (`id_hotel`),
  KEY `IDX_tax_rates_audit_usuario` (`usuario_id`),
  KEY `IDX_tax_rates_audit_fecha` (`fecha`),
  CONSTRAINT `FK_tax_rates_audit_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.tax_rates_audit: ~0 rows (aproximadamente)

-- Volcando estructura para tabla hotel.tipo_habitacion_amenidades
CREATE TABLE IF NOT EXISTS `tipo_habitacion_amenidades` (
  `id_tipo_habitacion` int(11) NOT NULL,
  `id_amenidad` int(11) NOT NULL,
  PRIMARY KEY (`id_tipo_habitacion`,`id_amenidad`),
  KEY `IDX_1ec4b4184d72ebd1a6d3b34eda` (`id_tipo_habitacion`),
  KEY `IDX_24f59c2181126b984ad06e98c2` (`id_amenidad`),
  CONSTRAINT `FK_1ec4b4184d72ebd1a6d3b34edaf` FOREIGN KEY (`id_tipo_habitacion`) REFERENCES `tipos_habitacion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_24f59c2181126b984ad06e98c2d` FOREIGN KEY (`id_amenidad`) REFERENCES `amenidades` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.tipo_habitacion_amenidades: ~36 rows (aproximadamente)
INSERT INTO `tipo_habitacion_amenidades` (`id_tipo_habitacion`, `id_amenidad`) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 7),
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(2, 7),
	(3, 1),
	(3, 2),
	(3, 3),
	(3, 4),
	(3, 5),
	(3, 6),
	(3, 7),
	(4, 1),
	(4, 2),
	(4, 3),
	(4, 4),
	(4, 5),
	(4, 6),
	(4, 7),
	(4, 10),
	(5, 1),
	(5, 2),
	(5, 3),
	(5, 4),
	(5, 5),
	(5, 6),
	(5, 7),
	(5, 8),
	(5, 9),
	(5, 10);

-- Volcando estructura para tabla hotel.tipos_habitacion
CREATE TABLE IF NOT EXISTS `tipos_habitacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `nombre_tipo` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `capacidad_personas` smallint(6) NOT NULL,
  `precio_base` decimal(12,2) DEFAULT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `id_categoria_servicios` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_079e1ae966fd1fdcc15efa2a35` (`nombre_tipo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla hotel.tipos_habitacion: ~5 rows (aproximadamente)
INSERT INTO `tipos_habitacion` (`id`, `id_hotel`, `nombre_tipo`, `descripcion`, `capacidad_personas`, `precio_base`, `activo`, `created_at`, `updated_at`, `id_categoria_servicios`) VALUES
	(1, 1, 'Sencilla', 'Habitación estándar para una persona', 1, 80000.00, 1, '2026-03-16 18:44:25.136602', '2026-03-19 15:17:47.493226', NULL),
	(2, 1, 'Doble', 'Habitación para dos personas', 2, 120000.00, 1, '2026-03-16 18:44:25.136602', '2026-03-19 15:17:47.493226', NULL),
	(3, 1, 'Ejecutiva', 'Habitación ejecutiva con escritorio', 2, 180000.00, 1, '2026-03-16 18:44:25.136602', '2026-03-19 15:17:47.493226', NULL),
	(4, 1, 'Suite', 'Suite amplia con sala', 3, 250000.00, 1, '2026-03-16 18:44:25.136602', '2026-03-19 15:17:47.493226', NULL),
	(5, 1, 'Penthouse', 'Habitación de lujo premium', 5, 500000.00, 1, '2026-03-16 18:44:25.136602', '2026-03-19 15:17:47.493226', NULL);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
