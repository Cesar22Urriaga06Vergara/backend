/**
 * Carga usuarios seed de areas operacionales.
 * Ejecutar con: node scripts/migrations/ejecutar-crear-usuarios.js
 *
 * La conexion se toma desde .env para evitar credenciales hardcodeadas.
 */

const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

async function ejecutarMigracion() {
  let connection;

  try {
    console.log('Conectando a la base de datos...');

    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT || 3306),
      user: process.env.DB_USERNAME || 'root',
      password: process.env.DB_PASSWORD,
      database: process.env.DB_DATABASE || 'hotel',
      multipleStatements: true,
    });

    console.log('Conexion establecida');

    const sqlPath = path.join(__dirname, 'crear-usuarios-areas.sql');
    const sqlContent = fs.readFileSync(sqlPath, 'utf8');

    console.log('Ejecutando script SQL...');
    await connection.query(sqlContent);
    console.log('Script ejecutado exitosamente');

    const [usuarios] = await connection.query(`
      SELECT id, cedula, nombre, apellido, email, rol, estado
      FROM empleados
      WHERE email IN (
        'lavanderia@gmail.com', 'spa@gmail.com', 'roomservice@gmail.com',
        'minibar@gmail.com', 'transporte@gmail.com', 'tours@gmail.com',
        'eventos@gmail.com', 'mantenimiento@gmail.com'
      )
      ORDER BY rol
    `);

    console.log('Usuarios creados:');
    console.table(
      usuarios.map((u) => ({
        ID: u.id,
        Email: u.email,
        Rol: u.rol,
        Nombre: `${u.nombre} ${u.apellido}`,
        Estado: u.estado,
      })),
    );

    const [resumen] = await connection.query(`
      SELECT rol, COUNT(*) as total
      FROM empleados
      WHERE estado = 'activo'
      GROUP BY rol
      ORDER BY rol
    `);

    console.log('Resumen por rol:');
    console.table(resumen);
    console.log('Migracion completada. La password seed no se imprime por seguridad.');
  } catch (error) {
    console.error('Error durante la migracion:', error.message);

    if (error.code === 'ER_DUP_ENTRY') {
      console.log('Algunos usuarios ya existen en la base de datos.');
      console.log('Revisa los emails duplicados y eliminalos si es necesario.');
    }

    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
      console.log('Conexion cerrada');
    }
  }
}

ejecutarMigracion();
