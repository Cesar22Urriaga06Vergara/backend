export const Rol = {
  SUPERADMIN: 'superadmin',
  ADMIN: 'admin',
  RECEPCIONISTA: 'recepcionista',
  CAFETERIA: 'cafeteria',
  LAVANDERIA: 'lavanderia',
  SPA: 'spa',
  ROOM_SERVICE: 'room_service',
  MINIBAR: 'minibar',
  TRANSPORTE: 'transporte',
  TOURS: 'tours',
  EVENTOS: 'eventos',
  MANTENIMIENTO: 'mantenimiento',
  CLIENTE: 'cliente',
} as const;

export type TipoRol = typeof Rol[keyof typeof Rol];

export const RolGrupos = {
  EMPLEADOS_AREA: ['cafeteria', 'lavanderia', 'spa', 'room_service', 'minibar', 'transporte', 'tours', 'eventos', 'mantenimiento'],
  RECEPCION: ['recepcionista', 'admin', 'superadmin'],
  GESTION: ['admin', 'superadmin'],
  TODOS_EMPLEADOS: [
    'superadmin',
    'admin',
    'recepcionista',
    'cafeteria',
    'lavanderia',
    'spa',
    'room_service',
    'minibar',
    'transporte',
    'tours',
    'eventos',
    'mantenimiento',
  ],
} as const;
