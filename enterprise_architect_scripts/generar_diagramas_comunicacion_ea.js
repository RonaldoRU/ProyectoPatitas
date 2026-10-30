!INC Local Scripts.EAConstants-JScript

/*
 * ==============================================================================================
 * SCRIPT AUTOMATIZADOR DE DIAGRAMAS DE COMUNICACIÓN (UML) - ENTERPRISE ARCHITECT (JScript)
 * PROYECTO: Sistema Web para Refugio de Animales "Los Angelitos de Edgar"
 * TOTAL CASOS DE USO IMPLEMENTADOS: 30 (CU1 a CU30 agrupados en 10 Paquetes P1 a P10)
 * ==============================================================================================
 * 
 * INSTRUCCIONES DE USO EN ENTERPRISE ARCHITECT:
 * 1. Abra Enterprise Architect con su proyecto EAP/EAPX/QEA o modelo conectado.
 * 2. Abra la ventana de scripting: Specialize / Tools -> Scripting (o presione Ctrl+F11 / Alt+7).
 * 3. En el panel de Scripts, seleccione o cree un grupo "JScript" (o use Local Scripts).
 * 4. Cree un nuevo script llamado "GeneradorDiagramasComunicacion" de tipo "Normal / JScript".
 * 5. Pegue la totalidad del contenido de este archivo y presione Guardar (Ctrl+S).
 * 6. En el Project Browser de EA, seleccione el Paquete raíz o el Paquete donde desea
 *    que se creen los diagramas y objetos.
 * 7. Haga clic derecho sobre este script en la ventana de Scripting y elija "Run Script".
 * 8. Observe la pestaña "System Output" -> "Script".
 * ==============================================================================================
 */

// Definición completa de los 30 Casos de Uso con sus Participantes y Mensajes
var CASOS_DE_USO = [
    // ------------------------------------------------------------------------------------------
    // PAQUETE P1: GESTIÓN DE SEGURIDAD Y AUTENTICACIÓN
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU1",
        nombre: "Iniciar Sesion en la Plataforma Web",
        paquete: "P1_Seguridad_Autenticacion",
        elementos: [
            { alias: "actor", nombre: "Usuario", tipo: "Actor", pos: { left: 50, top: 200, right: 140, bottom: 270 } },
            { alias: "boundary", nombre: ":LoginForm", tipo: "Boundary", pos: { left: 240, top: 200, right: 350, bottom: 270 } },
            { alias: "controller", nombre: ":AuthController", tipo: "Control", pos: { left: 450, top: 200, right: 560, bottom: 270 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 660, top: 120, right: 770, bottom: 190 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 660, top: 280, right: 770, bottom: 350 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "ingresarCredenciales(ci, password)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "login(request)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "where('ci', ci)->first()" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "verificarHash(password, hash)" },
            { origen: "controller", destino: "entity1", orden: "5", texto: "createToken('api_token')" },
            { origen: "controller", destino: "entity2", orden: "6", texto: "registrarAccion('Login exitoso')" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "devolverTokenJwt(token, rol)" }
        ]
    },
    {
        codigo: "CU2",
        nombre: "Cerrar Sesion y Revocar Token",
        paquete: "P1_Seguridad_Autenticacion",
        elementos: [
            { alias: "actor", nombre: "Usuario", tipo: "Actor", pos: { left: 50, top: 180, right: 140, bottom: 250 } },
            { alias: "boundary", nombre: ":TopNav", tipo: "Boundary", pos: { left: 240, top: 180, right: 350, bottom: 250 } },
            { alias: "controller", nombre: ":AuthController", tipo: "Control", pos: { left: 450, top: 180, right: 560, bottom: 250 } },
            { alias: "entity1", nombre: ":PersonalAccessToken", tipo: "Entity", pos: { left: 660, top: 120, right: 780, bottom: 190 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 660, top: 260, right: 770, bottom: 330 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "clickCerrarSesion()" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "logout(token)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "currentAccessToken()->delete()" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "registrarAccion('Logout del sistema')" },
            { origen: "controller", destino: "boundary", orden: "5", texto: "confirmarCierreSesion()" }
        ]
    },
    {
        codigo: "CU3",
        nombre: "Recuperar Contrasena Olvidada",
        paquete: "P1_Seguridad_Autenticacion",
        elementos: [
            { alias: "actor", nombre: "Usuario", tipo: "Actor", pos: { left: 50, top: 180, right: 140, bottom: 250 } },
            { alias: "boundary", nombre: ":RecuperarPassView", tipo: "Boundary", pos: { left: 240, top: 180, right: 360, bottom: 250 } },
            { alias: "controller", nombre: ":PasswordRecoveryController", tipo: "Control", pos: { left: 460, top: 180, right: 590, bottom: 250 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 680, top: 120, right: 790, bottom: 190 } },
            { alias: "entity2", nombre: ":PasswordResetToken", tipo: "Entity", pos: { left: 680, top: 260, right: 800, bottom: 330 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "solicitarRestablecimiento(email, ci)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "enviarEnlace(email, ci)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "verificarIdentidad(email, ci)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "generarTokenTemporal(user_id)" },
            { origen: "controller", destino: "entity1", orden: "5", texto: "updatePassword(nuevaPasswordHash)" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "mostrarConfirmacionRestablecido()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P2: ADMINISTRACIÓN DE USUARIOS (RBAC)
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU4",
        nombre: "Registrar Nuevo Usuario del Sistema",
        paquete: "P2_Administracion_Usuarios_RBAC",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":UsuariosView", tipo: "Boundary", pos: { left: 240, top: 190, right: 350, bottom: 260 } },
            { alias: "controller", nombre: ":UsuarioController", tipo: "Control", pos: { left: 450, top: 190, right: 570, bottom: 260 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 670, top: 130, right: 780, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 670, top: 270, right: 780, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "ingresarDatosUsuario(nombre, ci, rol, email, pass)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(usuarioData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "validateUnique(ci, email)" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "create(usuarioData, hashPass)" },
            { origen: "controller", destino: "entity2", orden: "5", texto: "registrarAccion('Creacion usuario id')" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "respuestaUsuarioCreado(status 201)" }
        ]
    },
    {
        codigo: "CU5",
        nombre: "Consultar Catalogo y Perfil de Usuarios",
        paquete: "P2_Administracion_Usuarios_RBAC",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 180, right: 150, bottom: 250 } },
            { alias: "boundary", nombre: ":UsuariosView", tipo: "Boundary", pos: { left: 250, top: 180, right: 360, bottom: 250 } },
            { alias: "controller", nombre: ":UsuarioController", tipo: "Control", pos: { left: 460, top: 180, right: 580, bottom: 250 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 680, top: 180, right: 790, bottom: 250 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "abrirModuloUsuarios(filtroRol, buscar)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "index(filtros)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "select(id, nombre, ci, email, rol, activo)" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "mostrarListaUsuarios(usuarios)" }
        ]
    },
    {
        codigo: "CU6",
        nombre: "Modificar Datos de Cuenta de Usuario",
        paquete: "P2_Administracion_Usuarios_RBAC",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":ModalEditarUsuario", tipo: "Boundary", pos: { left: 240, top: 190, right: 370, bottom: 260 } },
            { alias: "controller", nombre: ":UsuarioController", tipo: "Control", pos: { left: 470, top: 190, right: 590, bottom: 260 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 690, top: 130, right: 800, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 690, top: 270, right: 800, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "modificarDatos(id, nombre, telefono, email)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "update(id, datosActualizados)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "findOrFail(id)" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "update(datosActualizados)" },
            { origen: "controller", destino: "entity2", orden: "5", texto: "registrarAccion('Actualizacion datos cuenta')" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "confirmarActualizacion()" }
        ]
    },
    {
        codigo: "CU7",
        nombre: "Cambiar Rol Operativo y Permisos RBAC",
        paquete: "P2_Administracion_Usuarios_RBAC",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":UsuariosView", tipo: "Boundary", pos: { left: 240, top: 190, right: 360, bottom: 260 } },
            { alias: "controller", nombre: ":UsuarioController", tipo: "Control", pos: { left: 460, top: 190, right: 580, bottom: 260 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 680, top: 130, right: 790, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 680, top: 270, right: 790, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "seleccionarNuevoRol(id, nuevoRol)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "cambiarRol(id, nuevoRol)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "verificarRolValido(nuevoRol)" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "update(['rol' => nuevoRol])" },
            { origen: "controller", destino: "entity2", orden: "5", texto: "registrarAccion('Cambio de rol RBAC')" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "notificarRolActualizado()" }
        ]
    },
    {
        codigo: "CU8",
        nombre: "Suspender o Inactivar Cuenta de Usuario",
        paquete: "P2_Administracion_Usuarios_RBAC",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":UsuariosView", tipo: "Boundary", pos: { left: 240, top: 190, right: 360, bottom: 260 } },
            { alias: "controller", nombre: ":UsuarioController", tipo: "Control", pos: { left: 460, top: 190, right: 580, bottom: 260 } },
            { alias: "entity1", nombre: ":User", tipo: "Entity", pos: { left: 680, top: 120, right: 790, bottom: 190 } },
            { alias: "entity2", nombre: ":PersonalAccessToken", tipo: "Entity", pos: { left: 680, top: 210, right: 800, bottom: 280 } },
            { alias: "entity3", nombre: ":Bitacora", tipo: "Entity", pos: { left: 680, top: 300, right: 790, bottom: 370 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "clickAlternarEstado(id)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "toggleActivo(id)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "update(['activo' => !activo])" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "tokens()->delete()" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "registrarAccion('Inactivacion usuario')" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "refrescarEstadoUsuario()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P3: AUDITORÍA Y BITÁCORA DEL SISTEMA
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU9",
        nombre: "Registrar Accion Automatica en Bitacora",
        paquete: "P3_Auditoria_Bitacora",
        elementos: [
            { alias: "actor", nombre: "Sistema", tipo: "Actor", pos: { left: 50, top: 180, right: 140, bottom: 250 } },
            { alias: "boundary", nombre: ":AuditMiddleware", tipo: "Boundary", pos: { left: 230, top: 180, right: 350, bottom: 250 } },
            { alias: "controller", nombre: ":AuditoriaService", tipo: "Control", pos: { left: 440, top: 180, right: 560, bottom: 250 } },
            { alias: "entity1", nombre: ":Bitacora", tipo: "Entity", pos: { left: 660, top: 180, right: 770, bottom: 250 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "interceptarPeticionHttp(request, response)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "registrar(request, user, accion, modulo)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(ip, usuario_id, accion, detalle_json, fecha)" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "confirmarRegistroAuditoria()" }
        ]
    },
    {
        codigo: "CU10",
        nombre: "Consultar y Filtrar Bitacora de Auditoria",
        paquete: "P3_Auditoria_Bitacora",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 180, right: 150, bottom: 250 } },
            { alias: "boundary", nombre: ":BitacoraView", tipo: "Boundary", pos: { left: 240, top: 180, right: 350, bottom: 250 } },
            { alias: "controller", nombre: ":BitacoraController", tipo: "Control", pos: { left: 450, top: 180, right: 570, bottom: 250 } },
            { alias: "entity1", nombre: ":Bitacora", tipo: "Entity", pos: { left: 670, top: 180, right: 780, bottom: 250 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "aplicarFiltros(fechaInicio, modulo, usuario)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "index(filtros)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "queryBitacorasWithUsuario(filtros)" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "renderizarTablaAuditoria(logs)" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P4: CATÁLOGO Y GESTIÓN DE EXISTENCIAS
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU11",
        nombre: "Gestionar Catalogo de Articulos",
        paquete: "P4_Catalogo_Existencias",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":ArticulosView", tipo: "Boundary", pos: { left: 240, top: 190, right: 360, bottom: 260 } },
            { alias: "controller", nombre: ":ArticuloInventarioController", tipo: "Control", pos: { left: 460, top: 190, right: 600, bottom: 260 } },
            { alias: "entity1", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 700, top: 130, right: 820, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 700, top: 270, right: 810, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "ingresarNuevoArticulo(nombre, categoria, stockMin)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(articuloData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(['nombre' => nombre, 'stock_minimo' => min])" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "registrarAccion('Creacion articulo en catalogo')" },
            { origen: "controller", destino: "boundary", orden: "5", texto: "mostrarArticuloCreado(articulo)" }
        ]
    },
    {
        codigo: "CU14",
        nombre: "Consultar Stock Actual y Alertas Minimas",
        paquete: "P4_Catalogo_Existencias",
        elementos: [
            { alias: "actor", nombre: "Usuario", tipo: "Actor", pos: { left: 50, top: 180, right: 140, bottom: 250 } },
            { alias: "boundary", nombre: ":InventarioDashboard", tipo: "Boundary", pos: { left: 240, top: 180, right: 370, bottom: 250 } },
            { alias: "controller", nombre: ":ArticuloInventarioController", tipo: "Control", pos: { left: 470, top: 180, right: 610, bottom: 250 } },
            { alias: "entity1", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 710, top: 180, right: 830, bottom: 250 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "consultarNivelStock()" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "index()" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "whereRaw('stock_actual <= stock_minimo')->get()" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "mostrarAlertasStockCritico(articulosCriticos)" }
        ]
    },
    {
        codigo: "CU17",
        nombre: "Registrar Mermas y Ajustes de Inventario",
        paquete: "P4_Catalogo_Existencias",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":AjusteInventarioModal", tipo: "Boundary", pos: { left: 240, top: 190, right: 380, bottom: 260 } },
            { alias: "controller", nombre: ":AjusteInventarioController", tipo: "Control", pos: { left: 480, top: 190, right: 620, bottom: 260 } },
            { alias: "entity1", nombre: ":AjusteInventario", tipo: "Entity", pos: { left: 720, top: 120, right: 830, bottom: 190 } },
            { alias: "entity2", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 720, top: 210, right: 840, bottom: 280 } },
            { alias: "entity3", nombre: ":Bitacora", tipo: "Entity", pos: { left: 720, top: 300, right: 830, bottom: 370 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "ingresarMerma(articuloId, cantidad, motivo)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(ajusteData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(articuloId, tipo='Merma', cant, motivo)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "decrementStock(articuloId, cantidad)" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "registrarAccion('Merma de inventario')" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "confirmarAjusteRealizado()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P5: ABASTECIMIENTO, COMPRAS Y PROVEEDORES
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU12",
        nombre: "Registrar Entrada de Insumos y Compras",
        paquete: "P5_Abastecimiento_Proveedores",
        elementos: [
            { alias: "actor", nombre: "Recepcionista", tipo: "Actor", pos: { left: 50, top: 200, right: 150, bottom: 270 } },
            { alias: "boundary", nombre: ":EntradasInsumosView", tipo: "Boundary", pos: { left: 240, top: 200, right: 380, bottom: 270 } },
            { alias: "controller", nombre: ":CompraController", tipo: "Control", pos: { left: 470, top: 200, right: 590, bottom: 270 } },
            { alias: "entity1", nombre: ":Compra", tipo: "Entity", pos: { left: 690, top: 100, right: 800, bottom: 170 } },
            { alias: "entity2", nombre: ":DetalleCompra", tipo: "Entity", pos: { left: 690, top: 190, right: 810, bottom: 260 } },
            { alias: "entity3", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 690, top: 280, right: 810, bottom: 350 } },
            { alias: "entity4", nombre: ":InventarioLote", tipo: "Entity", pos: { left: 690, top: 370, right: 810, bottom: 440 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "registrarCompra(proveedorId, nroFactura, items)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(compraData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(proveedorId, total, fecha)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "createMany(detallesItems)" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "incrementStock(articuloId, cantidad)" },
            { origen: "controller", destino: "entity4", orden: "6", texto: "createLote(lote, fechaVencimiento)" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "confirmarEntradaGuardada()" }
        ]
    },
    {
        codigo: "CU13",
        nombre: "Registrar Salida y Consumo de Despensa",
        paquete: "P5_Abastecimiento_Proveedores",
        elementos: [
            { alias: "actor", nombre: "Voluntario", tipo: "Actor", pos: { left: 50, top: 200, right: 140, bottom: 270 } },
            { alias: "boundary", nombre: ":SalidasInventarioView", tipo: "Boundary", pos: { left: 240, top: 200, right: 380, bottom: 270 } },
            { alias: "controller", nombre: ":SalidaInventarioController", tipo: "Control", pos: { left: 480, top: 200, right: 620, bottom: 270 } },
            { alias: "entity1", nombre: ":SalidaInventario", tipo: "Entity", pos: { left: 720, top: 120, right: 830, bottom: 190 } },
            { alias: "entity2", nombre: ":DetalleSalida", tipo: "Entity", pos: { left: 720, top: 210, right: 830, bottom: 280 } },
            { alias: "entity3", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 720, top: 300, right: 840, bottom: 370 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "solicitarInsumosDespensa(destino, items)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(salidaData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(motivo, destino, fecha)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "createMany(itemsSalida)" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "decrementStock(articuloId, cant)" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "confirmarDespachoAlmacen()" }
        ]
    },
    {
        codigo: "CU18",
        nombre: "Gestionar Proveedores de Insumos",
        paquete: "P5_Abastecimiento_Proveedores",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 180, right: 150, bottom: 250 } },
            { alias: "boundary", nombre: ":ProveedoresView", tipo: "Boundary", pos: { left: 240, top: 180, right: 360, bottom: 250 } },
            { alias: "controller", nombre: ":ProveedorController", tipo: "Control", pos: { left: 460, top: 180, right: 580, bottom: 250 } },
            { alias: "entity1", nombre: ":Proveedor", tipo: "Entity", pos: { left: 680, top: 180, right: 790, bottom: 250 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "guardarProveedor(nombre, nit, telefono, direccion)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(proveedorData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(proveedorData)" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "actualizarListaProveedores()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P6: AUTOMATIZACIÓN CLÍNICA Y VENCIMIENTO DE FÁRMACOS
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU15",
        nombre: "Descargo Automatico por Consumo Clinico",
        paquete: "P6_Automatizacion_Clinica",
        elementos: [
            { alias: "actor", nombre: "Veterinario", tipo: "Actor", pos: { left: 50, top: 200, right: 150, bottom: 270 } },
            { alias: "boundary", nombre: ":AtencionClinicaModal", tipo: "Boundary", pos: { left: 240, top: 200, right: 380, bottom: 270 } },
            { alias: "controller", nombre: ":AtencionClinicaController", tipo: "Control", pos: { left: 470, top: 200, right: 610, bottom: 270 } },
            { alias: "entity1", nombre: ":HistorialClinico", tipo: "Entity", pos: { left: 710, top: 110, right: 820, bottom: 180 } },
            { alias: "entity2", nombre: ":SalidaInventario", tipo: "Entity", pos: { left: 710, top: 200, right: 820, bottom: 270 } },
            { alias: "entity3", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 710, top: 290, right: 830, bottom: 360 } },
            { alias: "entity4", nombre: ":InventarioLote", tipo: "Entity", pos: { left: 710, top: 380, right: 820, bottom: 450 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "registrarAtencionConFarmacos(mascotaId, farmacos)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(atencionData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(diagnostico, tratamiento)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "createSalidaClinica(historialId)" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "decrementStock(articuloId, dosis)" },
            { origen: "controller", destino: "entity4", orden: "6", texto: "descontarLotePEPS(farmacoId, dosis)" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "confirmarDescargoClinico()" }
        ]
    },
    {
        codigo: "CU16",
        nombre: "Controlar y Alertar Vencimiento de Farmacos",
        paquete: "P6_Automatizacion_Clinica",
        elementos: [
            { alias: "actor", nombre: "Sistema", tipo: "Actor", pos: { left: 50, top: 180, right: 140, bottom: 250 } },
            { alias: "boundary", nombre: ":ControlVencimientosView", tipo: "Boundary", pos: { left: 240, top: 180, right: 380, bottom: 250 } },
            { alias: "controller", nombre: ":ControlVencimientosController", tipo: "Control", pos: { left: 480, top: 180, right: 630, bottom: 250 } },
            { alias: "entity1", nombre: ":InventarioLote", tipo: "Entity", pos: { left: 730, top: 180, right: 840, bottom: 250 } }
        ],
        mensajes: [
            { origen: "actor", destino: "controller", orden: "1", texto: "ejecutarAuditoriaVencimientos()" },
            { origen: "controller", destino: "entity1", orden: "2", texto: "whereDate('fecha_vencimiento', '<=', now()+30days)" },
            { origen: "controller", destino: "boundary", orden: "3", texto: "emitirAlertaSemaforoVencimiento(lotesCriticos)" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P7: RESCATE, INGRESO E HISTORIAL CLÍNICO
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU19",
        nombre: "Registrar Ficha de Rescate e Ingreso de Mascota",
        paquete: "P7_Rescate_Historial_Clinico",
        elementos: [
            { alias: "actor", nombre: "Voluntario", tipo: "Actor", pos: { left: 50, top: 190, right: 140, bottom: 260 } },
            { alias: "boundary", nombre: ":MascotasView", tipo: "Boundary", pos: { left: 240, top: 190, right: 350, bottom: 260 } },
            { alias: "controller", nombre: ":MascotaController", tipo: "Control", pos: { left: 450, top: 190, right: 570, bottom: 260 } },
            { alias: "entity1", nombre: ":Mascota", tipo: "Entity", pos: { left: 670, top: 130, right: 780, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 670, top: 270, right: 780, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "ingresarFichaRescate(nombre, especie, estadoSalud, zona)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(mascotaData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(mascotaData, estado='Disponible')" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "registrarAccion('Ingreso de mascota')" },
            { origen: "controller", destino: "boundary", orden: "5", texto: "mostrarExpedienteMascota(mascota)" }
        ]
    },
    {
        codigo: "CU20",
        nombre: "Consultar Expediente y Registrar Atencion Medica",
        paquete: "P7_Rescate_Historial_Clinico",
        elementos: [
            { alias: "actor", nombre: "Veterinario", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":AtencionesClinicasView", tipo: "Boundary", pos: { left: 250, top: 190, right: 390, bottom: 260 } },
            { alias: "controller", nombre: ":AtencionClinicaController", tipo: "Control", pos: { left: 490, top: 190, right: 630, bottom: 260 } },
            { alias: "entity1", nombre: ":Mascota", tipo: "Entity", pos: { left: 730, top: 130, right: 840, bottom: 200 } },
            { alias: "entity2", nombre: ":HistorialClinico", tipo: "Entity", pos: { left: 730, top: 270, right: 850, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "buscarExpedienteMascota(mascotaId)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "getHistorial(mascotaId)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "findOrFail(mascotaId)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "historialClinico()->get()" },
            { origen: "controller", destino: "boundary", orden: "5", texto: "renderizarExpediente(consultasPrevias)" },
            { origen: "actor", destino: "boundary", orden: "6", texto: "guardarConsulta(sintomas, diagnostico, tratamiento)" },
            { origen: "boundary", destino: "controller", orden: "7", texto: "store(consultaData)" },
            { origen: "controller", destino: "entity2", orden: "8", texto: "create(consultaData)" },
            { origen: "controller", destino: "boundary", orden: "9", texto: "confirmarAtencionRegistrada()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P8: GESTIÓN INTEGRAL DE ADOPCIONES Y VISITAS DE CONTROL
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU21",
        nombre: "Registrar y Evaluar Postulante a Adopcion",
        paquete: "P8_Gestion_Adopciones_Seguimiento",
        elementos: [
            { alias: "actor", nombre: "Recepcionista", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":PostulantesView", tipo: "Boundary", pos: { left: 240, top: 190, right: 360, bottom: 260 } },
            { alias: "controller", nombre: ":PostulanteController", tipo: "Control", pos: { left: 460, top: 190, right: 590, bottom: 260 } },
            { alias: "entity1", nombre: ":InteresadoAdopcion", tipo: "Entity", pos: { left: 690, top: 130, right: 820, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 690, top: 270, right: 800, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "ingresarPostulante(nombre, ci, direccion, puntaje)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(postulanteData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(postulanteData, estado='En evaluacion')" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "mostrarPostulanteRegistrado()" },
            { origen: "actor", destino: "boundary", orden: "5", texto: "evaluarPostulante(id, calificacion, 'Aprobado')" },
            { origen: "boundary", destino: "controller", orden: "6", texto: "update(id, estado='Aprobado')" },
            { origen: "controller", destino: "entity1", orden: "7", texto: "update(['estado' => 'Aprobado'])" },
            { origen: "controller", destino: "entity2", orden: "8", texto: "registrarAccion('Postulante aprobado')" }
        ]
    },
    {
        codigo: "CU22",
        nombre: "Formalizar Adopcion y Programar Visitas",
        paquete: "P8_Gestion_Adopciones_Seguimiento",
        elementos: [
            { alias: "actor", nombre: "Recepcionista", tipo: "Actor", pos: { left: 50, top: 200, right: 150, bottom: 270 } },
            { alias: "boundary", nombre: ":AdopcionesView", tipo: "Boundary", pos: { left: 240, top: 200, right: 360, bottom: 270 } },
            { alias: "controller", nombre: ":AdopcionController", tipo: "Control", pos: { left: 460, top: 200, right: 580, bottom: 270 } },
            { alias: "entity1", nombre: ":Adopcion", tipo: "Entity", pos: { left: 680, top: 90, right: 790, bottom: 160 } },
            { alias: "entity2", nombre: ":Mascota", tipo: "Entity", pos: { left: 680, top: 180, right: 790, bottom: 250 } },
            { alias: "entity3", nombre: ":SeguimientoAdopcion", tipo: "Entity", pos: { left: 680, top: 270, right: 820, bottom: 340 } },
            { alias: "entity4", nombre: ":Bitacora", tipo: "Entity", pos: { left: 680, top: 360, right: 790, bottom: 430 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "formalizarAdopcion(postulanteId, mascotaId, fecha)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(adopcionData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(adopcionData)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "update(['estado_actual' => 'Adoptado'])" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "programarVisitasAutomaticas(30, 90, 180 dias)" },
            { origen: "controller", destino: "entity4", orden: "6", texto: "registrarAccion('Adopcion formalizada')" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "emitirActaDigitalPDF(actaData)" }
        ]
    },
    {
        codigo: "CU24",
        nombre: "Consultar y Registrar Visitas de Seguimiento",
        paquete: "P8_Gestion_Adopciones_Seguimiento",
        elementos: [
            { alias: "actor", nombre: "Voluntario", tipo: "Actor", pos: { left: 50, top: 190, right: 140, bottom: 260 } },
            { alias: "boundary", nombre: ":AgendaVisitasView", tipo: "Boundary", pos: { left: 240, top: 190, right: 370, bottom: 260 } },
            { alias: "controller", nombre: ":SeguimientoAdopcionController", tipo: "Control", pos: { left: 470, top: 190, right: 630, bottom: 260 } },
            { alias: "entity1", nombre: ":SeguimientoAdopcion", tipo: "Entity", pos: { left: 730, top: 130, right: 860, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 730, top: 270, right: 840, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "consultarAgendaVisitas(mes, estado)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "index(filtros)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "with(['adopcion.interesado', 'adopcion.mascota'])->get()" },
            { origen: "controller", destino: "boundary", orden: "4", texto: "mostrarListaVisitas(visitas)" },
            { origen: "actor", destino: "boundary", orden: "5", texto: "registrarVisita(id, fecha, reporte, evidenciaFoto)" },
            { origen: "boundary", destino: "controller", orden: "6", texto: "update(id, datosVisita)" },
            { origen: "controller", destino: "entity1", orden: "7", texto: "update(['estado' => 'Concluido Satisfactorio'])" },
            { origen: "controller", destino: "entity2", orden: "8", texto: "registrarAccion('Auditoria visita de control')" },
            { origen: "controller", destino: "boundary", orden: "9", texto: "confirmarVisitaRegistrada()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P9: PASARELA DE PAGOS, DONACIONES MONETARIAS Y RECIBOS DIGITALES
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU23",
        nombre: "Registrar Donacion de Insumos Fisicos",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        elementos: [
            { alias: "actor", nombre: "Recepcionista", tipo: "Actor", pos: { left: 50, top: 200, right: 150, bottom: 270 } },
            { alias: "boundary", nombre: ":DonacionesView", tipo: "Boundary", pos: { left: 240, top: 200, right: 360, bottom: 270 } },
            { alias: "controller", nombre: ":DonacionController", tipo: "Control", pos: { left: 460, top: 200, right: 580, bottom: 270 } },
            { alias: "entity1", nombre: ":Donante", tipo: "Entity", pos: { left: 680, top: 100, right: 790, bottom: 170 } },
            { alias: "entity2", nombre: ":Donacion", tipo: "Entity", pos: { left: 680, top: 190, right: 790, bottom: 260 } },
            { alias: "entity3", nombre: ":DetalleDonacionInsumo", tipo: "Entity", pos: { left: 680, top: 280, right: 830, bottom: 350 } },
            { alias: "entity4", nombre: ":ArticuloInventario", tipo: "Entity", pos: { left: 680, top: 370, right: 800, bottom: 440 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "registrarDonacionInsumos(donanteData, listaInsumos)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "store(donacionData)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "firstOrCreate(donanteData)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "create(donanteId, 'Insumo', fecha)" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "createMany(listaInsumos)" },
            { origen: "controller", destino: "entity4", orden: "6", texto: "incrementStock(articuloId, cantidad)" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "emitirComprobanteDonacion()" }
        ]
    },
    {
        codigo: "CU26",
        nombre: "Procesar Pago y Donacion Monetaria Pasarela",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        elementos: [
            { alias: "actor", nombre: "Donante", tipo: "Actor", pos: { left: 50, top: 200, right: 140, bottom: 270 } },
            { alias: "boundary", nombre: ":PasarelaPagosView", tipo: "Boundary", pos: { left: 230, top: 200, right: 360, bottom: 270 } },
            { alias: "controller", nombre: ":PasarelaPagoController", tipo: "Control", pos: { left: 460, top: 200, right: 600, bottom: 270 } },
            { alias: "entity1", nombre: ":Donacion", tipo: "Entity", pos: { left: 700, top: 110, right: 810, bottom: 180 } },
            { alias: "entity2", nombre: ":AporteDinero", tipo: "Entity", pos: { left: 700, top: 200, right: 810, bottom: 270 } },
            { alias: "external", nombre: ":PasarelaExterna", tipo: "Boundary", pos: { left: 700, top: 290, right: 820, bottom: 360 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "seleccionarMontoYMetodo(monto, 'QR Simple')" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "iniciarPago(donanteId, monto, metodo)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "create(donanteId, 'Monetaria', 'Pendiente')" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "create(monto, metodo, transaccionUuid)" },
            { origen: "controller", destino: "external", orden: "5", texto: "solicitarCobroQR(transaccionUuid, monto)" },
            { origen: "external", destino: "boundary", orden: "6", texto: "renderizarCodigoQREnvivo(qrImagePayload)" },
            { origen: "actor", destino: "external", orden: "7", texto: "escanearYConfirmarPagoBancario()" }
        ]
    },
    {
        codigo: "CU27",
        nombre: "Verificar y Confirmar Transaccion Webhook",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        elementos: [
            { alias: "actor", nombre: ":PasarelaExterna", tipo: "Actor", pos: { left: 50, top: 190, right: 160, bottom: 260 } },
            { alias: "boundary", nombre: ":WebhookEndpoint", tipo: "Boundary", pos: { left: 250, top: 190, right: 370, bottom: 260 } },
            { alias: "controller", nombre: ":PasarelaPagoController", tipo: "Control", pos: { left: 470, top: 190, right: 610, bottom: 260 } },
            { alias: "entity1", nombre: ":AporteDinero", tipo: "Entity", pos: { left: 710, top: 120, right: 820, bottom: 190 } },
            { alias: "entity2", nombre: ":Donacion", tipo: "Entity", pos: { left: 710, top: 210, right: 820, bottom: 280 } },
            { alias: "entity3", nombre: ":Bitacora", tipo: "Entity", pos: { left: 710, top: 300, right: 820, bottom: 370 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "notificarPagoWebhook(payload, firmaHmac)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "handleWebhook(request)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "where('nro_transaccion', txId)->first()" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "update(['estado' => 'Confirmado'])" },
            { origen: "controller", destino: "entity2", orden: "5", texto: "update(['estado' => 'Aprobado'])" },
            { origen: "controller", destino: "entity3", orden: "6", texto: "registrarAccion('Confirmacion automatica pago')" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "devolverAckHttp200()" }
        ]
    },
    {
        codigo: "CU28",
        nombre: "Emitir y Descargar Recibo Digital",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        elementos: [
            { alias: "actor", nombre: "Donante", tipo: "Actor", pos: { left: 50, top: 180, right: 140, bottom: 250 } },
            { alias: "boundary", nombre: ":ReciboDigitalModal", tipo: "Boundary", pos: { left: 240, top: 180, right: 370, bottom: 250 } },
            { alias: "controller", nombre: ":PasarelaPagoController", tipo: "Control", pos: { left: 470, top: 180, right: 610, bottom: 250 } },
            { alias: "entity1", nombre: ":AporteDinero", tipo: "Entity", pos: { left: 710, top: 130, right: 820, bottom: 200 } },
            { alias: "entity2", nombre: ":Donacion", tipo: "Entity", pos: { left: 710, top: 250, right: 820, bottom: 320 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "solicitarReciboDigital(donacionId)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "generarComprobante(donacionId)" },
            { origen: "controller", destino: "entity2", orden: "3", texto: "with(['donante', 'aporteDinero'])->find(id)" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "generarHashFiscalYFirmaDigital()" },
            { origen: "controller", destino: "boundary", orden: "5", texto: "descargarPdfRecibo(comprobantePayload)" }
        ]
    },
    {
        codigo: "CU29",
        nombre: "Conciliar y Arquear Transacciones Financieras",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 190, right: 150, bottom: 260 } },
            { alias: "boundary", nombre: ":ConciliacionFinancieraView", tipo: "Boundary", pos: { left: 240, top: 190, right: 390, bottom: 260 } },
            { alias: "controller", nombre: ":PasarelaPagoController", tipo: "Control", pos: { left: 490, top: 190, right: 630, bottom: 260 } },
            { alias: "entity1", nombre: ":AporteDinero", tipo: "Entity", pos: { left: 730, top: 130, right: 840, bottom: 200 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 730, top: 270, right: 840, bottom: 340 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "solicitarArqueoCaja(fechaInicio, fechaFin)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "conciliacion(fechas)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "sumTotalesPorMetodoYEstado(fechas)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "registrarAccion('Arqueo financiero consultado')" },
            { origen: "controller", destino: "boundary", orden: "5", texto: "mostrarReporteArqueo(totalesQR, efectivo, banco)" }
        ]
    },
    {
        codigo: "CU30",
        nombre: "Gestionar Anulacion o Reembolso de Transaccion",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 200, right: 150, bottom: 270 } },
            { alias: "boundary", nombre: ":ModalReembolso", tipo: "Boundary", pos: { left: 240, top: 200, right: 360, bottom: 270 } },
            { alias: "controller", nombre: ":PasarelaPagoController", tipo: "Control", pos: { left: 460, top: 200, right: 600, bottom: 270 } },
            { alias: "entity1", nombre: ":AporteDinero", tipo: "Entity", pos: { left: 700, top: 120, right: 810, bottom: 190 } },
            { alias: "entity2", nombre: ":Bitacora", tipo: "Entity", pos: { left: 700, top: 210, right: 810, bottom: 280 } },
            { alias: "external", nombre: ":PasarelaExterna", tipo: "Boundary", pos: { left: 700, top: 300, right: 820, bottom: 370 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "solicitarReembolso(donacionId, motivo)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "reembolso(donacionId, motivo)" },
            { origen: "controller", destino: "external", orden: "3", texto: "enviarOrdenReversion(transaccionUuid)" },
            { origen: "controller", destino: "entity1", orden: "4", texto: "update(['estado' => 'Reembolsado'])" },
            { origen: "controller", destino: "entity2", orden: "5", texto: "registrarAccion('Reembolso de transaccion')" },
            { origen: "controller", destino: "boundary", orden: "6", texto: "confirmarReembolsoProcesado()" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // PAQUETE P10: INDICADORES GERENCIALES Y REPORTES ESTRATÉGICOS
    // ------------------------------------------------------------------------------------------
    {
        codigo: "CU25",
        nombre: "Generar Reportes e Indicadores Gerenciales",
        paquete: "P10_Indicadores_Gerenciales",
        elementos: [
            { alias: "actor", nombre: "Administrador", tipo: "Actor", pos: { left: 50, top: 200, right: 150, bottom: 270 } },
            { alias: "boundary", nombre: ":ReportesGerencialesView", tipo: "Boundary", pos: { left: 240, top: 200, right: 390, bottom: 270 } },
            { alias: "controller", nombre: ":ReporteGerencialController", tipo: "Control", pos: { left: 490, top: 200, right: 640, bottom: 270 } },
            { alias: "entity1", nombre: ":Mascota", tipo: "Entity", pos: { left: 740, top: 100, right: 850, bottom: 170 } },
            { alias: "entity2", nombre: ":Adopcion", tipo: "Entity", pos: { left: 740, top: 190, right: 850, bottom: 260 } },
            { alias: "entity3", nombre: ":Donacion", tipo: "Entity", pos: { left: 740, top: 280, right: 850, bottom: 350 } },
            { alias: "entity4", nombre: ":HistorialClinico", tipo: "Entity", pos: { left: 740, top: 370, right: 860, bottom: 440 } }
        ],
        mensajes: [
            { origen: "actor", destino: "boundary", orden: "1", texto: "solicitarDashboardEstrategico(periodo)" },
            { origen: "boundary", destino: "controller", orden: "2", texto: "index(periodo)" },
            { origen: "controller", destino: "entity1", orden: "3", texto: "contarPorEstadoRescate(periodo)" },
            { origen: "controller", destino: "entity2", orden: "4", texto: "tasaAdopcionesEfectivas(periodo)" },
            { origen: "controller", destino: "entity3", orden: "5", texto: "totalRecaudacionesYMonedas(periodo)" },
            { origen: "controller", destino: "entity4", orden: "6", texto: "incidenciaEnfermedades(periodo)" },
            { origen: "controller", destino: "boundary", orden: "7", texto: "renderizarGraficosKPIs(metricasConsolidadas)" }
        ]
    }
];

/**
 * Función principal que ejecuta la automatización en Enterprise Architect
 */
function main() {
    Session.Output("=========================================================================");
    Session.Output("Iniciando Generador de Diagramas de Comunicacion (UML) en Enterprise Architect...");
    Session.Output("Refugio 'Los Angelitos de Edgar' - Casos de Uso CU1 a CU30");
    Session.Output("=========================================================================");

    // 1. Obtener el paquete seleccionado en el Project Browser de EA
    var selectedPackage = Repository.GetTreeSelectedPackage();
    if (!selectedPackage) {
        Session.Prompt("Por favor, seleccione un paquete en el Project Browser de Enterprise Architect antes de ejecutar el script.", promptOK);
        return;
    }

    Session.Output("Paquete destino seleccionado: " + selectedPackage.Name + " (ID: " + selectedPackage.PackageID + ")");

    var diagramasCreados = 0;
    var paquetesCache = {};

    // 2. Iterar sobre los 30 casos de uso
    for (var i = 0; i < CASOS_DE_USO.length; i++) {
        var cu = CASOS_DE_USO[i];
        Session.Output("\nProcesando [" + (i + 1) + "/30] " + cu.codigo + ": " + cu.nombre + "...");

        // A. Obtener o crear el paquete correspondiente (P1 a P10)
        var targetPkg = paquetesCache[cu.paquete];
        if (!targetPkg) {
            targetPkg = obtenerOCrearPaquete(selectedPackage, cu.paquete);
            paquetesCache[cu.paquete] = targetPkg;
        }

        // B. Crear el diagrama de comunicación (UML Communication Diagram)
        var diagramTitle = cu.codigo + " - Comunicacion - " + cu.nombre;
        var diag = targetPkg.Diagrams.AddNew(diagramTitle, "Communication");
        if (!diag.Update()) {
            Session.Output("  [!] Error creando diagrama: " + diag.GetLastError());
            continue;
        }

        // C. Crear los elementos participantes y agregarlos al diagrama
        var mapElementos = {}; // clave: alias, valor: EA.Element
        var mapDiagramObjects = {};

        for (var j = 0; j < cu.elementos.length; j++) {
            var elDef = cu.elementos[j];
            var eaElem = targetPkg.Elements.AddNew(elDef.nombre, elDef.tipo);
            if (!eaElem.Update()) {
                Session.Output("  [!] Error creando elemento " + elDef.nombre + ": " + eaElem.GetLastError());
                continue;
            }
            mapElementos[elDef.alias] = eaElem;

            // Agregar el elemento al diagrama con sus coordenadas
            var p = elDef.pos;
            var diagObj = diag.DiagramObjects.AddNew(
                "l=" + p.left + ";r=" + p.right + ";t=" + p.top + ";b=" + p.bottom + ";", 
                ""
            );
            diagObj.ElementID = eaElem.ElementID;
            diagObj.Update();
            mapDiagramObjects[elDef.alias] = diagObj;
        }

        // D. Crear los conectores (Communication Links) y registrar los mensajes numerados
        var conectoresCache = {}; // clave: origen-destino, valor: EA.Connector

        for (var k = 0; k < cu.mensajes.length; k++) {
            var msg = cu.mensajes[k];
            var elOrigen = mapElementos[msg.origen];
            var elDestino = mapElementos[msg.destino];

            if (!elOrigen || !elDestino) {
                Session.Output("  [!] Elemento de enlace no encontrado para mensaje: " + msg.texto);
                continue;
            }

            // Identificador de enlace no dirigido para reutilizar el conector
            var linkKey1 = elOrigen.ElementID + "-" + elDestino.ElementID;
            var linkKey2 = elDestino.ElementID + "-" + elOrigen.ElementID;
            var conn = conectoresCache[linkKey1] || conectoresCache[linkKey2];

            if (!conn) {
                // Crear conector de comunicación
                conn = elOrigen.Connectors.AddNew("", "CommunicationPath");
                conn.SupplierID = elDestino.ElementID;
                if (!conn.Update()) {
                    // Intento alternativo con InformationFlow o Association según versión de EA
                    conn = elOrigen.Connectors.AddNew("", "Association");
                    conn.SupplierID = elDestino.ElementID;
                    conn.Update();
                }
                conectoresCache[linkKey1] = conn;
                conectoresCache[linkKey2] = conn;
            }

            // Registrar el mensaje numerado en la secuencia de comunicación
            try {
                var messageItem = conn.Messages.AddNew(msg.texto, "Message");
                messageItem.SequenceNum = parseInt(msg.orden);
                messageItem.MessageSort = "synchCall";
                messageItem.Update();
            } catch (exMsg) {
                // En versiones de EA donde los mensajes se agregan como notas de enlace
                conn.Notes = (conn.Notes ? conn.Notes + "\n" : "") + msg.orden + ": " + msg.texto;
                conn.Update();
            }
        }

        diag.Update();
        diagramasCreados++;
        Session.Output("  -> Diagrama creado con éxito: '" + diagramTitle + "' con " + cu.elementos.length + " objetos y " + cu.mensajes.length + " mensajes.");
    }

    selectedPackage.Packages.Refresh();
    Repository.RefreshModelView(selectedPackage.PackageID);

    Session.Output("\n=========================================================================");
    Session.Output("FINALIZADO: Se crearon exitosamente " + diagramasCreados + " Diagramas de Comunicacion.");
    Session.Output("Revise los paquetes P1 a P10 en el Project Browser.");
    Session.Output("=========================================================================");
    Session.Prompt("Se generaron con éxito los " + diagramasCreados + " Diagramas de Comunicación UML en Enterprise Architect.", promptOK);
}

/**
 * Función auxiliar para buscar o crear un paquete por nombre
 */
function obtenerOCrearPaquete(parentPackage, nombrePaquete) {
    for (var i = 0; i < parentPackage.Packages.Count; i++) {
        var existingPkg = parentPackage.Packages.GetAt(i);
        if (existingPkg.Name == nombrePaquete) {
            return existingPkg;
        }
    }

    var newPkg = parentPackage.Packages.AddNew(nombrePaquete, "Package");
    newPkg.Update();
    parentPackage.Packages.Refresh();
    return newPkg;
}

// Ejecución
main();
