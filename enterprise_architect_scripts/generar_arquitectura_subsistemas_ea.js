
/*
 * ==============================================================================================
 * SCRIPT AUTOMATIZADOR DE ARQUITECTURA DE SUBSISTEMAS - ENTERPRISE ARCHITECT (JScript)
 * PROYECTO: Sistema Web para Refugio de Animales "Los Angelitos de Edgar"
 * TIPO DE DIAGRAMA: Componentes / Arquitectura de Software por Subsistema (P1 a P10)
 * ==============================================================================================
 * 
 * DESCRIPCIÓN DEL PATRÓN VISUAL GENERADO:
 * Cada diagrama contiene 3 niveles de componentes arquitectónicos organizados jerárquicamente:
 *  1. Marco Delimitador (Boundary): "Subsistema P[X] - [Nombre del Subsistema]"
 *  2. Nivel Superior («FORM»): Vistas web del frontend (rutas de vistas .php / react)
 *  3. Conector Intermedio: Ensamblado / Interfaz de comunicación (Assembly / Realization)
 *  4. Nivel Medio («CLASS»): Controladores backend en PHP (ej: UsuarioController.php)
 *  5. Conector Inferior: Dependencia (Dependency con línea punteada hacia la base de datos)
 *  6. Nivel Inferior («Table»): Tablas relacionales PostgreSQL de "Basededatosdelawebanimalitos"
 * 
 * INSTRUCCIONES DE USO EN ENTERPRISE ARCHITECT:
 * 1. Abra Enterprise Architect con su proyecto EAP/EAPX/QEA o conexión a BD.
 * 2. Abra la consola de scripting: Menú Specialize -> Tools -> Scripting (o presione Alt+7).
 * 3. En el árbol de Scripts, seleccione un grupo (ej: "Local Scripts" o "JScript").
 * 4. Cree un nuevo script haciendo clic derecho -> "New JScript" con el nombre:
 *    "GenerarArquitecturaSubsistemas"
 * 5. Pegue la TOTALIDAD de este código fuente en el editor y presione Guardar (Ctrl+S).
 * 6. En el Project Browser de EA, HAGA CLIC en el Paquete donde desea generar la arquitectura
 *    (por ejemplo, el paquete raíz "Model" o el paquete de Arquitectura del Sistema).
 * 7. En la ventana de Scripting, haga clic derecho sobre el script -> "Run Script".
 * 8. Observe los logs en la pestaña "System Output" -> "Script".
 * ==============================================================================================
 */

// Definición completa de los 10 Subsistemas con sus Vistas, Controladores, Tablas y Enlaces
var SUBSISTEMAS = [
    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P1: SEGURIDAD Y AUTENTICACIÓN
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P1",
        paquete: "P1_Seguridad_Autenticacion",
        titulo: "Subsistema P1 - Gestión de Seguridad y Autenticación",
        vistas: [
            { id: "v_login", nombre: "views/login.php" },
            { id: "v_recuperar", nombre: "views/recuperar-password.php" },
            { id: "v_logout", nombre: "views/logout.php" }
        ],
        controladores: [
            { id: "c_auth", nombre: "AuthController.php" },
            { id: "c_recovery", nombre: "PasswordRecoveryController.php" }
        ],
        tablas: [
            { id: "t_usuario", nombre: "usuario" },
            { id: "t_sesion", nombre: "sesion_jwt" },
            { id: "t_reset", nombre: "password_reset_token" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_login", controlador: "c_auth" },
            { vista: "v_logout", controlador: "c_auth" },
            { vista: "v_recuperar", controlador: "c_recovery" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_auth", tabla: "t_usuario" },
            { controlador: "c_auth", tabla: "t_sesion" },
            { controlador: "c_auth", tabla: "t_bitacora" },
            { controlador: "c_recovery", tabla: "t_usuario" },
            { controlador: "c_recovery", tabla: "t_reset" },
            { controlador: "c_recovery", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P2: GESTIÓN DE USUARIOS Y RBAC (Diseño idéntico a referencia)
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P2",
        paquete: "P2_Gestion_Usuarios_RBAC",
        titulo: "Subsistema P2 - Gestión de Usuarios y RBAC",
        vistas: [
            { id: "v_ges_user", nombre: "views/gestionusuarios.php" },
            { id: "v_perfil", nombre: "views/perfilusuario.php" },
            { id: "v_permisos", nombre: "views/matrizpermisos.php" }
        ],
        controladores: [
            { id: "c_user", nombre: "UsuarioController.php" },
            { id: "c_rbac", nombre: "RBACController.php" }
        ],
        tablas: [
            { id: "t_usuario", nombre: "usuario" },
            { id: "t_persona", nombre: "persona" },
            { id: "t_rol", nombre: "rol" },
            { id: "t_permiso", nombre: "permiso" },
            { id: "t_rol_permiso", nombre: "rol_permiso" },
            { id: "t_bitacora", nombre: "bitacora" },
            { id: "t_sesion", nombre: "sesion" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_ges_user", controlador: "c_user" },
            { vista: "v_perfil", controlador: "c_user" },
            { vista: "v_permisos", controlador: "c_rbac" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_user", tabla: "t_usuario" },
            { controlador: "c_user", tabla: "t_persona" },
            { controlador: "c_user", tabla: "t_rol" },
            { controlador: "c_user", tabla: "t_bitacora" },
            { controlador: "c_user", tabla: "t_sesion" },
            { controlador: "c_rbac", tabla: "t_rol" },
            { controlador: "c_rbac", tabla: "t_permiso" },
            { controlador: "c_rbac", tabla: "t_rol_permiso" },
            { controlador: "c_rbac", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P3: AUDITORÍA Y TRAZABILIDAD
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P3",
        paquete: "P3_Auditoria_Trazabilidad",
        titulo: "Subsistema P3 - Auditoría y Trazabilidad del Sistema",
        vistas: [
            { id: "v_bitacora", nombre: "views/bitacora-sucesos.php" },
            { id: "v_filtros_aud", nombre: "views/filtros-auditoria.php" },
            { id: "v_export_aud", nombre: "views/exportar-reportes.php" }
        ],
        controladores: [
            { id: "c_bitacora", nombre: "BitacoraController.php" }
        ],
        tablas: [
            { id: "t_bitacora", nombre: "bitacora" },
            { id: "t_usuario", nombre: "usuario" },
            { id: "t_rol", nombre: "rol" },
            { id: "t_sesion", nombre: "sesion" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_bitacora", controlador: "c_bitacora" },
            { vista: "v_filtros_aud", controlador: "c_bitacora" },
            { vista: "v_export_aud", controlador: "c_bitacora" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_bitacora", tabla: "t_bitacora" },
            { controlador: "c_bitacora", tabla: "t_usuario" },
            { controlador: "c_bitacora", tabla: "t_rol" },
            { controlador: "c_bitacora", tabla: "t_sesion" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P4: CATÁLOGO Y EXISTENCIAS DE INVENTARIO
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P4",
        paquete: "P4_Catalogo_Existencias",
        titulo: "Subsistema P4 - Catálogo y Existencias de Inventario",
        vistas: [
            { id: "v_articulos", nombre: "views/articulos-inventario.php" },
            { id: "v_ajustes", nombre: "views/ajustes-inventario.php" },
            { id: "v_alertas", nombre: "views/alertas-stock.php" }
        ],
        controladores: [
            { id: "c_articulos", nombre: "ArticuloInventarioController.php" },
            { id: "c_ajustes", nombre: "AjusteInventarioController.php" }
        ],
        tablas: [
            { id: "t_articulos", nombre: "articulo_inventario" },
            { id: "t_lotes", nombre: "inventario_lotes" },
            { id: "t_ajustes", nombre: "ajuste_inventario_lotes" },
            { id: "t_alertas", nombre: "alerta_inventario" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_articulos", controlador: "c_articulos" },
            { vista: "v_alertas", controlador: "c_articulos" },
            { vista: "v_ajustes", controlador: "c_ajustes" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_articulos", tabla: "t_articulos" },
            { controlador: "c_articulos", tabla: "t_lotes" },
            { controlador: "c_articulos", tabla: "t_alertas" },
            { controlador: "c_articulos", tabla: "t_bitacora" },
            { controlador: "c_ajustes", tabla: "t_ajustes" },
            { controlador: "c_ajustes", tabla: "t_articulos" },
            { controlador: "c_ajustes", tabla: "t_lotes" },
            { controlador: "c_ajustes", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P5: ABASTECIMIENTO Y PROVEEDORES
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P5",
        paquete: "P5_Abastecimiento_Proveedores",
        titulo: "Subsistema P5 - Abastecimiento y Proveedores",
        vistas: [
            { id: "v_prov", nombre: "views/proveedores.php" },
            { id: "v_compras", nombre: "views/compras-insumos.php" },
            { id: "v_salidas", nombre: "views/salidas-inventario.php" },
            { id: "v_kardex", nombre: "views/kardex-movimientos.php" }
        ],
        controladores: [
            { id: "c_prov", nombre: "ProveedorController.php" },
            { id: "c_compra", nombre: "CompraController.php" },
            { id: "c_salida", nombre: "SalidaInventarioController.php" }
        ],
        tablas: [
            { id: "t_prov", nombre: "proveedor" },
            { id: "t_compra", nombre: "compra" },
            { id: "t_det_compra", nombre: "detalle_compra" },
            { id: "t_salida", nombre: "salida_inventario" },
            { id: "t_det_salida", nombre: "detalle_salida_lotes" },
            { id: "t_articulo", nombre: "articulo_inventario" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_prov", controlador: "c_prov" },
            { vista: "v_compras", controlador: "c_compra" },
            { vista: "v_salidas", controlador: "c_salida" },
            { vista: "v_kardex", controlador: "c_salida" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_prov", tabla: "t_prov" },
            { controlador: "c_prov", tabla: "t_bitacora" },
            { controlador: "c_compra", tabla: "t_compra" },
            { controlador: "c_compra", tabla: "t_det_compra" },
            { controlador: "c_compra", tabla: "t_articulo" },
            { controlador: "c_compra", tabla: "t_prov" },
            { controlador: "c_compra", tabla: "t_bitacora" },
            { controlador: "c_salida", tabla: "t_salida" },
            { controlador: "c_salida", tabla: "t_det_salida" },
            { controlador: "c_salida", tabla: "t_articulo" },
            { controlador: "c_salida", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P6: AUTOMATIZACIÓN CLÍNICA Y VENCIMIENTOS
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P6",
        paquete: "P6_Automatizacion_Clinica",
        titulo: "Subsistema P6 - Automatización Clínica y Vencimientos",
        vistas: [
            { id: "v_vencimientos", nombre: "views/control-vencimientos.php" },
            { id: "v_descargo", nombre: "views/descargo-clinico.php" },
            { id: "v_alertas_clin", nombre: "views/alertas-cuarentena.php" }
        ],
        controladores: [
            { id: "c_auto_clinica", nombre: "AutomatizacionClinicaController.php" },
            { id: "c_salida_clin", nombre: "SalidaInventarioController.php" }
        ],
        tablas: [
            { id: "t_articulos", nombre: "articulo_inventario" },
            { id: "t_lotes", nombre: "inventario_lotes" },
            { id: "t_alertas", nombre: "alerta_inventario" },
            { id: "t_salida", nombre: "salida_inventario" },
            { id: "t_historial", nombre: "historial_clinico" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_vencimientos", controlador: "c_auto_clinica" },
            { vista: "v_descargo", controlador: "c_auto_clinica" },
            { vista: "v_alertas_clin", controlador: "c_salida_clin" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_auto_clinica", tabla: "t_articulos" },
            { controlador: "c_auto_clinica", tabla: "t_lotes" },
            { controlador: "c_auto_clinica", tabla: "t_alertas" },
            { controlador: "c_auto_clinica", tabla: "t_salida" },
            { controlador: "c_auto_clinica", tabla: "t_bitacora" },
            { controlador: "c_salida_clin", tabla: "t_salida" },
            { controlador: "c_salida_clin", tabla: "t_historial" },
            { controlador: "c_salida_clin", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P7: RESCATE E HISTORIAL CLÍNICO
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P7",
        paquete: "P7_Rescate_Historial_Clinico",
        titulo: "Subsistema P7 - Rescate e Historial Clínico",
        vistas: [
            { id: "v_mascotas", nombre: "views/registro-mascotas.php" },
            { id: "v_atenciones", nombre: "views/atenciones-clinicas.php" },
            { id: "v_expediente", nombre: "views/expediente-digital.php" },
            { id: "v_galeria", nombre: "views/galeria-adopcion.php" }
        ],
        controladores: [
            { id: "c_mascota", nombre: "MascotaController.php" },
            { id: "c_historial", nombre: "HistorialClinicoController.php" }
        ],
        tablas: [
            { id: "t_mascota", nombre: "mascota" },
            { id: "t_historial", nombre: "historial_clinico" },
            { id: "t_expediente", nombre: "expediente_digital" },
            { id: "t_usuario", nombre: "usuario" },
            { id: "t_insumo", nombre: "articulo_inventario" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_mascotas", controlador: "c_mascota" },
            { vista: "v_galeria", controlador: "c_mascota" },
            { vista: "v_atenciones", controlador: "c_historial" },
            { vista: "v_expediente", controlador: "c_historial" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_mascota", tabla: "t_mascota" },
            { controlador: "c_mascota", tabla: "t_expediente" },
            { controlador: "c_mascota", tabla: "t_bitacora" },
            { controlador: "c_historial", tabla: "t_historial" },
            { controlador: "c_historial", tabla: "t_mascota" },
            { controlador: "c_historial", tabla: "t_insumo" },
            { controlador: "c_historial", tabla: "t_usuario" },
            { controlador: "c_historial", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P8: GESTIÓN INTEGRAL DE ADOPCIONES
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P8",
        paquete: "P8_Gestion_Adopciones",
        titulo: "Subsistema P8 - Gestión Integral de Adopciones",
        vistas: [
            { id: "v_postulantes", nombre: "views/postulantes-adopcion.php" },
            { id: "v_evaluacion", nombre: "views/evaluacion-idoneidad.php" },
            { id: "v_adopciones", nombre: "views/adopciones-formalizadas.php" },
            { id: "v_visitas", nombre: "views/agenda-visitas-seguimiento.php" }
        ],
        controladores: [
            { id: "c_postulante", nombre: "PostulanteController.php" },
            { id: "c_adopcion", nombre: "AdopcionController.php" },
            { id: "c_seguimiento", nombre: "SeguimientoAdopcionController.php" }
        ],
        tablas: [
            { id: "t_interesado", nombre: "interesado_adopcion" },
            { id: "t_evaluacion", nombre: "evaluacion_idoneidad" },
            { id: "t_adopcion", nombre: "adopcion" },
            { id: "t_seguimiento", nombre: "seguimiento_adopcion" },
            { id: "t_mascota", nombre: "mascota" },
            { id: "t_usuario", nombre: "usuario" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_postulantes", controlador: "c_postulante" },
            { vista: "v_evaluacion", controlador: "c_postulante" },
            { vista: "v_adopciones", controlador: "c_adopcion" },
            { vista: "v_visitas", controlador: "c_seguimiento" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_postulante", tabla: "t_interesado" },
            { controlador: "c_postulante", tabla: "t_evaluacion" },
            { controlador: "c_postulante", tabla: "t_bitacora" },
            { controlador: "c_adopcion", tabla: "t_adopcion" },
            { controlador: "c_adopcion", tabla: "t_interesado" },
            { controlador: "c_adopcion", tabla: "t_mascota" },
            { controlador: "c_adopcion", tabla: "t_usuario" },
            { controlador: "c_adopcion", tabla: "t_bitacora" },
            { controlador: "c_seguimiento", tabla: "t_seguimiento" },
            { controlador: "c_seguimiento", tabla: "t_adopcion" },
            { controlador: "c_seguimiento", tabla: "t_mascota" },
            { controlador: "c_seguimiento", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P9: PASARELA DE PAGOS Y DONACIONES
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P9",
        paquete: "P9_Pasarela_Pagos_Donaciones",
        titulo: "Subsistema P9 - Pasarela de Pagos y Donaciones",
        vistas: [
            { id: "v_donantes", nombre: "views/registro-donantes.php" },
            { id: "v_don_insumos", nombre: "views/donaciones-insumos.php" },
            { id: "v_don_dinero", nombre: "views/donaciones-monetarias.php" },
            { id: "v_pasarela_qr", nombre: "views/pasarela-pagos-qr.php" }
        ],
        controladores: [
            { id: "c_donante", nombre: "DonanteController.php" },
            { id: "c_donacion", nombre: "DonacionController.php" },
            { id: "c_aporte", nombre: "AporteDineroController.php" },
            { id: "c_pasarela", nombre: "PasarelaPagoController.php" }
        ],
        tablas: [
            { id: "t_donante", nombre: "donante" },
            { id: "t_donacion", nombre: "donacion" },
            { id: "t_aporte", nombre: "aporte_dinero" },
            { id: "t_tipo_aporte", nombre: "tipo_aporte" },
            { id: "t_det_insumo", nombre: "detalle_donacion_insumo" },
            { id: "t_articulo", nombre: "articulo_inventario" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_donantes", controlador: "c_donante" },
            { vista: "v_don_insumos", controlador: "c_donacion" },
            { vista: "v_don_dinero", controlador: "c_aporte" },
            { vista: "v_pasarela_qr", controlador: "c_pasarela" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_donante", tabla: "t_donante" },
            { controlador: "c_donante", tabla: "t_bitacora" },
            { controlador: "c_donacion", tabla: "t_donacion" },
            { controlador: "c_donacion", tabla: "t_det_insumo" },
            { controlador: "c_donacion", tabla: "t_articulo" },
            { controlador: "c_donacion", tabla: "t_donante" },
            { controlador: "c_donacion", tabla: "t_bitacora" },
            { controlador: "c_aporte", tabla: "t_aporte" },
            { controlador: "c_aporte", tabla: "t_tipo_aporte" },
            { controlador: "c_aporte", tabla: "t_donacion" },
            { controlador: "c_aporte", tabla: "t_bitacora" },
            { controlador: "c_pasarela", tabla: "t_aporte" },
            { controlador: "c_pasarela", tabla: "t_donacion" },
            { controlador: "c_pasarela", tabla: "t_bitacora" }
        ]
    },

    // ------------------------------------------------------------------------------------------
    // SUBSISTEMA P10: INDICADORES GERENCIALES Y REPORTERÍA
    // ------------------------------------------------------------------------------------------
    {
        codigo: "P10",
        paquete: "P10_Indicadores_Gerenciales",
        titulo: "Subsistema P10 - Indicadores Gerenciales y Reportería",
        vistas: [
            { id: "v_dashboard", nombre: "views/dashboard-ejecutivo.php" },
            { id: "v_reportes", nombre: "views/reportes-estadisticos.php" },
            { id: "v_kpis", nombre: "views/exportacion-kpis.php" }
        ],
        controladores: [
            { id: "c_dashboard", nombre: "DashboardController.php" },
            { id: "c_reportes", nombre: "ReporteGerencialController.php" }
        ],
        tablas: [
            { id: "t_mascota", nombre: "mascota" },
            { id: "t_adopcion", nombre: "adopcion" },
            { id: "t_donacion", nombre: "donacion" },
            { id: "t_historial", nombre: "historial_clinico" },
            { id: "t_compra", nombre: "compra" },
            { id: "t_usuario", nombre: "usuario" },
            { id: "t_bitacora", nombre: "bitacora" }
        ],
        enlaces_vistas_controladores: [
            { vista: "v_dashboard", controlador: "c_dashboard" },
            { vista: "v_reportes", controlador: "c_reportes" },
            { vista: "v_kpis", controlador: "c_reportes" }
        ],
        enlaces_controladores_tablas: [
            { controlador: "c_dashboard", tabla: "t_mascota" },
            { controlador: "c_dashboard", tabla: "t_adopcion" },
            { controlador: "c_dashboard", tabla: "t_donacion" },
            { controlador: "c_dashboard", tabla: "t_historial" },
            { controlador: "c_dashboard", tabla: "t_compra" },
            { controlador: "c_dashboard", tabla: "t_bitacora" },
            { controlador: "c_reportes", tabla: "t_mascota" },
            { controlador: "c_reportes", tabla: "t_adopcion" },
            { controlador: "c_reportes", tabla: "t_donacion" },
            { controlador: "c_reportes", tabla: "t_usuario" },
            { controlador: "c_reportes", tabla: "t_bitacora" }
        ]
    }
];

/**
 * Función Principal del Script en Enterprise Architect
 */
function main() {
    Session.Output("=========================================================================");
    Session.Output("INICIANDO GENERACIÓN DE ARQUITECTURA DE SUBSISTEMAS (P1 A P10)");
    Session.Output("=========================================================================");

    // 1. Obtener paquete seleccionado en el Project Browser
    var selectedPackage = null;
    try {
        selectedPackage = Repository.GetTreeSelectedPackage();
    } catch (e) {
        selectedPackage = null;
    }

    if (!selectedPackage) {
        Session.Prompt("Por favor, seleccione un Paquete en el Project Browser antes de ejecutar.", promptOK);
        return;
    }

    Session.Output("Paquete Base Seleccionado: '" + selectedPackage.Name + "' (ID: " + selectedPackage.PackageID + ")");

    // 2. Crear paquete contenedor de la arquitectura
    var rootPkg = obtenerOCrearPaquete(selectedPackage, "Implementación de la Arquitectura de Subsistemas");

    var diagramasCreados = 0;

    // Dimensiones estándar del lienzo (Lienzo visual amplio)
    var CANVAS_WIDTH = 1380;
    var CANVAS_HEIGHT = 720;
    var BOUNDARY_MARGIN = 30;

    // Altura y posicionamiento Y de las tres capas
    var TOP_Y_FORMS = 80;
    var FORM_H = 75;

    var MID_Y_CTRLS = 270;
    var CTRL_H = 75;

    var BOT_Y_TABLES = 520;
    var TABLE_H = 65;

    // 3. Iterar cada uno de los 10 subsistemas
    for (var s = 0; s < SUBSISTEMAS.length; s++) {
        var sub = SUBSISTEMAS[s];
        Session.Output("\n[" + (s + 1) + "/10] Procesando " + sub.codigo + ": " + sub.titulo);

        // A. Crear paquete del subsistema
        var subPkg = obtenerOCrearPaquete(rootPkg, sub.paquete);

        // B. Crear diagrama de Componentes
        var diag = subPkg.Diagrams.AddNew(sub.titulo, "Component");
        if (!diag.Update()) {
            Session.Output("  [!] Error creando diagrama: " + diag.GetLastError());
            continue;
        }

        // C. Crear Marco Delimitador (Boundary / Frame)
        var boundaryLeft = BOUNDARY_MARGIN;
        var boundaryTop = BOUNDARY_MARGIN;
        var boundaryRight = CANVAS_WIDTH - BOUNDARY_MARGIN;
        var boundaryBottom = CANVAS_HEIGHT - BOUNDARY_MARGIN;

        var boundaryElem = subPkg.Elements.AddNew(sub.titulo, "Boundary");
        boundaryElem.Subtype = 0; // Boundary estándar con pestaña superior
        boundaryElem.Update();

        var boundaryObj = diag.DiagramObjects.AddNew(
            "l=" + boundaryLeft + ";r=" + boundaryRight + ";t=" + (-boundaryTop) + ";b=" + (-boundaryBottom) + ";",
            ""
        );
        boundaryObj.ElementID = boundaryElem.ElementID;
        boundaryObj.left = boundaryLeft;
        boundaryObj.right = boundaryRight;
        boundaryObj.top = -boundaryTop;
        boundaryObj.bottom = -boundaryBottom;
        boundaryObj.Sequence = 1; // Enviar al fondo (Z-Order 1)
        boundaryObj.Update();

        var mapElementos = {}; // clave: id, valor: EA.Element

        // D. Generar componentes de VISTAS («FORM») - Capa Superior
        var nForms = sub.vistas.length;
        var formW = 200;
        var espaciadoForms = (boundaryRight - boundaryLeft - (nForms * formW)) / (nForms + 1);

        for (var f = 0; f < nForms; f++) {
            var vDef = sub.vistas[f];
            var fLeft = Math.round(boundaryLeft + espaciadoForms * (f + 1) + formW * f);
            var fRight = fLeft + formW;
            var fTop = TOP_Y_FORMS;
            var fBottom = fTop + FORM_H;

            var formElem = subPkg.Elements.AddNew(vDef.nombre, "Component");
            formElem.Stereotype = "FORM";
            formElem.Update();
            mapElementos[vDef.id] = formElem;

            var dObjForm = diag.DiagramObjects.AddNew(
                "l=" + fLeft + ";r=" + fRight + ";t=" + (-fTop) + ";b=" + (-fBottom) + ";",
                ""
            );
            dObjForm.ElementID = formElem.ElementID;
            dObjForm.left = fLeft;
            dObjForm.right = fRight;
            dObjForm.top = -fTop;
            dObjForm.bottom = -fBottom;
            dObjForm.Sequence = 10 + f;
            dObjForm.Update();
        }

        // E. Generar componentes de CONTROLADORES («CLASS») - Capa Media
        var nCtrls = sub.controladores.length;
        var ctrlW = 220;
        var espaciadoCtrls = (boundaryRight - boundaryLeft - (nCtrls * ctrlW)) / (nCtrls + 1);

        for (var c = 0; c < nCtrls; c++) {
            var cDef = sub.controladores[c];
            var cLeft = Math.round(boundaryLeft + espaciadoCtrls * (c + 1) + ctrlW * c);
            var cRight = cLeft + ctrlW;
            var cTop = MID_Y_CTRLS;
            var cBottom = cTop + CTRL_H;

            var ctrlElem = subPkg.Elements.AddNew(cDef.nombre, "Component");
            ctrlElem.Stereotype = "CLASS";
            ctrlElem.Update();
            mapElementos[cDef.id] = ctrlElem;

            var dObjCtrl = diag.DiagramObjects.AddNew(
                "l=" + cLeft + ";r=" + cRight + ";t=" + (-cTop) + ";b=" + (-cBottom) + ";",
                ""
            );
            dObjCtrl.ElementID = ctrlElem.ElementID;
            dObjCtrl.left = cLeft;
            dObjCtrl.right = cRight;
            dObjCtrl.top = -cTop;
            dObjCtrl.bottom = -cBottom;
            dObjCtrl.Sequence = 30 + c;
            dObjCtrl.Update();
        }

        // F. Generar componentes de TABLAS («Table») - Capa Inferior
        var nTables = sub.tablas.length;
        var tableW = Math.min(140, Math.floor((boundaryRight - boundaryLeft - 40) / nTables - 15));
        var espaciadoTables = (boundaryRight - boundaryLeft - (nTables * tableW)) / (nTables + 1);

        for (var t = 0; t < nTables; t++) {
            var tDef = sub.tablas[t];
            var tLeft = Math.round(boundaryLeft + espaciadoTables * (t + 1) + tableW * t);
            var tRight = tLeft + tableW;
            var tTop = BOT_Y_TABLES;
            var tBottom = tTop + TABLE_H;

            var tableElem = subPkg.Elements.AddNew(tDef.nombre, "Component");
            tableElem.Stereotype = "Table";
            tableElem.Update();
            mapElementos[tDef.id] = tableElem;

            var dObjTable = diag.DiagramObjects.AddNew(
                "l=" + tLeft + ";r=" + tRight + ";t=" + (-tTop) + ";b=" + (-tBottom) + ";",
                ""
            );
            dObjTable.ElementID = tableElem.ElementID;
            dObjTable.left = tLeft;
            dObjTable.right = tRight;
            dObjTable.top = -tTop;
            dObjTable.bottom = -tBottom;
            dObjTable.Sequence = 50 + t;
            dObjTable.Update();
        }

        // G. Conectores Nivel Superior (Vistas -> Controladores): Conector Assembly (Ball & Socket)
        for (var vc = 0; vc < sub.enlaces_vistas_controladores.length; vc++) {
            var enlaceVC = sub.enlaces_vistas_controladores[vc];
            var elV = mapElementos[enlaceVC.vista];
            var elC = mapElementos[enlaceVC.controlador];

            if (elV && elC) {
                var connVC = elV.Connectors.AddNew("", "Assembly");
                connVC.SupplierID = elC.ElementID;
                if (!connVC.Update()) {
                    // Fallback a Dependency si el perfil no soporta Assembly directo
                    connVC = elV.Connectors.AddNew("", "Dependency");
                    connVC.Stereotype = "use";
                    connVC.SupplierID = elC.ElementID;
                    connVC.Update();
                }
            }
        }

        // H. Conectores Nivel Inferior (Controladores -> Tablas): Dependencia (Línea punteada)
        for (var ct = 0; ct < sub.enlaces_controladores_tablas.length; ct++) {
            var enlaceCT = sub.enlaces_controladores_tablas[ct];
            var elCtrl = mapElementos[enlaceCT.controlador];
            var elTbl = mapElementos[enlaceCT.tabla];

            if (elCtrl && elTbl) {
                var connCT = elCtrl.Connectors.AddNew("", "Dependency");
                connCT.SupplierID = elTbl.ElementID;
                connCT.Update();
            }
        }

        diag.Update();
        diagramasCreados++;
        Session.Output("  -> Diagrama arquitectonico creado con exito: '" + sub.titulo + "'");
    }

    selectedPackage.Packages.Refresh();
    Repository.RefreshModelView(selectedPackage.PackageID);

    Session.Output("\n=========================================================================");
    Session.Output("FINALIZADO CON ÉXITO: " + diagramasCreados + " Diagramas de Arquitectura creados.");
    Session.Output("Estructura generada en: 'Implementación de la Arquitectura de Subsistemas'");
    Session.Output("=========================================================================");
    Session.Prompt("Se generaron con éxito los 10 Diagramas de Arquitectura de Subsistemas (P1 a P10) en Enterprise Architect.", promptOK);
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

