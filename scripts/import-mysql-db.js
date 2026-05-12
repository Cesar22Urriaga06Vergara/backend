const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

const DEFAULT_SQL_FILE = 'Base de datos Sena.sql';

function getConnectionConfig() {
  const url = process.env.MYSQL_URL || process.env.DATABASE_URL;

  if (url && /^mysql:\/\//i.test(url)) {
    const sslEnabled =
      process.env.MYSQL_SSL === 'true' ||
      url.includes('aivencloud.com') ||
      /[?&]ssl-mode=required/i.test(url);

    try {
      const parsedUrl = new URL(url);
      parsedUrl.searchParams.delete('ssl-mode');
      return {
        uri: parsedUrl.toString(),
        ...(sslEnabled ? { ssl: { rejectUnauthorized: false } } : {}),
      };
    } catch {
      return {
        uri: url.replace(/([?&])ssl-mode=required&?/i, '$1'),
        ...(sslEnabled ? { ssl: { rejectUnauthorized: false } } : {}),
      };
    }
  }

  return {
    host: process.env.MYSQLHOST || process.env.DB_HOST || 'localhost',
    port: Number(process.env.MYSQLPORT || process.env.DB_PORT || 3306),
    user: process.env.MYSQLUSER || process.env.DB_USERNAME || 'root',
    password: process.env.MYSQLPASSWORD || process.env.DB_PASSWORD || '',
    database: process.env.MYSQLDATABASE || process.env.DB_DATABASE || 'hotel',
    ...(process.env.MYSQL_SSL === 'true'
      ? { ssl: { rejectUnauthorized: false } }
      : {}),
  };
}

function prepareDump(sql) {
  const tableNames = Array.from(
    sql.matchAll(/CREATE TABLE IF NOT EXISTS\s+`([^`]+)`/gi),
    (match) => match[1],
  );
  const dropTables = tableNames
    .map((tableName) => `DROP TABLE IF EXISTS \`${tableName}\`;`)
    .join('\n');

  const normalizedSql = sql
    .replace(/^\s*CREATE DATABASE\b[^;]*;\s*$/gim, '')
    .replace(/^\s*USE\s+`?[^`;]+`?\s*;\s*$/gim, '')
    .replace(/^\s*DELIMITER\s+\S+\s*$/gim, '')
    .replace(/\bDEFAULT\s+curdate\(\)/gim, 'DEFAULT (curdate())')
    .replace(
      /(`[^`]+`\s+(?:longtext|text|json)\b[^,\n]*?)\s+DEFAULT\s+'(?:\[\]|\{\})'([^,\n]*)/gim,
      '$1$2',
    );

  return [
    'SET FOREIGN_KEY_CHECKS=0;',
    dropTables,
    normalizedSql,
    'SET FOREIGN_KEY_CHECKS=1;',
  ]
    .filter(Boolean)
    .join('\n');
}

async function main() {
  const sqlFile = process.argv[2] || DEFAULT_SQL_FILE;
  const sqlPath = path.resolve(__dirname, sqlFile);

  if (!fs.existsSync(sqlPath)) {
    throw new Error(`No se encontro el archivo SQL: ${sqlPath}`);
  }

  const rawSql = fs.readFileSync(sqlPath, 'utf8');
  const sql = prepareDump(rawSql);
  const config = getConnectionConfig();

  const connection = await mysql.createConnection({
    ...config,
    multipleStatements: true,
  });

  try {
    await connection.query(sql);
    console.log(`Base de datos importada desde ${sqlFile}`);
  } finally {
    await connection.end();
  }
}

main().catch((error) => {
  console.error('No se pudo importar la base de datos.');
  console.error(error);
  process.exitCode = 1;
});
