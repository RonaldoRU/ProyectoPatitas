# Guía de Uso: Scripting para Enterprise Architect (JScript / JavaScript)
## Diagramas de Comunicación UML para los 30 Casos de Uso (P1 a P10)
### Sistema Web: Refugio "Los Angelitos de Edgar"

Este directorio contiene el script de automatización completo para **Sparx Enterprise Architect**:
- **Archivo principal:** [`generar_diagramas_comunicacion_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_diagramas_comunicacion_ea.js)

---

### 1. ¿Qué genera este script en Enterprise Architect?
Al ejecutarse en Enterprise Architect, el script crea automáticamente:
1. **10 Sub-Paquetes** organizados según la arquitectura de análisis:
   - `P1_Seguridad_Autenticacion`
   - `P2_Administracion_Usuarios_RBAC`
   - `P3_Auditoria_Bitacora`
   - `P4_Catalogo_Existencias`
   - `P5_Abastecimiento_Proveedores`
   - `P6_Automatizacion_Clinica`
   - `P7_Rescate_Historial_Clinico`
   - `P8_Gestion_Adopciones_Seguimiento`
   - `P9_Pasarela_Pagos_Donaciones`
   - `P10_Indicadores_Gerenciales`
2. **30 Diagramas de Comunicación UML (`Communication Diagram`)**, uno por cada caso de uso:
   - Objetos estereotipados PUDS: **Actores**, **Boundaries** (Vistas/Interfaces), **Controls** (Controladores de Laravel) y **Entities** (Modelos Eloquent y Base de Datos).
   - Enlaces de comunicación con **mensajes numerados secuencialmente** (`1: método()`, `2: consulta()`, etc.).
   - Disposición visual proporcional y coordinada en el lienzo.

---

### 2. Pasos para ejecutar en Enterprise Architect

1. Abra **Sparx Enterprise Architect** con su proyecto (`.eap`, `.eapx` o `.qea`).
2. Abra la ventana de scripting:
   - Menú: **Specialize** (o **Tools**) -> **Scripting**.
   - O use el atajo de teclado: `Ctrl + F11` (o `Alt + 7`).
3. En el panel de Scripting:
   - Cree un nuevo Script haciendo clic derecho en **Local Scripts** o en su grupo de scripts -> **New JScript**.
   - Asigne el nombre: `GeneradorDiagramasComunicacion`.
4. Abra el script creado con doble clic, borre el contenido por defecto y **pegue el código de [`generar_diagramas_comunicacion_ea.js`](file:///c:/xampp/htdocs/practica_s1_1-2026/proyecto/enterprise_architect_scripts/generar_diagramas_comunicacion_ea.js)**.
5. Guarde el script (`Ctrl + S`).
6. En el **Project Browser** (árbol del proyecto a la izquierda), **haga clic sobre el paquete raíz** donde desea que se creen los 10 paquetes y diagramas.
7. Vuelva a la ventana de Scripting, haga clic derecho sobre `GeneradorDiagramasComunicacion` y elija **Run Script**.
8. Observe la consola inferior (**System Output** -> pestaña **Script**). En unos segundos aparecerá el mensaje de confirmación con los 30 diagramas generados.

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
