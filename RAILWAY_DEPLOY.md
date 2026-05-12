# Despliegue En Railway

Este proyecto esta preparado para desplegarse como tres servicios en Railway:

- `backend`: NestJS, root directory `/backend`
- `frontend`: Nuxt, root directory `/frontend`
- `mysql`: base de datos MySQL creada desde `+ New > Database > MySQL`

## Variables Y GitHub

No subas archivos `.env` reales a GitHub. Esos archivos contienen secretos como
`JWT_SECRET`, passwords de base de datos y credenciales de Cloudinary/Google.

Lo correcto es subir solamente `.env.example`, que ya existe para backend y
frontend. Railway puede leer esos ejemplos para sugerir variables, pero los
valores reales deben configurarse en la pestaña `Variables` de cada servicio.

## Backend

Variables recomendadas:

```env
NODE_ENV=production
ENABLE_SWAGGER=false
FRONTEND_URL=https://tu-frontend.up.railway.app
CORS_ORIGINS=https://tu-frontend.up.railway.app
JWT_SECRET=cambia_esto_por_un_secreto_largo_y_privado
JWT_EXPIRATION=1h
TYPEORM_SYNCHRONIZE=false
TYPEORM_LOGGING=false
MYSQL_URL=${{MySQL.MYSQL_URL}}
MYSQL_SSL=false
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
CLOUDINARY_FOLDER_NAME=imghotel
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_CALLBACK_URL=https://tu-backend.up.railway.app/auth/google/callback
```

Railway define `PORT` automaticamente. No lo configures manualmente salvo que
sepas que lo necesitas.

## Frontend

Variables recomendadas:

```env
NUXT_PUBLIC_API_BASE=https://tu-backend.up.railway.app
NUXT_PUBLIC_DEBUG=false
```

## Importar La Base De Datos

Despues de crear el servicio MySQL y desplegar el backend, ejecuta una sola vez
en el servicio `backend`:

```bash
npm run db:import:railway
```

El script carga `scripts/Base de datos Sena.sql` en la base configurada por
`MYSQL_URL`. No hace falta crear la base a mano: Railway crea el servicio MySQL
y el script importa tablas y datos en la base asignada.

## Orden Sugerido

1. Crea el proyecto en Railway.
2. Agrega una base `MySQL`.
3. Agrega el servicio `backend` con root directory `/backend`.
4. Agrega el servicio `frontend` con root directory `/frontend`.
5. Configura las variables de ambos servicios.
6. Genera dominios publicos para backend y frontend.
7. Actualiza `FRONTEND_URL`, `CORS_ORIGINS`, `GOOGLE_CALLBACK_URL` y
   `NUXT_PUBLIC_API_BASE` con esos dominios.
8. Ejecuta `npm run db:import:railway` una sola vez.
