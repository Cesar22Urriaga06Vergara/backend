-- ------------------------------------------------------------
-- Limpieza controlada de datos operativos/transaccionales
-- Base de datos: hotel
--
-- Version compatible con HeidiSQL/MariaDB sin DELIMITER ni PROCEDURE.
--
-- Conserva datos maestros:
-- empleados, clientes, hoteles, habitaciones, tipos_habitacion,
-- amenidades, tipo_habitacion_amenidades, categoria_servicios,
-- servicios, medios_pago, resoluciones_facturacion, tax_rates.
--
-- Ejecutar manualmente en ambiente local/desarrollo.
-- ------------------------------------------------------------

USE `hotel`;

SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------
-- Limpieza operativa
-- ------------------------------------------------------------

-- Caja.
DELETE FROM `caja_movimientos`;
DELETE FROM `caja_turnos`;

-- Pagos.
DELETE FROM `pagos`;

-- Facturacion.
DELETE FROM `factura_reimpresiones`;
DELETE FROM `detalle_factura_cambios`;
DELETE FROM `factura_cambios`;
DELETE FROM `detalle_facturas`;
DELETE FROM `facturas`;

-- Servicios consumidos y pedidos.
DELETE FROM `pedido_cambios`;
DELETE FROM `pedido_items`;
DELETE FROM `pedidos`;

-- Folios, incidencias y reservas.
DELETE FROM `folios`;
DELETE FROM `room_incidents`;
DELETE FROM `reservas`;

-- Auditoria y trazabilidad.
DELETE FROM `audit_logs`;
DELETE FROM `tax_profile_audit`;
DELETE FROM `tax_rates_audit`;

-- Sesiones de autenticacion: se conserva por defecto para no cerrar sesiones activas.
-- Descomenta si quieres forzar nuevo login en todas las pruebas.
-- DELETE FROM `refresh_tokens`;

-- ------------------------------------------------------------
-- Reinicio de consecutivos operativos
-- ------------------------------------------------------------

ALTER TABLE `caja_movimientos` AUTO_INCREMENT = 1;
ALTER TABLE `caja_turnos` AUTO_INCREMENT = 1;
ALTER TABLE `pagos` AUTO_INCREMENT = 1;
ALTER TABLE `factura_reimpresiones` AUTO_INCREMENT = 1;
ALTER TABLE `detalle_factura_cambios` AUTO_INCREMENT = 1;
ALTER TABLE `factura_cambios` AUTO_INCREMENT = 1;
ALTER TABLE `detalle_facturas` AUTO_INCREMENT = 1;
ALTER TABLE `facturas` AUTO_INCREMENT = 1;
ALTER TABLE `pedido_cambios` AUTO_INCREMENT = 1;
ALTER TABLE `pedido_items` AUTO_INCREMENT = 1;
ALTER TABLE `pedidos` AUTO_INCREMENT = 1;
ALTER TABLE `folios` AUTO_INCREMENT = 1;
ALTER TABLE `room_incidents` AUTO_INCREMENT = 1;
ALTER TABLE `reservas` AUTO_INCREMENT = 1;
ALTER TABLE `audit_logs` AUTO_INCREMENT = 1;
ALTER TABLE `tax_profile_audit` AUTO_INCREMENT = 1;
ALTER TABLE `tax_rates_audit` AUTO_INCREMENT = 1;

-- Si descomentaste refresh_tokens, puedes reiniciar tambien su consecutivo.
-- ALTER TABLE `refresh_tokens` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;

-- ------------------------------------------------------------
-- Verificacion rapida de maestros conservados
-- ------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM empleados) AS empleados,
  (SELECT COUNT(*) FROM clientes) AS clientes,
  (SELECT COUNT(*) FROM hoteles) AS hoteles,
  (SELECT COUNT(*) FROM habitaciones) AS habitaciones,
  (SELECT COUNT(*) FROM tipos_habitacion) AS tipos_habitacion,
  (SELECT COUNT(*) FROM amenidades) AS amenidades,
  (SELECT COUNT(*) FROM tipo_habitacion_amenidades) AS tipo_habitacion_amenidades,
  (SELECT COUNT(*) FROM categoria_servicios) AS categoria_servicios,
  (SELECT COUNT(*) FROM servicios) AS servicios,
  (SELECT COUNT(*) FROM medios_pago) AS medios_pago,
  (SELECT COUNT(*) FROM resoluciones_facturacion) AS resoluciones_facturacion,
  (SELECT COUNT(*) FROM tax_rates) AS tax_rates;

-- ------------------------------------------------------------
-- Verificacion rapida de tablas operativas principales
-- ------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM reservas) AS reservas,
  (SELECT COUNT(*) FROM folios) AS folios,
  (SELECT COUNT(*) FROM facturas) AS facturas,
  (SELECT COUNT(*) FROM detalle_facturas) AS detalle_facturas,
  (SELECT COUNT(*) FROM pagos) AS pagos,
  (SELECT COUNT(*) FROM pedidos) AS pedidos,
  (SELECT COUNT(*) FROM pedido_items) AS pedido_items,
  (SELECT COUNT(*) FROM caja_turnos) AS caja_turnos,
  (SELECT COUNT(*) FROM caja_movimientos) AS caja_movimientos,
  (SELECT COUNT(*) FROM room_incidents) AS room_incidents,
  (SELECT COUNT(*) FROM audit_logs) AS audit_logs;

-- Tablas operativas mencionadas en el alcance pero no presentes en el dump actual:
-- cierres_caja, movimientos_pago, transacciones, factura_detalles,
-- servicios_consumidos, consumos, ordenes_servicio, movimientos_folio,
-- huespedes_reserva, reserva_servicios, historial_reservas, estados_reserva,
-- logs, logs_auditoria, historial_cambios, trazabilidad.
