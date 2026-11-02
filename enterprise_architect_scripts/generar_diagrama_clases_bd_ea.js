
/*
 * ==============================================================================================
 * SCRIPT AUTOMATIZADOR DE DIAGRAMA DE BASE DE DATOS (CLASES UML) - ENTERPRISE ARCHITECT (JScript)
 * PROYECTO: Sistema Web para Refugio de Animales "Los Angelitos de Edgar"
 * BASE DE DATOS: Basededatosdelawebanimalitos (PostgreSQL 18)
 * ==============================================================================================
 * 
 * DESCRIPCIÓN:
 * Genera el Diagrama Estructural Completo de Clases de la Base de Datos con:
 *   1. Todas las 25 Clases/Entidades del modelo relacional.
 *   2. Atributos detallados con su tipo de dato (Integer, String, Decimal, Date, DateTime, Boolean).
 *   3. Métodos y Funcionalidades operativas de cada clase (operaciones CRUD, validaciones, lógica de negocio).
 *   4. Relaciones de Asociación con sus respectivas cardinalidades (1..1, 1..*, 0..*, etc.).
 *   5. Organización visual armónica en cuadrícula por áreas funcionales para evitar solapamientos.
 * 
 * INSTRUCCIONES DE USO EN ENTERPRISE ARCHITECT:
 * 1. Abra Enterprise Architect con su proyecto EAP/EAPX/QEA o conexión a BD.
 * 2. Abra la consola de scripting: Menú Specialize -> Tools -> Scripting (o presione Alt+7).
 * 3. En el árbol de Scripts, seleccione un grupo (ej: "Local Scripts" o "JScript").
 * 4. Cree un nuevo script haciendo clic derecho -> "New JScript" con el nombre:
 *    "GenerarDiagramaClasesBD"
 * 5. Pegue la TOTALIDAD de este código fuente en el editor y presione Guardar (Ctrl+S).
 * 6. En el Project Browser de EA, HAGA CLIC en el Paquete donde desea generar el diagrama
 *    (por ejemplo, el paquete raíz "Model" o el paquete de Modelo de Datos).
 * 7. En la ventana de Scripting, haga clic derecho sobre el script -> "Run Script".
 * 8. Observe los logs en la pestaña "System Output" -> "Script".
 * ==============================================================================================
 */

// Definición exhaustiva de las 25 Clases con Atributos, Métodos y Posicionamiento
var CLASES_BD = [
    // ==========================================================================================
    // ÁREA 1: SEGURIDAD, USUARIOS, AUDITORÍA Y SESIONES
    // ==========================================================================================
    {
        id: "Usuario",
        nombre: "Usuario",
        pos: { col: 0, row: 0 },
        atributos: [
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "ci", tipo: "String", vis: "Private" },
            { nombre: "nombres", tipo: "String", vis: "Private" },
            { nombre: "apellidos", tipo: "String", vis: "Private" },
            { nombre: "email", tipo: "String", vis: "Private" },
            { nombre: "password_hash", tipo: "String", vis: "Private" },
            { nombre: "rol", tipo: "String", vis: "Private" },
            { nombre: "telefono", tipo: "String", vis: "Private" },
            { nombre: "estado", tipo: "Boolean", vis: "Private" },
            { nombre: "created_at", tipo: "DateTime", vis: "Private" }
        ],
        metodos: [
            { nombre: "iniciarSesion(credenciales)", retorno: "Boolean" },
            { nombre: "cerrarSesion(token)", retorno: "void" },
            { nombre: "asignarRol(id_rol)", retorno: "void" },
            { nombre: "cambiarPassword(hash)", retorno: "Boolean" },
            { nombre: "inactivarCuenta()", retorno: "void" }
        ]
    },
    {
        id: "RolPermiso",
        nombre: "RolPermiso",
        pos: { col: 1, row: 0 },
        atributos: [
            { nombre: "id_rol_permiso", tipo: "Integer", vis: "Private" },
            { nombre: "rol", tipo: "String", vis: "Private" },
            { nombre: "permiso", tipo: "String", vis: "Private" },
            { nombre: "modulo", tipo: "String", vis: "Private" },
            { nombre: "descripcion", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "verificarPermiso(permiso)", retorno: "Boolean" },
            { nombre: "sincronizarPermisos(permisos)", retorno: "void" },
            { nombre: "revocarPermiso(id_permiso)", retorno: "void" },
            { nombre: "obtenerMatrizRBAC()", retorno: "Array" }
        ]
    },
    {
        id: "SesionJWT",
        nombre: "SesionJWT",
        pos: { col: 0, row: 1 },
        atributos: [
            { nombre: "id_sesion", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "token_hash", tipo: "String", vis: "Private" },
            { nombre: "ip_address", tipo: "String", vis: "Private" },
            { nombre: "activo", tipo: "Boolean", vis: "Private" },
            { nombre: "expira_en", tipo: "DateTime", vis: "Private" }
        ],
        metodos: [
            { nombre: "generarToken(usuario)", retorno: "String" },
            { nombre: "validarToken(token)", retorno: "Boolean" },
            { nombre: "revocarSesion()", retorno: "void" },
            { nombre: "purgarTokensExpirados()", retorno: "Integer" }
        ]
    },
    {
        id: "Bitacora",
        nombre: "Bitacora",
        pos: { col: 1, row: 1 },
        atributos: [
            { nombre: "id_bitacora", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "accion", tipo: "String", vis: "Private" },
            { nombre: "tabla_afectada", tipo: "String", vis: "Private" },
            { nombre: "registro_id", tipo: "Integer", vis: "Private" },
            { nombre: "ip_origen", tipo: "String", vis: "Private" },
            { nombre: "payload_json", tipo: "Text", vis: "Private" },
            { nombre: "fecha_hora", tipo: "DateTime", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarAccion(accion, tabla)", retorno: "void" },
            { nombre: "consultarLogs(filtros)", retorno: "Array" },
            { nombre: "filtrarPorFecha(rango)", retorno: "Array" },
            { nombre: "exportarAuditoriaPDF()", retorno: "File" }
        ]
    },

    // ==========================================================================================
    // ÁREA 2: MASCOTAS, EXPEDIENTE DIGITAL Y ATENCIÓN CLÍNICA
    // ==========================================================================================
    {
        id: "Mascota",
        nombre: "Mascota",
        pos: { col: 2, row: 0 },
        atributos: [
            { nombre: "id_mascota", tipo: "Integer", vis: "Private" },
            { nombre: "codigo_chip", tipo: "String", vis: "Private" },
            { nombre: "nombre", tipo: "String", vis: "Private" },
            { nombre: "especie", tipo: "String", vis: "Private" },
            { nombre: "raza", tipo: "String", vis: "Private" },
            { nombre: "sexo", tipo: "String", vis: "Private" },
            { nombre: "fecha_nac_aprox", tipo: "Date", vis: "Private" },
            { nombre: "peso_kg", tipo: "Decimal", vis: "Private" },
            { nombre: "estado_salud", tipo: "String", vis: "Private" },
            { nombre: "estado_adopcion", tipo: "String", vis: "Private" },
            { nombre: "fecha_ingreso", tipo: "Date", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarIngreso(ficha)", retorno: "void" },
            { nombre: "actualizarEstadoSalud(estado)", retorno: "void" },
            { nombre: "cambiarEstadoAdopcion(estado)", retorno: "void" },
            { nombre: "obtenerHistorialClinico()", retorno: "Array" },
            { nombre: "verificarAptitudAdopcion()", retorno: "Boolean" }
        ]
    },
    {
        id: "ExpedienteDigital",
        nombre: "ExpedienteDigital",
        pos: { col: 3, row: 0 },
        atributos: [
            { nombre: "id_expediente", tipo: "Integer", vis: "Private" },
            { nombre: "id_mascota", tipo: "Integer", vis: "Private" },
            { nombre: "nro_expediente", tipo: "String", vis: "Private" },
            { nombre: "documento_url", tipo: "String", vis: "Private" },
            { nombre: "tipo_documento", tipo: "String", vis: "Private" },
            { nombre: "observaciones", tipo: "Text", vis: "Private" },
            { nombre: "fecha_creacion", tipo: "DateTime", vis: "Private" }
        ],
        metodos: [
            { nombre: "adjuntarDocumento(archivo)", retorno: "void" },
            { nombre: "descargarExpediente()", retorno: "File" },
            { nombre: "actualizarObservaciones(obs)", retorno: "void" }
        ]
    },
    {
        id: "HistorialClinico",
        nombre: "HistorialClinico",
        pos: { col: 2, row: 1 },
        atributos: [
            { nombre: "id_historial", tipo: "Integer", vis: "Private" },
            { nombre: "id_mascota", tipo: "Integer", vis: "Private" },
            { nombre: "id_veterinario", tipo: "Integer", vis: "Private" },
            { nombre: "fecha_atencion", tipo: "DateTime", vis: "Private" },
            { nombre: "peso", tipo: "Decimal", vis: "Private" },
            { nombre: "temperatura", tipo: "Decimal", vis: "Private" },
            { nombre: "diagnostico", tipo: "Text", vis: "Private" },
            { nombre: "tratamiento", tipo: "Text", vis: "Private" },
            { nombre: "receta_medica", tipo: "Text", vis: "Private" },
            { nombre: "proximo_control", tipo: "Date", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarConsulta(diagnostico)", retorno: "void" },
            { nombre: "recetarMedicamentos(items)", retorno: "void" },
            { nombre: "programarProximoControl(fecha)", retorno: "void" },
            { nombre: "solicitarDescargoFarmacia()", retorno: "void" }
        ]
    },

    // ==========================================================================================
    // ÁREA 3: CATÁLOGO DE INVENTARIO, LOTES Y ALERTAS
    // ==========================================================================================
    {
        id: "ArticuloInventario",
        nombre: "ArticuloInventario",
        pos: { col: 4, row: 0 },
        atributos: [
            { nombre: "id_articulo", tipo: "Integer", vis: "Private" },
            { nombre: "codigo_barra", tipo: "String", vis: "Private" },
            { nombre: "nombre", tipo: "String", vis: "Private" },
            { nombre: "categoria", tipo: "String", vis: "Private" },
            { nombre: "unidad_medida", tipo: "String", vis: "Private" },
            { nombre: "stock_minimo", tipo: "Integer", vis: "Private" },
            { nombre: "stock_actual", tipo: "Integer", vis: "Private" },
            { nombre: "activo", tipo: "Boolean", vis: "Private" }
        ],
        metodos: [
            { nombre: "crearArticulo(datos)", retorno: "void" },
            { nombre: "actualizarStock(cantidad)", retorno: "void" },
            { nombre: "evaluarStockBajo()", retorno: "Boolean" },
            { nombre: "calcularValorTotalInventario()", retorno: "Decimal" }
        ]
    },
    {
        id: "InventarioLote",
        nombre: "InventarioLote",
        pos: { col: 4, row: 1 },
        atributos: [
            { nombre: "id_lote", tipo: "Integer", vis: "Private" },
            { nombre: "id_articulo", tipo: "Integer", vis: "Private" },
            { nombre: "nro_lote", tipo: "String", vis: "Private" },
            { nombre: "cantidad_inicial", tipo: "Integer", vis: "Private" },
            { nombre: "cantidad_actual", tipo: "Integer", vis: "Private" },
            { nombre: "fecha_vencimiento", tipo: "Date", vis: "Private" },
            { nombre: "costo_unitario", tipo: "Decimal", vis: "Private" },
            { nombre: "estado", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "ingresarLote(datos)", retorno: "void" },
            { nombre: "descontarUnidades(cant)", retorno: "Boolean" },
            { nombre: "verificarVencimiento(dias)", retorno: "Boolean" },
            { nombre: "pasarACuarentena()", retorno: "void" }
        ]
    },
    {
        id: "AlertaInventario",
        nombre: "AlertaInventario",
        pos: { col: 3, row: 1 },
        atributos: [
            { nombre: "id_alerta", tipo: "Integer", vis: "Private" },
            { nombre: "id_articulo", tipo: "Integer", vis: "Private" },
            { nombre: "id_lote", tipo: "Integer", vis: "Private" },
            { nombre: "tipo_alerta", tipo: "String", vis: "Private" },
            { nombre: "nivel_urgencia", tipo: "String", vis: "Private" },
            { nombre: "mensaje", tipo: "String", vis: "Private" },
            { nombre: "estado", tipo: "String", vis: "Private" },
            { nombre: "fecha_alerta", tipo: "DateTime", vis: "Private" }
        ],
        metodos: [
            { nombre: "generarAlerta(tipo, nivel)", retorno: "void" },
            { nombre: "marcarResuelta()", retorno: "void" },
            { nombre: "notificarPersonalAlmacen()", retorno: "void" }
        ]
    },
    {
        id: "AjusteInventarioLote",
        nombre: "AjusteInventarioLote",
        pos: { col: 4, row: 2 },
        atributos: [
            { nombre: "id_ajuste", tipo: "Integer", vis: "Private" },
            { nombre: "id_lote", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "cantidad_ajustada", tipo: "Integer", vis: "Private" },
            { nombre: "tipo_ajuste", tipo: "String", vis: "Private" },
            { nombre: "motivo_merma", tipo: "String", vis: "Private" },
            { nombre: "fecha_ajuste", tipo: "DateTime", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarMerma(lote, cant)", retorno: "void" },
            { nombre: "aplicarAjusteFisico()", retorno: "void" },
            { nombre: "generarReporteMermas()", retorno: "Array" }
        ]
    },

    // ==========================================================================================
    // ÁREA 4: ABASTECIMIENTO, PROVEEDORES Y DESPACHOS
    // ==========================================================================================
    {
        id: "Proveedor",
        nombre: "Proveedor",
        pos: { col: 0, row: 2 },
        atributos: [
            { nombre: "id_proveedor", tipo: "Integer", vis: "Private" },
            { nombre: "nit", tipo: "String", vis: "Private" },
            { nombre: "razon_social", tipo: "String", vis: "Private" },
            { nombre: "contacto", tipo: "String", vis: "Private" },
            { nombre: "telefono", tipo: "String", vis: "Private" },
            { nombre: "email", tipo: "String", vis: "Private" },
            { nombre: "direccion", tipo: "String", vis: "Private" },
            { nombre: "activo", tipo: "Boolean", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarProveedor(datos)", retorno: "void" },
            { nombre: "actualizarDatos(datos)", retorno: "void" },
            { nombre: "evaluarCumplimiento()", retorno: "Decimal" },
            { nombre: "listarHistorialCompras()", retorno: "Array" }
        ]
    },
    {
        id: "Compra",
        nombre: "Compra",
        pos: { col: 1, row: 2 },
        atributos: [
            { nombre: "id_compra", tipo: "Integer", vis: "Private" },
            { nombre: "id_proveedor", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "nro_factura", tipo: "String", vis: "Private" },
            { nombre: "fecha_compra", tipo: "Date", vis: "Private" },
            { nombre: "total_bs", tipo: "Decimal", vis: "Private" },
            { nombre: "estado", tipo: "String", vis: "Private" },
            { nombre: "observaciones", tipo: "Text", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarCompra(cabecera)", retorno: "void" },
            { nombre: "calcularTotal()", retorno: "Decimal" },
            { nombre: "anularCompra(motivo)", retorno: "Boolean" },
            { nombre: "generarIngresoAlmacen()", retorno: "void" }
        ]
    },
    {
        id: "DetalleCompra",
        nombre: "DetalleCompra",
        pos: { col: 2, row: 2 },
        atributos: [
            { nombre: "id_detalle_compra", tipo: "Integer", vis: "Private" },
            { nombre: "id_compra", tipo: "Integer", vis: "Private" },
            { nombre: "id_articulo", tipo: "Integer", vis: "Private" },
            { nombre: "cantidad", tipo: "Integer", vis: "Private" },
            { nombre: "precio_unitario_bs", tipo: "Decimal", vis: "Private" },
            { nombre: "subtotal_bs", tipo: "Decimal", vis: "Private" }
        ],
        metodos: [
            { nombre: "calcularSubtotal()", retorno: "Decimal" },
            { nombre: "vincularLote(id_lote)", retorno: "void" }
        ]
    },
    {
        id: "SalidaInventario",
        nombre: "SalidaInventario",
        pos: { col: 3, row: 2 },
        atributos: [
            { nombre: "id_salida", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "fecha_salida", tipo: "DateTime", vis: "Private" },
            { nombre: "tipo_salida", tipo: "String", vis: "Private" },
            { nombre: "destino_sector", tipo: "String", vis: "Private" },
            { nombre: "motivo", tipo: "Text", vis: "Private" },
            { nombre: "estado", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarSalida(datos)", retorno: "void" },
            { nombre: "autorizarDespacho()", retorno: "void" },
            { nombre: "emitirComprobanteSalida()", retorno: "File" }
        ]
    },
    {
        id: "DetalleSalidaLote",
        nombre: "DetalleSalidaLote",
        pos: { col: 3, row: 3 },
        atributos: [
            { nombre: "id_detalle_salida", tipo: "Integer", vis: "Private" },
            { nombre: "id_salida", tipo: "Integer", vis: "Private" },
            { nombre: "id_lote", tipo: "Integer", vis: "Private" },
            { nombre: "cantidad", tipo: "Integer", vis: "Private" },
            { nombre: "motivo_especifico", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "descontarLoteStock()", retorno: "void" },
            { nombre: "validarDisponibilidad()", retorno: "Boolean" }
        ]
    },

    // ==========================================================================================
    // ÁREA 5: ADOPCIONES, POSTULANTES Y SEGUIMIENTO POST-ADOPCIÓN
    // ==========================================================================================
    {
        id: "InteresadoAdopcion",
        nombre: "InteresadoAdopcion",
        pos: { col: 0, row: 3 },
        atributos: [
            { nombre: "id_interesado", tipo: "Integer", vis: "Private" },
            { nombre: "ci", tipo: "String", vis: "Private" },
            { nombre: "nombres", tipo: "String", vis: "Private" },
            { nombre: "apellidos", tipo: "String", vis: "Private" },
            { nombre: "telefono", tipo: "String", vis: "Private" },
            { nombre: "direccion", tipo: "String", vis: "Private" },
            { nombre: "tipo_vivienda", tipo: "String", vis: "Private" },
            { nombre: "ingresos_mensuales", tipo: "Decimal", vis: "Private" },
            { nombre: "fecha_postulacion", tipo: "Date", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarPostulante(datos)", retorno: "void" },
            { nombre: "actualizarFicha(datos)", retorno: "void" },
            { nombre: "consultarHistorialPostulacion()", retorno: "Array" }
        ]
    },
    {
        id: "EvaluacionIdoneidad",
        nombre: "EvaluacionIdoneidad",
        pos: { col: 1, row: 3 },
        atributos: [
            { nombre: "id_evaluacion", tipo: "Integer", vis: "Private" },
            { nombre: "id_interesado", tipo: "Integer", vis: "Private" },
            { nombre: "id_evaluador", tipo: "Integer", vis: "Private" },
            { nombre: "puntaje_total", tipo: "Integer", vis: "Private" },
            { nombre: "estado_evaluacion", tipo: "String", vis: "Private" },
            { nombre: "observaciones", tipo: "Text", vis: "Private" },
            { nombre: "fecha_evaluacion", tipo: "Date", vis: "Private" }
        ],
        metodos: [
            { nombre: "calificarPostulante(criterios)", retorno: "Integer" },
            { nombre: "aprobarIdoneidad()", retorno: "void" },
            { nombre: "rechazarPostulacion(motivo)", retorno: "void" }
        ]
    },
    {
        id: "Adopcion",
        nombre: "Adopcion",
        pos: { col: 2, row: 3 },
        atributos: [
            { nombre: "id_adopcion", tipo: "Integer", vis: "Private" },
            { nombre: "id_interesado", tipo: "Integer", vis: "Private" },
            { nombre: "id_mascota", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "nro_contrato", tipo: "String", vis: "Private" },
            { nombre: "fecha_adopcion", tipo: "Date", vis: "Private" },
            { nombre: "estado_adopcion", tipo: "String", vis: "Private" },
            { nombre: "compromiso_esterilizacion", tipo: "Boolean", vis: "Private" },
            { nombre: "observaciones", tipo: "Text", vis: "Private" }
        ],
        metodos: [
            { nombre: "formalizarAdopcion()", retorno: "void" },
            { nombre: "generarContratoPDF()", retorno: "File" },
            { nombre: "programarVisitasSeguimiento()", retorno: "void" },
            { nombre: "revocarAdopcion(causa)", retorno: "void" }
        ]
    },
    {
        id: "SeguimientoAdopcion",
        nombre: "SeguimientoAdopcion",
        pos: { col: 2, row: 4 },
        atributos: [
            { nombre: "id_seguimiento", tipo: "Integer", vis: "Private" },
            { nombre: "id_adopcion", tipo: "Integer", vis: "Private" },
            { nombre: "id_voluntario", tipo: "Integer", vis: "Private" },
            { nombre: "nro_visita", tipo: "Integer", vis: "Private" },
            { nombre: "fecha_programada", tipo: "Date", vis: "Private" },
            { nombre: "fecha_realizada", tipo: "Date", vis: "Private" },
            { nombre: "estado_visita", tipo: "String", vis: "Private" },
            { nombre: "informe_bienestar", tipo: "Text", vis: "Private" },
            { nombre: "foto_evidencia_url", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "agendarVisita(fecha)", retorno: "void" },
            { nombre: "registrarResultadoVisita(informe)", retorno: "void" },
            { nombre: "adjuntarEvidenciaFoto(url)", retorno: "void" },
            { nombre: "reprogramarVisita(nueva_fecha)", retorno: "void" }
        ]
    },

    // ==========================================================================================
    // ÁREA 6: DONACIONES, PASARELA DE PAGOS Y APORTES
    // ==========================================================================================
    {
        id: "Donante",
        nombre: "Donante",
        pos: { col: 0, row: 4 },
        atributos: [
            { nombre: "id_donante", tipo: "Integer", vis: "Private" },
            { nombre: "ci_nit", tipo: "String", vis: "Private" },
            { nombre: "nombre_completo", tipo: "String", vis: "Private" },
            { nombre: "email", tipo: "String", vis: "Private" },
            { nombre: "telefono", tipo: "String", vis: "Private" },
            { nombre: "tipo_donante", tipo: "String", vis: "Private" },
            { nombre: "es_anonimo", tipo: "Boolean", vis: "Private" },
            { nombre: "fecha_registro", tipo: "Date", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarDonante(datos)", retorno: "void" },
            { nombre: "actualizarDatos(datos)", retorno: "void" },
            { nombre: "obtenerHistorialAportes()", retorno: "Array" }
        ]
    },
    {
        id: "Donacion",
        nombre: "Donacion",
        pos: { col: 1, row: 4 },
        atributos: [
            { nombre: "id_donacion", tipo: "Integer", vis: "Private" },
            { nombre: "id_donante", tipo: "Integer", vis: "Private" },
            { nombre: "id_usuario", tipo: "Integer", vis: "Private" },
            { nombre: "tipo_donacion", tipo: "String", vis: "Private" },
            { nombre: "fecha_donacion", tipo: "DateTime", vis: "Private" },
            { nombre: "estado_donacion", tipo: "String", vis: "Private" },
            { nombre: "observaciones", tipo: "Text", vis: "Private" }
        ],
        metodos: [
            { nombre: "registrarDonacion(tipo)", retorno: "void" },
            { nombre: "confirmarRecepcion()", retorno: "void" },
            { nombre: "emitirCertificadoDonacion()", retorno: "File" }
        ]
    },
    {
        id: "AporteDinero",
        nombre: "AporteDinero",
        pos: { col: 3, row: 4 },
        atributos: [
            { nombre: "id_aporte", tipo: "Integer", vis: "Private" },
            { nombre: "id_donacion", tipo: "Integer", vis: "Private" },
            { nombre: "id_tipo_aporte", tipo: "Integer", vis: "Private" },
            { nombre: "monto_bs", tipo: "Decimal", vis: "Private" },
            { nombre: "nro_transaccion_pasarela", tipo: "String", vis: "Private" },
            { nombre: "metodo_pago", tipo: "String", vis: "Private" },
            { nombre: "estado_pago", tipo: "String", vis: "Private" },
            { nombre: "fecha_pago", tipo: "DateTime", vis: "Private" },
            { nombre: "conciliado", tipo: "Boolean", vis: "Private" }
        ],
        metodos: [
            { nombre: "generarOrdenPagoQR(monto)", retorno: "String" },
            { nombre: "procesarWebhookNotificacion()", retorno: "Boolean" },
            { nombre: "conciliarTransaccion()", retorno: "void" },
            { nombre: "solicitarReembolso(motivo)", retorno: "Boolean" },
            { nombre: "emitirReciboFiscalPDF()", retorno: "File" }
        ]
    },
    {
        id: "TipoAporte",
        nombre: "TipoAporte",
        pos: { col: 4, row: 4 },
        atributos: [
            { nombre: "id_tipo_aporte", tipo: "Integer", vis: "Private" },
            { nombre: "nombre", tipo: "String", vis: "Private" },
            { nombre: "descripcion", tipo: "String", vis: "Private" },
            { nombre: "frecuencia", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "crearTipoAporte(datos)", retorno: "void" },
            { nombre: "obtenerTiposActivos()", retorno: "Array" }
        ]
    },
    {
        id: "DetalleDonacionInsumo",
        nombre: "DetalleDonacionInsumo",
        pos: { col: 4, row: 3 },
        atributos: [
            { nombre: "id_detalle_insumo", tipo: "Integer", vis: "Private" },
            { nombre: "id_donacion", tipo: "Integer", vis: "Private" },
            { nombre: "id_articulo", tipo: "Integer", vis: "Private" },
            { nombre: "cantidad", tipo: "Integer", vis: "Private" },
            { nombre: "observaciones", tipo: "String", vis: "Private" }
        ],
        metodos: [
            { nombre: "ingresarStockDonado()", retorno: "void" },
            { nombre: "validarInsumoAlmacen()", retorno: "Boolean" }
        ]
    }
];

// Definición de las 28 Relaciones estructurales entre las Clases de BD
var RELACIONES_BD = [
    // Seguridad y Auditoría
    { origen: "Usuario", destino: "Bitacora", cardOrigen: "1", cardDestino: "0..*", nombre: "registra" },
    { origen: "Usuario", destino: "SesionJWT", cardOrigen: "1", cardDestino: "0..*", nombre: "inicia" },
    { origen: "Usuario", destino: "RolPermiso", cardOrigen: "0..*", cardDestino: "1..*", nombre: "posee" },

    // Mascotas, Rescate y Clínica
    { origen: "Mascota", destino: "ExpedienteDigital", cardOrigen: "1", cardDestino: "1", nombre: "posee" },
    { origen: "Mascota", destino: "HistorialClinico", cardOrigen: "1", cardDestino: "0..*", nombre: "tiene" },
    { origen: "Usuario", destino: "HistorialClinico", cardOrigen: "1", cardDestino: "0..*", nombre: "atiende" },

    // Inventario y Lotes
    { origen: "ArticuloInventario", destino: "InventarioLote", cardOrigen: "1", cardDestino: "0..*", nombre: "almacena_en" },
    { origen: "ArticuloInventario", destino: "AlertaInventario", cardOrigen: "1", cardDestino: "0..*", nombre: "desencadena" },
    { origen: "InventarioLote", destino: "AjusteInventarioLote", cardOrigen: "1", cardDestino: "0..*", nombre: "sufre_ajuste" },
    { origen: "Usuario", destino: "AjusteInventarioLote", cardOrigen: "1", cardDestino: "0..*", nombre: "autoriza_merma" },

    // Abastecimiento y Compras
    { origen: "Proveedor", destino: "Compra", cardOrigen: "1", cardDestino: "0..*", nombre: "provee" },
    { origen: "Usuario", destino: "Compra", cardOrigen: "1", cardDestino: "0..*", nombre: "registra" },
    { origen: "Compra", destino: "DetalleCompra", cardOrigen: "1", cardDestino: "1..*", nombre: "compuesta_por" },
    { origen: "ArticuloInventario", destino: "DetalleCompra", cardOrigen: "1", cardDestino: "0..*", nombre: "adquiere" },

    // Salidas de Almacén y Lotes
    { origen: "Usuario", destino: "SalidaInventario", cardOrigen: "1", cardDestino: "0..*", nombre: "despacha" },
    { origen: "SalidaInventario", destino: "DetalleSalidaLote", cardOrigen: "1", cardDestino: "1..*", nombre: "incluye" },
    { origen: "InventarioLote", destino: "DetalleSalidaLote", cardOrigen: "1", cardDestino: "0..*", nombre: "descarga_de" },

    // Adopciones y Evaluaciones
    { origen: "InteresadoAdopcion", destino: "EvaluacionIdoneidad", cardOrigen: "1", cardDestino: "0..*", nombre: "evaluado_en" },
    { origen: "InteresadoAdopcion", destino: "Adopcion", cardOrigen: "1", cardDestino: "0..*", nombre: "adopta" },
    { origen: "Mascota", destino: "Adopcion", cardOrigen: "1", cardDestino: "0..1", nombre: "adoptada_en" },
    { origen: "Usuario", destino: "Adopcion", cardOrigen: "1", cardDestino: "0..*", nombre: "formaliza" },
    { origen: "Adopcion", destino: "SeguimientoAdopcion", cardOrigen: "1", cardDestino: "1..*", nombre: "programa" },
    { origen: "Usuario", destino: "SeguimientoAdopcion", cardOrigen: "1", cardDestino: "0..*", nombre: "audita" },

    // Donaciones y Pasarela de Pagos
    { origen: "Donante", destino: "Donacion", cardOrigen: "1", cardDestino: "0..*", nombre: "realiza" },
    { origen: "Usuario", destino: "Donacion", cardOrigen: "1", cardDestino: "0..*", nombre: "recibe" },
    { origen: "Donacion", destino: "AporteDinero", cardOrigen: "1", cardDestino: "0..1", nombre: "aporta_monto" },
    { origen: "TipoAporte", destino: "AporteDinero", cardOrigen: "1", cardDestino: "0..*", nombre: "categoriza" },
    { origen: "Donacion", destino: "DetalleDonacionInsumo", cardOrigen: "1", cardDestino: "0..*", nombre: "dona_insumos" },
    { origen: "ArticuloInventario", destino: "DetalleDonacionInsumo", cardOrigen: "1", cardDestino: "0..*", nombre: "incrementa" }
];

/**
 * Función Principal del Script en Enterprise Architect
 */
function main() {
    Session.Output("=========================================================================");
    Session.Output("INICIANDO GENERACIÓN DE DIAGRAMA DE CLASES DE BASE DE DATOS UML");
    Session.Output("PROYECTO: Sistema Web para Refugio de Animales 'Los Angelitos de Edgar'");
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

    // 2. Crear paquete contenedor del modelo de clases de base de datos
    var dbModelPkg = obtenerOCrearPaquete(selectedPackage, "Modelo de Clases de la Base de Datos");

    // 3. Crear Diagrama de Clases UML
    var diagramTitle = "Diagrama de Clases - Basededatosdelawebanimalitos";
    var diag = dbModelPkg.Diagrams.AddNew(diagramTitle, "Logical");
    if (!diag.Update()) {
        diag = dbModelPkg.Diagrams.AddNew(diagramTitle, "Class");
        if (!diag.Update()) {
            Session.Output("  [!] Error creando diagrama: " + diag.GetLastError());
            return;
        }
    }

    // Configuración geométrica de la cuadrícula
    var ORIGIN_X = 60;
    var ORIGIN_Y = 60;
    var CLASS_W = 270;
    var CLASS_H = 250;
    var GAP_X = 70;
    var GAP_Y = 80;

    var mapClases = {}; // clave: id, valor: EA.Element

    Session.Output("\n[1/3] Creando Clases, Atributos y Métodos...");

    // 4. Crear cada clase con sus atributos y operaciones
    for (var i = 0; i < CLASES_BD.length; i++) {
        var cDef = CLASES_BD[i];

        var eaClass = dbModelPkg.Elements.AddNew(cDef.nombre, "Class");
        eaClass.Stereotype = "Entity";
        if (!eaClass.Update()) {
            Session.Output("  [!] Error creando clase " + cDef.nombre + ": " + eaClass.GetLastError());
            continue;
        }
        mapClases[cDef.id] = eaClass;

        // A. Agregar atributos
        for (var a = 0; a < cDef.atributos.length; a++) {
            var aDef = cDef.atributos[a];
            var eaAttr = eaClass.Attributes.AddNew(aDef.nombre, aDef.tipo);
            eaAttr.Visibility = aDef.vis || "Private";
            eaAttr.Update();
        }

        // B. Agregar métodos / funcionalidades
        for (var m = 0; m < cDef.metodos.length; m++) {
            var mDef = cDef.metodos[m];
            var eaMethod = eaClass.Methods.AddNew(mDef.nombre, mDef.retorno || "void");
            eaMethod.Visibility = "Public";
            eaMethod.Update();
        }

        eaClass.Update();

        // C. Posicionar en el diagrama en su celda de la cuadrícula
        var cLeft = ORIGIN_X + cDef.pos.col * (CLASS_W + GAP_X);
        var cRight = cLeft + CLASS_W;
        var cTop = ORIGIN_Y + cDef.pos.row * (CLASS_H + GAP_Y);
        var cBottom = cTop + CLASS_H;

        var diagObj = diag.DiagramObjects.AddNew(
            "l=" + cLeft + ";r=" + cRight + ";t=" + (-cTop) + ";b=" + (-cBottom) + ";",
            ""
        );
        diagObj.ElementID = eaClass.ElementID;
        diagObj.left = cLeft;
        diagObj.right = cRight;
        diagObj.top = -cTop;
        diagObj.bottom = -cBottom;
        diagObj.Update();

        Session.Output("  + Clase creada: " + cDef.nombre + " (" + cDef.atributos.length + " attrs, " + cDef.metodos.length + " metodos)");
    }

    Session.Output("\n[2/3] Creando Relaciones y Cardinalidades...");

    // 5. Crear Asociaciones entre las clases con cardinalidades
    var relsCreadas = 0;
    for (var r = 0; r < RELACIONES_BD.length; r++) {
        var rel = RELACIONES_BD[r];
        var elOrigen = mapClases[rel.origen];
        var elDestino = mapClases[rel.destino];

        if (!elOrigen || !elDestino) {
            continue;
        }

        var conn = elOrigen.Connectors.AddNew(rel.nombre || "", "Association");
        conn.SupplierID = elDestino.ElementID;
        conn.ClientEnd.Cardinality = rel.cardOrigen || "1";
        conn.SupplierEnd.Cardinality = rel.cardDestino || "0..*";
        conn.ClientEnd.AllowDuplicates = false;
        conn.SupplierEnd.AllowDuplicates = false;

        if (conn.Update()) {
            relsCreadas++;
        }
    }

    Session.Output("  -> Relaciones de asociación creadas: " + relsCreadas);

    // 6. Refrescar vistas en Enterprise Architect
    diag.Update();
    selectedPackage.Packages.Refresh();
    Repository.RefreshModelView(selectedPackage.PackageID);

    Session.Output("\n=========================================================================");
    Session.Output("FINALIZADO CON ÉXITO: Diagrama de Clases de la BD generado.");
    Session.Output("Total Clases: " + CLASES_BD.length + " | Total Asociaciones: " + relsCreadas);
    Session.Output("Ubicación: 'Modelo de Clases de la Base de Datos' -> '" + diagramTitle + "'");
    Session.Output("=========================================================================");
    Session.Prompt("Se generó con éxito el Diagrama de Clases de la Base de Datos (" + CLASES_BD.length + " clases y " + relsCreadas + " asociaciones) en Enterprise Architect.", promptOK);
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

