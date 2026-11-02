# Scripts Automatizadores para Sparx Enterprise Architect (JScript)
## Proyecto: Sistema Web para Refugio de Animales "Los Angelitos de Edgar"

Este directorio contiene la suite completa de scripts en **JScript** diseñados para importar, modelar y generar diagramas de arquitectura, diseño y base de datos directamente en **Sparx Enterprise Architect**:

### Catálogo de Scripts Disponibles

1. **[`generar_diagramas_secuencia_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_diagramas_secuencia_ea.js)**:
   - **Tipo:** Diagramas de Secuencia UML (`Sequence Diagram`).
   - **Enfoque:** *Realización de caso de uso - diseño* para los 30 casos de uso.
   - **Estructura de Líneas de Vida:** `Actor` -> `: Vista (Boundary)` -> `: Controlador (Control)` -> `: Gestor (Control/Service)` -> `: Entidades / Tablas (Entity)`.
   - **Mensajes:** Flujos síncronos y asíncronos numerados con parámetros reales del sistema (ej: CU01 - Iniciar Sesión con `password_verify`, generación de sesión y registro en bitácora).

2. **[`generar_arquitectura_subsistemas_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_arquitectura_subsistemas_ea.js)**:
   - **Tipo:** Diagramas de Componentes / Arquitectura de Software por Subsistema (P1 a P10).
   - **Patrón Visual:** Marco delimitador de subsistema, nivel superior «FORM» (vistas frontend), nivel intermedio «CLASS» (controladores backend PHP) con conectores socket/interfaz, y nivel inferior «Table» (tablas PostgreSQL) con líneas punteadas de dependencia.

3. **[`generar_diagramas_comunicacion_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_diagramas_comunicacion_ea.js)**:
   - **Tipo:** Diagramas de Comunicación UML (`Communication Diagram`) para los 30 casos de uso con objetos estereotipados PUDS y numeración secuencial de mensajes.

4. **[`generar_diagrama_clases_bd_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_diagrama_clases_bd_ea.js)**:
   - **Tipo:** Diagrama de Clases de la Base de Datos física con atributos, claves primarias, foráneas, tipos de datos y métodos funcionales mapeados a cada controlador.

5. **[`base_de_datos_con_funcionalidades.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/base_de_datos_con_funcionalidades.js)**:
   - **Tipo:** Catálogo estructurado en JavaScript con la definición completa de tablas, atributos y métodos implementados en el backend.

---

### Instrucciones Generales de Ejecución en Enterprise Architect

1. Abra **Sparx Enterprise Architect** con su proyecto (`.eap`, `.eapx` o `.qea`).
2. Abra la consola de scripting:
   - Menú: **Specialize** (o **Tools**) -> **Scripting**.
   - O presione: `Alt + 7` (o `Ctrl + F11`).
3. En la ventana **Scripting**:
   - Haga clic derecho en **Local Scripts** (o **JScript**) -> **New JScript**.
   - Asigne un nombre al script (ej: `GenerarDiagramasSecuencia` o `GenerarArquitecturaSubsistemas`).
4. Abra el script con doble clic, borre el contenido por defecto y **pegue el contenido del archivo `.js` correspondiente**.
5. Guarde con `Ctrl + S`.
6. En el **Project Browser** de EA (árbol lateral izquierdo), **haga clic sobre el paquete donde desea generar los diagramas**.
7. En la ventana de Scripting, haga clic derecho sobre el script y seleccione **Run Script**.
8. Revise los mensajes en la pestaña **System Output** -> **Script**.

---

### 3. Matriz de Casos de Uso Automatizados

| Paquete | Caso de Uso | Diagrama Generado | Participantes Principales |
| :--- | :--- | :--- | :--- |
| **P1** | **CU1** | Iniciar Sesión en la Plataforma Web | Usuario, LoginForm, AuthController, User, Bitacora |
| **P1** | **CU2** | Cerrar Sesión y Revocar Token JWT | Usuario, TopNav, AuthController, PersonalAccessToken, Bitacora |
| **P1** | **CU3** | Recuperar Contraseña Olvidada | Usuario, RecuperarPassView, PasswordRecoveryController, User, PasswordResetToken |
| **P2** | **CU4** | Registrar Nuevo Usuario del Sistema | Administrador, UsuariosView, UsuarioController, User, Bitacora |
| **P2** | **CU5** | Consultar Catálogo y Perfil de Usuarios | Administrador, UsuariosView, UsuarioController, User |
| **P2** | **CU6** | Modificar Datos de Cuenta de Usuario | Administrador, ModalEditarUsuario, UsuarioController, User, Bitacora |
| **P2** | **CU7** | Cambiar Rol Operativo y Permisos (RBAC) | Administrador, UsuariosView, UsuarioController, User, Bitacora |
| **P2** | **CU8** | Suspender o Inactivar Cuenta de Usuario | Administrador, UsuariosView, UsuarioController, User, PersonalAccessToken, Bitacora |
| **P3** | **CU9** | Registrar Acción Automática en Bitácora | Sistema, AuditMiddleware, AuditoriaService, Bitacora |
| **P3** | **CU10**| Consultar y Filtrar Bitácora de Auditoría | Administrador, BitacoraView, BitacoraController, Bitacora |
| **P4** | **CU11**| Gestionar Catálogo de Artículos | Administrador, ArticulosView, ArticuloInventarioController, ArticuloInventario, Bitacora |
| **P4** | **CU14**| Consultar Stock Actual y Alertas Mínimas | Usuario, InventarioDashboard, ArticuloInventarioController, ArticuloInventario |
| **P4** | **CU17**| Registrar Mermas y Ajustes de Inventario | Administrador, AjusteInventarioModal, AjusteInventarioController, AjusteInventario, ArticuloInventario, Bitacora |
| **P5** | **CU12**| Registrar Entrada de Insumos y Compras | Recepcionista, EntradasInsumosView, CompraController, Compra, DetalleCompra, ArticuloInventario, InventarioLote |
| **P5** | **CU13**| Registrar Salida y Consumo de Despensa | Voluntario, SalidasInventarioView, SalidaInventarioController, SalidaInventario, DetalleSalida, ArticuloInventario |
| **P5** | **CU18**| Gestionar Proveedores de Insumos | Administrador, ProveedoresView, ProveedorController, Proveedor |
| **P6** | **CU15**| Descargo Automático por Consumo Clínico | Veterinario, AtencionClinicaModal, AtencionClinicaController, HistorialClinico, SalidaInventario, ArticuloInventario, InventarioLote |
| **P6** | **CU16**| Controlar y Alertar Vencimiento de Fármacos| Sistema, ControlVencimientosView, ControlVencimientosController, InventarioLote |
| **P7** | **CU19**| Registrar Ficha de Rescate e Ingreso de Mascota| Voluntario, MascotasView, MascotaController, Mascota, Bitacora |
| **P7** | **CU20**| Consultar Expediente y Registrar Atención Médica| Veterinario, AtencionesClinicasView, AtencionClinicaController, Mascota, HistorialClinico |
| **P8** | **CU21**| Registrar y Evaluar Postulante a Adopción | Recepcionista, PostulantesView, PostulanteController, InteresadoAdopcion, Bitacora |
| **P8** | **CU22**| Formalizar Adopción y Programar Visitas | Recepcionista, AdopcionesView, AdopcionController, Adopcion, Mascota, SeguimientoAdopcion, Bitacora |
| **P8** | **CU24**| Consultar y Registrar Visitas de Seguimiento| Voluntario, AgendaVisitasView, SeguimientoAdopcionController, SeguimientoAdopcion, Bitacora |
| **P9** | **CU23**| Registrar Donación de Insumos Físicos | Recepcionista, DonacionesView, DonacionController, Donante, Donacion, DetalleDonacionInsumo, ArticuloInventario |
| **P9** | **CU26**| Procesar Pago y Donación Monetaria Pasarela| Donante, PasarelaPagosView, PasarelaPagoController, Donacion, AporteDinero, PasarelaExterna |
| **P9** | **CU27**| Verificar y Confirmar Transacción Webhook | PasarelaExterna, WebhookEndpoint, PasarelaPagoController, AporteDinero, Donacion, Bitacora |
| **P9** | **CU28**| Emitir y Descargar Recibo Digital | Donante, ReciboDigitalModal, PasarelaPagoController, AporteDinero, Donacion |
| **P9** | **CU29**| Conciliar y Arquear Transacciones Financieras | Administrador, ConciliacionFinancieraView, PasarelaPagoController, AporteDinero, Bitacora |
| **P9** | **CU30**| Gestionar Anulación o Reembolso de Transacción | Administrador, ModalReembolso, PasarelaPagoController, AporteDinero, Bitacora, PasarelaExterna |
| **P10**| **CU25**| Generar Reportes e Indicadores Gerenciales| Administrador, ReportesGerencialesView, ReporteGerencialController, Mascota, Adopcion, Donacion, HistorialClinico |

---

### 4. Diagramas de Arquitectura de Subsistemas (Componentes)
- **Archivo:** [`generar_arquitectura_subsistemas_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_arquitectura_subsistemas_ea.js)
- **Tipo de Diagrama:** UML Component Diagram por cada Subsistema (P1 a P10).
- **Estructura en 3 Capas:**
  1. **Marco Delimitador (`Boundary`):** `Subsistema P[X] - [Nombre]`
  2. **Capa Superior (`«FORM»`):** Vistas web (ej: `views/gestionusuarios.php`, `views/perfilusuario.php`)
  3. **Conector Superior:** Ensamblado / Interfaz (`Assembly` - Ball & Socket)
  4. **Capa Media (`«CLASS»`):** Controladores PHP del sistema (ej: `UsuarioController.php`, `RBACController.php`)
  5. **Conector Inferior:** Dependencia punteada (`Dependency`) hacia la base de datos
  6. **Capa Inferior (`«Table»`):** Tablas relacionales PostgreSQL de `Basededatosdelawebanimalitos` (ej: `usuario`, `persona`, `rol`, `permiso`, `bitacora`, `sesion`)

---

### 5. Diagrama de Clases Estructural de la Base de Datos
- **Archivo:** [`generar_diagrama_clases_bd_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_diagrama_clases_bd_ea.js)
- **Tipo de Diagrama:** UML Class Diagram (`Logical` / `Class`).
- **Contenido Generado:**
  - **25 Clases:** Todas las entidades del modelo relacional (`Usuario`, `RolPermiso`, `SesionJWT`, `Bitacora`, `Mascota`, `ExpedienteDigital`, `HistorialClinico`, `ArticuloInventario`, `InventarioLote`, `AlertaInventario`, `AjusteInventarioLote`, `Proveedor`, `Compra`, `DetalleCompra`, `SalidaInventario`, `DetalleSalidaLote`, `InteresadoAdopcion`, `EvaluacionIdoneidad`, `Adopcion`, `SeguimientoAdopcion`, `Donante`, `Donacion`, `AporteDinero`, `TipoAporte`, `DetalleDonacionInsumo`).
  - **Atributos:** Columnas completas tipadas con visibilidad privada (`- id_usuario: Integer`, `- ci: String`, etc.).
  - **Funcionalidades / Métodos:** Operaciones públicas de cada clase (`+ iniciarSesion()`, `+ formalizarAdopcion()`, `+ registrarIngreso()`, `+ procesarPagoQR()`, etc.).
  - **Asociaciones y Cardinalidades:** 28 relaciones de asociación con multiplicidades UML (`1` a `0..*`, `1` a `1..*`, `1` a `1`, `1` a `0..1`).


