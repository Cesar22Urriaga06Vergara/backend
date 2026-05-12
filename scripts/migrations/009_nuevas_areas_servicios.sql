-- ============================================================
-- Migración 009: Nuevas áreas y servicios
-- Fecha: 2026-04-06
-- Descripción:
--   1. Extiende el ENUM de servicios.categoria con nuevas áreas
--   2. Corrige la categoría de servicios mal clasificados (44-50)
--   3. Agrega servicios para: transporte, tours, eventos, mantenimiento
--   4. Agrega empleados demo para cada área nueva
-- ============================================================

USE `hotel`;

-- ─── 1. Ampliar ENUM de servicios.categoria ──────────────────────────────────
-- (Ya aplicado si la BD fue creada con el dump actualizado)
-- ALTER TABLE `servicios`
--   MODIFY COLUMN `categoria`
--     ENUM('cafeteria','lavanderia','spa','room_service','minibar','transporte','tours','eventos','mantenimiento','otros')
--     NOT NULL DEFAULT 'otros';

-- ─── 2. Corregir servicios mal categorizados ─────────────────────────────────
-- Servicio taxi (44) → transporte
UPDATE `servicios` SET
  `categoria` = 'transporte',
  `id_categoria_servicios` = 7,
  `nombre` = 'Servicio taxi',
  `descripcion` = 'Taxi en la ciudad',
  `updated_at` = NOW()
WHERE `id` = 44;

-- Tour ciudad (45) → tours
UPDATE `servicios` SET
  `categoria` = 'tours',
  `id_categoria_servicios` = 8,
  `nombre` = 'Tour ciudad',
  `descripcion` = 'Guía turístico por la ciudad',
  `updated_at` = NOW()
WHERE `id` = 45;

-- Alquiler bicicleta (46) → transporte
UPDATE `servicios` SET
  `categoria` = 'transporte',
  `id_categoria_servicios` = 7,
  `updated_at` = NOW()
WHERE `id` = 46;

-- Traslado aeropuerto (47) → transporte
UPDATE `servicios` SET
  `categoria` = 'transporte',
  `id_categoria_servicios` = 7,
  `updated_at` = NOW()
WHERE `id` = 47;

-- Impresiones (48) → mantenimiento
UPDATE `servicios` SET
  `categoria` = 'mantenimiento',
  `id_categoria_servicios` = 10,
  `nombre` = 'Impresiones y fotocopias',
  `updated_at` = NOW()
WHERE `id` = 48;

-- Sala reuniones (49) → eventos
UPDATE `servicios` SET
  `categoria` = 'eventos',
  `id_categoria_servicios` = 9,
  `nombre` = 'Salón de reuniones',
  `descripcion` = 'Sala empresarial por hora',
  `updated_at` = NOW()
WHERE `id` = 49;

-- Servicio despertador (50) → mantenimiento
UPDATE `servicios` SET
  `categoria` = 'mantenimiento',
  `id_categoria_servicios` = 10,
  `updated_at` = NOW()
WHERE `id` = 50;

-- ─── 3. Nuevos servicios de Transporte ───────────────────────────────────────
INSERT IGNORE INTO `servicios`
  (`id`, `id_hotel`, `nombre`, `descripcion`, `categoria`, `id_categoria_servicios`, `es_alcoholico`, `precio_unitario`, `unidad_medida`, `imagen_url`, `activo`, `disponible_delivery`, `disponible_recogida`, `created_at`, `updated_at`)
VALUES
  (51, 1, 'Taxi ejecutivo', 'Taxi de lujo con chofer', 'transporte', 7, 0, 60000.00, 'viaje', NULL, 1, 1, 0, NOW(), NOW()),
  (52, 1, 'Van grupal', 'Transporte para grupos hasta 10 personas', 'transporte', 7, 0, 120000.00, 'viaje', NULL, 1, 1, 0, NOW(), NOW()),
  (53, 1, 'Alquiler moto', 'Moto por día para recorridos', 'transporte', 7, 0, 45000.00, 'dia', NULL, 1, 0, 1, NOW(), NOW()),
  (54, 1, 'Servicio nocturno', 'Transporte nocturno con recargo', 'transporte', 7, 0, 50000.00, 'viaje', NULL, 1, 1, 0, NOW(), NOW()),
  (55, 1, 'Traslado interurbano', 'Transporte a ciudades cercanas', 'transporte', 7, 0, 200000.00, 'viaje', NULL, 1, 1, 0, NOW(), NOW());

-- ─── 4. Nuevos servicios de Tours ────────────────────────────────────────────
INSERT IGNORE INTO `servicios`
  (`id`, `id_hotel`, `nombre`, `descripcion`, `categoria`, `id_categoria_servicios`, `es_alcoholico`, `precio_unitario`, `unidad_medida`, `imagen_url`, `activo`, `disponible_delivery`, `disponible_recogida`, `created_at`, `updated_at`)
VALUES
  (56, 1, 'Tour histórico', 'Recorrido por lugares históricos', 'tours', 8, 0, 120000.00, 'persona', NULL, 1, 0, 1, NOW(), NOW()),
  (57, 1, 'Tour gastronómico', 'Degustación de comida local y regional', 'tours', 8, 0, 95000.00, 'persona', NULL, 1, 0, 1, NOW(), NOW()),
  (58, 1, 'Tour de aventura', 'Actividades outdoor y senderismo', 'tours', 8, 0, 180000.00, 'persona', NULL, 1, 0, 1, NOW(), NOW()),
  (59, 1, 'Tour nocturno', 'Recorrido nocturno por la ciudad', 'tours', 8, 0, 75000.00, 'persona', NULL, 1, 0, 1, NOW(), NOW()),
  (60, 1, 'Tour en lancha', 'Paseo fluvial guiado', 'tours', 8, 0, 140000.00, 'persona', NULL, 1, 0, 1, NOW(), NOW());

-- ─── 5. Nuevos servicios de Eventos ──────────────────────────────────────────
INSERT IGNORE INTO `servicios`
  (`id`, `id_hotel`, `nombre`, `descripcion`, `categoria`, `id_categoria_servicios`, `es_alcoholico`, `precio_unitario`, `unidad_medida`, `imagen_url`, `activo`, `disponible_delivery`, `disponible_recogida`, `created_at`, `updated_at`)
VALUES
  (61, 1, 'Salón de banquetes', 'Salón grande para celebraciones', 'eventos', 9, 0, 500000.00, 'evento', NULL, 1, 0, 1, NOW(), NOW()),
  (62, 1, 'Decoración básica', 'Paquete decoración estándar', 'eventos', 9, 0, 250000.00, 'evento', NULL, 1, 0, 1, NOW(), NOW()),
  (63, 1, 'Decoración premium', 'Decoración personalizada de lujo', 'eventos', 9, 0, 600000.00, 'evento', NULL, 1, 0, 1, NOW(), NOW()),
  (64, 1, 'Catering básico', 'Servicio de alimentación para evento', 'eventos', 9, 0, 35000.00, 'persona', NULL, 1, 0, 1, NOW(), NOW()),
  (65, 1, 'Equipo audiovisual', 'Proyector, sonido y pantalla', 'eventos', 9, 0, 200000.00, 'evento', NULL, 1, 0, 1, NOW(), NOW()),
  (66, 1, 'Paquete cumpleaños', 'Decoración, torta y atención especial', 'eventos', 9, 0, 350000.00, 'evento', NULL, 1, 0, 1, NOW(), NOW());

-- ─── 6. Nuevos servicios de Mantenimiento ────────────────────────────────────
INSERT IGNORE INTO `servicios`
  (`id`, `id_hotel`, `nombre`, `descripcion`, `categoria`, `id_categoria_servicios`, `es_alcoholico`, `precio_unitario`, `unidad_medida`, `imagen_url`, `activo`, `disponible_delivery`, `disponible_recogida`, `created_at`, `updated_at`)
VALUES
  (67, 1, 'Planchado de ropa', 'Plancha disponible en habitación', 'mantenimiento', 10, 0, 15000.00, 'servicio', NULL, 1, 0, 1, NOW(), NOW()),
  (68, 1, 'Secador de cabello', 'Préstamo de secador profesional', 'mantenimiento', 10, 0, 0.00, 'servicio', NULL, 1, 0, 1, NOW(), NOW()),
  (69, 1, 'Kit de costura', 'Kit básico de costura y reparaciones', 'mantenimiento', 10, 0, 0.00, 'servicio', NULL, 1, 0, 1, NOW(), NOW()),
  (70, 1, 'Adaptador eléctrico', 'Adaptador universal de corriente', 'mantenimiento', 10, 0, 0.00, 'servicio', NULL, 1, 0, 1, NOW(), NOW()),
  (71, 1, 'Solicitud mantenimiento', 'Reporte de daño o solicitud de reparación', 'mantenimiento', 10, 0, 0.00, 'servicio', NULL, 1, 0, 1, NOW(), NOW());

-- ─── 7. Empleados demo para cada área nueva ──────────────────────────────────
-- Password seed: rotar antes de usar fuera de local
INSERT IGNORE INTO `empleados`
  (`id`, `id_hotel`, `cedula`, `nombre`, `apellido`, `email`, `password`, `rol`, `tax_profile`, `estado`, `createdAt`, `updatedAt`)
VALUES
  (7,  1, '345678901', 'Ana',     'García',  'lavanderia@gmail.com',    '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'lavanderia',    'RESIDENT', 'activo', NOW(), NOW()),
  (8,  1, '456789012', 'María',   'López',   'spa@gmail.com',           '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'spa',           'RESIDENT', 'activo', NOW(), NOW()),
  (9,  1, '567890123', 'Pedro',   'Ruiz',    'roomservice@gmail.com',   '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'room_service',  'RESIDENT', 'activo', NOW(), NOW()),
  (10, 1, '678901234', 'Laura',   'Díaz',    'minibar@gmail.com',       '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'minibar',       'RESIDENT', 'activo', NOW(), NOW()),
  (11, 1, '789012345', 'Carlos',  'Mora',    'transporte@gmail.com',    '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'transporte',    'RESIDENT', 'activo', NOW(), NOW()),
  (12, 1, '890123456', 'Sandra',  'Vega',    'tours@gmail.com',         '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'tours',         'RESIDENT', 'activo', NOW(), NOW()),
  (13, 1, '901234567', 'Diego',   'Pinto',   'eventos@gmail.com',       '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'eventos',       'RESIDENT', 'activo', NOW(), NOW()),
  (14, 1, '012345678', 'Juliana', 'Ríos',    'mantenimiento@gmail.com', '$2b$10$gR9wLTArbnDn97I4Pud5k.e9BXQL6B5k3Xm8zanMXd4.6l1R2ak96', 'mantenimiento', 'RESIDENT', 'activo', NOW(), NOW());

-- ─── Verificación ──────────────────────────────────────────────────────────
SELECT categoria, COUNT(*) as total
FROM servicios
GROUP BY categoria
ORDER BY categoria;
