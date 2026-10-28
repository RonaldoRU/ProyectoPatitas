 # Especificación Completa y Estructurada de Casos de Uso por Paquetes (P1 a P10)
## Sistema de Información Web para el Refugio "Los Angelitos de Edgar" (`db_hogar`)

---

## 1. INTRODUCCIÓN Y RESUMEN DE ARQUITECTURA DE PAQUETES

El presente documento consolida y especifica la totalidad de los **30 Casos de Uso (CU1 a CU30)** del sistema web para el albergue de animales **"Los Angelitos de Edgar"**, incorporando formalmente los módulos de seguridad, inventario, clínica, adopciones, indicadores gerenciales y el nuevo **Módulo de Pasarela de Pagos y Donaciones Monetarias (QR/Tarjeta/Transferencia)**.

La arquitectura del sistema se encuentra organizada en **10 Paquetes de Análisis y Diseño (P1 a P10)** según el Proceso Unificado de Desarrollo de Software (PUDS), garantizando un alto grado de cohesión y un bajo acoplamiento con persistencia relacional en **PostgreSQL (`db_hogar`)**.

---

## 2. MATRIZ GENERAL DE CASOS DE USO AGRUPADOS POR PAQUETES DE ANÁLISIS

| Código | Nombre del Caso de Uso | Paquete de Análisis | Actor Principal | Prioridad | Ciclo |
| :--- | :--- | :--- | :--- | :---: | :---: |
| **CU1** | Iniciar Sesión en la Plataforma Web | P1: Seguridad y Autenticación | Todos los Usuarios | **Alta** | Ciclo 1 |
| **CU2** | Cerrar Sesión y Revocar Token JWT | P1: Seguridad y Autenticación | Todos los Usuarios | **Media** | Ciclo 1 |
| **CU3** | Recuperar / Restablecer Contraseña Olvidada | P1: Seguridad y Autenticación | Todos los Usuarios | **Baja** | Ciclo 1 |
| **CU4** | Registrar Nuevo Usuario del Sistema | P2: Administración de Usuarios (RBAC) | Administrador | **Alta** | Ciclo 1 |
| **CU5** | Consultar Catálogo y Perfil de Usuarios | P2: Administración de Usuarios (RBAC) | Administrador | **Media** | Ciclo 1 |
| **CU6** | Modificar Datos de Cuenta de Usuario | P2: Administración de Usuarios (RBAC) | Administrador / Usuario | **Media** | Ciclo 1 |
| **CU7** | Cambiar Rol Operativo y Permisos (RBAC) | P2: Administración de Usuarios (RBAC) | Administrador | **Alta** | Ciclo 1 |
| **CU8** | Suspender / Inactivar Cuenta de Usuario | P2: Administración de Usuarios (RBAC) | Administrador | **Media** | Ciclo 1 |
| **CU9** | Registrar Acción Automática en Bitácora | P3: Auditoría y Bitácora | Sistema (Middleware) | **Alta** | Ciclo 1 |
| **CU10**| Consultar y Filtrar Bitácora de Auditoría | P3: Auditoría y Bitácora | Administrador | **Baja** | Ciclo 1 |
| **CU11**| Gestionar Catálogo de Artículos | P4: Catálogo y Existencias | Administrador | **Alta** | Ciclo 2 |
| **CU14**| Consultar Stock Actual y Alertas Mínimas | P4: Catálogo y Existencias | Todos los Usuarios | **Alta** | Ciclo 2 |
| **CU17**| Registrar Mermas y Ajustes de Inventario | P4: Catálogo y Existencias | Administrador | **Baja** | Ciclo 2 |
| **CU12**| Registrar Entrada de Insumos / Compras | P5: Abastecimiento y Proveedores | Admin / Recepcionista | **Alta** | Ciclo 2 |
| **CU13**| Registrar Salida y Consumo de Despensa | P5: Abastecimiento y Proveedores | Recepcionista / Voluntario | **Media** | Ciclo 2 |
| **CU18**| Gestionar Proveedores de Insumos | P5: Abastecimiento y Proveedores | Administrador | **Media** | Ciclo 2 |
| **CU15**| Descargo de Stock Automático por Consumo Clínico | P6: Automatización Clínica | Sistema / Veterinario | **Alta** | Ciclo 2 |
| **CU16**| Controlar y Alertar Vencimiento de Fármacos | P6: Automatización Clínica | Sistema / Veterinario | **Alta** | Ciclo 2 |
| **CU19**| Registrar Ficha de Rescate e Ingreso de Mascota | P7: Rescate e Historial Clínico | Recepcionista / Voluntario | **Alta** | Ciclo 3 |
| **CU20**| Consultar Expediente y Registrar Atención Médica | P7: Rescate e Historial Clínico | Médico Veterinario | **Alta** | Ciclo 3 |
| **CU21**| Registrar y Evaluar Postulante a Adopción | P8: Adopciones y Seguimiento | Recepcionista / Voluntario | **Media** | Ciclo 3 |
| **CU22**| Formalizar Adopción y Programar Visitas | P8: Adopciones y Seguimiento | Recepcionista / Voluntario | **Alta** | Ciclo 3 |
| **CU24**| Consultar y Registrar Visitas de Seguimiento | P8: Adopciones y Seguimiento | Recepcionista / Voluntario | **Media** | Ciclo 3 |
| **CU23**| Registrar Recepción de Donaciones de Insumos | P9: Pasarela de Pagos y Donaciones | Recepcionista / Voluntario | **Alta** | Ciclo 3 |
| **CU26**| Procesar Pago / Donación Monetaria (QR/Tarjeta/Transfer) | P9: Pasarela de Pagos y Donaciones | Donante / Recepcionista | **Alta** | Ciclo 3 |
| **CU27**| Verificar y Confirmar Transacción (Webhook) | P9: Pasarela de Pagos y Donaciones | Pasarela / Sistema | **Alta** | Ciclo 3 |
| **CU28**| Emitir y Descargar Comprobante / Recibo Digital | P9: Pasarela de Pagos y Donaciones | Donante / Recepcionista | **Media** | Ciclo 3 |
| **CU29**| Conciliar y Arquear Transacciones Financieras | P9: Pasarela de Pagos y Donaciones | Administrador | **Media** | Ciclo 3 |
| **CU30**| Gestionar Anulación o Reembolso de Transacción | P9: Pasarela de Pagos y Donaciones | Administrador | **Baja** | Ciclo 3 |
| **CU25**| Generar Reportes e Indicadores Gerenciales | P10: Indicadores Gerenciales | Administrador | **Baja** | Ciclo 3 |

---

## 3. ESPECIFICACIÓN DETALLADA DE CASOS DE USO POR PAQUETE

---

### PAQUETE P1: GESTIÓN DE SEGURIDAD Y AUTENTICACIÓN

#### CU1: Iniciar Sesión en la Plataforma Web
* **Código:** CU1
* **Nombre:** Iniciar Sesión en la Plataforma Web
* **Paquete:** P1: Gestión de Seguridad y Autenticación
* **Actor Principal:** Administrador, Médico Veterinario, Recepcionista / Voluntario
* **Actores Secundarios:** Sistema `db_hogar` (Servicio JWT)
* **Descripción:** Autentica las credenciales de acceso del usuario para generar un token JWT firmado que autoriza la navegación según su rol.
* **Precondiciones:** La cuenta de usuario debe existir en la tabla `usuario` y poseer `estado = 'Activo'`.
* **Postcondiciones:** Se emite el token JWT, se inicia la sesión y se registra la entrada en `bitacora`.
* **Flujo Principal:**
  1. El usuario ingresa su CI/Correo y contraseña en el formulario de login.
  2. El sistema valida las credenciales contra la base de datos comparando el hash `bcrypt`.
  3. El sistema verifica que la cuenta esté activa.
  4. El sistema genera el token JWT con el rol correspondiente.
  5. Se registra la acción en la bitácora y se redirige al dashboard del usuario.
* **Flujos Alternativos:**
  * **FA1 (Credenciales Incorrectas):** Si el hash no coincide, se notifica error y se incrementa el contador de intentos fallidos.
  * **FA2 (Cuenta Inactiva):** Si `estado = 'Inactivo'`, se muestra el mensaje: *"Cuenta suspendida. Contacte al Administrador"*.

#### CU2: Cerrar Sesión y Revocar Token JWT
* **Código:** CU2
* **Nombre:** Cerrar Sesión y Revocar Token JWT
* **Paquete:** P1: Gestión de Seguridad y Autenticación
* **Actor Principal:** Todos los Usuarios
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Permite cerrar la sesión activa invalidando el token JWT en el cliente y registrando el evento de salida.
* **Precondiciones:** Usuario autenticado con sesión activa.
* **Postcondiciones:** Token JWT invalidado en la lista negra (blacklist), almacenamiento local borrado y log en `bitacora`.
* **Flujo Principal:**
  1. El usuario hace clic en "Cerrar Sesión".
  2. El sistema añade el token activo a la lista de tokens revocados.
  3. Se destruye la sesión en el navegador.
  4. El sistema registra la salida en `bitacora` y redirige a la pantalla de login.

#### CU3: Recuperar / Restablecer Contraseña Olvidada
* **Código:** CU3
* **Nombre:** Recuperar / Restablecer Contraseña Olvidada
* **Paquete:** P1: Gestión de Seguridad y Autenticación
* **Actor Principal:** Todos los Usuarios
* **Actores Secundarios:** Servicio de Correo SMTP, Sistema `db_hogar`
* **Descripción:** Permite a un usuario restablecer su clave mediante un token temporal enviado a su correo institucional/personal.
* **Precondiciones:** El correo electrónico ingresado debe estar registrado y vinculado a una cuenta activa.
* **Postcondiciones:** Se actualiza el hash `bcrypt` en la tabla `usuario` y se invalida el token temporal.
* **Flujo Principal:**
  1. El usuario selecciona "¿Olvidó su contraseña?" e ingresa su correo/CI.
  2. El sistema valida la cuenta y envía un enlace con un token de un solo uso por correo.
  3. El usuario abre el enlace e ingresa la nueva contraseña.
  4. El sistema valida la complejidad de la clave, actualiza el hash en `usuario` y notifica el éxito.
* **Flujos Alternativos:**
  * **FA1 (Token Expirado):** Si el token superó los 15 minutos de validez, el sistema exige solicitar un nuevo enlace.

---

### PAQUETE P2: ADMINISTRACIÓN DE USUARIOS Y PERMISOS (RBAC)

#### CU4: Registrar Nuevo Usuario del Sistema
* **Código:** CU4
* **Nombre:** Registrar Nuevo Usuario del Sistema
* **Paquete:** P2: Administración de Usuarios y Permisos (RBAC)
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Da de alta a un nuevo funcionario o voluntario en la plataforma asignándole sus datos personales y rol.
* **Precondiciones:** Autenticado con rol `'Administrador'`.
* **Postcondiciones:** Nuevo registro en la tabla `usuario` y log de creación en `bitacora`.
* **Flujo Principal:**
  1. El Administrador accede a "Gestión de Usuarios" -> "Nuevo Usuario".
  2. Completa los campos: CI, Nombre Completo, Teléfono, Correo, Rol (`Administrador`, `Veterinario`, `Recepcionista`) y Contraseña inicial.
  3. El sistema valida la unicidad del CI y el formato del correo.
  4. El sistema aplica hash `bcrypt` a la contraseña e inserta el registro en `usuario`.
  5. Se muestra confirmación de registro.

#### CU5: Consultar Catálogo y Perfil de Usuarios
* **Código:** CU5
* **Nombre:** Consultar Catálogo y Perfil de Usuarios
* **Paquete:** P2: Administración de Usuarios y Permisos (RBAC)
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Permite buscar, filtrar y examinar los perfiles del personal registrado en el refugio.
* **Precondiciones:** Rol de Administrador autenticado.
* **Postcondiciones:** Despliegue en pantalla del listado o ficha detallada del usuario.
* **Flujo Principal:**
  1. El Administrador ingresa a la lista de usuarios.
  2. Aplica filtros por nombre, rol operativo o estado (`Activo`/`Inactivo`).
  3. El sistema consulta la entidad `usuario` y retorna los resultados paginados.

#### CU6: Modificar Datos de Cuenta de Usuario
* **Código:** CU6
* **Nombre:** Modificar Datos de Cuenta de Usuario
* **Paquete:** P2: Administración de Usuarios y Permisos (RBAC)
* **Actor Principal:** Administrador del Refugio / Usuario Titular
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Actualiza los datos de contacto del usuario o la contraseña personal.
* **Precondiciones:** Sesión activa del titular o del Administrador.
* **Postcondiciones:** Actualización del registro en la tabla `usuario` y log en `bitacora`.
* **Flujo Principal:**
  1. El usuario modifica su número telefónico o nombre desde su perfil.
  2. Guarda los cambios. El sistema valida los datos y ejecuta el `UPDATE` correspondiente.

#### CU7: Cambiar Rol Operativo y Permisos (RBAC)
* **Código:** CU7
* **Nombre:** Cambiar Rol Operativo y Permisos (RBAC)
* **Paquete:** P2: Administración de Usuarios y Permisos (RBAC)
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Cambia el nivel de autorización y rol de una cuenta para ajustar sus permisos de acceso a los módulos.
* **Precondiciones:** Usuario activo con rol de Administrador.
* **Postcondiciones:** Campo `rol` modificado en `usuario` y auditoría en `bitacora`.
* **Flujo Principal:**
  1. El Administrador selecciona un usuario del catálogo y hace clic en "Cambiar Rol".
  2. Selecciona el nuevo rol del menú desplegable (`Veterinario`, `Recepcionista`, `Administrador`).
  3. Confirma la reasignación. El sistema actualiza la base de datos e invalida las sesiones activas de esa cuenta para forzar la reautenticación con el nuevo rol.

#### CU8: Suspender / Inactivar Cuenta de Usuario
* **Código:** CU8
* **Nombre:** Suspender / Inactivar Cuenta de Usuario
* **Paquete:** P2: Administración de Usuarios y Permisos (RBAC)
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Inhabilita el acceso lógico de un voluntario o empleado saliente conservando la integridad referencial.
* **Precondiciones:** Rol de Administrador autenticado.
* **Postcondiciones:** `estado = 'Inactivo'` en la tabla `usuario`.
* **Flujo Principal:**
  1. El Administrador selecciona a la persona y presiona "Suspender Cuenta".
  2. Confirma la inactivación. El sistema ejecuta `UPDATE usuario SET estado = 'Inactivo' WHERE id_usuario = X`.

---

### PAQUETE P3: AUDITORÍA, TRAZABILIDAD Y BITÁCORA

#### CU9: Registrar Acción Automática en Bitácora (Trigger/Middleware)
* **Código:** CU9
* **Nombre:** Registrar Acción Automática en Bitácora
* **Paquete:** P3: Auditoría, Trazabilidad y Bitácora
* **Actor Principal:** Middleware / Triggers de PostgreSQL (Sistema)
* **Actores Secundarios:** Base de Datos `db_hogar`
* **Descripción:** Intercepta operaciones de inserción, actualización o borrado en la BD y las registra en `bitacora`.
* **Precondiciones:** Ejecución de cualquier transacción en las tablas monitoreadas.
* **Postcondiciones:** Registro insertado en `bitacora` (`id_usuario`, `fecha`, `hora`, `tabla`, `accion`, `ip`).
* **Flujo Principal:**
  1. Una transacción (ej. formalización de adopción) se ejecuta en la BD.
  2. El Trigger/Middleware captura los datos del usuario activo y la operación.
  3. Inserta automáticamente la fila de auditoría en la tabla `bitacora`.

#### CU10: Consultar y Filtrar Bitácora de Auditoría
* **Código:** CU10
* **Nombre:** Consultar y Filtrar Bitácora de Auditoría
* **Paquete:** P3: Auditoría, Trazabilidad y Bitácora
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Muestra la consola analítica de auditoría forense para inspeccionar las actividades del sistema.
* **Precondiciones:** Autenticado con rol de Administrador.
* **Postcondiciones:** Despliegue de registros de auditoría filtrados.
* **Flujo Principal:**
  1. El Administrador accede al panel de auditoría.
  2. Selecciona filtros: Rango de fechas, usuario específico o tipo de acción (`Crear`, `Modificar`, `Eliminar`).
  3. El sistema consulta `bitacora` y muestra los resultados ordenados cronológicamente.

---

### PAQUETE P4: CATÁLOGO Y CONTROL DE EXISTENCIAS DE INVENTARIO

#### CU11: Gestionar Catálogo de Artículos de Inventario
* **Código:** CU11
* **Nombre:** Gestionar Catálogo de Artículos de Inventario
* **Paquete:** P4: Catálogo y Control de Existencias
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Alta, edición y categorización de insumos (alimentos, medicamentos, productos de limpieza).
* **Precondiciones:** Rol de Administrador autenticado.
* **Postcondiciones:** Inserción o actualización en la tabla `articulo_inventario`.
* **Flujo Principal:**
  1. El Administrador ingresa al módulo de inventario.
  2. Ingresa los datos: Nombre del artículo, Categoría, Unidad de Medida, `stock_minimo_alerta` y Precio Referencial.
  3. Guarda el registro. El sistema valida e inserta en `articulo_inventario`.

#### CU14: Consultar Stock Actual y Alertas de Stock Mínimo
* **Código:** CU14
* **Nombre:** Consultar Stock Actual y Alertas de Stock Mínimo
* **Paquete:** P4: Catálogo y Control de Existencias
* **Actor Principal:** Todos los Usuarios
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Visualización en tiempo real del inventario disponible y resaltado de artículos en nivel crítico.
* **Precondiciones:** Usuario autenticado.
* **Postcondiciones:** Despliegue del listado de existencias con indicadores de estado de stock.
* **Flujo Principal:**
  1. El usuario abre la vista de existencias.
  2. El sistema consulta `articulo_inventario` y compara `stock_actual` contra `stock_minimo_alerta`.
  3. Si `stock_actual <= stock_minimo_alerta`, muestra el artículo resaltado en color rojo/amarillo de advertencia.

#### CU17: Registrar Mermas y Ajustes de Inventario
* **Código:** CU17
* **Nombre:** Registrar Mermas y Ajustes de Inventario
* **Paquete:** P4: Catálogo y Control de Existencias
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Registra pérdidas por deterioro, caducidad o rotura, descontando físicamente el stock de la BD.
* **Precondiciones:** Rol de Administrador autenticado.
* **Postcondiciones:** Reducción de `stock_actual` en `articulo_inventario` y registro del motivo de merma en la bitácora.
* **Flujo Principal:**
  1. El Administrador selecciona el artículo dañado/vencido.
  2. Ingresa la cantidad a descontar y el motivo detallado de la merma.
  3. Confirma el ajuste. El sistema descuenta las unidades e ingresa la justificación auditada.

---

### PAQUETE P5: ABASTECIMIENTO, SALIDAS Y PROVEEDORES

#### CU12: Registrar Entrada de Insumos / Compras
* **Código:** CU12
* **Nombre:** Registrar Entrada de Insumos / Compras
* **Paquete:** P5: Abastecimiento, Salidas y Proveedores
* **Actor Principal:** Administrador, Recepcionista
* **Actores Secundarios:** Proveedor, Sistema `db_hogar`
* **Descripción:** Documenta el ingreso de insumos adquiridos por compra, incrementando automáticamente el stock físico.
* **Precondiciones:** El proveedor debe estar registrado en la tabla `proveedor`.
* **Postcondiciones:** Registros en `compra` y `detalle_compra`, incremento de `stock_actual` en `articulo_inventario`.
* **Flujo Principal:**
  1. El usuario selecciona "Registrar Compra".
  2. Selecciona el proveedor y la fecha de factura/recibo.
  3. Agrega los artículos con su cantidad, costo unitario y fecha de vencimiento.
  4. Guarda la transacción. El sistema incrementa el stock de cada ítem recibido.

#### CU13: Registrar Salida y Consumo de Despensa
* **Código:** CU13
* **Nombre:** Registrar Salida y Consumo de Despensa
* **Paquete:** P5: Abastecimiento, Salidas y Proveedores
* **Actor Principal:** Recepcionista / Voluntario
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Registra el retiro de sacos de alimento o insumos de limpieza para consumo interno del albergue.
* **Precondiciones:** Existencia de stock suficiente en `articulo_inventario`.
* **Postcondiciones:** Registros en `salida_inventario` y `detalle_salida`, reducción del stock.
* **Flujo Principal:**
  1. El usuario selecciona "Nueva Salida de Despensa".
  2. Selecciona el destino (ej. "Caniles Sector A") y los artículos solicitados.
  3. Confirma el despacho. El sistema valida stock suficiente y descuenta las cantidades.

#### CU18: Gestionar Proveedores de Insumos
* **Código:** CU18
* **Nombre:** Gestionar Proveedores de Insumos
* **Paquete:** P5: Abastecimiento, Salidas y Proveedores
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Mantiene el catálogo comercial de distribuidores de alimento y laboratorios veterinarios.
* **Precondiciones:** Rol de Administrador.
* **Postcondiciones:** Creación/modificación de registros en la tabla `proveedor`.
* **Flujo Principal:**
  1. El Administrador ingresa al módulo de proveedores.
  2. Completa la ficha: NIT/RUC, Razón Social, Teléfono, Contacto Comercial y Dirección.
  3. Guarda la información en la tabla `proveedor`.

---

### PAQUETE P6: AUTOMATIZACIÓN CLÍNICA Y CONTROL DE VENCIMIENTOS

#### CU15: Descargo de Stock Automático por Consumo Clínico
* **Código:** CU15
* **Nombre:** Descargo de Stock Automático por Consumo Clínico
* **Paquete:** P6: Automatización Clínica y Control de Vencimientos
* **Actor Principal:** Sistema PostgreSQL (Trigger) / Médico Veterinario
* **Actores Secundarios:** Base de Datos `db_hogar`
* **Descripción:** Deduce automáticamente del inventario las dosis de vacunas y desparasitantes aplicados en la consulta médica.
* **Precondiciones:** Registro de una atención médica en `historial_clinico` que consuma fármacos.
* **Postcondiciones:** Descuento automático en `articulo_inventario.stock_actual` mediante Trigger.
* **Flujo Principal:**
  1. El Veterinario guarda la consulta médica indicando los medicamentos aplicados.
  2. El Trigger `tr_descontar_stock_salida` se ejecuta en la BD.
  3. Resta la cantidad consumida directamente del stock del medicamento correspondiente.

#### CU16: Controlar y Alertar Vencimiento de Fármacos
* **Código:** CU16
* **Nombre:** Controlar y Alertar Vencimiento de Fármacos
* **Paquete:** P6: Automatización Clínica y Control de Vencimientos
* **Actor Principal:** Sistema / Médico Veterinario
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Revisa las fechas de caducidad de los lotes e insumos médicos emitiendo alertas preventivas a 30 y 60 días.
* **Precondiciones:** Lotes registrados con `fecha_vencimiento`.
* **Postcondiciones:** Notificaciones visuales en el dashboard veterinario.
* **Flujo Principal:**
  1. El módulo de verificación consulta diariamente los insumos médicos.
  2. Compara `fecha_vencimiento` contra la fecha actual.
  3. Si faltan menos de 30 días para caducar, emite una alerta roja en la consola médica.

---

### PAQUETE P7: GESTIÓN DE RESCATE E HISTORIAL CLÍNICO VETERINARIO

#### CU19: Registrar Ficha de Rescate e Ingreso de Mascota
* **Código:** CU19
* **Nombre:** Registrar Ficha de Rescate e Ingreso de Mascota
* **Paquete:** P7: Gestión de Rescate e Historial Clínico
* **Actor Principal:** Recepcionista / Voluntario
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Digitaliza el ingreso de un animal rescatado (datos, especie, zona de rescate, fotografía) asignando estado `'En Recuperación'`.
* **Precondiciones:** Usuario autenticado en el sistema.
* **Postcondiciones:** Nuevo registro en la tabla `mascota` con `estado_actual = 'En Recuperación'`.
* **Flujo Principal:**
  1. El usuario selecciona "Registrar Nuevo Rescate".
  2. Completa el formulario: Nombre temporal, Especie, Sexo, Edad estimada, Lugar de rescate, Estado de salud inicial y foto.
  3. Guarda la ficha. El sistema inserta el registro en `mascota` y genera su expediente digital.

#### CU20: Consultar Expediente y Registrar Atención Médica e Historial Clínico
* **Código:** CU20
* **Nombre:** Consultar Expediente y Registrar Atención Médica
* **Paquete:** P7: Gestión de Rescate e Historial Clínico
* **Actor Principal:** Médico Veterinario
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Registra las consultas, vacunas, desparasitaciones o intervenciones quirúrgicas practicadas a la mascota.
* **Precondiciones:** Mascota registrada en la tabla `mascota`; rol de Veterinario.
* **Postcondiciones:** Inserción en `historial_clinico`, descargo de fármacos (CU15) y actualización del estado de la mascota.
* **Flujo Principal:**
  1. El Veterinario busca a la mascota por su código o nombre.
  2. Selecciona "Registrar Atención Médica".
  3. Ingresa el diagnóstico, tratamiento aplicado y medicamentos consumidos.
  4. Guarda la atención. El sistema actualiza el historial clínico y dispara la actualización del inventario.

---

### PAQUETE P8: GESTIÓN INTEGRAL DE ADOPCIONES Y CONTROL POST-ADOPCIÓN

#### CU21: Registrar y Evaluar Postulante a Adopción (Scoring de Idoneidad)
* **Código:** CU21
* **Nombre:** Registrar y Evaluar Postulante a Adopción
* **Paquete:** P8: Gestión Integral de Adopciones
* **Actor Principal:** Recepcionista / Voluntario
* **Actores Secundarios:** Interesado / Postulante, Sistema `db_hogar`
* **Descripción:** Registra a la persona interesada y evalúa su vivienda, experiencia e ingresos para calcular un puntaje de idoneidad.
* **Precondiciones:** Interesado no registrado previamente.
* **Postcondiciones:** Registro en `interesado_adopcion` con `puntaje_evaluacion` calculado.
* **Flujo Principal:**
  1. El usuario ingresa los datos del postulante (CI, Nombre, Teléfono, Dirección, Tipo de vivienda, Cerco perimetral, Horas a solas).
  2. El sistema aplica el algoritmo de evaluación de idoneidad.
  3. Almacena el postulante asignando un puntaje (ej. 85/100 -> Estado: `'Aprobado'`).

#### CU22: Formalizar Adopción de Mascota y Programación de Visitas
* **Código:** CU22
* **Nombre:** Formalizar Adopción de Mascota y Programación de Visitas
* **Paquete:** P8: Gestión Integral de Adopciones
* **Actor Principal:** Recepcionista / Voluntario
* **Actores Secundarios:** Adoptante, Sistema `db_hogar`
* **Descripción:** Asigna una mascota disponible a un adoptante aprobado, actualiza su estado a `'Adoptado'` y programa automáticamente 3 visitas de seguimiento (30, 90 y 180 días).
* **Precondiciones:** Mascota en `estado_actual = 'Disponible'` y postulante con puntaje de idoneidad aprobado.
* **Postcondiciones:** Inserción en `adopcion`, cambio de estado en `mascota` a `'Adoptado'` y 3 registros en `seguimiento_adopcion`.
* **Flujo Principal:**
  1. El usuario selecciona la mascota disponible y al adoptante aprobado.
  2. Confirma la fecha de entrega y formaliza la adopción.
  3. El sistema ejecuta la transacción:
     * Crea el registro en `adopcion`.
     * Ejecuta Trigger para cambiar `mascota.estado_actual = 'Adoptado'`.
     * Genera automáticamente las visitas agendadas a los 30, 90 y 180 días en `seguimiento_adopcion`.
  4. Emite el Acta de Adopción digital en PDF.

#### CU24: Consultar y Registrar Visitas de Seguimiento Post-Adopción
* **Código:** CU24
* **Nombre:** Consultar y Registrar Visitas de Seguimiento Post-Adopción
* **Paquete:** P8: Gestión Integral de Adopciones
* **Actor Principal:** Recepcionista / Voluntario
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Permite auditar y registrar las evidencias (fotos, estado de nutrición, trato) de las visitas de control post-adopción programadas.
* **Precondiciones:** Adopción formalizada existente en la tabla `adopcion`.
* **Postcondiciones:** Actualización del registro en `seguimiento_adopcion` a `estado_seguimiento = 'Completado'`.
* **Flujo Principal:**
  1. El voluntario revisa la agenda de visitas del mes.
  2. Selecciona la visita agendada y registra las observaciones de campo y fotos de la mascota.
  3. Guarda el informe de seguimiento. El sistema marca la visita como cumplida.

---

### PAQUETE P9: PASARELA DE PAGOS, DONACIONES MONETARIAS Y RECIBOS DIGITALES

#### CU23: Registrar Recepción de Donaciones Físicas y Monetarias
* **Código:** CU23
* **Nombre:** Registrar Recepción de Donaciones Físicas y Monetarias
* **Paquete:** P9: Pasarela de Pagos y Donaciones
* **Actor Principal:** Recepcionista / Voluntario
* **Actores Secundarios:** Donante, Sistema `db_hogar`
* **Descripción:** Documenta aportes de insumos materiales (alimentos, medicina) o donaciones monetarias en efectivo/presenciales.
* **Precondiciones:** Usuario autenticado en la plataforma.
* **Postcondiciones:** Registro en `donante` y `donacion`. Si es insumo, suma stock en `articulo_inventario`.
* **Flujo Principal:**
  1. El usuario busca o registra al donante por Cédula/NIT.
  2. Selecciona el tipo de donación (Insumos Físicos o Dinero en Efectivo).
  3. Si es insumo: ingresa cantidad y artículo; el sistema suma el stock.
  4. Si es dinero: ingresa monto y concepto.
  5. Confirma y emite el recibo institucional en PDF.

#### CU26 (CU-PG01): Procesar Pago / Donación Monetaria (QR / Tarjeta / Transferencia)
* **Código:** CU26
* **Nombre:** Procesar Pago / Donación Monetaria (Pasarela Digital)
* **Paquete:** P9: Pasarela de Pagos y Donaciones
* **Actor Principal:** Donante / Cliente, Recepcionista
* **Actores Secundarios:** API Pasarela de Pagos / Entidad Bancaria, Sistema `db_hogar`
* **Descripción:** Gestiona la intención de donación o pago digital generando un código QR dinámico o redireccionando al checkout seguro.
* **Precondiciones:** Integración activa con la API de la pasarela de pagos / bancaria.
* **Postcondiciones:** Registro de la transacción con estado `'Pendiente'` en la tabla `aporte_dinero`.
* **Flujo Principal:**
  1. El donante selecciona el monto a aportar y elige la opción de pago (QR Dinámico o Tarjeta).
  2. El sistema envía la solicitud a la API de la Pasarela de Pagos.
  3. La pasarela genera la imagen del código QR o el Token de checkout seguro.
  4. El sistema despliega el QR en pantalla para ser escaneado por el donante desde su app bancaria.
  5. El sistema registra el intento con `estado = 'Pendiente'` e identificador de transacción único.

#### CU27 (CU-PG02): Verificar y Confirmar Transacción Monetaria (Webhook / Callback)
* **Código:** CU27
* **Nombre:** Verificar y Confirmar Transacción Monetaria (Webhook)
* **Paquete:** P9: Pasarela de Pagos y Donaciones
* **Actor Principal:** Pasarela de Pagos / Backend (Servicio Automático)
* **Actores Secundarios:** Recepcionista, Sistema `db_hogar`
* **Descripción:** Procesa la notificación automática de confirmación bancaria (Webhook HTTP) para validar la acreditación de fondos.
* **Precondiciones:** Existencia de una transacción previa en estado `'Pendiente'`.
* **Postcondiciones:** Cambio de estado de la transacción a `'Confirmado'` en `aporte_dinero` y registro contable.
* **Flujo Principal:**
  1. La pasarela bancaria envía una notificación asíncrona (Webhook) al endpoint del backend al completarse la transferencia.
  2. El backend verifica la firma criptográfica y token de seguridad de la notificación.
  3. El sistema actualiza el registro en `aporte_dinero` a `estado = 'Confirmado'`.
  4. Dispara la generación del comprobante digital (CU28).
* **Flujos Alternativos:**
  * **FA1 (Verificación Manual por Cajero):** Si falla el webhook, el recepcionista ingresa el número de comprobante de la banca móvil y confirma manualmente la transacción.

#### CU28 (CU-PG03): Emitir y Descargar Comprobante / Recibo Digital
* **Código:** CU28
* **Nombre:** Emitir y Descargar Comprobante / Recibo Digital
* **Paquete:** P9: Pasarela de Pagos y Donaciones
* **Actor Principal:** Donante / Cliente, Recepcionista
* **Actores Secundarios:** Servicio de Generación PDF, Sistema `db_hogar`
* **Descripción:** Emite automáticamente el recibo o certificado digital de agradecimiento en formato PDF tras una donación/pago confirmado.
* **Precondiciones:** Transacción monetaria en estado `'Confirmado'`.
* **Postcondiciones:** Archivo PDF generado y listo para previsualizar, descargar o enviar por correo.
* **Flujo Principal:**
  1. Tras la confirmación del pago (CU27), el servicio toma los datos del donante, monto, concepto y código de referencia bancaria.
  2. Renderiza la plantilla del recibo digital en PDF incorporando un sello de agua y código QR de validación.
  3. Presenta el botón de descarga directa y envía una copia al correo electrónico del donante.

#### CU29 (CU-PG04): Conciliar y Arquear Transacciones Financieras
* **Código:** CU29
* **Nombre:** Conciliar y Arquear Transacciones Financieras
* **Paquete:** P9: Pasarela de Pagos y Donaciones
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Consolida la sumatoria de ingresos monetarios por canal (QR, tarjeta, efectivo) para el cuadre contable periódico.
* **Precondiciones:** Registros de aportes procesados en las tablas `donacion` y `aporte_dinero`.
* **Postcondiciones:** Reporte de conciliación financiera generado para cierre de caja.
* **Flujo Principal:**
  1. El Administrador selecciona el periodo a auditar (diario, semanal, mensual).
  2. El sistema realiza la consulta agregada discriminando entre pagos presenciales y pagos electrónicos liquidados por la pasarela.
  3. Presenta la matriz de conciliación permitiendo exportar el arqueo a formato PDF/Excel.

#### CU30 (CU-PG05): Gestionar Anulación o Reembolso de Transacción
* **Código:** CU30
* **Nombre:** Gestionar Anulación o Reembolso de Transacción
* **Paquete:** P9: Pasarela de Pagos y Donaciones
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** API Pasarela de Pagos, Bitácora
* **Descripción:** Revierte una transacción bancaria cobrada por error o duplicación, comunicando la anulación a la pasarela digital.
* **Precondiciones:** Transacción previa en estado `'Confirmado'`; rol de Administrador.
* **Postcondiciones:** `estado = 'Reembolsado'` en `aporte_dinero` y registro de la justificación en `bitacora`.
* **Flujo Principal:**
  1. El Administrador busca la transacción en el historial financiero y hace clic en "Solicitar Reembolso".
  2. Ingresa la justificación administrativa de la reversión.
  3. El sistema envía la instrucción de reembolso a la API de la pasarela bancaria.
  4. Al recibir la aceptación de la pasarela, actualiza el estado a `'Reembolsado'` y audita la operación en `bitacora`.

---

### PAQUETE P10: INDICADORES GERENCIALES Y REPORTES ESTADÍSTICOS

#### CU25: Generar Reportes Estadísticos e Indicadores Gerenciales
* **Código:** CU25
* **Nombre:** Generar Reportes Estadísticos e Indicadores Gerenciales
* **Paquete:** P10: Indicadores Gerenciales y Reportes Estadísticos
* **Actor Principal:** Administrador del Refugio
* **Actores Secundarios:** Sistema `db_hogar`
* **Descripción:** Consolida métricas y gráficos gerenciales sobre tasa de adopciones, tasa de rescates, rotación de inventarios e ingresos por donaciones.
* **Precondiciones:** Rol de Administrador autenticado.
* **Postcondiciones:** Cuadro de mando (Dashboard) e informes consolidados exportables.
* **Flujo Principal:**
  1. El Administrador ingresa al módulo de reportes gerenciales.
  2. Selecciona el tipo de indicador (ej. "Evolución Mensual de Adopciones", "Top Medicamentos Consumidos", "Ingresos Monetarios por Pasarela").
  3. El sistema procesa las consultas analíticas sobre `db_hogar` y despliega gráficos dinámicos y tablas de resumen.

---

## 4. MATRIZ DE TRAZABILIDAD Y COBERTURA DE REQUISITOS POR PAQUETES (P1 A P10)

| Paquete de Análisis | Casos de Uso Integrados | Tablas Físicas de la BD (`db_hogar`) Impactadas |
| :--- | :--- | :--- |
| **P1: Seguridad y Autenticación** | `CU1`, `CU2`, `CU3` | `usuario` |
| **P2: Administración de Usuarios (RBAC)** | `CU4`, `CU5`, `CU6`, `CU7`, `CU8` | `usuario` |
| **P3: Auditoría y Bitácora** | `CU9`, `CU10` | `bitacora`, `usuario` |
| **P4: Catálogo y Existencias** | `CU11`, `CU14`, `CU17` | `articulo_inventario` |
| **P5: Abastecimiento y Proveedores** | `CU12`, `CU13`, `CU18` | `compra`, `detalle_compra`, `salida_inventario`, `detalle_salida`, `proveedor` |
| **P6: Automatización Clínica** | `CU15`, `CU16` | `articulo_inventario`, `historial_clinico` |
| **P7: Rescate e Historial Clínico** | `CU19`, `CU20` | `mascota`, `historial_clinico` |
| **P8: Adopciones y Seguimiento** | `CU21`, `CU22`, `CU24` | `interesado_adopcion`, `adopcion`, `seguimiento_adopcion`, `mascota` |
| **P9: Pasarela de Pagos y Donaciones** | `CU23`, `CU26`, `CU27`, `CU28`, `CU29`, `CU30` | `donante`, `donacion`, `aporte_dinero`, `articulo_inventario` |
| **P10: Indicadores Gerenciales** | `CU25` | Vista analítica consolidada (`mascota`, `adopcion`, `donacion`, `historial_clinico`) |
