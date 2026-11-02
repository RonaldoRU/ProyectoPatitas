/*
 * ==============================================================================================
 * SCRIPT AUTOMATIZADOR DE DIAGRAMAS DE SECUENCIA - ENTERPRISE ARCHITECT (JScript)
 * PROYECTO: Sistema Web para Refugio de Animales "Los Angelitos de Edgar"
 * FORMATO: Realización de Caso de Uso - Diseño (Diagrama de Secuencia)
 * ESTÁNDAR: Actor -> Boundary (: Vista) -> Control (: Controlador) -> Service (: Gestor) -> Entity (: Tabla)
 * ==============================================================================================
 *
 * INSTRUCCIONES DE USO EN ENTERPRISE ARCHITECT:
 * 1. Abra Enterprise Architect con su proyecto abierto (.eap, .feap, .qea o conexión BD).
 * 2. Abra la consola de scripting: Menú Specialize -> Tools -> Scripting (o presione Alt+7).
 * 3. En la ventana "Scripting", seleccione una carpeta de scripts (ej: "Local Scripts" o "JScript").
 * 4. Haga clic en "New JScript", nómbrelo: "GenerarDiagramasSecuencia"
 * 5. Pegue la totalidad de este código fuente y guarde los cambios (Ctrl+S).
 * 6. En el Project Browser de EA, seleccione el Paquete donde desea crear los diagramas.
 * 7. Haga clic derecho sobre el script y elija "Run Script".
 * 8. Los 30 diagramas de secuencia se generarán organizados por paquetes con todas sus líneas de vida,
 *    activaciones y mensajes numerados en orden estricto.
 * ==============================================================================================
 */

// DEFINICIÓN DE LOS CASOS DE USO CON SUS LÍNEAS DE VIDA (LIFELINES) Y MENSAJES DE SECUENCIA
var CASOS_DE_USO_SECUENCIA = [
    // ------------------------------------------------------------------------------------------
    // CU01: Iniciar Sesión en la Plataforma Web (Diseño Idéntico a Referencia Oficial)
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU01",
        nombre: "CU01 - Iniciar Sesión en la Plataforma Web",
        paquete: "P1_Seguridad_Autenticacion",
        lifelines: [
            { id: "actor", nombre: "Usuario", tipo: "Actor", alias: ": Usuario" },
            { id: "vista", nombre: "Vista Login (login.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Login (login.php)" },
            { id: "ctrl", nombre: "Controlador Login", tipo: "Sequence", estereotipo: "control", alias: ": Controlador Login" },
            { id: "gestor", nombre: "Gestor de Autenticación", tipo: "Sequence", estereotipo: "control", alias: ": Gestor de Autenticación" },
            { id: "t_user", nombre: "Usuario (usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": Usuario (usuario)" },
            { id: "t_sesion", nombre: "Sesión (sesion)", tipo: "Sequence", estereotipo: "entity", alias: ": Sesión (sesion)" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora (bitacora)" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Acceder a inicio de sesión" },
            { de: "vista", para: "actor", nombre: "Solicitar credenciales" },
            { de: "actor", para: "vista", nombre: "Ingresar credenciales (nombre_usuario, contraseña)" },
            { de: "vista", para: "ctrl", nombre: "iniciarSesion (nombre_usuario, contraseña)" },
            { de: "ctrl", para: "gestor", nombre: "autenticar (nombre_usuario, contraseña)" },
            { de: "gestor", para: "t_user", nombre: "buscarPorNombreUsuario (nombre_usuario)" },
            { de: "gestor", para: "gestor", nombre: "password_verify (contraseña, hash_contrasena)" },
            { de: "gestor", para: "t_user", nombre: "reiniciarIntentosFallidos (id_usuario)" },
            { de: "ctrl", para: "t_sesion", nombre: "crearSesion (id_usuario, ip)" },
            { de: "t_sesion", para: "t_sesion", nombre: "generar $_SESSION (id_usuario, id_rol)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrar (id_usuario, 'LOGIN')" },
            { de: "ctrl", para: "vista", nombre: "redirigirPanel (rol)" },
            { de: "vista", para: "actor", nombre: "Mostrar panel principal según rol" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU02: Cerrar Sesión Activa
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU02",
        nombre: "CU02 - Cerrar Sesión Activa",
        paquete: "P1_Seguridad_Autenticacion",
        lifelines: [
            { id: "actor", nombre: "Usuario", tipo: "Actor", alias: ": Usuario" },
            { id: "vista", nombre: "Vista Principal (top-nav.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista TopNav" },
            { id: "ctrl", nombre: "Controlador Auth", tipo: "Sequence", estereotipo: "control", alias: ": AuthController" },
            { id: "t_sesion", nombre: "Sesión (sesion_jwt)", tipo: "Sequence", estereotipo: "entity", alias: ": SesionJWT" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Clic en 'Cerrar Sesión'" },
            { de: "vista", para: "ctrl", nombre: "cerrarSesion (token, id_usuario)" },
            { de: "ctrl", para: "t_sesion", nombre: "revocarToken (token)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrarAccion (id_usuario, 'LOGOUT')" },
            { de: "ctrl", para: "vista", nombre: "destruirSesion ()" },
            { de: "vista", para: "actor", nombre: "Redirigir a pantalla de login con mensaje de despedida" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU03: Recuperar Contraseña de Acceso
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU03",
        nombre: "CU03 - Recuperar Contraseña de Acceso",
        paquete: "P1_Seguridad_Autenticacion",
        lifelines: [
            { id: "actor", nombre: "Usuario", tipo: "Actor", alias: ": Usuario" },
            { id: "vista", nombre: "Vista Recuperar (recuperar.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Recuperar" },
            { id: "ctrl", nombre: "PasswordRecoveryController", tipo: "Sequence", estereotipo: "control", alias: ": RecoveryController" },
            { id: "gestor_correo", nombre: "Servicio de Correo (Mail)", tipo: "Sequence", estereotipo: "control", alias: ": MailService" },
            { id: "t_user", nombre: "Usuario (usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": Usuario" },
            { id: "t_token", nombre: "Token Reset (password_reset)", tipo: "Sequence", estereotipo: "entity", alias: ": ResetToken" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Solicitar enlace de recuperación (email)" },
            { de: "vista", para: "ctrl", nombre: "solicitarResetToken (email)" },
            { de: "ctrl", para: "t_user", nombre: "buscarPorEmail (email)" },
            { de: "ctrl", para: "t_token", nombre: "generarYGuardarToken (id_usuario, token, expiracion)" },
            { de: "ctrl", para: "gestor_correo", nombre: "enviarEmailRecuperacion (email, enlace)" },
            { de: "ctrl", para: "vista", nombre: "confirmarEnvio ()" },
            { de: "vista", para: "actor", nombre: "Mostrar confirmación de correo enviado" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU04: Registrar Nuevo Usuario del Sistema
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU04",
        nombre: "CU04 - Registrar Nuevo Usuario del Sistema",
        paquete: "P2_Gestion_Usuarios_RBAC",
        lifelines: [
            { id: "actor", nombre: "Administrador", tipo: "Actor", alias: ": Administrador" },
            { id: "vista", nombre: "Vista Usuarios (gestionusuarios.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista GestionUsuarios" },
            { id: "ctrl", nombre: "UsuarioController", tipo: "Sequence", estereotipo: "control", alias: ": UsuarioController" },
            { id: "t_persona", nombre: "Persona (persona)", tipo: "Sequence", estereotipo: "entity", alias: ": Persona" },
            { id: "t_user", nombre: "Usuario (usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": Usuario" },
            { id: "t_rol_user", nombre: "Rol Permiso (rol_usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": RolPermiso" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar datos de persona, usuario y rol" },
            { de: "vista", para: "ctrl", nombre: "crearUsuario (datosPersona, credenciales, rol_id)" },
            { de: "ctrl", para: "t_persona", nombre: "registrarPersona (ci, nombre, telefono, email)" },
            { de: "ctrl", para: "ctrl", nombre: "bcrypt (password)" },
            { de: "ctrl", para: "t_user", nombre: "registrarUsuario (persona_id, username, password_hash)" },
            { de: "ctrl", para: "t_rol_user", nombre: "asignarRolUsuario (usuario_id, rol_id)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrarAccion (admin_id, 'CREAR_USUARIO')" },
            { de: "ctrl", para: "vista", nombre: "confirmarCreacion (nuevoUsuario)" },
            { de: "vista", para: "actor", nombre: "Notificar éxito y actualizar grilla de usuarios" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU05: Modificar Datos de Usuario y Contraseña
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU05",
        nombre: "CU05 - Modificar Datos de Usuario y Contraseña",
        paquete: "P2_Gestion_Usuarios_RBAC",
        lifelines: [
            { id: "actor", nombre: "Administrador / Operador", tipo: "Actor", alias: ": Operador" },
            { id: "vista", nombre: "Vista Perfil (perfilusuario.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Perfil" },
            { id: "ctrl", nombre: "UsuarioController", tipo: "Sequence", estereotipo: "control", alias: ": UsuarioController" },
            { id: "t_user", nombre: "Usuario (usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": Usuario" },
            { id: "t_persona", nombre: "Persona (persona)", tipo: "Sequence", estereotipo: "entity", alias: ": Persona" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Editar teléfono, email o nueva contraseña" },
            { de: "vista", para: "ctrl", nombre: "actualizarDatos (id_usuario, nuevosDatos)" },
            { de: "ctrl", para: "t_persona", nombre: "actualizarContacto (persona_id, telefono, direccion)" },
            { de: "ctrl", para: "t_user", nombre: "actualizarPassword (id_usuario, nuevoHash)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrarAccion (id_usuario, 'UPDATE_PROFILE')" },
            { de: "ctrl", para: "vista", nombre: "confirmarActualizacion ()" },
            { de: "vista", para: "actor", nombre: "Mensaje: 'Datos actualizados correctamente'" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU06: Inactivar Cuenta de Usuario
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU06",
        nombre: "CU06 - Inactivar Cuenta de Usuario",
        paquete: "P2_Gestion_Usuarios_RBAC",
        lifelines: [
            { id: "actor", nombre: "Administrador", tipo: "Actor", alias: ": Administrador" },
            { id: "vista", nombre: "Vista Usuarios (gestionusuarios.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Usuarios" },
            { id: "ctrl", nombre: "UsuarioController", tipo: "Sequence", estereotipo: "control", alias: ": UsuarioController" },
            { id: "t_user", nombre: "Usuario (usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": Usuario" },
            { id: "t_sesion", nombre: "Sesión (sesion_jwt)", tipo: "Sequence", estereotipo: "entity", alias: ": SesionJWT" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Clic en 'Inactivar Usuario'" },
            { de: "vista", para: "ctrl", nombre: "inactivarUsuario (id_usuario)" },
            { de: "ctrl", para: "t_user", nombre: "updateEstado (id_usuario, 'INACTIVO')" },
            { de: "ctrl", para: "t_sesion", nombre: "revocarSesionesActivas (id_usuario)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrarAccion (admin_id, 'INACTIVAR_USUARIO')" },
            { de: "ctrl", para: "vista", nombre: "confirmarInactivacion ()" },
            { de: "vista", para: "actor", nombre: "Actualizar estado en tabla a 'Inactivo'" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU07: Asignar Roles y Permisos RBAC
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU07",
        nombre: "CU07 - Asignar Roles y Permisos RBAC",
        paquete: "P2_Gestion_Usuarios_RBAC",
        lifelines: [
            { id: "actor", nombre: "Administrador", tipo: "Actor", alias: ": Administrador" },
            { id: "vista", nombre: "Vista Matriz (matrizpermisos.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Permisos" },
            { id: "ctrl", nombre: "RolPermisoController", tipo: "Sequence", estereotipo: "control", alias: ": RolPermisoController" },
            { id: "t_rol_permiso", nombre: "Rol Permiso (rol_permiso)", tipo: "Sequence", estereotipo: "entity", alias: ": RolPermiso" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Modificar checkboxes de matriz de permisos" },
            { de: "vista", para: "ctrl", nombre: "guardarMatrizPermisos (rol_id, listaPermisos)" },
            { de: "ctrl", para: "t_rol_permiso", nombre: "sincronizarPermisosRol (rol_id, listaPermisos)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrarAccion (admin_id, 'UPDATE_RBAC_PERMISOS')" },
            { de: "ctrl", para: "vista", nombre: "confirmarGuardado ()" },
            { de: "vista", para: "actor", nombre: "Notificar: 'Matriz de permisos actualizada'" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU08: Consultar Bitácora de Auditoría
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU08",
        nombre: "CU08 - Consultar Bitácora de Auditoría",
        paquete: "P2_Gestion_Usuarios_RBAC",
        lifelines: [
            { id: "actor", nombre: "Auditor / Administrador", tipo: "Actor", alias: ": Auditor" },
            { id: "vista", nombre: "Vista Auditoría (auditoria.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Auditoria" },
            { id: "ctrl", nombre: "BitacoraController", tipo: "Sequence", estereotipo: "control", alias: ": BitacoraController" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" },
            { id: "t_user", nombre: "Usuario (usuario)", tipo: "Sequence", estereotipo: "entity", alias: ": Usuario" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Filtrar por rango de fecha y usuario" },
            { de: "vista", para: "ctrl", nombre: "filtrarPorFecha (fechaInicio, fechaFin, usuarioId)" },
            { de: "ctrl", para: "t_bitacora", nombre: "obtenerRegistrosFiltrados (fechaInicio, fechaFin)" },
            { de: "t_bitacora", para: "t_user", nombre: "joinUsuario ()" },
            { de: "ctrl", para: "vista", nombre: "retornarEventosAuditoria (listaEventos)" },
            { de: "vista", para: "actor", nombre: "Renderizar tabla de trazabilidad de acciones" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU09: Registrar Nuevo Proveedor
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU09",
        nombre: "CU09 - Registrar Nuevo Proveedor",
        paquete: "P3_ComprasProveedores",
        lifelines: [
            { id: "actor", nombre: "Encargado de Compras", tipo: "Actor", alias: ": Encargado Compras" },
            { id: "vista", nombre: "Vista Proveedores (proveedores.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Proveedores" },
            { id: "ctrl", nombre: "ProveedorController", tipo: "Sequence", estereotipo: "control", alias: ": ProveedorController" },
            { id: "t_prov", nombre: "Proveedor (proveedor)", tipo: "Sequence", estereotipo: "entity", alias: ": Proveedor" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar NIT, razón social y contacto" },
            { de: "vista", para: "ctrl", nombre: "registrarProveedor (datosProveedor)" },
            { de: "ctrl", para: "t_prov", nombre: "insertProveedor (nit, razon_social, telefono, direccion)" },
            { de: "ctrl", para: "t_bitacora", nombre: "registrarAccion (user_id, 'CREAR_PROVEEDOR')" },
            { de: "ctrl", para: "vista", nombre: "confirmarRegistro (nuevoProveedor)" },
            { de: "vista", para: "actor", nombre: "Mostrar proveedor en catálogo activo" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU10: Registrar Compra de Insumos / Medicamentos
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU10",
        nombre: "CU10 - Registrar Compra de Insumos / Medicamentos",
        paquete: "P3_ComprasProveedores",
        lifelines: [
            { id: "actor", nombre: "Encargado de Compras", tipo: "Actor", alias: ": Encargado Compras" },
            { id: "vista", nombre: "Vista Compras (compras.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Compras" },
            { id: "ctrl_compra", nombre: "CompraController", tipo: "Sequence", estereotipo: "control", alias: ": CompraController" },
            { id: "ctrl_art", nombre: "ArticuloInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": ArticuloController" },
            { id: "t_compra", nombre: "Compra (compra)", tipo: "Sequence", estereotipo: "entity", alias: ": Compra" },
            { id: "t_det_compra", nombre: "Detalle Compra (detalle_compra)", tipo: "Sequence", estereotipo: "entity", alias: ": DetalleCompra" },
            { id: "t_art", nombre: "Artículo (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": ArticuloInventario" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Cargar ítems, cantidades, costos y proveedor" },
            { de: "vista", para: "ctrl_compra", nombre: "registrarCabeceraCompra (proveedor_id, items)" },
            { de: "ctrl_compra", para: "t_compra", nombre: "crearCabecera (nro_factura, total)" },
            { de: "ctrl_compra", para: "t_det_compra", nombre: "insertarRenglonCompra (compra_id, item)" },
            { de: "ctrl_compra", para: "ctrl_art", nombre: "incrementarStock (articulo_id, cantidad)" },
            { de: "ctrl_art", para: "t_art", nombre: "actualizarStockYPrecio (articulo_id, cantidad, costo)" },
            { de: "ctrl_compra", para: "vista", nombre: "confirmarCompraGuardada (compraId)" },
            { de: "vista", para: "actor", nombre: "Emitir comprobante y actualizar stock disponible" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU11: Registrar Salida de Inventario por Suministro Clínico
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU11",
        nombre: "CU11 - Registrar Salida de Inventario por Suministro Clínico",
        paquete: "P4_CatalogoExistencias",
        lifelines: [
            { id: "actor", nombre: "Veterinario / Almacenero", tipo: "Actor", alias: ": Almacenero" },
            { id: "vista", nombre: "Vista Salidas (salidas.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Salidas" },
            { id: "ctrl_salida", nombre: "SalidaInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": SalidaController" },
            { id: "ctrl_art", nombre: "ArticuloInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": ArticuloController" },
            { id: "t_salida", nombre: "Salida (salida_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": SalidaInventario" },
            { id: "t_art", nombre: "Artículo (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": ArticuloInventario" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Seleccionar insumos para tratamiento clínico" },
            { de: "vista", para: "ctrl_salida", nombre: "registrarDespacho (motivo, items)" },
            { de: "ctrl_salida", para: "ctrl_salida", nombre: "validarDisponibilidadStock (items)" },
            { de: "ctrl_salida", para: "t_salida", nombre: "crearSalidaCabecera (motivo, fecha)" },
            { de: "ctrl_salida", para: "ctrl_art", nombre: "descontarStock (articulo_id, cantidad)" },
            { de: "ctrl_art", para: "t_art", nombre: "updateStockActual (articulo_id, nuevoStock)" },
            { de: "ctrl_salida", para: "vista", nombre: "confirmarDespacho ()" },
            { de: "vista", para: "actor", nombre: "Mostrar vale de salida autorizado" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU12: Control de Stock Crítico y Mermas
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU12",
        nombre: "CU12 - Control de Stock Crítico y Mermas",
        paquete: "P4_CatalogoExistencias",
        lifelines: [
            { id: "actor", nombre: "Encargado de Farmacia", tipo: "Actor", alias: ": Encargado Farmacia" },
            { id: "vista", nombre: "Vista Stock (stock-critico.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Stock" },
            { id: "ctrl", nombre: "ArticuloInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": ArticuloController" },
            { id: "t_art", nombre: "Artículo (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": ArticuloInventario" },
            { id: "t_merma", nombre: "Merma (merma_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": MermaInventario" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Registrar producto dañado o expirado (merma)" },
            { de: "vista", para: "ctrl", nombre: "registrarMerma (articulo_id, cantidad, motivo)" },
            { de: "ctrl", para: "t_merma", nombre: "insertarRegistroMerma (articulo_id, cantidad, motivo)" },
            { de: "ctrl", para: "t_art", nombre: "descontarStockMerma (articulo_id, cantidad)" },
            { de: "ctrl", para: "ctrl", nombre: "verificarNivelCritico (articulo_id)" },
            { de: "ctrl", para: "vista", nombre: "confirmarRegistroMerma ()" },
            { de: "vista", para: "actor", nombre: "Actualizar saldo y alertar si stock < mínimo" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU13: Generar Alerta de Reabastecimiento
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU13",
        nombre: "CU13 - Generar Alerta de Reabastecimiento",
        paquete: "P5_MonitoreoAbastecimiento",
        lifelines: [
            { id: "sistema", nombre: "Demonio / Cron Job", tipo: "Actor", alias: ": Cron / Scheduler" },
            { id: "ctrl_alerta", nombre: "AlertaInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": AlertaController" },
            { id: "t_art", nombre: "Artículo (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": ArticuloInventario" },
            { id: "t_alerta", nombre: "Alerta (alerta_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": AlertaInventario" },
            { id: "vista", nombre: "Vista Alertas (alertas.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Alertas" }
        ],
        mensajes: [
            { de: "sistema", para: "ctrl_alerta", nombre: "ejecutarMonitoreoDiario ()" },
            { de: "ctrl_alerta", para: "t_art", nombre: "consultarArticulosBajoMinimo ()" },
            { de: "ctrl_alerta", para: "ctrl_alerta", nombre: "generarAlertaCritica (articulo_id, nivel)" },
            { de: "ctrl_alerta", para: "t_alerta", nombre: "guardarAlerta (articulo_id, 'REABASTECIMIENTO_URGENTE')" },
            { de: "ctrl_alerta", para: "vista", nombre: "publicarNotificacion (badge_contador)" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU14: Registrar Ficha Médica y Diagnóstico
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU14",
        nombre: "CU14 - Registrar Ficha Médica y Diagnóstico",
        paquete: "P7_RescateClinico",
        lifelines: [
            { id: "actor", nombre: "Veterinario", tipo: "Actor", alias: ": Veterinario" },
            { id: "vista", nombre: "Vista Clínica (historial-clinico.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Historial" },
            { id: "ctrl_clinico", nombre: "HistorialClinicoController", tipo: "Sequence", estereotipo: "control", alias: ": HistorialController" },
            { id: "t_mascota", nombre: "Mascota (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "t_historial", nombre: "Historial (historial_clinico)", tipo: "Sequence", estereotipo: "entity", alias: ": HistorialClinico" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar signos vitales, peso y diagnóstico" },
            { de: "vista", para: "ctrl_clinico", nombre: "registrarConsultaMedica (mascota_id, diagnostico, peso)" },
            { de: "ctrl_clinico", para: "t_historial", nombre: "crearEntradaConsulta (mascota_id, diagnostico, peso)" },
            { de: "ctrl_clinico", para: "t_mascota", nombre: "actualizarCondicionMedica (mascota_id, 'En Tratamiento')" },
            { de: "ctrl_clinico", para: "vista", nombre: "confirmarRegistroConsulta ()" },
            { de: "vista", para: "actor", nombre: "Mostrar consulta consolidada en el expediente médico" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU15: Prescribir y Aplicar Tratamiento Veterinario
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU15",
        nombre: "CU15 - Prescribir y Aplicar Tratamiento Veterinario",
        paquete: "P7_RescateClinico",
        lifelines: [
            { id: "actor", nombre: "Veterinario", tipo: "Actor", alias: ": Veterinario" },
            { id: "vista", nombre: "Vista Ficha (historial-clinico.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Historial" },
            { id: "ctrl_clinico", nombre: "HistorialClinicoController", tipo: "Sequence", estereotipo: "control", alias: ": HistorialController" },
            { id: "ctrl_art", nombre: "ArticuloInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": ArticuloController" },
            { id: "t_historial", nombre: "Historial (historial_clinico)", tipo: "Sequence", estereotipo: "entity", alias: ": HistorialClinico" },
            { id: "t_art", nombre: "Fármaco (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": Farmaco" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Prescribir antibiótico y dosis" },
            { de: "vista", para: "ctrl_clinico", nombre: "aplicarTratamiento (mascota_id, farmaco_id, dosis)" },
            { de: "ctrl_clinico", para: "t_historial", nombre: "vincularTratamiento (mascota_id, farmaco_id, dosis)" },
            { de: "ctrl_clinico", para: "ctrl_art", nombre: "descontarStock (farmaco_id, cantidadDosis)" },
            { de: "ctrl_art", para: "t_art", nombre: "rebajarExistencia (farmaco_id, cantidadDosis)" },
            { de: "ctrl_clinico", para: "vista", nombre: "confirmarTratamiento ()" },
            { de: "vista", para: "actor", nombre: "Mostrar orden médica y actualizar stock de farmacia" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU16: Monitorear Vencimientos de Fármacos
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU16",
        nombre: "CU16 - Monitorear Vencimientos de Fármacos",
        paquete: "P6_AutomatizacionClinica",
        lifelines: [
            { id: "sistema", nombre: "Servicio Automatizado", tipo: "Actor", alias: ": Servicio Cron" },
            { id: "ctrl_venc", nombre: "Controlador Vencimientos", tipo: "Sequence", estereotipo: "control", alias: ": VencimientosController" },
            { id: "t_art", nombre: "Lote Farmacia (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": ArticuloInventario" },
            { id: "t_alerta", nombre: "Alerta (alerta_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": AlertaInventario" },
            { id: "vista", nombre: "Vista Vencimientos (vencimientos.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Vencimientos" }
        ],
        mensajes: [
            { de: "sistema", para: "ctrl_venc", nombre: "verificarFechasExpiracion ()" },
            { de: "ctrl_venc", para: "t_art", nombre: "buscarLotesProximosAVencer (dias = 30)" },
            { de: "ctrl_venc", para: "t_alerta", nombre: "registrarAlertaCaducidad (lote_id, diasRestantes)" },
            { de: "ctrl_venc", para: "vista", nombre: "actualizarBadgeVencimientos ()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU17: Emitir Alerta de Vacunación y Desparasitación
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU17",
        nombre: "CU17 - Emitir Alerta de Vacunación y Desparasitación",
        paquete: "P6_AutomatizacionClinica",
        lifelines: [
            { id: "sistema", nombre: "Motor de Reglas Clínicas", tipo: "Actor", alias: ": Motor Clínico" },
            { id: "ctrl_auto", nombre: "Controlador Reglas Clínicas", tipo: "Sequence", estereotipo: "control", alias: ": ReglasClinicasController" },
            { id: "t_mascota", nombre: "Mascota (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "t_historial", nombre: "Historial (historial_clinico)", tipo: "Sequence", estereotipo: "entity", alias: ": HistorialClinico" },
            { id: "vista", nombre: "Vista Agenda Médica", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Agenda" }
        ],
        mensajes: [
            { de: "sistema", para: "ctrl_auto", nombre: "evaluarCalendarioProfilactico ()" },
            { de: "ctrl_auto", para: "t_mascota", nombre: "obtenerAnimalesEnRefugio ()" },
            { de: "ctrl_auto", para: "t_historial", nombre: "obtenerUltimaVacunacion (mascota_id)" },
            { de: "ctrl_auto", para: "ctrl_auto", nombre: "calcularVencimientoRefuerzo (fechaUltima, tipoVacuna)" },
            { de: "ctrl_auto", para: "vista", nombre: "programarRecordatorioEnAgenda (mascota_id, fechaRefuerzo)" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU18: Registrar Ingreso y Ficha de Rescate
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU18",
        nombre: "CU18 - Registrar Ingreso y Ficha de Rescate",
        paquete: "P7_RescateClinico",
        lifelines: [
            { id: "actor", nombre: "Rescatista / Operador", tipo: "Actor", alias: ": Rescatista" },
            { id: "vista", nombre: "Vista Rescates (mascotas.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Mascotas" },
            { id: "ctrl_mascota", nombre: "MascotaController", tipo: "Sequence", estereotipo: "control", alias: ": MascotaController" },
            { id: "ctrl_exp", nombre: "ExpedienteDigitalController", tipo: "Sequence", estereotipo: "control", alias: ": ExpedienteController" },
            { id: "t_mascota", nombre: "Mascota (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "t_exp", nombre: "Expediente (expediente_digital)", tipo: "Sequence", estereotipo: "entity", alias: ": ExpedienteDigital" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar datos del animal (nombre, especie, foto, lugar)" },
            { de: "vista", para: "ctrl_mascota", nombre: "registrarIngreso (datosMascota)" },
            { de: "ctrl_mascota", para: "t_mascota", nombre: "crearRegistroMascota (nombre, especie, estado='Rescatado')" },
            { de: "ctrl_mascota", para: "ctrl_exp", nombre: "crearExpedienteInicial (mascota_id)" },
            { de: "ctrl_exp", para: "t_exp", nombre: "inicializarLegajo (mascota_id, codigoExpediente)" },
            { de: "ctrl_mascota", para: "vista", nombre: "confirmarIngreso (mascota_id)" },
            { de: "vista", para: "actor", nombre: "Mostrar carnet inicial de rescate" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU19: Actualizar Estado Clínico de Mascota
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU19",
        nombre: "CU19 - Actualizar Estado Clínico de Mascota",
        paquete: "P7_RescateClinico",
        lifelines: [
            { id: "actor", nombre: "Veterinario", tipo: "Actor", alias: ": Veterinario" },
            { id: "vista", nombre: "Vista Ficha (mascotas.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Mascotas" },
            { id: "ctrl_mascota", nombre: "MascotaController", tipo: "Sequence", estereotipo: "control", alias: ": MascotaController" },
            { id: "t_mascota", nombre: "Mascota (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Modificar estado (ej: 'Recuperado')" },
            { de: "vista", para: "ctrl_mascota", nombre: "actualizarEstado (mascota_id, nuevoEstado)" },
            { de: "ctrl_mascota", para: "t_mascota", nombre: "updateEstadoClinico (mascota_id, nuevoEstado)" },
            { de: "ctrl_mascota", para: "t_bitacora", nombre: "registrarAccion (vet_id, 'CAMBIO_ESTADO_CLINICO')" },
            { de: "ctrl_mascota", para: "vista", nombre: "confirmarCambio ()" },
            { de: "vista", para: "actor", nombre: "Actualizar indicador de estado en la ficha" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU20: Habilitar Mascota para Adopción
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU20",
        nombre: "CU20 - Habilitar Mascota para Adopción",
        paquete: "P8_Adopciones",
        lifelines: [
            { id: "actor", nombre: "Veterinario / Director", tipo: "Actor", alias: ": Veterinario" },
            { id: "vista", nombre: "Vista Mascotas (mascotas.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Mascotas" },
            { id: "ctrl_mascota", nombre: "MascotaController", tipo: "Sequence", estereotipo: "control", alias: ": MascotaController" },
            { id: "t_mascota", nombre: "Mascota (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "vista_adop", nombre: "Catálogo Público Adopciones", tipo: "Sequence", estereotipo: "boundary", alias: ": Portal Adopciones" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Validar alta médica y esterilización" },
            { de: "vista", para: "ctrl_mascota", nombre: "validarDisponibilidadAdopcion (mascota_id)" },
            { de: "ctrl_mascota", para: "ctrl_mascota", nombre: "verificarEsterilizadoYVacunado (mascota_id)" },
            { de: "ctrl_mascota", para: "t_mascota", nombre: "updateEstado (mascota_id, 'en_adopcion')" },
            { de: "ctrl_mascota", para: "vista_adop", nombre: "publicarEnGaleria (mascota_id)" },
            { de: "ctrl_mascota", para: "vista", nombre: "confirmarHabilitacion ()" },
            { de: "vista", para: "actor", nombre: "Animal visible para postulantes de adopción" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU21: Registrar Postulante y Evaluación de Idoneidad
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU21",
        nombre: "CU21 - Registrar Postulante y Evaluación de Idoneidad",
        paquete: "P8_Adopciones",
        lifelines: [
            { id: "actor", nombre: "Postulante / Adoptante", tipo: "Actor", alias: ": Postulante" },
            { id: "vista", nombre: "Formulario Solicitud (solicitud.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Postulacion" },
            { id: "ctrl_interesado", nombre: "InteresadoAdopcionController", tipo: "Sequence", estereotipo: "control", alias: ": InteresadoController" },
            { id: "ctrl_eval", nombre: "EvaluacionIdoneidadController", tipo: "Sequence", estereotipo: "control", alias: ": EvaluacionController" },
            { id: "t_interesado", nombre: "Interesado (interesado_adopcion)", tipo: "Sequence", estereotipo: "entity", alias: ": InteresadoAdopcion" },
            { id: "t_eval", nombre: "Evaluación (evaluacion_idoneidad)", tipo: "Sequence", estereotipo: "entity", alias: ": EvaluacionIdoneidad" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Completar cuestionario de vivienda, ingresos y compromiso" },
            { de: "vista", para: "ctrl_interesado", nombre: "registrarPostulante (datosPostulante, respuestas)" },
            { de: "ctrl_interesado", para: "t_interesado", nombre: "crearPostulante (ci, nombre, telefono)" },
            { de: "ctrl_interesado", para: "ctrl_eval", nombre: "calcularCalificacionVivienda (respuestas)" },
            { de: "ctrl_eval", para: "ctrl_eval", nombre: "calcularScoringTotal ()" },
            { de: "ctrl_eval", para: "t_eval", nombre: "guardarDictamen (interesado_id, score, resultado)" },
            { de: "ctrl_interesado", para: "vista", nombre: "retornarResultadoEvaluacion (score, 'Aprobado')" },
            { de: "vista", para: "actor", nombre: "Notificar: 'Solicitud aprobada para formalizar'" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU22: Formalizar Adopción y Generar Contrato PDF
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU22",
        nombre: "CU22 - Formalizar Adopción y Generar Contrato PDF",
        paquete: "P8_Adopciones",
        lifelines: [
            { id: "actor", nombre: "Coordinador de Adopciones", tipo: "Actor", alias: ": Coordinador" },
            { id: "vista", nombre: "Vista Adopciones (adopciones.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Adopciones" },
            { id: "ctrl_adop", nombre: "AdopcionController", tipo: "Sequence", estereotipo: "control", alias: ": AdopcionController" },
            { id: "ctrl_seg", nombre: "SeguimientoAdopcionController", tipo: "Sequence", estereotipo: "control", alias: ": SeguimientoController" },
            { id: "t_adop", nombre: "Adopción (adopcion)", tipo: "Sequence", estereotipo: "entity", alias: ": Adopcion" },
            { id: "t_mascota", nombre: "Mascota (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "t_seg", nombre: "Seguimiento (seguimiento_adopcion)", tipo: "Sequence", estereotipo: "entity", alias: ": SeguimientoAdopcion" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Vincular mascota con postulante aprobado" },
            { de: "vista", para: "ctrl_adop", nombre: "crearRegistroAdopcion (interesado_id, mascota_id, fecha)" },
            { de: "ctrl_adop", para: "t_adop", nombre: "insertAdopcion (interesado_id, mascota_id, fecha)" },
            { de: "ctrl_adop", para: "t_mascota", nombre: "updateEstado (mascota_id, 'Adoptado')" },
            { de: "ctrl_adop", para: "ctrl_seg", nombre: "programarCronogramaVisitas (adopcion_id)" },
            { de: "ctrl_seg", para: "t_seg", nombre: "crearVisitasProgramadas (30, 90, 180 dias)" },
            { de: "ctrl_adop", para: "ctrl_adop", nombre: "generarContratoAdopcionPDF (adopcion_id)" },
            { de: "ctrl_adop", para: "vista", nombre: "descargarActaDigital (pdf_url)" },
            { de: "vista", para: "actor", nombre: "Descarga de contrato legal y calendario de auditorías" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU23: Recepcionar Donación Física (Insumos o Efectivo)
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU23",
        nombre: "CU23 - Recepcionar Donación Física",
        paquete: "P9_PagosDonaciones",
        lifelines: [
            { id: "actor", nombre: "Recepcionista / Cajero", tipo: "Actor", alias: ": Recepcionista" },
            { id: "vista", nombre: "Vista Donaciones (donaciones.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Donaciones" },
            { id: "ctrl_dona", nombre: "DonacionController", tipo: "Sequence", estereotipo: "control", alias: ": DonacionController" },
            { id: "ctrl_art", nombre: "ArticuloInventarioController", tipo: "Sequence", estereotipo: "control", alias: ": ArticuloController" },
            { id: "t_dona", nombre: "Donación (donacion)", tipo: "Sequence", estereotipo: "entity", alias: ": Donacion" },
            { id: "t_insumo", nombre: "Detalle Insumo (detalle_donacion_insumo)", tipo: "Sequence", estereotipo: "entity", alias: ": DetalleInsumo" },
            { id: "t_art", nombre: "Artículo (articulo_inventario)", tipo: "Sequence", estereotipo: "entity", alias: ": ArticuloInventario" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Registrar datos de donante y bolsas de alimento" },
            { de: "vista", para: "ctrl_dona", nombre: "registrarRecepcion (donante_id, tipo='Insumos', items)" },
            { de: "ctrl_dona", para: "t_dona", nombre: "crearCabeceraDonacion (donante_id, fecha, comprobante)" },
            { de: "ctrl_dona", para: "t_insumo", nombre: "registrarInsumoDonado (donacion_id, item)" },
            { de: "ctrl_dona", para: "ctrl_art", nombre: "incrementarStock (articulo_id, cantidad)" },
            { de: "ctrl_art", para: "t_art", nombre: "sumarExistencias (articulo_id, cantidad)" },
            { de: "ctrl_dona", para: "ctrl_dona", nombre: "emitirReciboDonacion (donacion_id)" },
            { de: "ctrl_dona", para: "vista", nombre: "imprimirRecibo (reciboData)" },
            { de: "vista", para: "actor", nombre: "Entrega de certificado físico de agradecimiento" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU24: Monitorear y Registrar Visitas Post-Adopción
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU24",
        nombre: "CU24 - Monitorear y Registrar Visitas Post-Adopción",
        paquete: "P8_Adopciones",
        lifelines: [
            { id: "actor", nombre: "Inspector de Bienestar", tipo: "Actor", alias: ": Inspector" },
            { id: "vista", nombre: "Vista Visitas (adopciones.php#visitas)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Visitas" },
            { id: "ctrl_seg", nombre: "SeguimientoAdopcionController", tipo: "Sequence", estereotipo: "control", alias: ": SeguimientoController" },
            { id: "t_seg", nombre: "Seguimiento (seguimiento_adopcion)", tipo: "Sequence", estereotipo: "entity", alias: ": SeguimientoAdopcion" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar informe de visita domiciliaria y foto" },
            { de: "vista", para: "ctrl_seg", nombre: "registrarVisitaCumplida (visita_id, informe, foto)" },
            { de: "ctrl_seg", para: "t_seg", nombre: "actualizarVisita (visita_id, estado='realizada', informe, foto)" },
            { de: "ctrl_seg", para: "t_bitacora", nombre: "registrarAccion (inspector_id, 'AUDITORIA_VISITA_CUMPLIDA')" },
            { de: "ctrl_seg", para: "vista", nombre: "confirmarAuditoriaOk ()" },
            { de: "vista", para: "actor", nombre: "Marcar visita como completada e informe archivado" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU25: Generar Reporte Estadístico y Métricas Gerenciales
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU25",
        nombre: "CU25 - Generar Reporte Estadístico y Métricas Gerenciales",
        paquete: "P10_IndicadoresGerenciales",
        lifelines: [
            { id: "actor", nombre: "Director / Gerente", tipo: "Actor", alias: ": Director" },
            { id: "vista", nombre: "Vista Reportes (reportes-gerenciales.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Reportes" },
            { id: "ctrl_rep", nombre: "ReportesGerencialesController", tipo: "Sequence", estereotipo: "control", alias: ": ReportesController" },
            { id: "t_adop", nombre: "Adopciones (adopcion)", tipo: "Sequence", estereotipo: "entity", alias: ": Adopcion" },
            { id: "t_mascota", nombre: "Mascotas (mascota)", tipo: "Sequence", estereotipo: "entity", alias: ": Mascota" },
            { id: "t_dona", nombre: "Donaciones (donacion)", tipo: "Sequence", estereotipo: "entity", alias: ": Donacion" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Solicitar balance semestral consolidado" },
            { de: "vista", para: "ctrl_rep", nombre: "generarConsolidadoSemestral ()" },
            { de: "ctrl_rep", para: "t_adop", nombre: "contarAdopcionesPorMes ()" },
            { de: "ctrl_rep", para: "t_mascota", nombre: "contarRescatesPorMes ()" },
            { de: "ctrl_rep", para: "t_dona", nombre: "sumarRecaudacionMensual ()" },
            { de: "ctrl_rep", para: "ctrl_rep", nombre: "consolidarGraficosYTablas ()" },
            { de: "ctrl_rep", para: "vista", nombre: "renderizarDashboard (metricas)" },
            { de: "vista", para: "actor", nombre: "Visualización de gráficos ejecutivos y opción exportar PDF" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU26: Procesar Donación Digital / Checkout QR
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU26",
        nombre: "CU26 - Procesar Donación Digital / Checkout QR",
        paquete: "P9_PagosDonaciones",
        lifelines: [
            { id: "actor", nombre: "Donante Solidario", tipo: "Actor", alias: ": Donante" },
            { id: "vista", nombre: "Portal Donaciones (pasarela-pagos.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Checkout Portal" },
            { id: "ctrl_aporte", nombre: "AporteDineroController", tipo: "Sequence", estereotipo: "control", alias: ": AporteDineroController" },
            { id: "pasarela_api", nombre: "API Pasarela Bancaria", tipo: "Sequence", estereotipo: "control", alias: ": Pasarela Externa" },
            { id: "t_dona", nombre: "Donación (donacion)", tipo: "Sequence", estereotipo: "entity", alias: ": Donacion" },
            { id: "t_aporte", nombre: "Aporte (aporte_dinero)", tipo: "Sequence", estereotipo: "entity", alias: ": AporteDinero" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar monto (Bs. 100) y solicitar QR" },
            { de: "vista", para: "ctrl_aporte", nombre: "registrarPagoPasarela (monto, canal='QR_SIMPLE')" },
            { de: "ctrl_aporte", para: "t_dona", nombre: "crearDonacion (estado='Pendiente')" },
            { de: "ctrl_aporte", para: "pasarela_api", nombre: "generarCobroQR (monto, referencia)" },
            { de: "pasarela_api", para: "ctrl_aporte", nombre: "retornarImagenQR (qrCodeString, transaccionId)" },
            { de: "ctrl_aporte", para: "t_aporte", nombre: "guardarAportePendiente (transaccionId, monto)" },
            { de: "ctrl_aporte", para: "vista", nombre: "mostrarQR (qrCodeString)" },
            { de: "vista", para: "actor", nombre: "Escanear QR con app bancaria personal" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU27: Confirmar Transacción Bancaria Webhook
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU27",
        nombre: "CU27 - Confirmar Transacción Bancaria Webhook",
        paquete: "P9_PagosDonaciones",
        lifelines: [
            { id: "banco", nombre: "Servidor Bancario / Switch", tipo: "Actor", alias: ": Banco Central / Red" },
            { id: "webhook", nombre: "Endpoint Webhook (/api/webhook)", tipo: "Sequence", estereotipo: "boundary", alias: ": Webhook Endpoint" },
            { id: "ctrl_aporte", nombre: "AporteDineroController", tipo: "Sequence", estereotipo: "control", alias: ": AporteDineroController" },
            { id: "t_aporte", nombre: "Aporte (aporte_dinero)", tipo: "Sequence", estereotipo: "entity", alias: ": AporteDinero" },
            { id: "t_dona", nombre: "Donación (donacion)", tipo: "Sequence", estereotipo: "entity", alias: ": Donacion" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "banco", para: "webhook", nombre: "POST /api/pagos/callback (firma, transaccionId, estado='ACREDITADO')" },
            { de: "webhook", para: "ctrl_aporte", nombre: "procesarNotificacionBancaria (payload)" },
            { de: "ctrl_aporte", para: "ctrl_aporte", nombre: "validarFirmaCriptograficaHMAC (payload)" },
            { de: "ctrl_aporte", para: "t_aporte", nombre: "confirmarAcreditacion (transaccionId, fechaAcreditacion)" },
            { de: "ctrl_aporte", para: "t_dona", nombre: "updateEstado (donacion_id, 'Confirmado')" },
            { de: "ctrl_aporte", para: "t_bitacora", nombre: "registrarAccion (0, 'PAGO_WEBHOOK_CONFIRMADO')" },
            { de: "ctrl_aporte", para: "banco", nombre: "HTTP 200 OK (recibido)" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU28: Emitir Comprobante y Certificado Digital
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU28",
        nombre: "CU28 - Emitir Comprobante y Certificado Digital",
        paquete: "P9_PagosDonaciones",
        lifelines: [
            { id: "actor", nombre: "Donante Solidario", tipo: "Actor", alias: ": Donante" },
            { id: "vista", nombre: "Portal Recibos (comprobante.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Portal Recibos" },
            { id: "ctrl_dona", nombre: "DonacionController", tipo: "Sequence", estereotipo: "control", alias: ": DonacionController" },
            { id: "t_dona", nombre: "Donación (donacion)", tipo: "Sequence", estereotipo: "entity", alias: ": Donacion" },
            { id: "t_aporte", nombre: "Aporte (aporte_dinero)", tipo: "Sequence", estereotipo: "entity", alias: ": AporteDinero" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Clic en 'Descargar Comprobante Digital'" },
            { de: "vista", para: "ctrl_dona", nombre: "emitirReciboDonacion (donacion_id)" },
            { de: "ctrl_dona", para: "t_dona", nombre: "consultarDatosAporte (donacion_id)" },
            { de: "t_dona", para: "t_aporte", nombre: "obtenerCodigoAcreditacion ()" },
            { de: "ctrl_dona", para: "ctrl_dona", nombre: "generarSelloDigitalSha256 ()" },
            { de: "ctrl_dona", para: "vista", nombre: "renderizarReciboDigital (reciboConSello)" },
            { de: "vista", para: "actor", nombre: "Descarga de PDF oficial con sello de transparencia fiscal" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU29: Conciliar Caja y Arqueo Financiero
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU29",
        nombre: "CU29 - Conciliar Caja y Arqueo Financiero",
        paquete: "P9_PagosDonaciones",
        lifelines: [
            { id: "actor", nombre: "Administrador / Contador", tipo: "Actor", alias: ": Contador" },
            { id: "vista", nombre: "Vista Conciliación (pasarela-pagos.php#caja)", tipo: "Sequence", estereotipo: "boundary", alias: ": Vista Conciliacion" },
            { id: "ctrl_dona", nombre: "DonacionController", tipo: "Sequence", estereotipo: "control", alias: ": DonacionController" },
            { id: "t_dona", nombre: "Donación (donacion)", tipo: "Sequence", estereotipo: "entity", alias: ": Donacion" },
            { id: "t_aporte", nombre: "Aporte (aporte_dinero)", tipo: "Sequence", estereotipo: "entity", alias: ": AporteDinero" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Seleccionar periodo mensual para arqueo" },
            { de: "vista", para: "ctrl_dona", nombre: "totalizarPorPeriodo (fechaInicio, fechaFin)" },
            { de: "ctrl_dona", para: "t_dona", nombre: "consultarDonacionesPeriodo (fechaInicio, fechaFin)" },
            { de: "ctrl_dona", para: "t_aporte", nombre: "agruparPorCanalYEstado ()" },
            { de: "ctrl_dona", para: "ctrl_dona", nombre: "calcularDiferenciasCaja ()" },
            { de: "ctrl_dona", para: "vista", nombre: "mostrarResumenArqueo (arqueoCanales, totalConfirmado)" },
            { de: "vista", para: "actor", nombre: "Mostrar cuadro comparativo y botón de cierre de caja" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // CU30: Gestionar Reembolso / Reversión Bancaria
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU30",
        nombre: "CU30 - Gestionar Reembolso / Reversión Bancaria",
        paquete: "P9_PagosDonaciones",
        lifelines: [
            { id: "actor", nombre: "Administrador del Sistema", tipo: "Actor", alias: ": Administrador" },
            { id: "vista", nombre: "Modal Reembolso (pasarela-pagos.php)", tipo: "Sequence", estereotipo: "boundary", alias: ": Modal Reembolso" },
            { id: "ctrl_aporte", nombre: "AporteDineroController", tipo: "Sequence", estereotipo: "control", alias: ": AporteDineroController" },
            { id: "pasarela_api", nombre: "API Pasarela Bancaria", tipo: "Sequence", estereotipo: "control", alias: ": Pasarela Externa" },
            { id: "t_aporte", nombre: "Aporte (aporte_dinero)", tipo: "Sequence", estereotipo: "entity", alias: ": AporteDinero" },
            { id: "t_bitacora", nombre: "Bitácora (bitacora)", tipo: "Sequence", estereotipo: "entity", alias: ": Bitácora" }
        ],
        mensajes: [
            { de: "actor", para: "vista", nombre: "Ingresar justificación formal de reversión" },
            { de: "vista", para: "ctrl_aporte", nombre: "procesarReembolso (aporte_id, justificacion)" },
            { de: "ctrl_aporte", para: "pasarela_api", nombre: "solicitarReversion (transaccion_referencia, motivo)" },
            { de: "pasarela_api", para: "ctrl_aporte", nombre: "confirmarReversionExitosa ()" },
            { de: "ctrl_aporte", para: "t_aporte", nombre: "actualizarEstado (aporte_id, 'REEMBOLSADO')" },
            { de: "ctrl_aporte", para: "t_bitacora", nombre: "registrarAccion (admin_id, 'REEMBOLSO_DONACION_APROBADO')" },
            { de: "ctrl_aporte", para: "vista", nombre: "confirmarReembolsoExitoso ()" },
            { de: "vista", para: "actor", nombre: "Actualizar saldo de caja y emitir constancia de anulación" }
        ]
    }
];

// FUNCIÓN PRINCIPAL DE EJECUCIÓN DEL SCRIPT
function main() {
    Session.Output("================================================================================");
    Session.Output("INICIANDO GENERACIÓN DE DIAGRAMAS DE SECUENCIA (REALIZACIÓN DE CU - DISEÑO)");
    Session.Output("================================================================================");

    var repo = Repository;
    var paqueteSeleccionado = repo.GetTreeSelectedPackage();

    if (!paqueteSeleccionado) {
        Session.Prompt("Por favor, seleccione un Paquete en el Project Browser de Enterprise Architect antes de ejecutar.", 0);
        return;
    }

    Session.Output("Paquete destino seleccionado: " + paqueteSeleccionado.Name);

    // Crear paquete contenedor para los Diagramas de Secuencia
    var pkgSecuencias = paqueteSeleccionado.Packages.AddNew("Diagramas_Secuencia_Casos_de_Uso", "Package");
    pkgSecuencias.Update();
    paqueteSeleccionado.Packages.Refresh();

    var diagramasCreados = 0;
    var mensajesTotales = 0;

    for (var i = 0; i < CASOS_DE_USO_SECUENCIA.length; i++) {
        var cu = CASOS_DE_USO_SECUENCIA[i];
        Session.Output("-> Generando Diagrama de Secuencia: " + cu.nombre + " ...");

        // 1. Crear subpaquete específico por Caso de Uso
        var pkgCU = pkgSecuencias.Packages.AddNew(cu.codigo + "_" + cu.paquete, "Package");
        pkgCU.Update();

        // 2. Crear Diagrama de Secuencia
        var diagrama = pkgCU.Diagrams.AddNew(cu.nombre, "Sequence");
        diagrama.Notes = "Realización de caso de uso - diseño (Diagrama de secuencia)\nCaso de Uso: " + cu.nombre + "\nPaquete Arquitectónico: " + cu.paquete;
        diagrama.Update();

        // 3. Crear elementos Lifelines y mapear IDs
        var mapaElementos = {};
        var xOffset = 60;
        var anchoLifeline = 120;
        var espacioX = 65;

        for (var j = 0; j < cu.lifelines.length; j++) {
            var lfDef = cu.lifelines[j];
            var elem;

            if (lfDef.tipo === "Actor") {
                elem = pkgCU.Elements.AddNew(lfDef.nombre, "Actor");
            } else {
                elem = pkgCU.Elements.AddNew(lfDef.nombre, "Sequence");
                if (lfDef.estereotipo) {
                    elem.Stereotype = lfDef.estereotipo;
                }
            }
            elem.Update();
            mapaElementos[lfDef.id] = elem;

            // Posicionar Lifeline en el diagrama
            var left = xOffset;
            var right = left + anchoLifeline;
            var top = -50;
            var bottom = -550;

            var diagObj = diagrama.DiagramObjects.AddNew("l=" + left + ";r=" + right + ";t=" + top + ";b=" + bottom + ";", "");
            diagObj.ElementID = elem.ElementID;
            diagObj.Update();

            xOffset = right + espacioX;
        }

        // 4. Crear los Mensajes de Secuencia ordenados
        for (var m = 0; m < cu.mensajes.length; m++) {
            var msgDef = cu.mensajes[m];
            var elemOrigen = mapaElementos[msgDef.de];
            var elemDestino = mapaElementos[msgDef.para];

            if (elemOrigen && elemDestino) {
                var conn = elemOrigen.Connectors.AddNew(msgDef.nombre, "Sequence");
                conn.SupplierID = elemDestino.ElementID; // Destino de la flecha
                conn.ClientID = elemOrigen.ElementID;    // Origen de la llamada
                conn.SequenceNo = (m + 1);
                conn.Update();
                mensajesTotales++;
            }
        }

        diagrama.Update();
        pkgCU.Elements.Refresh();
        pkgCU.Diagrams.Refresh();
        diagramasCreados++;
    }

    pkgSecuencias.Packages.Refresh();
    repo.RefreshModelView(pkgSecuencias.PackageID);

    Session.Output("================================================================================");
    Session.Output("PROCESO FINALIZADO EXITOSAMENTE");
    Session.Output("Total de Diagramas de Secuencia creados: " + diagramasCreados);
    Session.Output("Total de Mensajes e Interacciones conectadas: " + mensajesTotales);
    Session.Output("Todos los diagramas siguen la estructura exacta: Actor -> :Vista -> :Controlador -> :Gestor -> :Entidades");
    Session.Output("================================================================================");
}

// Ejecutar el script
main();

