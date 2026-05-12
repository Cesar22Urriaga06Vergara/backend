# ADUS Hospitality OS - Backend

API REST del sistema de gestion hotelera ADUS. Expone autenticacion, usuarios,
hoteles, reservas, check-in/check-out, folios, pagos, caja, facturacion,
servicios, reportes y administracion de plataforma.

## Stack

- Node.js 18 o superior
- NestJS 11
- TypeScript
- TypeORM
- MySQL
- Passport, JWT y Google OAuth
- Swagger/OpenAPI
- Jest

## Arquitectura

La aplicacion esta organizada por modulos NestJS dentro de `src/`.

```text
src/
  app.module.ts
  main.ts
  auth/
  amenidad/
  caja/
  categoria-servicios/
  cliente/
  cloudinary/
  common/
  empleado/
  factura/
  folio/
  habitacion/
  hotel/
  huespedes/
  impuesto/
  incidencia/
  medio-pago/
  pago/
  reserva/
  servicio/
  superadmin/
  tax-rates/
  tipo-habitacion/
test/
scripts/
```

`main.ts` inicializa CORS, validacion global, Swagger opcional y el puerto HTTP.
`app.module.ts` centraliza configuracion, TypeORM y registro de modulos.

## Instalacion

```bash
npm install
cp .env.example .env
```

Edita `.env` con credenciales locales reales. No subas `.env` a Git.

## Variables De Entorno

```env
PORT=3001
NODE_ENV=development
ENABLE_SWAGGER=true

DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=tu_password_aqui
DB_DATABASE=hotel
TYPEORM_SYNCHRONIZE=false
TYPEORM_LOGGING=false

JWT_SECRET=cambia_esto_por_un_secreto_largo_y_unico
JWT_EXPIRATION=1h

CLOUDINARY_CLOUD_NAME=tu_cloud_name
CLOUDINARY_API_KEY=tu_api_key
CLOUDINARY_API_SECRET=tu_api_secret
CLOUDINARY_FOLDER_NAME=imghotel

CORS_ORIGINS=http://localhost:3000,http://127.0.0.1:3000

GOOGLE_CLIENT_ID=tu_google_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=tu_google_client_secret
GOOGLE_CALLBACK_URL=http://localhost:3001/auth/google/callback
```

## Scripts

```bash
npm run start        # Ejecuta Nest en modo normal
npm run start:dev    # Desarrollo con watch
npm run start:debug  # Debug con watch
npm run build        # Compila a dist/
npm run start:prod   # Ejecuta dist/main
npm run test         # Tests unitarios
npm run test:watch   # Tests en watch
npm run test:cov     # Cobertura
npm run test:e2e     # Tests e2e
npm run lint         # ESLint con fix
npm run format       # Prettier
```

## Ejecucion Local

1. Inicia MySQL y crea/configura la base definida en `DB_DATABASE`.
2. Configura `.env`.
3. Ejecuta:

```bash
npm run start:dev
```

La API queda disponible en:

```text
http://localhost:3001
```

Si `ENABLE_SWAGGER=true`, la documentacion queda en:

```text
http://localhost:3001/api/docs
```

## Produccion

```bash
npm run build
npm run start:prod
```

Para produccion:

- Usa `NODE_ENV=production`.
- Usa un `JWT_SECRET` largo, unico y privado.
- Manten `TYPEORM_SYNCHRONIZE=false`.
- Define `CORS_ORIGINS` con dominios permitidos reales.
- Configura secretos desde el proveedor de despliegue, no desde archivos versionados.
- Desactiva Swagger si no debe exponerse publicamente.

## Seguridad

- `.env`, logs, builds, caches, certificados y llaves privadas estan ignorados por Git.
- `.env.example` debe contener solo placeholders.
- No guardes tokens, API keys, passwords reales ni certificados dentro del repositorio.
- Los scripts de seed/migracion deben ejecutarse solo con variables de entorno controladas.
- Rota cualquier credencial demo antes de usar entornos compartidos o productivos.

## Troubleshooting

- `EADDRINUSE: 3001`: ya hay otro backend escuchando. Deten el proceso o cambia `PORT`.
- Error de conexion MySQL: revisa `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD` y `DB_DATABASE`.
- CORS en frontend: agrega el origen exacto a `CORS_ORIGINS`.
- Swagger no aparece: confirma `ENABLE_SWAGGER=true`.

## Convenciones

- Mantener la logica de negocio dentro de servicios NestJS.
- Mantener DTOs y validaciones por modulo.
- No subir archivos generados (`dist`, `coverage`, logs).
- Documentar nuevas variables en `.env.example`.
- Ejecutar build y tests antes de integrar cambios.

## Licencia

Proyecto privado sin licencia publica declarada.
