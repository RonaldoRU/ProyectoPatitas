--
-- PostgreSQL database dump
--


-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcions DROP CONSTRAINT IF EXISTS seguimiento_adopcions_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcions DROP CONSTRAINT IF EXISTS seguimiento_adopcions_id_adopcion_foreign;
ALTER TABLE IF EXISTS ONLY public.salida_inventarios DROP CONSTRAINT IF EXISTS salida_inventarios_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.salida_inventarios DROP CONSTRAINT IF EXISTS salida_inventarios_historial_clinico_foreign;
ALTER TABLE IF EXISTS ONLY public.prescripciones_dosificacion DROP CONSTRAINT IF EXISTS prescripciones_dosificacion_veterinario_id_foreign;
ALTER TABLE IF EXISTS ONLY public.prescripciones_dosificacion DROP CONSTRAINT IF EXISTS prescripciones_dosificacion_mascota_id_foreign;
ALTER TABLE IF EXISTS ONLY public.prescripciones_dosificacion DROP CONSTRAINT IF EXISTS prescripciones_dosificacion_historial_clinico_id_foreign;
ALTER TABLE IF EXISTS ONLY public.prescripciones_dosificacion DROP CONSTRAINT IF EXISTS prescripciones_dosificacion_articulo_id_foreign;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_detalle_donacion_foreign;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_detalle_compra_foreign;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.historial_clinicos DROP CONSTRAINT IF EXISTS historial_clinicos_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.historial_clinicos DROP CONSTRAINT IF EXISTS historial_clinicos_id_mascota_foreign;
ALTER TABLE IF EXISTS ONLY public.sesion_jwt DROP CONSTRAINT IF EXISTS fk_sesion_usuario;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcion DROP CONSTRAINT IF EXISTS fk_seguimiento_usuario;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcion DROP CONSTRAINT IF EXISTS fk_seguimiento_adopcion;
ALTER TABLE IF EXISTS ONLY public.salida_inventario DROP CONSTRAINT IF EXISTS fk_salida_usuario;
ALTER TABLE IF EXISTS ONLY public.historial_clinico DROP CONSTRAINT IF EXISTS fk_historial_usuario;
ALTER TABLE IF EXISTS ONLY public.historial_clinico DROP CONSTRAINT IF EXISTS fk_historial_mascota;
ALTER TABLE IF EXISTS ONLY public.expediente_digital DROP CONSTRAINT IF EXISTS fk_expediente_mascota;
ALTER TABLE IF EXISTS ONLY public.evaluacion_idoneidad DROP CONSTRAINT IF EXISTS fk_evaluacion_interesado;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumo DROP CONSTRAINT IF EXISTS fk_donacioninsumo_donacion;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumo DROP CONSTRAINT IF EXISTS fk_donacioninsumo_articulo;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS fk_donacion_usuario;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS fk_donacion_tipo;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS fk_donacion_donante;
ALTER TABLE IF EXISTS ONLY public.detalle_salida DROP CONSTRAINT IF EXISTS fk_detallesalida_cabecera;
ALTER TABLE IF EXISTS ONLY public.detalle_salida DROP CONSTRAINT IF EXISTS fk_detallesalida_articulo;
ALTER TABLE IF EXISTS ONLY public.detalle_compra DROP CONSTRAINT IF EXISTS fk_detallecompra_insumo;
ALTER TABLE IF EXISTS ONLY public.detalle_compra DROP CONSTRAINT IF EXISTS fk_detallecompra_cabecera;
ALTER TABLE IF EXISTS ONLY public.compra DROP CONSTRAINT IF EXISTS fk_compra_usuario;
ALTER TABLE IF EXISTS ONLY public.compra DROP CONSTRAINT IF EXISTS fk_compra_proveedor;
ALTER TABLE IF EXISTS ONLY public.bitacora DROP CONSTRAINT IF EXISTS fk_bitacora_usuario;
ALTER TABLE IF EXISTS ONLY public.aporte_dinero DROP CONSTRAINT IF EXISTS fk_aporte_donacion;
ALTER TABLE IF EXISTS ONLY public.alerta_inventario DROP CONSTRAINT IF EXISTS fk_alerta_articulo;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS fk_adopcion_mascota;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS fk_adopcion_interesado;
ALTER TABLE IF EXISTS ONLY public.facturas_legales DROP CONSTRAINT IF EXISTS facturas_legales_usuario_emisor_id_foreign;
ALTER TABLE IF EXISTS ONLY public.facturas_legales DROP CONSTRAINT IF EXISTS facturas_legales_usuario_anulador_id_foreign;
ALTER TABLE IF EXISTS ONLY public.facturas_legales DROP CONSTRAINT IF EXISTS facturas_legales_dosificacion_id_foreign;
ALTER TABLE IF EXISTS ONLY public.facturas_compras DROP CONSTRAINT IF EXISTS facturas_compras_registrado_por_foreign;
ALTER TABLE IF EXISTS ONLY public.facturas_compras DROP CONSTRAINT IF EXISTS facturas_compras_proveedor_id_foreign;
ALTER TABLE IF EXISTS ONLY public.dosificaciones_fiscales DROP CONSTRAINT IF EXISTS dosificaciones_fiscales_created_by_foreign;
ALTER TABLE IF EXISTS ONLY public.donacions DROP CONSTRAINT IF EXISTS donacions_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.donacions DROP CONSTRAINT IF EXISTS donacions_id_donante_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salidas DROP CONSTRAINT IF EXISTS detalle_salidas_id_salida_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salidas DROP CONSTRAINT IF EXISTS detalle_salidas_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_id_inventario_lote_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_id_detalle_salida_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_facturas_legales DROP CONSTRAINT IF EXISTS detalle_facturas_legales_factura_id_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumos DROP CONSTRAINT IF EXISTS detalle_donacion_insumos_id_donacion_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumos DROP CONSTRAINT IF EXISTS detalle_donacion_insumos_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_compras DROP CONSTRAINT IF EXISTS detalle_compras_id_compra_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_compras DROP CONSTRAINT IF EXISTS detalle_compras_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.cronograma_tratamientos DROP CONSTRAINT IF EXISTS cronograma_tratamientos_prescripcion_id_foreign;
ALTER TABLE IF EXISTS ONLY public.cronograma_tratamientos DROP CONSTRAINT IF EXISTS cronograma_tratamientos_lote_inventario_id_foreign;
ALTER TABLE IF EXISTS ONLY public.cronograma_tratamientos DROP CONSTRAINT IF EXISTS cronograma_tratamientos_administrado_por_foreign;
ALTER TABLE IF EXISTS ONLY public.compras DROP CONSTRAINT IF EXISTS compras_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.compras DROP CONSTRAINT IF EXISTS compras_id_proveedor_foreign;
ALTER TABLE IF EXISTS ONLY public.cierres_periodos_reportes DROP CONSTRAINT IF EXISTS cierres_periodos_reportes_generado_por_foreign;
ALTER TABLE IF EXISTS ONLY public.bitacoras DROP CONSTRAINT IF EXISTS bitacoras_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.auditoria_forense DROP CONSTRAINT IF EXISTS auditoria_forense_usuario_id_foreign;
ALTER TABLE IF EXISTS ONLY public.aporte_dineros DROP CONSTRAINT IF EXISTS aporte_dineros_id_donacion_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventarios DROP CONSTRAINT IF EXISTS ajuste_inventarios_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventarios DROP CONSTRAINT IF EXISTS ajuste_inventarios_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_id_inventario_lote_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_id_ajuste_inventario_foreign;
ALTER TABLE IF EXISTS ONLY public.adopcions DROP CONSTRAINT IF EXISTS adopcions_id_mascota_foreign;
ALTER TABLE IF EXISTS ONLY public.adopcions DROP CONSTRAINT IF EXISTS adopcions_id_interesado_foreign;
DROP TRIGGER IF EXISTS trg_sync_medicamentos ON public.medicamentos;
DROP TRIGGER IF EXISTS tr_verificar_stock_minimo_alerta ON public.articulo_inventario;
DROP TRIGGER IF EXISTS tr_sync_users ON public.users;
DROP TRIGGER IF EXISTS tr_sync_seguimientos ON public.seguimiento_adopcions;
DROP TRIGGER IF EXISTS tr_sync_proveedors ON public.proveedors;
DROP TRIGGER IF EXISTS tr_sync_mascotas ON public.mascotas;
DROP TRIGGER IF EXISTS tr_sync_interesados ON public.interesado_adopcions;
DROP TRIGGER IF EXISTS tr_sync_donantes ON public.donantes;
DROP TRIGGER IF EXISTS tr_sync_donacions ON public.donacions;
DROP TRIGGER IF EXISTS tr_sync_articulos ON public.articulo_inventarios;
DROP TRIGGER IF EXISTS tr_sync_adopcions ON public.adopcions;
DROP TRIGGER IF EXISTS tr_registrar_bitacora_adopcion ON public.adopcion;
DROP TRIGGER IF EXISTS tr_descontar_stock_salida ON public.detalle_salida;
DROP TRIGGER IF EXISTS tr_actualizar_stock_compra ON public.detalle_compra;
DROP TRIGGER IF EXISTS tr_actualizar_estado_por_historial ON public.historial_clinico;
DROP TRIGGER IF EXISTS tr_actualizar_estado_mascota_adopcion ON public.adopcion;
DROP INDEX IF EXISTS public.sessions_user_id_index;
DROP INDEX IF EXISTS public.sessions_last_activity_index;
DROP INDEX IF EXISTS public.proveedors_identificacion_index;
DROP INDEX IF EXISTS public.proveedors_active_name_index;
DROP INDEX IF EXISTS public.personal_access_tokens_tokenable_type_tokenable_id_index;
DROP INDEX IF EXISTS public.personal_access_tokens_expires_at_index;
DROP INDEX IF EXISTS public.medicamentos_id_medicamento_index;
DROP INDEX IF EXISTS public.medicamentos_es_inyectable_index;
DROP INDEX IF EXISTS public.jobs_queue_index;
DROP INDEX IF EXISTS public.inventario_lotes_fefo_index;
DROP INDEX IF EXISTS public.interesado_adopcions_estado_index;
DROP INDEX IF EXISTS public.idx_usuario_rol;
DROP INDEX IF EXISTS public.idx_usuario_ci;
DROP INDEX IF EXISTS public.idx_seguimiento_adopcion;
DROP INDEX IF EXISTS public.idx_mascota_estado;
DROP INDEX IF EXISTS public.idx_mascota_especie;
DROP INDEX IF EXISTS public.idx_historial_mascota;
DROP INDEX IF EXISTS public.idx_donacion_donante;
DROP INDEX IF EXISTS public.idx_bitacora_usuario;
DROP INDEX IF EXISTS public.idx_bitacora_fecha;
DROP INDEX IF EXISTS public.idx_articulo_categoria;
DROP INDEX IF EXISTS public.idx_adopcion_mascota;
DROP INDEX IF EXISTS public.idx_adopcion_interesado;
DROP INDEX IF EXISTS public.failed_jobs_connection_queue_failed_at_index;
DROP INDEX IF EXISTS public.cache_locks_expiration_index;
DROP INDEX IF EXISTS public.cache_expiration_index;
DROP INDEX IF EXISTS public.bitacoras_modulo_resultado_index;
DROP INDEX IF EXISTS public.bitacoras_created_id_index;
DROP INDEX IF EXISTS public.auditoria_forense_severidad_fecha_evento_index;
DROP INDEX IF EXISTS public.auditoria_forense_modulo_fecha_evento_index;
DROP INDEX IF EXISTS public.ajuste_inventarios_created_id_index;
DROP INDEX IF EXISTS public.ajuste_inventarios_articulo_created_index;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_ci_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_unique;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_ci_unique;
ALTER TABLE IF EXISTS ONLY public.tipo_aportes DROP CONSTRAINT IF EXISTS tipo_aportes_pkey;
ALTER TABLE IF EXISTS ONLY public.tipo_aporte DROP CONSTRAINT IF EXISTS tipo_aporte_pkey;
ALTER TABLE IF EXISTS ONLY public.tipo_aporte DROP CONSTRAINT IF EXISTS tipo_aporte_nombre_key;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.sesion_jwt DROP CONSTRAINT IF EXISTS sesion_jwt_pkey;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcions DROP CONSTRAINT IF EXISTS seguimiento_adopcions_pkey;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcion DROP CONSTRAINT IF EXISTS seguimiento_adopcion_pkey;
ALTER TABLE IF EXISTS ONLY public.salida_inventarios DROP CONSTRAINT IF EXISTS salida_inventarios_pkey;
ALTER TABLE IF EXISTS ONLY public.salida_inventarios DROP CONSTRAINT IF EXISTS salida_inventarios_historial_clinico_unique;
ALTER TABLE IF EXISTS ONLY public.salida_inventario DROP CONSTRAINT IF EXISTS salida_inventario_pkey;
ALTER TABLE IF EXISTS ONLY public.rol_permiso DROP CONSTRAINT IF EXISTS rol_permiso_pkey;
ALTER TABLE IF EXISTS ONLY public.rol_permiso DROP CONSTRAINT IF EXISTS rol_permiso_nombre_rol_key;
ALTER TABLE IF EXISTS ONLY public.proveedors DROP CONSTRAINT IF EXISTS proveedors_pkey;
ALTER TABLE IF EXISTS ONLY public.proveedor DROP CONSTRAINT IF EXISTS proveedor_pkey;
ALTER TABLE IF EXISTS ONLY public.proveedor DROP CONSTRAINT IF EXISTS proveedor_nombre_empresa_key;
ALTER TABLE IF EXISTS ONLY public.prescripciones_dosificacion DROP CONSTRAINT IF EXISTS prescripciones_dosificacion_pkey;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.medicamentos DROP CONSTRAINT IF EXISTS medicamentos_pkey;
ALTER TABLE IF EXISTS ONLY public.medicamento DROP CONSTRAINT IF EXISTS medicamento_pkey;
ALTER TABLE IF EXISTS ONLY public.mascotas DROP CONSTRAINT IF EXISTS mascotas_pkey;
ALTER TABLE IF EXISTS ONLY public.mascota DROP CONSTRAINT IF EXISTS mascota_pkey;
ALTER TABLE IF EXISTS ONLY public.jobs DROP CONSTRAINT IF EXISTS jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.job_batches DROP CONSTRAINT IF EXISTS job_batches_pkey;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_pkey;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_detalle_donacion_unique;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_detalle_compra_unique;
ALTER TABLE IF EXISTS ONLY public.interesado_adopcions DROP CONSTRAINT IF EXISTS interesado_adopcions_pkey;
ALTER TABLE IF EXISTS ONLY public.interesado_adopcions DROP CONSTRAINT IF EXISTS interesado_adopcions_ci_unique;
ALTER TABLE IF EXISTS ONLY public.interesado_adopcion DROP CONSTRAINT IF EXISTS interesado_adopcion_pkey;
ALTER TABLE IF EXISTS ONLY public.interesado_adopcion DROP CONSTRAINT IF EXISTS interesado_adopcion_ci_key;
ALTER TABLE IF EXISTS ONLY public.historial_clinicos DROP CONSTRAINT IF EXISTS historial_clinicos_pkey;
ALTER TABLE IF EXISTS ONLY public.historial_clinico DROP CONSTRAINT IF EXISTS historial_clinico_pkey;
ALTER TABLE IF EXISTS ONLY public.failed_jobs DROP CONSTRAINT IF EXISTS failed_jobs_uuid_unique;
ALTER TABLE IF EXISTS ONLY public.failed_jobs DROP CONSTRAINT IF EXISTS failed_jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.facturas_legales DROP CONSTRAINT IF EXISTS facturas_legales_pkey;
ALTER TABLE IF EXISTS ONLY public.facturas_legales DROP CONSTRAINT IF EXISTS facturas_legales_numero_autorizacion_numero_factura_unique;
ALTER TABLE IF EXISTS ONLY public.facturas_compras DROP CONSTRAINT IF EXISTS facturas_compras_pkey;
ALTER TABLE IF EXISTS ONLY public.expediente_digital DROP CONSTRAINT IF EXISTS expediente_digital_pkey;
ALTER TABLE IF EXISTS ONLY public.expediente_digital DROP CONSTRAINT IF EXISTS expediente_digital_id_mascota_key;
ALTER TABLE IF EXISTS ONLY public.evaluacion_idoneidad DROP CONSTRAINT IF EXISTS evaluacion_idoneidad_pkey;
ALTER TABLE IF EXISTS ONLY public.evaluacion_idoneidad DROP CONSTRAINT IF EXISTS evaluacion_idoneidad_id_interesado_key;
ALTER TABLE IF EXISTS ONLY public.dosificaciones_fiscales DROP CONSTRAINT IF EXISTS dosificaciones_fiscales_pkey;
ALTER TABLE IF EXISTS ONLY public.dosificaciones_fiscales DROP CONSTRAINT IF EXISTS dosificaciones_fiscales_numero_autorizacion_unique;
ALTER TABLE IF EXISTS ONLY public.donantes DROP CONSTRAINT IF EXISTS donantes_pkey;
ALTER TABLE IF EXISTS ONLY public.donante DROP CONSTRAINT IF EXISTS donante_pkey;
ALTER TABLE IF EXISTS ONLY public.donacions DROP CONSTRAINT IF EXISTS donacions_pkey;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS donacion_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_salidas DROP CONSTRAINT IF EXISTS detalle_salidas_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_salida DROP CONSTRAINT IF EXISTS detalle_salida_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_unique;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_facturas_legales DROP CONSTRAINT IF EXISTS detalle_facturas_legales_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumos DROP CONSTRAINT IF EXISTS detalle_donacion_insumos_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumo DROP CONSTRAINT IF EXISTS detalle_donacion_insumo_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_compras DROP CONSTRAINT IF EXISTS detalle_compras_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_compra DROP CONSTRAINT IF EXISTS detalle_compra_pkey;
ALTER TABLE IF EXISTS ONLY public.cronograma_tratamientos DROP CONSTRAINT IF EXISTS cronograma_tratamientos_pkey;
ALTER TABLE IF EXISTS ONLY public.compras DROP CONSTRAINT IF EXISTS compras_pkey;
ALTER TABLE IF EXISTS ONLY public.compra DROP CONSTRAINT IF EXISTS compra_pkey;
ALTER TABLE IF EXISTS ONLY public.cierres_periodos_reportes DROP CONSTRAINT IF EXISTS cierres_periodos_reportes_pkey;
ALTER TABLE IF EXISTS ONLY public.cache DROP CONSTRAINT IF EXISTS cache_pkey;
ALTER TABLE IF EXISTS ONLY public.cache_locks DROP CONSTRAINT IF EXISTS cache_locks_pkey;
ALTER TABLE IF EXISTS ONLY public.bitacoras DROP CONSTRAINT IF EXISTS bitacoras_pkey;
ALTER TABLE IF EXISTS ONLY public.bitacora DROP CONSTRAINT IF EXISTS bitacora_pkey;
ALTER TABLE IF EXISTS ONLY public.auditoria_forense DROP CONSTRAINT IF EXISTS auditoria_forense_pkey;
ALTER TABLE IF EXISTS ONLY public.articulo_inventarios DROP CONSTRAINT IF EXISTS articulo_inventarios_pkey;
ALTER TABLE IF EXISTS ONLY public.articulo_inventarios DROP CONSTRAINT IF EXISTS articulo_inventarios_nombre_unique;
ALTER TABLE IF EXISTS ONLY public.articulo_inventario DROP CONSTRAINT IF EXISTS articulo_inventario_pkey;
ALTER TABLE IF EXISTS ONLY public.aporte_dineros DROP CONSTRAINT IF EXISTS aporte_dineros_pkey;
ALTER TABLE IF EXISTS ONLY public.aporte_dinero DROP CONSTRAINT IF EXISTS aporte_dinero_pkey;
ALTER TABLE IF EXISTS ONLY public.aporte_dinero DROP CONSTRAINT IF EXISTS aporte_dinero_id_donacion_key;
ALTER TABLE IF EXISTS ONLY public.alerta_inventario DROP CONSTRAINT IF EXISTS alerta_inventario_pkey;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventarios DROP CONSTRAINT IF EXISTS ajuste_inventarios_pkey;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_unique;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_pkey;
ALTER TABLE IF EXISTS ONLY public.adopcions DROP CONSTRAINT IF EXISTS adopcions_pkey;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS adopcion_pkey;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS adopcion_id_mascota_key;
ALTER TABLE IF EXISTS public.usuario ALTER COLUMN id_usuario DROP DEFAULT;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_aportes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_aporte ALTER COLUMN id_tipoaporte DROP DEFAULT;
ALTER TABLE IF EXISTS public.seguimiento_adopcions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seguimiento_adopcion ALTER COLUMN id_seguimiento DROP DEFAULT;
ALTER TABLE IF EXISTS public.salida_inventarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.salida_inventario ALTER COLUMN id_salida DROP DEFAULT;
ALTER TABLE IF EXISTS public.rol_permiso ALTER COLUMN id_rol DROP DEFAULT;
ALTER TABLE IF EXISTS public.proveedors ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.proveedor ALTER COLUMN id_proveedor DROP DEFAULT;
ALTER TABLE IF EXISTS public.prescripciones_dosificacion ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.migrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.medicamentos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.medicamento ALTER COLUMN id_medicamento DROP DEFAULT;
ALTER TABLE IF EXISTS public.mascotas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.mascota ALTER COLUMN id_mascota DROP DEFAULT;
ALTER TABLE IF EXISTS public.jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventario_lotes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.interesado_adopcions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.interesado_adopcion ALTER COLUMN id_interesado DROP DEFAULT;
ALTER TABLE IF EXISTS public.historial_clinicos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.historial_clinico ALTER COLUMN id_historial DROP DEFAULT;
ALTER TABLE IF EXISTS public.failed_jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.facturas_legales ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.facturas_compras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.evaluacion_idoneidad ALTER COLUMN id_evaluacion DROP DEFAULT;
ALTER TABLE IF EXISTS public.dosificaciones_fiscales ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.donantes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.donante ALTER COLUMN id_donante DROP DEFAULT;
ALTER TABLE IF EXISTS public.donacions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.donacion ALTER COLUMN id_donacion DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_salidas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_salida_lotes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_salida ALTER COLUMN id_detallesalida DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_facturas_legales ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_donacion_insumos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_donacion_insumo ALTER COLUMN id_detalle DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_compras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_compra ALTER COLUMN id_detallecompra DROP DEFAULT;
ALTER TABLE IF EXISTS public.cronograma_tratamientos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.compras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.compra ALTER COLUMN id_compra DROP DEFAULT;
ALTER TABLE IF EXISTS public.cierres_periodos_reportes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bitacoras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bitacora ALTER COLUMN id_accion DROP DEFAULT;
ALTER TABLE IF EXISTS public.auditoria_forense ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.articulo_inventarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.articulo_inventario ALTER COLUMN id_articulo DROP DEFAULT;
ALTER TABLE IF EXISTS public.aporte_dineros ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.aporte_dinero ALTER COLUMN id_aporte DROP DEFAULT;
ALTER TABLE IF EXISTS public.alerta_inventario ALTER COLUMN id_alerta DROP DEFAULT;
ALTER TABLE IF EXISTS public.ajuste_inventarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.ajuste_inventario_lotes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.adopcions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.adopcion ALTER COLUMN id_adopcion DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.usuario_id_usuario_seq;
DROP TABLE IF EXISTS public.usuario;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.tipo_aportes_id_seq;
DROP TABLE IF EXISTS public.tipo_aportes;
DROP SEQUENCE IF EXISTS public.tipo_aporte_id_tipoaporte_seq;
DROP TABLE IF EXISTS public.tipo_aporte;
DROP TABLE IF EXISTS public.sessions;
DROP TABLE IF EXISTS public.sesion_jwt;
DROP SEQUENCE IF EXISTS public.seguimiento_adopcions_id_seq;
DROP TABLE IF EXISTS public.seguimiento_adopcions;
DROP SEQUENCE IF EXISTS public.seguimiento_adopcion_id_seguimiento_seq;
DROP TABLE IF EXISTS public.seguimiento_adopcion;
DROP SEQUENCE IF EXISTS public.salida_inventarios_id_seq;
DROP TABLE IF EXISTS public.salida_inventarios;
DROP SEQUENCE IF EXISTS public.salida_inventario_id_salida_seq;
DROP TABLE IF EXISTS public.salida_inventario;
DROP SEQUENCE IF EXISTS public.rol_permiso_id_rol_seq;
DROP TABLE IF EXISTS public.rol_permiso;
DROP SEQUENCE IF EXISTS public.proveedors_id_seq;
DROP TABLE IF EXISTS public.proveedors;
DROP SEQUENCE IF EXISTS public.proveedor_id_proveedor_seq;
DROP TABLE IF EXISTS public.proveedor;
DROP SEQUENCE IF EXISTS public.prescripciones_dosificacion_id_seq;
DROP TABLE IF EXISTS public.prescripciones_dosificacion;
DROP SEQUENCE IF EXISTS public.personal_access_tokens_id_seq;
DROP TABLE IF EXISTS public.personal_access_tokens;
DROP TABLE IF EXISTS public.password_reset_tokens;
DROP SEQUENCE IF EXISTS public.migrations_id_seq;
DROP TABLE IF EXISTS public.migrations;
DROP SEQUENCE IF EXISTS public.medicamentos_id_seq;
DROP TABLE IF EXISTS public.medicamentos;
DROP SEQUENCE IF EXISTS public.medicamento_id_medicamento_seq;
DROP TABLE IF EXISTS public.medicamento;
DROP SEQUENCE IF EXISTS public.mascotas_id_seq;
DROP TABLE IF EXISTS public.mascotas;
DROP SEQUENCE IF EXISTS public.mascota_id_mascota_seq;
DROP TABLE IF EXISTS public.mascota;
DROP SEQUENCE IF EXISTS public.jobs_id_seq;
DROP TABLE IF EXISTS public.jobs;
DROP TABLE IF EXISTS public.job_batches;
DROP SEQUENCE IF EXISTS public.inventario_lotes_id_seq;
DROP TABLE IF EXISTS public.inventario_lotes;
DROP SEQUENCE IF EXISTS public.interesado_adopcions_id_seq;
DROP TABLE IF EXISTS public.interesado_adopcions;
DROP SEQUENCE IF EXISTS public.interesado_adopcion_id_interesado_seq;
DROP TABLE IF EXISTS public.interesado_adopcion;
DROP SEQUENCE IF EXISTS public.historial_clinicos_id_seq;
DROP TABLE IF EXISTS public.historial_clinicos;
DROP SEQUENCE IF EXISTS public.historial_clinico_id_historial_seq;
DROP TABLE IF EXISTS public.historial_clinico;
DROP SEQUENCE IF EXISTS public.failed_jobs_id_seq;
DROP TABLE IF EXISTS public.failed_jobs;
DROP SEQUENCE IF EXISTS public.facturas_legales_id_seq;
DROP TABLE IF EXISTS public.facturas_legales;
DROP SEQUENCE IF EXISTS public.facturas_compras_id_seq;
DROP TABLE IF EXISTS public.facturas_compras;
DROP TABLE IF EXISTS public.expediente_digital;
DROP SEQUENCE IF EXISTS public.evaluacion_idoneidad_id_evaluacion_seq;
DROP TABLE IF EXISTS public.evaluacion_idoneidad;
DROP SEQUENCE IF EXISTS public.dosificaciones_fiscales_id_seq;
DROP TABLE IF EXISTS public.dosificaciones_fiscales;
DROP SEQUENCE IF EXISTS public.donantes_id_seq;
DROP TABLE IF EXISTS public.donantes;
DROP SEQUENCE IF EXISTS public.donante_id_donante_seq;
DROP TABLE IF EXISTS public.donante;
DROP SEQUENCE IF EXISTS public.donacions_id_seq;
DROP TABLE IF EXISTS public.donacions;
DROP SEQUENCE IF EXISTS public.donacion_id_donacion_seq;
DROP TABLE IF EXISTS public.donacion;
DROP SEQUENCE IF EXISTS public.detalle_salidas_id_seq;
DROP TABLE IF EXISTS public.detalle_salidas;
DROP SEQUENCE IF EXISTS public.detalle_salida_lotes_id_seq;
DROP TABLE IF EXISTS public.detalle_salida_lotes;
DROP SEQUENCE IF EXISTS public.detalle_salida_id_detallesalida_seq;
DROP TABLE IF EXISTS public.detalle_salida;
DROP SEQUENCE IF EXISTS public.detalle_facturas_legales_id_seq;
DROP TABLE IF EXISTS public.detalle_facturas_legales;
DROP SEQUENCE IF EXISTS public.detalle_donacion_insumos_id_seq;
DROP TABLE IF EXISTS public.detalle_donacion_insumos;
DROP SEQUENCE IF EXISTS public.detalle_donacion_insumo_id_detalle_seq;
DROP TABLE IF EXISTS public.detalle_donacion_insumo;
DROP SEQUENCE IF EXISTS public.detalle_compras_id_seq;
DROP TABLE IF EXISTS public.detalle_compras;
DROP SEQUENCE IF EXISTS public.detalle_compra_id_detallecompra_seq;
DROP TABLE IF EXISTS public.detalle_compra;
DROP SEQUENCE IF EXISTS public.cronograma_tratamientos_id_seq;
DROP TABLE IF EXISTS public.cronograma_tratamientos;
DROP SEQUENCE IF EXISTS public.compras_id_seq;
DROP TABLE IF EXISTS public.compras;
DROP SEQUENCE IF EXISTS public.compra_id_compra_seq;
DROP TABLE IF EXISTS public.compra;
DROP SEQUENCE IF EXISTS public.cierres_periodos_reportes_id_seq;
DROP TABLE IF EXISTS public.cierres_periodos_reportes;
DROP TABLE IF EXISTS public.cache_locks;
DROP TABLE IF EXISTS public.cache;
DROP SEQUENCE IF EXISTS public.bitacoras_id_seq;
DROP TABLE IF EXISTS public.bitacoras;
DROP SEQUENCE IF EXISTS public.bitacora_id_accion_seq;
DROP TABLE IF EXISTS public.bitacora;
DROP SEQUENCE IF EXISTS public.auditoria_forense_id_seq;
DROP TABLE IF EXISTS public.auditoria_forense;
DROP SEQUENCE IF EXISTS public.articulo_inventarios_id_seq;
DROP TABLE IF EXISTS public.articulo_inventarios;
DROP SEQUENCE IF EXISTS public.articulo_inventario_id_articulo_seq;
DROP TABLE IF EXISTS public.articulo_inventario;
DROP SEQUENCE IF EXISTS public.aporte_dineros_id_seq;
DROP TABLE IF EXISTS public.aporte_dineros;
DROP SEQUENCE IF EXISTS public.aporte_dinero_id_aporte_seq;
DROP TABLE IF EXISTS public.aporte_dinero;
DROP SEQUENCE IF EXISTS public.alerta_inventario_id_alerta_seq;
DROP TABLE IF EXISTS public.alerta_inventario;
DROP SEQUENCE IF EXISTS public.ajuste_inventarios_id_seq;
DROP TABLE IF EXISTS public.ajuste_inventarios;
DROP SEQUENCE IF EXISTS public.ajuste_inventario_lotes_id_seq;
DROP TABLE IF EXISTS public.ajuste_inventario_lotes;
DROP SEQUENCE IF EXISTS public.adopcions_id_seq;
DROP TABLE IF EXISTS public.adopcions;
DROP SEQUENCE IF EXISTS public.adopcion_id_adopcion_seq;
DROP TABLE IF EXISTS public.adopcion;
DROP FUNCTION IF EXISTS public.sync_medicamentos_to_medicamento();
DROP PROCEDURE IF EXISTS public.sp_registrar_salida(IN p_usuario_id integer, IN p_articulo_id integer, IN p_cantidad numeric, IN p_motivo character varying);
DROP PROCEDURE IF EXISTS public.sp_registrar_donacion_dinero(IN p_donante_id integer, IN p_usuario_id integer, IN p_monto numeric, IN p_comprobante character varying, IN p_observaciones text);
DROP PROCEDURE IF EXISTS public.sp_registrar_atencion_medica(IN p_mascota_id integer, IN p_usuario_id integer, IN p_tipo_procedimiento character varying, IN p_diagnostico text, IN p_observaciones text);
DROP PROCEDURE IF EXISTS public.sp_formalizar_adopcion(IN p_mascota_id integer, IN p_interesado_id integer, IN p_usuario_id integer);
DROP FUNCTION IF EXISTS public.fn_verificar_stock_minimo_alerta();
DROP FUNCTION IF EXISTS public.fn_sync_users_to_usuario();
DROP FUNCTION IF EXISTS public.fn_sync_seguimientos_to_singular();
DROP FUNCTION IF EXISTS public.fn_sync_proveedors_to_singular();
DROP FUNCTION IF EXISTS public.fn_sync_mascotas_to_mascota();
DROP FUNCTION IF EXISTS public.fn_sync_interesados_to_singular();
DROP FUNCTION IF EXISTS public.fn_sync_donantes_to_singular();
DROP FUNCTION IF EXISTS public.fn_sync_donacions_to_singular();
DROP FUNCTION IF EXISTS public.fn_sync_articulos_to_singular();
DROP FUNCTION IF EXISTS public.fn_sync_adopcions_to_singular();
DROP FUNCTION IF EXISTS public.fn_registrar_bitacora_adopcion();
DROP FUNCTION IF EXISTS public.fn_descontar_stock_por_salida();
DROP FUNCTION IF EXISTS public.fn_actualizar_stock_por_compra();
DROP FUNCTION IF EXISTS public.fn_actualizar_estado_por_historial();
DROP FUNCTION IF EXISTS public.fn_actualizar_estado_mascota_adopcion();
DROP EXTENSION IF EXISTS pgcrypto;
--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: fn_actualizar_estado_mascota_adopcion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_actualizar_estado_mascota_adopcion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE mascota
    SET estado_actual = 'Adoptado',
        updated_at = CURRENT_TIMESTAMP
    WHERE id_mascota = NEW.id_mascota;

    RETURN NEW;
END;
$$;


--
-- Name: fn_actualizar_estado_por_historial(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_actualizar_estado_por_historial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.tipo_procedimiento IN ('Consulta Médica', 'Curación', 'Cirugía', 'Tratamiento') THEN
        UPDATE mascota
        SET estado_actual = 'En Tratamiento',
            updated_at = CURRENT_TIMESTAMP
        WHERE id_mascota = NEW.id_mascota
          AND estado_actual <> 'Adoptado';
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: fn_actualizar_stock_por_compra(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_actualizar_stock_por_compra() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE articulo_inventario
    SET stock_actual = stock_actual + NEW.cantidad,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_articulo = NEW.id_insumo;

    RETURN NEW;
END;
$$;


--
-- Name: fn_descontar_stock_por_salida(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_descontar_stock_por_salida() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE articulo_inventario
    SET stock_actual = stock_actual - NEW.cantidad,
        updated_at = CURRENT_TIMESTAMP
    WHERE id_articulo = NEW.id_articulo;

    RETURN NEW;
END;
$$;


--
-- Name: fn_registrar_bitacora_adopcion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_registrar_bitacora_adopcion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO bitacora (
            id_usuario, fecha, hora, tipo_accion, tabla_afectada, id_registro_afectado
        ) VALUES (
            1, CURRENT_DATE, CURRENT_TIME, 'Registro formal de adopción de mascota', 'adopcion', NEW.id_adopcion
        );
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_adopcions_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_adopcions_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO adopcion (
            id_adopcion, id_mascota, id_interesado, fecha_adopcion, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.id_mascota, NEW.id_interesado, NEW.fecha_adopcion::date,
            COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_adopcion) DO UPDATE SET
            id_mascota = EXCLUDED.id_mascota,
            id_interesado = EXCLUDED.id_interesado,
            fecha_adopcion = EXCLUDED.fecha_adopcion,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_articulos_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_articulos_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO articulo_inventario (
            id_articulo, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.nombre, NEW.categoria, NEW.unidad_medida, NEW.stock_actual, NEW.stock_minimo_alerta,
            COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_articulo) DO UPDATE SET
            nombre = EXCLUDED.nombre,
            categoria = EXCLUDED.categoria,
            unidad_medida = EXCLUDED.unidad_medida,
            stock_actual = EXCLUDED.stock_actual,
            stock_minimo_alerta = EXCLUDED.stock_minimo_alerta,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_donacions_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_donacions_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO donacion (
            id_donacion, id_donante, id_usuario, tipo_aporte, fecha, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.id_donante, NEW.id_usuario, 1, NEW.fecha::date,
            COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_donacion) DO UPDATE SET
            id_donante = EXCLUDED.id_donante,
            id_usuario = EXCLUDED.id_usuario,
            fecha = EXCLUDED.fecha,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_donantes_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_donantes_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO donante (
            id_donante, nombre, tipo_persona, telefono, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.nombre, NEW.tipo_persona, NEW.telefono,
            COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_donante) DO UPDATE SET
            nombre = EXCLUDED.nombre,
            tipo_persona = EXCLUDED.tipo_persona,
            telefono = EXCLUDED.telefono,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_interesados_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_interesados_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO interesado_adopcion (
            id_interesado, ci, nombre, telefono, direccion, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.ci, NEW.nombre, NEW.telefono, NEW.direccion, NEW.situacion_casa, NEW.referencias,
            COALESCE(NULLIF(REGEXP_REPLACE(NEW.puntaje_evaluacion::text, '[^0-9]', '', 'g'), '')::integer, 0),
            COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_interesado) DO UPDATE SET
            nombre = EXCLUDED.nombre,
            ci = EXCLUDED.ci,
            telefono = EXCLUDED.telefono,
            direccion = EXCLUDED.direccion,
            situacion_casa = EXCLUDED.situacion_casa,
            referencias = EXCLUDED.referencias,
            puntaje_evaluacion = EXCLUDED.puntaje_evaluacion,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_mascotas_to_mascota(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_mascotas_to_mascota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_estado text;
BEGIN
    BEGIN
        IF NEW.estado_actual ILIKE '%adoptad%' THEN
            v_estado := 'Adoptado';
        ELSIF NEW.estado_actual ILIKE '%trata%' THEN
            v_estado := 'En Tratamiento';
        ELSIF NEW.estado_actual ILIKE '%recupera%' THEN
            v_estado := 'En Recuperación';
        ELSIF NEW.estado_actual ILIKE '%fallecid%' THEN
            v_estado := 'Fallecido';
        ELSE
            v_estado := 'Disponible para Adopción';
        END IF;

        INSERT INTO mascota (
            id_mascota, nombre, especie, raza, sexo, edad_aproximada, estado_actual,
            zona_rescate, fecha_ingreso, foto, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.nombre, NEW.especie, NEW.raza, NEW.sexo, NEW.edad, v_estado,
            NEW.zona_rescate, NEW.fecha_ingreso::date, NEW.foto, COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_mascota) DO UPDATE SET
            nombre = EXCLUDED.nombre,
            especie = EXCLUDED.especie,
            raza = EXCLUDED.raza,
            sexo = EXCLUDED.sexo,
            edad_aproximada = EXCLUDED.edad_aproximada,
            estado_actual = EXCLUDED.estado_actual,
            zona_rescate = EXCLUDED.zona_rescate,
            fecha_ingreso = EXCLUDED.fecha_ingreso,
            foto = EXCLUDED.foto,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_proveedors_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_proveedors_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO proveedor (
            id_proveedor, nombre_empresa, contacto_nombre, direccion, telefono, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.nombre_empresa, NEW.nombre_contacto, NEW.direccion, NEW.telefono,
            COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_proveedor) DO UPDATE SET
            nombre_empresa = EXCLUDED.nombre_empresa,
            contacto_nombre = EXCLUDED.contacto_nombre,
            direccion = EXCLUDED.direccion,
            telefono = EXCLUDED.telefono,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_seguimientos_to_singular(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_seguimientos_to_singular() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO seguimiento_adopcion (
            id_seguimiento, id_adopcion, id_usuario, estado_seguimiento,
            fecha_programada, fecha_realizada, reporte_bienestar, fotografias_evidencia, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.id_adopcion, NEW.id_usuario, COALESCE(NEW.estado_seguimiento, 'Pendiente'),
            NEW.fecha_programada::date,
            CASE WHEN NEW.fecha_realizada IS NOT NULL THEN NEW.fecha_realizada::date ELSE NULL END,
            NEW.reporte_bienestar, NEW.fotografia, COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_seguimiento) DO UPDATE SET
            estado_seguimiento = EXCLUDED.estado_seguimiento,
            fecha_programada = EXCLUDED.fecha_programada,
            fecha_realizada = EXCLUDED.fecha_realizada,
            reporte_bienestar = EXCLUDED.reporte_bienestar,
            fotografias_evidencia = EXCLUDED.fotografias_evidencia,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        -- Evitar que desincronizaciones en tabla espejo singular bloqueen la operación principal
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_sync_users_to_usuario(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_sync_users_to_usuario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO usuario (
            id_usuario, ci, nombre_completo, rol, telefono, hash_contrasena,
            estado, intentos_fallidos, created_at, updated_at
        ) VALUES (
            NEW.id, COALESCE(NEW.ci, 'CI-' || NEW.id), NEW.nombre, NEW.rol, NEW.telefono,
            NEW.password, CASE WHEN NEW.activo THEN 'Activo' ELSE 'Inactivo' END,
            0, COALESCE(NEW.created_at, now()), COALESCE(NEW.updated_at, now())
        )
        ON CONFLICT (id_usuario) DO UPDATE SET
            nombre_completo = EXCLUDED.nombre_completo,
            rol = EXCLUDED.rol,
            telefono = EXCLUDED.telefono,
            hash_contrasena = EXCLUDED.hash_contrasena,
            estado = EXCLUDED.estado,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


--
-- Name: fn_verificar_stock_minimo_alerta(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_verificar_stock_minimo_alerta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Si el stock actual cae por debajo o igual al stock mínimo configurado
    IF NEW.stock_actual <= NEW.stock_minimo_alerta AND NEW.stock_minimo_alerta > 0 THEN
        -- Verificar si ya existe una alerta activa para este artículo
        IF NOT EXISTS (
            SELECT 1 FROM alerta_inventario 
            WHERE id_articulo = NEW.id_articulo AND estado = 'Pendiente'
        ) THEN
            INSERT INTO alerta_inventario (id_articulo, nivel_criticidad, fecha_generada, estado)
            VALUES (
                NEW.id_articulo,
                CASE WHEN NEW.stock_actual = 0 THEN 'Agotado' ELSE 'Critico' END,
                CURRENT_TIMESTAMP,
                'Pendiente'
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: sp_formalizar_adopcion(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_formalizar_adopcion(IN p_mascota_id integer, IN p_interesado_id integer, IN p_usuario_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_adopcion_id INT;
    v_estado_mascota VARCHAR;
BEGIN
    -- Verificar disponibilidad de la mascota
    SELECT estado_actual INTO v_estado_mascota
    FROM mascota
    WHERE id_mascota = p_mascota_id;

    IF v_estado_mascota IS NULL THEN
        RAISE EXCEPTION 'La mascota con ID % no existe.', p_mascota_id;
    END IF;

    IF v_estado_mascota = 'Adoptado' THEN
        RAISE EXCEPTION 'La mascota ya se encuentra adoptada.';
    END IF;

    -- 1. Registrar la adopción (el trigger tr_actualizar_estado_mascota_adopcion cambiará su estado a 'Adoptado')
    INSERT INTO adopcion (id_mascota, id_interesado, fecha_adopcion)
    VALUES (p_mascota_id, p_interesado_id, CURRENT_DATE)
    RETURNING id_adopcion INTO v_adopcion_id;

    -- 2. Programar automáticamente las 3 visitas de seguimiento protocolar
    -- Visita 1: a los 30 días
    INSERT INTO seguimiento_adopcion (id_adopcion, id_usuario, estado_seguimiento, fecha_programada, reporte_bienestar)
    VALUES (v_adopcion_id, p_usuario_id, 'Programado', CURRENT_DATE + INTERVAL '30 days', 'Primer control de adaptación y entorno');

    -- Visita 2: a los 90 días (3 meses)
    INSERT INTO seguimiento_adopcion (id_adopcion, id_usuario, estado_seguimiento, fecha_programada, reporte_bienestar)
    VALUES (v_adopcion_id, p_usuario_id, 'Programado', CURRENT_DATE + INTERVAL '90 days', 'Segundo control nutricional y cartilla sanitaria');

    -- Visita 3: a los 180 días (6 meses)
    INSERT INTO seguimiento_adopcion (id_adopcion, id_usuario, estado_seguimiento, fecha_programada, reporte_bienestar)
    VALUES (v_adopcion_id, p_usuario_id, 'Programado', CURRENT_DATE + INTERVAL '180 days', 'Control final de bienestar y esterilización');

    RAISE NOTICE 'Adopción % formalizada con éxito. Se programaron 3 visitas de control.', v_adopcion_id;
END;
$$;


--
-- Name: sp_registrar_atencion_medica(integer, integer, character varying, text, text); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_registrar_atencion_medica(IN p_mascota_id integer, IN p_usuario_id integer, IN p_tipo_procedimiento character varying, IN p_diagnostico text, IN p_observaciones text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_historial_id INT;
BEGIN
    INSERT INTO historial_clinico (id_mascota, id_usuario, fecha_atencion, tipo_procedimiento, diagnostico, observaciones)
    VALUES (p_mascota_id, p_usuario_id, CURRENT_DATE, p_tipo_procedimiento, p_diagnostico, p_observaciones)
    RETURNING id_historial INTO v_historial_id;

    RAISE NOTICE 'Atención clínica % registrada con éxito para la mascota %.', v_historial_id, p_mascota_id;
END;
$$;


--
-- Name: sp_registrar_donacion_dinero(integer, integer, numeric, character varying, text); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_registrar_donacion_dinero(IN p_donante_id integer, IN p_usuario_id integer, IN p_monto numeric, IN p_comprobante character varying, IN p_observaciones text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_donacion_id INT;
    v_tipo_aporte_id INT;
BEGIN
    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto donado debe ser mayor a 0.';
    END IF;

    -- Obtener o asignar tipo de aporte monetario
    SELECT id_tipoAporte INTO v_tipo_aporte_id
    FROM tipo_aporte
    WHERE nombre ILIKE '%Monetario%' OR nombre ILIKE '%Dinero%'
    LIMIT 1;

    IF v_tipo_aporte_id IS NULL THEN
        INSERT INTO tipo_aporte (nombre, descripcion)
        VALUES ('Aporte Monetario', 'Aportes en efectivo, transferencia o pasarela QR')
        RETURNING id_tipoAporte INTO v_tipo_aporte_id;
    END IF;

    -- 1. Registrar la cabecera de donación
    INSERT INTO donacion (id_donante, id_usuario, tipo_aporte, fecha)
    VALUES (p_donante_id, p_usuario_id, v_tipo_aporte_id, CURRENT_DATE)
    RETURNING id_donacion INTO v_donacion_id;

    -- 2. Registrar el aporte de dinero
    INSERT INTO aporte_dinero (id_donacion, monto, fecha_recepcion, comprobante, observaciones)
    VALUES (v_donacion_id, p_monto, CURRENT_DATE, p_comprobante, p_observaciones);

    RAISE NOTICE 'Donación monetaria % por Bs. % registrada con éxito.', v_donacion_id, p_monto;
END;
$$;


--
-- Name: sp_registrar_salida(integer, integer, numeric, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_registrar_salida(IN p_usuario_id integer, IN p_articulo_id integer, IN p_cantidad numeric, IN p_motivo character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_salida_id INT;
    v_stock_actual DECIMAL;
BEGIN
    -- Validar existencia y stock suficiente
    SELECT stock_actual INTO v_stock_actual
    FROM articulo_inventario
    WHERE id_articulo = p_articulo_id;

    IF v_stock_actual IS NULL THEN
        RAISE EXCEPTION 'El artículo con ID % no existe en el catálogo.', p_articulo_id;
    END IF;

    IF v_stock_actual < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente. Stock actual: %, Solicitado: %', v_stock_actual, p_cantidad;
    END IF;

    -- Registrar la cabecera de salida
    INSERT INTO salida_inventario (id_usuario, fecha_salida, motivo)
    VALUES (p_usuario_id, CURRENT_DATE, p_motivo)
    RETURNING id_salida INTO v_salida_id;

    -- Registrar el detalle de salida (el trigger tr_descontar_stock_salida descuenta el stock)
    INSERT INTO detalle_salida (id_salida, id_articulo, cantidad)
    VALUES (v_salida_id, p_articulo_id, p_cantidad);

    RAISE NOTICE 'Salida de inventario % registrada exitosamente para el insumo %.', v_salida_id, p_articulo_id;
END;
$$;


--
-- Name: sync_medicamentos_to_medicamento(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_medicamentos_to_medicamento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    BEGIN
        INSERT INTO medicamento (
            id_medicamento, nombre, principio_activo, categoria_farmacologica,
            tipo_presentacion, via_administracion, concentracion, especie_destino,
            dosis_recomendada, indicacion_terapeutica, es_inyectable, lote,
            fecha_vencimiento, stock_actual, stock_minimo, unidad_medida,
            precio_unitario, created_at, updated_at
        ) VALUES (
            NEW.id, NEW.nombre, NEW.principio_activo, NEW.categoria_farmacologica,
            NEW.tipo_presentacion, NEW.via_administracion, NEW.concentracion, NEW.especie_destino,
            NEW.dosis_recomendada, NEW.indicacion_terapeutica, NEW.es_inyectable, NEW.lote,
            NEW.fecha_vencimiento, NEW.stock_actual, NEW.stock_minimo, NEW.unidad_medida,
            NEW.precio_unitario, NEW.created_at, NEW.updated_at
        )
        ON CONFLICT (id_medicamento) DO UPDATE SET
            nombre = EXCLUDED.nombre,
            principio_activo = EXCLUDED.principio_activo,
            categoria_farmacologica = EXCLUDED.categoria_farmacologica,
            tipo_presentacion = EXCLUDED.tipo_presentacion,
            via_administracion = EXCLUDED.via_administracion,
            concentracion = EXCLUDED.concentracion,
            especie_destino = EXCLUDED.especie_destino,
            dosis_recomendada = EXCLUDED.dosis_recomendada,
            indicacion_terapeutica = EXCLUDED.indicacion_terapeutica,
            es_inyectable = EXCLUDED.es_inyectable,
            lote = EXCLUDED.lote,
            fecha_vencimiento = EXCLUDED.fecha_vencimiento,
            stock_actual = EXCLUDED.stock_actual,
            stock_minimo = EXCLUDED.stock_minimo,
            unidad_medida = EXCLUDED.unidad_medida,
            precio_unitario = EXCLUDED.precio_unitario,
            updated_at = EXCLUDED.updated_at;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adopcion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adopcion (
    id_adopcion integer NOT NULL,
    id_mascota integer NOT NULL,
    id_interesado integer NOT NULL,
    fecha_adopcion date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adopcion_id_adopcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adopcion_id_adopcion_seq OWNED BY public.adopcion.id_adopcion;


--
-- Name: adopcions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adopcions (
    id bigint NOT NULL,
    fecha_adopcion character varying(255) NOT NULL,
    id_interesado bigint NOT NULL,
    id_mascota bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: adopcions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adopcions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adopcions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adopcions_id_seq OWNED BY public.adopcions.id;


--
-- Name: ajuste_inventario_lotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ajuste_inventario_lotes (
    id bigint NOT NULL,
    id_ajuste_inventario bigint NOT NULL,
    id_inventario_lote bigint NOT NULL,
    cantidad numeric(12,2) NOT NULL
);


--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ajuste_inventario_lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ajuste_inventario_lotes_id_seq OWNED BY public.ajuste_inventario_lotes.id;


--
-- Name: ajuste_inventarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ajuste_inventarios (
    id bigint NOT NULL,
    id_articulo bigint NOT NULL,
    id_usuario bigint,
    usuario_nombre character varying(255) NOT NULL,
    cantidad integer NOT NULL,
    stock_anterior numeric(12,2) NOT NULL,
    stock_nuevo numeric(12,2) NOT NULL,
    saldo_disponible_anterior numeric(12,2) NOT NULL,
    saldo_disponible_nuevo numeric(12,2) NOT NULL,
    motivo text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ajuste_inventarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ajuste_inventarios_id_seq OWNED BY public.ajuste_inventarios.id;


--
-- Name: alerta_inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alerta_inventario (
    id_alerta integer NOT NULL,
    id_articulo integer NOT NULL,
    nivel_criticidad character varying(20) DEFAULT 'Critico'::character varying NOT NULL,
    fecha_generada timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(20) DEFAULT 'Pendiente'::character varying NOT NULL
);


--
-- Name: alerta_inventario_id_alerta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alerta_inventario_id_alerta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alerta_inventario_id_alerta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alerta_inventario_id_alerta_seq OWNED BY public.alerta_inventario.id_alerta;


--
-- Name: aporte_dinero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aporte_dinero (
    id_aporte integer NOT NULL,
    id_donacion integer NOT NULL,
    monto numeric(10,2) NOT NULL,
    fecha_recepcion date DEFAULT CURRENT_DATE NOT NULL,
    comprobante character varying(100),
    observaciones text,
    CONSTRAINT aporte_dinero_monto_check CHECK ((monto > (0)::numeric))
);


--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aporte_dinero_id_aporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aporte_dinero_id_aporte_seq OWNED BY public.aporte_dinero.id_aporte;


--
-- Name: aporte_dineros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aporte_dineros (
    id bigint NOT NULL,
    monto numeric(10,2) NOT NULL,
    fecha_recepcion date NOT NULL,
    comprobante character varying(100),
    observaciones text,
    id_donacion bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aporte_dineros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aporte_dineros_id_seq OWNED BY public.aporte_dineros.id;


--
-- Name: articulo_inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articulo_inventario (
    id_articulo integer NOT NULL,
    nombre character varying(150) NOT NULL,
    categoria character varying(50) NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    stock_actual numeric(10,2) DEFAULT 0.00 NOT NULL,
    stock_minimo_alerta numeric(10,2) DEFAULT 0.00 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT articulo_inventario_stock_actual_check CHECK ((stock_actual >= (0)::numeric)),
    CONSTRAINT articulo_inventario_stock_minimo_alerta_check CHECK ((stock_minimo_alerta >= (0)::numeric))
);


--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articulo_inventario_id_articulo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articulo_inventario_id_articulo_seq OWNED BY public.articulo_inventario.id_articulo;


--
-- Name: articulo_inventarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articulo_inventarios (
    id bigint NOT NULL,
    nombre character varying(150) NOT NULL,
    categoria character varying(50) NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    stock_actual numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    stock_minimo_alerta numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articulo_inventarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articulo_inventarios_id_seq OWNED BY public.articulo_inventarios.id;


--
-- Name: auditoria_forense; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auditoria_forense (
    id bigint NOT NULL,
    fecha_evento timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_id bigint,
    ip_origen character varying(45) NOT NULL,
    user_agent text,
    severidad character varying(20) DEFAULT 'INFO'::character varying NOT NULL,
    modulo character varying(60) NOT NULL,
    accion character varying(50) NOT NULL,
    tabla_afectada character varying(60),
    registro_id character varying(50),
    payload_anterior jsonb,
    payload_nuevo jsonb,
    hash_integridad character varying(64) NOT NULL
);


--
-- Name: auditoria_forense_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auditoria_forense_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auditoria_forense_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auditoria_forense_id_seq OWNED BY public.auditoria_forense.id;


--
-- Name: bitacora; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bitacora (
    id_accion integer NOT NULL,
    id_usuario integer,
    fecha date DEFAULT CURRENT_DATE NOT NULL,
    hora time without time zone DEFAULT CURRENT_TIME NOT NULL,
    tipo_accion character varying(100) NOT NULL,
    tabla_afectada character varying(100),
    id_registro_afectado integer,
    ip character varying(45),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bitacora_id_accion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bitacora_id_accion_seq OWNED BY public.bitacora.id_accion;


--
-- Name: bitacoras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bitacoras (
    id bigint NOT NULL,
    tipo_accion character varying(255) NOT NULL,
    id_usuario bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    usuario_nombre character varying(255),
    modulo character varying(100) DEFAULT 'sistema'::character varying NOT NULL,
    descripcion text,
    entidad_tipo character varying(100),
    entidad_id character varying(64),
    ip character varying(45),
    http_method character varying(10),
    ruta character varying(255),
    resultado character varying(20) DEFAULT 'exitosa'::character varying NOT NULL,
    contexto json
);


--
-- Name: bitacoras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bitacoras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bitacoras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bitacoras_id_seq OWNED BY public.bitacoras.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration bigint NOT NULL
);


--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration bigint NOT NULL
);


--
-- Name: cierres_periodos_reportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cierres_periodos_reportes (
    id bigint NOT NULL,
    anio integer NOT NULL,
    mes integer NOT NULL,
    tipo_reporte character varying(40) NOT NULL,
    periodo_cerrado boolean DEFAULT false NOT NULL,
    hash_documento character varying(64) NOT NULL,
    generado_por bigint NOT NULL,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: cierres_periodos_reportes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cierres_periodos_reportes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cierres_periodos_reportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cierres_periodos_reportes_id_seq OWNED BY public.cierres_periodos_reportes.id;


--
-- Name: compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_compra date DEFAULT CURRENT_DATE NOT NULL,
    monto_total numeric(10,2) DEFAULT 0.00 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT compra_monto_total_check CHECK ((monto_total >= (0)::numeric))
);


--
-- Name: compra_id_compra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compra_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compra_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compra_id_compra_seq OWNED BY public.compra.id_compra;


--
-- Name: compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compras (
    id bigint NOT NULL,
    monto_total numeric(10,2) NOT NULL,
    fecha_compra date NOT NULL,
    id_proveedor bigint NOT NULL,
    id_usuario bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    numero_documento character varying(100)
);


--
-- Name: compras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;


--
-- Name: cronograma_tratamientos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cronograma_tratamientos (
    id bigint NOT NULL,
    prescripcion_id bigint NOT NULL,
    lote_inventario_id bigint,
    fecha_hora_programada timestamp(0) without time zone NOT NULL,
    fecha_hora_administrada timestamp(0) without time zone,
    administrado_por bigint,
    estado character varying(20) DEFAULT 'PENDIENTE'::character varying NOT NULL,
    notas text
);


--
-- Name: cronograma_tratamientos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cronograma_tratamientos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cronograma_tratamientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cronograma_tratamientos_id_seq OWNED BY public.cronograma_tratamientos.id;


--
-- Name: detalle_compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_compra (
    id_detallecompra integer NOT NULL,
    id_compra integer NOT NULL,
    id_insumo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    costo_unitario numeric(10,2) NOT NULL,
    fecha_vencimiento date,
    CONSTRAINT detalle_compra_cantidad_check CHECK ((cantidad > (0)::numeric)),
    CONSTRAINT detalle_compra_costo_unitario_check CHECK ((costo_unitario >= (0)::numeric))
);


--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_compra_id_detallecompra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_compra_id_detallecompra_seq OWNED BY public.detalle_compra.id_detallecompra;


--
-- Name: detalle_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_compras (
    id bigint NOT NULL,
    costo_unitario numeric(10,2) NOT NULL,
    fecha_vencimiento date,
    cantidad numeric(10,2) NOT NULL,
    id_compra bigint NOT NULL,
    id_articulo bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: detalle_compras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_compras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_compras_id_seq OWNED BY public.detalle_compras.id;


--
-- Name: detalle_donacion_insumo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_donacion_insumo (
    id_detalle integer NOT NULL,
    id_donacion integer NOT NULL,
    id_articulo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    fecha_vencimiento date,
    CONSTRAINT detalle_donacion_insumo_cantidad_check CHECK ((cantidad > (0)::numeric))
);


--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_donacion_insumo_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_donacion_insumo_id_detalle_seq OWNED BY public.detalle_donacion_insumo.id_detalle;


--
-- Name: detalle_donacion_insumos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_donacion_insumos (
    id bigint NOT NULL,
    fecha_vencimiento date,
    cantidad numeric(10,2) NOT NULL,
    id_donacion bigint NOT NULL,
    id_articulo bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_donacion_insumos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_donacion_insumos_id_seq OWNED BY public.detalle_donacion_insumos.id;


--
-- Name: detalle_facturas_legales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_facturas_legales (
    id bigint NOT NULL,
    factura_id bigint NOT NULL,
    concepto character varying(255) NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    referencia_tipo character varying(30),
    referencia_id bigint
);


--
-- Name: detalle_facturas_legales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_facturas_legales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_facturas_legales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_facturas_legales_id_seq OWNED BY public.detalle_facturas_legales.id;


--
-- Name: detalle_salida; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_salida (
    id_detallesalida integer NOT NULL,
    id_salida integer NOT NULL,
    id_articulo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    CONSTRAINT detalle_salida_cantidad_check CHECK ((cantidad > (0)::numeric))
);


--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_salida_id_detallesalida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_salida_id_detallesalida_seq OWNED BY public.detalle_salida.id_detallesalida;


--
-- Name: detalle_salida_lotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_salida_lotes (
    id bigint NOT NULL,
    id_detalle_salida bigint NOT NULL,
    id_inventario_lote bigint NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_salida_lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_salida_lotes_id_seq OWNED BY public.detalle_salida_lotes.id;


--
-- Name: detalle_salidas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_salidas (
    id bigint NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    id_salida bigint NOT NULL,
    id_articulo bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_salidas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_salidas_id_seq OWNED BY public.detalle_salidas.id;


--
-- Name: donacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donacion (
    id_donacion integer NOT NULL,
    id_donante integer NOT NULL,
    id_usuario integer NOT NULL,
    tipo_aporte integer NOT NULL,
    fecha date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donacion_id_donacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donacion_id_donacion_seq OWNED BY public.donacion.id_donacion;


--
-- Name: donacions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donacions (
    id bigint NOT NULL,
    tipo_aporte character varying(255) NOT NULL,
    fecha date NOT NULL,
    id_donante bigint NOT NULL,
    id_usuario bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    numero_documento character varying(100)
);


--
-- Name: donacions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donacions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donacions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donacions_id_seq OWNED BY public.donacions.id;


--
-- Name: donante; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donante (
    id_donante integer NOT NULL,
    nombre character varying(150) NOT NULL,
    tipo_persona character varying(50) DEFAULT 'Natural'::character varying,
    telefono character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: donante_id_donante_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donante_id_donante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donante_id_donante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donante_id_donante_seq OWNED BY public.donante.id_donante;


--
-- Name: donantes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donantes (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    telefono character varying(255) NOT NULL,
    tipo_persona character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: donantes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donantes_id_seq OWNED BY public.donantes.id;


--
-- Name: dosificaciones_fiscales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dosificaciones_fiscales (
    id bigint NOT NULL,
    nit_emisor character varying(20) NOT NULL,
    numero_autorizacion character varying(50) NOT NULL,
    llave_dosificacion text NOT NULL,
    numero_inicial integer DEFAULT 1 NOT NULL,
    numero_final integer NOT NULL,
    correlativo_actual integer DEFAULT 1 NOT NULL,
    fecha_limite_emision date NOT NULL,
    leyenda_tributaria text NOT NULL,
    activa boolean DEFAULT true NOT NULL,
    created_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: dosificaciones_fiscales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dosificaciones_fiscales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dosificaciones_fiscales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dosificaciones_fiscales_id_seq OWNED BY public.dosificaciones_fiscales.id;


--
-- Name: evaluacion_idoneidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evaluacion_idoneidad (
    id_evaluacion integer NOT NULL,
    id_interesado integer NOT NULL,
    puntaje_vivienda integer DEFAULT 0,
    puntaje_compromiso integer DEFAULT 0,
    puntaje_total integer DEFAULT 0,
    resultado character varying(30) DEFAULT 'Pendiente'::character varying,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: evaluacion_idoneidad_id_evaluacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evaluacion_idoneidad_id_evaluacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluacion_idoneidad_id_evaluacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.evaluacion_idoneidad_id_evaluacion_seq OWNED BY public.evaluacion_idoneidad.id_evaluacion;


--
-- Name: expediente_digital; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expediente_digital (
    nro_expediente character varying(50) NOT NULL,
    id_mascota integer NOT NULL,
    estado_clinico character varying(50) DEFAULT 'Inicial'::character varying,
    fecha_apertura date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: facturas_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facturas_compras (
    id bigint NOT NULL,
    proveedor_id bigint NOT NULL,
    fecha_factura date NOT NULL,
    nit_proveedor character varying(20) NOT NULL,
    razon_social_proveedor character varying(200) NOT NULL,
    numero_factura character varying(30) NOT NULL,
    numero_autorizacion character varying(50) NOT NULL,
    codigo_control character varying(30),
    importe_total numeric(12,2) NOT NULL,
    importe_exento numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    importe_base_cf numeric(12,2) NOT NULL,
    credito_fiscal numeric(12,2) NOT NULL,
    registrado_por bigint NOT NULL,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: facturas_compras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facturas_compras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facturas_compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facturas_compras_id_seq OWNED BY public.facturas_compras.id;


--
-- Name: facturas_legales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facturas_legales (
    id bigint NOT NULL,
    dosificacion_id bigint NOT NULL,
    numero_factura integer NOT NULL,
    numero_autorizacion character varying(50) NOT NULL,
    fecha_emision timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    nit_ci_cliente character varying(20) NOT NULL,
    complemento_ci character varying(5),
    razon_social_cliente character varying(200) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    descuento numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    importe_total numeric(12,2) NOT NULL,
    importe_base_cf numeric(12,2) NOT NULL,
    debito_fiscal numeric(12,2) NOT NULL,
    codigo_control character varying(30) NOT NULL,
    cadena_qr text NOT NULL,
    estado character varying(15) DEFAULT 'EMITIDA'::character varying NOT NULL,
    motivo_anulacion text,
    fecha_anulacion timestamp(0) without time zone,
    usuario_emisor_id bigint NOT NULL,
    usuario_anulador_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: facturas_legales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facturas_legales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facturas_legales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facturas_legales_id_seq OWNED BY public.facturas_legales.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection character varying(255) NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: historial_clinico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historial_clinico (
    id_historial integer NOT NULL,
    id_mascota integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_atencion date DEFAULT CURRENT_DATE NOT NULL,
    tipo_procedimiento character varying(100) NOT NULL,
    diagnostico text,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.historial_clinico_id_historial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.historial_clinico_id_historial_seq OWNED BY public.historial_clinico.id_historial;


--
-- Name: historial_clinicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historial_clinicos (
    id bigint NOT NULL,
    fecha_atencion character varying(255) NOT NULL,
    diagnostico character varying(255) NOT NULL,
    observacion character varying(255) NOT NULL,
    tipo_procedimiento character varying(255) NOT NULL,
    id_mascota bigint NOT NULL,
    id_usuario bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.historial_clinicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.historial_clinicos_id_seq OWNED BY public.historial_clinicos.id;


--
-- Name: interesado_adopcion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interesado_adopcion (
    id_interesado integer NOT NULL,
    ci character varying(20) NOT NULL,
    nombre character varying(150) NOT NULL,
    telefono character varying(20),
    direccion character varying(255),
    situacion_casa text,
    referencias text,
    puntaje_evaluacion integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interesado_adopcion_id_interesado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interesado_adopcion_id_interesado_seq OWNED BY public.interesado_adopcion.id_interesado;


--
-- Name: interesado_adopcions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interesado_adopcions (
    id bigint NOT NULL,
    ci character varying(20) NOT NULL,
    nombre character varying(255) NOT NULL,
    direccion character varying(255) NOT NULL,
    telefono character varying(255) NOT NULL,
    situacion_casa character varying(255) NOT NULL,
    referencias character varying(255) NOT NULL,
    puntaje_evaluacion character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    estado character varying(32) DEFAULT 'Pendiente'::character varying NOT NULL
);


--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interesado_adopcions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interesado_adopcions_id_seq OWNED BY public.interesado_adopcions.id;


--
-- Name: inventario_lotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventario_lotes (
    id bigint NOT NULL,
    id_articulo bigint NOT NULL,
    id_detalle_compra bigint,
    id_detalle_donacion bigint,
    fecha_vencimiento date,
    cantidad_inicial numeric(10,2) NOT NULL,
    cantidad_disponible numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    cantidad_vencida numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventario_lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventario_lotes_id_seq OWNED BY public.inventario_lotes.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: mascota; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mascota (
    id_mascota integer NOT NULL,
    nombre character varying(100) NOT NULL,
    especie character varying(50) NOT NULL,
    raza character varying(50),
    sexo character varying(15),
    edad_aproximada character varying(50),
    estado_actual character varying(50) DEFAULT 'En Recuperación'::character varying NOT NULL,
    zona_rescate character varying(150),
    fecha_ingreso date DEFAULT CURRENT_DATE NOT NULL,
    foto text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mascota_id_mascota_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mascota_id_mascota_seq OWNED BY public.mascota.id_mascota;


--
-- Name: mascotas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mascotas (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    raza character varying(255) NOT NULL,
    edad character varying(255) NOT NULL,
    especie character varying(255) NOT NULL,
    estado_actual character varying(255) NOT NULL,
    fecha_ingreso character varying(255) NOT NULL,
    sexo character varying(255) NOT NULL,
    zona_rescate character varying(255) NOT NULL,
    foto text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: mascotas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mascotas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mascotas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mascotas_id_seq OWNED BY public.mascotas.id;


--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medicamento (
    id_medicamento integer NOT NULL,
    nombre character varying(255) NOT NULL,
    principio_activo character varying(255) NOT NULL,
    categoria_farmacologica character varying(100) NOT NULL,
    tipo_presentacion character varying(100) NOT NULL,
    via_administracion character varying(100) NOT NULL,
    concentracion character varying(100) NOT NULL,
    especie_destino character varying(100) DEFAULT 'Caninos y Felinos'::character varying NOT NULL,
    dosis_recomendada character varying(255) NOT NULL,
    indicacion_terapeutica text NOT NULL,
    es_inyectable boolean DEFAULT false NOT NULL,
    lote character varying(50),
    fecha_vencimiento date,
    stock_actual numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    stock_minimo numeric(12,2) DEFAULT '5'::numeric NOT NULL,
    unidad_medida character varying(50) DEFAULT 'Frasco'::character varying NOT NULL,
    precio_unitario numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: medicamento_id_medicamento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medicamento_id_medicamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medicamento_id_medicamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medicamento_id_medicamento_seq OWNED BY public.medicamento.id_medicamento;


--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medicamentos (
    id bigint NOT NULL,
    id_medicamento integer,
    nombre character varying(255) NOT NULL,
    principio_activo character varying(255) NOT NULL,
    categoria_farmacologica character varying(100) NOT NULL,
    tipo_presentacion character varying(100) NOT NULL,
    via_administracion character varying(100) NOT NULL,
    concentracion character varying(100) NOT NULL,
    especie_destino character varying(100) DEFAULT 'Caninos y Felinos'::character varying NOT NULL,
    dosis_recomendada character varying(255) NOT NULL,
    indicacion_terapeutica text NOT NULL,
    es_inyectable boolean DEFAULT false NOT NULL,
    lote character varying(50),
    fecha_vencimiento date,
    stock_actual numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    stock_minimo numeric(12,2) DEFAULT '5'::numeric NOT NULL,
    unidad_medida character varying(50) DEFAULT 'Frasco'::character varying NOT NULL,
    precio_unitario numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: medicamentos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medicamentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medicamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medicamentos_id_seq OWNED BY public.medicamentos.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: prescripciones_dosificacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prescripciones_dosificacion (
    id bigint NOT NULL,
    mascota_id bigint NOT NULL,
    historial_clinico_id bigint,
    articulo_id bigint NOT NULL,
    veterinario_id bigint NOT NULL,
    peso_mascota_kg numeric(6,2) NOT NULL,
    dosis_mg_kg numeric(8,3) NOT NULL,
    concentracion_farmaco numeric(8,3) NOT NULL,
    dosis_calculada_unidad numeric(8,3) NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    frecuencia_horas integer NOT NULL,
    duracion_dias integer NOT NULL,
    observaciones_clinicas text,
    estado character varying(20) DEFAULT 'ACTIVO'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: prescripciones_dosificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prescripciones_dosificacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prescripciones_dosificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prescripciones_dosificacion_id_seq OWNED BY public.prescripciones_dosificacion.id;


--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proveedor (
    id_proveedor integer NOT NULL,
    nombre_empresa character varying(150) NOT NULL,
    contacto_nombre character varying(150),
    direccion character varying(255),
    telefono character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(50) DEFAULT 'Activo'::character varying NOT NULL
);


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNED BY public.proveedor.id_proveedor;


--
-- Name: proveedors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proveedors (
    id bigint NOT NULL,
    nombre_empresa character varying(255) NOT NULL,
    nombre_contacto character varying(255) NOT NULL,
    telefono character varying(255) NOT NULL,
    direccion character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    identificacion character varying(50),
    tipo_insumo_provisto character varying(255),
    activo boolean DEFAULT true NOT NULL,
    estado character varying(50) DEFAULT 'Activo'::character varying NOT NULL
);


--
-- Name: proveedors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proveedors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proveedors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.proveedors_id_seq OWNED BY public.proveedors.id;


--
-- Name: rol_permiso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rol_permiso (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(255),
    permisos_modulos text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: rol_permiso_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rol_permiso_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rol_permiso_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rol_permiso_id_rol_seq OWNED BY public.rol_permiso.id_rol;


--
-- Name: salida_inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salida_inventario (
    id_salida integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_salida date DEFAULT CURRENT_DATE NOT NULL,
    motivo character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.salida_inventario_id_salida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.salida_inventario_id_salida_seq OWNED BY public.salida_inventario.id_salida;


--
-- Name: salida_inventarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salida_inventarios (
    id bigint NOT NULL,
    motivo character varying(255) NOT NULL,
    id_usuario bigint NOT NULL,
    fecha_salida date NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    id_historial_clinico bigint
);


--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.salida_inventarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.salida_inventarios_id_seq OWNED BY public.salida_inventarios.id;


--
-- Name: seguimiento_adopcion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seguimiento_adopcion (
    id_seguimiento integer NOT NULL,
    id_adopcion integer NOT NULL,
    id_usuario integer NOT NULL,
    estado_seguimiento character varying(50) DEFAULT 'Programado'::character varying NOT NULL,
    fecha_programada date NOT NULL,
    fecha_realizada date,
    reporte_bienestar text,
    fotografias_evidencia text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seguimiento_adopcion_id_seguimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seguimiento_adopcion_id_seguimiento_seq OWNED BY public.seguimiento_adopcion.id_seguimiento;


--
-- Name: seguimiento_adopcions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seguimiento_adopcions (
    id bigint NOT NULL,
    estado_seguimiento character varying(255) NOT NULL,
    fecha_programada date NOT NULL,
    fecha_realizada date,
    fotografia text NOT NULL,
    reporte_bienestar text NOT NULL,
    id_adopcion bigint NOT NULL,
    id_usuario bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seguimiento_adopcions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seguimiento_adopcions_id_seq OWNED BY public.seguimiento_adopcions.id;


--
-- Name: sesion_jwt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sesion_jwt (
    token_hash character varying(255) NOT NULL,
    id_usuario integer NOT NULL,
    ip_cliente character varying(45),
    user_agent character varying(255),
    fecha_emision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion timestamp without time zone NOT NULL,
    estado character varying(20) DEFAULT 'Activo'::character varying NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


--
-- Name: tipo_aporte; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_aporte (
    id_tipoaporte integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text
);


--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tipo_aporte_id_tipoaporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tipo_aporte_id_tipoaporte_seq OWNED BY public.tipo_aporte.id_tipoaporte;


--
-- Name: tipo_aportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_aportes (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tipo_aportes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tipo_aportes_id_seq OWNED BY public.tipo_aportes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    nombre character varying(255) CONSTRAINT users_user_name_not_null NOT NULL,
    email character varying(255) NOT NULL,
    rol character varying(255) NOT NULL,
    telefono character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    ci character varying(20),
    activo boolean DEFAULT true NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    ci character varying(20) NOT NULL,
    nombre_completo character varying(150) NOT NULL,
    rol character varying(50) NOT NULL,
    telefono character varying(20),
    hash_contrasena character varying(255) NOT NULL,
    estado character varying(20) DEFAULT 'Activo'::character varying NOT NULL,
    intentos_fallidos integer DEFAULT 0 NOT NULL,
    bloqueado_hasta timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- Name: adopcion id_adopcion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion ALTER COLUMN id_adopcion SET DEFAULT nextval('public.adopcion_id_adopcion_seq'::regclass);


--
-- Name: adopcions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcions ALTER COLUMN id SET DEFAULT nextval('public.adopcions_id_seq'::regclass);


--
-- Name: ajuste_inventario_lotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventario_lotes ALTER COLUMN id SET DEFAULT nextval('public.ajuste_inventario_lotes_id_seq'::regclass);


--
-- Name: ajuste_inventarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventarios ALTER COLUMN id SET DEFAULT nextval('public.ajuste_inventarios_id_seq'::regclass);


--
-- Name: alerta_inventario id_alerta; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_inventario ALTER COLUMN id_alerta SET DEFAULT nextval('public.alerta_inventario_id_alerta_seq'::regclass);


--
-- Name: aporte_dinero id_aporte; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dinero ALTER COLUMN id_aporte SET DEFAULT nextval('public.aporte_dinero_id_aporte_seq'::regclass);


--
-- Name: aporte_dineros id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dineros ALTER COLUMN id SET DEFAULT nextval('public.aporte_dineros_id_seq'::regclass);


--
-- Name: articulo_inventario id_articulo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articulo_inventario ALTER COLUMN id_articulo SET DEFAULT nextval('public.articulo_inventario_id_articulo_seq'::regclass);


--
-- Name: articulo_inventarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articulo_inventarios ALTER COLUMN id SET DEFAULT nextval('public.articulo_inventarios_id_seq'::regclass);


--
-- Name: auditoria_forense id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria_forense ALTER COLUMN id SET DEFAULT nextval('public.auditoria_forense_id_seq'::regclass);


--
-- Name: bitacora id_accion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora ALTER COLUMN id_accion SET DEFAULT nextval('public.bitacora_id_accion_seq'::regclass);


--
-- Name: bitacoras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacoras ALTER COLUMN id SET DEFAULT nextval('public.bitacoras_id_seq'::regclass);


--
-- Name: cierres_periodos_reportes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cierres_periodos_reportes ALTER COLUMN id SET DEFAULT nextval('public.cierres_periodos_reportes_id_seq'::regclass);


--
-- Name: compra id_compra; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_id_compra_seq'::regclass);


--
-- Name: compras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);


--
-- Name: cronograma_tratamientos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cronograma_tratamientos ALTER COLUMN id SET DEFAULT nextval('public.cronograma_tratamientos_id_seq'::regclass);


--
-- Name: detalle_compra id_detallecompra; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compra ALTER COLUMN id_detallecompra SET DEFAULT nextval('public.detalle_compra_id_detallecompra_seq'::regclass);


--
-- Name: detalle_compras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compras ALTER COLUMN id SET DEFAULT nextval('public.detalle_compras_id_seq'::regclass);


--
-- Name: detalle_donacion_insumo id_detalle; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumo ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_donacion_insumo_id_detalle_seq'::regclass);


--
-- Name: detalle_donacion_insumos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumos ALTER COLUMN id SET DEFAULT nextval('public.detalle_donacion_insumos_id_seq'::regclass);


--
-- Name: detalle_facturas_legales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_facturas_legales ALTER COLUMN id SET DEFAULT nextval('public.detalle_facturas_legales_id_seq'::regclass);


--
-- Name: detalle_salida id_detallesalida; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida ALTER COLUMN id_detallesalida SET DEFAULT nextval('public.detalle_salida_id_detallesalida_seq'::regclass);


--
-- Name: detalle_salida_lotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida_lotes ALTER COLUMN id SET DEFAULT nextval('public.detalle_salida_lotes_id_seq'::regclass);


--
-- Name: detalle_salidas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salidas ALTER COLUMN id SET DEFAULT nextval('public.detalle_salidas_id_seq'::regclass);


--
-- Name: donacion id_donacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion ALTER COLUMN id_donacion SET DEFAULT nextval('public.donacion_id_donacion_seq'::regclass);


--
-- Name: donacions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacions ALTER COLUMN id SET DEFAULT nextval('public.donacions_id_seq'::regclass);


--
-- Name: donante id_donante; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donante ALTER COLUMN id_donante SET DEFAULT nextval('public.donante_id_donante_seq'::regclass);


--
-- Name: donantes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donantes ALTER COLUMN id SET DEFAULT nextval('public.donantes_id_seq'::regclass);


--
-- Name: dosificaciones_fiscales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dosificaciones_fiscales ALTER COLUMN id SET DEFAULT nextval('public.dosificaciones_fiscales_id_seq'::regclass);


--
-- Name: evaluacion_idoneidad id_evaluacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluacion_idoneidad ALTER COLUMN id_evaluacion SET DEFAULT nextval('public.evaluacion_idoneidad_id_evaluacion_seq'::regclass);


--
-- Name: facturas_compras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_compras ALTER COLUMN id SET DEFAULT nextval('public.facturas_compras_id_seq'::regclass);


--
-- Name: facturas_legales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_legales ALTER COLUMN id SET DEFAULT nextval('public.facturas_legales_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: historial_clinico id_historial; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinico ALTER COLUMN id_historial SET DEFAULT nextval('public.historial_clinico_id_historial_seq'::regclass);


--
-- Name: historial_clinicos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinicos ALTER COLUMN id SET DEFAULT nextval('public.historial_clinicos_id_seq'::regclass);


--
-- Name: interesado_adopcion id_interesado; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interesado_adopcion ALTER COLUMN id_interesado SET DEFAULT nextval('public.interesado_adopcion_id_interesado_seq'::regclass);


--
-- Name: interesado_adopcions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interesado_adopcions ALTER COLUMN id SET DEFAULT nextval('public.interesado_adopcions_id_seq'::regclass);


--
-- Name: inventario_lotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes ALTER COLUMN id SET DEFAULT nextval('public.inventario_lotes_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: mascota id_mascota; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mascota ALTER COLUMN id_mascota SET DEFAULT nextval('public.mascota_id_mascota_seq'::regclass);


--
-- Name: mascotas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mascotas ALTER COLUMN id SET DEFAULT nextval('public.mascotas_id_seq'::regclass);


--
-- Name: medicamento id_medicamento; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicamento ALTER COLUMN id_medicamento SET DEFAULT nextval('public.medicamento_id_medicamento_seq'::regclass);


--
-- Name: medicamentos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicamentos ALTER COLUMN id SET DEFAULT nextval('public.medicamentos_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: prescripciones_dosificacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescripciones_dosificacion ALTER COLUMN id SET DEFAULT nextval('public.prescripciones_dosificacion_id_seq'::regclass);


--
-- Name: proveedor id_proveedor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);


--
-- Name: proveedors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedors ALTER COLUMN id SET DEFAULT nextval('public.proveedors_id_seq'::regclass);


--
-- Name: rol_permiso id_rol; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol_permiso ALTER COLUMN id_rol SET DEFAULT nextval('public.rol_permiso_id_rol_seq'::regclass);


--
-- Name: salida_inventario id_salida; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventario ALTER COLUMN id_salida SET DEFAULT nextval('public.salida_inventario_id_salida_seq'::regclass);


--
-- Name: salida_inventarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventarios ALTER COLUMN id SET DEFAULT nextval('public.salida_inventarios_id_seq'::regclass);


--
-- Name: seguimiento_adopcion id_seguimiento; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcion ALTER COLUMN id_seguimiento SET DEFAULT nextval('public.seguimiento_adopcion_id_seguimiento_seq'::regclass);


--
-- Name: seguimiento_adopcions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcions ALTER COLUMN id SET DEFAULT nextval('public.seguimiento_adopcions_id_seq'::regclass);


--
-- Name: tipo_aporte id_tipoaporte; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_aporte ALTER COLUMN id_tipoaporte SET DEFAULT nextval('public.tipo_aporte_id_tipoaporte_seq'::regclass);


--
-- Name: tipo_aportes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_aportes ALTER COLUMN id SET DEFAULT nextval('public.tipo_aportes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- Data for Name: adopcion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.adopcion (id_adopcion, id_mascota, id_interesado, fecha_adopcion, created_at, updated_at) FROM stdin;
1	1	1	2026-08-04	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	2	2	2026-08-05	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	3	3	2026-08-06	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	4	4	2026-08-07	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	5	5	2026-08-08	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	6	6	2026-08-09	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	7	7	2026-08-10	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	8	8	2026-08-11	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	9	9	2026-08-12	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	10	10	2026-08-13	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	11	11	2026-08-14	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	12	12	2026-08-15	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	13	13	2026-08-16	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	14	14	2026-08-17	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	15	15	2026-08-18	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	16	16	2026-08-19	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	17	17	2026-08-20	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	18	18	2026-08-21	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	19	19	2026-08-22	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	20	20	2026-08-23	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	21	21	2026-08-24	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	22	22	2026-08-25	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	23	23	2026-08-26	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	24	24	2026-08-27	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	25	25	2026-08-28	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	26	26	2026-08-29	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	27	27	2026-08-30	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	28	28	2026-08-31	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	29	29	2026-09-01	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	30	30	2026-09-02	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	31	31	2026-09-03	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	32	32	2026-09-04	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	33	33	2026-09-05	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	34	34	2026-09-06	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	35	35	2026-09-07	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	36	36	2026-09-08	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	37	37	2026-09-09	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	38	38	2026-09-10	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	39	39	2026-09-11	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	40	40	2026-09-12	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	41	41	2026-09-13	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	42	42	2026-09-14	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	43	43	2026-09-15	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	44	44	2026-09-16	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	45	45	2026-09-17	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	46	46	2026-09-18	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	47	47	2026-09-19	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	48	48	2026-09-20	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	49	49	2026-09-21	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	50	50	2026-09-22	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: adopcions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.adopcions (id, fecha_adopcion, id_interesado, id_mascota, created_at, updated_at) FROM stdin;
1	2026-02-01	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	2026-03-07	3	4	2026-11-01 18:17:19	2026-11-01 18:17:19
3	2026-08-06	3	3	2026-11-01 14:00:13	2026-11-01 14:00:13
4	2026-08-07	4	4	2026-11-01 14:00:13	2026-11-01 14:00:13
5	2026-08-08	5	5	2026-11-01 14:00:13	2026-11-01 14:00:13
6	2026-08-09	6	6	2026-11-01 14:00:13	2026-11-01 14:00:13
7	2026-08-10	7	7	2026-11-01 14:00:13	2026-11-01 14:00:13
8	2026-08-11	8	8	2026-11-01 14:00:13	2026-11-01 14:00:13
9	2026-08-12	9	9	2026-11-01 14:00:13	2026-11-01 14:00:13
10	2026-08-13	10	10	2026-11-01 14:00:13	2026-11-01 14:00:13
11	2026-08-14	11	11	2026-11-01 14:00:13	2026-11-01 14:00:13
12	2026-08-15	12	12	2026-11-01 14:00:13	2026-11-01 14:00:13
13	2026-08-16	13	13	2026-11-01 14:00:13	2026-11-01 14:00:13
14	2026-08-17	14	14	2026-11-01 14:00:13	2026-11-01 14:00:13
15	2026-08-18	15	15	2026-11-01 14:00:13	2026-11-01 14:00:13
16	2026-08-19	16	16	2026-11-01 14:00:13	2026-11-01 14:00:13
17	2026-08-20	17	17	2026-11-01 14:00:13	2026-11-01 14:00:13
18	2026-08-21	18	18	2026-11-01 14:00:13	2026-11-01 14:00:13
19	2026-08-22	19	19	2026-11-01 14:00:13	2026-11-01 14:00:13
20	2026-08-23	20	20	2026-11-01 14:00:13	2026-11-01 14:00:13
21	2026-08-24	21	21	2026-11-01 14:00:13	2026-11-01 14:00:13
22	2026-08-25	22	22	2026-11-01 14:00:13	2026-11-01 14:00:13
23	2026-08-26	23	23	2026-11-01 14:00:13	2026-11-01 14:00:13
24	2026-08-27	24	24	2026-11-01 14:00:13	2026-11-01 14:00:13
25	2026-08-28	25	25	2026-11-01 14:00:13	2026-11-01 14:00:13
26	2026-08-29	26	26	2026-11-01 14:00:13	2026-11-01 14:00:13
27	2026-08-30	27	27	2026-11-01 14:00:13	2026-11-01 14:00:13
28	2026-08-31	28	28	2026-11-01 14:00:13	2026-11-01 14:00:13
29	2026-09-01	29	29	2026-11-01 14:00:13	2026-11-01 14:00:13
30	2026-09-02	30	30	2026-11-01 14:00:13	2026-11-01 14:00:13
31	2026-09-03	31	31	2026-11-01 14:00:13	2026-11-01 14:00:13
32	2026-09-04	32	32	2026-11-01 14:00:13	2026-11-01 14:00:13
33	2026-09-05	33	33	2026-11-01 14:00:13	2026-11-01 14:00:13
34	2026-09-06	34	34	2026-11-01 14:00:13	2026-11-01 14:00:13
35	2026-09-07	35	35	2026-11-01 14:00:13	2026-11-01 14:00:13
36	2026-09-08	36	36	2026-11-01 14:00:13	2026-11-01 14:00:13
37	2026-09-09	37	37	2026-11-01 14:00:13	2026-11-01 14:00:13
38	2026-09-10	38	38	2026-11-01 14:00:13	2026-11-01 14:00:13
39	2026-09-11	39	39	2026-11-01 14:00:13	2026-11-01 14:00:13
40	2026-09-12	40	40	2026-11-01 14:00:13	2026-11-01 14:00:13
41	2026-09-13	41	41	2026-11-01 14:00:13	2026-11-01 14:00:13
42	2026-09-14	42	42	2026-11-01 14:00:13	2026-11-01 14:00:13
43	2026-09-15	43	43	2026-11-01 14:00:13	2026-11-01 14:00:13
44	2026-09-16	44	44	2026-11-01 14:00:13	2026-11-01 14:00:13
45	2026-09-17	45	45	2026-11-01 14:00:13	2026-11-01 14:00:13
46	2026-09-18	46	46	2026-11-01 14:00:13	2026-11-01 14:00:13
47	2026-09-19	47	47	2026-11-01 14:00:13	2026-11-01 14:00:13
48	2026-09-20	48	48	2026-11-01 14:00:13	2026-11-01 14:00:13
49	2026-09-21	49	49	2026-11-01 14:00:13	2026-11-01 14:00:13
50	2026-09-22	50	50	2026-11-01 14:00:13	2026-11-01 14:00:13
51	2026-11-21	29	27	2026-11-21 10:36:58	2026-11-21 10:36:58
52	2026-11-21	60	38	2026-11-21 10:40:09	2026-11-21 10:40:09
\.


--
-- Data for Name: ajuste_inventario_lotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ajuste_inventario_lotes (id, id_ajuste_inventario, id_inventario_lote, cantidad) FROM stdin;
1	1	6	9.00
2	2	7	6.00
3	3	8	1.00
4	4	9	5.00
5	5	10	9.00
6	6	12	9.00
7	7	13	9.00
8	8	14	6.00
9	1	15	10.00
10	2	16	10.00
\.


--
-- Data for Name: ajuste_inventarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ajuste_inventarios (id, id_articulo, id_usuario, usuario_nombre, cantidad, stock_anterior, stock_nuevo, saldo_disponible_anterior, saldo_disponible_nuevo, motivo, created_at, updated_at) FROM stdin;
1	24	1	Carlos Eduardo Mendoza	3	110.00	107.00	11000.00	10700.00	Rotura accidental de frascos de suspensión de vidrio en el gabinete médico B.	2026-11-02 03:34:42	2026-11-02 03:34:42
2	34	1	Carlos Eduardo Mendoza	2	150.00	148.00	15000.00	14800.00	Fisura en envase plástico durante la descarga de proveedores con pérdida de líquido.	2026-11-02 03:34:42	2026-11-02 03:34:42
3	12	1	Carlos Eduardo Mendoza	4	180.00	176.00	18000.00	17600.00	Quiebre de cadena de frío en refrigerador secundario por corte de energía nocturno.	2026-11-02 03:34:42	2026-11-02 03:34:42
4	6	1	Carlos Eduardo Mendoza	1	35.00	34.00	3500.00	3400.00	Bolsa rasgada por humedad en el depósito lateral, alimento no apto para consumo.	2026-11-02 03:34:42	2026-11-02 03:34:42
5	32	1	Carlos Eduardo Mendoza	5	75.00	70.00	7500.00	7000.00	Lote con sello de esterilidad comprometido detectado en la inspección de almacén.	2026-11-02 03:34:42	2026-11-02 03:34:42
6	103	1	Carlos Eduardo Mendoza	2	95.00	93.00	9500.00	9300.00	Frascos expirados con fecha de vencimiento cumplida en el botiquín de triaje.	2026-11-02 03:34:42	2026-11-02 03:34:42
7	46	1	Carlos Eduardo Mendoza	1	100.00	99.00	10000.00	9900.00	Caja contaminada por derrame de tintura de yodo en área de esterilización.	2026-11-02 03:34:42	2026-11-02 03:34:42
8	60	1	Carlos Eduardo Mendoza	3	28.00	25.00	2800.00	2500.00	Blíster deteriorado y cápsulas desintegradas por exposición térmica.	2026-11-02 03:34:42	2026-11-02 03:34:42
\.


--
-- Data for Name: alerta_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alerta_inventario (id_alerta, id_articulo, nivel_criticidad, fecha_generada, estado) FROM stdin;
1	1	Advertencia	2026-10-30 14:00:12.780728	Atendida
2	2	Agotado	2026-10-28 14:00:12.780728	Descartada
3	3	Critico	2026-10-26 14:00:12.780728	Pendiente
4	4	Advertencia	2026-10-24 14:00:12.780728	Atendida
5	5	Agotado	2026-10-22 14:00:12.780728	Descartada
6	6	Critico	2026-10-20 14:00:12.780728	Pendiente
7	7	Advertencia	2026-10-18 14:00:12.780728	Atendida
8	8	Agotado	2026-10-16 14:00:12.780728	Descartada
9	9	Critico	2026-10-14 14:00:12.780728	Pendiente
10	10	Advertencia	2026-10-12 14:00:12.780728	Atendida
11	11	Agotado	2026-10-10 14:00:12.780728	Descartada
12	12	Critico	2026-10-08 14:00:12.780728	Pendiente
13	13	Advertencia	2026-10-06 14:00:12.780728	Atendida
14	14	Agotado	2026-10-04 14:00:12.780728	Descartada
15	15	Critico	2026-10-02 14:00:12.780728	Pendiente
16	16	Advertencia	2026-09-30 14:00:12.780728	Atendida
17	17	Agotado	2026-09-28 14:00:12.780728	Descartada
18	18	Critico	2026-09-26 14:00:12.780728	Pendiente
19	19	Advertencia	2026-09-24 14:00:12.780728	Atendida
20	20	Agotado	2026-09-22 14:00:12.780728	Descartada
21	21	Critico	2026-09-20 14:00:12.780728	Pendiente
22	22	Advertencia	2026-09-18 14:00:12.780728	Atendida
23	23	Agotado	2026-09-16 14:00:12.780728	Descartada
24	24	Critico	2026-09-14 14:00:12.780728	Pendiente
25	25	Advertencia	2026-09-12 14:00:12.780728	Atendida
26	26	Agotado	2026-09-10 14:00:12.780728	Descartada
27	27	Critico	2026-09-08 14:00:12.780728	Pendiente
28	28	Advertencia	2026-09-06 14:00:12.780728	Atendida
29	29	Agotado	2026-09-04 14:00:12.780728	Descartada
30	30	Critico	2026-11-01 14:00:12.780728	Pendiente
31	31	Advertencia	2026-10-30 14:00:12.780728	Atendida
32	32	Agotado	2026-10-28 14:00:12.780728	Descartada
33	33	Critico	2026-10-26 14:00:12.780728	Pendiente
34	34	Advertencia	2026-10-24 14:00:12.780728	Atendida
35	35	Agotado	2026-10-22 14:00:12.780728	Descartada
36	36	Critico	2026-10-20 14:00:12.780728	Pendiente
37	37	Advertencia	2026-10-18 14:00:12.780728	Atendida
38	38	Agotado	2026-10-16 14:00:12.780728	Descartada
39	39	Critico	2026-10-14 14:00:12.780728	Pendiente
40	40	Advertencia	2026-10-12 14:00:12.780728	Atendida
41	41	Agotado	2026-10-10 14:00:12.780728	Descartada
42	42	Critico	2026-10-08 14:00:12.780728	Pendiente
43	43	Advertencia	2026-10-06 14:00:12.780728	Atendida
44	44	Agotado	2026-10-04 14:00:12.780728	Descartada
45	45	Critico	2026-10-02 14:00:12.780728	Pendiente
46	46	Advertencia	2026-09-30 14:00:12.780728	Atendida
47	47	Agotado	2026-09-28 14:00:12.780728	Descartada
48	48	Critico	2026-09-26 14:00:12.780728	Pendiente
49	49	Advertencia	2026-09-24 14:00:12.780728	Atendida
50	50	Agotado	2026-09-22 14:00:12.780728	Descartada
\.


--
-- Data for Name: aporte_dinero; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.aporte_dinero (id_aporte, id_donacion, monto, fecha_recepcion, comprobante, observaciones) FROM stdin;
1	1	100.00	2026-07-05	REC-2026-0001	Donación procesada mediante pasarela bancaria con código QR BCP
2	2	150.00	2026-07-06	REC-2026-0002	Aporte para cirugías de esterilización de campaña comunitaria
3	3	200.00	2026-07-07	REC-2026-0003	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
4	4	250.00	2026-07-08	REC-2026-0004	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
5	5	300.00	2026-07-09	REC-2026-0005	Aporte en efectivo entregado en caja de recepción para compra de alimento
6	6	500.00	2026-07-10	REC-2026-0006	Donación procesada mediante pasarela bancaria con código QR BCP
7	7	750.00	2026-07-11	REC-2026-0007	Aporte para cirugías de esterilización de campaña comunitaria
8	8	1000.00	2026-07-12	REC-2026-0008	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
9	9	1500.00	2026-07-13	REC-2026-0009	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
10	10	2000.00	2026-07-14	REC-2026-0010	Aporte en efectivo entregado en caja de recepción para compra de alimento
11	11	50.00	2026-07-15	REC-2026-0011	Donación procesada mediante pasarela bancaria con código QR BCP
12	12	100.00	2026-07-16	REC-2026-0012	Aporte para cirugías de esterilización de campaña comunitaria
13	13	150.00	2026-07-17	REC-2026-0013	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
14	14	200.00	2026-07-18	REC-2026-0014	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
15	15	250.00	2026-07-19	REC-2026-0015	Aporte en efectivo entregado en caja de recepción para compra de alimento
16	16	300.00	2026-07-20	REC-2026-0016	Donación procesada mediante pasarela bancaria con código QR BCP
17	17	500.00	2026-07-21	REC-2026-0017	Aporte para cirugías de esterilización de campaña comunitaria
18	18	750.00	2026-07-22	REC-2026-0018	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
19	19	1000.00	2026-07-23	REC-2026-0019	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
20	20	1500.00	2026-07-24	REC-2026-0020	Aporte en efectivo entregado en caja de recepción para compra de alimento
21	21	2000.00	2026-07-25	REC-2026-0021	Donación procesada mediante pasarela bancaria con código QR BCP
22	22	50.00	2026-07-26	REC-2026-0022	Aporte para cirugías de esterilización de campaña comunitaria
23	23	100.00	2026-07-27	REC-2026-0023	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
24	24	150.00	2026-07-28	REC-2026-0024	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
25	25	200.00	2026-07-29	REC-2026-0025	Aporte en efectivo entregado en caja de recepción para compra de alimento
26	26	250.00	2026-07-30	REC-2026-0026	Donación procesada mediante pasarela bancaria con código QR BCP
27	27	300.00	2026-07-31	REC-2026-0027	Aporte para cirugías de esterilización de campaña comunitaria
28	28	500.00	2026-08-01	REC-2026-0028	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
29	29	750.00	2026-08-02	REC-2026-0029	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
30	30	1000.00	2026-08-03	REC-2026-0030	Aporte en efectivo entregado en caja de recepción para compra de alimento
31	31	1500.00	2026-08-04	REC-2026-0031	Donación procesada mediante pasarela bancaria con código QR BCP
32	32	2000.00	2026-08-05	REC-2026-0032	Aporte para cirugías de esterilización de campaña comunitaria
33	33	50.00	2026-08-06	REC-2026-0033	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
34	34	100.00	2026-08-07	REC-2026-0034	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
35	35	150.00	2026-08-08	REC-2026-0035	Aporte en efectivo entregado en caja de recepción para compra de alimento
36	36	200.00	2026-08-09	REC-2026-0036	Donación procesada mediante pasarela bancaria con código QR BCP
37	37	250.00	2026-08-10	REC-2026-0037	Aporte para cirugías de esterilización de campaña comunitaria
38	38	300.00	2026-08-11	REC-2026-0038	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
39	39	500.00	2026-08-12	REC-2026-0039	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
40	40	750.00	2026-08-13	REC-2026-0040	Aporte en efectivo entregado en caja de recepción para compra de alimento
41	41	1000.00	2026-08-14	REC-2026-0041	Donación procesada mediante pasarela bancaria con código QR BCP
42	42	1500.00	2026-08-15	REC-2026-0042	Aporte para cirugías de esterilización de campaña comunitaria
43	43	2000.00	2026-08-16	REC-2026-0043	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
44	44	50.00	2026-08-17	REC-2026-0044	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
45	45	100.00	2026-08-18	REC-2026-0045	Aporte en efectivo entregado en caja de recepción para compra de alimento
46	46	150.00	2026-08-19	REC-2026-0046	Donación procesada mediante pasarela bancaria con código QR BCP
47	47	200.00	2026-08-20	REC-2026-0047	Aporte para cirugías de esterilización de campaña comunitaria
48	48	250.00	2026-08-21	REC-2026-0048	Transferencia interbancaria BNB para medicamentos de cuidados intensivos
49	49	300.00	2026-08-22	REC-2026-0049	Donación voluntaria de adoptante en agradecimiento por entrega de mascota
50	50	500.00	2026-08-23	REC-2026-0050	Aporte en efectivo entregado en caja de recepción para compra de alimento
\.


--
-- Data for Name: aporte_dineros; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.aporte_dineros (id, monto, fecha_recepcion, comprobante, observaciones, id_donacion, created_at, updated_at) FROM stdin;
3	250.00	2026-10-19	CAJA-EFEC-2026-001	Donación en efectivo en recepción para alimentación de cachorros rescatados.	81	2026-11-02 03:36:39	2026-11-02 03:36:39
4	180.00	2026-10-21	CAJA-EFEC-2026-002	Aporte voluntario en efectivo por cuota de recuperación de esterilización y vacunación.	82	2026-11-02 03:36:39	2026-11-02 03:36:39
5	500.00	2026-10-23	CAJA-EFEC-2026-003	Donación en ventanilla para compra urgente de antibióticos y analgésicos de casos críticos.	83	2026-11-02 03:36:39	2026-11-02 03:36:39
6	320.00	2026-10-25	CAJA-EFEC-2026-004	Recaudación de alcancía solidaria en efectivo de la jornada dominical de adopción.	84	2026-11-02 03:36:39	2026-11-02 03:36:39
7	150.00	2026-10-27	CAJA-EFEC-2026-005	Aporte en caja directa de padrino para mantenimiento y desparasitación mensual.	85	2026-11-02 03:36:39	2026-11-02 03:36:39
8	400.00	2026-10-29	CAJA-EFEC-2026-006	Donación en efectivo para cubrir radiografías y yeso traumatológico de rescate de emergencia.	86	2026-11-02 03:36:39	2026-11-02 03:36:39
9	200.00	2026-10-31	CAJA-EFEC-2026-007	Contribución solidaria en ventanilla de visitante para insumos de limpieza y desinfección.	87	2026-11-02 03:36:39	2026-11-02 03:36:39
10	350.00	2026-11-01	CAJA-EFEC-2026-008	Aporte en efectivo de familia adoptante como fondo de auxilio médico para nuevos rescates.	88	2026-11-02 03:36:39	2026-11-02 03:36:39
11	120.00	2026-10-30	STK-QR-2026-901	Canal: QR | Estado: Confirmado | Concepto: Donación Solidaria Simple QR Campaña Vacunación	89	2026-11-02 03:40:36	2026-11-02 03:40:36
12	300.00	2026-11-01	STK-QR-2026-902	Canal: QR | Estado: Confirmado | Concepto: Aporte QR Apadrinamiento Max | Ref Banco: BCP-QR-889921	90	2026-11-02 03:40:36	2026-11-02 03:40:36
13	35.50	2026-11-04	TXN-0BUR3TSQTB	Canal: Tarjeta (Stripe Sandbox) | Estado: Reembolsado | Concepto: Alimento balanceado mascotas | Stripe ID: pi_3UXv1S63IwbkhSOn0OiEOZzW | Stripe Status: succeeded | Justificación Reembolso: Prueba de anulación y reembolso en Stripe Sandbox | Stripe Refund ID: re_3UXv1S63IwbkhSOn0Qycv1Et	91	2026-11-04 03:38:01	2026-11-04 03:38:06
14	100.00	2026-11-04	TXN-NI5RJ3IPBO	Canal: QR | Estado: Confirmado | Concepto: Donación de apoyo a alimentación	92	2026-11-04 03:52:55	2026-11-04 03:53:12
15	500.00	2026-11-16	DON-WEB-20261116202431-694	Donación online Mensual (Recurrente) | Estado: Confirmado | Donante: angel (anjelradio@gmail.com)	93	2026-11-16 20:24:31	2026-11-16 20:24:31
16	100.00	2026-11-19	TXN-8FPOVSA2EM	Canal: QR | Estado: Confirmado | Concepto: Donación de apoyo a alimentación	94	2026-11-19 14:46:51	2026-11-19 14:47:24
\.


--
-- Data for Name: articulo_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.articulo_inventario (id_articulo, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at) FROM stdin;
1	Alimento Dog Chow Adulto 20kg	Alimento	Bolsa	150.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	Alimento Dog Chow Cachorro 15kg	Alimento	Bolsa	120.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	Alimento Pro Plan Adulto Raza Mediana 18kg	Alimento	Bolsa	80.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	Alimento Whiskas Carne Adulto 10kg	Alimento	Bolsa	110.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	Alimento Medicado Gastrointestinal Canino 10kg	Alimento	Bolsa	40.00	8.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	Latas Paté Pollo para Perro Convaleciente 400g	Alimento	Lata	250.00	30.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	Sobres Alimento Húmedo Whiskas Salmón 85g	Alimento	Sobre	400.00	50.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	Leche Maternizada Canina KMR en Polvo 500g	Alimento	Pote	60.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	Leche Maternizada Felina PetLac 400g	Alimento	Pote	55.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	Vacuna Puppy DP para Cachorros	Vacuna	Dosis	130.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	Vacuna Triple Felina Felocell 3	Vacuna	Dosis	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	Vacuna Antirrábica Rabisin 1ml	Vacuna	Dosis	300.00	40.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	Desparasitante Total F Canino (Tabletas)	Medicamento	Tableta	500.00	50.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	Desparasitante Pediátrico en Suspensión 60ml	Medicamento	Frasco	85.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	Pipeta Fipronil Antipulgas Perro 10-20kg	Medicamento	Pipeta	160.00	25.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	Pipeta Fipronil Antipulgas Gato	Medicamento	Pipeta	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	Tableta Nexgard Spectra 15-30kg	Medicamento	Tableta	90.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	Tableta Bravecto Antiparasitario 20-40kg	Medicamento	Tableta	75.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	Antibiótico Ceftriaxona 1g Polvo Inyectable	Medicamento	Frasco	120.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	Antibiótico Enrofloxacina 10% Inyectable 100ml	Medicamento	Frasco	65.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	Antiinflamatorio Meloxicam 0.5% Inyectable 50ml	Medicamento	Frasco	70.00	12.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	Dexametasona 2mg/ml Inyectable 50ml	Medicamento	Frasco	80.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	Suero Fisiológico al 0.9% 500ml	Medicamento	Bolsa	320.00	40.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	Suero Ringer Lactato 500ml	Medicamento	Bolsa	280.00	35.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	Complejo B Inyectable Hematopoyético 100ml	Medicamento	Frasco	95.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	Tramadol Gotas Analgésico 20ml	Medicamento	Frasco	60.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	Curabichera Plata Aerosol Cicatrizante 400ml	Medicamento	Frasco	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	Yodopovidona Solución Tópica al 10% 1 Litro	Medicamento	Frasco	80.00	12.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	Algodón Hidrófilo en Rollo 500g	Limpieza	Paquete	90.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	Gasas Estériles Hospitalarias 10x10cm (Caja 100)	Limpieza	Caja	130.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	Vendas Elásticas Cambric 10cm x 5m	Limpieza	Unidad	200.00	30.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	Jeringas Descartables 3ml con Aguja (Caja 100)	Limpieza	Caja	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	Jeringas Descartables 5ml con Aguja (Caja 100)	Limpieza	Caja	120.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	Catéteres Intravenosos 22G Jelco (Caja 50)	Limpieza	Caja	70.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	Lavandina Concentrada al 5.5% Bidón 5 Litros	Limpieza	Bidón	85.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	Detergente Industrial Multiuso en Polvo 10kg	Limpieza	Bolsa	90.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	Desinfectante Amonio Cuaternario 5ta Gen. 5L	Limpieza	Bidón	60.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	Arena Sanitaria Aglomerante para Gatos 10kg	Limpieza	Bolsa	160.00	25.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	Bolsas Plásticas Gruesas para Residuos 100L	Limpieza	Paquete	110.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	Collares Isabelinos de Protección Talle 3-5	Accesorio	Unidad	75.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	Platos Dobles de Acero Inoxidable para Perro	Accesorio	Unidad	120.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	Correas Resistentes de Paseo Nylon 2m	Accesorio	Unidad	85.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	Mantas Térmicas Acolchadas Lavables	Accesorio	Unidad	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
52	Penicilina G Benzatínica + Procaínica 6.000.000 UI	Medicamento	Frasco Ampolla	30.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
54	Oxitetraciclina L.A. 200mg/ml Inyectable 100ml	Medicamento	Frasco 100ml	25.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
55	Ampicilina + Sulbactam 1.5g Inyectable	Medicamento	Vial	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
56	Gentamicina Sulfato 10% Inyectable 100ml	Medicamento	Frasco 100ml	20.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
57	Amoxicilina L.A. 15% Suspensión Inyectable 100ml	Medicamento	Frasco 100ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
58	Cefalotina Sódica 1g Polvo Inyectable	Medicamento	Vial	55.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
59	Metronidazol 500mg/100ml Solución para Infusión	Medicamento	Frasco 100ml	35.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
62	Meloxicam 2% Inyectable 50ml	Medicamento	Frasco 50ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
63	Ketoprofeno 1% Inyectable 20ml	Medicamento	Frasco 20ml	42.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
64	Carprofeno Inyectable 50mg/ml 20ml	Medicamento	Frasco 20ml	35.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
65	Dipirona (Metamizol) 50% Inyectable 50ml	Medicamento	Frasco 50ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
66	Tramadol Clorhidrato 50mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	65.00	12.00	2026-11-02 02:45:24	2026-11-02 02:45:24
67	Fentanilo Citrato 0.05mg/ml Ampolla 10ml	Medicamento	Ampolla 10ml	24.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
24	Amoxicilina + Ácido Clavulánico 500mg Comp.	Medicamento	Caja	107.00	15.00	2026-11-01 14:00:12.780728	2026-11-02 03:34:42
34	Alcohol Medicinal al 70% 1 Litro	Limpieza	Botella	148.00	20.00	2026-11-01 14:00:12.780728	2026-11-02 03:34:42
12	Vacuna Óctuple Vanguard Plus 5/L	Vacuna	Dosis	176.00	25.00	2026-11-01 14:00:12.780728	2026-11-02 03:34:42
6	Alimento Medicado Renal Royal Canin 7.5kg	Alimento	Bolsa	34.00	5.00	2026-11-01 14:00:12.780728	2026-11-02 03:34:42
32	Solución Clorhexidina al 2% para Heridas 1 Litro	Medicamento	Frasco	70.00	10.00	2026-11-01 14:00:12.780728	2026-11-02 03:34:42
46	Guantes Quirúrgicos de Látex Talle M (Caja 100)	Limpieza	Caja	99.00	15.00	2026-11-01 14:00:12.780728	2026-11-02 03:34:42
60	Doxiciclina Inyectable 50mg/ml 50ml	Medicamento	Frasco 50ml	25.00	6.00	2026-11-02 02:45:24	2026-11-02 03:34:42
4	Lavandina Concentrada 5L	Limpieza	Bidón	14.00	4.00	2026-11-01 14:00:12.780728	2026-11-21 10:44:30
68	Morfina Clorhidrato 10mg/ml Ampolla 1ml	Medicamento	Ampolla 1ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
69	Butorfanol Tartrato 10mg/ml Inyectable 10ml	Medicamento	Vial 10ml	20.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
70	Flunixin Meglumina 5% Inyectable 50ml	Medicamento	Frasco 50ml	22.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
71	Betametasona Dipropionato 4mg/ml Inyectable	Medicamento	Ampolla 5ml	35.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
72	Prednisolona Acetato 10mg/ml Suspensión Inyectable	Medicamento	Frasco 20ml	28.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
73	Difenhidramina Clorhidrato 10mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	45.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
74	Ketamina Clorhidrato 10% (100mg/ml) Inyectable 50ml	Medicamento	Frasco 50ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
75	Xilacina 2% Inyectable 30ml	Medicamento	Frasco 30ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
76	Propofol 1% (10mg/ml) Emulsión Inyectable 20ml	Medicamento	Ampolla 20ml	38.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
77	Midazolam 5mg/ml Inyectable 10ml	Medicamento	Vial 10ml	30.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
78	Diazepam 5mg/ml Inyectable Ampolla 2ml	Medicamento	Ampolla 2ml	60.00	15.00	2026-11-02 02:45:24	2026-11-02 02:45:24
79	Acepromacina 1% Inyectable 20ml	Medicamento	Frasco 20ml	25.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
80	Atropina Sulfato 1% Inyectable 20ml	Medicamento	Frasco 20ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
81	Lidocaína Clorhidrato 2% Inyectable 100ml	Medicamento	Frasco 100ml	35.00	7.00	2026-11-02 02:45:24	2026-11-02 02:45:24
82	Doramectina 1% Inyectable 50ml	Medicamento	Frasco 50ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
83	Imidocarb Dipropionato 12% Inyectable 20ml	Medicamento	Frasco 20ml	20.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
84	Levamisol Clorhidrato 10% Inyectable 100ml	Medicamento	Frasco 100ml	22.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
87	Dextrosa al 5% en Solución Salina 500ml	Medicamento	Bolsa 500ml	75.00	15.00	2026-11-02 02:45:24	2026-11-02 02:45:24
88	Ranitidina Clorhidrato 25mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
89	Omeprazol Sódico 40mg Polvo Liofilizado Inyectable	Medicamento	Vial	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
90	Ondansetrón 2mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
91	Metoclopramida Clorhidrato 5mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
92	Maropitant (Cerenia) 10mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
94	Vitamina K1 (Fitomenadiona) 10mg/ml Inyectable Ampolla 2ml	Medicamento	Ampolla 2ml	50.00	12.00	2026-11-02 02:45:24	2026-11-02 02:45:24
95	Calcio Borogluconato con Magnesio Inyectable 100ml	Medicamento	Frasco 100ml	30.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
96	Dextrano Férrico 100mg/ml Inyectable 50ml	Medicamento	Frasco 50ml	35.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
97	Aminoácidos + Electrolitos Reconstituyente 500ml	Medicamento	Frasco 500ml	45.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
99	Vacuna Séxtuple Canina Inyectable (DHPPi+L)	Medicamento	Dosis 1ml	130.00	25.00	2026-11-02 02:45:24	2026-11-02 02:45:24
101	Suero Hiperinmune Anticanino Polivalente Inyectable 10ml	Medicamento	Frasco 10ml	40.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
104	Doxiciclina 100mg Comprimidos Ranurados	Medicamento	Caja	110.00	25.00	2026-11-02 02:46:08	2026-11-02 02:46:08
105	Meloxicam 1mg Comprimidos Masticables Palatables	Medicamento	Caja	80.00	15.00	2026-11-02 02:46:08	2026-11-02 02:46:08
106	Prednisona 20mg Comprimidos	Medicamento	Caja	70.00	12.00	2026-11-02 02:46:08	2026-11-02 02:46:08
107	Fenbendazol 500mg Comprimidos Desparasitante	Medicamento	Caja	140.00	30.00	2026-11-02 02:46:08	2026-11-02 02:46:08
108	Silimarina + Complejo Hepático 100mg Cápsulas	Medicamento	Frasco	55.00	10.00	2026-11-02 02:46:08	2026-11-02 02:46:08
103	Cefalexina 500mg Comprimidos Palatables	Medicamento	Caja	93.00	20.00	2026-11-02 02:46:08	2026-11-02 03:34:42
\.


--
-- Data for Name: articulo_inventarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.articulo_inventarios (id, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at) FROM stdin;
1	Croquetas Adulto Dog Chow 15kg	Alimento	Bolsa	25.00	5.00	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Cat Chow Gatitos 8kg	Alimento	Bolsa	12.00	3.00	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Ivermectina 1% Inyectable 50ml	Medicamento	Frasco	8.00	2.00	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Jeringas Descartables 3ml	Insumo Médico	Unidad	150.00	30.00	2026-11-01 18:17:19	2026-11-01 18:17:19
7	Alimento Medicado Gastrointestinal Canino 10kg	Alimento	Bolsa	40.00	8.00	2026-11-01 14:00:13	2026-11-01 14:00:13
8	Latas Paté Pollo para Perro Convaleciente 400g	Alimento	Lata	250.00	30.00	2026-11-01 14:00:13	2026-11-01 14:00:13
9	Sobres Alimento Húmedo Whiskas Salmón 85g	Alimento	Sobre	400.00	50.00	2026-11-01 14:00:13	2026-11-01 14:00:13
10	Leche Maternizada Canina KMR en Polvo 500g	Alimento	Pote	60.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
11	Leche Maternizada Felina PetLac 400g	Alimento	Pote	55.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
13	Vacuna Puppy DP para Cachorros	Vacuna	Dosis	130.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
14	Vacuna Triple Felina Felocell 3	Vacuna	Dosis	140.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
15	Vacuna Antirrábica Rabisin 1ml	Vacuna	Dosis	300.00	40.00	2026-11-01 14:00:13	2026-11-01 14:00:13
16	Desparasitante Total F Canino (Tabletas)	Medicamento	Tableta	500.00	50.00	2026-11-01 14:00:13	2026-11-01 14:00:13
17	Desparasitante Pediátrico en Suspensión 60ml	Medicamento	Frasco	85.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
18	Pipeta Fipronil Antipulgas Perro 10-20kg	Medicamento	Pipeta	160.00	25.00	2026-11-01 14:00:13	2026-11-01 14:00:13
19	Pipeta Fipronil Antipulgas Gato	Medicamento	Pipeta	140.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
20	Tableta Nexgard Spectra 15-30kg	Medicamento	Tableta	90.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
21	Tableta Bravecto Antiparasitario 20-40kg	Medicamento	Tableta	75.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
22	Antibiótico Ceftriaxona 1g Polvo Inyectable	Medicamento	Frasco	120.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
23	Antibiótico Enrofloxacina 10% Inyectable 100ml	Medicamento	Frasco	65.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
25	Antiinflamatorio Meloxicam 0.5% Inyectable 50ml	Medicamento	Frasco	70.00	12.00	2026-11-01 14:00:13	2026-11-01 14:00:13
26	Dexametasona 2mg/ml Inyectable 50ml	Medicamento	Frasco	80.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
27	Suero Fisiológico al 0.9% 500ml	Medicamento	Bolsa	320.00	40.00	2026-11-01 14:00:13	2026-11-01 14:00:13
28	Suero Ringer Lactato 500ml	Medicamento	Bolsa	280.00	35.00	2026-11-01 14:00:13	2026-11-01 14:00:13
29	Complejo B Inyectable Hematopoyético 100ml	Medicamento	Frasco	95.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
30	Tramadol Gotas Analgésico 20ml	Medicamento	Frasco	60.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
31	Curabichera Plata Aerosol Cicatrizante 400ml	Medicamento	Frasco	140.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
33	Yodopovidona Solución Tópica al 10% 1 Litro	Medicamento	Frasco	80.00	12.00	2026-11-01 14:00:13	2026-11-01 14:00:13
35	Algodón Hidrófilo en Rollo 500g	Limpieza	Paquete	90.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
36	Gasas Estériles Hospitalarias 10x10cm (Caja 100)	Limpieza	Caja	130.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
37	Vendas Elásticas Cambric 10cm x 5m	Limpieza	Unidad	200.00	30.00	2026-11-01 14:00:13	2026-11-01 14:00:13
38	Jeringas Descartables 3ml con Aguja (Caja 100)	Limpieza	Caja	140.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
39	Jeringas Descartables 5ml con Aguja (Caja 100)	Limpieza	Caja	120.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
40	Catéteres Intravenosos 22G Jelco (Caja 50)	Limpieza	Caja	70.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
41	Lavandina Concentrada al 5.5% Bidón 5 Litros	Limpieza	Bidón	85.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
42	Detergente Industrial Multiuso en Polvo 10kg	Limpieza	Bolsa	90.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
43	Desinfectante Amonio Cuaternario 5ta Gen. 5L	Limpieza	Bidón	60.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
44	Arena Sanitaria Aglomerante para Gatos 10kg	Limpieza	Bolsa	160.00	25.00	2026-11-01 14:00:13	2026-11-01 14:00:13
45	Bolsas Plásticas Gruesas para Residuos 100L	Limpieza	Paquete	110.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
47	Collares Isabelinos de Protección Talle 3-5	Accesorio	Unidad	75.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
48	Platos Dobles de Acero Inoxidable para Perro	Accesorio	Unidad	120.00	15.00	2026-11-01 14:00:13	2026-11-01 14:00:13
49	Correas Resistentes de Paseo Nylon 2m	Accesorio	Unidad	85.00	10.00	2026-11-01 14:00:13	2026-11-01 14:00:13
50	Mantas Térmicas Acolchadas Lavables	Accesorio	Unidad	140.00	20.00	2026-11-01 14:00:13	2026-11-01 14:00:13
52	Penicilina G Benzatínica + Procaínica 6.000.000 UI	Medicamento	Frasco Ampolla	30.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
54	Oxitetraciclina L.A. 200mg/ml Inyectable 100ml	Medicamento	Frasco 100ml	25.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
55	Ampicilina + Sulbactam 1.5g Inyectable	Medicamento	Vial	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
56	Gentamicina Sulfato 10% Inyectable 100ml	Medicamento	Frasco 100ml	20.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
57	Amoxicilina L.A. 15% Suspensión Inyectable 100ml	Medicamento	Frasco 100ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
58	Cefalotina Sódica 1g Polvo Inyectable	Medicamento	Vial	55.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
59	Metronidazol 500mg/100ml Solución para Infusión	Medicamento	Frasco 100ml	35.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
62	Meloxicam 2% Inyectable 50ml	Medicamento	Frasco 50ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
63	Ketoprofeno 1% Inyectable 20ml	Medicamento	Frasco 20ml	42.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
64	Carprofeno Inyectable 50mg/ml 20ml	Medicamento	Frasco 20ml	35.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
65	Dipirona (Metamizol) 50% Inyectable 50ml	Medicamento	Frasco 50ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
66	Tramadol Clorhidrato 50mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	65.00	12.00	2026-11-02 02:45:24	2026-11-02 02:45:24
24	Amoxicilina + Ácido Clavulánico 500mg Comp.	Medicamento	Caja	107.00	15.00	2026-11-01 14:00:13	2026-11-02 03:34:42
34	Alcohol Medicinal al 70% 1 Litro	Limpieza	Botella	148.00	20.00	2026-11-01 14:00:13	2026-11-02 03:34:42
12	Vacuna Óctuple Vanguard Plus 5/L	Vacuna	Dosis	176.00	25.00	2026-11-01 14:00:13	2026-11-02 03:34:42
6	Alimento Medicado Renal Royal Canin 7.5kg	Alimento	Bolsa	34.00	5.00	2026-11-01 14:00:13	2026-11-02 03:34:42
32	Solución Clorhexidina al 2% para Heridas 1 Litro	Medicamento	Frasco	70.00	10.00	2026-11-01 14:00:13	2026-11-02 03:34:42
46	Guantes Quirúrgicos de Látex Talle M (Caja 100)	Limpieza	Caja	99.00	15.00	2026-11-01 14:00:13	2026-11-02 03:34:42
60	Doxiciclina Inyectable 50mg/ml 50ml	Medicamento	Frasco 50ml	25.00	6.00	2026-11-02 02:45:24	2026-11-02 03:34:42
4	Lavandina Concentrada 5L	Limpieza	Bidón	14.00	4.00	2026-11-01 18:17:19	2026-11-21 10:44:30
67	Fentanilo Citrato 0.05mg/ml Ampolla 10ml	Medicamento	Ampolla 10ml	24.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
68	Morfina Clorhidrato 10mg/ml Ampolla 1ml	Medicamento	Ampolla 1ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
69	Butorfanol Tartrato 10mg/ml Inyectable 10ml	Medicamento	Vial 10ml	20.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
70	Flunixin Meglumina 5% Inyectable 50ml	Medicamento	Frasco 50ml	22.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
71	Betametasona Dipropionato 4mg/ml Inyectable	Medicamento	Ampolla 5ml	35.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
72	Prednisolona Acetato 10mg/ml Suspensión Inyectable	Medicamento	Frasco 20ml	28.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
73	Difenhidramina Clorhidrato 10mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	45.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
74	Ketamina Clorhidrato 10% (100mg/ml) Inyectable 50ml	Medicamento	Frasco 50ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
75	Xilacina 2% Inyectable 30ml	Medicamento	Frasco 30ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
76	Propofol 1% (10mg/ml) Emulsión Inyectable 20ml	Medicamento	Ampolla 20ml	38.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
77	Midazolam 5mg/ml Inyectable 10ml	Medicamento	Vial 10ml	30.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
78	Diazepam 5mg/ml Inyectable Ampolla 2ml	Medicamento	Ampolla 2ml	60.00	15.00	2026-11-02 02:45:24	2026-11-02 02:45:24
79	Acepromacina 1% Inyectable 20ml	Medicamento	Frasco 20ml	25.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
80	Atropina Sulfato 1% Inyectable 20ml	Medicamento	Frasco 20ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
81	Lidocaína Clorhidrato 2% Inyectable 100ml	Medicamento	Frasco 100ml	35.00	7.00	2026-11-02 02:45:24	2026-11-02 02:45:24
82	Doramectina 1% Inyectable 50ml	Medicamento	Frasco 50ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
83	Imidocarb Dipropionato 12% Inyectable 20ml	Medicamento	Frasco 20ml	20.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
84	Levamisol Clorhidrato 10% Inyectable 100ml	Medicamento	Frasco 100ml	22.00	4.00	2026-11-02 02:45:24	2026-11-02 02:45:24
87	Dextrosa al 5% en Solución Salina 500ml	Medicamento	Bolsa 500ml	75.00	15.00	2026-11-02 02:45:24	2026-11-02 02:45:24
88	Ranitidina Clorhidrato 25mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
89	Omeprazol Sódico 40mg Polvo Liofilizado Inyectable	Medicamento	Vial	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
90	Ondansetrón 2mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	50.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
91	Metoclopramida Clorhidrato 5mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	40.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
92	Maropitant (Cerenia) 10mg/ml Inyectable 20ml	Medicamento	Frasco 20ml	30.00	5.00	2026-11-02 02:45:24	2026-11-02 02:45:24
94	Vitamina K1 (Fitomenadiona) 10mg/ml Inyectable Ampolla 2ml	Medicamento	Ampolla 2ml	50.00	12.00	2026-11-02 02:45:24	2026-11-02 02:45:24
95	Calcio Borogluconato con Magnesio Inyectable 100ml	Medicamento	Frasco 100ml	30.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
96	Dextrano Férrico 100mg/ml Inyectable 50ml	Medicamento	Frasco 50ml	35.00	6.00	2026-11-02 02:45:24	2026-11-02 02:45:24
97	Aminoácidos + Electrolitos Reconstituyente 500ml	Medicamento	Frasco 500ml	45.00	8.00	2026-11-02 02:45:24	2026-11-02 02:45:24
99	Vacuna Séxtuple Canina Inyectable (DHPPi+L)	Medicamento	Dosis 1ml	130.00	25.00	2026-11-02 02:45:24	2026-11-02 02:45:24
101	Suero Hiperinmune Anticanino Polivalente Inyectable 10ml	Medicamento	Frasco 10ml	40.00	10.00	2026-11-02 02:45:24	2026-11-02 02:45:24
104	Doxiciclina 100mg Comprimidos Ranurados	Medicamento	Caja	110.00	25.00	2026-11-02 02:46:08	2026-11-02 02:46:08
105	Meloxicam 1mg Comprimidos Masticables Palatables	Medicamento	Caja	80.00	15.00	2026-11-02 02:46:08	2026-11-02 02:46:08
106	Prednisona 20mg Comprimidos	Medicamento	Caja	70.00	12.00	2026-11-02 02:46:08	2026-11-02 02:46:08
107	Fenbendazol 500mg Comprimidos Desparasitante	Medicamento	Caja	140.00	30.00	2026-11-02 02:46:08	2026-11-02 02:46:08
108	Silimarina + Complejo Hepático 100mg Cápsulas	Medicamento	Frasco	55.00	10.00	2026-11-02 02:46:08	2026-11-02 02:46:08
103	Cefalexina 500mg Comprimidos Palatables	Medicamento	Caja	93.00	20.00	2026-11-02 02:46:08	2026-11-02 03:34:42
\.


--
-- Data for Name: auditoria_forense; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auditoria_forense (id, fecha_evento, usuario_id, ip_origen, user_agent, severidad, modulo, accion, tabla_afectada, registro_id, payload_anterior, payload_nuevo, hash_integridad) FROM stdin;
1	2026-01-03 09:15:00+00	5	192.168.1.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	1	\N	{"importe_total": 85, "numero_factura": 1}	10e312cdb0389bcbf62c517da4cb55c4383438a2034dbb8e9cb9e2a6dfc8a332
2	2026-01-04 10:40:00+00	4	192.168.1.49	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	1	\N	{"dosis": 1.7, "mascota": "Max"}	10ec9f5a3e7f1ec724cb88b84f3ee8ed55ce1668be3d2801194bdb171f432604
3	2026-01-06 11:20:00+00	6	192.168.1.44	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	1	\N	{"importe_total": 305}	54be5ad370d6235ef4e47127f1f6bb4b40a15e2600d5f5ab378e3d98131e174e
4	2026-01-09 11:22:00+00	5	192.168.1.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	2	\N	{"importe_total": 130, "numero_factura": 2}	1545acdb886ae2e8cd1de33544d895d81889faa699740999378ddd05ba2fc983
5	2026-01-13 11:40:00+00	7	192.168.1.56	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	2	\N	{"dosis": 2.5, "mascota": "Tom"}	286006fd0fedee44a9fc0ed524fbf59c5abd0b6c97e09446dab257a35f33b20f
6	2026-01-15 13:29:00+00	5	192.168.1.14	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	3	\N	{"importe_total": 350, "numero_factura": 3}	1e99282c5e846781ad6a27a27675e65195464625c2bca927989ef36edf373a80
7	2026-01-16 12:20:00+00	6	192.168.1.64	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	2	\N	{"importe_total": 400}	7933dbe66b1353d82306738714645aed60c891aad2f3f7c9f4e7830063f3e38a
8	2026-01-21 15:36:00+00	5	192.168.1.66	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	4	\N	{"importe_total": 270, "numero_factura": 4}	b3cac6acfe4b35a66dcb4b3b4923c7289dfdfa95d1281b2f3dd15e037d1c7e3b
9	2026-02-03 09:15:00+00	5	192.168.1.53	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	5	\N	{"importe_total": 65, "numero_factura": 5}	3626b2286521bce2d472dd7f3dc28c173fdab6c9632fe846b1fb1bda4aac062f
10	2026-02-04 10:40:00+00	7	192.168.1.66	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	3	\N	{"dosis": 1.7, "mascota": "Bruno"}	8f34db80264ca456009443f37af377399926f422475eaf2cc9a81bf3efa55662
11	2026-02-06 11:20:00+00	6	192.168.1.47	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	3	\N	{"importe_total": 330}	66b9c43603ff56eb04ab5b579184d5bb78eb891d3888e6f6a7b04cd6b3627313
12	2026-02-09 11:22:00+00	5	192.168.1.84	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	6	\N	{"importe_total": 700, "numero_factura": 6}	1a41d381479e2d4433ce3bfbfec65808950c93d269788bce3c25abfffb31b41e
13	2026-02-13 11:40:00+00	8	192.168.1.75	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	4	\N	{"dosis": 2.5, "mascota": "Kira"}	6f97d919872acb66b7ef3a3102bbc1fef8456f265a66bfbf697b5f100ce6976c
14	2026-02-15 13:29:00+00	5	192.168.1.81	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	7	\N	{"importe_total": 140, "numero_factura": 7}	7537e982c4b518813f344221bbb9fafdbb2037ca428a8e94c1331a5dad4f3b20
15	2026-02-16 12:20:00+00	6	192.168.1.31	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	4	\N	{"importe_total": 425}	a8d92dfdb5c24d92d341869705a4af0be36ae5052425aa17136cfb63bd935e97
16	2026-02-21 15:36:00+00	5	192.168.1.73	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	8	\N	{"importe_total": 230, "numero_factura": 8}	1d8536dfd6e3775ff85bdc168e0bf25ad160fe8a54972a77410c8868ea50d55a
17	2026-03-03 09:15:00+00	5	192.168.1.74	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	9	\N	{"importe_total": 350, "numero_factura": 9}	0ff06dd87bb66c04500b9556b8e3b6c6fa2fe29532e549e920a300f735eb6630
18	2026-03-04 10:40:00+00	8	192.168.1.41	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	5	\N	{"dosis": 1.7, "mascota": "Thor"}	f036433ffe089e19625d3d199d5689b239d7249a9d95f462eb9e5d08b23c39cb
19	2026-03-06 11:20:00+00	6	192.168.1.66	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	5	\N	{"importe_total": 355}	7e982c5d13803adac72db0333050500203d23d0c6dcf1a0300ce899d6c3dbddf
20	2026-03-09 11:22:00+00	5	192.168.1.83	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	10	\N	{"importe_total": 280, "numero_factura": 10}	a90f9593d83da1b175800e1f8d5ef72209c88675ab8c54092565be501c5b0884
21	2026-03-13 11:40:00+00	9	192.168.1.28	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	6	\N	{"dosis": 2.5, "mascota": "Milo"}	612770ef9411194575fac26f99fdbc16cb12853b11383c0cc8ca449df7ce6836
22	2026-03-15 13:29:00+00	5	192.168.1.38	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	11	\N	{"importe_total": 120, "numero_factura": 11}	6133339921e43bfad5fd804dcdb6a2593e3dabba48b2ace929daf9f4c7559c0d
23	2026-03-15 16:29:00+00	6	192.168.1.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	CRITICAL	P11_FacturacionLegal	ANULAR_FACTURA	facturas_legales	11	{"estado": "EMITIDA"}	{"estado": "ANULADA"}	342ee125b6564f218e2786084051f2b4c403295e1d32b538d173a48dffe3451a
24	2026-03-16 12:20:00+00	6	192.168.1.64	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	6	\N	{"importe_total": 450}	d08c583cdf6e0fa1b5530409db8ad357fbc47f5fb90205240a804049ae48ae42
25	2026-03-21 15:36:00+00	5	192.168.1.86	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	12	\N	{"importe_total": 160, "numero_factura": 12}	27d450c3fa525a1ff4d31ed566d3b6640aca7c976c7a5a9a6c504e446246e922
26	2026-04-03 09:15:00+00	5	192.168.1.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	13	\N	{"importe_total": 140, "numero_factura": 13}	3376eb96290e47adcbf02da1137d819fec6b19681c1488113343af03fa564e79
27	2026-04-04 10:40:00+00	9	192.168.1.31	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	7	\N	{"dosis": 1.7, "mascota": "Simba"}	1c3f46ad8199b07947453b2329c412847599cd43d6e76f54055d41b12a159eb3
28	2026-04-06 11:20:00+00	6	192.168.1.67	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	7	\N	{"importe_total": 380}	5b9a5a97da038818fe3b492f16dd699a4918b9a0ab692d51a6e63ac9d41ff8e2
29	2026-04-09 11:22:00+00	5	192.168.1.29	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	14	\N	{"importe_total": 240, "numero_factura": 14}	98f85a6a4b5c7f785d346e53efb89e87d73974c635b80db3264f8e5fb65cad9a
30	2026-04-13 11:40:00+00	10	192.168.1.16	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	8	\N	{"dosis": 2.5, "mascota": "Daisy"}	ff671350df307b023cff8695b083037c0c222a8ea4fbf5d9b31df6c37d8e4b78
31	2026-04-15 13:29:00+00	5	192.168.1.37	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	15	\N	{"importe_total": 85, "numero_factura": 15}	d15ce5a70f6720942cdd577c513d648dee643a963165f67a2bc28b795876956c
32	2026-04-16 12:20:00+00	6	192.168.1.23	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	8	\N	{"importe_total": 475}	2b6cb2d4b967c391d8b08a03b7f4ea9cbf5caf3b3f66d93abf269d1a2ed72f31
33	2026-04-21 15:36:00+00	5	192.168.1.20	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	16	\N	{"importe_total": 120, "numero_factura": 16}	4fb0f5b2225a270e607cecb7a8a0effe6fd0c46713049c896f84ad3012ef32f4
34	2026-05-03 09:15:00+00	5	192.168.1.44	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	17	\N	{"importe_total": 120, "numero_factura": 17}	25da6398e990452d8335cf7c223947058d338c1f1fdc89c90231e5ba2629e23e
35	2026-05-04 10:40:00+00	10	192.168.1.77	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	9	\N	{"dosis": 1.7, "mascota": "Firulais"}	ae7cbf74673686d2d9c3256e873f9ab1d20f9b07bcace45534be313c60fd5019
36	2026-05-06 11:20:00+00	6	192.168.1.72	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	9	\N	{"importe_total": 405}	5e5742b1ce71444823fc153df3ae42fb6c854c9ec52acdab68e36b37e832159b
37	2026-05-09 11:22:00+00	5	192.168.1.37	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	18	\N	{"importe_total": 170, "numero_factura": 18}	fdf0f1e27b84a5773cc319a608e070a3cb15d9fdec18f219aaeac4e8feb62576
38	2026-05-13 11:40:00+00	11	192.168.1.75	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	10	\N	{"dosis": 2.5, "mascota": "Tigre"}	1a77ade85ad671c7fc7e13227596de84349a698ff9ca4de5d3da7c0448fbfec4
39	2026-05-15 13:29:00+00	5	192.168.1.60	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	19	\N	{"importe_total": 65, "numero_factura": 19}	72580368fc65bd751c66f4ece993478a3e8a1e732ec0c9f847bc9153367c9b50
40	2026-05-16 12:20:00+00	6	192.168.1.47	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	10	\N	{"importe_total": 500}	d125b6f7524daca02733414cc027d222b5689cef9b97c12c331ac192d34c5374
41	2026-05-21 15:36:00+00	5	192.168.1.58	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	20	\N	{"importe_total": 690, "numero_factura": 20}	983863098db60aa0fe3d53e1347dbea2b35f0e06145f4f090f79d9ef326ca6ad
42	2026-06-03 09:15:00+00	5	192.168.1.64	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	21	\N	{"importe_total": 85, "numero_factura": 21}	c75cef45120842957175b5de73599f2cb24ea82e07bea0db989e47e8c9f28cd6
43	2026-06-04 10:40:00+00	11	192.168.1.12	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	11	\N	{"dosis": 1.7, "mascota": "Oso"}	231eb4bf40b9f2d4863f4042fdf3de753745b07eb1557224330a3080d99e9288
44	2026-06-06 11:20:00+00	6	192.168.1.37	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	11	\N	{"importe_total": 430}	7d2f67d364b53781127a72c8ceaf1d79b57e956c63c900c0d85e495e979cd503
45	2026-06-09 11:22:00+00	5	192.168.1.10	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	22	\N	{"importe_total": 130, "numero_factura": 22}	5c64b8533bef180ca4602b9537c534ea9115bd0589a6f7d5511cdfebde1fb00d
46	2026-06-13 11:40:00+00	12	192.168.1.17	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	12	\N	{"dosis": 2.5, "mascota": "Blanca"}	077ce141d8d4ccd7aa2b5970e8828614bf1606ca369d480fc04e41c070ddc3d8
47	2026-06-15 13:29:00+00	5	192.168.1.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	23	\N	{"importe_total": 350, "numero_factura": 23}	b5ab1d1a6f234ba48f2c6a07cf2376a3bfc6a8b76d9fda0ed655e59054d1b3b9
48	2026-06-15 16:29:00+00	6	192.168.1.74	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	CRITICAL	P11_FacturacionLegal	ANULAR_FACTURA	facturas_legales	23	{"estado": "EMITIDA"}	{"estado": "ANULADA"}	c1ed861ebaf8136383e22e6332a63e62b18ea4e7744e5e59077b373833265492
49	2026-06-16 12:20:00+00	6	192.168.1.80	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	12	\N	{"importe_total": 525}	175684269c93c365106f39d3eaa47886b962e8b6e68a4ca505ebaba2c46b0c53
50	2026-06-21 15:36:00+00	5	192.168.1.79	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	24	\N	{"importe_total": 270, "numero_factura": 24}	87e13d91b96b5470dc51f8a461047599616efc7c7e8b941ac7f28b019727c72b
51	2026-07-03 09:15:00+00	5	192.168.1.66	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	25	\N	{"importe_total": 65, "numero_factura": 501}	81890be0e772e2d75c2d4923422c84ce3cb562571f58213377be34abdb98cc8a
52	2026-07-04 10:40:00+00	12	192.168.1.87	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	13	\N	{"dosis": 1.7, "mascota": "Snoopy"}	8be28c73c4c0e884e331bba75809505dec88c46d4c6328a4edd6aaee6f7860e7
53	2026-07-06 11:20:00+00	6	192.168.1.73	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	13	\N	{"importe_total": 455}	b8ac3dfc0c069198004c46beab545eb2f6b6aaf3bd23b29e3a903e6e4e516636
54	2026-07-09 11:22:00+00	5	192.168.1.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	26	\N	{"importe_total": 700, "numero_factura": 502}	20ef0b9b7e134dd803e0f619e187c9092abbec9301b35e3fbf82259b43672a8f
55	2026-07-13 11:40:00+00	13	192.168.1.66	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	14	\N	{"dosis": 2.5, "mascota": "Sombra"}	42621cccab82fdce7a061c5a6ccda53b545af4ac124c9c40ed5c8686d04ac686
56	2026-07-15 13:29:00+00	5	192.168.1.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	27	\N	{"importe_total": 140, "numero_factura": 503}	981e61c23b055a08185eb96696701355fda903a28650d8ba88697142157ddd41
57	2026-07-16 12:20:00+00	6	192.168.1.56	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	14	\N	{"importe_total": 550}	7e395cd463ce3d18385310a4c0737a644ca80e3d1dc3c1701d135b880ec9c1eb
58	2026-07-21 15:36:00+00	5	192.168.1.81	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	28	\N	{"importe_total": 230, "numero_factura": 504}	06b2bd0e992687050e28627dd16545b300877b8630a378377a72cb3e47d97cb5
59	2026-08-03 09:15:00+00	5	192.168.1.55	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	29	\N	{"importe_total": 350, "numero_factura": 505}	4edf724e0a66e0244bfca28b236c879521c3cab7b4030d842e7ed353c23d19cb
60	2026-08-04 10:40:00+00	13	192.168.1.50	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	15	\N	{"dosis": 1.7, "mascota": "Ragnar"}	b543bb2fb7636eafbbe13a6a91314613dfe7c879f6828c1ba2b16aecac9efd7f
61	2026-08-06 11:20:00+00	6	192.168.1.45	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	15	\N	{"importe_total": 480}	ef90820b9be581e413abe66f04c5792fe2cacbe0941c7a1a2310615f1d08dddc
62	2026-08-09 11:22:00+00	5	192.168.1.67	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	30	\N	{"importe_total": 280, "numero_factura": 506}	ce95db291754248fdf2310e27015570fcaf8a239c9374e00cad1f7484045aae3
63	2026-08-13 11:40:00+00	14	192.168.1.48	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	16	\N	{"dosis": 2.5, "mascota": "Chispa"}	c0f1986730af17592e343b730e0e6963eea55adea0d8b60820ef5eef34460638
64	2026-08-15 13:29:00+00	5	192.168.1.90	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	31	\N	{"importe_total": 120, "numero_factura": 507}	245884b1c7dc17683cdf4b06fcd32c68059881f1f72114b254662581a91d937f
65	2026-08-16 12:20:00+00	6	192.168.1.23	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	16	\N	{"importe_total": 575}	ef9c8a8e8c7c97f85a1c3305a66b96b830c0f3bb17eaee9fb1496c67f949dde8
66	2026-08-21 15:36:00+00	5	192.168.1.38	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	32	\N	{"importe_total": 160, "numero_factura": 508}	cfa1e47946d102ea1e58b9fd82650ecf9181d957608a676541d8a43fe4479b40
67	2026-09-03 09:15:00+00	5	192.168.1.17	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	33	\N	{"importe_total": 140, "numero_factura": 509}	0ddbe509f767a942fed35ea22254c1b2cf51e1ec90b71589a250d7401c5e0f22
68	2026-09-04 10:40:00+00	14	192.168.1.11	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	17	\N	{"dosis": 1.7, "mascota": "Capitán"}	e6baf3990a3162162c67643eabda8b34bb2c996be02e19f28d7ae93e8c075194
69	2026-09-06 11:20:00+00	6	192.168.1.63	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	17	\N	{"importe_total": 505}	65dbadd3410663e68ed405d0b916ed4fb9231279df2fe564d3782b14158d98cd
70	2026-09-09 11:22:00+00	5	192.168.1.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	34	\N	{"importe_total": 240, "numero_factura": 510}	b0137c3438ef2d1dbdd8195c49fcec68c7499d20dc150d06dcab9baf46bd875e
71	2026-09-13 11:40:00+00	15	192.168.1.68	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	18	\N	{"dosis": 2.5, "mascota": "Pardo"}	e4f97bbe0cbc9306047705daf510ec56bc21210d154de780c33b04228f2ae839
72	2026-09-15 13:29:00+00	5	192.168.1.81	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	35	\N	{"importe_total": 85, "numero_factura": 511}	b80aed84e2ce0ac07ab133edf1596bfcc811d1cb42c543cd5a6e13ee9f2a2cbe
73	2026-09-15 16:29:00+00	6	192.168.1.83	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	CRITICAL	P11_FacturacionLegal	ANULAR_FACTURA	facturas_legales	35	{"estado": "EMITIDA"}	{"estado": "ANULADA"}	54b610ebd748fa6ee8b203677c44bba29bdcede8c0d979ad1372559bc7edcb1c
74	2026-09-16 12:20:00+00	6	192.168.1.83	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	18	\N	{"importe_total": 600}	c8f0300d50fc8e8fd619f2935173fd1fe9707462f5e0f80c961f7fda678ddba7
75	2026-09-21 15:36:00+00	5	192.168.1.69	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	36	\N	{"importe_total": 120, "numero_factura": 512}	e4ed23a9e73f7eb6167ee02830eff923f4fd7bbd71767020a06464877a80a5ce
76	2026-10-03 09:15:00+00	5	192.168.1.49	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	37	\N	{"importe_total": 120, "numero_factura": 513}	7aab49cc4b12c86e877d50e928ed0604b3bab0b368085e93469bd84d33a4601c
77	2026-10-04 10:40:00+00	15	192.168.1.35	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	19	\N	{"dosis": 1.7, "mascota": "Balto"}	e818b448306fff0ddb88784acd1bb5f9466896aaff070da865ba47a8ee284e5a
78	2026-10-06 11:20:00+00	6	192.168.1.86	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	19	\N	{"importe_total": 530}	43f9adc43775c6fba16e50be0b7e7f4493b3f0870f7f159734728e90f6b3662d
79	2026-10-09 11:22:00+00	5	192.168.1.11	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	38	\N	{"importe_total": 170, "numero_factura": 514}	725884ddc0263f5fe199437d5df1d8980bba2d6da43af1788595d46de09c95aa
80	2026-10-13 11:40:00+00	2	192.168.1.18	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	20	\N	{"dosis": 2.5, "mascota": "Canela"}	10d2e1c691d17ca327501ae2067fb5f44fa97a51ccf7753007472168c73a99ff
81	2026-10-15 13:29:00+00	5	192.168.1.44	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	39	\N	{"importe_total": 65, "numero_factura": 515}	d705b95fcb56252921611ea2528d1bb4bcaa9b7a5835266d2854abc5054c20b5
82	2026-10-16 12:20:00+00	6	192.168.1.82	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	20	\N	{"importe_total": 625}	7c8258105d0cda6435b69fd9ae259d0832d133d4bf33123038137c8163a4c89d
83	2026-10-21 15:36:00+00	5	192.168.1.69	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	40	\N	{"importe_total": 690, "numero_factura": 516}	b70e066ac197a8398655f2cb45187713aaaf9450eded57d6085ca22c73526894
84	2026-11-03 09:15:00+00	5	192.168.1.58	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	41	\N	{"importe_total": 85, "numero_factura": 517}	ced7b00e4f6e926b62b667330f5e9d4ca02f376f99ae89fa004d7d819f57f82f
85	2026-11-04 10:40:00+00	2	192.168.1.45	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	21	\N	{"dosis": 1.7, "mascota": "Zeús"}	e7c6594e984fe924114b62c183c1ff8f38fae51bf7fe7b8a7ff459d6c1e747a1
86	2026-11-06 11:20:00+00	6	192.168.1.61	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	21	\N	{"importe_total": 555}	2e4dd2cf9908b6b43dbb4115b867693c008e8fb571dc9016bbe738e315c2e521
87	2026-11-09 11:22:00+00	5	192.168.1.79	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	42	\N	{"importe_total": 130, "numero_factura": 518}	c1ef70cff6550a0ff83eb1c6ae617a2de67565da13f316dd28bc4b84f407e0ed
88	2026-11-12 11:40:00+00	4	192.168.1.60	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P12_ControlClinicoSeguridad	CREAR_DOSIFICACION_CLINICA	prescripciones_dosificacion	22	\N	{"dosis": 2.5, "mascota": "Pelusa"}	88a0dbbfa3d06735f00ff4ceeb3ef61e57e2f234244f30070b4445cef2ba4054
89	2026-11-12 12:20:00+00	6	192.168.1.61	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P13_ReportesFiscales	REGISTRAR_FACTURA_COMPRA	facturas_compras	22	\N	{"importe_total": 650}	9a81e1d34a0ca2b113fd0d194eab3712747d009c89a2d80d1bcd1477b81210ce
90	2026-11-12 13:29:00+00	5	192.168.1.60	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	43	\N	{"importe_total": 350, "numero_factura": 519}	4dceb9afff0f5f2f5047f379c3a11e5defa932354f335ae80fbb32184eea90c5
91	2026-11-12 15:36:00+00	5	192.168.1.88	Mozilla/5.0 (Windows NT 10.0; Win64; x64)	INFO	P11_FacturacionLegal	EMITIR_FACTURA	facturas_legales	44	\N	{"importe_total": 270, "numero_factura": 520}	1b302f6abb169f1a58de80f4a1795bc2fa7901e9add8812029cd202c9759284f
92	2026-11-16 18:59:49+00	6	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36	INFO	P12_ControlClinicoSeguridad	REGISTRAR_TOMA_TRATAMIENTO	cronograma_tratamientos	86	\N	{"estado": "ADMINISTRADO"}	2585043a7873c4f0a3633a25b79e439e8eefb88465c18bfc2e11121e0e6bf96b
93	2026-11-16 18:59:50+00	6	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36	INFO	P12_ControlClinicoSeguridad	REGISTRAR_TOMA_TRATAMIENTO	cronograma_tratamientos	87	\N	{"estado": "ADMINISTRADO"}	acc9003c6398116690204b742bdc09f2e1d5000cb5a1ed7ae003302dd5918982
94	2026-11-16 19:00:15+00	6	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36	INFO	P12_ControlClinicoSeguridad	REGISTRAR_TOMA_TRATAMIENTO	cronograma_tratamientos	88	\N	{"estado": "ADMINISTRADO"}	59583f1ae6442fa6c26069ca1757581815fe823f57ad565358a2a001c132a3bf
\.


--
-- Data for Name: bitacora; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bitacora (id_accion, id_usuario, fecha, hora, tipo_accion, tabla_afectada, id_registro_afectado, ip, created_at) FROM stdin;
1	2	2026-09-03	14:00:12.780728	ALTA_NUEVO_RESCATE	mascota	2	192.168.1.20	2026-11-01 14:00:12.780728
2	3	2026-09-04	14:00:12.780728	REGISTRO_ATENCION_MEDICA	historial_clinico	3	192.168.1.25	2026-11-01 14:00:12.780728
3	4	2026-09-05	14:00:12.780728	ENTRADA_COMPRA_INSUMOS	compra	4	192.168.1.30	2026-11-01 14:00:12.780728
4	5	2026-09-06	14:00:12.780728	DESPACHO_CONSUMO_DESPENSA	salida_inventario	5	192.168.1.18	2026-11-01 14:00:12.780728
5	6	2026-09-07	14:00:12.780728	FORMALIZACION_ADOPCION	adopcion	6	192.168.1.22	2026-11-01 14:00:12.780728
6	7	2026-09-08	14:00:12.780728	RECEPCION_DONACION_DINERO	donacion	7	192.168.1.12	2026-11-01 14:00:12.780728
7	8	2026-09-09	14:00:12.780728	EVALUACION_POSTULANTE_SCORING	evaluacion_idoneidad	8	192.168.1.24	2026-11-01 14:00:12.780728
8	9	2026-09-10	14:00:12.780728	REGISTRO_VISITA_SEGUIMIENTO	seguimiento_adopcion	9	192.168.1.16	2026-11-01 14:00:12.780728
9	10	2026-09-11	14:00:12.780728	ACTUALIZACION_STOCK_MINIMO	articulo_inventario	10	192.168.1.10	2026-11-01 14:00:12.780728
10	11	2026-09-12	14:00:12.780728	LOGIN_EXITOSO	usuario	11	192.168.1.15	2026-11-01 14:00:12.780728
11	12	2026-09-13	14:00:12.780728	ALTA_NUEVO_RESCATE	mascota	12	192.168.1.20	2026-11-01 14:00:12.780728
12	13	2026-09-14	14:00:12.780728	REGISTRO_ATENCION_MEDICA	historial_clinico	13	192.168.1.25	2026-11-01 14:00:12.780728
13	14	2026-09-15	14:00:12.780728	ENTRADA_COMPRA_INSUMOS	compra	14	192.168.1.30	2026-11-01 14:00:12.780728
14	15	2026-09-16	14:00:12.780728	DESPACHO_CONSUMO_DESPENSA	salida_inventario	15	192.168.1.18	2026-11-01 14:00:12.780728
15	1	2026-09-17	14:00:12.780728	FORMALIZACION_ADOPCION	adopcion	16	192.168.1.22	2026-11-01 14:00:12.780728
16	2	2026-09-18	14:00:12.780728	RECEPCION_DONACION_DINERO	donacion	17	192.168.1.12	2026-11-01 14:00:12.780728
17	3	2026-09-19	14:00:12.780728	EVALUACION_POSTULANTE_SCORING	evaluacion_idoneidad	18	192.168.1.24	2026-11-01 14:00:12.780728
18	4	2026-09-20	14:00:12.780728	REGISTRO_VISITA_SEGUIMIENTO	seguimiento_adopcion	19	192.168.1.16	2026-11-01 14:00:12.780728
19	5	2026-09-21	14:00:12.780728	ACTUALIZACION_STOCK_MINIMO	articulo_inventario	20	192.168.1.10	2026-11-01 14:00:12.780728
20	6	2026-09-22	14:00:12.780728	LOGIN_EXITOSO	usuario	21	192.168.1.15	2026-11-01 14:00:12.780728
21	7	2026-09-23	14:00:12.780728	ALTA_NUEVO_RESCATE	mascota	22	192.168.1.20	2026-11-01 14:00:12.780728
22	8	2026-09-24	14:00:12.780728	REGISTRO_ATENCION_MEDICA	historial_clinico	23	192.168.1.25	2026-11-01 14:00:12.780728
23	9	2026-09-25	14:00:12.780728	ENTRADA_COMPRA_INSUMOS	compra	24	192.168.1.30	2026-11-01 14:00:12.780728
24	10	2026-09-26	14:00:12.780728	DESPACHO_CONSUMO_DESPENSA	salida_inventario	25	192.168.1.18	2026-11-01 14:00:12.780728
25	11	2026-09-27	14:00:12.780728	FORMALIZACION_ADOPCION	adopcion	26	192.168.1.22	2026-11-01 14:00:12.780728
26	12	2026-09-28	14:00:12.780728	RECEPCION_DONACION_DINERO	donacion	27	192.168.1.12	2026-11-01 14:00:12.780728
27	13	2026-09-29	14:00:12.780728	EVALUACION_POSTULANTE_SCORING	evaluacion_idoneidad	28	192.168.1.24	2026-11-01 14:00:12.780728
28	14	2026-09-30	14:00:12.780728	REGISTRO_VISITA_SEGUIMIENTO	seguimiento_adopcion	29	192.168.1.16	2026-11-01 14:00:12.780728
29	15	2026-10-01	14:00:12.780728	ACTUALIZACION_STOCK_MINIMO	articulo_inventario	30	192.168.1.10	2026-11-01 14:00:12.780728
30	1	2026-10-02	14:00:12.780728	LOGIN_EXITOSO	usuario	31	192.168.1.15	2026-11-01 14:00:12.780728
31	2	2026-10-03	14:00:12.780728	ALTA_NUEVO_RESCATE	mascota	32	192.168.1.20	2026-11-01 14:00:12.780728
32	3	2026-10-04	14:00:12.780728	REGISTRO_ATENCION_MEDICA	historial_clinico	33	192.168.1.25	2026-11-01 14:00:12.780728
33	4	2026-10-05	14:00:12.780728	ENTRADA_COMPRA_INSUMOS	compra	34	192.168.1.30	2026-11-01 14:00:12.780728
34	5	2026-10-06	14:00:12.780728	DESPACHO_CONSUMO_DESPENSA	salida_inventario	35	192.168.1.18	2026-11-01 14:00:12.780728
35	6	2026-10-07	14:00:12.780728	FORMALIZACION_ADOPCION	adopcion	36	192.168.1.22	2026-11-01 14:00:12.780728
36	7	2026-10-08	14:00:12.780728	RECEPCION_DONACION_DINERO	donacion	37	192.168.1.12	2026-11-01 14:00:12.780728
37	8	2026-10-09	14:00:12.780728	EVALUACION_POSTULANTE_SCORING	evaluacion_idoneidad	38	192.168.1.24	2026-11-01 14:00:12.780728
38	9	2026-10-10	14:00:12.780728	REGISTRO_VISITA_SEGUIMIENTO	seguimiento_adopcion	39	192.168.1.16	2026-11-01 14:00:12.780728
39	10	2026-10-11	14:00:12.780728	ACTUALIZACION_STOCK_MINIMO	articulo_inventario	40	192.168.1.10	2026-11-01 14:00:12.780728
40	11	2026-10-12	14:00:12.780728	LOGIN_EXITOSO	usuario	41	192.168.1.15	2026-11-01 14:00:12.780728
41	12	2026-10-13	14:00:12.780728	ALTA_NUEVO_RESCATE	mascota	42	192.168.1.20	2026-11-01 14:00:12.780728
42	13	2026-10-14	14:00:12.780728	REGISTRO_ATENCION_MEDICA	historial_clinico	43	192.168.1.25	2026-11-01 14:00:12.780728
43	14	2026-10-15	14:00:12.780728	ENTRADA_COMPRA_INSUMOS	compra	44	192.168.1.30	2026-11-01 14:00:12.780728
44	15	2026-10-16	14:00:12.780728	DESPACHO_CONSUMO_DESPENSA	salida_inventario	45	192.168.1.18	2026-11-01 14:00:12.780728
45	1	2026-10-17	14:00:12.780728	FORMALIZACION_ADOPCION	adopcion	1	192.168.1.22	2026-11-01 14:00:12.780728
46	2	2026-10-18	14:00:12.780728	RECEPCION_DONACION_DINERO	donacion	2	192.168.1.12	2026-11-01 14:00:12.780728
47	3	2026-10-19	14:00:12.780728	EVALUACION_POSTULANTE_SCORING	evaluacion_idoneidad	3	192.168.1.24	2026-11-01 14:00:12.780728
48	4	2026-10-20	14:00:12.780728	REGISTRO_VISITA_SEGUIMIENTO	seguimiento_adopcion	4	192.168.1.16	2026-11-01 14:00:12.780728
49	5	2026-10-21	14:00:12.780728	ACTUALIZACION_STOCK_MINIMO	articulo_inventario	5	192.168.1.10	2026-11-01 14:00:12.780728
50	6	2026-10-22	14:00:12.780728	LOGIN_EXITOSO	usuario	6	192.168.1.15	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: bitacoras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bitacoras (id, tipo_accion, id_usuario, created_at, updated_at, usuario_nombre, modulo, descripcion, entidad_tipo, entidad_id, ip, http_method, ruta, resultado, contexto) FROM stdin;
1	Emitir factura legal	5	2026-01-03 09:15:00	2026-01-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 1 por Bs. 85	FacturaLegal	1	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-01-03"}
2	Programar dosificación clínica	4	2026-01-04 10:40:00	2026-01-04 10:40:00	Dr. Mateo Vargas Ortiz	clinica	Prescripción FEFO para Max	PrescripcionDosificacion	1	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-01-04"}
3	Registrar factura de compra IVA	6	2026-01-06 11:20:00	2026-01-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Insumos Médicos Veterinarios San Juan por Bs. 305	FacturaCompra	1	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-01-06"}
4	Emitir factura legal	5	2026-01-09 11:22:00	2026-01-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 2 por Bs. 130	FacturaLegal	2	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-01-09"}
5	Programar dosificación clínica	7	2026-01-13 11:40:00	2026-01-13 11:40:00	Ignacio Ribera Zabala	clinica	Prescripción FEFO para Tom	PrescripcionDosificacion	2	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-01-13"}
6	Emitir factura legal	5	2026-01-15 13:29:00	2026-01-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 3 por Bs. 350	FacturaLegal	3	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-01-15"}
7	Iniciar sesión	6	2026-01-15 14:48:00	2026-01-15 14:48:00	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
8	Registrar factura de compra IVA	6	2026-01-16 12:20:00	2026-01-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Agropecuaria Cotoca Import-Export por Bs. 400	FacturaCompra	2	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-01-16"}
9	Iniciar sesión	6	2026-01-18 12:36:00	2026-01-18 12:36:00	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
10	Emitir factura legal	5	2026-01-21 15:36:00	2026-01-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 4 por Bs. 270	FacturaLegal	4	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-01-21"}
11	Emitir factura legal	5	2026-02-03 09:15:00	2026-02-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 5 por Bs. 65	FacturaLegal	5	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-02-03"}
12	Programar dosificación clínica	7	2026-02-04 10:40:00	2026-02-04 10:40:00	Ignacio Ribera Zabala	clinica	Prescripción FEFO para Bruno	PrescripcionDosificacion	3	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-02-04"}
13	Registrar factura de compra IVA	6	2026-02-06 11:20:00	2026-02-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Agropecuaria Cotoca Import-Export por Bs. 330	FacturaCompra	3	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-02-06"}
14	Emitir factura legal	5	2026-02-09 11:22:00	2026-02-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 6 por Bs. 700	FacturaLegal	6	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-02-09"}
15	Programar dosificación clínica	8	2026-02-13 11:40:00	2026-02-13 11:40:00	Gabriel Salazar Paz	clinica	Prescripción FEFO para Kira	PrescripcionDosificacion	4	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-02-13"}
16	Emitir factura legal	5	2026-02-15 13:29:00	2026-02-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 7 por Bs. 140	FacturaLegal	7	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-02-15"}
17	Registrar factura de compra IVA	6	2026-02-16 12:20:00	2026-02-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Comercializadora Agrovet del Oriente por Bs. 425	FacturaCompra	4	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-02-16"}
18	Emitir factura legal	5	2026-02-21 15:36:00	2026-02-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 8 por Bs. 230	FacturaLegal	8	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-02-21"}
19	Inicio de sesión en el sistema	1	2026-03-01 08:30:00	2026-03-01 08:30:00	\N	sistema	Inicio de sesión en el sistema	\N	\N	127.0.0.1	POST	/api/sistema	exitosa	\N
20	Registro de consulta clínica - Mascota ID 1	2	2026-03-01 09:15:00	2026-03-01 09:15:00	\N	sistema	Registro de consulta clínica - Mascota ID 1	\N	\N	127.0.0.1	POST	/api/sistema	exitosa	\N
21	Registro de nuevo interesado en adopción	5	2026-03-02 10:00:00	2026-03-02 10:00:00	\N	sistema	Registro de nuevo interesado en adopción	\N	\N	127.0.0.1	POST	/api/sistema	exitosa	\N
22	Aprobación de solicitud de adopción ID 1	1	2026-03-02 11:30:00	2026-03-02 11:30:00	\N	sistema	Aprobación de solicitud de adopción ID 1	\N	\N	127.0.0.1	POST	/api/sistema	exitosa	\N
23	Emitir factura legal	5	2026-03-03 09:15:00	2026-03-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 9 por Bs. 350	FacturaLegal	9	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-03-03"}
24	Registro de salida de alimentos de inventario	3	2026-03-03 14:20:00	2026-03-03 14:20:00	\N	sistema	Registro de salida de alimentos de inventario	\N	\N	127.0.0.1	POST	/api/sistema	exitosa	\N
25	Programar dosificación clínica	8	2026-03-04 10:40:00	2026-03-04 10:40:00	Gabriel Salazar Paz	clinica	Prescripción FEFO para Thor	PrescripcionDosificacion	5	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-03-04"}
26	Registrar factura de compra IVA	6	2026-03-06 11:20:00	2026-03-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Comercializadora Agrovet del Oriente por Bs. 355	FacturaCompra	5	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-03-06"}
27	Emitir factura legal	5	2026-03-09 11:22:00	2026-03-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 10 por Bs. 280	FacturaLegal	10	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-03-09"}
28	Programar dosificación clínica	9	2026-03-13 11:40:00	2026-03-13 11:40:00	Diego Armando Cuéllar Pinto	clinica	Prescripción FEFO para Milo	PrescripcionDosificacion	6	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-03-13"}
29	Emitir factura legal	5	2026-03-15 13:29:00	2026-03-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 11 por Bs. 120	FacturaLegal	11	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-03-15"}
30	Anular factura legal	6	2026-03-15 16:29:00	2026-03-15 16:29:00	Juan Ronaldo Rojas Ugarte	facturacion	Anulación de Factura N° 11	FacturaLegal	11	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-03-15"}
31	Registrar factura de compra IVA	6	2026-03-16 12:20:00	2026-03-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Nutrición Animal Purina Bolivia por Bs. 450	FacturaCompra	6	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-03-16"}
32	Emitir factura legal	5	2026-03-21 15:36:00	2026-03-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 12 por Bs. 160	FacturaLegal	12	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-03-21"}
33	Iniciar sesión	6	2026-04-01 13:02:00	2026-04-01 13:02:00	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
168	Iniciar sesión	6	2026-11-12 19:38:15	2026-11-12 19:38:15	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
34	Emitir factura legal	5	2026-04-03 09:15:00	2026-04-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 13 por Bs. 140	FacturaLegal	13	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-04-03"}
35	Programar dosificación clínica	9	2026-04-04 10:40:00	2026-04-04 10:40:00	Diego Armando Cuéllar Pinto	clinica	Prescripción FEFO para Simba	PrescripcionDosificacion	7	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-04-04"}
36	Registrar factura de compra IVA	6	2026-04-06 11:20:00	2026-04-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Nutrición Animal Purina Bolivia por Bs. 380	FacturaCompra	7	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-04-06"}
37	Emitir factura legal	5	2026-04-09 11:22:00	2026-04-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 14 por Bs. 240	FacturaLegal	14	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-04-09"}
38	Programar dosificación clínica	10	2026-04-13 11:40:00	2026-04-13 11:40:00	Jessica Rojas Cuéllar	clinica	Prescripción FEFO para Daisy	PrescripcionDosificacion	8	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-04-13"}
39	Emitir factura legal	5	2026-04-15 13:29:00	2026-04-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 15 por Bs. 85	FacturaLegal	15	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-04-15"}
40	Registrar factura de compra IVA	6	2026-04-16 12:20:00	2026-04-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Importadora Veterinaria Guabirá por Bs. 475	FacturaCompra	8	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-04-16"}
41	Emitir factura legal	5	2026-04-21 15:36:00	2026-04-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 16 por Bs. 120	FacturaLegal	16	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-04-21"}
42	Cerrar sesión	6	2026-04-26 08:17:00	2026-04-26 08:17:00	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
43	Emitir factura legal	5	2026-05-03 09:15:00	2026-05-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 17 por Bs. 120	FacturaLegal	17	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-05-03"}
44	Programar dosificación clínica	10	2026-05-04 10:40:00	2026-05-04 10:40:00	Jessica Rojas Cuéllar	clinica	Prescripción FEFO para Firulais	PrescripcionDosificacion	9	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-05-04"}
45	Registrar factura de compra IVA	6	2026-05-06 11:20:00	2026-05-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Importadora Veterinaria Guabirá por Bs. 405	FacturaCompra	9	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-05-06"}
46	Emitir factura legal	5	2026-05-09 11:22:00	2026-05-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 18 por Bs. 170	FacturaLegal	18	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-05-09"}
47	Programar dosificación clínica	11	2026-05-13 11:40:00	2026-05-13 11:40:00	Víctor Hugo Dorado Rojas	clinica	Prescripción FEFO para Tigre	PrescripcionDosificacion	10	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-05-13"}
48	Emitir factura legal	5	2026-05-15 13:29:00	2026-05-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 19 por Bs. 65	FacturaLegal	19	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-05-15"}
49	Registrar factura de compra IVA	6	2026-05-16 12:20:00	2026-05-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Distribuidora de Fármacos Vetsur por Bs. 500	FacturaCompra	10	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-05-16"}
50	Intento de inicio de sesión rechazado	\N	2026-05-17 09:14:00	2026-05-17 09:14:00	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
51	Emitir factura legal	5	2026-05-21 15:36:00	2026-05-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 20 por Bs. 690	FacturaLegal	20	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-05-21"}
52	Emitir factura legal	5	2026-06-03 09:15:00	2026-06-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 21 por Bs. 85	FacturaLegal	21	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-06-03"}
53	Programar dosificación clínica	11	2026-06-04 10:40:00	2026-06-04 10:40:00	Víctor Hugo Dorado Rojas	clinica	Prescripción FEFO para Oso	PrescripcionDosificacion	11	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-06-04"}
54	Registrar factura de compra IVA	6	2026-06-06 11:20:00	2026-06-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Distribuidora de Fármacos Vetsur por Bs. 430	FacturaCompra	11	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-06-06"}
55	Emitir factura legal	5	2026-06-09 11:22:00	2026-06-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 22 por Bs. 130	FacturaLegal	22	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-06-09"}
56	Iniciar sesión	6	2026-06-11 10:57:00	2026-06-11 10:57:00	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
57	Programar dosificación clínica	12	2026-06-13 11:40:00	2026-06-13 11:40:00	Rubén Añez Peña	clinica	Prescripción FEFO para Blanca	PrescripcionDosificacion	12	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-06-13"}
58	Emitir factura legal	5	2026-06-15 13:29:00	2026-06-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 23 por Bs. 350	FacturaLegal	23	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-06-15"}
59	Anular factura legal	6	2026-06-15 16:29:00	2026-06-15 16:29:00	Juan Ronaldo Rojas Ugarte	facturacion	Anulación de Factura N° 23	FacturaLegal	23	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-06-15"}
60	Registrar factura de compra IVA	6	2026-06-16 12:20:00	2026-06-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Clínica y Proveedora Veterinaria Urbarí por Bs. 525	FacturaCompra	12	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-06-16"}
61	Cerrar sesión	6	2026-06-20 09:11:00	2026-06-20 09:11:00	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
62	Emitir factura legal	5	2026-06-21 15:36:00	2026-06-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 24 por Bs. 270	FacturaLegal	24	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-06-21"}
63	Emitir factura legal	5	2026-07-03 09:15:00	2026-07-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 501 por Bs. 65	FacturaLegal	25	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-07-03"}
64	Programar dosificación clínica	12	2026-07-04 10:40:00	2026-07-04 10:40:00	Rubén Añez Peña	clinica	Prescripción FEFO para Snoopy	PrescripcionDosificacion	13	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-07-04"}
65	Registrar factura de compra IVA	6	2026-07-06 11:20:00	2026-07-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Clínica y Proveedora Veterinaria Urbarí por Bs. 455	FacturaCompra	13	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-07-06"}
169	Cerrar sesión	6	2026-11-12 19:53:43	2026-11-12 19:53:43	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
66	Emitir factura legal	5	2026-07-09 11:22:00	2026-07-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 502 por Bs. 700	FacturaLegal	26	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-07-09"}
67	Programar dosificación clínica	13	2026-07-13 11:40:00	2026-07-13 11:40:00	Tatiana Condori Saucedo	clinica	Prescripción FEFO para Sombra	PrescripcionDosificacion	14	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-07-13"}
68	Emitir factura legal	5	2026-07-15 13:29:00	2026-07-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 503 por Bs. 140	FacturaLegal	27	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-07-15"}
69	Registrar factura de compra IVA	6	2026-07-16 12:20:00	2026-07-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Suministros Hospitalarios Santa Cruz por Bs. 550	FacturaCompra	14	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-07-16"}
70	Emitir factura legal	5	2026-07-21 15:36:00	2026-07-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 504 por Bs. 230	FacturaLegal	28	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-07-21"}
71	Emitir factura legal	5	2026-08-03 09:15:00	2026-08-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 505 por Bs. 350	FacturaLegal	29	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-08-03"}
72	Programar dosificación clínica	13	2026-08-04 10:40:00	2026-08-04 10:40:00	Tatiana Condori Saucedo	clinica	Prescripción FEFO para Ragnar	PrescripcionDosificacion	15	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-08-04"}
73	Registrar factura de compra IVA	6	2026-08-06 11:20:00	2026-08-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Suministros Hospitalarios Santa Cruz por Bs. 480	FacturaCompra	15	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-08-06"}
74	Emitir factura legal	5	2026-08-09 11:22:00	2026-08-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 506 por Bs. 280	FacturaLegal	30	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-08-09"}
75	Programar dosificación clínica	14	2026-08-13 11:40:00	2026-08-13 11:40:00	Ignacio Flores Dorado	clinica	Prescripción FEFO para Chispa	PrescripcionDosificacion	16	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-08-13"}
76	Emitir factura legal	5	2026-08-15 13:29:00	2026-08-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 507 por Bs. 120	FacturaLegal	31	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-08-15"}
77	Registrar factura de compra IVA	6	2026-08-16 12:20:00	2026-08-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Química Industrial Oriente (Desinfectantes) por Bs. 575	FacturaCompra	16	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-08-16"}
78	Emitir factura legal	5	2026-08-21 15:36:00	2026-08-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 508 por Bs. 160	FacturaLegal	32	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-08-21"}
79	Emitir factura legal	5	2026-09-03 09:15:00	2026-09-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 509 por Bs. 140	FacturaLegal	33	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-09-03"}
80	Programar dosificación clínica	14	2026-09-04 10:40:00	2026-09-04 10:40:00	Ignacio Flores Dorado	clinica	Prescripción FEFO para Capitán	PrescripcionDosificacion	17	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-09-04"}
81	Registrar factura de compra IVA	6	2026-09-06 11:20:00	2026-09-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Química Industrial Oriente (Desinfectantes) por Bs. 505	FacturaCompra	17	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-09-06"}
82	Emitir factura legal	5	2026-09-09 11:22:00	2026-09-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 510 por Bs. 240	FacturaLegal	34	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-09-09"}
83	Programar dosificación clínica	15	2026-09-13 11:40:00	2026-09-13 11:40:00	Juan Carlos Torrico Salazar	clinica	Prescripción FEFO para Pardo	PrescripcionDosificacion	18	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-09-13"}
84	Emitir factura legal	5	2026-09-15 13:29:00	2026-09-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 511 por Bs. 85	FacturaLegal	35	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-09-15"}
85	Anular factura legal	6	2026-09-15 16:29:00	2026-09-15 16:29:00	Juan Ronaldo Rojas Ugarte	facturacion	Anulación de Factura N° 511	FacturaLegal	35	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-09-15"}
86	Registrar factura de compra IVA	6	2026-09-16 12:20:00	2026-09-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Plásticos y Descartables Camba por Bs. 600	FacturaCompra	18	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-09-16"}
87	Emitir factura legal	5	2026-09-21 15:36:00	2026-09-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 512 por Bs. 120	FacturaLegal	36	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-09-21"}
88	Emitir factura legal	5	2026-10-03 09:15:00	2026-10-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 513 por Bs. 120	FacturaLegal	37	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-10-03"}
89	Programar dosificación clínica	15	2026-10-04 10:40:00	2026-10-04 10:40:00	Juan Carlos Torrico Salazar	clinica	Prescripción FEFO para Balto	PrescripcionDosificacion	19	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-10-04"}
90	Registrar factura de compra IVA	6	2026-10-06 11:20:00	2026-10-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Plásticos y Descartables Camba por Bs. 530	FacturaCompra	19	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-10-06"}
91	Emitir factura legal	5	2026-10-09 11:22:00	2026-10-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 514 por Bs. 170	FacturaLegal	38	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-10-09"}
92	Programar dosificación clínica	2	2026-10-13 11:40:00	2026-10-13 11:40:00	Dra. Beatriz Morales Peña	clinica	Prescripción FEFO para Canela	PrescripcionDosificacion	20	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-10-13"}
93	Emitir factura legal	5	2026-10-15 13:29:00	2026-10-15 13:29:00	Camila Suárez Roca	facturacion	Factura N° 515 por Bs. 65	FacturaLegal	39	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-10-15"}
94	Registrar factura de compra IVA	6	2026-10-16 12:20:00	2026-10-16 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Distribuidora de Alimentos PetFood SCZ por Bs. 625	FacturaCompra	20	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-10-16"}
95	Emitir factura legal	5	2026-10-21 15:36:00	2026-10-21 15:36:00	Camila Suárez Roca	facturacion	Factura N° 516 por Bs. 690	FacturaLegal	40	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-10-21"}
96	Iniciar sesión	6	2026-10-22 12:06:00	2026-10-22 12:06:00	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
170	Iniciar sesión	6	2026-11-12 20:38:58	2026-11-12 20:38:58	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
97	Suspender cuenta de usuario	6	2026-10-25 08:51:00	2026-10-25 08:51:00	Juan Ronaldo Rojas Ugarte	usuarios	Suspender cuenta de usuario	User	1	127.0.0.1	PATCH	api/usuarios/{usuario}/estado	exitosa	{"estado_anterior":true,"estado_nuevo":false}
98	Cerrar sesión	6	2026-10-25 18:30:00	2026-10-25 18:30:00	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
99	Iniciar sesión	1	2026-11-02 01:11:16	2026-11-02 01:11:16	Carlos Eduardo Mendoza	autenticacion	Iniciar sesión	User	1	127.0.0.1	POST	api/login	exitosa	\N
100	Iniciar sesión	1	2026-11-02 01:11:31	2026-11-02 01:11:31	Carlos Eduardo Mendoza	autenticacion	Iniciar sesión	User	1	127.0.0.1	POST	api/login	exitosa	\N
101	Cerrar sesión	1	2026-11-02 01:24:57	2026-11-02 01:24:57	Carlos Eduardo Mendoza	autenticacion	Cerrar sesión	User	1	127.0.0.1	POST	api/logout	exitosa	\N
102	Restablecer contraseña	6	2026-11-02 01:55:00	2026-11-02 01:55:00	Juan Ronaldo Rojas Ugarte	autenticacion	Restablecer contraseña	User	6	127.0.0.1	POST	api/restablecer-password	exitosa	\N
103	Iniciar sesión	6	2026-11-02 01:55:26	2026-11-02 01:55:26	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
104	Iniciar sesión	6	2026-11-02 01:56:03	2026-11-02 01:56:03	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
105	Cerrar sesión	6	2026-11-02 01:56:22	2026-11-02 01:56:22	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
106	Iniciar sesión	6	2026-11-02 02:18:24	2026-11-02 02:18:24	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
107	Cerrar sesión	6	2026-11-02 02:33:53	2026-11-02 02:33:53	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
108	Iniciar sesión	6	2026-11-02 02:52:39	2026-11-02 02:52:39	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
109	Iniciar sesión	6	2026-11-02 02:59:14	2026-11-02 02:59:14	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
110	Iniciar sesión	1	2026-11-02 03:58:58	2026-11-02 03:58:58	Carlos Eduardo Mendoza	autenticacion	Iniciar sesión	User	1	127.0.0.1	POST	api/login	exitosa	\N
111	Iniciar sesión	1	2026-11-02 03:59:08	2026-11-02 03:59:08	Carlos Eduardo Mendoza	autenticacion	Iniciar sesión	User	1	127.0.0.1	POST	api/login	exitosa	\N
112	Emitir factura legal	5	2026-11-03 09:15:00	2026-11-03 09:15:00	Camila Suárez Roca	facturacion	Factura N° 517 por Bs. 85	FacturaLegal	41	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-11-03"}
113	Iniciar sesión	6	2026-11-04 03:35:30	2026-11-04 03:35:30	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
114	Iniciar pago/donación digital	\N	2026-11-04 03:38:02	2026-11-04 03:38:02	No autenticado	pasarela_pagos	Iniciar pago/donación digital	AporteDinero	13	127.0.0.1	POST	/api/sistema	exitosa	{"transaccion_id":"TXN-0BUR3TSQTB","monto":35.5,"canal":"Tarjeta","estado":"Pendiente","stripe":true}
115	Confirmación de pago con tarjeta en Stripe Sandbox	\N	2026-11-04 03:38:04	2026-11-04 03:38:04	No autenticado	pasarela_pagos	Confirmación de pago con tarjeta en Stripe Sandbox	AporteDinero	13	127.0.0.1	POST	/api/sistema	exitosa	{"transaccion_id":"TXN-0BUR3TSQTB","stripe_id":"pi_3UXv1S63IwbkhSOn0OiEOZzW","estado":"Confirmado"}
116	Gestionar anulación / reembolso de transacción	\N	2026-11-04 03:38:06	2026-11-04 03:38:06	No autenticado	pasarela_pagos	Gestionar anulación / reembolso de transacción	AporteDinero	13	127.0.0.1	POST	/api/sistema	exitosa	{"justificacion":"Prueba de anulaci\\u00f3n y reembolso en Stripe Sandbox","monto":"35.50","comprobante":"TXN-0BUR3TSQTB","stripe_refund_id":"re_3UXv1S63IwbkhSOn0Qycv1Et"}
117	Iniciar pago/donación digital	6	2026-11-04 03:52:55	2026-11-04 03:52:55	Juan Ronaldo Rojas Ugarte	pasarela_pagos	Iniciar pago/donación digital	AporteDinero	14	127.0.0.1	POST	api/pasarela/iniciar	exitosa	{"transaccion_id":"TXN-NI5RJ3IPBO","monto":100,"canal":"QR","estado":"Pendiente","stripe":false}
118	Confirmación automática por Webhook	\N	2026-11-04 03:53:12	2026-11-04 03:53:12	No autenticado	pasarela_pagos	Confirmación automática por Webhook	AporteDinero	14	127.0.0.1	POST	api/pasarela/webhook	exitosa	{"transaccion_id":"TXN-NI5RJ3IPBO","estado":"Confirmado"}
119	Cerrar sesión	6	2026-11-04 04:05:47	2026-11-04 04:05:47	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
120	Programar dosificación clínica	2	2026-11-04 10:40:00	2026-11-04 10:40:00	Dra. Beatriz Morales Peña	clinica	Prescripción FEFO para Zeús	PrescripcionDosificacion	21	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-11-04"}
121	Iniciar sesión	6	2026-11-04 12:58:07	2026-11-04 12:58:07	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
122	Cerrar sesión	6	2026-11-04 13:47:18	2026-11-04 13:47:18	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
123	Iniciar sesión	6	2026-11-05 14:09:15	2026-11-05 14:09:15	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
124	Cerrar sesión	6	2026-11-05 14:13:59	2026-11-05 14:13:59	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
125	Intento de inicio de sesión rechazado	\N	2026-11-05 14:14:43	2026-11-05 14:14:43	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
126	Iniciar sesión	6	2026-11-05 14:14:52	2026-11-05 14:14:52	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
127	Cerrar sesión	6	2026-11-05 14:17:03	2026-11-05 14:17:03	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
128	Iniciar sesión	6	2026-11-05 14:19:23	2026-11-05 14:19:23	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
129	Cerrar sesión	6	2026-11-05 14:21:29	2026-11-05 14:21:29	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
130	Iniciar sesión	6	2026-11-05 14:23:36	2026-11-05 14:23:36	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
131	Ampliar tabla proveedors con nuevo atributo estado	6	2026-11-05 14:23:43	2026-11-05 14:23:43	Juan Ronaldo Rojas Ugarte	inventario	Se aumentó el nuevo atributo estado (VARCHAR(50) DEFAULT Activo) en la tabla proveedors y proveedor en PostgreSQL local.	Proveedor	proveedors	127.0.0.1	ALTER	public.proveedors	exitosa	{"tabla_afectada":"public.proveedors","nuevo_atributo_tabla_proveedor":"estado","tipo_dato_sql":"VARCHAR(50) NOT NULL DEFAULT Activo","valores_soportados":["Activo","Inactivo","Suspendido","En revisi\\u00f3n"],"registros_actualizados":50}
171	Cerrar sesión	6	2026-11-12 21:29:22	2026-11-12 21:29:22	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
172	Iniciar sesión	6	2026-11-12 21:29:40	2026-11-12 21:29:40	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
132	Actualizar atributo estado en tabla proveedors	6	2026-11-05 14:23:43	2026-11-05 14:23:43	Juan Ronaldo Rojas Ugarte	inventario	Actualización en tabla proveedors (Comercializadora AgroCruceña) especificando nuevo atributo estado: Activo	Proveedor	2	127.0.0.1	PATCH	api/proveedores/2	exitosa	{"tabla_afectada":"proveedors","nuevo_atributo_tabla_proveedor":"estado","nombre_empresa":"Comercializadora AgroCruce\\u00f1a","identificacion":"NIT-1000002","tipo_insumo_provisto":"Insumos Veterinarios y Alimento","estado":"Activo"}
133	Actualizar atributo estado en tabla proveedors	6	2026-11-05 14:23:43	2026-11-05 14:23:43	Juan Ronaldo Rojas Ugarte	inventario	Actualización en tabla proveedors (Importadora Médica Santa Cruz) especificando nuevo atributo estado: Activo	Proveedor	3	127.0.0.1	PATCH	api/proveedores/3	exitosa	{"tabla_afectada":"proveedors","nuevo_atributo_tabla_proveedor":"estado","nombre_empresa":"Importadora M\\u00e9dica Santa Cruz","identificacion":"NIT-1000003","tipo_insumo_provisto":"Insumos Veterinarios y Alimento","estado":"Activo"}
134	Actualizar atributo estado en tabla proveedors	6	2026-11-05 14:23:43	2026-11-05 14:23:43	Juan Ronaldo Rojas Ugarte	inventario	Actualización en tabla proveedors (Veterinaria & Distribuidora El Paisano) especificando nuevo atributo estado: Activo	Proveedor	1	127.0.0.1	PATCH	api/proveedores/1	exitosa	{"tabla_afectada":"proveedors","nuevo_atributo_tabla_proveedor":"estado","nombre_empresa":"Veterinaria & Distribuidora El Paisano","identificacion":"NIT-1000001","tipo_insumo_provisto":"Insumos Veterinarios y Alimento","estado":"Activo"}
135	Cerrar sesión	6	2026-11-05 14:25:16	2026-11-05 14:25:16	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
136	Iniciar sesión	6	2026-11-05 14:27:08	2026-11-05 14:27:08	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
137	Registrar factura de compra IVA	6	2026-11-06 11:20:00	2026-11-06 11:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Distribuidora de Alimentos PetFood SCZ por Bs. 555	FacturaCompra	21	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-11-06"}
138	Emitir factura legal	5	2026-11-09 11:22:00	2026-11-09 11:22:00	Camila Suárez Roca	facturacion	Factura N° 518 por Bs. 130	FacturaLegal	42	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-11-09"}
139	Restablecer contraseña	6	2026-11-10 20:26:04	2026-11-10 20:26:04	Juan Ronaldo Rojas Ugarte	autenticacion	Restablecer contraseña	User	6	127.0.0.1	POST	api/restablecer-password	exitosa	\N
140	Iniciar sesión	6	2026-11-10 20:26:19	2026-11-10 20:26:19	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
141	Intento de inicio de sesión rechazado	\N	2026-11-11 15:49:04	2026-11-11 15:49:04	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
142	Iniciar sesión	6	2026-11-11 15:49:59	2026-11-11 15:49:59	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
143	Cerrar sesión	6	2026-11-11 15:53:15	2026-11-11 15:53:15	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
144	Programar dosificación clínica	4	2026-11-12 11:40:00	2026-11-12 11:40:00	Dr. Mateo Vargas Ortiz	clinica	Prescripción FEFO para Pelusa	PrescripcionDosificacion	22	192.168.1.25	POST	/api/clinica	exitosa	{"fecha_operacion":"2026-11-12"}
145	Registrar factura de compra IVA	6	2026-11-12 12:20:00	2026-11-12 12:20:00	Juan Ronaldo Rojas Ugarte	reportes_fiscales	Compra a Bayer Animal Health Bolivia por Bs. 650	FacturaCompra	22	192.168.1.25	POST	/api/reportes_fiscales	exitosa	{"fecha_operacion":"2026-11-12"}
146	Emitir factura legal	5	2026-11-12 13:29:00	2026-11-12 13:29:00	Camila Suárez Roca	facturacion	Factura N° 519 por Bs. 350	FacturaLegal	43	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-11-12"}
147	Emitir factura legal	5	2026-11-12 15:36:00	2026-11-12 15:36:00	Camila Suárez Roca	facturacion	Factura N° 520 por Bs. 270	FacturaLegal	44	192.168.1.25	POST	/api/facturacion	exitosa	{"fecha_operacion":"2026-11-12"}
148	Iniciar sesión	6	2026-11-12 16:17:23	2026-11-12 16:17:23	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
149	Cerrar sesión	6	2026-11-12 16:20:35	2026-11-12 16:20:35	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
150	Iniciar sesión	7	2026-11-12 16:21:04	2026-11-12 16:21:04	Ignacio Ribera Zabala	autenticacion	Iniciar sesión	User	7	127.0.0.1	POST	api/login	exitosa	\N
151	Cerrar sesión	7	2026-11-12 16:27:28	2026-11-12 16:27:28	Ignacio Ribera Zabala	autenticacion	Cerrar sesión	User	7	127.0.0.1	POST	api/logout	exitosa	\N
152	Intento de inicio de sesión rechazado	\N	2026-11-12 16:28:30	2026-11-12 16:28:30	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
153	Iniciar sesión	16	2026-11-12 16:28:31	2026-11-12 16:28:31	Gonzalo Morales Román	autenticacion	Iniciar sesión	User	16	127.0.0.1	POST	api/login	exitosa	\N
154	Cerrar sesión	16	2026-11-12 17:36:08	2026-11-12 17:36:08	Gonzalo Morales Román	autenticacion	Cerrar sesión	User	16	127.0.0.1	POST	api/logout	exitosa	\N
155	Iniciar sesión	16	2026-11-12 17:36:33	2026-11-12 17:36:33	Gonzalo Morales Román	autenticacion	Iniciar sesión	User	16	127.0.0.1	POST	api/login	exitosa	\N
156	Cerrar sesión	16	2026-11-12 17:41:27	2026-11-12 17:41:27	Gonzalo Morales Román	autenticacion	Cerrar sesión	User	16	127.0.0.1	POST	api/logout	exitosa	\N
157	Iniciar sesión	7	2026-11-12 17:41:35	2026-11-12 17:41:35	Ignacio Ribera Zabala	autenticacion	Iniciar sesión	User	7	127.0.0.1	POST	api/login	exitosa	\N
158	Cerrar sesión	7	2026-11-12 17:45:43	2026-11-12 17:45:43	Ignacio Ribera Zabala	autenticacion	Cerrar sesión	User	7	127.0.0.1	POST	api/logout	exitosa	\N
159	Intento de inicio de sesión rechazado	\N	2026-11-12 17:48:49	2026-11-12 17:48:49	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
160	Iniciar sesión	6	2026-11-12 17:48:58	2026-11-12 17:48:58	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
161	Cerrar sesión	6	2026-11-12 18:07:01	2026-11-12 18:07:01	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
162	Iniciar sesión	6	2026-11-12 18:46:15	2026-11-12 18:46:15	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
163	Cerrar sesión	6	2026-11-12 19:07:41	2026-11-12 19:07:41	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
164	Iniciar sesión	6	2026-11-12 19:07:58	2026-11-12 19:07:58	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
165	Cerrar sesión	6	2026-11-12 19:18:02	2026-11-12 19:18:02	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
166	Iniciar sesión	6	2026-11-12 19:18:24	2026-11-12 19:18:24	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
167	Cerrar sesión	6	2026-11-12 19:29:18	2026-11-12 19:29:18	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
173	Cerrar sesión	6	2026-11-12 21:35:51	2026-11-12 21:35:51	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
174	Intento de inicio de sesión rechazado	\N	2026-11-12 21:36:15	2026-11-12 21:36:15	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
175	Iniciar sesión	6	2026-11-12 21:36:23	2026-11-12 21:36:23	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
176	Cerrar sesión	6	2026-11-12 21:38:01	2026-11-12 21:38:01	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
177	Iniciar sesión	6	2026-11-12 21:38:18	2026-11-12 21:38:18	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
178	Intento de inicio de sesión rechazado	\N	2026-11-16 18:31:28	2026-11-16 18:31:28	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
179	Iniciar sesión	6	2026-11-16 18:31:36	2026-11-16 18:31:36	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
180	Cerrar sesión	6	2026-11-16 19:30:11	2026-11-16 19:30:11	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
181	Iniciar sesión	6	2026-11-16 19:30:27	2026-11-16 19:30:27	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
182	Cerrar sesión	6	2026-11-16 19:43:41	2026-11-16 19:43:41	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
183	Donación online pública (Mensual (Recurrente))	51	2026-11-16 20:24:37	2026-11-16 20:24:37	angel	donaciones	Donación online pública (Mensual (Recurrente))	Donacion	93	127.0.0.1	POST	api/donaciones/publica	exitosa	{"monto":500,"frecuencia":"Mensual (Recurrente)","recibo":"REC-000015"}
184	Intento de inicio de sesión rechazado	\N	2026-11-17 12:42:46	2026-11-17 12:42:46	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
185	Iniciar sesión	6	2026-11-17 12:42:50	2026-11-17 12:42:50	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
186	Cerrar sesión	6	2026-11-17 14:35:16	2026-11-17 14:35:16	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
187	Iniciar sesión	6	2026-11-17 15:17:02	2026-11-17 15:17:02	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
188	Cerrar sesión	6	2026-11-17 15:23:40	2026-11-17 15:23:40	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
189	Iniciar sesión	6	2026-11-17 16:09:19	2026-11-17 16:09:19	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
190	Cerrar sesión	6	2026-11-17 16:24:15	2026-11-17 16:24:15	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
191	Iniciar sesión	6	2026-11-17 17:04:36	2026-11-17 17:04:36	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
192	Iniciar sesión	6	2026-11-19 12:38:43	2026-11-19 12:38:43	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
193	Cerrar sesión	6	2026-11-19 14:30:50	2026-11-19 14:30:50	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
194	Intento de inicio de sesión rechazado	\N	2026-11-19 14:39:06	2026-11-19 14:39:06	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
195	Iniciar sesión	6	2026-11-19 14:39:11	2026-11-19 14:39:11	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
196	Iniciar pago/donación digital	6	2026-11-19 14:46:51	2026-11-19 14:46:51	Juan Ronaldo Rojas Ugarte	pasarela_pagos	Iniciar pago/donación digital	AporteDinero	16	127.0.0.1	POST	api/pasarela/iniciar	exitosa	{"transaccion_id":"TXN-8FPOVSA2EM","monto":100,"canal":"QR","estado":"Pendiente","stripe":false}
197	Confirmación automática por Webhook	\N	2026-11-19 14:47:24	2026-11-19 14:47:24	No autenticado	pasarela_pagos	Confirmación automática por Webhook	AporteDinero	16	127.0.0.1	POST	api/pasarela/webhook	exitosa	{"transaccion_id":"TXN-8FPOVSA2EM","estado":"Confirmado"}
198	Cerrar sesión	6	2026-11-21 09:20:10	2026-11-21 09:20:10	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
199	Intento de inicio de sesión rechazado	\N	2026-11-21 09:42:10	2026-11-21 09:42:10	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
200	Iniciar sesión	5	2026-11-21 09:42:20	2026-11-21 09:42:20	Camila Suárez Roca	autenticacion	Iniciar sesión	User	5	127.0.0.1	POST	api/login	exitosa	\N
201	Formalizar adopción y programar visitas	5	2026-11-21 10:36:58	2026-11-21 10:36:58	Camila Suárez Roca	adopciones	Formalizar adopción y programar visitas	Adopcion	51	127.0.0.1	POST	api/adopciones	exitosa	{"adoptante":"Adriana Aguilera Aguilera","mascota":"Lucas","visitas_programadas":3}
202	Formalizar adopción y programar visitas	5	2026-11-21 10:40:09	2026-11-21 10:40:09	Camila Suárez Roca	adopciones	Formalizar adopción y programar visitas	Adopcion	52	127.0.0.1	POST	api/adopciones	exitosa	{"adoptante":"Bruno Zabala Paz","mascota":"Coco","visitas_programadas":3}
203	Registrar visita de seguimiento post-adopción	5	2026-11-21 10:40:59	2026-11-21 10:40:59	Camila Suárez Roca	seguimiento_adopciones	Registrar visita de seguimiento post-adopción	SeguimientoAdopcion	1	127.0.0.1	POST	api/seguimientos/{seguimiento}	exitosa	{"estado":"Concluido Satisfactorio","fecha_realizada":"2026-02-15","fotografia":"\\/uploads\\/visitas\\/visita_20261121_104059_6b01ad7be8f2e_0.jpeg|https:\\/\\/refugio.org\\/evidencias\\/seg_firulais_1.jpg"}
204	Registrar salida de inventario	5	2026-11-21 10:44:30	2026-11-21 10:44:30	Camila Suárez Roca	inventario	Se registró el consumo de artículos y se descontó el stock.	SalidaInventario	11	127.0.0.1	POST	api/salidas-inventario	exitosa	{"motivo":"se ensuciaron toda la ropa puesta los perritos","destino":"limpieza","fecha_salida":"2026-11-21","cantidad_lineas":1,"articulos":["Lavandina Concentrada 5L"]}
205	Cerrar sesión	5	2026-11-21 10:45:30	2026-11-21 10:45:30	Camila Suárez Roca	autenticacion	Cerrar sesión	User	5	127.0.0.1	POST	api/logout	exitosa	\N
206	Iniciar sesión	2	2026-11-21 10:46:05	2026-11-21 10:46:05	Dra. Beatriz Morales Peña	autenticacion	Iniciar sesión	User	2	127.0.0.1	POST	api/login	exitosa	\N
207	Cerrar sesión	2	2026-11-21 10:48:23	2026-11-21 10:48:23	Dra. Beatriz Morales Peña	autenticacion	Cerrar sesión	User	2	127.0.0.1	POST	api/logout	exitosa	\N
208	Intento de inicio de sesión rechazado	\N	2026-11-21 10:48:34	2026-11-21 10:48:34	No autenticado	autenticacion	Credenciales rechazadas.	\N	\N	127.0.0.1	POST	api/login	fallida	\N
209	Iniciar sesión	3	2026-11-21 10:48:44	2026-11-21 10:48:44	Lucía Fernández Claros	autenticacion	Iniciar sesión	User	3	127.0.0.1	POST	api/login	exitosa	\N
210	Cerrar sesión	3	2026-11-21 10:53:26	2026-11-21 10:53:26	Lucía Fernández Claros	autenticacion	Cerrar sesión	User	3	127.0.0.1	POST	api/logout	exitosa	\N
211	Iniciar sesión	53	2026-11-21 10:53:53	2026-11-21 10:53:53	Valeria Ribera (Postulante)	autenticacion	Iniciar sesión	User	53	127.0.0.1	POST	api/login	exitosa	\N
212	Cerrar sesión	53	2026-11-21 11:11:15	2026-11-21 11:11:15	Valeria Ribera (Postulante)	autenticacion	Cerrar sesión	User	53	127.0.0.1	POST	api/logout	exitosa	\N
213	Iniciar sesión	52	2026-11-21 11:11:26	2026-11-21 11:11:26	Roberto Justiniano (Donante)	autenticacion	Iniciar sesión	User	52	127.0.0.1	POST	api/login	exitosa	\N
214	Cerrar sesión	52	2026-11-21 11:11:56	2026-11-21 11:11:56	Roberto Justiniano (Donante)	autenticacion	Cerrar sesión	User	52	127.0.0.1	POST	api/logout	exitosa	\N
215	Iniciar sesión	3	2026-11-21 11:18:02	2026-11-21 11:18:02	Lucía Fernández Claros	autenticacion	Iniciar sesión	User	3	127.0.0.1	POST	api/login	exitosa	\N
216	Cerrar sesión	3	2026-11-21 11:21:17	2026-11-21 11:21:17	Lucía Fernández Claros	autenticacion	Cerrar sesión	User	3	127.0.0.1	POST	api/logout	exitosa	\N
217	Iniciar sesión	2	2026-11-21 11:21:28	2026-11-21 11:21:28	Dra. Beatriz Morales Peña	autenticacion	Iniciar sesión	User	2	127.0.0.1	POST	api/login	exitosa	\N
218	Cerrar sesión	2	2026-11-21 12:06:52	2026-11-21 12:06:52	Dra. Beatriz Morales Peña	autenticacion	Cerrar sesión	User	2	127.0.0.1	POST	api/logout	exitosa	\N
219	Iniciar sesión	2	2026-11-21 12:56:03	2026-11-21 12:56:03	Dra. Beatriz Morales Peña	autenticacion	Iniciar sesión	User	2	127.0.0.1	POST	api/login	exitosa	\N
220	Cerrar sesión	2	2026-11-21 12:56:33	2026-11-21 12:56:33	Dra. Beatriz Morales Peña	autenticacion	Cerrar sesión	User	2	127.0.0.1	POST	api/logout	exitosa	\N
221	Iniciar sesión	6	2026-11-21 13:14:41	2026-11-21 13:14:41	Juan Ronaldo Rojas Ugarte	autenticacion	Iniciar sesión	User	6	127.0.0.1	POST	api/login	exitosa	\N
222	Modificar evaluación de postulante	6	2026-11-21 13:58:44	2026-11-21 13:58:44	Juan Ronaldo Rojas Ugarte	adopciones	Modificar evaluación de postulante	InteresadoAdopcion	59	127.0.0.1	PATCH	api/postulantes/{postulante}	exitosa	{"campos_modificados":["estado"]}
223	Cerrar sesión	6	2026-11-21 15:11:29	2026-11-21 15:11:29	Juan Ronaldo Rojas Ugarte	autenticacion	Cerrar sesión	User	6	127.0.0.1	POST	api/logout	exitosa	\N
224	Iniciar sesión	2	2026-11-21 15:12:00	2026-11-21 15:12:00	Dra. Beatriz Morales Peña	autenticacion	Iniciar sesión	User	2	127.0.0.1	POST	api/login	exitosa	\N
225	Cerrar sesión	2	2026-11-21 15:22:19	2026-11-21 15:22:19	Dra. Beatriz Morales Peña	autenticacion	Cerrar sesión	User	2	127.0.0.1	POST	api/logout	exitosa	\N
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cache (key, value, expiration) FROM stdin;
los-angelitos-de-edgar-cache-login-attempts:df8eb7a8579e66a48f223d8d7fbbc9181cd4d629d9579d061284ec2b4096abdf	i:1;	1793888383
los-angelitos-de-edgar-cache-5c785c036466adea360111aa28563bfd556b5fba:timer	i:1794342423;	1794342423
los-angelitos-de-edgar-cache-5c785c036466adea360111aa28563bfd556b5fba	i:1;	1794342423
los-angelitos-de-edgar-cache-roster:project:v3:b3172106c3e4872eef41676820b86740	TzoyNjoiTGFyYXZlbFxSb3N0ZXJcUHJvamVjdFNjYW4iOjg6e3M6ODoiYmFzZVBhdGgiO3M6NDQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cIjtzOjM6InBocCI7TzozNToiTGFyYXZlbFxSb3N0ZXJcRWNvc3lzdGVtc1xFY29zeXN0ZW0iOjI6e3M6OToiACoAYnlOYW1lIjthOjE0MDp7czoxMDoiYnJpY2svbWF0aCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEwOiJicmljay9tYXRoIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjAuMTguMCI7czo5OiIAKgBzb3VyY2UiO0U6NDM6IkxhcmF2ZWxcUm9zdGVyXEVudW1zXFBhY2thZ2VTb3VyY2U6Q29tcG9zZXIiO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjYxOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxicmlja1xtYXRoIjt9czozMToiY2FyYm9ucGhwL2NhcmJvbi1kb2N0cmluZS10eXBlcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMxOiJjYXJib25waHAvY2FyYm9uLWRvY3RyaW5lLXR5cGVzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjMuMi4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjgyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxjYXJib25waHBcY2FyYm9uLWRvY3RyaW5lLXR5cGVzIjt9czoyMzoiZGZseWRldi9kb3QtYWNjZXNzLWRhdGEiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMzoiZGZseWRldi9kb3QtYWNjZXNzLWRhdGEiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy4wLjMiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGRmbHlkZXZcZG90LWFjY2Vzcy1kYXRhIjt9czoxODoiZG9jdHJpbmUvaW5mbGVjdG9yIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTg6ImRvY3RyaW5lL2luZmxlY3RvciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjEuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2OToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcZG9jdHJpbmVcaW5mbGVjdG9yIjt9czoxNDoiZG9jdHJpbmUvbGV4ZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNDoiZG9jdHJpbmUvbGV4ZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy4wLjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGRvY3RyaW5lXGxleGVyIjt9czoyOToiZHJhZ29ubWFudGFuay9jcm9uLWV4cHJlc3Npb24iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyOToiZHJhZ29ubWFudGFuay9jcm9uLWV4cHJlc3Npb24iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy42LjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGRyYWdvbm1hbnRhbmtcY3Jvbi1leHByZXNzaW9uIjt9czoyMzoiZWd1bGlhcy9lbWFpbC12YWxpZGF0b3IiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMzoiZWd1bGlhcy9lbWFpbC12YWxpZGF0b3IiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4wLjQiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGVndWxpYXNcZW1haWwtdmFsaWRhdG9yIjt9czoxODoiZnJ1aXRjYWtlL3BocC1jb3JzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTg6ImZydWl0Y2FrZS9waHAtY29ycyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjQuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2OToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcZnJ1aXRjYWtlXHBocC1jb3JzIjt9czoyNzoiZ3JhaGFtLWNhbXBiZWxsL3Jlc3VsdC10eXBlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6ImdyYWhhbS1jYW1wYmVsbC9yZXN1bHQtdHlwZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjIuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcZ3JhaGFtLWNhbXBiZWxsXHJlc3VsdC10eXBlIjt9czoxNzoiZ3V6emxlaHR0cC9ndXp6bGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoiZ3V6emxlaHR0cC9ndXp6bGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiOC4xLjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGd1enpsZWh0dHBcZ3V6emxlIjt9czoxOToiZ3V6emxlaHR0cC9wcm9taXNlcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE5OiJndXp6bGVodHRwL3Byb21pc2VzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjMuMC4yIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjcwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxndXp6bGVodHRwXHByb21pc2VzIjt9czoxNToiZ3V6emxlaHR0cC9wc3I3IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTU6Imd1enpsZWh0dHAvcHNyNyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIzLjEuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcZ3V6emxlaHR0cFxwc3I3Ijt9czoyMzoiZ3V6emxlaHR0cC91cmktdGVtcGxhdGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMzoiZ3V6emxlaHR0cC91cmktdGVtcGxhdGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi4wLjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGd1enpsZWh0dHBcdXJpLXRlbXBsYXRlIjt9czoyNToiaW5lcnRpYWpzL2luZXJ0aWEtbGFyYXZlbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI1OiJpbmVydGlhanMvaW5lcnRpYS1sYXJhdmVsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjMuMy4xIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjQ6Il4zLjAiO3M6NzoiACoAcGF0aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcaW5lcnRpYWpzXGluZXJ0aWEtbGFyYXZlbCI7fXM6MTc6ImxhcmF2ZWwvZnJhbWV3b3JrIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6ImxhcmF2ZWwvZnJhbWV3b3JrIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjc6IjEzLjI5LjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NjoiXjEzLjE3IjtzOjc6IgAqAHBhdGgiO3M6Njg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmF2ZWxcZnJhbWV3b3JrIjt9czoxNToibGFyYXZlbC9wcm9tcHRzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTU6ImxhcmF2ZWwvcHJvbXB0cyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIwLjMuMjQiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmF2ZWxccHJvbXB0cyI7fXM6MTU6ImxhcmF2ZWwvc2FuY3R1bSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE1OiJsYXJhdmVsL3NhbmN0dW0iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4zLjMiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NDoiXjQuMCI7czo3OiIAKgBwYXRoIjtzOjY2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXHNhbmN0dW0iO31zOjI4OiJsYXJhdmVsL3NlcmlhbGl6YWJsZS1jbG9zdXJlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjg6ImxhcmF2ZWwvc2VyaWFsaXphYmxlLWNsb3N1cmUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMi4wLjE2IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXHNlcmlhbGl6YWJsZS1jbG9zdXJlIjt9czoxNDoibGFyYXZlbC90aW5rZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNDoibGFyYXZlbC90aW5rZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy4wLjIiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NDoiXjMuMCI7czo3OiIAKgBwYXRoIjtzOjY1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXHRpbmtlciI7fXM6MTc6ImxhcmF2ZWwvd2F5ZmluZGVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6ImxhcmF2ZWwvd2F5ZmluZGVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjAuMS4yMSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjE7czoxMzoiACoAY29uc3RyYWludCI7czo3OiJeMC4xLjE0IjtzOjc6IgAqAHBhdGgiO3M6Njg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmF2ZWxcd2F5ZmluZGVyIjt9czoxNzoibGVhZ3VlL2NvbW1vbm1hcmsiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoibGVhZ3VlL2NvbW1vbm1hcmsiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMi4xMC4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsZWFndWVcY29tbW9ubWFyayI7fXM6MTM6ImxlYWd1ZS9jb25maWciO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxMzoibGVhZ3VlL2NvbmZpZyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjIuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcbGVhZ3VlXGNvbmZpZyI7fXM6MTY6ImxlYWd1ZS9mbHlzeXN0ZW0iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNjoibGVhZ3VlL2ZseXN5c3RlbSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIzLjM1LjMiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxlYWd1ZVxmbHlzeXN0ZW0iO31zOjIyOiJsZWFndWUvZmx5c3lzdGVtLWxvY2FsIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjI6ImxlYWd1ZS9mbHlzeXN0ZW0tbG9jYWwiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMy4zNS4zIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjczOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsZWFndWVcZmx5c3lzdGVtLWxvY2FsIjt9czoyNjoibGVhZ3VlL21pbWUtdHlwZS1kZXRlY3Rpb24iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNjoibGVhZ3VlL21pbWUtdHlwZS1kZXRlY3Rpb24iO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xNy4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsZWFndWVcbWltZS10eXBlLWRldGVjdGlvbiI7fXM6MTA6ImxlYWd1ZS91cmkiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoA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YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc3ltZm9ueVxjbG9jayI7fXM6MTU6InN5bWZvbnkvY29uc29sZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE1OiJzeW1mb255L2NvbnNvbGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy40LjE3IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzeW1mb255XGNvbnNvbGUiO31zOjIwOiJzeW1mb255L2Nzcy1zZWxlY3RvciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIwOiJzeW1mb255L2Nzcy1zZWxlY3RvciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcY3NzLXNlbGVjdG9yIjt9czoyOToic3ltZm9ueS9kZXByZWNhdGlvbi1jb250cmFjdHMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyOToic3ltZm9ueS9kZXByZWNhdGlvbi1jb250cmFjdHMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy43LjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcZGVwcmVjYXRpb24tY29udHJhY3RzIjt9czoyMToic3ltZm9ueS9lcnJvci1oYW5kbGVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjE6InN5bWZvbnkvZXJyb3ItaGFuZGxlciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzI6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcZXJyb3ItaGFuZGxlciI7fXM6MjQ6InN5bWZvbnkvZXZlbnQtZGlzcGF0Y2hlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI0OiJzeW1mb255L2V2ZW50LWRpc3BhdGNoZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy40LjE3IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzeW1mb255XGV2ZW50LWRpc3BhdGNoZXIiO31zOjM0OiJzeW1mb255L2V2ZW50LWRpc3BhdGNoZXItY29udHJhY3RzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzQ6InN5bWZvbnkvZXZlbnQtZGlzcGF0Y2hlci1jb250cmFjdHMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy43LjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcZXZlbnQtZGlzcGF0Y2hlci1jb250cmFjdHMiO31zOjE0OiJzeW1mb255L2ZpbmRlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE0OiJzeW1mb255L2ZpbmRlciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcZmluZGVyIjt9czoyMzoic3ltZm9ueS9odHRwLWZvdW5kYXRpb24iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMzoic3ltZm9ueS9odHRwLWZvdW5kYXRpb24iO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy40LjE3IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc0OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzeW1mb255XGh0dHAtZm91bmRhdGlvbiI7fXM6MTk6InN5bWZvbnkvaHR0cC1rZXJuZWwiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxOToic3ltZm9ueS9odHRwLWtlcm5lbCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcaHR0cC1rZXJuZWwiO31zOjE0OiJzeW1mb255L21haWxlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE0OiJzeW1mb255L21haWxlciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcbWFpbGVyIjt9czoxMjoic3ltZm9ueS9taW1lIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTI6InN5bWZvbnkvbWltZSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcbWltZSI7fXM6MjI6InN5bWZvbnkvcG9seWZpbGwtY3R5cGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMjoic3ltZm9ueS9wb2x5ZmlsbC1jdHlwZSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjM3LjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlccG9seWZpbGwtY3R5cGUiO31zOjMwOiJzeW1mb255L3BvbHlmaWxsLWludGwtZ3JhcGhlbWUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMDoic3ltZm9ueS9wb2x5ZmlsbC1pbnRsLWdyYXBoZW1lIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuNDEuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc3ltZm9ueVxwb2x5ZmlsbC1pbnRsLWdyYXBoZW1lIjt9czoyNToic3ltZm9ueS9wb2x5ZmlsbC1pbnRsLWlkbiI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI1OiJzeW1mb255L3BvbHlmaWxsLWludGwtaWRuIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuNDIuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc3ltZm9ueVxwb2x5ZmlsbC1pbnRsLWlkbiI7fXM6MzI6InN5bWZvbnkvcG9seWZpbGwtaW50bC1ub3JtYWxpemVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzI6InN5bWZvbnkvcG9seWZpbGwtaW50bC1ub3JtYWxpemVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuNDIuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc3ltZm9ueVxwb2x5ZmlsbC1pbnRsLW5vcm1hbGl6ZXIiO31zOjI1OiJzeW1mb255L3BvbHlmaWxsLW1ic3RyaW5nIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjU6InN5bWZvbnkvcG9seWZpbGwtbWJzdHJpbmciO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zOC4yIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzeW1mb255XHBvbHlmaWxsLW1ic3RyaW5nIjt9czoyMjoic3ltZm9ueS9wb2x5ZmlsbC1waHA4MCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIyOiJzeW1mb255L3BvbHlmaWxsLXBocDgwIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMzcuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc3ltZm9ueVxwb2x5ZmlsbC1waHA4MCI7fXM6MjI6InN5bWZvbnkvcG9seWZpbGwtcGhwODIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMjoic3ltZm9ueS9wb2x5ZmlsbC1waHA4MiI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjM4LjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlccG9seWZpbGwtcGhwODIiO31zOjIyOiJzeW1mb255L3BvbHlmaWxsLXBocDgzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjI6InN5bWZvbnkvcG9seWZpbGwtcGhwODMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS40MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjczOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzeW1mb255XHBvbHlmaWxsLXBocDgzIjt9czoyMjoic3ltZm9ueS9wb2x5ZmlsbC1waHA4NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIyOiJzeW1mb255L3BvbHlmaWxsLXBocDg0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMzguMSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc3ltZm9ueVxwb2x5ZmlsbC1waHA4NCI7fXM6MjI6InN5bWZvbnkvcG9seWZpbGwtcGhwODUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMjoic3ltZm9ueS9wb2x5ZmlsbC1waHA4NSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjQxLjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlccG9seWZpbGwtcGhwODUiO31zOjIyOiJzeW1mb255L3BvbHlmaWxsLXBocDg2IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjI6InN5bWZvbnkvcG9seWZpbGwtcGhwODYiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS40MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjczOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzeW1mb255XHBvbHlmaWxsLXBocDg2Ijt9czoyMToic3ltZm9ueS9wb2x5ZmlsbC11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dGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlcdmFyLWR1bXBlciI7fXM6MzM6InRpanN2ZXJrb3llbi9jc3MtdG8taW5saW5lLXN0eWxlcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMzOiJ0aWpzdmVya295ZW4vY3NzLXRvLWlubGluZS1zdHlsZXMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi40LjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHRpanN2ZXJrb3llblxjc3MtdG8taW5saW5lLXN0eWxlcyI7fXM6MTY6InZsdWNhcy9waHBkb3RlbnYiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNjoidmx1Y2FzL3BocGRvdGVudiI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI1LjcuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcdmx1Y2FzXHBocGRvdGVudiI7fXM6MTk6InZva3UvcG9ydGFibGUtYXNjaWkiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxOToidm9rdS9wb3J0YWJsZS1hc2NpaSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjEuMSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcdm9rdVxwb3J0YWJsZS1hc2NpaSI7fXM6MTc6ImJyaWFuaXVtL3BhcmF0ZXN0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6ImJyaWFuaXVtL3BhcmF0ZXN0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcYnJpYW5pdW1ccGFyYXRlc3QiO31zOjEzOiJjb21wb3Nlci9wY3JlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTM6ImNvbXBvc2VyL3BjcmUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy40LjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGNvbXBvc2VyXHBjcmUiO31zOjE1OiJjb21wb3Nlci9zZW12ZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNToiY29tcG9zZXIvc2VtdmVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjMuNC40IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxjb21wb3NlclxzZW12ZXIiO31zOjIzOiJjb21wb3Nlci94ZGVidWctaGFuZGxlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIzOiJjb21wb3Nlci94ZGVidWctaGFuZGxlciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIzLjAuNSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcY29tcG9zZXJceGRlYnVnLWhhbmRsZXIiO31zOjIxOiJkb2N0cmluZS9kZXByZWNhdGlvbnMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMToiZG9jdHJpbmUvZGVwcmVjYXRpb25zIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMS42IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjcyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxkb2N0cmluZVxkZXByZWNhdGlvbnMiO31zOjE0OiJmYWtlcnBocC9mYWtlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE0OiJmYWtlcnBocC9mYWtlciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjI0LjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NToiXjEuMjQiO3M6NzoiACoAcGF0aCI7czo2NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcZmFrZXJwaHBcZmFrZXIiO31zOjIyOiJmaWRyeS9jcHUtY29yZS1jb3VudGVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjI6ImZpZHJ5L2NwdS1jb3JlLWNvdW50ZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4zLjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGZpZHJ5XGNwdS1jb3JlLWNvdW50ZXIiO31zOjExOiJmaWxwL3dob29wcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjExOiJmaWxwL3dob29wcyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIyLjE4LjQiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjI6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGZpbHBcd2hvb3BzIjt9czoyMToiaGFtY3Jlc3QvaGFtY3Jlc3QtcGhwIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjE6ImhhbWNyZXN0L2hhbWNyZXN0LXBocCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIzLjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcaGFtY3Jlc3RcaGFtY3Jlc3QtcGhwIjt9czoxNzoiaWFtY2FsL3NxbC1wYXJzZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoiaWFtY2FsL3NxbC1wYXJzZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6MzoiMC43IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxpYW1jYWxcc3FsLXBhcnNlciI7fXM6MzA6ImplYW44NS9wcmV0dHktcGFja2FnZS12ZXJzaW9ucyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMwOiJqZWFuODUvcHJldHR5LXBhY2thZ2UtdmVyc2lvbnMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi4xLjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGplYW44NVxwcmV0dHktcGFja2FnZS12ZXJzaW9ucyI7fXM6MTc6ImxhcmFzdGFuL2xhcmFzdGFuIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6ImxhcmFzdGFuL2xhcmFzdGFuIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjMuMTAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjE7czoxMzoiACoAY29uc3RyYWludCI7czo0OiJeMy45IjtzOjc6IgAqAHBhdGgiO3M6Njg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmFzdGFuXGxhcmFzdGFuIjt9czoyMjoibGFyYXZlbC9hZ2VudC1kZXRlY3RvciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIyOiJsYXJhdmVsL2FnZW50LWRldGVjdG9yIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjIuMC4yIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjczOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXGFnZW50LWRldGVjdG9yIjt9czoxMzoibGFyYXZlbC9ib29zdCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEzOiJsYXJhdmVsL2Jvb3N0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjIuNy4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjQ6Il4yLjIiO3M6NzoiACoAcGF0aCI7czo2NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcbGFyYXZlbFxib29zdCI7fXM6MTE6ImxhcmF2ZWwvbWNwIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTE6ImxhcmF2ZWwvbWNwIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjAuOS40IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjYyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXG1jcCI7fXM6MTI6ImxhcmF2ZWwvcGFpbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJsYXJhdmVsL3BhaWwiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4yLjciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NjoiXjEuMi41IjtzOjc6IgAqAHBhdGgiO3M6NjM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmF2ZWxccGFpbCI7fXM6MTE6ImxhcmF2ZWwvcGFvIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTE6ImxhcmF2ZWwvcGFvIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMS40IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjY6Il4xLjAuNiI7czo3OiIAKgBwYXRoIjtzOjYyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXHBhbyI7fXM6MTI6ImxhcmF2ZWwvcGludCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJsYXJhdmVsL3BpbnQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zMC41IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjU6Il4xLjI3IjtzOjc6IgAqAHBhdGgiO3M6NjM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmF2ZWxccGludCI7fXM6MTQ6ImxhcmF2ZWwvcm9zdGVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTQ6ImxhcmF2ZWwvcm9zdGVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxsYXJhdmVsXHJvc3RlciI7fXM6MTI6ImxhcmF2ZWwvc2FpbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJsYXJhdmVsL3NhaWwiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS42Ny4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjU6Il4xLjUzIjtzOjc6IgAqAHBhdGgiO3M6NjM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXGxhcmF2ZWxcc2FpbCI7fXM6MTU6Im1vY2tlcnkvbW9ja2VyeSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE1OiJtb2NrZXJ5L21vY2tlcnkiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS42LjE1IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjQ6Il4xLjYiO3M6NzoiACoAcGF0aCI7czo2NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JcbW9ja2VyeVxtb2NrZXJ5Ijt9czoxNzoibXljbGFicy9kZWVwLWNvcHkiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoibXljbGFicy9kZWVwLWNvcHkiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xNC4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxteWNsYWJzXGRlZXAtY29weSI7fXM6MjA6Im51bm9tYWR1cm8vY29sbGlzaW9uIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjA6Im51bm9tYWR1cm8vY29sbGlzaW9uIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjguOS41IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjY6Il44LjkuMyI7czo3OiIAKgBwYXRoIjtzOjcxOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxudW5vbWFkdXJvXGNvbGxpc2lvbiI7fXM6MTI6InBlc3RwaHAvcGVzdCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJwZXN0cGhwL3Blc3QiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC43LjgiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NDoiXjQuNyI7czo3OiIAKgBwYXRoIjtzOjYzOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxwZXN0cGhwXHBlc3QiO31zOjE5OiJwZXN0cGhwL3Blc3QtcGx1Z2luIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTk6InBlc3RwaHAvcGVzdC1wbHVnaW4iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4wLjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHBlc3RwaHBccGVzdC1wbHVnaW4iO31zOjI0OiJwZXN0cGhwL3Blc3QtcGx1Z2luLWFyY2giO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNDoicGVzdHBocC9wZXN0LXBsdWdpbi1hcmNoIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMC4yIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxwZXN0cGhwXHBlc3QtcGx1Z2luLWFyY2giO31zOjI3OiJwZXN0cGhwL3Blc3QtcGx1Z2luLWxhcmF2ZWwiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNzoicGVzdHBocC9wZXN0LXBsdWdpbi1sYXJhdmVsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMS4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjQ6Il40LjEiO3M6NzoiACoAcGF0aCI7czo3ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGVzdHBocFxwZXN0LXBsdWdpbi1sYXJhdmVsIjt9czoyNjoicGVzdHBocC9wZXN0LXBsdWdpbi1tdXRhdGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNjoicGVzdHBocC9wZXN0LXBsdWdpbi1tdXRhdGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4wLjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Nzc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHBlc3RwaHBccGVzdC1wbHVnaW4tbXV0YXRlIjt9czoyOToicGVzdHBocC9wZXN0LXBsdWdpbi1wcm9mYW5pdHkiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyOToicGVzdHBocC9wZXN0LXBsdWdpbi1wcm9mYW5pdHkiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4yLjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHBlc3RwaHBccGVzdC1wbHVnaW4tcHJvZmFuaXR5Ijt9czoxNjoicGhhci1pby9tYW5pZmVzdCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE2OiJwaGFyLWlvL21hbmlmZXN0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjIuMC40IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxwaGFyLWlvXG1hbmlmZXN0Ijt9czoxNToicGhhci1pby92ZXJzaW9uIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTU6InBoYXItaW8vdmVyc2lvbiI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIzLjIuMSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhhci1pb1x2ZXJzaW9uIjt9czozMToicGhwZG9jdW1lbnRvci9yZWZsZWN0aW9uLWNvbW1vbiI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMxOiJwaHBkb2N1bWVudG9yL3JlZmxlY3Rpb24tY29tbW9uIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjIuMi4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjgyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxwaHBkb2N1bWVudG9yXHJlZmxlY3Rpb24tY29tbW9uIjt9czozMzoicGhwZG9jdW1lbnRvci9yZWZsZWN0aW9uLWRvY2Jsb2NrIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzM6InBocGRvY3VtZW50b3IvcmVmbGVjdGlvbi1kb2NibG9jayI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI2LjAuMyI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwZG9jdW1lbnRvclxyZWZsZWN0aW9uLWRvY2Jsb2NrIjt9czoyNzoicGhwZG9jdW1lbnRvci90eXBlLXJlc29sdmVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6InBocGRvY3VtZW50b3IvdHlwZS1yZXNvbHZlciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwZG9jdW1lbnRvclx0eXBlLXJlc29sdmVyIjt9czoxNToicGhwc3Rhbi9waHBzdGFuIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTU6InBocHN0YW4vcGhwc3RhbiI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjIuOSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwc3RhblxwaHBzdGFuIjt9czoyNToicGhwdW5pdC9waHAtY29kZS1jb3ZlcmFnZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI1OiJwaHB1bml0L3BocC1jb2RlLWNvdmVyYWdlIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEyLjUuNyI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwdW5pdFxwaHAtY29kZS1jb3ZlcmFnZSI7fXM6MjU6InBocHVuaXQvcGhwLWZpbGUtaXRlcmF0b3IiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNToicGhwdW5pdC9waHAtZmlsZS1pdGVyYXRvciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI2LjAuMiI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwdW5pdFxwaHAtZmlsZS1pdGVyYXRvciI7fXM6MTk6InBocHVuaXQvcGhwLWludm9rZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxOToicGhwdW5pdC9waHAtaW52b2tlciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI2LjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwdW5pdFxwaHAtaW52b2tlciI7fXM6MjU6InBocHVuaXQvcGhwLXRleHQtdGVtcGxhdGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNToicGhwdW5pdC9waHAtdGV4dC10ZW1wbGF0ZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI1LjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3JccGhwdW5pdFxwaHAtdGV4dC10ZW1wbGF0ZSI7fXM6MTc6InBocHVuaXQvcGhwLXRpbWVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6InBocHVuaXQvcGhwLXRpbWVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjguMC4wIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxwaHB1bml0XHBocC10aW1lciI7fXM6MTU6InBocHVuaXQvcGhwdW5pdCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6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YXN0aWFuL2V4cG9ydGVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTg6InNlYmFzdGlhbi9leHBvcnRlciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI3LjAuMyI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2OToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc2ViYXN0aWFuXGV4cG9ydGVyIjt9czoyMjoic2ViYXN0aWFuL2dsb2JhbC1zdGF0ZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIyOiJzZWJhc3RpYW4vZ2xvYmFsLXN0YXRlIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjguMC4zIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjczOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzZWJhc3RpYW5cZ2xvYmFsLXN0YXRlIjt9czoyMzoic2ViYXN0aWFuL2xpbmVzLW9mLWNvZGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMzoic2ViYXN0aWFuL2xpbmVzLW9mLWNvZGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4wLjEiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHNlYmFzdGlhblxsaW5lcy1vZi1jb2RlIjt9czoyNzoic2ViYXN0aWFuL29iamVjdC1lbnVtZXJhdG9yIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6InNlYmFzdGlhbi9vYmplY3QtZW51bWVyYXRvciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI3LjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc2ViYXN0aWFuXG9iamVjdC1lbnVtZXJhdG9yIjt9czoyNjoic2ViYXN0aWFuL29iamVjdC1yZWZsZWN0b3IiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNjoic2ViYXN0aWFuL29iamVjdC1yZWZsZWN0b3IiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNS4wLjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Nzc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHNlYmFzdGlhblxvYmplY3QtcmVmbGVjdG9yIjt9czoyNzoic2ViYXN0aWFuL3JlY3Vyc2lvbi1jb250ZXh0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6InNlYmFzdGlhbi9yZWN1cnNpb24tY29udGV4dCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI3LjAuMSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcc2ViYXN0aWFuXHJlY3Vyc2lvbi1jb250ZXh0Ijt9czoxNDoic2ViYXN0aWFuL3R5cGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNDoic2ViYXN0aWFuL3R5cGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNi4wLjQiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHNlYmFzdGlhblx0eXBlIjt9czoxNzoic2ViYXN0aWFuL3ZlcnNpb24iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoic2ViYXN0aWFuL3ZlcnNpb24iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNi4wLjAiO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHNlYmFzdGlhblx2ZXJzaW9uIjt9czoyODoic3RhYWJtL3NpZGUtZWZmZWN0cy1kZXRlY3RvciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI4OiJzdGFhYm0vc2lkZS1lZmZlY3RzLWRldGVjdG9yIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC41IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclxzdGFhYm1cc2lkZS1lZmZlY3RzLWRldGVjdG9yIjt9czoxMjoic3ltZm9ueS95YW1sIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTI6InN5bWZvbnkveWFtbCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjQuMTciO3M6OToiACoAc291cmNlIjtyOjg7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cdmVuZG9yXHN5bWZvbnlceWFtbCI7fXM6MzU6InRhLXRpa29tYS9waHB1bml0LWFyY2hpdGVjdHVyZS10ZXN0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzU6InRhLXRpa29tYS9waHB1bml0LWFyY2hpdGVjdHVyZS10ZXN0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjAuOC43IjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclx0YS10aWtvbWFccGhwdW5pdC1hcmNoaXRlY3R1cmUtdGVzdCI7fXM6MTc6InRoZXNlZXIvdG9rZW5pemVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6InRoZXNlZXIvdG9rZW5pemVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjIuMC4xIjtzOjk6IgAqAHNvdXJjZSI7cjo4O3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXHZlbmRvclx0aGVzZWVyXHRva2VuaXplciI7fXM6MTY6IndlYm1vemFydC9hc3NlcnQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNjoid2VibW96YXJ0L2Fzc2VydCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjQuMSI7czo5OiIAKgBzb3VyY2UiO3I6ODtzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1x2ZW5kb3Jcd2VibW96YXJ0XGFzc2VydCI7fX1zOjExOiIAKgBwYWNrYWdlcyI7TzozMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZUNvbGxlY3Rpb24iOjI6e3M6ODoiACoAaXRlbXMiO2E6MTQwOntpOjA7cjo1O2k6MTtyOjEzO2k6MjtyOjIxO2k6MztyOjI5O2k6NDtyOjM3O2k6NTtyOjQ1O2k6NjtyOjUzO2k6NztyOjYxO2k6ODtyOjY5O2k6OTtyOjc3O2k6MTA7cjo4NTtpOjExO3I6OTM7aToxMjtyOjEwMTtpOjEzO3I6MTA5O2k6MTQ7cjoxMTc7aToxNTtyOjEyNTtpOjE2O3I6MTMzO2k6MTc7cjoxNDE7aToxODtyOjE0OTtpOjE5O3I6MTU3O2k6MjA7cjoxNjU7aToyMTtyOjE3MztpOjIyO3I6MTgxO2k6MjM7cjoxODk7aToyNDtyOjE5NztpOjI1O3I6MjA1O2k6MjY7cjoyMTM7aToyNztyOjIyMTtpOjI4O3I6MjI5O2k6Mjk7cjoyMzc7aTozMDtyOjI0NTtpOjMxO3I6MjUzO2k6MzI7cjoyNjE7aTozMztyOjI2OTtpOjM0O3I6Mjc3O2k6MzU7cjoyODU7aTozNjtyOjI5MztpOjM3O3I6MzAxO2k6Mzg7cjozMDk7aTozOTtyOjMxNztpOjQwO3I6MzI1O2k6NDE7cjozMzM7aTo0MjtyOjM0MTtpOjQzO3I6MzQ5O2k6NDQ7cjozNTc7aTo0NTtyOjM2NTtpOjQ2O3I6MzczO2k6NDc7cjozODE7aTo0ODtyOjM4OTtpOjQ5O3I6Mzk3O2k6NTA7cjo0MDU7aTo1MTtyOjQxMztpOjUyO3I6NDIxO2k6NTM7cjo0Mjk7aTo1NDtyOjQzNztpOjU1O3I6NDQ1O2k6NTY7cjo0NTM7aTo1NztyOjQ2MTtpOjU4O3I6NDY5O2k6NTk7cjo0Nzc7aTo2MDtyOjQ4NTtpOjYxO3I6NDkzO2k6NjI7cjo1MDE7aTo2MztyOjUwOTtpOjY0O3I6NTE3O2k6NjU7cjo1MjU7aTo2NjtyOjUzMztpOjY3O3I6NTQxO2k6Njg7cjo1NDk7aTo2OTtyOjU1NztpOjcwO3I6NTY1O2k6NzE7cjo1NzM7aTo3MjtyOjU4MTtpOjczO3I6NTg5O2k6NzQ7cjo1OTc7aTo3NTtyOjYwNTtpOjc2O3I6NjEzO2k6Nzc7cjo2MjE7aTo3ODtyOjYyOTtpOjc5O3I6NjM3O2k6ODA7cjo2NDU7aTo4MTtyOjY1MztpOjgyO3I6NjYxO2k6ODM7cjo2Njk7aTo4NDtyOjY3NztpOjg1O3I6Njg1O2k6ODY7cjo2OTM7aTo4NztyOjcwMTtpOjg4O3I6NzA5O2k6ODk7cjo3MTc7aTo5MDtyOjcyNTtpOjkxO3I6NzMzO2k6OTI7cjo3NDE7aTo5MztyOjc0OTtpOjk0O3I6NzU3O2k6OTU7cjo3NjU7aTo5NjtyOjc3MztpOjk3O3I6NzgxO2k6OTg7cjo3ODk7aTo5OTtyOjc5NztpOjEwMDtyOjgwNTtpOjEwMTtyOjgxMztpOjEwMjtyOjgyMTtpOjEwMztyOjgyOTtpOjEwNDtyOjgzNztpOjEwNTtyOjg0NTtpOjEwNjtyOjg1MztpOjEwNztyOjg2MTtpOjEwODtyOjg2OTtpOjEwOTtyOjg3NztpOjEx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Ojc4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAYmFiZWxcaGVscGVyLWdsb2JhbHMiO31zOjI4OiJAYmFiZWwvaGVscGVyLW1vZHVsZS1pbXBvcnRzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjg6IkBiYWJlbC9oZWxwZXItbW9kdWxlLWltcG9ydHMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy4yOS43IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAYmFiZWxcaGVscGVyLW1vZHVsZS1pbXBvcnRzIjt9czozMToiQGJhYmVsL2hlbHBlci1tb2R1bGUtdHJhbnNmb3JtcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMxOiJAYmFiZWwvaGVscGVyLW1vZHVsZS10cmFuc2Zvcm1zIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjkuNyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGJhYmVsXGhlbHBlci1tb2R1bGUtdHJhbnNmb3JtcyI7fXM6MjY6IkBiYWJlbC9oZWxwZXItcGx1Z2luLXV0aWxzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjY6IkBiYWJlbC9oZWxwZXItcGx1Z2luLXV0aWxzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjkuNyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGJhYmVsXGhlbHBlci1wbHVnaW4tdXRpbHMiO31zOjI3OiJAYmFiZWwvaGVscGVyLXN0cmluZy1wYXJzZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNzoiQGJhYmVsL2hlbHBlci1zdHJpbmctcGFyc2VyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjkuNyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGJhYmVsXGhlbHBlci1zdHJpbmctcGFyc2VyIjt9czozNDoiQGJhYmVsL2hlbHBlci12YWxpZGF0b3ItaWRlbnRpZmllciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM0OiJAYmFiZWwvaGVscGVyLXZhbGlkYXRvci1pZGVudGlmaWVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjkuNyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGJhYmVsXGhlbHBlci12YWxpZGF0b3ItaWRlbnRpZmllciI7fXM6MzA6IkBiYWJlbC9oZWxwZXItdmFsaWRhdG9yLW9wdGlvbiI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMwOiJAYmFiZWwvaGVscGVyLXZhbGlkYXRvci1vcHRpb24iO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy4yOS43IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAYmFiZWxcaGVscGVyLXZhbGlkYXRvci1vcHRpb24iO31zOjE0OiJAYmFiZWwvaGVscGVycyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE0OiJAYmFiZWwvaGVscGVycyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjI5LjciO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBiYWJlbFxoZWxwZXJzIjt9czoxMzoiQGJhYmVsL3BhcnNlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEzOiJAYmFiZWwvcGFyc2VyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjkuOSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGJhYmVsXHBhcnNlciI7fXM6Mzg6IkBiYWJlbC9wbHVnaW4tdHJhbnNmb3JtLXJlYWN0LWpzeC1zZWxmIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzg6IkBiYWJlbC9wbHVnaW4tdHJhbnNmb3JtLXJlYWN0LWpzeC1zZWxmIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjcuMjkuNyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGJhYmVsXHBsdWdpbi10cmFuc2Zvcm0tcmVhY3QtanN4LXNlbGYiO31zOjQwOiJAYmFiZWwvcGx1Z2luLXRyYW5zZm9ybS1yZWFjdC1qc3gtc291cmNlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6NDA6IkBiYWJlbC9wbHVnaW4tdHJhbnNmb3JtLXJlYWN0LWpzeC1zb3VyY2UiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy4yOS43IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAYmFiZWxccGx1Z2luLXRyYW5zZm9ybS1yZWFjdC1qc3gtc291cmNlIjt9czoxNToiQGJhYmVsL3RlbXBsYXRlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdl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IjtzOjc6IgAqAHBhdGgiO3M6ODA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBqcmlkZ2V3ZWxsXHJlc29sdmUtdXJpIjt9czoyNzoiQGpyaWRnZXdlbGwvc291cmNlbWFwLWNvZGVjIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6IkBqcmlkZ2V3ZWxsL3NvdXJjZW1hcC1jb2RlYyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjYuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGpyaWRnZXdlbGxcc291cmNlbWFwLWNvZGVjIjt9czoyNToiQGpyaWRnZXdlbGwvdHJhY2UtbWFwcGluZyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI1OiJAanJpZGdld2VsbC90cmFjZS1tYXBwaW5nIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjAuMy4zMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQGpyaWRnZXdlbGxcdHJhY2UtbWFwcGluZyI7fXM6MTg6IkBsYXJhdmVsL211bHRpcGxleCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE4OiJAbGFyYXZlbC9tdWx0aXBsZXgiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMC40LjQiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NjoiXjAuNC4xIjtzOjc6IgAqAHBhdGgiO3M6NzU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBsYXJhdmVsXG11bHRpcGxleCI7fXM6MjE6IkBuYXBpLXJzL3dhc20tcnVudGltZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIxOiJAbmFwaS1ycy93YXNtLXJ1bnRpbWUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4yLjQiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Nzg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBuYXBpLXJzXHdhc20tcnVudGltZSI7fXM6MTg6IkBveGMtcHJvamVjdC90eXBlcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE4OiJAb3hjLXByb2plY3QvdHlwZXMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NzoiMC4xNTEuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQG94Yy1wcm9qZWN0XHR5cGVzIjt9czozNDoiQHJvbGxkb3duL2JpbmRpbmctYW5kcm9pZC1hcm0tZWFiaSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM0OiJAcm9sbGRvd24vYmluZGluZy1hbmRyb2lkLWFybS1lYWJpIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMi4xMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHJvbGxkb3duXGJpbmRpbmctYW5kcm9pZC1hcm0tZWFiaSI7fXM6MzE6IkByb2xsZG93bi9iaW5kaW5nLWFuZHJvaWQtYXJtNjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMToiQHJvbGxkb3duL2JpbmRpbmctYW5kcm9pZC1hcm02NCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLWFuZHJvaWQtYXJtNjQiO31zOjMwOiJAcm9sbGRvd24vYmluZGluZy1kYXJ3aW4tYXJtNjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMDoiQHJvbGxkb3duL2JpbmRpbmctZGFyd2luLWFybTY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMi4xMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHJvbGxkb3duXGJpbmRpbmctZGFyd2luLWFybTY0Ijt9czoyODoiQHJvbGxkb3duL2JpbmRpbmctZGFyd2luLXg2NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI4OiJAcm9sbGRvd24vYmluZGluZy1kYXJ3aW4teDY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMi4xMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHJvbGxkb3duXGJpbmRpbmctZGFyd2luLXg2NCI7fXM6Mjk6IkByb2xsZG93bi9iaW5kaW5nLWZyZWVic2QteDY0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjk6IkByb2xsZG93bi9iaW5kaW5nLWZyZWVic2QteDY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMi4xMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHJvbGxkb3duXGJpbmRpbmctZnJlZWJzZC14NjQiO31zOjM3OiJAcm9sbGRvd24vYmluZGluZy1saW51eC1hcm0tZ251ZWFiaWhmIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzc6IkByb2xsZG93bi9iaW5kaW5nLWxpbnV4LWFybS1nbnVlYWJpaGYiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4yLjExIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk0OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAcm9sbGRvd25cYmluZGluZy1saW51eC1hcm0tZ251ZWFiaWhmIjt9czozMzoiQHJvbGxkb3duL2JpbmRpbmctbGludXgtYXJtNjQtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzM6IkByb2xsZG93bi9iaW5kaW5nLWxpbnV4LWFybTY0LWdudSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLWxpbnV4LWFybTY0LWdudSI7fXM6MzQ6IkByb2xsZG93bi9iaW5kaW5nLWxpbnV4LWFybTY0LW11c2wiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozNDoiQHJvbGxkb3duL2JpbmRpbmctbGludXgtYXJtNjQtbXVzbCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLWxpbnV4LWFybTY0LW11c2wiO31zOjMzOiJAcm9sbGRvd24vYmluZGluZy1saW51eC1wcGM2NC1nbnUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMzoiQHJvbGxkb3duL2JpbmRpbmctbGludXgtcHBjNjQtZ251IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMi4xMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHJvbGxkb3duXGJpbmRpbmctbGludXgtcHBjNjQtZ251Ijt9czozMzoiQHJvbGxkb3duL2JpbmRpbmctbGludXgtczM5MHgtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzM6IkByb2xsZG93bi9iaW5kaW5nLWxpbnV4LXMzOTB4LWdudSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLWxpbnV4LXMzOTB4LWdudSI7fXM6MzE6IkByb2xsZG93bi9iaW5kaW5nLWxpbnV4LXg2NC1nbnUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMToiQHJvbGxkb3duL2JpbmRpbmctbGludXgteDY0LWdudSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLWxpbnV4LXg2NC1nbnUiO31zOjMyOiJAcm9sbGRvd24vYmluZGluZy1saW51eC14NjQtbXVzbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMyOiJAcm9sbGRvd24vYmluZGluZy1saW51eC14NjQtbXVzbCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODk6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLWxpbnV4LXg2NC1tdXNsIjt9czozNToiQHJvbGxkb3duL2JpbmRpbmctb3Blbmhhcm1vbnktYXJtNjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozNToiQHJvbGxkb3duL2JpbmRpbmctb3Blbmhhcm1vbnktYXJtNjQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4yLjExIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAcm9sbGRvd25cYmluZGluZy1vcGVuaGFybW9ueS1hcm02NCI7fXM6MzQ6IkByb2xsZG93bi9iaW5kaW5nLXdpbjMyLWFybTY0LW1zdmMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozNDoiQHJvbGxkb3duL2JpbmRpbmctd2luMzItYXJtNjQtbXN2YyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLXdpbjMyLWFybTY0LW1zdmMiO31zOjMyOiJAcm9sbGRvd24vYmluZGluZy13aW4zMi14NjQtbXN2YyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMyOiJAcm9sbGRvd24vYmluZGluZy13aW4zMi14NjQtbXN2YyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjIuMTEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODk6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsZG93blxiaW5kaW5nLXdpbjMyLXg2NC1tc3ZjIjt9czoyMToiQHJvbGxkb3duL3BsdWdpbnV0aWxzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjE6IkByb2xsZG93bi9wbHVnaW51dGlscyI7czoxMDoiACoAdmVyc2lvbiI7czoxMDoiMS4wLjAtcmMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHJvbGxkb3duXHBsdWdpbnV0aWxzIjt9czoyODoiQHJvbGx1cC9yb2xsdXAtbGludXgteDY0LWdudSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI4OiJAcm9sbHVwL3JvbGx1cC1saW51eC14NjQtZ251IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuOS41IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjU6IjQuOS41IjtzOjc6IgAqAHBhdGgiO3M6ODU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEByb2xsdXBccm9sbHVwLWxpbnV4LXg2NC1nbnUiO31zOjE3OiJAdGFpbHdpbmRjc3Mvbm9kZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE3OiJAdGFpbHdpbmRjc3Mvbm9kZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG5vZGUiO31zOjE4OiJAdGFpbHdpbmRjc3Mvb3hpZGUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxODoiQHRhaWx3aW5kY3NzL294aWRlIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMy4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdGFpbHdpbmRjc3Ncb3hpZGUiO31zOjMyOiJAdGFpbHdpbmRjc3Mvb3hpZGUtYW5kcm9pZC1hcm02NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMyOiJAdGFpbHdpbmRjc3Mvb3hpZGUtYW5kcm9pZC1hcm02NCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4OToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG94aWRlLWFuZHJvaWQtYXJtNjQiO31zOjMxOiJAdGFpbHdpbmRjc3Mvb3hpZGUtZGFyd2luLWFybTY0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzE6IkB0YWlsd2luZGNzcy9veGlkZS1kYXJ3aW4tYXJtNjQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4zLjMiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0YWlsd2luZGNzc1xveGlkZS1kYXJ3aW4tYXJtNjQiO31zOjI5OiJAdGFpbHdpbmRjc3Mvb3hpZGUtZGFyd2luLXg2NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI5OiJAdGFpbHdpbmRjc3Mvb3hpZGUtZGFyd2luLXg2NCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG94aWRlLWRhcndpbi14NjQiO31zOjMwOiJAdGFpbHdpbmRjc3Mvb3hpZGUtZnJlZWJzZC14NjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMDoiQHRhaWx3aW5kY3NzL294aWRlLWZyZWVic2QteDY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMy4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdGFpbHdpbmRjc3Ncb3hpZGUtZnJlZWJzZC14NjQiO31zOjM4OiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgtYXJtLWdudWVhYmloZiI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM4OiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgtYXJtLWdudWVhYmloZiI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG94aWRlLWxpbnV4LWFybS1nbnVlYWJpaGYiO31zOjM0OiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgtYXJtNjQtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzQ6IkB0YWlsd2luZGNzcy9veGlkZS1saW51eC1hcm02NC1nbnUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC4zLjMiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0YWlsd2luZGNzc1xveGlkZS1saW51eC1hcm02NC1nbnUiO31zOjM1OiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgtYXJtNjQtbXVzbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM1OiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgtYXJtNjQtbXVzbCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG94aWRlLWxpbnV4LWFybTY0LW11c2wiO31zOjMyOiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgteDY0LWdudSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMyOiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgteDY0LWdudSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjE7czoxMzoiACoAY29uc3RyYWludCI7czo2OiJeNC4wLjEiO3M6NzoiACoAcGF0aCI7czo4OToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG94aWRlLWxpbnV4LXg2NC1nbnUiO31zOjMzOiJAdGFpbHdpbmRjc3Mvb3hpZGUtbGludXgteDY0LW11c2wiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMzoiQHRhaWx3aW5kY3NzL294aWRlLWxpbnV4LXg2NC1tdXNsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMy4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdGFpbHdpbmRjc3Ncb3hpZGUtbGludXgteDY0LW11c2wiO31zOjMwOiJAdGFpbHdpbmRjc3Mvb3hpZGUtd2FzbTMyLXdhc2kiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMDoiQHRhaWx3aW5kY3NzL294aWRlLXdhc20zMi13YXNpIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMy4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdGFpbHdpbmRjc3Ncb3hpZGUtd2FzbTMyLXdhc2kiO31zOjM1OiJAdGFpbHdpbmRjc3Mvb3hpZGUtd2luMzItYXJtNjQtbXN2YyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM1OiJAdGFpbHdpbmRjc3Mvb3hpZGUtd2luMzItYXJtNjQtbXN2YyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHRhaWx3aW5kY3NzXG94aWRlLXdpbjMyLWFybTY0LW1zdmMiO31zOjMzOiJAdGFpbHdpbmRjc3Mvb3hpZGUtd2luMzIteDY0LW1zdmMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMzoiQHRhaWx3aW5kY3NzL294aWRlLXdpbjMyLXg2NC1tc3ZjIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjQuMy4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdGFpbHdpbmRjc3Ncb3hpZGUtd2luMzIteDY0LW1zdmMiO31zOjE3OiJAdGFpbHdpbmRjc3Mvdml0ZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE3OiJAdGFpbHdpbmRjc3Mvdml0ZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjMuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjE7czoxMzoiACoAY29uc3RyYWludCI7czo3OiJeNC4xLjExIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0YWlsd2luZGNzc1x2aXRlIjt9czoxNjoiQHR5YnlzL3dhc20tdXRpbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE2OiJAdHlieXMvd2FzbS11dGlsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjAuMTAuNCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHR5YnlzXHdhc20tdXRpbCI7fXM6MTg6IkB0eXBlcy9iYWJlbF9fY29yZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE4OiJAdHlwZXMvYmFiZWxfX2NvcmUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy4yMC41IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNcYmFiZWxfX2NvcmUiO31zOjIzOiJAdHlwZXMvYmFiZWxfX2dlbmVyYXRvciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIzOiJAdHlwZXMvYmFiZWxfX2dlbmVyYXRvciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjI3LjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0eXBlc1xiYWJlbF9fZ2VuZXJhdG9yIjt9czoyMjoiQHR5cGVzL2JhYmVsX190ZW1wbGF0ZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIyOiJAdHlwZXMvYmFiZWxfX3RlbXBsYXRlIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjcuNC40IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNcYmFiZWxfX3RlbXBsYXRlIjt9czoyMjoiQHR5cGVzL2JhYmVsX190cmF2ZXJzZSI7TzoyMjoiTGFyYXZl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aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbGFyYXZlbC12aXRlLXBsdWdpbiI7fXM6MTI6ImxpZ2h0bmluZ2NzcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJsaWdodG5pbmdjc3MiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zMi4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjY5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xsaWdodG5pbmdjc3MiO31zOjI2OiJsaWdodG5pbmdjc3MtYW5kcm9pZC1hcm02NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI2OiJsaWdodG5pbmdjc3MtYW5kcm9pZC1hcm02NCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjMyLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGxpZ2h0bmluZ2Nzcy1hbmRyb2lkLWFybTY0Ijt9czoyNToibGlnaHRuaW5nY3NzLWRhcndpbi1hcm02NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI1OiJsaWdodG5pbmdjc3MtZGFyd2luLWFybTY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMzIuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbGlnaHRuaW5nY3NzLWRhcndpbi1hcm02NCI7fXM6MjM6ImxpZ2h0bmluZ2Nzcy1kYXJ3aW4teDY0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjM6ImxpZ2h0bmluZ2Nzcy1kYXJ3aW4teDY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMzIuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbGlnaHRuaW5nY3NzLWRhcndpbi14NjQiO31zOjI0OiJsaWdodG5pbmdjc3MtZnJlZWJzZC14NjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNDoibGlnaHRuaW5nY3NzLWZyZWVic2QteDY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMzIuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbGlnaHRuaW5nY3NzLWZyZWVic2QteDY0Ijt9czozMjoibGlnaHRuaW5nY3NzLWxpbnV4LWFybS1nbnVlYWJpaGYiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMjoibGlnaHRuaW5nY3NzLWxpbnV4LWFybS1nbnVlYWJpaGYiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zMi4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xsaWdodG5pbmdjc3MtbGludXgtYXJtLWdudWVhYmloZiI7fXM6Mjg6ImxpZ2h0bmluZ2Nzcy1saW51eC1hcm02NC1nbnUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyODoibGlnaHRuaW5nY3NzLWxpbnV4LWFybTY0LWdudSI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjMyLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGxpZ2h0bmluZ2Nzcy1saW51eC1hcm02NC1nbnUiO31zOjI5OiJsaWdodG5pbmdjc3MtbGludXgtYXJtNjQtbXVzbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI5OiJsaWdodG5pbmdjc3MtbGludXgtYXJtNjQtbXVzbCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjMyLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MDtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGxpZ2h0bmluZ2Nzcy1saW51eC1hcm02NC1tdXNsIjt9czoyNjoibGlnaHRuaW5nY3NzLWxpbnV4LXg2NC1nbnUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNjoibGlnaHRuaW5nY3NzLWxpbnV4LXg2NC1nbnUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zMy4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjc6Il4xLjI5LjEiO3M6NzoiACoAcGF0aCI7czo4MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbGlnaHRuaW5nY3NzLWxpbnV4LXg2NC1nbnUiO31zOjI3OiJsaWdodG5pbmdjc3MtbGludXgteDY0LW11c2wiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNzoibGlnaHRuaW5nY3NzLWxpbnV4LXg2NC1tdXNsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMzIuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbGlnaHRuaW5nY3NzLWxpbnV4LXg2NC1tdXNsIjt9czoyOToibGlnaHRuaW5nY3NzLXdpbjMyLWFybTY0LW1zdmMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyOToibGlnaHRuaW5nY3NzLXdpbjMyLWFybTY0LW1zdmMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zMi4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xsaWdodG5pbmdjc3Mtd2luMzItYXJtNjQtbXN2YyI7fXM6Mjc6ImxpZ2h0bmluZ2Nzcy13aW4zMi14NjQtbXN2YyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI3OiJsaWdodG5pbmdjc3Mtd2luMzIteDY0LW1zdmMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4zMi4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjA7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg0OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xsaWdodG5pbmdjc3Mtd2luMzIteDY0LW1zdmMiO31zOjk6ImxydS1jYWNoZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjk6ImxydS1jYWNoZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI1LjEuMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjowO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcbHJ1LWNhY2hlIjt9czoxMjoibWFnaWMtc3RyaW5nIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3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KgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAZXNsaW50LWNvbW11bml0eVxlc2xpbnQtdXRpbHMiO31zOjI1OiJAZXNsaW50LWNvbW11bml0eS9yZWdleHBwIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjU6IkBlc2xpbnQtY29tbXVuaXR5L3JlZ2V4cHAiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNC4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjgyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAZXNsaW50LWNvbW11bml0eVxyZWdleHBwIjt9czoyMDoiQGVzbGludC9jb25maWctYXJyYXkiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMDoiQGVzbGludC9jb25maWctYXJyYXkiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMC4yMS4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAZXNsaW50XGNvbmZpZy1hcnJheSI7fXM6MjI6IkBlc2xpbnQvY29uZmlnLWhlbHBlcnMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMjoiQGVzbGlu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bndob2NvZGVzL21vZHVsZS1pbXBvcnRlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMwOiJAaHVtYW53aG9jb2Rlcy9tb2R1bGUtaW1wb3J0ZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4wLjEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBodW1hbndob2NvZGVzXG1vZHVsZS1pbXBvcnRlciI7fXM6MjA6IkBodW1hbndob2NvZGVzL3JldHJ5IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjA6IkBodW1hbndob2NvZGVzL3JldHJ5IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjAuNC4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAaHVtYW53aG9jb2Rlc1xyZXRyeSI7fXM6MzA6IkBsYXJhdmVsL3ZpdGUtcGx1Z2luLXdheWZpbmRlciI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMwOiJAbGFyYXZlbC92aXRlLXBsdWdpbi13YXlmaW5kZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMC4xLjEwIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjY6Il4wLjEuMyI7czo3OiIAKgBwYXRoIjtzOjg3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAbGFyYXZlbFx2aXRlLXBsdWdpbi13YXlmaW5kZXIiO31zOjEwOiJAcnRzYW8vc2NjIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTA6IkBydHNhby9zY2MiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4xLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBydHNhb1xzY2MiO31zOjI0OiJAc3R5bGlzdGljL2VzbGludC1wbHVnaW4iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNDoiQHN0eWxpc3RpYy9lc2xpbnQtcGx1Z2luIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjUuMTAuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjE7czoxMzoiACoAY29uc3RyYWludCI7czo3OiJeNS4xMC4wIjtzOjc6IgAqAHBhdGgiO3M6ODE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEBzdHlsaXN0aWNcZXNsaW50LXBsdWdpbiI7fXM6MTM6IkB0eXBlcy9lc3RyZWUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxMzoiQHR5cGVzL2VzdHJlZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuOSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHR5cGVzXGVzdHJlZSI7fXM6MTg6IkB0eXBlcy9qc29uLXNjaGVtYSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE4OiJAdHlwZXMvanNvbi1zY2hlbWEiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNy4wLjE1IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNcanNvbi1zY2hlbWEiO31zOjEyOiJAdHlwZXMvanNvbjUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxMjoiQHR5cGVzL2pzb241IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjAuMC4yOSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2OToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHR5cGVzXGpzb241Ijt9czozMjoiQHR5cGVzY3JpcHQtZXNsaW50L2VzbGludC1wbHVnaW4iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMjoiQHR5cGVzY3JpcHQtZXNsaW50L2VzbGludC1wbHVnaW4iO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiOC43MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNjcmlwdC1lc2xpbnRcZXNsaW50LXBsdWdpbiI7fXM6MjU6IkB0eXBlc2NyaXB0LWVzbGludC9wYXJzZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNToiQHR5cGVzY3JpcHQtZXNsaW50L3BhcnNlciI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI4LjcxLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODI6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0eXBlc2NyaXB0LWVzbGludFxwYXJzZXIiO31zOjM0OiJAdHlwZXNjcmlwdC1lc2xpbnQvcHJvamVjdC1zZXJ2aWNlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzQ6IkB0eXBlc2NyaXB0LWVzbGludC9wcm9qZWN0LXNlcnZpY2UiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiOC43MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkxOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNjcmlwdC1lc2xpbnRccHJvamVjdC1zZXJ2aWNlIjt9czozMjoiQHR5cGVzY3JpcHQtZXNsaW50L3Njb3BlLW1hbmFnZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMjoiQHR5cGVzY3JpcHQtZXNsaW50L3Njb3BlLW1hbmFnZXIiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiOC43MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjg5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNjcmlwdC1lc2xpbnRcc2NvcGUtbWFuYWdlciI7fXM6MzM6IkB0eXBlc2NyaXB0LWVzbGludC90c2NvbmZpZy11dGlscyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMzOiJAdHlwZXNjcmlwdC1lc2xpbnQvdHNjb25maWctdXRpbHMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiOC43MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNjcmlwdC1lc2xpbnRcdHNjb25maWctdXRpbHMiO31zOjI5OiJAdHlwZXNjcmlwdC1lc2xpbnQvdHlwZS11dGlscyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI5OiJAdHlwZXNjcmlwdC1lc2xpbnQvdHlwZS11dGlscyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI4LjcxLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0eXBlc2NyaXB0LWVzbGludFx0eXBlLXV0aWxzIjt9czoyNDoiQHR5cGVzY3JpcHQtZXNsaW50L3R5cGVzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjQ6IkB0eXBlc2NyaXB0LWVzbGludC90eXBlcyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI4LjcxLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB0eXBlc2NyaXB0LWVzbGludFx0eXBlcyI7fXM6MzY6IkB0eXBlc2NyaXB0LWVzbGludC90eXBlc2NyaXB0LWVzdHJlZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM2OiJAdHlwZXNjcmlwdC1lc2xpbnQvdHlwZXNjcmlwdC1lc3RyZWUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiOC43MS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkzOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdHlwZXNjcmlwdC1lc2xpbnRcdHlwZXNjcmlwdC1lc3RyZWUiO31zOjI0OiJAdHlwZXNjcmlwdC1lc2xpbnQvdXRpbHMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNDoiQHR5cGVzY3JpcHQtZXNsaW50L3V0aWxzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjguNzEuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHR5cGVzY3JpcHQtZXNsaW50XHV0aWxzIjt9czozMToiQHR5cGVzY3JpcHQtZXNsaW50L3Zpc2l0b3Ita2V5cyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMxOiJAdHlwZXNjcmlwdC1lc2xpbnQvdmlzaXRvci1rZXlzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjguNzEuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHR5cGVzY3JpcHQtZXNsaW50XHZpc2l0b3Ita2V5cyI7fXM6Mzk6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctYW5kcm9pZC1hcm0tZWFiaSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM5OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWFuZHJvaWQtYXJtLWVhYmkiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWFuZHJvaWQtYXJtLWVhYmkiO31zOjM2OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWFuZHJvaWQtYXJtNjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozNjoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1hbmRyb2lkLWFybTY0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMTIuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHVucnNccmVzb2x2ZXItYmluZGluZy1hbmRyb2lkLWFybTY0Ijt9czozNToiQHVucnMvcmVzb2x2ZXItYmluZGluZy1kYXJ3aW4tYXJtNjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozNToiQHVucnMvcmVzb2x2ZXItYmluZGluZy1kYXJ3aW4tYXJtNjQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWRhcndpbi1hcm02NCI7fXM6MzM6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctZGFyd2luLXg2NCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMzOiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWRhcndpbi14NjQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWRhcndpbi14NjQiO31zOjM0OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWZyZWVic2QteDY0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzQ6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctZnJlZWJzZC14NjQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkxOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWZyZWVic2QteDY0Ijt9czo0MjoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1hcm0tZ251ZWFiaWhmIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6NDI6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtYXJtLWdudWVhYmloZiI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjEyLjIiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTk6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB1bnJzXHJlc29sdmVyLWJpbmRpbmctbGludXgtYXJtLWdudWVhYmloZiI7fXM6NDM6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtYXJtLW11c2xlYWJpaGYiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czo0MzoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1hcm0tbXVzbGVhYmloZiI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjEyLjIiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6MTAwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LWFybS1tdXNsZWFiaWhmIjt9czozODoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1hcm02NC1nbnUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozODoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1hcm02NC1nbnUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LWFybTY0LWdudSI7fXM6Mzk6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtYXJtNjQtbXVzbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM5OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWxpbnV4LWFybTY0LW11c2wiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LWFybTY0LW11c2wiO31zOjQwOiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWxpbnV4LWxvb25nNjQtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6NDA6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtbG9vbmc2NC1nbnUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LWxvb25nNjQtZ251Ijt9czo0MToiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1sb29uZzY0LW11c2wiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czo0MToiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1sb29uZzY0LW11c2wiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LWxvb25nNjQtbXVzbCI7fXM6Mzg6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtcHBjNjQtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzg6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtcHBjNjQtZ251IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMTIuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHVucnNccmVzb2x2ZXItYmluZGluZy1saW51eC1wcGM2NC1nbnUiO31zOjQwOiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWxpbnV4LXJpc2N2NjQtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6NDA6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtcmlzY3Y2NC1nbnUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LXJpc2N2NjQtZ251Ijt9czo0MToiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1yaXNjdjY0LW11c2wiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czo0MToiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC1yaXNjdjY0LW11c2wiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLWxpbnV4LXJpc2N2NjQtbXVzbCI7fXM6Mzg6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtczM5MHgtZ251IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzg6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctbGludXgtczM5MHgtZ251IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMTIuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHVucnNccmVzb2x2ZXItYmluZGluZy1saW51eC1zMzkweC1nbnUiO31zOjM2OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWxpbnV4LXg2NC1nbnUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozNjoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC14NjQtZ251IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMTIuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHVucnNccmVzb2x2ZXItYmluZGluZy1saW51eC14NjQtZ251Ijt9czozNzoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1saW51eC14NjQtbXVzbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjM3OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLWxpbnV4LXg2NC1tdXNsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMTIuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHVucnNccmVzb2x2ZXItYmluZGluZy1saW51eC14NjQtbXVzbCI7fXM6NDA6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctb3Blbmhhcm1vbnktYXJtNjQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czo0MDoiQHVucnMvcmVzb2x2ZXItYmluZGluZy1vcGVuaGFybW9ueS1hcm02NCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjEyLjIiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB1bnJzXHJlc29sdmVyLWJpbmRpbmctb3Blbmhhcm1vbnktYXJtNjQiO31zOjM0OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLXdhc20zMi13YXNpIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MzQ6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctd2FzbTMyLXdhc2kiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjkxOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLXdhc20zMi13YXNpIjt9czozOToiQHVucnMvcmVzb2x2ZXItYmluZGluZy13aW4zMi1hcm02NC1tc3ZjIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzk6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctd2luMzItYXJtNjQtbXN2YyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIxLjEyLjIiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXEB1bnJzXHJlc29sdmVyLWJpbmRpbmctd2luMzItYXJtNjQtbXN2YyI7fXM6Mzg6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctd2luMzItaWEzMi1tc3ZjIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzg6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctd2luMzItaWEzMi1tc3ZjIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMTIuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo5NToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcQHVucnNccmVzb2x2ZXItYmluZGluZy13aW4zMi1pYTMyLW1zdmMiO31zOjM3OiJAdW5ycy9yZXNvbHZlci1iaW5kaW5nLXdpbjMyLXg2NC1tc3ZjIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzc6IkB1bnJzL3Jlc29sdmVyLWJpbmRpbmctd2luMzIteDY0LW1zdmMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4xMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjk0OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xAdW5yc1xyZXNvbHZlci1iaW5kaW5nLXdpbjMyLXg2NC1tc3ZjIjt9czo1OiJhY29ybiI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjU6ImFjb3JuIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjguMTguMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcYWNvcm4iO31zOjk6ImFjb3JuLWpzeCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjk6ImFjb3JuLWpzeCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI1LjMuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcYWNvcm4tanN4Ijt9czozOiJhanYiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozOiJhanYiO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiNi4xNS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjYwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xhanYiO31zOjg6ImFyZ3BhcnNlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6ODoiYXJncGFyc2UiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi4wLjEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGFyZ3BhcnNlIjt9czoyNDoiYXJyYXktYnVmZmVyLWJ5dGUtbGVuZ3RoIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjQ6ImFycmF5LWJ1ZmZlci1ieXRlLWxlbmd0aCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcYXJyYXktYnVmZmVyLWJ5dGUtbGVuZ3RoIjt9czoxNDoiYXJyYXktaW5jbHVkZXMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNDoiYXJyYXktaW5jbHVkZXMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy4yLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGFycmF5LWluY2x1ZGVzIjt9czoyNDoiYXJyYXkucHJvdG90eXBlLmZpbmRsYXN0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjQ6ImFycmF5LnByb3RvdHlwZS5maW5kbGFzdCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjIuNSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcYXJyYXkucHJvdG90eXBlLmZpbmRsYXN0Ijt9czoyOToiYXJyYXkucHJvdG90eXBlLmZpbmRsYXN0aW5kZXgiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyOToiYXJyYXkucHJvdG90eXBlLmZpbmRsYXN0aW5kZXgiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4yLjYiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGFycmF5LnByb3RvdHlwZS5maW5kbGFzdGluZGV4Ijt9czoyMDoiYXJyYXkucHJvdG90eXBlLmZsYXQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMDoiYXJyYXkucHJvdG90eXBlLmZsYXQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4zLjMiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Nzc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGFycmF5LnByb3RvdHlwZS5mbGF0Ijt9czoyMzoiYXJyYXkucHJvdG90eXBlLmZsYXRtYXAiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyMzoiYXJyYXkucHJvdG90eXBlLmZsYXRtYXAiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4zLjMiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGFycmF5LnByb3RvdHlwZS5mbGF0bWFwIjt9czoyNDoiYXJyYXkucHJvdG90eXBlLnRvc29ydGVkIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjQ6ImFycmF5LnByb3RvdHlwZS50b3NvcnRlZCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjEuNCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcYXJyYXkucHJvdG90eXBlLnRvc29ydGVkIjt9czoyNzoiYXJyYXlidWZmZXIucHJvdG90eXBlLnNsaWNlIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6ImFycmF5YnVmZmVyLnByb3RvdHlwZS5zbGljZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuNCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4NDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcYXJyYXlidWZmZXIucHJvdG90eXBlLnNsaWNlIjt9czoxNDoiYXN5bmMtZnVuY3Rpb24iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNDoiYXN5bmMtZnVuY3Rpb24iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4wLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzE6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGFzeW5jLWZ1bmN0aW9uIjt9czoyMjoiYXZhaWxhYmxlLXR5cGVkLWFycmF5cyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIyOiJhdmFpbGFibGUtdHlwZWQtYXJyYXlzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC43IjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc5OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xhdmFpbGFibGUtdHlwZWQtYXJyYXlzIjt9czoyNzoiYmFiZWwtcGx1Z2luLXJlYWN0LWNvbXBpbGVyIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mjc6ImJhYmVsLXBsdWdpbi1yZWFjdC1jb21waWxlciI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMCI7czo5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AHBhdGgiO3M6ODQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGVzbGludC1pbXBvcnQtcmVzb2x2ZXItbm9kZSI7fXM6MzM6ImVzbGludC1pbXBvcnQtcmVzb2x2ZXItdHlwZXNjcmlwdCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjMzOiJlc2xpbnQtaW1wb3J0LXJlc29sdmVyLXR5cGVzY3JpcHQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiNC40LjUiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NjoiXjQuNC40IjtzOjc6IgAqAHBhdGgiO3M6OTA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGVzbGludC1pbXBvcnQtcmVzb2x2ZXItdHlwZXNjcmlwdCI7fXM6MTk6ImVzbGludC1tb2R1bGUtdXRpbHMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxOToiZXNsaW50LW1vZHVsZS11dGlscyI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIyLjE0LjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGVzbGludC1tb2R1bGUtdXRpbHMiO31zOjIwOiJlc2xpbnQtcGx1Z2luLWltcG9ydCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIwOiJlc2xpbnQtcGx1Z2luLWltcG9ydCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiIyLjMyLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NzoiXjIuMzIuMCI7czo3OiIAKgBwYXRoIjtzOjc3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xlc2xpbnQtcGx1Z2luLWltcG9ydCI7fXM6MTk6ImVzbGludC1wbHVnaW4tcmVhY3QiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxOToiZXNsaW50LXBsdWdpbi1yZWFjdCI7czoxMDoiACoAdmVyc2lvbiI7czo2OiI3LjM3LjUiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjoxO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6NzoiXjcuMzcuMyI7czo3OiIAKgBwYXRoIjtzOjc2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xlc2xpbnQtcGx1Z2luLXJlYWN0Ijt9czoyNToiZXNsaW50LXBsdWdpbi1yZWFjdC1ob29rcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI1OiJlc2xpbnQtcGx1Z2luLXJlYWN0LWhvb2tzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjcuMS4xIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MTtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjY6Il43LjAuMCI7czo3OiIAKgBwYXRoIjtzOjgyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xlc2xpbnQtcGx1Z2luLXJlYWN0LWhvb2tzIjt9czoxMjoiZXNsaW50LXNjb3Bl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dXRpbHMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi4wLjMiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGVzdXRpbHMiO31zOjE1OiJmYXN0LWRlZXAtZXF1YWwiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNToiZmFzdC1kZWVwLWVxdWFsIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjMuMS4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjcyOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xmYXN0LWRlZXAtZXF1YWwiO31zOjI2OiJmYXN0LWpzb24tc3RhYmxlLXN0cmluZ2lmeSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjI2OiJmYXN0LWpzb24tc3RhYmxlLXN0cmluZ2lmeSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjEuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcZmFzdC1qc29uLXN0YWJsZS1zdHJpbmdpZnkiO31zOjE2OiJmYXN0LWxldmVuc2h0ZWluIjtPOjIyOiJMYXJhdmVsXFJvc3Rl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MTA6IgAqAHZlcnNpb24iO3M6NToiMS4xLjIiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzA6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGZ1bmN0aW9uLWJpbmQiO31zOjIzOiJmdW5jdGlvbi5wcm90b3R5cGUubmFtZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIzOiJmdW5jdGlvbi5wcm90b3R5cGUubmFtZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjIuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcZnVuY3Rpb24ucHJvdG90eXBlLm5hbWUiO31zOjIwOiJmdW5jdGlvbnMtaGF2ZS1uYW1lcyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIwOiJmdW5jdGlvbnMtaGF2ZS1uYW1lcyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjIuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcZnVuY3Rpb25zLWhhdmUtbmFtZXMiO31zOjE4OiJnZW5lcmF0b3ItZnVuY3Rpb24iO086MjI6IkxhcmF2ZWxc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AHZlcnNpb24iO3M6NToiMS4wLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzI6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGlzLWRvY3VtZW50LmFsbCI7fXM6MTA6ImlzLWV4dGdsb2IiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxMDoiaXMtZXh0Z2xvYiI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIyLjEuMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2NzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcaXMtZXh0Z2xvYiI7fXM6MjM6ImlzLWZpbmFsaXphdGlvbnJlZ2lzdHJ5IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjM6ImlzLWZpbmFsaXphdGlvbnJlZ2lzdHJ5IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMS4xIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjgwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xpcy1maW5hbGl6YXRpb25yZWdpc3RyeSI7fXM6MjE6ImlzLWdlbmVyYXRvci1mdW5jdGlvbiI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1l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YWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo2ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcanNvbi1idWZmZXIiO31zOjIwOiJqc29uLXNjaGVtYS10cmF2ZXJzZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIwOiJqc29uLXNjaGVtYS10cmF2ZXJzZSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIwLjQuMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcanNvbi1zY2hlbWEtdHJhdmVyc2UiO31zOjM3OiJqc29uLXN0YWJsZS1zdHJpbmdpZnktd2l0aG91dC1qc29uaWZ5IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6Mzc6Impzb24tc3RhYmxlLXN0cmluZ2lmeS13aXRob3V0LWpzb25pZnkiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4wLjEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6OTQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXGpzb24tc3RhYmxlLXN0cmluZ2lmeS13aXRob3V0LWpzb25pZnkiO31zOjEzOiJqc3gtYXN0LXV0aWxzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTM6ImpzeC1hc3QtdXRpbHMiO3M6MTA6IgAqAHZlcnNp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OjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjczOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xyZXNvbHZlLXBrZy1tYXBzIjt9czoxNzoic2FmZS1hcnJheS1jb25jYXQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoic2FmZS1hcnJheS1jb25jYXQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4xLjQiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHNhZmUtYXJyYXktY29uY2F0Ijt9czoxNToic2FmZS1wdXNoLWFwcGx5IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTU6InNhZmUtcHVzaC1hcHBseSI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc2FmZS1wdXNoLWFwcGx5Ijt9czoxNToic2FmZS1yZWdleC10ZXN0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTU6InNhZmUtcmVnZXgtdGVzdCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjEuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc2FmZS1yZWdleC10ZXN0Ijt9czoxOToic2V0LWZ1bmN0aW9uLWxlbmd0aCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE5OiJzZXQtZnVuY3Rpb24tbGVuZ3RoIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMi4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc2OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xzZXQtZnVuY3Rpb24tbGVuZ3RoIjt9czoxNzoic2V0LWZ1bmN0aW9uLW5hbWUiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNzoic2V0LWZ1bmN0aW9uLW5hbWUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi4wLjIiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzQ6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHNldC1mdW5jdGlvbi1uYW1lIjt9czo5OiJzZXQtcHJvdG8iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czo5OiJzZXQtcHJvdG8iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4wLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHNldC1wcm90byI7fXM6MTU6InNoZWJhbmctY29tbWFuZCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE1OiJzaGViYW5nLWNvbW1hbmQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi4wLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzI6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHNoZWJhbmctY29tbWFuZCI7fXM6MTM6InNoZWJhbmctcmVnZXgiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxMzoic2hlYmFuZy1yZWdleCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIzLjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc2hlYmFuZy1yZWdleCI7fXM6MTI6InNpZGUtY2hhbm5lbCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJzaWRlLWNoYW5uZWwiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4xLjEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njk6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHNpZGUtY2hhbm5lbCI7fXM6MTc6InNpZGUtY2hhbm5lbC1saXN0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTc6InNpZGUtY2hhbm5lbC1saXN0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC4xIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc0OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xzaWRlLWNoYW5uZWwtbGlzdCI7fXM6MTY6InNpZGUtY2hhbm5lbC1tYXAiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNjoic2lkZS1jaGFubmVsLW1hcCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc2lkZS1jaGFubmVsLW1hcCI7fXM6MjA6InNpZGUtY2hhbm5lbC13ZWFrbWFwIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjA6InNpZGUtY2hhbm5lbC13ZWFrbWFwIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC4yIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc3OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xzaWRlLWNoYW5uZWwtd2Vha21hcCI7fXM6MTM6InN0YWJsZS1oYXNoLXgiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxMzoic3RhYmxlLWhhc2gteCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIwLjIuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc3RhYmxlLWhhc2gteCI7fXM6MjM6InN0b3AtaXRlcmF0aW9uLWl0ZXJhdG9yIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjM6InN0b3AtaXRlcmF0aW9uLWl0ZXJhdG9yIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMS4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjgwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xzdG9wLWl0ZXJhdGlvbi1pdGVyYXRvciI7fXM6MjU6InN0cmluZy5wcm90b3R5cGUubWF0Y2hhbGwiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNToic3RyaW5nLnByb3RvdHlwZS5tYXRjaGFsbCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiI0LjEuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc3RyaW5nLnByb3RvdHlwZS5tYXRjaGFsbCI7fXM6MjM6InN0cmluZy5wcm90b3R5cGUucmVwZWF0IjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MjM6InN0cmluZy5wcm90b3R5cGUucmVwZWF0IjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC4wIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjgwOiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xzdHJpbmcucHJvdG90eXBlLnJlcGVhdCI7fXM6MjE6InN0cmluZy5wcm90b3R5cGUudHJpbSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIxOiJzdHJpbmcucHJvdG90eXBlLnRyaW0iO3M6MTA6IgAqAHZlcnNpb24iO3M6NjoiMS4yLjExIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc4OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1xzdHJpbmcucHJvdG90eXBlLnRyaW0iO31zOjI0OiJzdHJpbmcucHJvdG90eXBlLnRyaW1lbmQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNDoic3RyaW5nLnByb3RvdHlwZS50cmltZW5kIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjEuMC4xMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc3RyaW5nLnByb3RvdHlwZS50cmltZW5kIjt9czoyNjoic3RyaW5nLnByb3RvdHlwZS50cmltc3RhcnQiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoyNjoic3RyaW5nLnByb3RvdHlwZS50cmltc3RhcnQiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4wLjgiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6ODM6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHN0cmluZy5wcm90b3R5cGUudHJpbXN0YXJ0Ijt9czo5OiJzdHJpcC1ib20iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czo5OiJzdHJpcC1ib20iO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMy4wLjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NjY6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHN0cmlwLWJvbSI7fXM6MTk6InN0cmlwLWpzb24tY29tbWVudHMiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxOToic3RyaXAtanNvbi1jb21tZW50cyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIzLjEuMSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3NjoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc3RyaXAtanNvbi1jb21tZW50cyI7fXM6MzE6InN1cHBvcnRzLXByZXNlcnZlLXN5bWxpbmtzLWZsYWciO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czozMToic3VwcG9ydHMtcHJlc2VydmUtc3ltbGlua3MtZmxhZyI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4ODoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcc3VwcG9ydHMtcHJlc2VydmUtc3ltbGlua3MtZmxhZyI7fXM6MTI6InRzLWFwaS11dGlscyI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjEyOiJ0cy1hcGktdXRpbHMiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMi41LjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njk6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHRzLWFwaS11dGlscyI7fXM6MTQ6InRzY29uZmlnLXBhdGhzIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTQ6InRzY29uZmlnLXBhdGhzIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjY6IjMuMTUuMCI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MToiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcdHNjb25maWctcGF0aHMiO31zOjEwOiJ0eXBlLWNoZWNrIjtPOjIyOiJMYXJhdmVsXFJvc3RlclxQYWNrYWdlIjo3OntzOjc6IgAqAG5hbWUiO3M6MTA6InR5cGUtY2hlY2siO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMC40LjAiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Njc6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHR5cGUtY2hlY2siO31zOjE4OiJ0eXBlZC1hcnJheS1idWZmZXIiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxODoidHlwZWQtYXJyYXktYnVmZmVyIjtzOjEwOiIAKgB2ZXJzaW9uIjtzOjU6IjEuMC4zIjtzOjk6IgAqAHNvdXJjZSI7cjoxMjczO3M6NjoiACoAZGV2IjtiOjE7czo5OiIAKgBkaXJlY3QiO2I6MDtzOjEzOiIAKgBjb25zdHJhaW50IjtzOjA6IiI7czo3OiIAKgBwYXRoIjtzOjc1OiJDOlx4YW1wcFxodGRvY3NccHJhY3RpY2FfczFfMS0yMDI2XHByb3llY3RvXG5vZGVfbW9kdWxlc1x0eXBlZC1hcnJheS1idWZmZXIiO31zOjIzOiJ0eXBlZC1hcnJheS1ieXRlLWxlbmd0aCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIzOiJ0eXBlZC1hcnJheS1ieXRlLWxlbmd0aCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMyI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcdHlwZWQtYXJyYXktYnl0ZS1sZW5ndGgiO31zOjIzOiJ0eXBlZC1hcnJheS1ieXRlLW9mZnNldCI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjIzOiJ0eXBlZC1hcnJheS1ieXRlLW9mZnNldCI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuNSI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo4MDoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcdHlwZWQtYXJyYXktYnl0ZS1vZmZzZXQiO31zOjE4OiJ0eXBlZC1hcnJheS1sZW5ndGgiO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7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OiJ3aGljaC1ib3hlZC1wcmltaXRpdmUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4xLjEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6Nzg6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHdoaWNoLWJveGVkLXByaW1pdGl2ZSI7fXM6MTg6IndoaWNoLWJ1aWx0aW4tdHlwZSI7TzoyMjoiTGFyYXZlbFxSb3N0ZXJcUGFja2FnZSI6Nzp7czo3OiIAKgBuYW1lIjtzOjE4OiJ3aGljaC1idWlsdGluLXR5cGUiO3M6MTA6IgAqAHZlcnNpb24iO3M6NToiMS4yLjEiO3M6OToiACoAc291cmNlIjtyOjEyNzM7czo2OiIAKgBkZXYiO2I6MTtzOjk6IgAqAGRpcmVjdCI7YjowO3M6MTM6IgAqAGNvbnN0cmFpbnQiO3M6MDoiIjtzOjc6IgAqAHBhdGgiO3M6NzU6IkM6XHhhbXBwXGh0ZG9jc1xwcmFjdGljYV9zMV8xLTIwMjZccHJveWVjdG9cbm9kZV9tb2R1bGVzXHdoaWNoLWJ1aWx0aW4tdHlwZSI7fXM6MTY6IndoaWNoLWNvbGxlY3Rpb24iO086MjI6IkxhcmF2ZWxcUm9zdGVyXFBhY2thZ2UiOjc6e3M6NzoiACoAbmFtZSI7czoxNjoid2hpY2gtY29sbGVjdGlvbiI7czoxMDoiACoAdmVyc2lvbiI7czo1OiIxLjAuMiI7czo5OiIAKgBzb3VyY2UiO3I6MTI3MztzOjY6IgAqAGRldiI7YjoxO3M6OToiACoAZGlyZWN0IjtiOjA7czoxMzoiACoAY29uc3RyYWludCI7czowOiIiO3M6NzoiACoAcGF0aCI7czo3MzoiQzpceGFtcHBcaHRkb2NzXHByYWN0aWNhX3MxXzEtMjAyNlxwcm95ZWN0b1xub2RlX21vZHVsZXNcd2hpY2gtY29sbGVjdGlvbiI7fXM6MTc6IndoaWNoLXR5cGVkLWFycmF5IjtPOjIyOiJM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O2k6MjM7cjoxNDU0O2k6MjQ7cjoxNDYyO2k6MjU7cjoxNDcwO2k6MjY7cjoxNDc4O2k6Mjc7cjoxNDg2O2k6Mjg7cjoxNDk0O2k6Mjk7cjoxNTAyO2k6MzA7cjoxNTEwO2k6MzE7cjoxNTE4O2k6MzI7cjoxNTI2O2k6MzM7cjoxNTM0O2k6MzQ7cjoxNTQyO2k6MzU7cjoxNTUwO2k6MzY7cjoxNTU4O2k6Mzc7cjoxNTY2O2k6Mzg7cjoxNTc0O2k6Mzk7cjoxNTgyO2k6NDA7cjoxNTkwO2k6NDE7cjoxNTk4O2k6NDI7cjoxNjA2O2k6NDM7cjoxNjE0O2k6NDQ7cjoxNjIyO2k6NDU7cjoxNjMwO2k6NDY7cjoxNjM4O2k6NDc7cjoxNjQ2O2k6NDg7cjoxNjU0O2k6NDk7cjoxNjYyO2k6NTA7cjoxNjcwO2k6NTE7cjoxNjc4O2k6NTI7cjoxNjg2O2k6NTM7cjoxNjk0O2k6NTQ7cjoxNzAyO2k6NTU7cjoxNzEwO2k6NTY7cjoxNzE4O2k6NTc7cjoxNzI2O2k6NTg7cjoxNzM0O2k6NTk7cjoxNzQyO2k6NjA7cjoxNzUwO2k6NjE7cjoxNzU4O2k6NjI7cjoxNzY2O2k6NjM7cjoxNzc0O2k6NjQ7cjoxNzgyO2k6NjU7cjoxNzkwO2k6NjY7cjoxNzk4O2k6Njc7cjoxODA2O2k6Njg7cjoxODE0O2k6Njk7cjoxODIyO2k6NzA7cjoxODMwO2k6NzE7cjoxODM4O2k6NzI7cjoxODQ2O2k6NzM7cjoxODU0O2k6NzQ7cjoxODYyO2k6NzU7cjoxODcwO2k6NzY7cjoxODc4O2k6Nzc7cjoxODg2O2k6Nzg7cjoxODk0O2k6Nzk7cjoxOTAyO2k6ODA7cjoxOTEwO2k6ODE7cjoxOTE4O2k6ODI7cjoxOTI2O2k6ODM7cjoxOTM0O2k6ODQ7cjoxOTQyO2k6ODU7cjoxOTUwO2k6ODY7cjoxOTU4O2k6ODc7cjoxOTY2O2k6ODg7cjoxOTc0O2k6ODk7cjoxOTgyO2k6OTA7cjoxOTkwO2k6OTE7cjoxOTk4O2k6OTI7cjoyMDA2O2k6OTM7cjoyMDE0O2k6OTQ7cjoyMDIyO2k6OTU7cjoyMDMwO2k6OTY7cjoyMDM4O2k6OTc7cjoyMDQ2O2k6OTg7cjoyMDU0O2k6OTk7cjoyMDYyO2k6MTAwO3I6MjA3MDtpOjEwMTtyOjIwNzg7aToxMDI7cjoyMDg2O2k6MTAzO3I6MjA5NDtpOjEwNDtyOjIxMDI7aToxMDU7cjoyMTEwO2k6MTA2O3I6MjExODtpOjEwNztyOjIxMjY7aToxMDg7cjoyMTM0O2k6MTA5O3I6MjE0MjtpOjExMDtyOjIxNTA7aToxMTE7cjoyMTU4O2k6MTEyO3I6MjE2NjtpOjExMztyOjIxNzQ7aToxMTQ7cjoyMTgyO2k6MTE1O3I6MjE5MDtpOjExNjtyOjIxOTg7aToxMTc7cjoyMjA2O2k6MTE4O3I6MjIxNDtpOjExOTtyOjIyMjI7aToxMjA7cjoyMjMwO2k6MTIxO3I6MjIzODtpOjEyMjtyOjIyNDY7aToxMjM7cjoyMjU0O2k6MTI0O3I6MjI2MjtpOjEyNTtyOjIyNzA7aToxMjY7cjoyMjc4O2k6MTI3O3I6MjI4NjtpOjEyODtyOjIyOTQ7aToxMjk7cjoyMzAyO2k6MTMwO3I6MjMxMDtpOjEzMTtyOjIzMTg7aToxMzI7cjoyMzI2O2k6MTMzO3I6MjMzNDtpOjEzNDtyOjIzNDI7aToxMzU7cjoyMzUwO2k6MTM2O3I6MjM1ODtpOjEzNztyOjIzNjY7aToxMzg7cjoyMzc0O2k6MTM5O3I6MjM4MjtpOjE0MDtyOjIzOTA7aToxNDE7cjoyMzk4O2k6MTQyO3I6MjQwNjtpOjE0MztyOjI0MTQ7aToxNDQ7cjoyNDIyO2k6MTQ1O3I6MjQzMDtpOjE0NjtyOjI0Mzg7aToxNDc7cjoyNDQ2O2k6MTQ4O3I6MjQ1NDtpOjE0OTtyOjI0NjI7aToxNTA7cjoyNDcwO2k6MTUxO3I6MjQ3ODtpOjE1MjtyOjI0ODY7aToxNTM7cjoyNDk0O2k6MTU0O3I6MjUwMjtpOjE1NTtyOjI1MTA7aToxNTY7cjoyNTE4O2k6MTU3O3I6MjUyNjtpOjE1ODtyOjI1MzQ7aToxNTk7cjoyNTQyO2k6MTYwO3I6MjU1MDtpOjE2MTtyOjI1NTg7aToxNjI7cjoyNTY2O2k6MTYzO3I6MjU3NDtpOjE2NDtyOjI1ODI7aToxNjU7cjoyNTkwO2k6MTY2O3I6MjU5ODtpOjE2NztyOjI2MDY7aToxNjg7cjoyNjE0O2k6MTY5O3I6MjYyMjtpOjE3MDtyOjI2MzA7aToxNzE7cjoyNjM4O2k6MTcyO3I6MjY0NjtpOjE3MztyOjI2NTQ7aToxNzQ7cjoyNjYyO2k6MTc1O3I6MjY3MDtpOjE3NjtyOjI2Nzg7aToxNzc7cjoyNjg2O2k6MTc4O3I6MjY5NDtpOjE3OTtyOjI3MDI7aToxODA7cjoyNzEwO2k6MTgxO3I6MjcxODtpOjE4MjtyOjI3MjY7aToxODM7cjoyNzM0O2k6MTg0O3I6Mjc0MjtpOjE4NTtyOjI3NTA7aToxODY7cjoyNzU4O2k6MTg3O3I6Mjc2NjtpOjE4ODtyOjI3NzQ7aToxODk7cjoyNzgyO2k6MTkwO3I6Mjc5MDtpOjE5MTtyOjI3OTg7aToxOTI7cjoyODA2O2k6MTkzO3I6MjgxNDtpOjE5NDtyOjI4MjI7aToxOTU7cjoyODMwO2k6MTk2O3I6MjgzODtpOjE5NztyOjI4NDY7aToxOTg7cjoyODU0O2k6MTk5O3I6Mjg2MjtpOjIwMDtyOjI4NzA7aToyMDE7cjoyODc4O2k6MjAyO3I6Mjg4NjtpOjIwMztyOjI4OTQ7aToyMDQ7cjoyOTAyO2k6MjA1O3I6MjkxMDtpOjIwNjtyOjI5MTg7aToyMDc7cjoyOTI2O2k6MjA4O3I6MjkzNDtpOjIwOTtyOjI5NDI7aToyMTA7cjoyOTUwO2k6MjExO3I6Mjk1ODtpOjIxMjtyOjI5NjY7aToyMTM7cjoyOTc0O2k6MjE0O3I6Mjk4MjtpOjIxNTtyOjI5OTA7aToyMTY7cjoyOTk4O2k6MjE3O3I6MzAwNjtpOjIxODtyOjMwMTQ7aToyMTk7cjozMDIyO2k6MjIwO3I6MzAzMDtpOjIyMTtyOjMwMzg7aToyMjI7cjozMDQ2O2k6MjIzO3I6MzA1NDtpOjIyNDtyOjMwNjI7aToyMjU7cjozMDcwO2k6MjI2O3I6MzA3ODtpOjIyNztyOjMwODY7aToyMjg7cjozMDk0O2k6MjI5O3I6MzEwMjtpOjIzMDtyOjMxMTA7aToyMzE7cjozMTE4O2k6MjMyO3I6MzEyNjtpOjIzMztyOjMxMzQ7aToyMzQ7cjozMTQyO2k6MjM1O3I6MzE1MDtpOjIzNjtyOjMxNTg7aToyMzc7cjozMTY2O2k6MjM4O3I6MzE3NDtpOjIzOTtyOjMxODI7aToyNDA7cjozMTkwO2k6MjQxO3I6MzE5ODtpOjI0MjtyOjMyMDY7aToyNDM7cjozMjE0O2k6MjQ0O3I6MzIyMjtpOjI0NTtyOjMyMzA7aToyNDY7cjozMjM4O2k6MjQ3O3I6MzI0NjtpOjI0ODtyOjMyNTQ7aToyNDk7cjozMjYyO2k6MjUwO3I6MzI3MDtpOjI1MTtyOjMyNzg7aToyNTI7cjozMjg2O2k6MjUzO3I6MzI5NDtpOjI1NDtyOjMzMDI7aToyNTU7cjozMzEwO2k6MjU2O3I6MzMxODtpOjI1NztyOjMzMjY7aToyNTg7cjozMzM0O2k6MjU5O3I6MzM0MjtpOjI2MDtyOjMzNTA7aToyNjE7cjozMzU4O2k6MjYyO3I6MzM2NjtpOjI2MztyOjMzNzQ7aToyNjQ7cjozMzgyO2k6MjY1O3I6MzM5MDtpOjI2NjtyOjMzOTg7aToyNjc7cjozNDA2O2k6MjY4O3I6MzQxNDtpOjI2OTtyOjM0MjI7aToyNzA7cjozNDMwO2k6MjcxO3I6MzQzODtpOjI3MjtyOjM0NDY7aToyNzM7cjozNDU0O2k6Mjc0O3I6MzQ2MjtpOjI3NTtyOjM0NzA7aToyNzY7cjozNDc4O2k6Mjc3O3I6MzQ4NjtpOjI3ODtyOjM0OTQ7aToyNzk7cjozNTAyO2k6MjgwO3I6MzUxMDtpOjI4MTtyOjM1MTg7aToyODI7cjozNTI2O2k6MjgzO3I6MzUzNDtpOjI4NDtyOjM1NDI7aToyODU7cjozNTUwO2k6Mjg2O3I6MzU1ODtpOjI4NztyOjM1NjY7aToyODg7cjozNTc0O2k6Mjg5O3I6MzU4MjtpOjI5MDtyOjM1OTA7aToyOTE7cjozNTk4O2k6MjkyO3I6MzYwNjtpOjI5MztyOjM2MTQ7aToyOTQ7cjozNjIyO2k6Mjk1O3I6MzYzMDtpOjI5NjtyOjM2Mzg7aToyOTc7cjozNjQ2O2k6Mjk4O3I6MzY1NDtpOjI5OTtyOjM2NjI7aTozMDA7cjozNjcwO2k6MzAxO3I6MzY3ODtpOjMwMjtyOjM2ODY7aTozMDM7cjozNjk0O2k6MzA0O3I6MzcwMjtpOjMwNTtyOjM3MTA7aTozMDY7cjozNzE4O2k6MzA3O3I6MzcyNjtpOjMwODtyOjM3MzQ7aTozMDk7cjozNzQyO2k6MzEwO3I6Mzc1MDtpOjMxMTtyOjM3NTg7aTozMTI7cjozNzY2O2k6MzEzO3I6Mzc3NDtpOjMxNDtyOjM3ODI7aTozMTU7cjozNzkwO2k6MzE2O3I6Mzc5ODtpOjMxNztyOjM4MDY7aTozMTg7cjozODE0O2k6MzE5O3I6MzgyMjtpOjMyMDtyOjM4MzA7aTozMjE7cjozODM4O2k6MzIyO3I6Mzg0NjtpOjMyMztyOjM4NTQ7aTozMjQ7cjozODYyO2k6MzI1O3I6Mzg3MDtpOjMyNjtyOjM4Nzg7aTozMjc7cjozODg2O2k6MzI4O3I6Mzg5NDtpOjMyOTtyOjM5MDI7aTozMzA7cjozOTEwO2k6MzMxO3I6MzkxODtpOjMzMjtyOjM5MjY7aTozMzM7cjozOTM0O2k6MzM0O3I6Mzk0MjtpOjMzNTtyOjM5NTA7aTozMzY7cjozOTU4O2k6MzM3O3I6Mzk2NjtpOjMzODtyOjM5NzQ7aTozMzk7cjozOTgyO2k6MzQwO3I6Mzk5MDtpOjM0MTtyOjM5OTg7aTozNDI7cjo0MDA2O2k6MzQzO3I6NDAxNDtpOjM0NDtyOjQwMjI7aTozNDU7cjo0MDMwO2k6MzQ2O3I6NDAzODtpOjM0NztyOjQwNDY7aTozNDg7cjo0MDU0O2k6MzQ5O3I6NDA2MjtpOjM1MDtyOjQwNzA7aTozNTE7cjo0MDc4O2k6MzUyO3I6NDA4NjtpOjM1MztyOjQwOTQ7aTozNTQ7cjo0MTAyO2k6MzU1O3I6NDExMDtpOjM1NjtyOjQxMTg7aTozNTc7cjo0MTI2O2k6MzU4O3I6NDEzNDtpOjM1OTtyOjQxNDI7aTozNjA7cjo0MTUwO2k6MzYxO3I6NDE1ODtpOjM2MjtyOjQxNjY7aTozNjM7cjo0MTc0O2k6MzY0O3I6NDE4MjtpOjM2NTtyOjQxOTA7aTozNjY7cjo0MTk4O2k6MzY3O3I6NDIwNjtpOjM2ODtyOjQyMTQ7aTozNjk7cjo0MjIyO2k6MzcwO3I6NDIzMDtpOjM3MTtyOjQyMzg7aTozNzI7cjo0MjQ2O2k6MzczO3I6NDI1NDtpOjM3NDtyOjQyNjI7aTozNzU7cjo0MjcwO2k6Mzc2O3I6NDI3ODtpOjM3NztyOjQyODY7aTozNzg7cjo0Mjk0O2k6Mzc5O3I6NDMwMjtpOjM4MDtyOjQzMTA7aTozODE7cjo0MzE4O2k6MzgyO3I6NDMyNjtpOjM4MztyOjQzMzQ7aTozODQ7cjo0MzQyO2k6Mzg1O3I6NDM1MDtpOjM4NjtyOjQzNTg7aTozODc7cjo0MzY2O2k6Mzg4O3I6NDM3NDtpOjM4OTtyOjQzODI7aTozOTA7cjo0MzkwO2k6MzkxO3I6NDM5ODtpOjM5MjtyOjQ0MDY7aTozOTM7cjo0NDE0O2k6Mzk0O3I6NDQyMjtpOjM5NTtyOjQ0MzA7aTozOTY7cjo0NDM4O2k6Mzk3O3I6NDQ0NjtpOjM5ODtyOjQ0NTQ7aTozOTk7cjo0NDYyO2k6NDAwO3I6NDQ3MDtpOjQwMTtyOjQ0Nzg7aTo0MDI7cjo0NDg2O2k6NDAzO3I6NDQ5NDtpOjQwNDtyOjQ1MDI7aTo0MDU7cjo0NTEwO2k6NDA2O3I6NDUxODtpOjQwNztyOjQ1MjY7aTo0MDg7cjo0NTM0O2k6NDA5O3I6NDU0MjtpOjQxMDtyOjQ1NTA7aTo0MTE7cjo0NTU4O2k6NDEyO3I6NDU2NjtpOjQxMztyOjQ1NzQ7aTo0MTQ7cjo0NTgyO2k6NDE1O3I6NDU5MDtpOjQxNjtyOjQ1OTg7aTo0MTc7cjo0NjA2O2k6NDE4O3I6NDYxNDtpOjQxOTtyOjQ2MjI7aTo0MjA7cjo0NjMwO2k6NDIxO3I6NDYzODtpOjQyMjtyOjQ2NDY7aTo0MjM7cjo0NjU0O2k6NDI0O3I6NDY2MjtpOjQyNTtyOjQ2NzA7aTo0MjY7cjo0Njc4O2k6NDI3O3I6NDY4NjtpOjQyODtyOjQ2OTQ7aTo0Mjk7cjo0NzAyO2k6NDMwO3I6NDcxMDtpOjQzMTtyOjQ3MTg7aTo0MzI7cjo0NzI2O2k6NDMzO3I6NDczNDtpOjQzNDtyOjQ3NDI7aTo0MzU7cjo0NzUwO2k6NDM2O3I6NDc1ODtpOjQzNztyOjQ3NjY7aTo0Mzg7cjo0Nzc0O31zOjI4OiIAKgBlc2NhcGVXaGVuQ2FzdGluZ1RvU3RyaW5nIjtiOjA7fXM6MTc6IgAqAHBhY2thZ2VNYW5hZ2VyIjtFOjQxOiJMYXJhdmVsXFJvc3RlclxFbnVtc1xKc1BhY2thZ2VNYW5hZ2VyOk5wbSI7fXM6Njoic3RhY2tzIjtPOjMwOiJMYXJhdmVsXFJvc3RlclxTdXBwb3J0XEVudW1TZXQiOjE6e3M6ODoiACoAY2FzZXMiO2E6MTp7aTowO0U6Mzk6IkxhcmF2ZWxcUm9zdGVyXEVudW1zXFN0YWNrOkluZXJ0aWFSZWFjdCI7fX1zOjIxOiJicm93c2VyVGVzdEZyYW1ld29ya3MiO086MzA6IkxhcmF2ZWxcUm9zdGVyXFN1cHBvcnRcRW51bVNldCI6MTp7czo4OiIAKgBjYXNlcyI7YTowOnt9fXM6OToiZnJvbnRlbmRzIjtPOjMwOiJMYXJhdmVsXFJvc3RlclxTdXBwb3J0XEVudW1TZXQiOjE6e3M6ODoiACoAY2FzZXMiO2E6MTp7aTowO0U6MzU6IkxhcmF2ZWxcUm9zdGVyXEVudW1zXEZyb250ZW5kOlJlYWN0Ijt9fXM6NjoiYWdlbnRzIjtPOjMwOiJMYXJhdmVsXFJvc3RlclxTdXBwb3J0XEVudW1TZXQiOjE6e3M6ODoiACoAY2FzZXMiO2E6MTp7aTowO0U6MzI6IkxhcmF2ZWxcUm9zdGVyXEVudW1zXEFnZW50OkNvZGV4Ijt9fXM6NzoiZWRpdG9ycyI7TzozMDoiTGFyYXZlbFxSb3N0ZXJcU3VwcG9ydFxFbnVtU2V0IjoxOntzOjg6IgAqAGNhc2VzIjthOjA6e319fQ==	1795271309
los-angelitos-de-edgar-cache-login-attempts:6088ccbd4ef362104db13734810adb9da6ad974de2015335bbe99d68d34aa584	i:1;	1795268830
los-angelitos-de-edgar-cache-boost:mcp:database-schema:pgsql:mascotas|articulo_inventarios|interesado_adopcions|adopcions|seguimiento_adopcions|historial_clinicos|dosificaciones_fiscales|facturas_legales|proveedors|compras|ajuste_inventarios:0:0:0:0	a:2:{s:6:"engine";s:5:"pgsql";s:6:"tables";a:0:{}}	1795284847
los-angelitos-de-edgar-cache-boost:mcp:database-schema:pgsql::0:0:0:0	a:2:{s:6:"engine";s:5:"pgsql";s:6:"tables";a:64:{s:8:"adopcion";a:5:{s:7:"columns";a:6:{s:11:"id_adopcion";a:1:{s:4:"type";s:7:"integer";}s:10:"id_mascota";a:1:{s:4:"type";s:7:"integer";}s:13:"id_interesado";a:1:{s:4:"type";s:7:"integer";}s:14:"fecha_adopcion";a:1:{s:4:"type";s:4:"date";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:4:{s:23:"adopcion_id_mascota_key";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:13:"adopcion_pkey";a:4:{s:7:"columns";a:1:{i:0;s:11:"id_adopcion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:23:"idx_adopcion_interesado";a:4:{s:7:"columns";a:1:{i:0;s:13:"id_interesado";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:20:"idx_adopcion_mascota";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:22:"fk_adopcion_interesado";s:7:"columns";a:1:{i:0;s:13:"id_interesado";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:19:"interesado_adopcion";s:15:"foreign_columns";a:1:{i:0;s:13:"id_interesado";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:19:"fk_adopcion_mascota";s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"mascota";s:15:"foreign_columns";a:1:{i:0;s:10:"id_mascota";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:30:"tr_registrar_bitacora_adopcion";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:8:"adopcion";s:16:"action_statement";s:49:"EXECUTE FUNCTION fn_registrar_bitacora_adopcion()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:37:"tr_actualizar_estado_mascota_adopcion";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:8:"adopcion";s:16:"action_statement";s:56:"EXECUTE FUNCTION fn_actualizar_estado_mascota_adopcion()";}}s:17:"check_constraints";a:0:{}}s:9:"adopcions";a:5:{s:7:"columns";a:6:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:14:"fecha_adopcion";a:1:{s:4:"type";s:22:"character varying(255)";}s:13:"id_interesado";a:1:{s:4:"type";s:6:"bigint";}s:10:"id_mascota";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:14:"adopcions_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:31:"adopcions_id_interesado_foreign";s:7:"columns";a:1:{i:0;s:13:"id_interesado";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"interesado_adopcions";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:28:"adopcions_id_mascota_foreign";s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"mascotas";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:17:"tr_sync_adopcions";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:9:"adopcions";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_sync_adopcions_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:17:"tr_sync_adopcions";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:9:"adopcions";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_sync_adopcions_to_singular()";}}s:17:"check_constraints";a:0:{}}s:23:"ajuste_inventario_lotes";a:5:{s:7:"columns";a:4:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:20:"id_ajuste_inventario";a:1:{s:4:"type";s:6:"bigint";}s:18:"id_inventario_lote";a:1:{s:4:"type";s:6:"bigint";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(12,2)";}}s:7:"indexes";a:2:{s:28:"ajuste_inventario_lotes_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:30:"ajuste_inventario_lotes_unique";a:4:{s:7:"columns";a:2:{i:0;s:20:"id_ajuste_inventario";i:1;s:18:"id_inventario_lote";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:52:"ajuste_inventario_lotes_id_ajuste_inventario_foreign";s:7:"columns";a:1:{i:0;s:20:"id_ajuste_inventario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:18:"ajuste_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:50:"ajuste_inventario_lotes_id_inventario_lote_foreign";s:7:"columns";a:1:{i:0;s:18:"id_inventario_lote";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:16:"inventario_lotes";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:18:"ajuste_inventarios";a:5:{s:7:"columns";a:12:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:11:"id_articulo";a:1:{s:4:"type";s:6:"bigint";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:14:"usuario_nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"cantidad";a:1:{s:4:"type";s:7:"integer";}s:14:"stock_anterior";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:11:"stock_nuevo";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:25:"saldo_disponible_anterior";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:22:"saldo_disponible_nuevo";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:6:"motivo";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:3:{s:41:"ajuste_inventarios_articulo_created_index";a:4:{s:7:"columns";a:2:{i:0;s:11:"id_articulo";i:1;s:10:"created_at";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:35:"ajuste_inventarios_created_id_index";a:4:{s:7:"columns";a:2:{i:0;s:10:"created_at";i:1;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:23:"ajuste_inventarios_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:38:"ajuste_inventarios_id_articulo_foreign";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"articulo_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:37:"ajuste_inventarios_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:17:"alerta_inventario";a:5:{s:7:"columns";a:5:{s:9:"id_alerta";a:1:{s:4:"type";s:7:"integer";}s:11:"id_articulo";a:1:{s:4:"type";s:7:"integer";}s:16:"nivel_criticidad";a:1:{s:4:"type";s:21:"character varying(20)";}s:14:"fecha_generada";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(20)";}}s:7:"indexes";a:1:{s:22:"alerta_inventario_pkey";a:4:{s:7:"columns";a:1:{i:0;s:9:"id_alerta";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:18:"fk_alerta_articulo";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:19:"articulo_inventario";s:15:"foreign_columns";a:1:{i:0;s:11:"id_articulo";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:13:"aporte_dinero";a:5:{s:7:"columns";a:6:{s:9:"id_aporte";a:1:{s:4:"type";s:7:"integer";}s:11:"id_donacion";a:1:{s:4:"type";s:7:"integer";}s:5:"monto";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:15:"fecha_recepcion";a:1:{s:4:"type";s:4:"date";}s:11:"comprobante";a:1:{s:4:"type";s:22:"character varying(100)";}s:13:"observaciones";a:1:{s:4:"type";s:4:"text";}}s:7:"indexes";a:2:{s:29:"aporte_dinero_id_donacion_key";a:4:{s:7:"columns";a:1:{i:0;s:11:"id_donacion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:18:"aporte_dinero_pkey";a:4:{s:7:"columns";a:1:{i:0;s:9:"id_aporte";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:18:"fk_aporte_donacion";s:7:"columns";a:1:{i:0;s:11:"id_donacion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"donacion";s:15:"foreign_columns";a:1:{i:0;s:11:"id_donacion";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:1:{i:0;O:8:"stdClass":2:{s:7:"conname";s:25:"aporte_dinero_monto_check";s:10:"definition";s:30:"CHECK ((monto > (0)::numeric))";}}}s:14:"aporte_dineros";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:5:"monto";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:15:"fecha_recepcion";a:1:{s:4:"type";s:4:"date";}s:11:"comprobante";a:1:{s:4:"type";s:22:"character varying(100)";}s:13:"observaciones";a:1:{s:4:"type";s:4:"text";}s:11:"id_donacion";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:19:"aporte_dineros_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:34:"aporte_dineros_id_donacion_foreign";s:7:"columns";a:1:{i:0;s:11:"id_donacion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:9:"donacions";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:19:"articulo_inventario";a:5:{s:7:"columns";a:8:{s:11:"id_articulo";a:1:{s:4:"type";s:7:"integer";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(150)";}s:9:"categoria";a:1:{s:4:"type";s:21:"character varying(50)";}s:13:"unidad_medida";a:1:{s:4:"type";s:21:"character varying(20)";}s:12:"stock_actual";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:19:"stock_minimo_alerta";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:24:"articulo_inventario_pkey";a:4:{s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:22:"idx_articulo_categoria";a:4:{s:7:"columns";a:1:{i:0;s:9:"categoria";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:1:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:32:"tr_verificar_stock_minimo_alerta";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:19:"articulo_inventario";s:16:"action_statement";s:51:"EXECUTE FUNCTION fn_verificar_stock_minimo_alerta()";}}s:17:"check_constraints";a:2:{i:0;O:8:"stdClass":2:{s:7:"conname";s:38:"articulo_inventario_stock_actual_check";s:10:"definition";s:38:"CHECK ((stock_actual >= (0)::numeric))";}i:1;O:8:"stdClass":2:{s:7:"conname";s:45:"articulo_inventario_stock_minimo_alerta_check";s:10:"definition";s:45:"CHECK ((stock_minimo_alerta >= (0)::numeric))";}}}s:20:"articulo_inventarios";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(150)";}s:9:"categoria";a:1:{s:4:"type";s:21:"character varying(50)";}s:13:"unidad_medida";a:1:{s:4:"type";s:21:"character varying(20)";}s:12:"stock_actual";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:19:"stock_minimo_alerta";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:2:{s:34:"articulo_inventarios_nombre_unique";a:4:{s:7:"columns";a:1:{i:0;s:6:"nombre";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:25:"articulo_inventarios_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:17:"tr_sync_articulos";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:20:"articulo_inventarios";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_sync_articulos_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:17:"tr_sync_articulos";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:20:"articulo_inventarios";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_sync_articulos_to_singular()";}}s:17:"check_constraints";a:0:{}}s:17:"auditoria_forense";a:5:{s:7:"columns";a:13:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:12:"fecha_evento";a:1:{s:4:"type";s:27:"timestamp(0) with time zone";}s:10:"usuario_id";a:1:{s:4:"type";s:6:"bigint";}s:9:"ip_origen";a:1:{s:4:"type";s:21:"character varying(45)";}s:10:"user_agent";a:1:{s:4:"type";s:4:"text";}s:9:"severidad";a:1:{s:4:"type";s:21:"character varying(20)";}s:6:"modulo";a:1:{s:4:"type";s:21:"character varying(60)";}s:6:"accion";a:1:{s:4:"type";s:21:"character varying(50)";}s:14:"tabla_afectada";a:1:{s:4:"type";s:21:"character varying(60)";}s:11:"registro_id";a:1:{s:4:"type";s:21:"character varying(50)";}s:16:"payload_anterior";a:1:{s:4:"type";s:5:"jsonb";}s:13:"payload_nuevo";a:1:{s:4:"type";s:5:"jsonb";}s:15:"hash_integridad";a:1:{s:4:"type";s:21:"character varying(64)";}}s:7:"indexes";a:3:{s:43:"auditoria_forense_modulo_fecha_evento_index";a:4:{s:7:"columns";a:2:{i:0;s:6:"modulo";i:1;s:12:"fecha_evento";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:22:"auditoria_forense_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:46:"auditoria_forense_severidad_fecha_evento_index";a:4:{s:7:"columns";a:2:{i:0;s:9:"severidad";i:1;s:12:"fecha_evento";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:36:"auditoria_forense_usuario_id_foreign";s:7:"columns";a:1:{i:0;s:10:"usuario_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:8:"bitacora";a:5:{s:7:"columns";a:9:{s:9:"id_accion";a:1:{s:4:"type";s:7:"integer";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:5:"fecha";a:1:{s:4:"type";s:4:"date";}s:4:"hora";a:1:{s:4:"type";s:22:"time without time zone";}s:11:"tipo_accion";a:1:{s:4:"type";s:22:"character varying(100)";}s:14:"tabla_afectada";a:1:{s:4:"type";s:22:"character varying(100)";}s:20:"id_registro_afectado";a:1:{s:4:"type";s:7:"integer";}s:2:"ip";a:1:{s:4:"type";s:21:"character varying(45)";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:3:{s:13:"bitacora_pkey";a:4:{s:7:"columns";a:1:{i:0;s:9:"id_accion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:18:"idx_bitacora_fecha";a:4:{s:7:"columns";a:1:{i:0;s:5:"fecha";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:20:"idx_bitacora_usuario";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:19:"fk_bitacora_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"set null";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:9:"bitacoras";a:5:{s:7:"columns";a:15:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:11:"tipo_accion";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:14:"usuario_nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:6:"modulo";a:1:{s:4:"type";s:22:"character varying(100)";}s:11:"descripcion";a:1:{s:4:"type";s:4:"text";}s:12:"entidad_tipo";a:1:{s:4:"type";s:22:"character varying(100)";}s:10:"entidad_id";a:1:{s:4:"type";s:21:"character varying(64)";}s:2:"ip";a:1:{s:4:"type";s:21:"character varying(45)";}s:11:"http_method";a:1:{s:4:"type";s:21:"character varying(10)";}s:4:"ruta";a:1:{s:4:"type";s:22:"character varying(255)";}s:9:"resultado";a:1:{s:4:"type";s:21:"character varying(20)";}s:8:"contexto";a:1:{s:4:"type";s:4:"json";}}s:7:"indexes";a:3:{s:26:"bitacoras_created_id_index";a:4:{s:7:"columns";a:2:{i:0;s:10:"created_at";i:1;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:32:"bitacoras_modulo_resultado_index";a:4:{s:7:"columns";a:2:{i:0;s:6:"modulo";i:1;s:9:"resultado";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:14:"bitacoras_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:28:"bitacoras_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:5:"cache";a:5:{s:7:"columns";a:3:{s:3:"key";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"value";a:1:{s:4:"type";s:4:"text";}s:10:"expiration";a:1:{s:4:"type";s:6:"bigint";}}s:7:"indexes";a:2:{s:22:"cache_expiration_index";a:4:{s:7:"columns";a:1:{i:0;s:10:"expiration";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:10:"cache_pkey";a:4:{s:7:"columns";a:1:{i:0;s:3:"key";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:11:"cache_locks";a:5:{s:7:"columns";a:3:{s:3:"key";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"owner";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"expiration";a:1:{s:4:"type";s:6:"bigint";}}s:7:"indexes";a:2:{s:28:"cache_locks_expiration_index";a:4:{s:7:"columns";a:1:{i:0;s:10:"expiration";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:16:"cache_locks_pkey";a:4:{s:7:"columns";a:1:{i:0;s:3:"key";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:25:"cierres_periodos_reportes";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:4:"anio";a:1:{s:4:"type";s:7:"integer";}s:3:"mes";a:1:{s:4:"type";s:7:"integer";}s:12:"tipo_reporte";a:1:{s:4:"type";s:21:"character varying(40)";}s:15:"periodo_cerrado";a:1:{s:4:"type";s:7:"boolean";}s:14:"hash_documento";a:1:{s:4:"type";s:21:"character varying(64)";}s:12:"generado_por";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:30:"cierres_periodos_reportes_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:46:"cierres_periodos_reportes_generado_por_foreign";s:7:"columns";a:1:{i:0;s:12:"generado_por";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:6:"compra";a:5:{s:7:"columns";a:7:{s:9:"id_compra";a:1:{s:4:"type";s:7:"integer";}s:12:"id_proveedor";a:1:{s:4:"type";s:7:"integer";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:12:"fecha_compra";a:1:{s:4:"type";s:4:"date";}s:11:"monto_total";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:1:{s:11:"compra_pkey";a:4:{s:7:"columns";a:1:{i:0;s:9:"id_compra";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:19:"fk_compra_proveedor";s:7:"columns";a:1:{i:0;s:12:"id_proveedor";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:9:"proveedor";s:15:"foreign_columns";a:1:{i:0;s:12:"id_proveedor";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:17:"fk_compra_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:1:{i:0;O:8:"stdClass":2:{s:7:"conname";s:24:"compra_monto_total_check";s:10:"definition";s:37:"CHECK ((monto_total >= (0)::numeric))";}}}s:7:"compras";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:11:"monto_total";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:12:"fecha_compra";a:1:{s:4:"type";s:4:"date";}s:12:"id_proveedor";a:1:{s:4:"type";s:6:"bigint";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:16:"numero_documento";a:1:{s:4:"type";s:22:"character varying(100)";}}s:7:"indexes";a:1:{s:12:"compras_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:28:"compras_id_proveedor_foreign";s:7:"columns";a:1:{i:0;s:12:"id_proveedor";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:10:"proveedors";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:26:"compras_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:23:"cronograma_tratamientos";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:15:"prescripcion_id";a:1:{s:4:"type";s:6:"bigint";}s:18:"lote_inventario_id";a:1:{s:4:"type";s:6:"bigint";}s:21:"fecha_hora_programada";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:23:"fecha_hora_administrada";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:16:"administrado_por";a:1:{s:4:"type";s:6:"bigint";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(20)";}s:5:"notas";a:1:{s:4:"type";s:4:"text";}}s:7:"indexes";a:1:{s:28:"cronograma_tratamientos_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:3:{i:0;a:7:{s:4:"name";s:48:"cronograma_tratamientos_administrado_por_foreign";s:7:"columns";a:1:{i:0;s:16:"administrado_por";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}i:1;a:7:{s:4:"name";s:50:"cronograma_tratamientos_lote_inventario_id_foreign";s:7:"columns";a:1:{i:0;s:18:"lote_inventario_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:16:"inventario_lotes";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}i:2;a:7:{s:4:"name";s:47:"cronograma_tratamientos_prescripcion_id_foreign";s:7:"columns";a:1:{i:0;s:15:"prescripcion_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:27:"prescripciones_dosificacion";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:14:"detalle_compra";a:5:{s:7:"columns";a:6:{s:16:"id_detallecompra";a:1:{s:4:"type";s:7:"integer";}s:9:"id_compra";a:1:{s:4:"type";s:7:"integer";}s:9:"id_insumo";a:1:{s:4:"type";s:7:"integer";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:14:"costo_unitario";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}}s:7:"indexes";a:1:{s:19:"detalle_compra_pkey";a:4:{s:7:"columns";a:1:{i:0;s:16:"id_detallecompra";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:25:"fk_detallecompra_cabecera";s:7:"columns";a:1:{i:0;s:9:"id_compra";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:6:"compra";s:15:"foreign_columns";a:1:{i:0;s:9:"id_compra";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:23:"fk_detallecompra_insumo";s:7:"columns";a:1:{i:0;s:9:"id_insumo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:19:"articulo_inventario";s:15:"foreign_columns";a:1:{i:0;s:11:"id_articulo";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:1:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:26:"tr_actualizar_stock_compra";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:14:"detalle_compra";s:16:"action_statement";s:49:"EXECUTE FUNCTION fn_actualizar_stock_por_compra()";}}s:17:"check_constraints";a:2:{i:0;O:8:"stdClass":2:{s:7:"conname";s:29:"detalle_compra_cantidad_check";s:10:"definition";s:33:"CHECK ((cantidad > (0)::numeric))";}i:1;O:8:"stdClass":2:{s:7:"conname";s:35:"detalle_compra_costo_unitario_check";s:10:"definition";s:40:"CHECK ((costo_unitario >= (0)::numeric))";}}}s:15:"detalle_compras";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:14:"costo_unitario";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:9:"id_compra";a:1:{s:4:"type";s:6:"bigint";}s:11:"id_articulo";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:20:"detalle_compras_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:35:"detalle_compras_id_articulo_foreign";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"articulo_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:33:"detalle_compras_id_compra_foreign";s:7:"columns";a:1:{i:0;s:9:"id_compra";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"compras";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:23:"detalle_donacion_insumo";a:5:{s:7:"columns";a:5:{s:10:"id_detalle";a:1:{s:4:"type";s:7:"integer";}s:11:"id_donacion";a:1:{s:4:"type";s:7:"integer";}s:11:"id_articulo";a:1:{s:4:"type";s:7:"integer";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}}s:7:"indexes";a:1:{s:28:"detalle_donacion_insumo_pkey";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_detalle";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:26:"fk_donacioninsumo_articulo";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:19:"articulo_inventario";s:15:"foreign_columns";a:1:{i:0;s:11:"id_articulo";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:26:"fk_donacioninsumo_donacion";s:7:"columns";a:1:{i:0;s:11:"id_donacion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"donacion";s:15:"foreign_columns";a:1:{i:0;s:11:"id_donacion";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:1:{i:0;O:8:"stdClass":2:{s:7:"conname";s:38:"detalle_donacion_insumo_cantidad_check";s:10:"definition";s:33:"CHECK ((cantidad > (0)::numeric))";}}}s:24:"detalle_donacion_insumos";a:5:{s:7:"columns";a:7:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:11:"id_donacion";a:1:{s:4:"type";s:6:"bigint";}s:11:"id_articulo";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:29:"detalle_donacion_insumos_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:44:"detalle_donacion_insumos_id_articulo_foreign";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"articulo_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:44:"detalle_donacion_insumos_id_donacion_foreign";s:7:"columns";a:1:{i:0;s:11:"id_donacion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:9:"donacions";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:24:"detalle_facturas_legales";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:10:"factura_id";a:1:{s:4:"type";s:6:"bigint";}s:8:"concepto";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:15:"precio_unitario";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:8:"subtotal";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:15:"referencia_tipo";a:1:{s:4:"type";s:21:"character varying(30)";}s:13:"referencia_id";a:1:{s:4:"type";s:6:"bigint";}}s:7:"indexes";a:1:{s:29:"detalle_facturas_legales_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:43:"detalle_facturas_legales_factura_id_foreign";s:7:"columns";a:1:{i:0;s:10:"factura_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:16:"facturas_legales";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:14:"detalle_salida";a:5:{s:7:"columns";a:4:{s:16:"id_detallesalida";a:1:{s:4:"type";s:7:"integer";}s:9:"id_salida";a:1:{s:4:"type";s:7:"integer";}s:11:"id_articulo";a:1:{s:4:"type";s:7:"integer";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}}s:7:"indexes";a:1:{s:19:"detalle_salida_pkey";a:4:{s:7:"columns";a:1:{i:0;s:16:"id_detallesalida";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:25:"fk_detallesalida_articulo";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:19:"articulo_inventario";s:15:"foreign_columns";a:1:{i:0;s:11:"id_articulo";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:25:"fk_detallesalida_cabecera";s:7:"columns";a:1:{i:0;s:9:"id_salida";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:17:"salida_inventario";s:15:"foreign_columns";a:1:{i:0;s:9:"id_salida";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:1:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:25:"tr_descontar_stock_salida";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:14:"detalle_salida";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_descontar_stock_por_salida()";}}s:17:"check_constraints";a:1:{i:0;O:8:"stdClass":2:{s:7:"conname";s:29:"detalle_salida_cantidad_check";s:10:"definition";s:33:"CHECK ((cantidad > (0)::numeric))";}}}s:20:"detalle_salida_lotes";a:5:{s:7:"columns";a:6:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:17:"id_detalle_salida";a:1:{s:4:"type";s:6:"bigint";}s:18:"id_inventario_lote";a:1:{s:4:"type";s:6:"bigint";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:2:{s:25:"detalle_salida_lotes_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:27:"detalle_salida_lotes_unique";a:4:{s:7:"columns";a:2:{i:0;s:17:"id_detalle_salida";i:1;s:18:"id_inventario_lote";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:46:"detalle_salida_lotes_id_detalle_salida_foreign";s:7:"columns";a:1:{i:0;s:17:"id_detalle_salida";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:15:"detalle_salidas";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:47:"detalle_salida_lotes_id_inventario_lote_foreign";s:7:"columns";a:1:{i:0;s:18:"id_inventario_lote";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:16:"inventario_lotes";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:15:"detalle_salidas";a:5:{s:7:"columns";a:6:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:8:"cantidad";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:9:"id_salida";a:1:{s:4:"type";s:6:"bigint";}s:11:"id_articulo";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:20:"detalle_salidas_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:35:"detalle_salidas_id_articulo_foreign";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"articulo_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:33:"detalle_salidas_id_salida_foreign";s:7:"columns";a:1:{i:0;s:9:"id_salida";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:18:"salida_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:8:"donacion";a:5:{s:7:"columns";a:7:{s:11:"id_donacion";a:1:{s:4:"type";s:7:"integer";}s:10:"id_donante";a:1:{s:4:"type";s:7:"integer";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:11:"tipo_aporte";a:1:{s:4:"type";s:7:"integer";}s:5:"fecha";a:1:{s:4:"type";s:4:"date";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:13:"donacion_pkey";a:4:{s:7:"columns";a:1:{i:0;s:11:"id_donacion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:20:"idx_donacion_donante";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_donante";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:3:{i:0;a:7:{s:4:"name";s:19:"fk_donacion_donante";s:7:"columns";a:1:{i:0;s:10:"id_donante";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"donante";s:15:"foreign_columns";a:1:{i:0;s:10:"id_donante";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:16:"fk_donacion_tipo";s:7:"columns";a:1:{i:0;s:11:"tipo_aporte";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:11:"tipo_aporte";s:15:"foreign_columns";a:1:{i:0;s:13:"id_tipoaporte";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}i:2;a:7:{s:4:"name";s:19:"fk_donacion_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:9:"donacions";a:5:{s:7:"columns";a:8:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:11:"tipo_aporte";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"fecha";a:1:{s:4:"type";s:4:"date";}s:10:"id_donante";a:1:{s:4:"type";s:6:"bigint";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:16:"numero_documento";a:1:{s:4:"type";s:22:"character varying(100)";}}s:7:"indexes";a:1:{s:14:"donacions_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:28:"donacions_id_donante_foreign";s:7:"columns";a:1:{i:0;s:10:"id_donante";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"donantes";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:28:"donacions_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:17:"tr_sync_donacions";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:9:"donacions";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_sync_donacions_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:17:"tr_sync_donacions";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:9:"donacions";s:16:"action_statement";s:48:"EXECUTE FUNCTION fn_sync_donacions_to_singular()";}}s:17:"check_constraints";a:0:{}}s:7:"donante";a:5:{s:7:"columns";a:6:{s:10:"id_donante";a:1:{s:4:"type";s:7:"integer";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(150)";}s:12:"tipo_persona";a:1:{s:4:"type";s:21:"character varying(50)";}s:8:"telefono";a:1:{s:4:"type";s:21:"character varying(20)";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:1:{s:12:"donante_pkey";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_donante";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:8:"donantes";a:5:{s:7:"columns";a:6:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"telefono";a:1:{s:4:"type";s:22:"character varying(255)";}s:12:"tipo_persona";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:13:"donantes_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:16:"tr_sync_donantes";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:8:"donantes";s:16:"action_statement";s:47:"EXECUTE FUNCTION fn_sync_donantes_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:16:"tr_sync_donantes";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:8:"donantes";s:16:"action_statement";s:47:"EXECUTE FUNCTION fn_sync_donantes_to_singular()";}}s:17:"check_constraints";a:0:{}}s:23:"dosificaciones_fiscales";a:5:{s:7:"columns";a:13:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:10:"nit_emisor";a:1:{s:4:"type";s:21:"character varying(20)";}s:19:"numero_autorizacion";a:1:{s:4:"type";s:21:"character varying(50)";}s:18:"llave_dosificacion";a:1:{s:4:"type";s:4:"text";}s:14:"numero_inicial";a:1:{s:4:"type";s:7:"integer";}s:12:"numero_final";a:1:{s:4:"type";s:7:"integer";}s:18:"correlativo_actual";a:1:{s:4:"type";s:7:"integer";}s:20:"fecha_limite_emision";a:1:{s:4:"type";s:4:"date";}s:18:"leyenda_tributaria";a:1:{s:4:"type";s:4:"text";}s:6:"activa";a:1:{s:4:"type";s:7:"boolean";}s:10:"created_by";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:2:{s:50:"dosificaciones_fiscales_numero_autorizacion_unique";a:4:{s:7:"columns";a:1:{i:0;s:19:"numero_autorizacion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:28:"dosificaciones_fiscales_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:42:"dosificaciones_fiscales_created_by_foreign";s:7:"columns";a:1:{i:0;s:10:"created_by";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:20:"evaluacion_idoneidad";a:5:{s:7:"columns";a:8:{s:13:"id_evaluacion";a:1:{s:4:"type";s:7:"integer";}s:13:"id_interesado";a:1:{s:4:"type";s:7:"integer";}s:16:"puntaje_vivienda";a:1:{s:4:"type";s:7:"integer";}s:18:"puntaje_compromiso";a:1:{s:4:"type";s:7:"integer";}s:13:"puntaje_total";a:1:{s:4:"type";s:7:"integer";}s:9:"resultado";a:1:{s:4:"type";s:21:"character varying(30)";}s:13:"observaciones";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:38:"evaluacion_idoneidad_id_interesado_key";a:4:{s:7:"columns";a:1:{i:0;s:13:"id_interesado";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:25:"evaluacion_idoneidad_pkey";a:4:{s:7:"columns";a:1:{i:0;s:13:"id_evaluacion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:24:"fk_evaluacion_interesado";s:7:"columns";a:1:{i:0;s:13:"id_interesado";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:19:"interesado_adopcion";s:15:"foreign_columns";a:1:{i:0;s:13:"id_interesado";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:18:"expediente_digital";a:5:{s:7:"columns";a:5:{s:14:"nro_expediente";a:1:{s:4:"type";s:21:"character varying(50)";}s:10:"id_mascota";a:1:{s:4:"type";s:7:"integer";}s:14:"estado_clinico";a:1:{s:4:"type";s:21:"character varying(50)";}s:14:"fecha_apertura";a:1:{s:4:"type";s:4:"date";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:33:"expediente_digital_id_mascota_key";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:23:"expediente_digital_pkey";a:4:{s:7:"columns";a:1:{i:0;s:14:"nro_expediente";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:21:"fk_expediente_mascota";s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"mascota";s:15:"foreign_columns";a:1:{i:0;s:10:"id_mascota";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:16:"facturas_compras";a:5:{s:7:"columns";a:14:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:12:"proveedor_id";a:1:{s:4:"type";s:6:"bigint";}s:13:"fecha_factura";a:1:{s:4:"type";s:4:"date";}s:13:"nit_proveedor";a:1:{s:4:"type";s:21:"character varying(20)";}s:22:"razon_social_proveedor";a:1:{s:4:"type";s:22:"character varying(200)";}s:14:"numero_factura";a:1:{s:4:"type";s:21:"character varying(30)";}s:19:"numero_autorizacion";a:1:{s:4:"type";s:21:"character varying(50)";}s:14:"codigo_control";a:1:{s:4:"type";s:21:"character varying(30)";}s:13:"importe_total";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:14:"importe_exento";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:15:"importe_base_cf";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:14:"credito_fiscal";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:14:"registrado_por";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:21:"facturas_compras_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:37:"facturas_compras_proveedor_id_foreign";s:7:"columns";a:1:{i:0;s:12:"proveedor_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:10:"proveedors";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:39:"facturas_compras_registrado_por_foreign";s:7:"columns";a:1:{i:0;s:14:"registrado_por";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:16:"facturas_legales";a:5:{s:7:"columns";a:22:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:15:"dosificacion_id";a:1:{s:4:"type";s:6:"bigint";}s:14:"numero_factura";a:1:{s:4:"type";s:7:"integer";}s:19:"numero_autorizacion";a:1:{s:4:"type";s:21:"character varying(50)";}s:13:"fecha_emision";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:14:"nit_ci_cliente";a:1:{s:4:"type";s:21:"character varying(20)";}s:14:"complemento_ci";a:1:{s:4:"type";s:20:"character varying(5)";}s:20:"razon_social_cliente";a:1:{s:4:"type";s:22:"character varying(200)";}s:8:"subtotal";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:9:"descuento";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:13:"importe_total";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:15:"importe_base_cf";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:13:"debito_fiscal";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:14:"codigo_control";a:1:{s:4:"type";s:21:"character varying(30)";}s:9:"cadena_qr";a:1:{s:4:"type";s:4:"text";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(15)";}s:16:"motivo_anulacion";a:1:{s:4:"type";s:4:"text";}s:15:"fecha_anulacion";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:17:"usuario_emisor_id";a:1:{s:4:"type";s:6:"bigint";}s:19:"usuario_anulador_id";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:2:{s:58:"facturas_legales_numero_autorizacion_numero_factura_unique";a:4:{s:7:"columns";a:2:{i:0;s:19:"numero_autorizacion";i:1;s:14:"numero_factura";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:21:"facturas_legales_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:3:{i:0;a:7:{s:4:"name";s:40:"facturas_legales_dosificacion_id_foreign";s:7:"columns";a:1:{i:0;s:15:"dosificacion_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:23:"dosificaciones_fiscales";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:44:"facturas_legales_usuario_anulador_id_foreign";s:7:"columns";a:1:{i:0;s:19:"usuario_anulador_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}i:2;a:7:{s:4:"name";s:42:"facturas_legales_usuario_emisor_id_foreign";s:7:"columns";a:1:{i:0;s:17:"usuario_emisor_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:11:"failed_jobs";a:5:{s:7:"columns";a:7:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:4:"uuid";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"connection";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"queue";a:1:{s:4:"type";s:22:"character varying(255)";}s:7:"payload";a:1:{s:4:"type";s:4:"text";}s:9:"exception";a:1:{s:4:"type";s:4:"text";}s:9:"failed_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:3:{s:44:"failed_jobs_connection_queue_failed_at_index";a:4:{s:7:"columns";a:3:{i:0;s:10:"connection";i:1;s:5:"queue";i:2;s:9:"failed_at";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:16:"failed_jobs_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:23:"failed_jobs_uuid_unique";a:4:{s:7:"columns";a:1:{i:0;s:4:"uuid";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:17:"historial_clinico";a:5:{s:7:"columns";a:9:{s:12:"id_historial";a:1:{s:4:"type";s:7:"integer";}s:10:"id_mascota";a:1:{s:4:"type";s:7:"integer";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:14:"fecha_atencion";a:1:{s:4:"type";s:4:"date";}s:18:"tipo_procedimiento";a:1:{s:4:"type";s:22:"character varying(100)";}s:11:"diagnostico";a:1:{s:4:"type";s:4:"text";}s:13:"observaciones";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:22:"historial_clinico_pkey";a:4:{s:7:"columns";a:1:{i:0;s:12:"id_historial";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:21:"idx_historial_mascota";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:20:"fk_historial_mascota";s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"mascota";s:15:"foreign_columns";a:1:{i:0;s:10:"id_mascota";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:20:"fk_historial_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:1:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:34:"tr_actualizar_estado_por_historial";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:17:"historial_clinico";s:16:"action_statement";s:53:"EXECUTE FUNCTION fn_actualizar_estado_por_historial()";}}s:17:"check_constraints";a:0:{}}s:18:"historial_clinicos";a:5:{s:7:"columns";a:9:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:14:"fecha_atencion";a:1:{s:4:"type";s:22:"character varying(255)";}s:11:"diagnostico";a:1:{s:4:"type";s:22:"character varying(255)";}s:11:"observacion";a:1:{s:4:"type";s:22:"character varying(255)";}s:18:"tipo_procedimiento";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"id_mascota";a:1:{s:4:"type";s:6:"bigint";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:23:"historial_clinicos_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:37:"historial_clinicos_id_mascota_foreign";s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"mascotas";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:37:"historial_clinicos_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:19:"interesado_adopcion";a:5:{s:7:"columns";a:10:{s:13:"id_interesado";a:1:{s:4:"type";s:7:"integer";}s:2:"ci";a:1:{s:4:"type";s:21:"character varying(20)";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(150)";}s:8:"telefono";a:1:{s:4:"type";s:21:"character varying(20)";}s:9:"direccion";a:1:{s:4:"type";s:22:"character varying(255)";}s:14:"situacion_casa";a:1:{s:4:"type";s:4:"text";}s:11:"referencias";a:1:{s:4:"type";s:4:"text";}s:18:"puntaje_evaluacion";a:1:{s:4:"type";s:7:"integer";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:26:"interesado_adopcion_ci_key";a:4:{s:7:"columns";a:1:{i:0;s:2:"ci";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:24:"interesado_adopcion_pkey";a:4:{s:7:"columns";a:1:{i:0;s:13:"id_interesado";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:20:"interesado_adopcions";a:5:{s:7:"columns";a:11:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:2:"ci";a:1:{s:4:"type";s:21:"character varying(20)";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:9:"direccion";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"telefono";a:1:{s:4:"type";s:22:"character varying(255)";}s:14:"situacion_casa";a:1:{s:4:"type";s:22:"character varying(255)";}s:11:"referencias";a:1:{s:4:"type";s:22:"character varying(255)";}s:18:"puntaje_evaluacion";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(32)";}}s:7:"indexes";a:3:{s:30:"interesado_adopcions_ci_unique";a:4:{s:7:"columns";a:1:{i:0;s:2:"ci";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:33:"interesado_adopcions_estado_index";a:4:{s:7:"columns";a:1:{i:0;s:6:"estado";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:25:"interesado_adopcions_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:19:"tr_sync_interesados";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:20:"interesado_adopcions";s:16:"action_statement";s:50:"EXECUTE FUNCTION fn_sync_interesados_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:19:"tr_sync_interesados";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:20:"interesado_adopcions";s:16:"action_statement";s:50:"EXECUTE FUNCTION fn_sync_interesados_to_singular()";}}s:17:"check_constraints";a:0:{}}s:16:"inventario_lotes";a:5:{s:7:"columns";a:10:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:11:"id_articulo";a:1:{s:4:"type";s:6:"bigint";}s:17:"id_detalle_compra";a:1:{s:4:"type";s:6:"bigint";}s:19:"id_detalle_donacion";a:1:{s:4:"type";s:6:"bigint";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}s:16:"cantidad_inicial";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:19:"cantidad_disponible";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:16:"cantidad_vencida";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:4:{s:27:"inventario_lotes_fefo_index";a:4:{s:7:"columns";a:3:{i:0;s:11:"id_articulo";i:1;s:17:"fecha_vencimiento";i:2;s:19:"cantidad_disponible";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:41:"inventario_lotes_id_detalle_compra_unique";a:4:{s:7:"columns";a:1:{i:0;s:17:"id_detalle_compra";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:43:"inventario_lotes_id_detalle_donacion_unique";a:4:{s:7:"columns";a:1:{i:0;s:19:"id_detalle_donacion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:21:"inventario_lotes_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:3:{i:0;a:7:{s:4:"name";s:36:"inventario_lotes_id_articulo_foreign";s:7:"columns";a:1:{i:0;s:11:"id_articulo";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"articulo_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:42:"inventario_lotes_id_detalle_compra_foreign";s:7:"columns";a:1:{i:0;s:17:"id_detalle_compra";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:15:"detalle_compras";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}i:2;a:7:{s:4:"name";s:44:"inventario_lotes_id_detalle_donacion_foreign";s:7:"columns";a:1:{i:0;s:19:"id_detalle_donacion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:24:"detalle_donacion_insumos";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:11:"job_batches";a:5:{s:7:"columns";a:10:{s:2:"id";a:1:{s:4:"type";s:22:"character varying(255)";}s:4:"name";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"total_jobs";a:1:{s:4:"type";s:7:"integer";}s:12:"pending_jobs";a:1:{s:4:"type";s:7:"integer";}s:11:"failed_jobs";a:1:{s:4:"type";s:7:"integer";}s:14:"failed_job_ids";a:1:{s:4:"type";s:4:"text";}s:7:"options";a:1:{s:4:"type";s:4:"text";}s:12:"cancelled_at";a:1:{s:4:"type";s:7:"integer";}s:10:"created_at";a:1:{s:4:"type";s:7:"integer";}s:11:"finished_at";a:1:{s:4:"type";s:7:"integer";}}s:7:"indexes";a:1:{s:16:"job_batches_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:4:"jobs";a:5:{s:7:"columns";a:7:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:5:"queue";a:1:{s:4:"type";s:22:"character varying(255)";}s:7:"payload";a:1:{s:4:"type";s:4:"text";}s:8:"attempts";a:1:{s:4:"type";s:8:"smallint";}s:11:"reserved_at";a:1:{s:4:"type";s:7:"integer";}s:12:"available_at";a:1:{s:4:"type";s:7:"integer";}s:10:"created_at";a:1:{s:4:"type";s:7:"integer";}}s:7:"indexes";a:2:{s:9:"jobs_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:16:"jobs_queue_index";a:4:{s:7:"columns";a:1:{i:0;s:5:"queue";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:7:"mascota";a:5:{s:7:"columns";a:12:{s:10:"id_mascota";a:1:{s:4:"type";s:7:"integer";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(100)";}s:7:"especie";a:1:{s:4:"type";s:21:"character varying(50)";}s:4:"raza";a:1:{s:4:"type";s:21:"character varying(50)";}s:4:"sexo";a:1:{s:4:"type";s:21:"character varying(15)";}s:15:"edad_aproximada";a:1:{s:4:"type";s:21:"character varying(50)";}s:13:"estado_actual";a:1:{s:4:"type";s:21:"character varying(50)";}s:12:"zona_rescate";a:1:{s:4:"type";s:22:"character varying(150)";}s:13:"fecha_ingreso";a:1:{s:4:"type";s:4:"date";}s:4:"foto";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:3:{s:19:"idx_mascota_especie";a:4:{s:7:"columns";a:1:{i:0;s:7:"especie";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:18:"idx_mascota_estado";a:4:{s:7:"columns";a:1:{i:0;s:13:"estado_actual";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:12:"mascota_pkey";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_mascota";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:8:"mascotas";a:5:{s:7:"columns";a:12:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:4:"raza";a:1:{s:4:"type";s:22:"character varying(255)";}s:4:"edad";a:1:{s:4:"type";s:22:"character varying(255)";}s:7:"especie";a:1:{s:4:"type";s:22:"character varying(255)";}s:13:"estado_actual";a:1:{s:4:"type";s:22:"character varying(255)";}s:13:"fecha_ingreso";a:1:{s:4:"type";s:22:"character varying(255)";}s:4:"sexo";a:1:{s:4:"type";s:22:"character varying(255)";}s:12:"zona_rescate";a:1:{s:4:"type";s:22:"character varying(255)";}s:4:"foto";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:13:"mascotas_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:16:"tr_sync_mascotas";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:8:"mascotas";s:16:"action_statement";s:46:"EXECUTE FUNCTION fn_sync_mascotas_to_mascota()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:16:"tr_sync_mascotas";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:8:"mascotas";s:16:"action_statement";s:46:"EXECUTE FUNCTION fn_sync_mascotas_to_mascota()";}}s:17:"check_constraints";a:0:{}}s:11:"medicamento";a:5:{s:7:"columns";a:19:{s:14:"id_medicamento";a:1:{s:4:"type";s:7:"integer";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:16:"principio_activo";a:1:{s:4:"type";s:22:"character varying(255)";}s:23:"categoria_farmacologica";a:1:{s:4:"type";s:22:"character varying(100)";}s:17:"tipo_presentacion";a:1:{s:4:"type";s:22:"character varying(100)";}s:18:"via_administracion";a:1:{s:4:"type";s:22:"character varying(100)";}s:13:"concentracion";a:1:{s:4:"type";s:22:"character varying(100)";}s:15:"especie_destino";a:1:{s:4:"type";s:22:"character varying(100)";}s:17:"dosis_recomendada";a:1:{s:4:"type";s:22:"character varying(255)";}s:22:"indicacion_terapeutica";a:1:{s:4:"type";s:4:"text";}s:13:"es_inyectable";a:1:{s:4:"type";s:7:"boolean";}s:4:"lote";a:1:{s:4:"type";s:21:"character varying(50)";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}s:12:"stock_actual";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:12:"stock_minimo";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:13:"unidad_medida";a:1:{s:4:"type";s:21:"character varying(50)";}s:15:"precio_unitario";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:16:"medicamento_pkey";a:4:{s:7:"columns";a:1:{i:0;s:14:"id_medicamento";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:12:"medicamentos";a:5:{s:7:"columns";a:20:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:14:"id_medicamento";a:1:{s:4:"type";s:7:"integer";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:16:"principio_activo";a:1:{s:4:"type";s:22:"character varying(255)";}s:23:"categoria_farmacologica";a:1:{s:4:"type";s:22:"character varying(100)";}s:17:"tipo_presentacion";a:1:{s:4:"type";s:22:"character varying(100)";}s:18:"via_administracion";a:1:{s:4:"type";s:22:"character varying(100)";}s:13:"concentracion";a:1:{s:4:"type";s:22:"character varying(100)";}s:15:"especie_destino";a:1:{s:4:"type";s:22:"character varying(100)";}s:17:"dosis_recomendada";a:1:{s:4:"type";s:22:"character varying(255)";}s:22:"indicacion_terapeutica";a:1:{s:4:"type";s:4:"text";}s:13:"es_inyectable";a:1:{s:4:"type";s:7:"boolean";}s:4:"lote";a:1:{s:4:"type";s:21:"character varying(50)";}s:17:"fecha_vencimiento";a:1:{s:4:"type";s:4:"date";}s:12:"stock_actual";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:12:"stock_minimo";a:1:{s:4:"type";s:13:"numeric(12,2)";}s:13:"unidad_medida";a:1:{s:4:"type";s:21:"character varying(50)";}s:15:"precio_unitario";a:1:{s:4:"type";s:13:"numeric(10,2)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:3:{s:32:"medicamentos_es_inyectable_index";a:4:{s:7:"columns";a:1:{i:0;s:13:"es_inyectable";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:33:"medicamentos_id_medicamento_index";a:4:{s:7:"columns";a:1:{i:0;s:14:"id_medicamento";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:17:"medicamentos_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:21:"trg_sync_medicamentos";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:12:"medicamentos";s:16:"action_statement";s:51:"EXECUTE FUNCTION sync_medicamentos_to_medicamento()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:21:"trg_sync_medicamentos";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:12:"medicamentos";s:16:"action_statement";s:51:"EXECUTE FUNCTION sync_medicamentos_to_medicamento()";}}s:17:"check_constraints";a:0:{}}s:10:"migrations";a:5:{s:7:"columns";a:3:{s:2:"id";a:1:{s:4:"type";s:7:"integer";}s:9:"migration";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"batch";a:1:{s:4:"type";s:7:"integer";}}s:7:"indexes";a:1:{s:15:"migrations_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:21:"password_reset_tokens";a:5:{s:7:"columns";a:3:{s:5:"email";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"token";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:26:"password_reset_tokens_pkey";a:4:{s:7:"columns";a:1:{i:0;s:5:"email";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:22:"personal_access_tokens";a:5:{s:7:"columns";a:10:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:14:"tokenable_type";a:1:{s:4:"type";s:22:"character varying(255)";}s:12:"tokenable_id";a:1:{s:4:"type";s:6:"bigint";}s:4:"name";a:1:{s:4:"type";s:4:"text";}s:5:"token";a:1:{s:4:"type";s:21:"character varying(64)";}s:9:"abilities";a:1:{s:4:"type";s:4:"text";}s:12:"last_used_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"expires_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:4:{s:39:"personal_access_tokens_expires_at_index";a:4:{s:7:"columns";a:1:{i:0;s:10:"expires_at";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:27:"personal_access_tokens_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:35:"personal_access_tokens_token_unique";a:4:{s:7:"columns";a:1:{i:0;s:5:"token";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:56:"personal_access_tokens_tokenable_type_tokenable_id_index";a:4:{s:7:"columns";a:2:{i:0;s:14:"tokenable_type";i:1;s:12:"tokenable_id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:27:"prescripciones_dosificacion";a:5:{s:7:"columns";a:16:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:10:"mascota_id";a:1:{s:4:"type";s:6:"bigint";}s:20:"historial_clinico_id";a:1:{s:4:"type";s:6:"bigint";}s:11:"articulo_id";a:1:{s:4:"type";s:6:"bigint";}s:14:"veterinario_id";a:1:{s:4:"type";s:6:"bigint";}s:15:"peso_mascota_kg";a:1:{s:4:"type";s:12:"numeric(6,2)";}s:11:"dosis_mg_kg";a:1:{s:4:"type";s:12:"numeric(8,3)";}s:21:"concentracion_farmaco";a:1:{s:4:"type";s:12:"numeric(8,3)";}s:22:"dosis_calculada_unidad";a:1:{s:4:"type";s:12:"numeric(8,3)";}s:13:"unidad_medida";a:1:{s:4:"type";s:21:"character varying(20)";}s:16:"frecuencia_horas";a:1:{s:4:"type";s:7:"integer";}s:13:"duracion_dias";a:1:{s:4:"type";s:7:"integer";}s:22:"observaciones_clinicas";a:1:{s:4:"type";s:4:"text";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(20)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:32:"prescripciones_dosificacion_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:4:{i:0;a:7:{s:4:"name";s:47:"prescripciones_dosificacion_articulo_id_foreign";s:7:"columns";a:1:{i:0;s:11:"articulo_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:20:"articulo_inventarios";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}i:1;a:7:{s:4:"name";s:56:"prescripciones_dosificacion_historial_clinico_id_foreign";s:7:"columns";a:1:{i:0;s:20:"historial_clinico_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:18:"historial_clinicos";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}i:2;a:7:{s:4:"name";s:46:"prescripciones_dosificacion_mascota_id_foreign";s:7:"columns";a:1:{i:0;s:10:"mascota_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"mascotas";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}i:3;a:7:{s:4:"name";s:50:"prescripciones_dosificacion_veterinario_id_foreign";s:7:"columns";a:1:{i:0;s:14:"veterinario_id";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:9:"proveedor";a:5:{s:7:"columns";a:8:{s:12:"id_proveedor";a:1:{s:4:"type";s:7:"integer";}s:14:"nombre_empresa";a:1:{s:4:"type";s:22:"character varying(150)";}s:15:"contacto_nombre";a:1:{s:4:"type";s:22:"character varying(150)";}s:9:"direccion";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"telefono";a:1:{s:4:"type";s:21:"character varying(20)";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(50)";}}s:7:"indexes";a:2:{s:28:"proveedor_nombre_empresa_key";a:4:{s:7:"columns";a:1:{i:0;s:14:"nombre_empresa";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:14:"proveedor_pkey";a:4:{s:7:"columns";a:1:{i:0;s:12:"id_proveedor";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:10:"proveedors";a:5:{s:7:"columns";a:11:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:14:"nombre_empresa";a:1:{s:4:"type";s:22:"character varying(255)";}s:15:"nombre_contacto";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"telefono";a:1:{s:4:"type";s:22:"character varying(255)";}s:9:"direccion";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:14:"identificacion";a:1:{s:4:"type";s:21:"character varying(50)";}s:20:"tipo_insumo_provisto";a:1:{s:4:"type";s:22:"character varying(255)";}s:6:"activo";a:1:{s:4:"type";s:7:"boolean";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(50)";}}s:7:"indexes";a:3:{s:28:"proveedors_active_name_index";a:4:{s:7:"columns";a:2:{i:0;s:6:"activo";i:1;s:14:"nombre_empresa";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:31:"proveedors_identificacion_index";a:4:{s:7:"columns";a:1:{i:0;s:14:"identificacion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:15:"proveedors_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:18:"tr_sync_proveedors";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:10:"proveedors";s:16:"action_statement";s:49:"EXECUTE FUNCTION fn_sync_proveedors_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:18:"tr_sync_proveedors";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:10:"proveedors";s:16:"action_statement";s:49:"EXECUTE FUNCTION fn_sync_proveedors_to_singular()";}}s:17:"check_constraints";a:0:{}}s:11:"rol_permiso";a:5:{s:7:"columns";a:5:{s:6:"id_rol";a:1:{s:4:"type";s:7:"integer";}s:10:"nombre_rol";a:1:{s:4:"type";s:21:"character varying(50)";}s:11:"descripcion";a:1:{s:4:"type";s:22:"character varying(255)";}s:16:"permisos_modulos";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:26:"rol_permiso_nombre_rol_key";a:4:{s:7:"columns";a:1:{i:0;s:10:"nombre_rol";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:16:"rol_permiso_pkey";a:4:{s:7:"columns";a:1:{i:0;s:6:"id_rol";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:17:"salida_inventario";a:5:{s:7:"columns";a:6:{s:9:"id_salida";a:1:{s:4:"type";s:7:"integer";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:12:"fecha_salida";a:1:{s:4:"type";s:4:"date";}s:6:"motivo";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:1:{s:22:"salida_inventario_pkey";a:4:{s:7:"columns";a:1:{i:0;s:9:"id_salida";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:17:"fk_salida_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:18:"salida_inventarios";a:5:{s:7:"columns";a:7:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:6:"motivo";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:12:"fecha_salida";a:1:{s:4:"type";s:4:"date";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:20:"id_historial_clinico";a:1:{s:4:"type";s:6:"bigint";}}s:7:"indexes";a:2:{s:43:"salida_inventarios_historial_clinico_unique";a:4:{s:7:"columns";a:1:{i:0;s:20:"id_historial_clinico";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:23:"salida_inventarios_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:44:"salida_inventarios_historial_clinico_foreign";s:7:"columns";a:1:{i:0;s:20:"id_historial_clinico";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:18:"historial_clinicos";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:8:"set null";}i:1;a:7:{s:4:"name";s:37:"salida_inventarios_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:20:"seguimiento_adopcion";a:5:{s:7:"columns";a:10:{s:14:"id_seguimiento";a:1:{s:4:"type";s:7:"integer";}s:11:"id_adopcion";a:1:{s:4:"type";s:7:"integer";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:18:"estado_seguimiento";a:1:{s:4:"type";s:21:"character varying(50)";}s:16:"fecha_programada";a:1:{s:4:"type";s:4:"date";}s:15:"fecha_realizada";a:1:{s:4:"type";s:4:"date";}s:17:"reporte_bienestar";a:1:{s:4:"type";s:4:"text";}s:21:"fotografias_evidencia";a:1:{s:4:"type";s:4:"text";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:2:{s:24:"idx_seguimiento_adopcion";a:4:{s:7:"columns";a:1:{i:0;s:11:"id_adopcion";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:25:"seguimiento_adopcion_pkey";a:4:{s:7:"columns";a:1:{i:0;s:14:"id_seguimiento";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:23:"fk_seguimiento_adopcion";s:7:"columns";a:1:{i:0;s:11:"id_adopcion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:8:"adopcion";s:15:"foreign_columns";a:1:{i:0;s:11:"id_adopcion";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:22:"fk_seguimiento_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:8:"restrict";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:21:"seguimiento_adopcions";a:5:{s:7:"columns";a:10:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:18:"estado_seguimiento";a:1:{s:4:"type";s:22:"character varying(255)";}s:16:"fecha_programada";a:1:{s:4:"type";s:4:"date";}s:15:"fecha_realizada";a:1:{s:4:"type";s:4:"date";}s:10:"fotografia";a:1:{s:4:"type";s:4:"text";}s:17:"reporte_bienestar";a:1:{s:4:"type";s:4:"text";}s:11:"id_adopcion";a:1:{s:4:"type";s:6:"bigint";}s:10:"id_usuario";a:1:{s:4:"type";s:6:"bigint";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:26:"seguimiento_adopcions_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:2:{i:0;a:7:{s:4:"name";s:41:"seguimiento_adopcions_id_adopcion_foreign";s:7:"columns";a:1:{i:0;s:11:"id_adopcion";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:9:"adopcions";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}i:1;a:7:{s:4:"name";s:40:"seguimiento_adopcions_id_usuario_foreign";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:5:"users";s:15:"foreign_columns";a:1:{i:0;s:2:"id";}s:9:"on_update";s:9:"no action";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:20:"tr_sync_seguimientos";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:21:"seguimiento_adopcions";s:16:"action_statement";s:51:"EXECUTE FUNCTION fn_sync_seguimientos_to_singular()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:20:"tr_sync_seguimientos";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:21:"seguimiento_adopcions";s:16:"action_statement";s:51:"EXECUTE FUNCTION fn_sync_seguimientos_to_singular()";}}s:17:"check_constraints";a:0:{}}s:10:"sesion_jwt";a:5:{s:7:"columns";a:7:{s:10:"token_hash";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:10:"ip_cliente";a:1:{s:4:"type";s:21:"character varying(45)";}s:10:"user_agent";a:1:{s:4:"type";s:22:"character varying(255)";}s:13:"fecha_emision";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:16:"fecha_expiracion";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(20)";}}s:7:"indexes";a:1:{s:15:"sesion_jwt_pkey";a:4:{s:7:"columns";a:1:{i:0;s:10:"token_hash";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:1:{i:0;a:7:{s:4:"name";s:17:"fk_sesion_usuario";s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:14:"foreign_schema";s:6:"public";s:13:"foreign_table";s:7:"usuario";s:15:"foreign_columns";a:1:{i:0;s:10:"id_usuario";}s:9:"on_update";s:7:"cascade";s:9:"on_delete";s:7:"cascade";}}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:8:"sessions";a:5:{s:7:"columns";a:6:{s:2:"id";a:1:{s:4:"type";s:22:"character varying(255)";}s:7:"user_id";a:1:{s:4:"type";s:6:"bigint";}s:10:"ip_address";a:1:{s:4:"type";s:21:"character varying(45)";}s:10:"user_agent";a:1:{s:4:"type";s:4:"text";}s:7:"payload";a:1:{s:4:"type";s:4:"text";}s:13:"last_activity";a:1:{s:4:"type";s:7:"integer";}}s:7:"indexes";a:3:{s:28:"sessions_last_activity_index";a:4:{s:7:"columns";a:1:{i:0;s:13:"last_activity";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:13:"sessions_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}s:22:"sessions_user_id_index";a:4:{s:7:"columns";a:1:{i:0;s:7:"user_id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:11:"tipo_aporte";a:5:{s:7:"columns";a:3:{s:13:"id_tipoaporte";a:1:{s:4:"type";s:7:"integer";}s:6:"nombre";a:1:{s:4:"type";s:21:"character varying(50)";}s:11:"descripcion";a:1:{s:4:"type";s:4:"text";}}s:7:"indexes";a:2:{s:22:"tipo_aporte_nombre_key";a:4:{s:7:"columns";a:1:{i:0;s:6:"nombre";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:16:"tipo_aporte_pkey";a:4:{s:7:"columns";a:1:{i:0;s:13:"id_tipoaporte";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:12:"tipo_aportes";a:5:{s:7:"columns";a:5:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:11:"descripcion";a:1:{s:4:"type";s:22:"character varying(255)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}}s:7:"indexes";a:1:{s:17:"tipo_aportes_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}s:5:"users";a:5:{s:7:"columns";a:11:{s:2:"id";a:1:{s:4:"type";s:6:"bigint";}s:6:"nombre";a:1:{s:4:"type";s:22:"character varying(255)";}s:5:"email";a:1:{s:4:"type";s:22:"character varying(255)";}s:3:"rol";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"telefono";a:1:{s:4:"type";s:22:"character varying(255)";}s:8:"password";a:1:{s:4:"type";s:22:"character varying(255)";}s:14:"remember_token";a:1:{s:4:"type";s:22:"character varying(100)";}s:10:"created_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:30:"timestamp(0) without time zone";}s:2:"ci";a:1:{s:4:"type";s:21:"character varying(20)";}s:6:"activo";a:1:{s:4:"type";s:7:"boolean";}}s:7:"indexes";a:3:{s:15:"users_ci_unique";a:4:{s:7:"columns";a:1:{i:0;s:2:"ci";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:18:"users_email_unique";a:4:{s:7:"columns";a:1:{i:0;s:5:"email";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:10:"users_pkey";a:4:{s:7:"columns";a:1:{i:0;s:2:"id";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:2:{i:0;O:8:"stdClass":4:{s:12:"trigger_name";s:13:"tr_sync_users";s:18:"event_manipulation";s:6:"INSERT";s:18:"event_object_table";s:5:"users";s:16:"action_statement";s:43:"EXECUTE FUNCTION fn_sync_users_to_usuario()";}i:1;O:8:"stdClass":4:{s:12:"trigger_name";s:13:"tr_sync_users";s:18:"event_manipulation";s:6:"UPDATE";s:18:"event_object_table";s:5:"users";s:16:"action_statement";s:43:"EXECUTE FUNCTION fn_sync_users_to_usuario()";}}s:17:"check_constraints";a:0:{}}s:7:"usuario";a:5:{s:7:"columns";a:11:{s:10:"id_usuario";a:1:{s:4:"type";s:7:"integer";}s:2:"ci";a:1:{s:4:"type";s:21:"character varying(20)";}s:15:"nombre_completo";a:1:{s:4:"type";s:22:"character varying(150)";}s:3:"rol";a:1:{s:4:"type";s:21:"character varying(50)";}s:8:"telefono";a:1:{s:4:"type";s:21:"character varying(20)";}s:15:"hash_contrasena";a:1:{s:4:"type";s:22:"character varying(255)";}s:6:"estado";a:1:{s:4:"type";s:21:"character varying(20)";}s:17:"intentos_fallidos";a:1:{s:4:"type";s:7:"integer";}s:15:"bloqueado_hasta";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"created_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}s:10:"updated_at";a:1:{s:4:"type";s:27:"timestamp without time zone";}}s:7:"indexes";a:4:{s:14:"idx_usuario_ci";a:4:{s:7:"columns";a:1:{i:0;s:2:"ci";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:15:"idx_usuario_rol";a:4:{s:7:"columns";a:1:{i:0;s:3:"rol";}s:4:"type";s:5:"btree";s:9:"is_unique";b:0;s:10:"is_primary";b:0;}s:14:"usuario_ci_key";a:4:{s:7:"columns";a:1:{i:0;s:2:"ci";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:0;}s:12:"usuario_pkey";a:4:{s:7:"columns";a:1:{i:0;s:10:"id_usuario";}s:4:"type";s:5:"btree";s:9:"is_unique";b:1;s:10:"is_primary";b:1;}}s:12:"foreign_keys";a:0:{}s:8:"triggers";a:0:{}s:17:"check_constraints";a:0:{}}}}	1795284875
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: cierres_periodos_reportes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cierres_periodos_reportes (id, anio, mes, tipo_reporte, periodo_cerrado, hash_documento, generado_por, created_at) FROM stdin;
1	2026	1	LIBRO_VENTAS	t	133655ed1827d579f381cc30d18f7b3598015f39306f7a0a9ab27f3ee3691ce3	6	2026-01-31 17:50:00
2	2026	2	LIBRO_VENTAS	t	3413ce9e840699693710399536487786407734ce9f93cee8500943cf3aa64126	6	2026-02-28 17:50:00
3	2026	3	LIBRO_VENTAS	t	2195288271c08705bb09e571db62045580e72e769f8831a5a7a3e965bf64c9b7	6	2026-03-31 17:50:00
4	2026	3	RENDICION_CUENTAS	t	3119a07a2c7de3a3a9cb94ddce18c0685f88f28705c128605599178e3601075a	6	2026-03-31 17:55:00
5	2026	4	LIBRO_VENTAS	t	2254844e34ed4ca87b738558f6a04c8810090f3e2f3ad7719c23476846758c59	6	2026-04-30 17:50:00
6	2026	5	LIBRO_VENTAS	t	953c9d6b6092a7254a2f594abcacda08d8e7790c3b94cc3bb89f779de0608fbc	6	2026-05-31 17:50:00
7	2026	6	LIBRO_VENTAS	t	41a79b1b8da3c268b23cbd6e8e40c80eda0a96fc1b55ee8cf918061e817de4e9	6	2026-06-30 17:50:00
8	2026	6	RENDICION_CUENTAS	t	3faa8a8f3f9abd5fb2bd6a6b81f10b22d35836a1f519c4cd84c0f08ec756068b	6	2026-06-30 17:55:00
9	2026	7	LIBRO_VENTAS	t	22ec42a3056ec8b86045bb50d494ab72d0c5af888e7b8b88214840d13aac9d46	6	2026-07-31 17:50:00
10	2026	8	LIBRO_VENTAS	t	e1d57a14549279f8e56c07c9d6eff7d1b6826b915b47bd8d63b3ef16a5d30464	6	2026-08-31 17:50:00
11	2026	9	LIBRO_VENTAS	t	66202f24fb04fafe5c18e01506e052e219ef888ba5a04beead680f6dbe95cfe4	6	2026-09-30 17:50:00
12	2026	9	RENDICION_CUENTAS	t	2dbee3539cd35583eaac11b2b48760084750f9638f994eed5e22ea5d29a3ff03	6	2026-09-30 17:55:00
13	2026	10	LIBRO_VENTAS	t	fa1466845fd3682804ac2d98d600b8f1ed16d85760a3bb11e478320969d2bc36	6	2026-10-31 17:50:00
14	2026	11	LIBRO_VENTAS	f	1e729e1053b52453efdce9149b1b8fe4dbd50fb6fb47a21f37afc7a8b984c815	6	2026-11-12 17:50:00
15	2026	11	RENDICION_CUENTAS	f	707d4f01170f6688f2e4bc1579fdedc3d56f39de18d1f3cdf2bebcce63328d98	6	2026-11-12 17:55:00
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.compra (id_compra, id_proveedor, id_usuario, fecha_compra, monto_total, created_at, updated_at) FROM stdin;
1	1	2	2026-06-06	625.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	2	3	2026-06-08	751.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	3	4	2026-06-10	876.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	4	5	2026-06-12	1002.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	5	1	2026-06-14	1127.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	6	2	2026-06-16	1253.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	7	3	2026-06-18	1378.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	8	4	2026-06-20	1504.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	9	5	2026-06-22	1629.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	10	1	2026-06-24	1755.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	11	2	2026-06-26	1880.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	12	3	2026-06-28	2006.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	13	4	2026-06-30	2131.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	14	5	2026-07-02	2257.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	15	1	2026-07-04	2382.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	16	2	2026-07-06	2508.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	17	3	2026-07-08	2633.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	18	4	2026-07-10	2759.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	19	5	2026-07-12	2884.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	20	1	2026-07-14	3010.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	21	2	2026-07-16	3135.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	22	3	2026-07-18	3261.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	23	4	2026-07-20	3386.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	24	5	2026-07-22	3512.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	25	1	2026-07-24	3637.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	26	2	2026-07-26	3763.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	27	3	2026-07-28	3888.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	28	4	2026-07-30	4014.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	29	5	2026-08-01	4139.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	30	1	2026-08-03	4265.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	31	2	2026-08-05	4390.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	32	3	2026-08-07	4516.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	33	4	2026-08-09	4641.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	34	5	2026-08-11	4767.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	35	1	2026-08-13	4892.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	36	2	2026-08-15	5018.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	37	3	2026-08-17	5143.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	38	4	2026-08-19	5269.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	39	5	2026-08-21	5394.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	40	1	2026-08-23	5520.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	41	2	2026-08-25	5645.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	42	3	2026-08-27	5771.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	43	4	2026-08-29	5896.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	44	5	2026-08-31	6022.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	45	1	2026-09-02	6147.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	46	2	2026-09-04	6273.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	47	3	2026-09-06	6398.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	48	4	2026-09-08	6524.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	49	5	2026-09-10	6649.50	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	50	1	2026-09-12	6775.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.compras (id, monto_total, fecha_compra, id_proveedor, id_usuario, created_at, updated_at, numero_documento) FROM stdin;
1	1250.00	2026-01-05	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
2	840.00	2026-02-02	3	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
3	449.00	2026-11-11	5	3	2026-11-12 16:51:28	2026-11-12 16:51:28	FAC-00003
4	457.00	2026-11-07	6	4	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00004
5	314.00	2026-11-03	7	5	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00005
6	583.00	2026-10-30	8	7	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00006
7	1132.00	2026-10-26	9	6	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00007
8	1184.00	2026-10-22	10	8	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00008
9	755.00	2026-10-18	11	9	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00009
10	1238.00	2026-10-14	12	10	2026-11-12 16:51:29	2026-11-12 16:51:29	FAC-00010
\.


--
-- Data for Name: cronograma_tratamientos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cronograma_tratamientos (id, prescripcion_id, lote_inventario_id, fecha_hora_programada, fecha_hora_administrada, administrado_por, estado, notas) FROM stdin;
1	1	53	2026-01-04 10:40:00	2026-01-04 10:45:00	4	ADMINISTRADO	Dosis aplicada sin novedades.
2	1	53	2026-01-04 22:40:00	2026-01-04 22:45:00	4	ADMINISTRADO	Dosis aplicada sin novedades.
3	1	53	2026-01-05 10:40:00	2026-01-05 10:45:00	4	ADMINISTRADO	Dosis aplicada sin novedades.
4	1	53	2026-01-05 22:40:00	2026-01-05 22:45:00	4	ADMINISTRADO	Dosis aplicada sin novedades.
5	2	33	2026-01-13 11:40:00	2026-01-13 11:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
6	2	33	2026-01-13 23:40:00	2026-01-13 23:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
7	2	33	2026-01-14 11:40:00	2026-01-14 11:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
8	2	33	2026-01-14 23:40:00	2026-01-14 23:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
9	3	33	2026-02-04 10:40:00	2026-02-04 10:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
10	3	33	2026-02-04 22:40:00	2026-02-04 22:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
11	3	33	2026-02-05 10:40:00	2026-02-05 10:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
12	3	33	2026-02-05 22:40:00	2026-02-05 22:45:00	7	ADMINISTRADO	Dosis aplicada sin novedades.
13	4	53	2026-02-13 11:40:00	2026-02-13 11:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
14	4	53	2026-02-13 23:40:00	2026-02-13 23:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
15	4	53	2026-02-14 11:40:00	2026-02-14 11:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
16	4	53	2026-02-14 23:40:00	2026-02-14 23:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
17	5	53	2026-03-04 10:40:00	2026-03-04 10:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
18	5	53	2026-03-04 22:40:00	2026-03-04 22:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
19	5	53	2026-03-05 10:40:00	2026-03-05 10:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
20	5	53	2026-03-05 22:40:00	2026-03-05 22:45:00	8	ADMINISTRADO	Dosis aplicada sin novedades.
21	6	53	2026-03-13 11:40:00	2026-03-13 11:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
22	6	53	2026-03-13 23:40:00	2026-03-13 23:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
23	6	53	2026-03-14 11:40:00	2026-03-14 11:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
24	6	53	2026-03-14 23:40:00	2026-03-14 23:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
25	7	53	2026-04-04 10:40:00	2026-04-04 10:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
26	7	53	2026-04-04 22:40:00	2026-04-04 22:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
27	7	53	2026-04-05 10:40:00	2026-04-05 10:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
28	7	53	2026-04-05 22:40:00	2026-04-05 22:45:00	9	ADMINISTRADO	Dosis aplicada sin novedades.
29	8	53	2026-04-13 11:40:00	2026-04-13 11:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
30	8	53	2026-04-13 23:40:00	2026-04-13 23:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
31	8	53	2026-04-14 11:40:00	2026-04-14 11:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
32	8	53	2026-04-14 23:40:00	2026-04-14 23:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
33	9	53	2026-05-04 10:40:00	2026-05-04 10:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
34	9	53	2026-05-04 22:40:00	2026-05-04 22:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
35	9	53	2026-05-05 10:40:00	2026-05-05 10:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
36	9	53	2026-05-05 22:40:00	2026-05-05 22:45:00	10	ADMINISTRADO	Dosis aplicada sin novedades.
37	10	53	2026-05-13 11:40:00	2026-05-13 11:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
38	10	53	2026-05-13 23:40:00	2026-05-13 23:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
39	10	53	2026-05-14 11:40:00	2026-05-14 11:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
40	10	53	2026-05-14 23:40:00	2026-05-14 23:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
41	11	53	2026-06-04 10:40:00	2026-06-04 10:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
42	11	53	2026-06-04 22:40:00	2026-06-04 22:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
43	11	53	2026-06-05 10:40:00	2026-06-05 10:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
44	11	53	2026-06-05 22:40:00	2026-06-05 22:45:00	11	ADMINISTRADO	Dosis aplicada sin novedades.
45	12	53	2026-06-13 11:40:00	2026-06-13 11:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
46	12	53	2026-06-13 23:40:00	2026-06-13 23:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
47	12	53	2026-06-14 11:40:00	2026-06-14 11:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
48	12	53	2026-06-14 23:40:00	2026-06-14 23:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
49	13	53	2026-07-04 10:40:00	2026-07-04 10:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
50	13	53	2026-07-04 22:40:00	2026-07-04 22:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
51	13	53	2026-07-05 10:40:00	2026-07-05 10:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
52	13	53	2026-07-05 22:40:00	2026-07-05 22:45:00	12	ADMINISTRADO	Dosis aplicada sin novedades.
53	14	53	2026-07-13 11:40:00	2026-07-13 11:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
54	14	53	2026-07-13 23:40:00	2026-07-13 23:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
55	14	53	2026-07-14 11:40:00	2026-07-14 11:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
56	14	53	2026-07-14 23:40:00	2026-07-14 23:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
57	15	53	2026-08-04 10:40:00	2026-08-04 10:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
58	15	53	2026-08-04 22:40:00	2026-08-04 22:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
59	15	53	2026-08-05 10:40:00	2026-08-05 10:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
60	15	53	2026-08-05 22:40:00	2026-08-05 22:45:00	13	ADMINISTRADO	Dosis aplicada sin novedades.
61	16	53	2026-08-13 11:40:00	2026-08-13 11:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
62	16	53	2026-08-13 23:40:00	2026-08-13 23:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
63	16	53	2026-08-14 11:40:00	2026-08-14 11:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
64	16	53	2026-08-14 23:40:00	2026-08-14 23:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
65	17	53	2026-09-04 10:40:00	2026-09-04 10:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
66	17	53	2026-09-04 22:40:00	2026-09-04 22:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
67	17	53	2026-09-05 10:40:00	2026-09-05 10:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
68	17	53	2026-09-05 22:40:00	2026-09-05 22:45:00	14	ADMINISTRADO	Dosis aplicada sin novedades.
69	18	53	2026-09-13 11:40:00	2026-09-13 11:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
70	18	53	2026-09-13 23:40:00	2026-09-13 23:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
71	18	53	2026-09-14 11:40:00	2026-09-14 11:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
72	18	53	2026-09-14 23:40:00	2026-09-14 23:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
73	19	53	2026-10-04 10:40:00	2026-10-04 10:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
74	19	53	2026-10-04 22:40:00	2026-10-04 22:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
75	19	53	2026-10-05 10:40:00	2026-10-05 10:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
76	19	53	2026-10-05 22:40:00	2026-10-05 22:45:00	15	ADMINISTRADO	Dosis aplicada sin novedades.
77	20	68	2026-10-13 11:40:00	2026-10-13 11:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
78	20	68	2026-10-13 23:40:00	2026-10-13 23:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
79	20	68	2026-10-14 11:40:00	2026-10-14 11:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
80	20	68	2026-10-14 23:40:00	2026-10-14 23:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
81	21	68	2026-11-04 10:40:00	2026-11-04 10:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
82	21	68	2026-11-04 22:40:00	2026-11-04 22:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
83	21	68	2026-11-05 10:40:00	2026-11-05 10:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
84	21	68	2026-11-05 22:40:00	2026-11-05 22:45:00	2	ADMINISTRADO	Dosis aplicada sin novedades.
85	22	67	2026-11-12 11:40:00	2026-11-12 11:45:00	4	ADMINISTRADO	Dosis aplicada sin novedades.
86	22	67	2026-11-12 23:40:00	2026-11-16 18:59:49	6	ADMINISTRADO	\N
87	22	67	2026-11-13 11:40:00	2026-11-16 18:59:50	6	ADMINISTRADO	\N
88	22	67	2026-11-13 23:40:00	2026-11-16 19:00:15	6	ADMINISTRADO	\N
\.


--
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_compra (id_detallecompra, id_compra, id_insumo, cantidad, costo_unitario, fecha_vencimiento) FROM stdin;
1	1	1	16.00	29.50	2027-05-10
2	2	2	17.00	34.00	2027-05-20
3	3	3	18.00	38.50	2027-05-30
4	4	4	19.00	43.00	2027-06-09
5	5	5	20.00	47.50	2027-06-19
6	6	6	21.00	52.00	2027-06-29
7	7	7	22.00	56.50	2027-07-09
8	8	8	23.00	61.00	2027-07-19
9	9	9	24.00	65.50	2027-07-29
10	10	10	25.00	70.00	2027-08-08
11	11	11	26.00	74.50	2027-08-18
12	12	12	27.00	79.00	2027-08-28
13	13	13	28.00	83.50	2027-09-07
14	14	14	29.00	88.00	2027-09-17
15	15	15	30.00	92.50	2027-09-27
16	16	16	31.00	97.00	2027-10-07
17	17	17	32.00	101.50	2027-10-17
18	18	18	33.00	106.00	2027-10-27
19	19	19	34.00	110.50	2027-11-06
20	20	20	35.00	115.00	2027-11-16
21	21	21	36.00	119.50	2027-11-26
22	22	22	37.00	124.00	2027-12-06
23	23	23	38.00	128.50	2027-12-16
24	24	24	39.00	133.00	2027-12-26
25	25	25	15.00	137.50	2028-01-05
26	26	26	16.00	142.00	2028-01-15
27	27	27	17.00	146.50	2028-01-25
28	28	28	18.00	151.00	2028-02-04
29	29	29	19.00	155.50	2028-02-14
30	30	30	20.00	160.00	2028-02-24
31	31	31	21.00	164.50	2028-03-05
32	32	32	22.00	169.00	2028-03-15
33	33	33	23.00	173.50	2028-03-25
34	34	34	24.00	178.00	2028-04-04
35	35	35	25.00	182.50	2028-04-14
36	36	36	26.00	187.00	2028-04-24
37	37	37	27.00	191.50	2028-05-04
38	38	38	28.00	196.00	2028-05-14
39	39	39	29.00	200.50	2028-05-24
40	40	40	30.00	205.00	2028-06-03
41	41	41	31.00	209.50	2028-06-13
42	42	42	32.00	214.00	2028-06-23
43	43	43	33.00	218.50	2028-07-03
44	44	44	34.00	223.00	2028-07-13
45	45	45	35.00	227.50	2028-07-23
46	46	46	36.00	232.00	2028-08-02
47	47	47	37.00	236.50	2028-08-12
48	48	48	38.00	241.00	2028-08-22
49	49	49	39.00	245.50	2028-09-01
50	50	50	15.00	250.00	2028-09-11
\.


--
-- Data for Name: detalle_compras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_compras (id, costo_unitario, fecha_vencimiento, cantidad, id_compra, id_articulo, created_at, updated_at) FROM stdin;
1	125.00	2027-05-20	10.00	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	85.00	2028-01-15	4.00	2	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	5.00	2028-10-10	100.00	2	5	2026-11-01 18:17:19	2026-11-01 18:17:19
4	22.45	2027-09-21	20.00	3	2	2026-11-12 16:51:29	2026-11-12 16:51:29
5	50.78	2027-11-06	9.00	4	3	2026-11-12 16:51:29	2026-11-12 16:51:29
6	8.49	2027-09-21	37.00	5	4	2026-11-12 16:51:29	2026-11-12 16:51:29
7	34.29	2027-07-16	17.00	6	5	2026-11-12 16:51:29	2026-11-12 16:51:29
8	32.34	2027-07-08	35.00	7	7	2026-11-12 16:51:29	2026-11-12 16:51:29
9	53.82	2027-06-05	22.00	8	8	2026-11-12 16:51:29	2026-11-12 16:51:29
10	22.21	2027-06-29	34.00	9	9	2026-11-12 16:51:29	2026-11-12 16:51:29
\.


--
-- Data for Name: detalle_donacion_insumo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_donacion_insumo (id_detalle, id_donacion, id_articulo, cantidad, fecha_vencimiento) FROM stdin;
1	52	2	6.00	2027-07-07
2	53	3	7.00	2027-07-15
3	54	4	8.00	2027-07-23
4	55	5	9.00	2027-07-31
5	56	6	10.00	2027-08-08
6	57	7	11.00	2027-08-16
7	58	8	12.00	2027-08-24
8	59	9	13.00	2027-09-01
9	60	10	14.00	2027-09-09
10	61	11	15.00	2027-09-17
11	62	12	16.00	2027-09-25
12	63	13	17.00	2027-10-03
13	64	14	18.00	2027-10-11
14	65	15	19.00	2027-10-19
15	66	16	20.00	2027-10-27
16	67	17	21.00	2027-11-04
17	68	18	22.00	2027-11-12
18	69	19	23.00	2027-11-20
19	70	20	24.00	2027-11-28
20	71	21	5.00	2027-12-06
21	72	22	6.00	2027-12-14
22	73	23	7.00	2027-12-22
23	74	24	8.00	2027-12-30
24	75	25	9.00	2028-01-07
25	76	26	10.00	2028-01-15
26	77	27	11.00	2028-01-23
27	78	28	12.00	2028-01-31
28	79	29	13.00	2028-02-08
29	80	30	14.00	2028-02-16
30	51	31	15.00	2028-02-24
31	52	32	16.00	2028-03-03
32	53	33	17.00	2028-03-11
33	54	34	18.00	2028-03-19
34	55	35	19.00	2028-03-27
35	56	36	20.00	2028-04-04
36	57	37	21.00	2028-04-12
37	58	38	22.00	2028-04-20
38	59	39	23.00	2028-04-28
39	60	40	24.00	2028-05-06
40	61	41	5.00	2028-05-14
41	62	42	6.00	2028-05-22
42	63	43	7.00	2028-05-30
43	64	44	8.00	2028-06-07
44	65	45	9.00	2028-06-15
45	66	46	10.00	2028-06-23
46	67	47	11.00	2028-07-01
47	68	48	12.00	2028-07-09
48	69	49	13.00	2028-07-17
49	70	50	14.00	2028-07-25
50	71	1	15.00	2028-08-02
\.


--
-- Data for Name: detalle_donacion_insumos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_donacion_insumos (id, fecha_vencimiento, cantidad, id_donacion, id_articulo, created_at, updated_at) FROM stdin;
1	2027-06-30	20.00	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	2027-12-31	5.00	3	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	2028-05-15	100.00	3	5	2026-11-01 18:17:19	2026-11-01 18:17:19
5	2027-07-07	6.00	52	2	2026-11-04 04:15:13	2026-11-04 04:15:13
6	2027-07-15	7.00	53	3	2026-11-04 04:15:13	2026-11-04 04:15:13
7	2027-07-23	8.00	54	4	2026-11-04 04:15:13	2026-11-04 04:15:13
8	2027-07-31	9.00	55	5	2026-11-04 04:15:13	2026-11-04 04:15:13
9	2027-08-08	10.00	56	6	2026-11-04 04:15:13	2026-11-04 04:15:13
10	2027-08-16	11.00	57	7	2026-11-04 04:15:13	2026-11-04 04:15:13
11	2027-08-24	12.00	58	8	2026-11-04 04:15:13	2026-11-04 04:15:13
12	2027-09-01	13.00	59	9	2026-11-04 04:15:13	2026-11-04 04:15:13
13	2027-09-09	14.00	60	10	2026-11-04 04:15:13	2026-11-04 04:15:13
14	2027-09-17	15.00	61	11	2026-11-04 04:15:13	2026-11-04 04:15:13
15	2027-09-25	16.00	62	12	2026-11-04 04:15:13	2026-11-04 04:15:13
16	2027-10-03	17.00	63	13	2026-11-04 04:15:13	2026-11-04 04:15:13
17	2027-10-11	18.00	64	14	2026-11-04 04:15:13	2026-11-04 04:15:13
18	2027-10-19	19.00	65	15	2026-11-04 04:15:13	2026-11-04 04:15:13
19	2027-10-27	20.00	66	16	2026-11-04 04:15:13	2026-11-04 04:15:13
20	2027-11-04	21.00	67	17	2026-11-04 04:15:13	2026-11-04 04:15:13
21	2027-11-12	22.00	68	18	2026-11-04 04:15:13	2026-11-04 04:15:13
22	2027-11-20	23.00	69	19	2026-11-04 04:15:13	2026-11-04 04:15:13
23	2027-11-28	24.00	70	20	2026-11-04 04:15:13	2026-11-04 04:15:13
24	2027-12-06	5.00	71	21	2026-11-04 04:15:13	2026-11-04 04:15:13
25	2027-12-14	6.00	72	22	2026-11-04 04:15:13	2026-11-04 04:15:13
26	2027-12-22	7.00	73	23	2026-11-04 04:15:13	2026-11-04 04:15:13
27	2027-12-30	8.00	74	24	2026-11-04 04:15:13	2026-11-04 04:15:13
28	2028-01-07	9.00	75	25	2026-11-04 04:15:13	2026-11-04 04:15:13
29	2028-01-15	10.00	76	26	2026-11-04 04:15:13	2026-11-04 04:15:13
30	2028-01-23	11.00	77	27	2026-11-04 04:15:13	2026-11-04 04:15:13
31	2028-01-31	12.00	78	28	2026-11-04 04:15:13	2026-11-04 04:15:13
32	2028-02-08	13.00	79	29	2026-11-04 04:15:13	2026-11-04 04:15:13
33	2028-02-16	14.00	80	30	2026-11-04 04:15:13	2026-11-04 04:15:13
34	2028-02-24	15.00	51	31	2026-11-04 04:15:13	2026-11-04 04:15:13
35	2028-03-03	16.00	52	32	2026-11-04 04:15:13	2026-11-04 04:15:13
36	2028-03-11	17.00	53	33	2026-11-04 04:15:13	2026-11-04 04:15:13
37	2028-03-19	18.00	54	34	2026-11-04 04:15:13	2026-11-04 04:15:13
38	2028-03-27	19.00	55	35	2026-11-04 04:15:13	2026-11-04 04:15:13
39	2028-04-04	20.00	56	36	2026-11-04 04:15:13	2026-11-04 04:15:13
40	2028-04-12	21.00	57	37	2026-11-04 04:15:13	2026-11-04 04:15:13
41	2028-04-20	22.00	58	38	2026-11-04 04:15:13	2026-11-04 04:15:13
42	2028-04-28	23.00	59	39	2026-11-04 04:15:13	2026-11-04 04:15:13
43	2028-05-06	24.00	60	40	2026-11-04 04:15:13	2026-11-04 04:15:13
44	2028-05-14	5.00	61	41	2026-11-04 04:15:13	2026-11-04 04:15:13
45	2028-05-22	6.00	62	42	2026-11-04 04:15:13	2026-11-04 04:15:13
46	2028-05-30	7.00	63	43	2026-11-04 04:15:13	2026-11-04 04:15:13
47	2028-06-07	8.00	64	44	2026-11-04 04:15:13	2026-11-04 04:15:13
48	2028-06-15	9.00	65	45	2026-11-04 04:15:13	2026-11-04 04:15:13
49	2028-06-23	10.00	66	46	2026-11-04 04:15:13	2026-11-04 04:15:13
50	2028-07-01	11.00	67	47	2026-11-04 04:15:13	2026-11-04 04:15:13
51	2028-07-09	12.00	68	48	2026-11-04 04:15:13	2026-11-04 04:15:13
52	2028-07-17	13.00	69	49	2026-11-04 04:15:13	2026-11-04 04:15:13
53	2028-07-25	14.00	70	50	2026-11-04 04:15:13	2026-11-04 04:15:13
54	2028-08-02	15.00	71	1	2026-11-04 04:15:13	2026-11-04 04:15:13
\.


--
-- Data for Name: detalle_facturas_legales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_facturas_legales (id, factura_id, concepto, cantidad, precio_unitario, subtotal, referencia_tipo, referencia_id) FROM stdin;
1	1	Vacunación antirrábica y carnet sanitario	1.00	85.00	85.00	CONSULTA_MEDICA	\N
2	2	Desparasitación interna y externa	2.00	65.00	130.00	CONSULTA_MEDICA	\N
3	3	Esterilización quirúrgica controlada	1.00	350.00	350.00	CONSULTA_MEDICA	\N
4	4	Curación y tratamiento dermatológico	2.00	140.00	280.00	CONSULTA_MEDICA	\N
5	5	Desparasitación interna y externa	1.00	65.00	65.00	CONSULTA_MEDICA	\N
6	6	Esterilización quirúrgica controlada	2.00	350.00	700.00	CONSULTA_MEDICA	\N
7	7	Curación y tratamiento dermatológico	1.00	140.00	140.00	CONSULTA_MEDICA	\N
8	8	Consulta veterinaria general y valoración	2.00	120.00	240.00	CONSULTA_MEDICA	\N
9	9	Esterilización quirúrgica controlada	1.00	350.00	350.00	CONSULTA_MEDICA	\N
10	10	Curación y tratamiento dermatológico	2.00	140.00	280.00	CONSULTA_MEDICA	\N
11	11	Consulta veterinaria general y valoración	1.00	120.00	120.00	CONSULTA_MEDICA	\N
12	12	Vacunación antirrábica y carnet sanitario	2.00	85.00	170.00	CONSULTA_MEDICA	\N
13	13	Curación y tratamiento dermatológico	1.00	140.00	140.00	CONSULTA_MEDICA	\N
14	14	Consulta veterinaria general y valoración	2.00	120.00	240.00	CONSULTA_MEDICA	\N
15	15	Vacunación antirrábica y carnet sanitario	1.00	85.00	85.00	CONSULTA_MEDICA	\N
16	16	Desparasitación interna y externa	2.00	65.00	130.00	CONSULTA_MEDICA	\N
17	17	Consulta veterinaria general y valoración	1.00	120.00	120.00	CONSULTA_MEDICA	\N
18	18	Vacunación antirrábica y carnet sanitario	2.00	85.00	170.00	CONSULTA_MEDICA	\N
19	19	Desparasitación interna y externa	1.00	65.00	65.00	CONSULTA_MEDICA	\N
20	20	Esterilización quirúrgica controlada	2.00	350.00	700.00	CONSULTA_MEDICA	\N
21	21	Vacunación antirrábica y carnet sanitario	1.00	85.00	85.00	CONSULTA_MEDICA	\N
22	22	Desparasitación interna y externa	2.00	65.00	130.00	CONSULTA_MEDICA	\N
23	23	Esterilización quirúrgica controlada	1.00	350.00	350.00	CONSULTA_MEDICA	\N
24	24	Curación y tratamiento dermatológico	2.00	140.00	280.00	CONSULTA_MEDICA	\N
25	25	Desparasitación interna y externa	1.00	65.00	65.00	CONSULTA_MEDICA	\N
26	26	Esterilización quirúrgica controlada	2.00	350.00	700.00	CONSULTA_MEDICA	\N
27	27	Curación y tratamiento dermatológico	1.00	140.00	140.00	CONSULTA_MEDICA	\N
28	28	Consulta veterinaria general y valoración	2.00	120.00	240.00	CONSULTA_MEDICA	\N
29	29	Esterilización quirúrgica controlada	1.00	350.00	350.00	CONSULTA_MEDICA	\N
30	30	Curación y tratamiento dermatológico	2.00	140.00	280.00	CONSULTA_MEDICA	\N
31	31	Consulta veterinaria general y valoración	1.00	120.00	120.00	CONSULTA_MEDICA	\N
32	32	Vacunación antirrábica y carnet sanitario	2.00	85.00	170.00	CONSULTA_MEDICA	\N
33	33	Curación y tratamiento dermatológico	1.00	140.00	140.00	CONSULTA_MEDICA	\N
34	34	Consulta veterinaria general y valoración	2.00	120.00	240.00	CONSULTA_MEDICA	\N
35	35	Vacunación antirrábica y carnet sanitario	1.00	85.00	85.00	CONSULTA_MEDICA	\N
36	36	Desparasitación interna y externa	2.00	65.00	130.00	CONSULTA_MEDICA	\N
37	37	Consulta veterinaria general y valoración	1.00	120.00	120.00	CONSULTA_MEDICA	\N
38	38	Vacunación antirrábica y carnet sanitario	2.00	85.00	170.00	CONSULTA_MEDICA	\N
39	39	Desparasitación interna y externa	1.00	65.00	65.00	CONSULTA_MEDICA	\N
40	40	Esterilización quirúrgica controlada	2.00	350.00	700.00	CONSULTA_MEDICA	\N
41	41	Vacunación antirrábica y carnet sanitario	1.00	85.00	85.00	CONSULTA_MEDICA	\N
42	42	Desparasitación interna y externa	2.00	65.00	130.00	CONSULTA_MEDICA	\N
43	43	Esterilización quirúrgica controlada	1.00	350.00	350.00	CONSULTA_MEDICA	\N
44	44	Curación y tratamiento dermatológico	2.00	140.00	280.00	CONSULTA_MEDICA	\N
\.


--
-- Data for Name: detalle_salida; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_salida (id_detallesalida, id_salida, id_articulo, cantidad) FROM stdin;
1	1	1	2.00
2	2	2	3.00
3	3	3	1.00
4	4	4	2.00
5	5	5	3.00
6	6	6	1.00
7	7	7	2.00
8	8	8	3.00
9	9	9	1.00
10	10	10	2.00
11	11	11	3.00
12	12	12	1.00
13	13	13	2.00
14	14	14	3.00
15	15	15	1.00
16	16	16	2.00
17	17	17	3.00
18	18	18	1.00
19	19	19	2.00
20	20	20	3.00
21	21	21	1.00
22	22	22	2.00
23	23	23	3.00
24	24	24	1.00
25	25	25	2.00
26	26	26	3.00
27	27	27	1.00
28	28	28	2.00
29	29	29	3.00
30	30	30	1.00
31	31	31	2.00
32	32	32	3.00
33	33	33	1.00
34	34	34	2.00
35	35	35	3.00
36	36	36	1.00
37	37	37	2.00
38	38	38	3.00
39	39	39	1.00
40	40	40	2.00
41	41	41	3.00
42	42	42	1.00
43	43	43	2.00
44	44	44	3.00
45	45	45	1.00
46	46	46	2.00
47	47	47	3.00
48	48	48	1.00
49	49	49	2.00
50	50	50	3.00
\.


--
-- Data for Name: detalle_salida_lotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_salida_lotes (id, id_detalle_salida, id_inventario_lote, cantidad, created_at, updated_at) FROM stdin;
1	1	2	5.00	2026-11-12 16:51:29	2026-11-12 16:51:29
2	2	4	2.00	2026-11-12 16:51:29	2026-11-12 16:51:29
3	3	5	2.00	2026-11-12 16:51:29	2026-11-12 16:51:29
4	4	6	5.00	2026-11-12 16:51:29	2026-11-12 16:51:29
5	5	7	3.00	2026-11-12 16:51:29	2026-11-12 16:51:29
6	6	8	2.00	2026-11-12 16:51:29	2026-11-12 16:51:29
7	7	9	3.00	2026-11-12 16:51:29	2026-11-12 16:51:29
8	8	10	3.00	2026-11-12 16:51:29	2026-11-12 16:51:29
9	9	12	2.00	2026-11-12 16:51:29	2026-11-12 16:51:29
10	10	13	4.00	2026-11-12 16:51:29	2026-11-12 16:51:29
\.


--
-- Data for Name: detalle_salidas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_salidas (id, cantidad, id_salida, id_articulo, created_at, updated_at) FROM stdin;
1	3.00	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	1.00	2	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	10.00	2	5	2026-11-01 18:17:19	2026-11-01 18:17:19
4	2.00	3	4	2026-11-01 18:17:19	2026-11-01 18:17:19
5	2.00	4	3	2026-11-12 16:51:29	2026-11-12 16:51:29
6	4.00	5	4	2026-11-12 16:51:29	2026-11-12 16:51:29
7	2.00	6	5	2026-11-12 16:51:29	2026-11-12 16:51:29
8	4.00	7	7	2026-11-12 16:51:29	2026-11-12 16:51:29
9	4.00	8	8	2026-11-12 16:51:29	2026-11-12 16:51:29
10	3.00	9	9	2026-11-12 16:51:29	2026-11-12 16:51:29
11	1.00	11	4	2026-11-21 10:44:30	2026-11-21 10:44:30
\.


--
-- Data for Name: donacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donacion (id_donacion, id_donante, id_usuario, tipo_aporte, fecha, created_at, updated_at) FROM stdin;
1	2	11	1	2026-07-05	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	3	12	1	2026-07-06	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	4	13	1	2026-07-07	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	5	14	1	2026-07-08	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	6	10	1	2026-07-09	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	7	11	1	2026-07-10	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	8	12	1	2026-07-11	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	9	13	1	2026-07-12	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	10	14	1	2026-07-13	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	11	10	1	2026-07-14	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	12	11	1	2026-07-15	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	13	12	1	2026-07-16	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	14	13	1	2026-07-17	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	15	14	1	2026-07-18	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	16	10	1	2026-07-19	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	17	11	1	2026-07-20	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	18	12	1	2026-07-21	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	19	13	1	2026-07-22	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	20	14	1	2026-07-23	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	21	10	1	2026-07-24	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	22	11	1	2026-07-25	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	23	12	1	2026-07-26	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	24	13	1	2026-07-27	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	25	14	1	2026-07-28	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	26	10	1	2026-07-29	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	27	11	1	2026-07-30	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	28	12	1	2026-07-31	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	29	13	1	2026-08-01	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	30	14	1	2026-08-02	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	31	10	1	2026-08-03	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	32	11	1	2026-08-04	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	33	12	1	2026-08-05	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	34	13	1	2026-08-06	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	35	14	1	2026-08-07	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	36	10	1	2026-08-08	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	37	11	1	2026-08-09	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	38	12	1	2026-08-10	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	39	13	1	2026-08-11	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	40	14	1	2026-08-12	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	41	10	1	2026-08-13	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	42	11	1	2026-08-14	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	43	12	1	2026-08-15	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	44	13	1	2026-08-16	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	45	14	1	2026-08-17	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	46	10	1	2026-08-18	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	47	11	1	2026-08-19	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	48	12	1	2026-08-20	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	49	13	1	2026-08-21	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	50	14	1	2026-08-22	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	1	10	1	2026-08-23	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
51	2	11	5	2026-08-24	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
52	3	12	6	2026-08-25	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
53	4	13	7	2026-08-26	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
54	5	14	8	2026-08-27	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
55	6	10	9	2026-08-28	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
56	7	11	10	2026-08-29	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
57	8	12	11	2026-08-30	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
58	9	13	12	2026-08-31	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
59	10	14	13	2026-09-01	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
60	11	10	14	2026-09-02	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
61	12	11	15	2026-09-03	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
62	13	12	16	2026-09-04	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
63	14	13	17	2026-09-05	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
64	15	14	18	2026-09-06	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
65	16	10	19	2026-09-07	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
66	17	11	20	2026-09-08	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
67	18	12	21	2026-09-09	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
68	19	13	22	2026-09-10	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
69	20	14	23	2026-09-11	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
70	21	10	24	2026-09-12	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
71	22	11	25	2026-09-13	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
72	23	12	26	2026-09-14	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
73	24	13	27	2026-09-15	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
74	25	14	28	2026-09-16	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
75	26	10	29	2026-09-17	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
76	27	11	30	2026-09-18	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
77	28	12	31	2026-09-19	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
78	29	13	32	2026-09-20	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
79	30	14	33	2026-09-21	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
80	31	10	34	2026-09-22	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
81	1	1	1	2026-10-19	2026-11-02 03:36:39	2026-11-02 03:36:39
82	2	1	1	2026-10-21	2026-11-02 03:36:39	2026-11-02 03:36:39
83	3	1	1	2026-10-23	2026-11-02 03:36:39	2026-11-02 03:36:39
84	4	1	1	2026-10-25	2026-11-02 03:36:39	2026-11-02 03:36:39
85	5	1	1	2026-10-27	2026-11-02 03:36:39	2026-11-02 03:36:39
86	6	1	1	2026-10-29	2026-11-02 03:36:39	2026-11-02 03:36:39
87	7	1	1	2026-10-31	2026-11-02 03:36:39	2026-11-02 03:36:39
88	8	1	1	2026-11-01	2026-11-02 03:36:39	2026-11-02 03:36:39
89	1	1	1	2026-10-30	2026-11-02 03:40:36	2026-11-02 03:40:36
90	1	1	1	2026-11-01	2026-11-02 03:40:36	2026-11-02 03:40:36
91	52	1	1	2026-11-04	2026-11-04 03:38:01	2026-11-04 03:38:01
92	53	6	1	2026-11-04	2026-11-04 03:52:55	2026-11-04 03:52:55
93	54	51	1	2026-11-16	2026-11-16 20:24:31	2026-11-16 20:24:31
94	59	6	1	2026-11-19	2026-11-19 14:46:51	2026-11-19 14:46:51
\.


--
-- Data for Name: donacions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donacions (id, tipo_aporte, fecha, id_donante, id_usuario, created_at, updated_at, numero_documento) FROM stdin;
1	Alimento Seco	2026-01-10	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
2	Efectivo / Transferencia	2026-01-20	3	5	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
3	Insumos Médicos	2026-02-05	4	2	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
4	Efectivo / Transferencia	2026-02-18	2	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
5	Mobiliario / Accesorios	2026-03-05	5	5	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
6	Insumos	2026-07-10	7	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00006
7	Insumos	2026-07-11	8	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00007
8	Insumos	2026-07-12	9	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00008
9	Insumos	2026-07-13	10	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00009
10	Insumos	2026-07-14	11	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00010
11	Insumos	2026-07-15	12	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00011
12	Insumos	2026-07-16	13	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00012
13	Insumos	2026-07-17	14	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00013
14	Insumos	2026-07-18	15	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00014
15	Insumos	2026-07-19	16	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00015
16	Insumos	2026-07-20	17	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00016
17	Insumos	2026-07-21	18	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00017
18	Insumos	2026-07-22	19	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00018
19	Insumos	2026-07-23	20	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00019
20	Insumos	2026-07-24	21	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00020
21	Insumos	2026-07-25	22	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00021
22	Insumos	2026-07-26	23	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00022
23	Insumos	2026-07-27	24	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00023
24	Insumos	2026-07-28	25	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00024
25	Insumos	2026-07-29	26	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00025
26	Insumos	2026-07-30	27	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00026
27	Insumos	2026-07-31	28	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00027
28	Insumos	2026-08-01	29	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00028
29	Insumos	2026-08-02	30	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00029
30	Insumos	2026-08-03	31	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00030
31	Insumos	2026-08-04	32	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00031
32	Insumos	2026-08-05	33	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00032
33	Insumos	2026-08-06	34	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00033
34	Insumos	2026-08-07	35	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00034
35	Insumos	2026-08-08	36	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00035
36	Insumos	2026-08-09	37	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00036
37	Insumos	2026-08-10	38	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00037
38	Insumos	2026-08-11	39	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00038
39	Insumos	2026-08-12	40	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00039
40	Insumos	2026-08-13	41	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00040
41	Insumos	2026-08-14	42	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00041
42	Insumos	2026-08-15	43	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00042
43	Insumos	2026-08-16	44	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00043
44	Insumos	2026-08-17	45	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00044
45	Insumos	2026-08-18	46	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00045
46	Insumos	2026-08-19	47	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00046
47	Insumos	2026-08-20	48	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00047
48	Insumos	2026-08-21	49	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00048
49	Insumos	2026-08-22	50	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00049
50	Insumos	2026-08-23	1	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00050
51	Insumos	2026-08-24	2	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00051
52	Insumos	2026-08-25	3	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00052
53	Insumos	2026-08-26	4	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00053
54	Insumos	2026-08-27	5	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00054
55	Insumos	2026-08-28	6	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00055
56	Insumos	2026-08-29	7	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00056
57	Insumos	2026-08-30	8	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00057
58	Insumos	2026-08-31	9	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00058
59	Insumos	2026-09-01	10	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00059
60	Insumos	2026-09-02	11	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00060
61	Insumos	2026-09-03	12	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00061
62	Insumos	2026-09-04	13	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00062
63	Insumos	2026-09-05	14	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00063
64	Insumos	2026-09-06	15	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00064
65	Insumos	2026-09-07	16	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00065
66	Insumos	2026-09-08	17	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00066
67	Insumos	2026-09-09	18	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00067
68	Insumos	2026-09-10	19	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00068
69	Insumos	2026-09-11	20	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00069
70	Insumos	2026-09-12	21	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00070
71	Insumos	2026-09-13	22	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00071
72	Insumos	2026-09-14	23	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00072
73	Insumos	2026-09-15	24	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00073
74	Insumos	2026-09-16	25	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00074
75	Insumos	2026-09-17	26	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00075
76	Insumos	2026-09-18	27	11	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00076
77	Insumos	2026-09-19	28	12	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00077
78	Insumos	2026-09-20	29	13	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00078
79	Insumos	2026-09-21	30	14	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00079
80	Insumos	2026-09-22	31	10	2026-11-01 14:00:13	2026-11-01 14:00:13	DON-00080
81	Efectivo / Transferencia	2026-10-19	1	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-001
82	Efectivo / Transferencia	2026-10-21	2	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-002
83	Efectivo / Transferencia	2026-10-23	3	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-003
84	Efectivo / Transferencia	2026-10-25	4	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-004
85	Efectivo / Transferencia	2026-10-27	5	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-005
86	Efectivo / Transferencia	2026-10-29	6	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-006
87	Efectivo / Transferencia	2026-10-31	7	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-007
88	Efectivo / Transferencia	2026-11-01	8	1	2026-11-02 03:36:39	2026-11-02 03:36:39	CAJA-EFEC-2026-008
89	Efectivo / Transferencia	2026-10-30	1	1	2026-11-02 03:40:36	2026-11-02 03:40:36	STK-QR-2026-901
90	Efectivo / Transferencia	2026-11-01	1	1	2026-11-02 03:40:36	2026-11-02 03:40:36	STK-QR-2026-902
91	Dinero	2026-11-04	52	1	2026-11-04 03:38:01	2026-11-04 03:38:01	TXN-0BUR3TSQTB
92	Dinero	2026-11-04	53	6	2026-11-04 03:52:55	2026-11-04 03:52:55	TXN-NI5RJ3IPBO
93	Dinero	2026-11-16	54	51	2026-11-16 20:24:31	2026-11-16 20:24:31	DON-WEB-20261116202431-694
94	Dinero	2026-11-19	59	6	2026-11-19 14:46:51	2026-11-19 14:46:51	TXN-8FPOVSA2EM
\.


--
-- Data for Name: donante; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donante (id_donante, nombre, tipo_persona, telefono, created_at, updated_at) FROM stdin;
1	Fundación Amor por los Animales Bolivia	Jurídica	67881238	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	Grupo Empresarial del Oriente	Jurídica	78961257	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	Clínica Veterinaria Santa Cruz Norte	Jurídica	62569630	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	Supermercados Fidalga Sucursal Equipetrol	Jurídica	73970645	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	Colegio Médico Veterinario de Santa Cruz	Jurídica	64092338	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	Club de Leones Santa Cruz Centro	Jurídica	75396806	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	Asociación de Damas Voluntarias Solidarias	Jurídica	77789845	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	Inmobiliaria y Constructora Las Palmas	Jurídica	64310538	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	Farmacias Chávez RSE	Jurídica	65783337	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	Restaurante El Aljibe Solidario	Jurídica	78779907	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	Miguel Ángel Peña Hurtado	Natural	71936954	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	Gabriela Vargas Cuéllar	Natural	72827468	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	Mónica Añez Ugarte	Natural	61537724	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	Verónica Saucedo Mendoza	Natural	67643462	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	Óscar Vargas Suárez	Natural	78836112	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	Diego Armando Castedo Zabala	Natural	69222499	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	Óscar Aguilera Aguilera	Natural	62719171	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	Jessica Chávez Suárez	Natural	75715694	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	Álvaro Dorado Mendoza	Natural	66063775	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	Sofía Vargas Montaño	Natural	69447504	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	Guillermo Castedo Aguilera	Natural	64876720	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	Daniela Mamani Mamani	Natural	69579456	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	Adriana Soliz Hurtado	Natural	61314241	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	Marcelo Añez Ugarte	Natural	68916657	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	Valeria Ugarte Ribera	Natural	67529130	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	Alejandro Pinto Castedo	Natural	67952988	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	Gabriela Zabala Añez	Natural	72978578	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	Silvia Ribera Paz	Natural	65419918	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	Alejandra Ugarte Chávez	Natural	72484584	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	Carla Mariana Montaño Antelo	Natural	79721936	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	Roberto Mamani Condori	Natural	68815928	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	Bruno Chávez Salazar	Natural	74432271	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	Víctor Hugo Antelo Mamani	Natural	69710532	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	Óscar Vargas Zabala	Natural	77167439	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	Alejandro Zabala Condori	Natural	76187728	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	Valeria Flores Torrico	Natural	67547506	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	Luis Fernando Justiniano Ribera	Natural	69514563	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	Diana Suárez Mendoza	Natural	67726676	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	Gabriela Añez Chávez	Natural	66464362	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	Leonardo Zabala Ugarte	Natural	65605296	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	Diego Armando Aguilera Barba	Natural	73406809	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	Alejandra Flores Cuéllar	Natural	71006940	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	Gabriela Dorado Ugarte	Natural	74446858	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	David Román Soliz	Natural	68757032	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	Lucas Román Gutiérrez	Natural	61104012	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	Carla Mariana Gutiérrez Mercado	Natural	66694971	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	Gabriel Condori Pinto	Natural	79502229	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	Diego Armando Saucedo Vargas	Natural	77804742	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	Rodrigo Dorado Rojas	Natural	75192692	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	Diego Armando Añez Suárez	Natural	71929347	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
52	María Rodríguez	Natural	71234567	2026-11-04 03:38:01	2026-11-04 03:38:01
53	ronald jimenez chura	Natural	69039375	2026-11-04 03:52:55	2026-11-04 03:52:55
54	angel	Natural	64447731	2026-11-16 20:24:31	2026-11-16 20:24:31
59	perez	Natural	78456248	2026-11-19 14:46:51	2026-11-19 14:46:51
\.


--
-- Data for Name: donantes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donantes (id, nombre, telefono, tipo_persona, created_at, updated_at) FROM stdin;
1	Empresa Avícola Sofía	70019283	Jurídica	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Fundación Bienestar Animal	33492019	Jurídica	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Roberto Pinto Saucedo	71390219	Natural	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Farmacia Chávez S.A.	800102030	Jurídica	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Gabriela Arteaga	76019283	Natural	2026-11-01 18:17:19	2026-11-01 18:17:19
6	Club de Leones Santa Cruz Centro	75396806	Jurídica	2026-11-01 14:00:13	2026-11-01 14:00:13
7	Asociación de Damas Voluntarias Solidarias	77789845	Jurídica	2026-11-01 14:00:13	2026-11-01 14:00:13
8	Inmobiliaria y Constructora Las Palmas	64310538	Jurídica	2026-11-01 14:00:13	2026-11-01 14:00:13
9	Farmacias Chávez RSE	65783337	Jurídica	2026-11-01 14:00:13	2026-11-01 14:00:13
10	Restaurante El Aljibe Solidario	78779907	Jurídica	2026-11-01 14:00:13	2026-11-01 14:00:13
11	Miguel Ángel Peña Hurtado	71936954	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
12	Gabriela Vargas Cuéllar	72827468	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
13	Mónica Añez Ugarte	61537724	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
14	Verónica Saucedo Mendoza	67643462	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
15	Óscar Vargas Suárez	78836112	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
16	Diego Armando Castedo Zabala	69222499	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
17	Óscar Aguilera Aguilera	62719171	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
18	Jessica Chávez Suárez	75715694	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
19	Álvaro Dorado Mendoza	66063775	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
20	Sofía Vargas Montaño	69447504	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
21	Guillermo Castedo Aguilera	64876720	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
22	Daniela Mamani Mamani	69579456	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
23	Adriana Soliz Hurtado	61314241	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
24	Marcelo Añez Ugarte	68916657	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
25	Valeria Ugarte Ribera	67529130	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
26	Alejandro Pinto Castedo	67952988	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
27	Gabriela Zabala Añez	72978578	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
28	Silvia Ribera Paz	65419918	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
29	Alejandra Ugarte Chávez	72484584	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
30	Carla Mariana Montaño Antelo	79721936	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
31	Roberto Mamani Condori	68815928	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
32	Bruno Chávez Salazar	74432271	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
33	Víctor Hugo Antelo Mamani	69710532	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
34	Óscar Vargas Zabala	77167439	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
35	Alejandro Zabala Condori	76187728	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
36	Valeria Flores Torrico	67547506	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
37	Luis Fernando Justiniano Ribera	69514563	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
38	Diana Suárez Mendoza	67726676	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
39	Gabriela Añez Chávez	66464362	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
40	Leonardo Zabala Ugarte	65605296	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
41	Diego Armando Aguilera Barba	73406809	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
42	Alejandra Flores Cuéllar	71006940	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
43	Gabriela Dorado Ugarte	74446858	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
44	David Román Soliz	68757032	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
45	Lucas Román Gutiérrez	61104012	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
46	Carla Mariana Gutiérrez Mercado	66694971	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
47	Gabriel Condori Pinto	79502229	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
48	Diego Armando Saucedo Vargas	77804742	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
49	Rodrigo Dorado Rojas	75192692	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
50	Diego Armando Añez Suárez	71929347	Natural	2026-11-01 14:00:13	2026-11-01 14:00:13
52	María Rodríguez	71234567	Natural	2026-11-04 03:38:01	2026-11-04 03:38:01
53	ronald jimenez chura	69039375	Natural	2026-11-04 03:52:55	2026-11-04 03:52:55
54	angel	64447731	Natural	2026-11-16 20:24:31	2026-11-16 20:24:31
59	perez	78456248	Natural	2026-11-19 14:46:51	2026-11-19 14:46:51
\.


--
-- Data for Name: dosificaciones_fiscales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dosificaciones_fiscales (id, nit_emisor, numero_autorizacion, llave_dosificacion, numero_inicial, numero_final, correlativo_actual, fecha_limite_emision, leyenda_tributaria, activa, created_by, created_at, updated_at) FROM stdin;
1	1020304021	290400202601	eyJpdiI6Im5QYUdyWk5MYS9HczI4ZzVqT3FPVXc9PSIsInZhbHVlIjoieEpEcHJtVWNaNmxnRkhUTG5KV0o3V2ZSUWVTdTRTajh6OW1TZFBnOXBoaz0iLCJtYWMiOiIwN2I2YjZkZDkxYTVmMTc5MDk4NTQ1N2ZhYjdiMTQwYWU1MDU1Y2RhNTM1MjkzMjJkN2JkZmQ1NmY3MjJkOTc2IiwidGFnIjoiIn0=	1	500	25	2026-06-30	Ley N° 453: Tienes derecho a recibir información sobre las características y contenidos de los servicios que utilices.	f	6	2026-01-02 08:30:00	2026-06-30 18:00:00
2	1020304021	290400202602	eyJpdiI6IjRSQldxNjF1Q0tCN0thb09mUDZjK0E9PSIsInZhbHVlIjoiaWYyVVNMYzNJYlVPR1FQRDl2TEhGNWN3VklUUEM4NXIrMHV0V3VyVWNHVT0iLCJtYWMiOiI1NWJhMTk2NGJlNTQyNTc2YTBjMjRlOGIxZWE2OTQ4ZmFlYWI3YTFlMzZjM2E5NTA1MWY0ZmNmZTIxMjQ5YWEyIiwidGFnIjoiIn0=	501	1500	521	2026-12-31	Ley N° 453: Tienes derecho a recibir información sobre las características y contenidos de los servicios que utilices.	t	6	2026-07-01 08:15:00	2026-11-12 16:00:00
\.


--
-- Data for Name: evaluacion_idoneidad; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.evaluacion_idoneidad (id_evaluacion, id_interesado, puntaje_vivienda, puntaje_compromiso, puntaje_total, resultado, observaciones, created_at) FROM stdin;
1	1	42	43	85	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 85/100).	2026-11-01 14:00:12.780728
2	2	44	46	90	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 90/100).	2026-11-01 14:00:12.780728
3	3	46	49	95	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 95/100).	2026-11-01 14:00:12.780728
4	4	48	41	89	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 89/100).	2026-11-01 14:00:12.780728
5	5	50	44	94	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 94/100).	2026-11-01 14:00:12.780728
6	6	41	47	88	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 88/100).	2026-11-01 14:00:12.780728
7	7	43	50	93	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 93/100).	2026-11-01 14:00:12.780728
8	8	45	42	87	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 87/100).	2026-11-01 14:00:12.780728
9	9	47	45	92	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 92/100).	2026-11-01 14:00:12.780728
10	10	49	48	97	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 97/100).	2026-11-01 14:00:12.780728
11	11	40	40	80	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 80/100).	2026-11-01 14:00:12.780728
12	12	42	43	85	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 85/100).	2026-11-01 14:00:12.780728
13	13	44	46	90	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 90/100).	2026-11-01 14:00:12.780728
14	14	46	49	95	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 95/100).	2026-11-01 14:00:12.780728
15	15	48	41	89	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 89/100).	2026-11-01 14:00:12.780728
16	16	50	44	94	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 94/100).	2026-11-01 14:00:12.780728
17	17	41	47	88	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 88/100).	2026-11-01 14:00:12.780728
18	18	43	50	93	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 93/100).	2026-11-01 14:00:12.780728
19	19	45	42	87	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 87/100).	2026-11-01 14:00:12.780728
20	20	47	45	92	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 92/100).	2026-11-01 14:00:12.780728
21	21	49	48	97	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 97/100).	2026-11-01 14:00:12.780728
22	22	40	40	80	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 80/100).	2026-11-01 14:00:12.780728
23	23	42	43	85	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 85/100).	2026-11-01 14:00:12.780728
24	24	44	46	90	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 90/100).	2026-11-01 14:00:12.780728
25	25	46	49	95	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 95/100).	2026-11-01 14:00:12.780728
26	26	48	41	89	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 89/100).	2026-11-01 14:00:12.780728
27	27	50	44	94	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 94/100).	2026-11-01 14:00:12.780728
28	28	41	47	88	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 88/100).	2026-11-01 14:00:12.780728
29	29	43	50	93	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 93/100).	2026-11-01 14:00:12.780728
30	30	45	42	87	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 87/100).	2026-11-01 14:00:12.780728
31	31	47	45	92	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 92/100).	2026-11-01 14:00:12.780728
32	32	49	48	97	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 97/100).	2026-11-01 14:00:12.780728
33	33	40	40	80	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 80/100).	2026-11-01 14:00:12.780728
34	34	42	43	85	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 85/100).	2026-11-01 14:00:12.780728
35	35	44	46	90	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 90/100).	2026-11-01 14:00:12.780728
36	36	46	49	95	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 95/100).	2026-11-01 14:00:12.780728
37	37	48	41	89	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 89/100).	2026-11-01 14:00:12.780728
38	38	50	44	94	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 94/100).	2026-11-01 14:00:12.780728
39	39	41	47	88	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 88/100).	2026-11-01 14:00:12.780728
40	40	43	50	93	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 93/100).	2026-11-01 14:00:12.780728
41	41	45	42	87	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 87/100).	2026-11-01 14:00:12.780728
42	42	47	45	92	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 92/100).	2026-11-01 14:00:12.780728
43	43	49	48	97	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 97/100).	2026-11-01 14:00:12.780728
44	44	40	40	80	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 80/100).	2026-11-01 14:00:12.780728
45	45	42	43	85	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 85/100).	2026-11-01 14:00:12.780728
46	46	44	46	90	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 90/100).	2026-11-01 14:00:12.780728
47	47	46	49	95	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 95/100).	2026-11-01 14:00:12.780728
48	48	48	41	89	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 89/100).	2026-11-01 14:00:12.780728
49	49	50	44	94	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 94/100).	2026-11-01 14:00:12.780728
50	50	41	47	88	Aprobado	Postulante verificado con inspección fotográfica satisfactoria en su domicilio (Score: 88/100).	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: expediente_digital; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.expediente_digital (nro_expediente, id_mascota, estado_clinico, fecha_apertura, created_at) FROM stdin;
EXP-2026-0001	1	En Observación	2026-04-18	2026-11-01 14:00:12.780728
EXP-2026-0002	2	Esterilizado y Apto	2026-04-21	2026-11-01 14:00:12.780728
EXP-2026-0003	3	Tratamiento Dermatológico	2026-04-24	2026-11-01 14:00:12.780728
EXP-2026-0004	4	Sano para Entrega	2026-04-27	2026-11-01 14:00:12.780728
EXP-2026-0005	5	Completo y Vacunado	2026-04-30	2026-11-01 14:00:12.780728
EXP-2026-0006	6	En Observación	2026-05-03	2026-11-01 14:00:12.780728
EXP-2026-0007	7	Esterilizado y Apto	2026-05-06	2026-11-01 14:00:12.780728
EXP-2026-0008	8	Tratamiento Dermatológico	2026-05-09	2026-11-01 14:00:12.780728
EXP-2026-0009	9	Sano para Entrega	2026-05-12	2026-11-01 14:00:12.780728
EXP-2026-0010	10	Completo y Vacunado	2026-05-15	2026-11-01 14:00:12.780728
EXP-2026-0011	11	En Observación	2026-05-18	2026-11-01 14:00:12.780728
EXP-2026-0012	12	Esterilizado y Apto	2026-05-21	2026-11-01 14:00:12.780728
EXP-2026-0013	13	Tratamiento Dermatológico	2026-05-24	2026-11-01 14:00:12.780728
EXP-2026-0014	14	Sano para Entrega	2026-05-27	2026-11-01 14:00:12.780728
EXP-2026-0015	15	Completo y Vacunado	2026-05-30	2026-11-01 14:00:12.780728
EXP-2026-0016	16	En Observación	2026-06-02	2026-11-01 14:00:12.780728
EXP-2026-0017	17	Esterilizado y Apto	2026-06-05	2026-11-01 14:00:12.780728
EXP-2026-0018	18	Tratamiento Dermatológico	2026-06-08	2026-11-01 14:00:12.780728
EXP-2026-0019	19	Sano para Entrega	2026-06-11	2026-11-01 14:00:12.780728
EXP-2026-0020	20	Completo y Vacunado	2026-06-14	2026-11-01 14:00:12.780728
EXP-2026-0021	21	En Observación	2026-06-17	2026-11-01 14:00:12.780728
EXP-2026-0022	22	Esterilizado y Apto	2026-06-20	2026-11-01 14:00:12.780728
EXP-2026-0023	23	Tratamiento Dermatológico	2026-06-23	2026-11-01 14:00:12.780728
EXP-2026-0024	24	Sano para Entrega	2026-06-26	2026-11-01 14:00:12.780728
EXP-2026-0025	25	Completo y Vacunado	2026-06-29	2026-11-01 14:00:12.780728
EXP-2026-0026	26	En Observación	2026-07-02	2026-11-01 14:00:12.780728
EXP-2026-0027	27	Esterilizado y Apto	2026-07-05	2026-11-01 14:00:12.780728
EXP-2026-0028	28	Tratamiento Dermatológico	2026-07-08	2026-11-01 14:00:12.780728
EXP-2026-0029	29	Sano para Entrega	2026-07-11	2026-11-01 14:00:12.780728
EXP-2026-0030	30	Completo y Vacunado	2026-07-14	2026-11-01 14:00:12.780728
EXP-2026-0031	31	En Observación	2026-07-17	2026-11-01 14:00:12.780728
EXP-2026-0032	32	Esterilizado y Apto	2026-07-20	2026-11-01 14:00:12.780728
EXP-2026-0033	33	Tratamiento Dermatológico	2026-07-23	2026-11-01 14:00:12.780728
EXP-2026-0034	34	Sano para Entrega	2026-07-26	2026-11-01 14:00:12.780728
EXP-2026-0035	35	Completo y Vacunado	2026-07-29	2026-11-01 14:00:12.780728
EXP-2026-0036	36	En Observación	2026-08-01	2026-11-01 14:00:12.780728
EXP-2026-0037	37	Esterilizado y Apto	2026-08-04	2026-11-01 14:00:12.780728
EXP-2026-0038	38	Tratamiento Dermatológico	2026-08-07	2026-11-01 14:00:12.780728
EXP-2026-0039	39	Sano para Entrega	2026-08-10	2026-11-01 14:00:12.780728
EXP-2026-0040	40	Completo y Vacunado	2026-08-13	2026-11-01 14:00:12.780728
EXP-2026-0041	41	En Observación	2026-08-16	2026-11-01 14:00:12.780728
EXP-2026-0042	42	Esterilizado y Apto	2026-08-19	2026-11-01 14:00:12.780728
EXP-2026-0043	43	Tratamiento Dermatológico	2026-08-22	2026-11-01 14:00:12.780728
EXP-2026-0044	44	Sano para Entrega	2026-08-25	2026-11-01 14:00:12.780728
EXP-2026-0045	45	Completo y Vacunado	2026-08-28	2026-11-01 14:00:12.780728
EXP-2026-0046	46	En Observación	2026-08-31	2026-11-01 14:00:12.780728
EXP-2026-0047	47	Esterilizado y Apto	2026-09-03	2026-11-01 14:00:12.780728
EXP-2026-0048	48	Tratamiento Dermatológico	2026-09-06	2026-11-01 14:00:12.780728
EXP-2026-0049	49	Sano para Entrega	2026-09-09	2026-11-01 14:00:12.780728
EXP-2026-0050	50	Completo y Vacunado	2026-09-12	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: facturas_compras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.facturas_compras (id, proveedor_id, fecha_factura, nit_proveedor, razon_social_proveedor, numero_factura, numero_autorizacion, codigo_control, importe_total, importe_exento, importe_base_cf, credito_fiscal, registrado_por, created_at) FROM stdin;
1	5	2026-01-06	NIT-1000005	Insumos Médicos Veterinarios San Juan	FC-2026-0010	390400202601	EB8E3A6BCF	305.00	0.00	305.00	39.65	6	2026-01-06 11:20:00
2	6	2026-01-16	NIT-1000006	Agropecuaria Cotoca Import-Export	FC-2026-0011	390400202601	2E5D8E7EAF	400.00	0.00	400.00	52.00	6	2026-01-16 12:20:00
3	6	2026-02-06	NIT-1000006	Agropecuaria Cotoca Import-Export	FC-2026-0020	390400202602	1B84FA7CA7	330.00	0.00	330.00	42.90	6	2026-02-06 11:20:00
4	7	2026-02-16	NIT-1000007	Comercializadora Agrovet del Oriente	FC-2026-0021	390400202602	9E6B8B5B87	425.00	0.00	425.00	55.25	6	2026-02-16 12:20:00
5	7	2026-03-06	NIT-1000007	Comercializadora Agrovet del Oriente	FC-2026-0030	390400202603	39BFCFE116	355.00	0.00	355.00	46.15	6	2026-03-06 11:20:00
6	8	2026-03-16	NIT-1000008	Nutrición Animal Purina Bolivia	FC-2026-0031	390400202603	6402F4108A	450.00	0.00	450.00	58.50	6	2026-03-16 12:20:00
7	8	2026-04-06	NIT-1000008	Nutrición Animal Purina Bolivia	FC-2026-0040	390400202604	DC1EF0BF14	380.00	0.00	380.00	49.40	6	2026-04-06 11:20:00
8	9	2026-04-16	NIT-1000009	Importadora Veterinaria Guabirá	FC-2026-0041	390400202604	F8C721C9B2	475.00	0.00	475.00	61.75	6	2026-04-16 12:20:00
9	9	2026-05-06	NIT-1000009	Importadora Veterinaria Guabirá	FC-2026-0050	390400202605	F28ADBBAE3	405.00	0.00	405.00	52.65	6	2026-05-06 11:20:00
10	10	2026-05-16	NIT-1000010	Distribuidora de Fármacos Vetsur	FC-2026-0051	390400202605	09C4F918C3	500.00	0.00	500.00	65.00	6	2026-05-16 12:20:00
11	10	2026-06-06	NIT-1000010	Distribuidora de Fármacos Vetsur	FC-2026-0060	390400202606	FA6E2795A8	430.00	0.00	430.00	55.90	6	2026-06-06 11:20:00
12	11	2026-06-16	NIT-1000011	Clínica y Proveedora Veterinaria Urbarí	FC-2026-0061	390400202606	459F483A96	525.00	0.00	525.00	68.25	6	2026-06-16 12:20:00
13	11	2026-07-06	NIT-1000011	Clínica y Proveedora Veterinaria Urbarí	FC-2026-0070	390400202607	832692C1B4	455.00	0.00	455.00	59.15	6	2026-07-06 11:20:00
14	12	2026-07-16	NIT-1000012	Suministros Hospitalarios Santa Cruz	FC-2026-0071	390400202607	A83F9D6678	550.00	0.00	550.00	71.50	6	2026-07-16 12:20:00
15	12	2026-08-06	NIT-1000012	Suministros Hospitalarios Santa Cruz	FC-2026-0080	390400202608	216A55EF7D	480.00	0.00	480.00	62.40	6	2026-08-06 11:20:00
16	13	2026-08-16	NIT-1000013	Química Industrial Oriente (Desinfectantes)	FC-2026-0081	390400202608	425974FEEC	575.00	0.00	575.00	74.75	6	2026-08-16 12:20:00
17	13	2026-09-06	NIT-1000013	Química Industrial Oriente (Desinfectantes)	FC-2026-0090	390400202609	B8DBBA9104	505.00	0.00	505.00	65.65	6	2026-09-06 11:20:00
18	14	2026-09-16	NIT-1000014	Plásticos y Descartables Camba	FC-2026-0091	390400202609	62EE3F66E1	600.00	0.00	600.00	78.00	6	2026-09-16 12:20:00
19	14	2026-10-06	NIT-1000014	Plásticos y Descartables Camba	FC-2026-0100	390400202610	23BA5A471C	530.00	0.00	530.00	68.90	6	2026-10-06 11:20:00
20	15	2026-10-16	NIT-1000015	Distribuidora de Alimentos PetFood SCZ	FC-2026-0101	390400202610	D74C707550	625.00	0.00	625.00	81.25	6	2026-10-16 12:20:00
21	15	2026-11-06	NIT-1000015	Distribuidora de Alimentos PetFood SCZ	FC-2026-0110	390400202611	A561206762	555.00	0.00	555.00	72.15	6	2026-11-06 11:20:00
22	16	2026-11-12	NIT-1000016	Bayer Animal Health Bolivia	FC-2026-0111	390400202611	942013251E	650.00	0.00	650.00	84.50	6	2026-11-12 12:20:00
\.


--
-- Data for Name: facturas_legales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.facturas_legales (id, dosificacion_id, numero_factura, numero_autorizacion, fecha_emision, nit_ci_cliente, complemento_ci, razon_social_cliente, subtotal, descuento, importe_total, importe_base_cf, debito_fiscal, codigo_control, cadena_qr, estado, motivo_anulacion, fecha_anulacion, usuario_emisor_id, usuario_anulador_id, created_at, updated_at) FROM stdin;
1	1	1	290400202601	2026-01-03 09:15:00	7812345	\N	María Elena Suárez	85.00	0.00	85.00	85.00	11.05	0D-A7-45-4E	1020304021|1|290400202601|03/01/2026|85.00|85.00|0D-A7-45-4E|7812345|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-01-03 09:15:00	2026-01-03 09:15:00
2	1	2	290400202601	2026-01-09 11:22:00	3298451	\N	Clínica Aliada Santa Cruz	130.00	0.00	130.00	130.00	16.90	17-DB-44-CE-C6	1020304021|2|290400202601|09/01/2026|130.00|130.00|17-DB-44-CE-C6|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-01-09 11:22:00	2026-01-09 11:22:00
3	1	3	290400202601	2026-01-15 13:29:00	6541298	\N	Fernanda Paz Ribera	350.00	0.00	350.00	350.00	45.50	11-EB-98-00-E4	1020304021|3|290400202601|15/01/2026|350.00|350.00|11-EB-98-00-E4|6541298|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-01-15 13:29:00	2026-01-15 13:29:00
4	1	4	290400202601	2026-01-21 15:36:00	8912304	\N	Comercial Agropecuaria Oriente	280.00	10.00	270.00	270.00	35.10	7B-4E-18-50	1020304021|4|290400202601|21/01/2026|270.00|270.00|7B-4E-18-50|8912304|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-01-21 15:36:00	2026-01-21 15:36:00
5	1	5	290400202601	2026-02-03 09:15:00	3298451	\N	Clínica Aliada Santa Cruz	65.00	0.00	65.00	65.00	8.45	F1-7D-75-7F	1020304021|5|290400202601|03/02/2026|65.00|65.00|F1-7D-75-7F|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-02-03 09:15:00	2026-02-03 09:15:00
6	1	6	290400202601	2026-02-09 11:22:00	6541298	\N	Fernanda Paz Ribera	700.00	0.00	700.00	700.00	91.00	38-AE-5B-9B-5B	1020304021|6|290400202601|09/02/2026|700.00|700.00|38-AE-5B-9B-5B|6541298|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-02-09 11:22:00	2026-02-09 11:22:00
7	1	7	290400202601	2026-02-15 13:29:00	8912304	\N	Comercial Agropecuaria Oriente	140.00	0.00	140.00	140.00	18.20	7E-79-6B-53	1020304021|7|290400202601|15/02/2026|140.00|140.00|7E-79-6B-53|8912304|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-02-15 13:29:00	2026-02-15 13:29:00
8	1	8	290400202601	2026-02-21 15:36:00	4589123	\N	Roberto Carlos Justiniano	240.00	10.00	230.00	230.00	29.90	72-32-71-51	1020304021|8|290400202601|21/02/2026|230.00|230.00|72-32-71-51|4589123|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-02-21 15:36:00	2026-02-21 15:36:00
9	1	9	290400202601	2026-03-03 09:15:00	6541298	\N	Fernanda Paz Ribera	350.00	0.00	350.00	350.00	45.50	A1-17-44-AA-2A	1020304021|9|290400202601|03/03/2026|350.00|350.00|A1-17-44-AA-2A|6541298|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-03-03 09:15:00	2026-03-03 09:15:00
10	1	10	290400202601	2026-03-09 11:22:00	8912304	\N	Comercial Agropecuaria Oriente	280.00	0.00	280.00	280.00	36.40	12-91-88-1D	1020304021|10|290400202601|09/03/2026|280.00|280.00|12-91-88-1D|8912304|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-03-09 11:22:00	2026-03-09 11:22:00
11	1	11	290400202601	2026-03-15 13:29:00	4589123	\N	Roberto Carlos Justiniano	120.00	0.00	120.00	120.00	15.60	D4-17-A1-07-43	1020304021|11|290400202601|15/03/2026|120.00|120.00|D4-17-A1-07-43|4589123|0.00|0.00|0.00	ANULADA	Error en transcripción de razón social	2026-03-15 16:29:00	5	6	2026-03-15 13:29:00	2026-03-15 16:29:00
12	1	12	290400202601	2026-03-21 15:36:00	7812345	\N	María Elena Suárez	170.00	10.00	160.00	160.00	20.80	C2-81-7B-C3	1020304021|12|290400202601|21/03/2026|160.00|160.00|C2-81-7B-C3|7812345|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-03-21 15:36:00	2026-03-21 15:36:00
13	1	13	290400202601	2026-04-03 09:15:00	8912304	\N	Comercial Agropecuaria Oriente	140.00	0.00	140.00	140.00	18.20	08-13-98-79-AE	1020304021|13|290400202601|03/04/2026|140.00|140.00|08-13-98-79-AE|8912304|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-04-03 09:15:00	2026-04-03 09:15:00
14	1	14	290400202601	2026-04-09 11:22:00	4589123	\N	Roberto Carlos Justiniano	240.00	0.00	240.00	240.00	31.20	D9-BF-BB-D6	1020304021|14|290400202601|09/04/2026|240.00|240.00|D9-BF-BB-D6|4589123|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-04-09 11:22:00	2026-04-09 11:22:00
15	1	15	290400202601	2026-04-15 13:29:00	7812345	\N	María Elena Suárez	85.00	0.00	85.00	85.00	11.05	8A-83-8B-78-2D	1020304021|15|290400202601|15/04/2026|85.00|85.00|8A-83-8B-78-2D|7812345|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-04-15 13:29:00	2026-04-15 13:29:00
16	1	16	290400202601	2026-04-21 15:36:00	3298451	\N	Clínica Aliada Santa Cruz	130.00	10.00	120.00	120.00	15.60	9B-68-32-CE-84	1020304021|16|290400202601|21/04/2026|120.00|120.00|9B-68-32-CE-84|3298451|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-04-21 15:36:00	2026-04-21 15:36:00
17	1	17	290400202601	2026-05-03 09:15:00	4589123	\N	Roberto Carlos Justiniano	120.00	0.00	120.00	120.00	15.60	01-E7-0B-C6	1020304021|17|290400202601|03/05/2026|120.00|120.00|01-E7-0B-C6|4589123|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-05-03 09:15:00	2026-05-03 09:15:00
18	1	18	290400202601	2026-05-09 11:22:00	7812345	\N	María Elena Suárez	170.00	0.00	170.00	170.00	22.10	36-9A-11-57	1020304021|18|290400202601|09/05/2026|170.00|170.00|36-9A-11-57|7812345|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-05-09 11:22:00	2026-05-09 11:22:00
19	1	19	290400202601	2026-05-15 13:29:00	3298451	\N	Clínica Aliada Santa Cruz	65.00	0.00	65.00	65.00	8.45	E6-17-A5-A7	1020304021|19|290400202601|15/05/2026|65.00|65.00|E6-17-A5-A7|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-05-15 13:29:00	2026-05-15 13:29:00
20	1	20	290400202601	2026-05-21 15:36:00	6541298	\N	Fernanda Paz Ribera	700.00	10.00	690.00	690.00	89.70	D8-23-23-1F	1020304021|20|290400202601|21/05/2026|690.00|690.00|D8-23-23-1F|6541298|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-05-21 15:36:00	2026-05-21 15:36:00
21	1	21	290400202601	2026-06-03 09:15:00	7812345	\N	María Elena Suárez	85.00	0.00	85.00	85.00	11.05	87-C3-1B-86	1020304021|21|290400202601|03/06/2026|85.00|85.00|87-C3-1B-86|7812345|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-06-03 09:15:00	2026-06-03 09:15:00
22	1	22	290400202601	2026-06-09 11:22:00	3298451	\N	Clínica Aliada Santa Cruz	130.00	0.00	130.00	130.00	16.90	5F-F8-BD-65-9D	1020304021|22|290400202601|09/06/2026|130.00|130.00|5F-F8-BD-65-9D|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-06-09 11:22:00	2026-06-09 11:22:00
23	1	23	290400202601	2026-06-15 13:29:00	6541298	\N	Fernanda Paz Ribera	350.00	0.00	350.00	350.00	45.50	AF-5E-9C-E6	1020304021|23|290400202601|15/06/2026|350.00|350.00|AF-5E-9C-E6|6541298|0.00|0.00|0.00	ANULADA	Error en transcripción de razón social	2026-06-15 16:29:00	5	6	2026-06-15 13:29:00	2026-06-15 16:29:00
24	1	24	290400202601	2026-06-21 15:36:00	8912304	\N	Comercial Agropecuaria Oriente	280.00	10.00	270.00	270.00	35.10	15-C3-2F-78	1020304021|24|290400202601|21/06/2026|270.00|270.00|15-C3-2F-78|8912304|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-06-21 15:36:00	2026-06-21 15:36:00
25	2	501	290400202602	2026-07-03 09:15:00	3298451	\N	Clínica Aliada Santa Cruz	65.00	0.00	65.00	65.00	8.45	CD-99-17-62	1020304021|501|290400202602|03/07/2026|65.00|65.00|CD-99-17-62|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-07-03 09:15:00	2026-07-03 09:15:00
26	2	502	290400202602	2026-07-09 11:22:00	6541298	\N	Fernanda Paz Ribera	700.00	0.00	700.00	700.00	91.00	89-0A-F3-A0-A1	1020304021|502|290400202602|09/07/2026|700.00|700.00|89-0A-F3-A0-A1|6541298|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-07-09 11:22:00	2026-07-09 11:22:00
27	2	503	290400202602	2026-07-15 13:29:00	8912304	\N	Comercial Agropecuaria Oriente	140.00	0.00	140.00	140.00	18.20	D6-C9-A2-F1	1020304021|503|290400202602|15/07/2026|140.00|140.00|D6-C9-A2-F1|8912304|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-07-15 13:29:00	2026-07-15 13:29:00
28	2	504	290400202602	2026-07-21 15:36:00	4589123	\N	Roberto Carlos Justiniano	240.00	10.00	230.00	230.00	29.90	E2-73-8F-D0-A4	1020304021|504|290400202602|21/07/2026|230.00|230.00|E2-73-8F-D0-A4|4589123|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-07-21 15:36:00	2026-07-21 15:36:00
29	2	505	290400202602	2026-08-03 09:15:00	6541298	\N	Fernanda Paz Ribera	350.00	0.00	350.00	350.00	45.50	8D-96-F0-18	1020304021|505|290400202602|03/08/2026|350.00|350.00|8D-96-F0-18|6541298|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-08-03 09:15:00	2026-08-03 09:15:00
30	2	506	290400202602	2026-08-09 11:22:00	8912304	\N	Comercial Agropecuaria Oriente	280.00	0.00	280.00	280.00	36.40	74-81-90-45-2F	1020304021|506|290400202602|09/08/2026|280.00|280.00|74-81-90-45-2F|8912304|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-08-09 11:22:00	2026-08-09 11:22:00
31	2	507	290400202602	2026-08-15 13:29:00	4589123	\N	Roberto Carlos Justiniano	120.00	0.00	120.00	120.00	15.60	E4-69-04-96	1020304021|507|290400202602|15/08/2026|120.00|120.00|E4-69-04-96|4589123|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-08-15 13:29:00	2026-08-15 13:29:00
32	2	508	290400202602	2026-08-21 15:36:00	7812345	\N	María Elena Suárez	170.00	10.00	160.00	160.00	20.80	93-B3-8C-87	1020304021|508|290400202602|21/08/2026|160.00|160.00|93-B3-8C-87|7812345|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-08-21 15:36:00	2026-08-21 15:36:00
33	2	509	290400202602	2026-09-03 09:15:00	8912304	\N	Comercial Agropecuaria Oriente	140.00	0.00	140.00	140.00	18.20	C1-2C-B8-81-B9	1020304021|509|290400202602|03/09/2026|140.00|140.00|C1-2C-B8-81-B9|8912304|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-09-03 09:15:00	2026-09-03 09:15:00
34	2	510	290400202602	2026-09-09 11:22:00	4589123	\N	Roberto Carlos Justiniano	240.00	0.00	240.00	240.00	31.20	B1-1E-8A-19	1020304021|510|290400202602|09/09/2026|240.00|240.00|B1-1E-8A-19|4589123|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-09-09 11:22:00	2026-09-09 11:22:00
35	2	511	290400202602	2026-09-15 13:29:00	7812345	\N	María Elena Suárez	85.00	0.00	85.00	85.00	11.05	A4-E4-5C-1A-6C	1020304021|511|290400202602|15/09/2026|85.00|85.00|A4-E4-5C-1A-6C|7812345|0.00|0.00|0.00	ANULADA	Error en transcripción de razón social	2026-09-15 16:29:00	5	6	2026-09-15 13:29:00	2026-09-15 16:29:00
36	2	512	290400202602	2026-09-21 15:36:00	3298451	\N	Clínica Aliada Santa Cruz	130.00	10.00	120.00	120.00	15.60	6C-4A-C3-0F	1020304021|512|290400202602|21/09/2026|120.00|120.00|6C-4A-C3-0F|3298451|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-09-21 15:36:00	2026-09-21 15:36:00
37	2	513	290400202602	2026-10-03 09:15:00	4589123	\N	Roberto Carlos Justiniano	120.00	0.00	120.00	120.00	15.60	61-6C-8C-14-3D	1020304021|513|290400202602|03/10/2026|120.00|120.00|61-6C-8C-14-3D|4589123|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-10-03 09:15:00	2026-10-03 09:15:00
38	2	514	290400202602	2026-10-09 11:22:00	7812345	\N	María Elena Suárez	170.00	0.00	170.00	170.00	22.10	6B-42-C7-08-83	1020304021|514|290400202602|09/10/2026|170.00|170.00|6B-42-C7-08-83|7812345|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-10-09 11:22:00	2026-10-09 11:22:00
39	2	515	290400202602	2026-10-15 13:29:00	3298451	\N	Clínica Aliada Santa Cruz	65.00	0.00	65.00	65.00	8.45	E8-47-97-F7	1020304021|515|290400202602|15/10/2026|65.00|65.00|E8-47-97-F7|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-10-15 13:29:00	2026-10-15 13:29:00
40	2	516	290400202602	2026-10-21 15:36:00	6541298	\N	Fernanda Paz Ribera	700.00	10.00	690.00	690.00	89.70	3F-25-8D-99-02	1020304021|516|290400202602|21/10/2026|690.00|690.00|3F-25-8D-99-02|6541298|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-10-21 15:36:00	2026-10-21 15:36:00
41	2	517	290400202602	2026-11-03 09:15:00	7812345	\N	María Elena Suárez	85.00	0.00	85.00	85.00	11.05	C9-E4-D1-08	1020304021|517|290400202602|03/11/2026|85.00|85.00|C9-E4-D1-08|7812345|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-11-03 09:15:00	2026-11-03 09:15:00
42	2	518	290400202602	2026-11-09 11:22:00	3298451	\N	Clínica Aliada Santa Cruz	130.00	0.00	130.00	130.00	16.90	11-7D-D2-80-7D	1020304021|518|290400202602|09/11/2026|130.00|130.00|11-7D-D2-80-7D|3298451|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-11-09 11:22:00	2026-11-09 11:22:00
43	2	519	290400202602	2026-11-12 13:29:00	6541298	\N	Fernanda Paz Ribera	350.00	0.00	350.00	350.00	45.50	6E-81-88-28-51	1020304021|519|290400202602|12/11/2026|350.00|350.00|6E-81-88-28-51|6541298|0.00|0.00|0.00	EMITIDA	\N	\N	5	\N	2026-11-12 13:29:00	2026-11-12 13:29:00
44	2	520	290400202602	2026-11-12 15:36:00	8912304	\N	Comercial Agropecuaria Oriente	280.00	10.00	270.00	270.00	35.10	C0-9A-11-3C-55	1020304021|520|290400202602|12/11/2026|270.00|270.00|C0-9A-11-3C-55|8912304|0.00|0.00|10.00	EMITIDA	\N	\N	5	\N	2026-11-12 15:36:00	2026-11-12 15:36:00
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: historial_clinico; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.historial_clinico (id_historial, id_mascota, id_usuario, fecha_atencion, tipo_procedimiento, diagnostico, observaciones, created_at, updated_at) FROM stdin;
1	1	4	2026-07-26	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	2	5	2026-07-28	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	3	6	2026-07-30	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	4	7	2026-08-01	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	5	3	2026-08-03	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	6	4	2026-08-05	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	7	5	2026-08-07	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	8	6	2026-08-09	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	9	7	2026-08-11	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	10	3	2026-08-13	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	11	4	2026-08-15	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	12	5	2026-08-17	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	13	6	2026-08-19	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	14	7	2026-08-21	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	15	3	2026-08-23	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	16	4	2026-08-25	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	17	5	2026-08-27	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	18	6	2026-08-29	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	19	7	2026-08-31	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	20	3	2026-09-02	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	21	4	2026-09-04	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	22	5	2026-09-06	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	23	6	2026-09-08	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	24	7	2026-09-10	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	25	3	2026-09-12	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	26	4	2026-09-14	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	27	5	2026-09-16	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	28	6	2026-09-18	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	29	7	2026-09-20	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	30	3	2026-09-22	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	31	4	2026-09-24	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	32	5	2026-09-26	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	33	6	2026-09-28	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	34	7	2026-09-30	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	35	3	2026-10-02	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	36	4	2026-10-04	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	37	5	2026-10-06	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	38	6	2026-10-08	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	39	7	2026-10-10	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	40	3	2026-10-12	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	41	4	2026-10-14	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	42	5	2026-10-16	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	43	6	2026-10-18	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	44	7	2026-10-20	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	45	3	2026-10-22	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	46	4	2026-10-24	Vacunación	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	47	5	2026-10-26	Desparasitación	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	48	6	2026-10-28	Curación	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	49	7	2026-10-30	Cirugía	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	50	3	2026-11-01	Consulta Médica	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: historial_clinicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.historial_clinicos (id, fecha_atencion, diagnostico, observacion, tipo_procedimiento, id_mascota, id_usuario, created_at, updated_at) FROM stdin;
1	2026-01-16	Desnutrición leve y parasitosis intestinal.	Se administra antiparasitario interno y suplemento vitamínico.	Evaluación Inicial	1	2	2026-11-01 18:17:19	2026-11-01 18:17:19
2	2026-02-11	Infección respiratoria felina (Pérdida de apetito).	Tratamiento con antibiótico por 7 días y nebulización.	Consulta Médica	2	2	2026-11-01 18:17:19	2026-11-01 18:17:19
3	2026-03-02	Paciente clínicamente sano, apto para procedimiento.	Cirugía realizada sin complicaciones. Postoperatorio en observación.	Cirugía de Esterilización	3	4	2026-11-01 18:17:19	2026-11-01 18:17:19
4	2026-03-05	Saludable.	Aplicación de vacuna trivalente felina y desparasitación.	Vacunación	4	2	2026-11-01 18:17:19	2026-11-01 18:17:19
5	2026-03-06	Laceración superficial en pata delantera izquierda.	Limpieza de herida y aplicación de antiséptico en spray.	Curación	5	4	2026-11-01 18:17:19	2026-11-01 18:17:19
6	2026-08-05	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	6	4	2026-11-01 14:00:13	2026-11-01 14:00:13
7	2026-08-07	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	7	5	2026-11-01 14:00:13	2026-11-01 14:00:13
8	2026-08-09	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	8	6	2026-11-01 14:00:13	2026-11-01 14:00:13
9	2026-08-11	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	9	7	2026-11-01 14:00:13	2026-11-01 14:00:13
10	2026-08-13	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	10	3	2026-11-01 14:00:13	2026-11-01 14:00:13
11	2026-08-15	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	11	4	2026-11-01 14:00:13	2026-11-01 14:00:13
12	2026-08-17	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	12	5	2026-11-01 14:00:13	2026-11-01 14:00:13
13	2026-08-19	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	13	6	2026-11-01 14:00:13	2026-11-01 14:00:13
14	2026-08-21	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	14	7	2026-11-01 14:00:13	2026-11-01 14:00:13
15	2026-08-23	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	15	3	2026-11-01 14:00:13	2026-11-01 14:00:13
16	2026-08-25	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	16	4	2026-11-01 14:00:13	2026-11-01 14:00:13
17	2026-08-27	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	17	5	2026-11-01 14:00:13	2026-11-01 14:00:13
18	2026-08-29	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	18	6	2026-11-01 14:00:13	2026-11-01 14:00:13
19	2026-08-31	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	19	7	2026-11-01 14:00:13	2026-11-01 14:00:13
20	2026-09-02	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	20	3	2026-11-01 14:00:13	2026-11-01 14:00:13
21	2026-09-04	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	21	4	2026-11-01 14:00:13	2026-11-01 14:00:13
22	2026-09-06	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	22	5	2026-11-01 14:00:13	2026-11-01 14:00:13
23	2026-09-08	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	23	6	2026-11-01 14:00:13	2026-11-01 14:00:13
24	2026-09-10	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	24	7	2026-11-01 14:00:13	2026-11-01 14:00:13
25	2026-09-12	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	25	3	2026-11-01 14:00:13	2026-11-01 14:00:13
26	2026-09-14	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	26	4	2026-11-01 14:00:13	2026-11-01 14:00:13
27	2026-09-16	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	27	5	2026-11-01 14:00:13	2026-11-01 14:00:13
28	2026-09-18	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	28	6	2026-11-01 14:00:13	2026-11-01 14:00:13
29	2026-09-20	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	29	7	2026-11-01 14:00:13	2026-11-01 14:00:13
30	2026-09-22	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	30	3	2026-11-01 14:00:13	2026-11-01 14:00:13
31	2026-09-24	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	31	4	2026-11-01 14:00:13	2026-11-01 14:00:13
32	2026-09-26	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	32	5	2026-11-01 14:00:13	2026-11-01 14:00:13
33	2026-09-28	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	33	6	2026-11-01 14:00:13	2026-11-01 14:00:13
34	2026-09-30	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	34	7	2026-11-01 14:00:13	2026-11-01 14:00:13
35	2026-10-02	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	35	3	2026-11-01 14:00:13	2026-11-01 14:00:13
36	2026-10-04	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	36	4	2026-11-01 14:00:13	2026-11-01 14:00:13
37	2026-10-06	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	37	5	2026-11-01 14:00:13	2026-11-01 14:00:13
38	2026-10-08	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	38	6	2026-11-01 14:00:13	2026-11-01 14:00:13
39	2026-10-10	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	39	7	2026-11-01 14:00:13	2026-11-01 14:00:13
40	2026-10-12	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	40	3	2026-11-01 14:00:13	2026-11-01 14:00:13
41	2026-10-14	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	41	4	2026-11-01 14:00:13	2026-11-01 14:00:13
42	2026-10-16	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	42	5	2026-11-01 14:00:13	2026-11-01 14:00:13
43	2026-10-18	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	43	6	2026-11-01 14:00:13	2026-11-01 14:00:13
44	2026-10-20	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	44	7	2026-11-01 14:00:13	2026-11-01 14:00:13
45	2026-10-22	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	45	3	2026-11-01 14:00:13	2026-11-01 14:00:13
46	2026-10-24	Animal clínicamente apto para inmunización	Se aplica vacuna óctuple Vanguard Plus lote #9822.	Vacunación	46	4	2026-11-01 14:00:13	2026-11-01 14:00:13
47	2026-10-26	Parasitosis intestinal por nematodos confirmada por coprología	Se administra Total F comprimidos según peso corporal (15kg).	Desparasitación	47	5	2026-11-01 14:00:13	2026-11-01 14:00:13
48	2026-10-28	Herida abierta lacerada en extremidad posterior derecha por mordedura	Lavado con clorhexidina al 2%, sutura y colocación de curabichera.	Curación	48	6	2026-11-01 14:00:13	2026-11-01 14:00:13
49	2026-10-30	Esterilización quirúrgica electiva (Ovariohisterectomía / Castración)	Procedimiento exitoso sin complicaciones anestésicas. Cono protector.	Cirugía	49	7	2026-11-01 14:00:13	2026-11-01 14:00:13
50	2026-11-01	Desnutrición moderada, anemia y ectoparásitos en piel	Se suministra complejo B inyectable y pipeta antiparasitaria.	Consulta Médica	50	3	2026-11-01 14:00:13	2026-11-01 14:00:13
51	2025-10-19	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	1	2	2026-11-02 03:34:42	2026-11-02 03:34:42
52	2025-11-12	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	1	4	2026-11-02 03:34:42	2026-11-02 03:34:42
53	2025-10-23	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	2	4	2026-11-02 03:34:42	2026-11-02 03:34:42
54	2025-11-16	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	2	7	2026-11-02 03:34:42	2026-11-02 03:34:42
55	2025-10-27	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	3	7	2026-11-02 03:34:42	2026-11-02 03:34:42
56	2025-11-20	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	3	8	2026-11-02 03:34:42	2026-11-02 03:34:42
57	2025-10-31	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	4	8	2026-11-02 03:34:42	2026-11-02 03:34:42
58	2025-11-24	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	4	9	2026-11-02 03:34:42	2026-11-02 03:34:42
59	2025-11-04	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	5	9	2026-11-02 03:34:42	2026-11-02 03:34:42
60	2025-11-28	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	5	10	2026-11-02 03:34:42	2026-11-02 03:34:42
61	2025-11-08	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	6	10	2026-11-02 03:34:42	2026-11-02 03:34:42
62	2025-12-02	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	6	2	2026-11-02 03:34:42	2026-11-02 03:34:42
63	2025-11-12	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	7	2	2026-11-02 03:34:42	2026-11-02 03:34:42
64	2025-12-06	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	7	4	2026-11-02 03:34:42	2026-11-02 03:34:42
65	2025-11-16	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	8	4	2026-11-02 03:34:42	2026-11-02 03:34:42
66	2025-12-10	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	8	7	2026-11-02 03:34:42	2026-11-02 03:34:42
67	2025-11-20	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	9	7	2026-11-02 03:34:42	2026-11-02 03:34:42
68	2025-12-14	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	9	8	2026-11-02 03:34:42	2026-11-02 03:34:42
98	2026-02-12	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	24	2	2026-11-02 03:34:42	2026-11-02 03:34:42
69	2025-11-24	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	10	8	2026-11-02 03:34:42	2026-11-02 03:34:42
70	2025-12-18	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	10	9	2026-11-02 03:34:42	2026-11-02 03:34:42
71	2025-11-28	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	11	9	2026-11-02 03:34:42	2026-11-02 03:34:42
72	2025-12-22	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	11	10	2026-11-02 03:34:42	2026-11-02 03:34:42
73	2025-12-02	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	12	10	2026-11-02 03:34:42	2026-11-02 03:34:42
74	2025-12-26	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	12	2	2026-11-02 03:34:42	2026-11-02 03:34:42
75	2025-12-06	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	13	2	2026-11-02 03:34:42	2026-11-02 03:34:42
76	2025-12-30	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	13	4	2026-11-02 03:34:42	2026-11-02 03:34:42
77	2025-12-10	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	14	4	2026-11-02 03:34:42	2026-11-02 03:34:42
78	2026-01-03	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	14	7	2026-11-02 03:34:42	2026-11-02 03:34:42
79	2025-12-14	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	15	7	2026-11-02 03:34:42	2026-11-02 03:34:42
80	2026-01-07	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	15	8	2026-11-02 03:34:42	2026-11-02 03:34:42
81	2025-12-18	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	16	8	2026-11-02 03:34:42	2026-11-02 03:34:42
82	2026-01-11	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	16	9	2026-11-02 03:34:42	2026-11-02 03:34:42
83	2025-12-22	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	17	9	2026-11-02 03:34:42	2026-11-02 03:34:42
84	2026-01-15	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	17	10	2026-11-02 03:34:42	2026-11-02 03:34:42
85	2025-12-26	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	18	10	2026-11-02 03:34:42	2026-11-02 03:34:42
86	2026-01-19	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	18	2	2026-11-02 03:34:42	2026-11-02 03:34:42
87	2025-12-30	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	19	2	2026-11-02 03:34:42	2026-11-02 03:34:42
88	2026-01-23	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	19	4	2026-11-02 03:34:42	2026-11-02 03:34:42
89	2026-01-03	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	20	4	2026-11-02 03:34:42	2026-11-02 03:34:42
90	2026-01-27	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	20	7	2026-11-02 03:34:42	2026-11-02 03:34:42
91	2026-01-07	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	21	7	2026-11-02 03:34:42	2026-11-02 03:34:42
92	2026-01-31	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	21	8	2026-11-02 03:34:42	2026-11-02 03:34:42
93	2026-01-11	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	22	8	2026-11-02 03:34:42	2026-11-02 03:34:42
94	2026-02-04	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	22	9	2026-11-02 03:34:42	2026-11-02 03:34:42
95	2026-01-15	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	23	9	2026-11-02 03:34:42	2026-11-02 03:34:42
96	2026-02-08	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	23	10	2026-11-02 03:34:42	2026-11-02 03:34:42
97	2026-01-19	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	24	10	2026-11-02 03:34:42	2026-11-02 03:34:42
99	2026-01-23	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	25	2	2026-11-02 03:34:42	2026-11-02 03:34:42
100	2026-02-16	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	25	4	2026-11-02 03:34:42	2026-11-02 03:34:42
101	2026-01-27	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	26	4	2026-11-02 03:34:42	2026-11-02 03:34:42
102	2026-02-20	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	26	7	2026-11-02 03:34:42	2026-11-02 03:34:42
103	2026-01-31	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	27	7	2026-11-02 03:34:42	2026-11-02 03:34:42
104	2026-02-24	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	27	8	2026-11-02 03:34:42	2026-11-02 03:34:42
105	2026-02-04	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	28	8	2026-11-02 03:34:42	2026-11-02 03:34:42
106	2026-02-28	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	28	9	2026-11-02 03:34:42	2026-11-02 03:34:42
107	2026-02-08	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	29	9	2026-11-02 03:34:42	2026-11-02 03:34:42
108	2026-03-04	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	29	10	2026-11-02 03:34:42	2026-11-02 03:34:42
109	2026-02-12	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	30	10	2026-11-02 03:34:42	2026-11-02 03:34:42
110	2026-03-08	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	30	2	2026-11-02 03:34:42	2026-11-02 03:34:42
111	2026-02-16	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	31	2	2026-11-02 03:34:42	2026-11-02 03:34:42
112	2026-03-12	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	31	4	2026-11-02 03:34:42	2026-11-02 03:34:42
113	2026-02-20	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	32	4	2026-11-02 03:34:42	2026-11-02 03:34:42
114	2026-03-16	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	32	7	2026-11-02 03:34:42	2026-11-02 03:34:42
115	2026-02-24	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	33	7	2026-11-02 03:34:42	2026-11-02 03:34:42
116	2026-03-20	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	33	8	2026-11-02 03:34:42	2026-11-02 03:34:42
117	2026-02-28	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	34	8	2026-11-02 03:34:42	2026-11-02 03:34:42
118	2026-03-24	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	34	9	2026-11-02 03:34:42	2026-11-02 03:34:42
119	2026-03-04	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	35	9	2026-11-02 03:34:42	2026-11-02 03:34:42
120	2026-03-28	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	35	10	2026-11-02 03:34:42	2026-11-02 03:34:42
121	2026-03-08	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	36	10	2026-11-02 03:34:42	2026-11-02 03:34:42
122	2026-04-01	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	36	2	2026-11-02 03:34:42	2026-11-02 03:34:42
123	2026-03-12	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	37	2	2026-11-02 03:34:42	2026-11-02 03:34:42
124	2026-04-05	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	37	4	2026-11-02 03:34:42	2026-11-02 03:34:42
125	2026-03-16	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	38	4	2026-11-02 03:34:42	2026-11-02 03:34:42
126	2026-04-09	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	38	7	2026-11-02 03:34:42	2026-11-02 03:34:42
127	2026-03-20	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	39	7	2026-11-02 03:34:42	2026-11-02 03:34:42
128	2026-04-13	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	39	8	2026-11-02 03:34:42	2026-11-02 03:34:42
129	2026-03-24	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	40	8	2026-11-02 03:34:42	2026-11-02 03:34:42
130	2026-04-17	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	40	9	2026-11-02 03:34:42	2026-11-02 03:34:42
131	2026-03-28	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	41	9	2026-11-02 03:34:42	2026-11-02 03:34:42
132	2026-04-21	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	41	10	2026-11-02 03:34:42	2026-11-02 03:34:42
133	2026-04-01	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	42	10	2026-11-02 03:34:42	2026-11-02 03:34:42
134	2026-04-25	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	42	2	2026-11-02 03:34:42	2026-11-02 03:34:42
135	2026-04-05	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	43	2	2026-11-02 03:34:42	2026-11-02 03:34:42
136	2026-04-29	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	43	4	2026-11-02 03:34:42	2026-11-02 03:34:42
137	2026-04-09	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	44	4	2026-11-02 03:34:42	2026-11-02 03:34:42
138	2026-05-03	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	44	7	2026-11-02 03:34:42	2026-11-02 03:34:42
139	2026-04-13	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	45	7	2026-11-02 03:34:42	2026-11-02 03:34:42
140	2026-05-07	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	45	8	2026-11-02 03:34:42	2026-11-02 03:34:42
141	2026-04-17	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	46	8	2026-11-02 03:34:42	2026-11-02 03:34:42
142	2026-05-11	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	46	9	2026-11-02 03:34:42	2026-11-02 03:34:42
143	2026-04-21	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	47	9	2026-11-02 03:34:42	2026-11-02 03:34:42
144	2026-05-15	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	47	10	2026-11-02 03:34:42	2026-11-02 03:34:42
145	2026-04-25	Evaluación respiratoria y ocular limpia. Apto para vacuna felina.	Aplicación de vacuna Triple Felina (Rinotraqueítis, Calicivirus, Panleucopenia) y pipeta externa.	Vacunación Triple Felina	48	10	2026-11-02 03:34:42	2026-11-02 03:34:42
146	2026-05-19	Control reproductivo profiláctico.	Cirugía sin incidencias. Implante de microchip subcutáneo interescapular verificado con lector.	Esterilización y Microchip	48	2	2026-11-02 03:34:42	2026-11-02 03:34:42
147	2026-04-29	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	49	2	2026-11-02 03:34:42	2026-11-02 03:34:42
148	2026-05-23	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	49	4	2026-11-02 03:34:42	2026-11-02 03:34:42
149	2026-05-03	Paciente sin signos de infección viral activa. Apto para inmunización.	Se administra vacuna Séxtuple Canina (DHPPiL) y comprimido antiparasitario interno amplio espectro.	Vacunación y Desparasitación	50	4	2026-11-02 03:34:42	2026-11-02 03:34:42
150	2026-05-27	Profilaxis reproductiva y control poblacional del albergue.	Orquiectomía / Ovariohisterectomía completada bajo anestesia general. Buena recuperación, sutura intradérmica.	Cirugía de Esterilización	50	7	2026-11-02 03:34:42	2026-11-02 03:34:42
\.


--
-- Data for Name: interesado_adopcion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.interesado_adopcion (id_interesado, ci, nombre, telefono, direccion, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at) FROM stdin;
59	5212921	Juan Carlos Flores Ugarte	63587660	Barrio Urbari, Calle Mocoví	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-21 13:58:44
1	4920193	Mariana Paz Soldán	77391029	Av. San Martín #450, Barrio Equipetrol	Casa propia con patio amplio completamente cerrado.	Dra. Claudia Ríos (Veterinaria Particular) - 71000000	95	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
2	8192039	Jorge Justiniano Rivero	71629384	Calle Arenales #123, Centro	Departamento propio en 3er piso (Permite mascotas pequeñas).	Ing. Roberto Justiniano (Hermano) - 72000000	88	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
3	3920192	Valeria Aguilera Banegas	69012938	Barrio Sirari, Calle 3 #12	Casa familiar con jardín interno.	Lic. Sofía Aguilera (Madre) - 73000000	90	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
4	9201938	Fernando Roca Pinto	72819203	Av. Busch y 3er Anillo	Alquiler con autorización firmada por el propietario.	Carlos Roca (Padre) - 74000000	75	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
5	5829103	Andrea Melgar Justiniano	75591823	Urb. Las Palmas, Calle 5	Quinta con muro perimetral alto y áreas verdes.	Dra. María Melgar - 75000000	98	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
6	5201314	Rodrigo Salazar Montaño	66493086	Doble Vía a La Guardia, Km 6	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
7	5201533	Carla Mariana Dorado Pinto	79701323	Barrio Hamacas, Calle 4 Norte	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
8	5201752	Claudia Patricia Justiniano Chávez	65946432	Barrio Sirari, Calle Los Claveles	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
9	5201971	Fernanda Pinto Román	78164651	Radial 26, Barrio 24 de Septiembre	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
10	5202190	Alejandra Justiniano Soliz	79313470	Radial 10, Barrio 4 de Octubre	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
11	5202409	Miguel Ángel Antelo Ugarte	76717873	Barrio Urbari, Calle Mocoví	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
12	5202628	María René Mercado Hurtado	71560194	Zona Santos Dumont, 4to Anillo	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
13	5202847	Jessica Gutiérrez Ribera	72002175	Barrio Guaracachi, Av. Brasil	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
14	5203066	Laura Morales Rojas	79586141	Barrio La Cuchilla, Av. Moscú	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
15	5203285	Óscar Mercado Vargas	68958241	Barrio Los Chacos, Calle Las Peñas	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
16	5203504	Fernando Suárez Castedo	64844090	Zona Parque Industrial, PI-12	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
17	5203723	Leonardo Montaño Gutiérrez	71128406	Av. Banzer, Km 8.5	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
18	5203942	Lucas Paz Flores	65341881	Barrio Petrolero, Calle YPFB	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
19	5204161	Natalia Vargas Saucedo	65758783	Zona El Trompillo, Calle Cochabamba	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
20	5204380	Lorena Hurtado Pinto	71388723	Barrio Cordecruz, Manzano 14	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
21	5204599	Sebastián Antelo Soliz	76779785	Barrio Remanso, Calle Las Lajas	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
22	5204818	Gonzalo Dorado Condori	64433868	Barrio España, Calle Valencia	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
23	5205037	Carolina Vargas Hurtado	76893470	Barrio Magisterio, Av. Mutualista	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
24	5205256	Andrea Fabiana Justiniano Paz	67611810	Barrio Equipetrol, Calle 8 Este	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
25	5205475	Claudia Patricia Añez Barba	66247681	Barrio Las Palmas, Av. Las Palmeras	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
26	5205694	Hugo Zabala Añez	72718284	Plan 3000, Barrio El Quior	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
27	5205913	Adriana Torrico Román	76576286	Villa 1ro de Mayo, Calle 3	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
28	5206132	Jorge Luis Ribera Aguilera	77520223	Pampa de la Isla, Av. Montecristo	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
29	5206351	Adriana Aguilera Aguilera	68238228	Barrio Los Pozos, Calle Suárez Arana	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
30	5206570	Mario Alberto Peña Añez	77826978	Doble Vía a La Guardia, Km 6	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
31	5206789	Daniela Torrico Suárez	79874138	Barrio Hamacas, Calle 4 Norte	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
32	5207008	María René Castedo Castedo	71578459	Barrio Sirari, Calle Los Claveles	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
33	5207227	Jorge Luis Soliz Román	76158019	Radial 26, Barrio 24 de Septiembre	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
34	5207446	Mario Alberto Gutiérrez Pinto	64136033	Radial 10, Barrio 4 de Octubre	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
35	5207665	Juan Carlos Barba Saucedo	79976512	Barrio Urbari, Calle Mocoví	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
36	5207884	Adriana Castedo Montaño	72417645	Zona Santos Dumont, 4to Anillo	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
37	5208103	Gabriela Justiniano Saucedo	79289302	Barrio Guaracachi, Av. Brasil	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
38	5208322	Daniela Cuéllar Dorado	75835586	Barrio La Cuchilla, Av. Moscú	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
39	5208541	Mario Alberto Salazar Ugarte	67864207	Barrio Los Chacos, Calle Las Peñas	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
40	5208760	Claudia Patricia Mamani Vargas	62748166	Zona Parque Industrial, PI-12	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
41	5208979	Rodrigo Mendoza Antelo	72566501	Av. Banzer, Km 8.5	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
42	5209198	Diana Ugarte Condori	67712246	Barrio Petrolero, Calle YPFB	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
43	5209417	Marcelo Aguilera Saucedo	73549252	Zona El Trompillo, Calle Cochabamba	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
44	5209636	Lucas Peña Chávez	61228942	Barrio Cordecruz, Manzano 14	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
45	5209855	Mónica Montaño Montaño	62137980	Barrio Remanso, Calle Las Lajas	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
46	5210074	Mauricio Suárez Barba	73466477	Barrio España, Calle Valencia	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
47	5210293	Diego Armando Ribera Salazar	65197362	Barrio Magisterio, Av. Mutualista	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
48	5210512	Hugo Román Aguilera	62637432	Barrio Equipetrol, Calle 8 Este	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
49	5210731	Carlos Eduardo Chávez Aguilera	66917479	Barrio Las Palmas, Av. Las Palmeras	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
50	5210950	Claudia Patricia Morales Morales	74293324	Plan 3000, Barrio El Quior	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
51	5211169	Miguel Ángel Antelo Paz	68310889	Villa 1ro de Mayo, Calle 3	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
52	5211388	Camila Soliz Barba	71797640	Pampa de la Isla, Av. Montecristo	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
53	5211607	Tatiana Flores Montaño	64284806	Barrio Los Pozos, Calle Suárez Arana	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
54	5211826	Víctor Hugo Román Flores	68937984	Doble Vía a La Guardia, Km 6	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
55	5212045	Fernanda Justiniano Pinto	68418590	Barrio Hamacas, Calle 4 Norte	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
56	5212264	Óscar Flores Montaño	69166514	Barrio Sirari, Calle Los Claveles	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
57	5212483	Natalia Peña Barba	76539400	Radial 26, Barrio 24 de Septiembre	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
58	5212702	Verónica Mendoza Ribera	66663136	Radial 10, Barrio 4 de Octubre	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
60	5213140	Bruno Zabala Paz	63701572	Zona Santos Dumont, 4to Anillo	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
61	5213359	Diego Armando Aguilera Añez	62984618	Barrio Guaracachi, Av. Brasil	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
62	5213578	Lucía Chávez Añez	78045792	Barrio La Cuchilla, Av. Moscú	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
63	5213797	Lucía Peña Román	76440935	Barrio Los Chacos, Calle Las Peñas	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
64	5214016	Carla Mariana Suárez Justiniano	62748619	Zona Parque Industrial, PI-12	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
65	5214235	Lucas Antelo Antelo	79069289	Av. Banzer, Km 8.5	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
\.


--
-- Data for Name: interesado_adopcions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.interesado_adopcions (id, ci, nombre, direccion, telefono, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at, estado) FROM stdin;
1	4920193	Mariana Paz Soldán	Av. San Martín #450, Barrio Equipetrol	77391029	Casa propia con patio amplio completamente cerrado.	Dra. Claudia Ríos (Veterinaria Particular) - 71000000	95	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
2	8192039	Jorge Justiniano Rivero	Calle Arenales #123, Centro	71629384	Departamento propio en 3er piso (Permite mascotas pequeñas).	Ing. Roberto Justiniano (Hermano) - 72000000	88	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
3	3920192	Valeria Aguilera Banegas	Barrio Sirari, Calle 3 #12	69012938	Casa familiar con jardín interno.	Lic. Sofía Aguilera (Madre) - 73000000	90	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
4	9201938	Fernando Roca Pinto	Av. Busch y 3er Anillo	72819203	Alquiler con autorización firmada por el propietario.	Carlos Roca (Padre) - 74000000	75	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
5	5829103	Andrea Melgar Justiniano	Urb. Las Palmas, Calle 5	75591823	Quinta con muro perimetral alto y áreas verdes.	Dra. María Melgar - 75000000	98	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
59	5212921	Juan Carlos Flores Ugarte	Barrio Urbari, Calle Mocoví	63587660	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-21 13:58:44	Pendiente
58	5212702	Verónica Mendoza Ribera	Radial 10, Barrio 4 de Octubre	66663136	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
60	5213140	Bruno Zabala Paz	Zona Santos Dumont, 4to Anillo	63701572	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
61	5213359	Diego Armando Aguilera Añez	Barrio Guaracachi, Av. Brasil	62984618	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
62	5213578	Lucía Chávez Añez	Barrio La Cuchilla, Av. Moscú	78045792	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
63	5213797	Lucía Peña Román	Barrio Los Chacos, Calle Las Peñas	76440935	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
64	5214016	Carla Mariana Suárez Justiniano	Zona Parque Industrial, PI-12	62748619	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
65	5214235	Lucas Antelo Antelo	Av. Banzer, Km 8.5	79069289	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
6	5201314	Rodrigo Salazar Montaño	Doble Vía a La Guardia, Km 6	66493086	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
7	5201533	Carla Mariana Dorado Pinto	Barrio Hamacas, Calle 4 Norte	79701323	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
8	5201752	Claudia Patricia Justiniano Chávez	Barrio Sirari, Calle Los Claveles	65946432	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
9	5201971	Fernanda Pinto Román	Radial 26, Barrio 24 de Septiembre	78164651	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
10	5202190	Alejandra Justiniano Soliz	Radial 10, Barrio 4 de Octubre	79313470	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
11	5202409	Miguel Ángel Antelo Ugarte	Barrio Urbari, Calle Mocoví	76717873	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
12	5202628	María René Mercado Hurtado	Zona Santos Dumont, 4to Anillo	71560194	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
13	5202847	Jessica Gutiérrez Ribera	Barrio Guaracachi, Av. Brasil	72002175	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
14	5203066	Laura Morales Rojas	Barrio La Cuchilla, Av. Moscú	79586141	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
15	5203285	Óscar Mercado Vargas	Barrio Los Chacos, Calle Las Peñas	68958241	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
16	5203504	Fernando Suárez Castedo	Zona Parque Industrial, PI-12	64844090	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
17	5203723	Leonardo Montaño Gutiérrez	Av. Banzer, Km 8.5	71128406	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
18	5203942	Lucas Paz Flores	Barrio Petrolero, Calle YPFB	65341881	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
19	5204161	Natalia Vargas Saucedo	Zona El Trompillo, Calle Cochabamba	65758783	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
20	5204380	Lorena Hurtado Pinto	Barrio Cordecruz, Manzano 14	71388723	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
21	5204599	Sebastián Antelo Soliz	Barrio Remanso, Calle Las Lajas	76779785	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
22	5204818	Gonzalo Dorado Condori	Barrio España, Calle Valencia	64433868	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
23	5205037	Carolina Vargas Hurtado	Barrio Magisterio, Av. Mutualista	76893470	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
24	5205256	Andrea Fabiana Justiniano Paz	Barrio Equipetrol, Calle 8 Este	67611810	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
25	5205475	Claudia Patricia Añez Barba	Barrio Las Palmas, Av. Las Palmeras	66247681	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
26	5205694	Hugo Zabala Añez	Plan 3000, Barrio El Quior	72718284	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
27	5205913	Adriana Torrico Román	Villa 1ro de Mayo, Calle 3	76576286	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
28	5206132	Jorge Luis Ribera Aguilera	Pampa de la Isla, Av. Montecristo	77520223	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
29	5206351	Adriana Aguilera Aguilera	Barrio Los Pozos, Calle Suárez Arana	68238228	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
30	5206570	Mario Alberto Peña Añez	Doble Vía a La Guardia, Km 6	77826978	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
31	5206789	Daniela Torrico Suárez	Barrio Hamacas, Calle 4 Norte	79874138	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
32	5207008	María René Castedo Castedo	Barrio Sirari, Calle Los Claveles	71578459	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
33	5207227	Jorge Luis Soliz Román	Radial 26, Barrio 24 de Septiembre	76158019	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
34	5207446	Mario Alberto Gutiérrez Pinto	Radial 10, Barrio 4 de Octubre	64136033	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
35	5207665	Juan Carlos Barba Saucedo	Barrio Urbari, Calle Mocoví	79976512	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
36	5207884	Adriana Castedo Montaño	Zona Santos Dumont, 4to Anillo	72417645	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
37	5208103	Gabriela Justiniano Saucedo	Barrio Guaracachi, Av. Brasil	79289302	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
38	5208322	Daniela Cuéllar Dorado	Barrio La Cuchilla, Av. Moscú	75835586	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
39	5208541	Mario Alberto Salazar Ugarte	Barrio Los Chacos, Calle Las Peñas	67864207	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
40	5208760	Claudia Patricia Mamani Vargas	Zona Parque Industrial, PI-12	62748166	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
41	5208979	Rodrigo Mendoza Antelo	Av. Banzer, Km 8.5	72566501	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
42	5209198	Diana Ugarte Condori	Barrio Petrolero, Calle YPFB	67712246	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
43	5209417	Marcelo Aguilera Saucedo	Zona El Trompillo, Calle Cochabamba	73549252	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
44	5209636	Lucas Peña Chávez	Barrio Cordecruz, Manzano 14	61228942	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
45	5209855	Mónica Montaño Montaño	Barrio Remanso, Calle Las Lajas	62137980	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
46	5210074	Mauricio Suárez Barba	Barrio España, Calle Valencia	73466477	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
47	5210293	Diego Armando Ribera Salazar	Barrio Magisterio, Av. Mutualista	65197362	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
48	5210512	Hugo Román Aguilera	Barrio Equipetrol, Calle 8 Este	62637432	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
49	5210731	Carlos Eduardo Chávez Aguilera	Barrio Las Palmas, Av. Las Palmeras	66917479	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
50	5210950	Claudia Patricia Morales Morales	Plan 3000, Barrio El Quior	74293324	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
51	5211169	Miguel Ángel Antelo Paz	Villa 1ro de Mayo, Calle 3	68310889	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
52	5211388	Camila Soliz Barba	Pampa de la Isla, Av. Montecristo	71797640	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
53	5211607	Tatiana Flores Montaño	Barrio Los Pozos, Calle Suárez Arana	64284806	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
54	5211826	Víctor Hugo Román Flores	Doble Vía a La Guardia, Km 6	68937984	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
55	5212045	Fernanda Justiniano Pinto	Barrio Hamacas, Calle 4 Norte	68418590	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
56	5212264	Óscar Flores Montaño	Barrio Sirari, Calle Los Claveles	69166514	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
57	5212483	Natalia Peña Barba	Radial 26, Barrio 24 de Septiembre	76539400	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:13	2026-11-01 14:00:13	Aprobado
\.


--
-- Data for Name: inventario_lotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventario_lotes (id, id_articulo, id_detalle_compra, id_detalle_donacion, fecha_vencimiento, cantidad_inicial, cantidad_disponible, cantidad_vencida, created_at, updated_at) FROM stdin;
2	52	\N	\N	2028-05-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
4	54	\N	\N	2028-09-02	25.00	25.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
5	55	\N	\N	2028-03-02	40.00	40.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
6	56	\N	\N	2028-06-02	20.00	20.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
7	57	\N	\N	2028-11-02	50.00	50.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
8	58	\N	\N	2028-04-02	55.00	55.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
9	59	\N	\N	2028-08-02	35.00	35.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
10	60	\N	\N	2028-02-02	28.00	28.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
12	62	\N	\N	2028-10-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
13	63	\N	\N	2028-05-02	42.00	42.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
14	64	\N	\N	2028-09-02	35.00	35.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
15	65	\N	\N	2028-12-02	50.00	50.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
16	66	\N	\N	2029-05-02	65.00	65.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
17	67	\N	\N	2028-07-02	24.00	24.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
18	68	\N	\N	2028-05-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
19	69	\N	\N	2028-11-02	20.00	20.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
20	70	\N	\N	2028-08-02	22.00	22.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
21	26	\N	\N	2029-03-02	55.00	55.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
22	71	\N	\N	2028-07-02	35.00	35.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
23	72	\N	\N	2028-09-02	28.00	28.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
24	73	\N	\N	2028-11-02	45.00	45.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
25	74	\N	\N	2029-07-02	50.00	50.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
26	75	\N	\N	2029-02-02	40.00	40.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
27	76	\N	\N	2028-02-02	38.00	38.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
28	77	\N	\N	2028-12-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
29	78	\N	\N	2029-04-02	60.00	60.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
30	79	\N	\N	2028-11-02	25.00	25.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
31	80	\N	\N	2029-08-02	40.00	40.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
32	81	\N	\N	2029-05-02	35.00	35.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
33	3	\N	\N	2029-03-02	45.00	45.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
34	82	\N	\N	2029-01-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
35	83	\N	\N	2028-09-02	20.00	20.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
36	84	\N	\N	2028-07-02	22.00	22.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
39	87	\N	\N	2029-05-02	75.00	75.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
40	88	\N	\N	2028-07-02	40.00	40.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
41	89	\N	\N	2028-11-02	50.00	50.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
42	90	\N	\N	2028-09-02	50.00	50.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
43	91	\N	\N	2028-12-02	40.00	40.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
44	92	\N	\N	2028-07-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
46	94	\N	\N	2028-11-02	50.00	50.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
47	95	\N	\N	2029-03-02	30.00	30.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
48	96	\N	\N	2029-07-02	35.00	35.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
49	97	\N	\N	2028-09-02	45.00	45.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
51	99	\N	\N	2028-03-02	130.00	130.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
53	101	\N	\N	2028-01-02	40.00	40.00	0.00	2026-11-02 02:45:24	2026-11-02 02:45:24
55	103	\N	\N	2029-03-02	95.00	95.00	0.00	2026-11-02 02:46:08	2026-11-02 02:46:08
56	104	\N	\N	2029-05-02	110.00	110.00	0.00	2026-11-02 02:46:08	2026-11-02 02:46:08
57	105	\N	\N	2029-01-02	80.00	80.00	0.00	2026-11-02 02:46:08	2026-11-02 02:46:08
58	106	\N	\N	2028-12-02	70.00	70.00	0.00	2026-11-02 02:46:08	2026-11-02 02:46:08
59	107	\N	\N	2029-07-02	140.00	140.00	0.00	2026-11-02 02:46:08	2026-11-02 02:46:08
60	108	\N	\N	2029-02-02	55.00	55.00	0.00	2026-11-02 02:46:08	2026-11-02 02:46:08
61	23	\N	\N	2028-11-02	65.00	65.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
62	22	\N	\N	2028-11-02	120.00	120.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
63	25	\N	\N	2028-11-02	70.00	70.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
64	28	\N	\N	2028-11-02	280.00	280.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
65	27	\N	\N	2028-11-02	320.00	320.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
66	29	\N	\N	2028-11-02	95.00	95.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
67	15	\N	\N	2028-11-02	300.00	300.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
68	14	\N	\N	2028-11-02	140.00	140.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
69	24	\N	\N	2028-11-02	110.00	110.00	0.00	2026-11-02 03:17:50	2026-11-02 03:17:50
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: mascota; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mascota (id_mascota, nombre, especie, raza, sexo, edad_aproximada, estado_actual, zona_rescate, fecha_ingreso, foto, created_at, updated_at) FROM stdin;
5	Bruno	Canino	Poodle / Caniche Mix	Macho	5 años	Adoptado	Barrio Los Pozos, Calle Suárez Arana	2025-10-17	/images/mascotas/mascota_5_bruno_poodle-caniche-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
6	Kira	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Doble Vía a La Guardia, Km 6	2025-10-21	/images/mascotas/mascota_6_kira_chihuahua-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
7	Thor	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Hamacas, Calle 4 Norte	2025-10-25	/images/mascotas/mascota_7_thor_golden-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
8	Milo	Felino	Siamés Mix	Hembra	4 meses	Disponible para Adopción	Barrio Sirari, Calle Los Claveles	2025-10-29	/images/mascotas/mascota_8_milo_siam-s-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
9	Simba	Canino	Pitbull Terrier	Macho	8 meses	En Recuperación	Radial 26, Barrio 24 de Septiembre	2025-11-02	/images/mascotas/mascota_9_simba_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
10	Daisy	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Adoptado	Radial 10, Barrio 4 de Octubre	2025-11-06	/images/mascotas/mascota_10_daisy_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
11	Firulais	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Barrio Urbari, Calle Mocoví	2025-11-10	/images/mascotas/mascota_11_firulais_labrador-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
12	Tigre	Felino	Carey	Hembra	3 años	Disponible para Adopción	Zona Santos Dumont, 4to Anillo	2025-11-14	/images/mascotas/mascota_12_tigre_carey.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
13	Oso	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Guaracachi, Av. Brasil	2025-11-18	/images/mascotas/mascota_13_oso_poodle-caniche-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
1	Toby	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Barrio Las Palmas, Av. Las Palmeras	2025-10-01	/images/mascotas/mascota_1_toby_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
14	Blanca	Canino	Chihuahua Mix	Hembra	7 meses	En Recuperación	Barrio La Cuchilla, Av. Moscú	2025-11-22	/images/mascotas/mascota_14_blanca_chihuahua-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
15	Snoopy	Canino	Golden Retriever Mix	Macho	4 años	Adoptado	Barrio Los Chacos, Calle Las Peñas	2025-11-26	/images/mascotas/mascota_15_snoopy_golden-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
16	Sombra	Felino	Persa Mix	Hembra	4 meses	Disponible para Adopción	Zona Parque Industrial, PI-12	2025-11-30	/images/mascotas/mascota_16_sombra_persa-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
17	Ragnar	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Av. Banzer, Km 8.5	2025-12-04	/images/mascotas/mascota_17_ragnar_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
18	Chispa	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Barrio Petrolero, Calle YPFB	2025-12-08	/images/mascotas/mascota_18_chispa_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
2	Lola	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Plan 3000, Barrio El Quior	2025-10-05	/images/mascotas/mascota_2_lola_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
3	Max	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Villa 1ro de Mayo, Calle 3	2025-10-09	/images/mascotas/mascota_3_max_labrador-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
4	Tom	Felino	Tabby Atigrado	Hembra	3 años	En Recuperación	Pampa de la Isla, Av. Montecristo	2025-10-13	/images/mascotas/mascota_4_tom_tabby-atigrado.jpg	2026-11-01 14:00:12.780728	2026-11-01 18:17:19
23	Zeús	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Magisterio, Av. Mutualista	2025-12-28	/images/mascotas/mascota_23_ze-s_golden-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
24	Pelusa	Felino	Angora Mix	Hembra	4 meses	En Recuperación	Barrio Equipetrol, Calle 8 Este	2026-01-01	/images/mascotas/mascota_24_pelusa_angora-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
25	Rocky	Canino	Pitbull Terrier	Macho	8 meses	Adoptado	Barrio Las Palmas, Av. Las Palmeras	2026-01-05	/images/mascotas/mascota_25_rocky_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
26	Nala	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Plan 3000, Barrio El Quior	2026-01-09	/images/mascotas/mascota_26_nala_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
27	Lucas	Canino	Labrador Retriever Mix	Macho	2 años	Adoptado	Villa 1ro de Mayo, Calle 3	2026-01-13	/images/mascotas/mascota_27_lucas_labrador-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-21 10:36:58
28	Kiara	Felino	Mestizo / Criollo	Hembra	3 años	Disponible para Adopción	Pampa de la Isla, Av. Montecristo	2026-01-17	/images/mascotas/mascota_28_kiara_mestizo-criollo.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
29	Pancho	Canino	Poodle / Caniche Mix	Macho	5 años	En Recuperación	Barrio Los Pozos, Calle Suárez Arana	2026-01-21	/images/mascotas/mascota_29_pancho_poodle-caniche-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
30	Maya	Canino	Chihuahua Mix	Hembra	7 meses	Adoptado	Doble Vía a La Guardia, Km 6	2026-01-25	/images/mascotas/mascota_30_maya_chihuahua-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
31	Teo	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Hamacas, Calle 4 Norte	2026-01-29	/images/mascotas/mascota_31_teo_golden-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
32	Luna	Felino	Tabby Atigrado	Hembra	4 meses	Disponible para Adopción	Barrio Sirari, Calle Los Claveles	2026-02-02	/images/mascotas/mascota_32_luna_tabby-atigrado.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
33	Bimba	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Radial 26, Barrio 24 de Septiembre	2026-02-06	/images/mascotas/mascota_33_bimba_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
34	Rocco	Canino	Pastor Alemán Mix	Hembra	1 año y medio	En Recuperación	Radial 10, Barrio 4 de Octubre	2026-02-10	/images/mascotas/mascota_34_rocco_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
35	Bella	Canino	Labrador Retriever Mix	Macho	2 años	Adoptado	Barrio Urbari, Calle Mocoví	2026-02-14	/images/mascotas/mascota_35_bella_labrador-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
36	Choco	Felino	Siamés Mix	Hembra	3 años	Disponible para Adopción	Zona Santos Dumont, 4to Anillo	2026-02-18	/images/mascotas/mascota_36_choco_siam-s-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
19	Capitán	Canino	Labrador Retriever Mix	Macho	2 años	En Recuperación	Zona El Trompillo, Calle Cochabamba	2025-12-12	/images/mascotas/mascota_19_capit-n_labrador-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
20	Pardo	Felino	Común Europeo	Hembra	3 años	Adoptado	Barrio Cordecruz, Manzano 14	2025-12-16	/images/mascotas/mascota_20_pardo_com-n-europeo.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
21	Balto	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Remanso, Calle Las Lajas	2025-12-20	/images/mascotas/mascota_21_balto_poodle-caniche-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
22	Canela	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Barrio España, Calle Valencia	2025-12-24	/images/mascotas/mascota_22_canela_chihuahua-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
37	Frida	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Guaracachi, Av. Brasil	2026-02-22	/images/mascotas/mascota_37_frida_poodle-caniche-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
40	Negrita	Felino	Carey	Hembra	4 meses	Adoptado	Zona Parque Industrial, PI-12	2026-03-06	/images/mascotas/mascota_40_negrita_carey.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
41	Duki	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Av. Banzer, Km 8.5	2026-03-10	/images/mascotas/mascota_41_duki_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
42	Princesa	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Barrio Petrolero, Calle YPFB	2026-03-14	/images/mascotas/mascota_42_princesa_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
43	Bobby	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Zona El Trompillo, Calle Cochabamba	2026-03-18	/images/mascotas/mascota_43_bobby_labrador-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
44	Rayo	Felino	Persa Mix	Hembra	3 años	En Recuperación	Barrio Cordecruz, Manzano 14	2026-03-22	/images/mascotas/mascota_44_rayo_persa-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
45	Oliver	Canino	Poodle / Caniche Mix	Macho	5 años	Adoptado	Barrio Remanso, Calle Las Lajas	2026-03-26	/images/mascotas/mascota_45_oliver_poodle-caniche-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
46	Fiona	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Barrio España, Calle Valencia	2026-03-30	/images/mascotas/mascota_46_fiona_chihuahua-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
47	Sam	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Magisterio, Av. Mutualista	2026-04-03	/images/mascotas/mascota_47_sam_golden-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
48	Mia	Felino	Común Europeo	Hembra	4 meses	Disponible para Adopción	Barrio Equipetrol, Calle 8 Este	2026-04-07	/images/mascotas/mascota_48_mia_com-n-europeo.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
49	Mateo	Canino	Pitbull Terrier	Macho	8 meses	En Recuperación	Barrio Las Palmas, Av. Las Palmeras	2026-04-11	/images/mascotas/mascota_49_mateo_pitbull-terrier.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
50	Dulce	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Adoptado	Plan 3000, Barrio El Quior	2026-04-15	/images/mascotas/mascota_50_dulce_pastor-alem-n-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
38	Coco	Canino	Chihuahua Mix	Hembra	7 meses	Adoptado	Barrio La Cuchilla, Av. Moscú	2026-02-26	/images/mascotas/mascota_38_coco_chihuahua-mix.jpg	2026-11-01 14:00:12.780728	2026-11-21 10:40:09
39	Manchitas	Canino	Golden Retriever Mix	Macho	4 años	En Recuperación	Barrio Los Chacos, Calle Las Peñas	2026-03-02	/images/mascotas/mascota_39_manchitas_golden-retriever-mix.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
\.


--
-- Data for Name: mascotas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mascotas (id, nombre, raza, edad, especie, estado_actual, fecha_ingreso, sexo, zona_rescate, foto, created_at, updated_at) FROM stdin;
1	Toby	Pitbull Terrier	8 meses	Canino	Disponible	2025-10-01	Macho	Barrio Las Palmas, Av. Las Palmeras	/images/mascotas/mascota_1_toby_pitbull-terrier.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Lola	Pastor Alemán Mix	1 año y medio	Canino	Disponible	2025-10-05	Hembra	Plan 3000, Barrio El Quior	/images/mascotas/mascota_2_lola_pastor-alem-n-mix.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Max	Labrador Retriever Mix	2 años	Canino	Disponible	2025-10-09	Macho	Villa 1ro de Mayo, Calle 3	/images/mascotas/mascota_3_max_labrador-retriever-mix.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Tom	Tabby Atigrado	3 años	Felino	En Recuperación	2025-10-13	Hembra	Pampa de la Isla, Av. Montecristo	/images/mascotas/mascota_4_tom_tabby-atigrado.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Bruno	Poodle / Caniche Mix	5 años	Canino	Adoptado	2025-10-17	Macho	Barrio Los Pozos, Calle Suárez Arana	/images/mascotas/mascota_5_bruno_poodle-caniche-mix.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
6	Kira	Chihuahua Mix	7 meses	Canino	Disponible	2025-10-21	Hembra	Doble Vía a La Guardia, Km 6	/images/mascotas/mascota_6_kira_chihuahua-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
17	Ragnar	Pitbull Terrier	8 meses	Canino	Disponible	2025-12-04	Macho	Av. Banzer, Km 8.5	/images/mascotas/mascota_17_ragnar_pitbull-terrier.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
18	Chispa	Pastor Alemán Mix	1 año y medio	Canino	Disponible	2025-12-08	Hembra	Barrio Petrolero, Calle YPFB	/images/mascotas/mascota_18_chispa_pastor-alem-n-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
19	Capitán	Labrador Retriever Mix	2 años	Canino	En Recuperación	2025-12-12	Macho	Zona El Trompillo, Calle Cochabamba	/images/mascotas/mascota_19_capit-n_labrador-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
20	Pardo	Común Europeo	3 años	Felino	Adoptado	2025-12-16	Hembra	Barrio Cordecruz, Manzano 14	/images/mascotas/mascota_20_pardo_com-n-europeo.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
21	Balto	Poodle / Caniche Mix	5 años	Canino	Disponible	2025-12-20	Macho	Barrio Remanso, Calle Las Lajas	/images/mascotas/mascota_21_balto_poodle-caniche-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
22	Canela	Chihuahua Mix	7 meses	Canino	Disponible	2025-12-24	Hembra	Barrio España, Calle Valencia	/images/mascotas/mascota_22_canela_chihuahua-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
7	Thor	Golden Retriever Mix	4 años	Canino	Disponible	2025-10-25	Macho	Barrio Hamacas, Calle 4 Norte	/images/mascotas/mascota_7_thor_golden-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
8	Milo	Siamés Mix	4 meses	Felino	Disponible	2025-10-29	Hembra	Barrio Sirari, Calle Los Claveles	/images/mascotas/mascota_8_milo_siam-s-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
9	Simba	Pitbull Terrier	8 meses	Canino	En Recuperación	2025-11-02	Macho	Radial 26, Barrio 24 de Septiembre	/images/mascotas/mascota_9_simba_pitbull-terrier.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
10	Daisy	Pastor Alemán Mix	1 año y medio	Canino	Adoptado	2025-11-06	Hembra	Radial 10, Barrio 4 de Octubre	/images/mascotas/mascota_10_daisy_pastor-alem-n-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
11	Firulais	Labrador Retriever Mix	2 años	Canino	Disponible	2025-11-10	Macho	Barrio Urbari, Calle Mocoví	/images/mascotas/mascota_11_firulais_labrador-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
12	Tigre	Carey	3 años	Felino	Disponible	2025-11-14	Hembra	Zona Santos Dumont, 4to Anillo	/images/mascotas/mascota_12_tigre_carey.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
13	Oso	Poodle / Caniche Mix	5 años	Canino	Disponible	2025-11-18	Macho	Barrio Guaracachi, Av. Brasil	/images/mascotas/mascota_13_oso_poodle-caniche-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
14	Blanca	Chihuahua Mix	7 meses	Canino	En Recuperación	2025-11-22	Hembra	Barrio La Cuchilla, Av. Moscú	/images/mascotas/mascota_14_blanca_chihuahua-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
15	Snoopy	Golden Retriever Mix	4 años	Canino	Adoptado	2025-11-26	Macho	Barrio Los Chacos, Calle Las Peñas	/images/mascotas/mascota_15_snoopy_golden-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
16	Sombra	Persa Mix	4 meses	Felino	Disponible	2025-11-30	Hembra	Zona Parque Industrial, PI-12	/images/mascotas/mascota_16_sombra_persa-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
27	Lucas	Labrador Retriever Mix	2 años	Canino	Adoptado	2026-01-13	Macho	Villa 1ro de Mayo, Calle 3	/images/mascotas/mascota_27_lucas_labrador-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-21 10:36:58
34	Rocco	Pastor Alemán Mix	1 año y medio	Canino	En Recuperación	2026-02-10	Hembra	Radial 10, Barrio 4 de Octubre	/images/mascotas/mascota_34_rocco_pastor-alem-n-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
41	Duki	Pitbull Terrier	8 meses	Canino	Disponible	2026-03-10	Macho	Av. Banzer, Km 8.5	/images/mascotas/mascota_41_duki_pitbull-terrier.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
35	Bella	Labrador Retriever Mix	2 años	Canino	Adoptado	2026-02-14	Macho	Barrio Urbari, Calle Mocoví	/images/mascotas/mascota_35_bella_labrador-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
36	Choco	Siamés Mix	3 años	Felino	Disponible	2026-02-18	Hembra	Zona Santos Dumont, 4to Anillo	/images/mascotas/mascota_36_choco_siam-s-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
37	Frida	Poodle / Caniche Mix	5 años	Canino	Disponible	2026-02-22	Macho	Barrio Guaracachi, Av. Brasil	/images/mascotas/mascota_37_frida_poodle-caniche-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
38	Coco	Chihuahua Mix	7 meses	Canino	Adoptado	2026-02-26	Hembra	Barrio La Cuchilla, Av. Moscú	/images/mascotas/mascota_38_coco_chihuahua-mix.jpg	2026-11-01 14:00:13	2026-11-21 10:40:09
42	Princesa	Pastor Alemán Mix	1 año y medio	Canino	Disponible	2026-03-14	Hembra	Barrio Petrolero, Calle YPFB	/images/mascotas/mascota_42_princesa_pastor-alem-n-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
43	Bobby	Labrador Retriever Mix	2 años	Canino	Disponible	2026-03-18	Macho	Zona El Trompillo, Calle Cochabamba	/images/mascotas/mascota_43_bobby_labrador-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
44	Rayo	Persa Mix	3 años	Felino	En Recuperación	2026-03-22	Hembra	Barrio Cordecruz, Manzano 14	/images/mascotas/mascota_44_rayo_persa-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
45	Oliver	Poodle / Caniche Mix	5 años	Canino	Adoptado	2026-03-26	Macho	Barrio Remanso, Calle Las Lajas	/images/mascotas/mascota_45_oliver_poodle-caniche-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
46	Fiona	Chihuahua Mix	7 meses	Canino	Disponible	2026-03-30	Hembra	Barrio España, Calle Valencia	/images/mascotas/mascota_46_fiona_chihuahua-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
48	Mia	Común Europeo	4 meses	Felino	Disponible	2026-04-07	Hembra	Barrio Equipetrol, Calle 8 Este	/images/mascotas/mascota_48_mia_com-n-europeo.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
28	Kiara	Mestizo / Criollo	3 años	Felino	Disponible	2026-01-17	Hembra	Pampa de la Isla, Av. Montecristo	/images/mascotas/mascota_28_kiara_mestizo-criollo.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
49	Mateo	Pitbull Terrier	8 meses	Canino	En Recuperación	2026-04-11	Macho	Barrio Las Palmas, Av. Las Palmeras	/images/mascotas/mascota_49_mateo_pitbull-terrier.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
50	Dulce	Pastor Alemán Mix	1 año y medio	Canino	Adoptado	2026-04-15	Hembra	Plan 3000, Barrio El Quior	/images/mascotas/mascota_50_dulce_pastor-alem-n-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
23	Zeús	Golden Retriever Mix	4 años	Canino	Disponible	2025-12-28	Macho	Barrio Magisterio, Av. Mutualista	/images/mascotas/mascota_23_ze-s_golden-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
24	Pelusa	Angora Mix	4 meses	Felino	En Recuperación	2026-01-01	Hembra	Barrio Equipetrol, Calle 8 Este	/images/mascotas/mascota_24_pelusa_angora-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
25	Rocky	Pitbull Terrier	8 meses	Canino	Adoptado	2026-01-05	Macho	Barrio Las Palmas, Av. Las Palmeras	/images/mascotas/mascota_25_rocky_pitbull-terrier.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
29	Pancho	Poodle / Caniche Mix	5 años	Canino	En Recuperación	2026-01-21	Macho	Barrio Los Pozos, Calle Suárez Arana	/images/mascotas/mascota_29_pancho_poodle-caniche-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
30	Maya	Chihuahua Mix	7 meses	Canino	Adoptado	2026-01-25	Hembra	Doble Vía a La Guardia, Km 6	/images/mascotas/mascota_30_maya_chihuahua-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
39	Manchitas	Golden Retriever Mix	4 años	Canino	En Recuperación	2026-03-02	Macho	Barrio Los Chacos, Calle Las Peñas	/images/mascotas/mascota_39_manchitas_golden-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
31	Teo	Golden Retriever Mix	4 años	Canino	Disponible	2026-01-29	Macho	Barrio Hamacas, Calle 4 Norte	/images/mascotas/mascota_31_teo_golden-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
32	Luna	Tabby Atigrado	4 meses	Felino	Disponible	2026-02-02	Hembra	Barrio Sirari, Calle Los Claveles	/images/mascotas/mascota_32_luna_tabby-atigrado.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
40	Negrita	Carey	4 meses	Felino	Adoptado	2026-03-06	Hembra	Zona Parque Industrial, PI-12	/images/mascotas/mascota_40_negrita_carey.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
47	Sam	Golden Retriever Mix	4 años	Canino	Disponible	2026-04-03	Macho	Barrio Magisterio, Av. Mutualista	/images/mascotas/mascota_47_sam_golden-retriever-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
26	Nala	Pastor Alemán Mix	1 año y medio	Canino	Disponible	2026-01-09	Hembra	Plan 3000, Barrio El Quior	/images/mascotas/mascota_26_nala_pastor-alem-n-mix.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
33	Bimba	Pitbull Terrier	8 meses	Canino	Disponible	2026-02-06	Macho	Radial 26, Barrio 24 de Septiembre	/images/mascotas/mascota_33_bimba_pitbull-terrier.jpg	2026-11-01 14:00:13	2026-11-01 14:00:13
\.


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.medicamento (id_medicamento, nombre, principio_activo, categoria_farmacologica, tipo_presentacion, via_administracion, concentracion, especie_destino, dosis_recomendada, indicacion_terapeutica, es_inyectable, lote, fecha_vencimiento, stock_actual, stock_minimo, unidad_medida, precio_unitario, created_at, updated_at) FROM stdin;
1	Enrofloxacina 10% Inyectable 100ml	Enrofloxacina	Antibiótico Fluoroquinolona	Frasco Ampolla Inyectable	Subcutánea (SC) / Intramuscular (IM)	100 mg/ml (10%)	Caninos y Felinos	5 mg/kg cada 24 horas por 5 a 7 días	Tratamiento de infecciones del tracto respiratorio, genitourinario y dérmico causadas por bacterias Gram positivas y Gram negativas.	t	ENRO-2026-01	2028-11-02	45.00	8.00	Frasco 100ml	65.00	2026-11-02 00:00:00	2026-11-02 00:00:00
2	Penicilina G Benzatínica + Procaínica 6.000.000 UI	Penicilina G Benzatínica y Procaína	Antibiótico Betalactámico	Frasco Ampolla con Diluyente	Intramuscular profunda (IM)	6.000.000 UI por vial	Caninos	20.000 a 40.000 UI/kg cada 48 a 72 horas	Infecciones bacterianas sistémicas graves, estreptococosis, heridas infectadas y tétanos en rescates clínicos.	t	PEN-6M-2026	2028-05-02	30.00	6.00	Frasco Ampolla	42.50	2026-11-02 00:00:00	2026-11-02 00:00:00
3	Ceftriaxona Sódica 1g Polvo Inyectable	Ceftriaxona Sódica	Cefalosporina de 3ra Generación	Vial Liofilizado + Solvente	Intravenosa lenta (IV) / Intramuscular (IM)	1000 mg (1 g)	Caninos y Felinos	25 a 50 mg/kg cada 12 a 24 horas	Infecciones graves del sistema nervioso central, sepsis, peritonitis, piometra y osteomielitis.	t	CEFT-1G-99	2028-07-02	60.00	10.00	Vial	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
4	Oxitetraciclina L.A. 200mg/ml Inyectable 100ml	Oxitetraciclina Larga Acción	Antibiótico Tetraciclina	Frasco Ampolla Inyectable	Intramuscular profunda (IM) / Subcutánea (SC)	200 mg/ml	Caninos	20 mg/kg cada 72 horas	Tratamiento de infecciones bacterianas agudas y crónicas, clamidiasis y anaplasmosis.	t	OXI-LA-2026	2028-09-02	25.00	5.00	Frasco 100ml	55.00	2026-11-02 00:00:00	2026-11-02 00:00:00
5	Ampicilina + Sulbactam 1.5g Inyectable	Ampicilina Sódica / Sulbactam Sódico	Aminopenicilina con Inhibidor de Betalactamasas	Vial Polvo para Reconstituir	Intravenosa (IV) / Subcutánea (SC)	1000 mg / 500 mg	Caninos y Felinos	20 a 30 mg/kg cada 8 horas	Neumonías por aspiración, mordeduras infectadas profundas, infecciones intraabdominales.	t	AMPSUL-26	2028-03-02	40.00	8.00	Vial	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
6	Gentamicina Sulfato 10% Inyectable 100ml	Gentamicina Sulfato	Antibiótico Aminoglucósido	Frasco Ampolla Inyectable	Intramuscular (IM) / Subcutánea (SC)	100 mg/ml (10%)	Caninos y Felinos	5 a 8 mg/kg cada 24 horas (monitorear función renal)	Infecciones urinarias refractarias, septicemias y heridas traumáticas expuestas.	t	GENT-10-88	2028-06-02	20.00	5.00	Frasco 100ml	48.00	2026-11-02 00:00:00	2026-11-02 00:00:00
7	Amoxicilina L.A. 15% Suspensión Inyectable 100ml	Amoxicilina Trihidrato	Penicilina Semisintética Larga Acción	Suspensión Inyectable Frasco	Intramuscular (IM) / Subcutánea (SC)	150 mg/ml (15%)	Caninos y Felinos	15 mg/kg cada 48 horas	Infecciones bacterianas del aparato digestivo, respiratorio y urogenital.	t	AMOX-LA-2026	2028-11-02	50.00	10.00	Frasco 100ml	52.00	2026-11-02 00:00:00	2026-11-02 00:00:00
8	Cefalotina Sódica 1g Polvo Inyectable	Cefalotina	Cefalosporina de 1ra Generación	Vial Inyectable Reconstituible	Intravenosa lenta (IV)	1000 mg	Caninos y Felinos	20 a 30 mg/kg cada 6 a 8 horas	Profilaxis quirúrgica pre y postoperatoria en cirugías de esterilización y traumatología.	t	CEFAL-1G-12	2028-04-02	55.00	10.00	Vial	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
9	Metronidazol 500mg/100ml Solución para Infusión	Metronidazol	Antibacteriano Nitroimidazol / Antiprotozoario	Frasco para Infusión Continua	Intravenosa por goteo lento (IV)	5 mg/ml (500mg/100ml)	Caninos y Felinos	15 a 25 mg/kg cada 12 horas	Infecciones por anaerobios estrictos, giardiasis severa y abscesos intraabdominales.	t	METRO-INF-26	2028-08-02	35.00	8.00	Frasco 100ml	28.00	2026-11-02 00:00:00	2026-11-02 00:00:00
10	Doxiciclina Inyectable 50mg/ml 50ml	Doxiciclina Hiclato	Tetraciclina de 2da Generación	Frasco Ampolla Inyectable	Intravenosa lenta (IV)	50 mg/ml	Caninos y Felinos	5 a 10 mg/kg cada 12 a 24 horas	Ehrlichiosis canina, hemoplasmosis felina, leptospirosis y neumonías atípicas.	t	DOXI-INJ-04	2028-02-02	28.00	6.00	Frasco 50ml	62.00	2026-11-02 00:00:00	2026-11-02 00:00:00
11	Meloxicam 0.5% Inyectable 20ml	Meloxicam	AINE Inhibidor selectivo COX-2	Frasco Ampolla Inyectable	Subcutánea (SC) / Intravenosa (IV)	5 mg/ml (0.5%)	Caninos y Felinos	0.2 mg/kg día inicial, 0.1 mg/kg mantenimiento	Control del dolor postoperatorio, traumatismos, osteoartritis aguda y lesiones articulares.	t	MELOX-05-26	2029-01-02	70.00	12.00	Frasco 20ml	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
12	Meloxicam 2% Inyectable 50ml	Meloxicam Concentrado	AINE Inhibidor selectivo COX-2	Frasco Ampolla Inyectable	Subcutánea (SC) / Intramuscular (IM)	20 mg/ml (2%)	Caninos Grandes	0.2 mg/kg inicial luego 0.1 mg/kg	Antiinflamatorio y analgésico de alta potencia para caninos de gran porte rescatados con fracturas.	t	MELOX-20-81	2028-10-02	30.00	5.00	Frasco 50ml	68.00	2026-11-02 00:00:00	2026-11-02 00:00:00
13	Ketoprofeno 1% Inyectable 20ml	Ketoprofeno	AINE Derivado del Ácido Propiónico	Frasco Ampolla Inyectable	Subcutánea (SC) / Intramuscular (IM)	10 mg/ml (1%)	Caninos y Felinos	2 mg/kg cada 24 horas por máximo 3 días	Alivio rápido de la inflamación musculoesquelética y dolor visceral moderado.	t	KETO-10-33	2028-05-02	42.00	8.00	Frasco 20ml	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
14	Carprofeno Inyectable 50mg/ml 20ml	Carprofeno	AINE Inhibidor selectivo COX-2	Frasco Inyectable	Subcutánea (SC) / Intravenosa (IV)	50 mg/ml	Caninos	4 mg/kg cada 24 horas o dividido cada 12 horas	Manejo del dolor y la inflamación postquirúrgica ortopédica y de tejidos blandos.	t	CARP-50-26	2028-09-02	35.00	6.00	Frasco 20ml	75.00	2026-11-02 00:00:00	2026-11-02 00:00:00
15	Dipirona (Metamizol) 50% Inyectable 50ml	Metamizol Sódico (Dipirona)	Analgésico Antipirético Espasmolítico	Frasco Ampolla Inyectable	Intravenosa lenta (IV) / Intramuscular (IM)	500 mg/ml (50%)	Caninos y Felinos	25 a 35 mg/kg cada 8 horas según necesidad	Tratamiento de fiebre alta refractaria, cólicos intestinales, dolor agudo por espasmos viscerales.	t	DIPI-50-77	2028-12-02	50.00	10.00	Frasco 50ml	32.00	2026-11-02 00:00:00	2026-11-02 00:00:00
16	Tramadol Clorhidrato 50mg/ml Inyectable 20ml	Tramadol Clorhidrato	Analgésico Opioide Atípico Sintético	Frasco Inyectable	Subcutánea (SC) / Intravenosa lenta (IV)	50 mg/ml	Caninos y Felinos	2 a 4 mg/kg cada 8 a 12 horas	Tratamiento del dolor moderado a severo oncológico, traumatismos severos y cirugías complejas.	t	TRAM-50-2026	2029-05-02	65.00	12.00	Frasco 20ml	58.00	2026-11-02 00:00:00	2026-11-02 00:00:00
17	Fentanilo Citrato 0.05mg/ml Ampolla 10ml	Fentanilo Citrato	Analgésico Opioide Potente Mu-Agonista	Ampolla de Vidrio	Intravenosa (IV) infusión continua o bolo lento	50 mcg/ml (0.05 mg/ml)	Caninos y Felinos	2 a 5 mcg/kg/hora en infusión continua (CRI)	Analgesia transquirúrgica de rescate crítico para animales politraumatizados o cirugías torácicas.	t	FENT-AMP-09	2028-07-02	24.00	4.00	Ampolla 10ml	85.00	2026-11-02 00:00:00	2026-11-02 00:00:00
18	Morfina Clorhidrato 10mg/ml Ampolla 1ml	Morfina Clorhidrato	Analgésico Narcótico Agonista Opioide Puro	Ampolla 1ml	Intramuscular (IM) / Subcutánea (SC)	10 mg/ml	Caninos	0.2 a 0.5 mg/kg cada 4 a 6 horas	Manejo del dolor agudo severo por quemaduras extensas o amputaciones de emergencia.	t	MORF-10-18	2028-05-02	30.00	5.00	Ampolla 1ml	40.00	2026-11-02 00:00:00	2026-11-02 00:00:00
19	Butorfanol Tartrato 10mg/ml Inyectable 10ml	Butorfanol Tartrato	Opioide Agonista-Antagonista / Antitusígeno	Vial Inyectable	Intravenosa (IV) / Subcutánea (SC)	10 mg/ml	Caninos y Felinos	0.1 a 0.4 mg/kg cada 4 a 8 horas	Analgesia visceral excelente y sedación combinada en felinos y cachorros caninos.	t	BUTOR-10-44	2028-11-02	20.00	4.00	Vial 10ml	92.00	2026-11-02 00:00:00	2026-11-02 00:00:00
20	Flunixin Meglumina 5% Inyectable 50ml	Flunixin Meglumina	AINE Potente No Esteroideo	Frasco Inyectable	Intravenosa (IV) lenta	50 mg/ml (5%)	Caninos	1 mg/kg cada 24 horas por máximo 2 días	Tratamiento del choque endotóxico, dolor osteoarticular agudo grave.	t	FLUN-50-61	2028-08-02	22.00	4.00	Frasco 50ml	58.00	2026-11-02 00:00:00	2026-11-02 00:00:00
21	Dexametasona 2mg/ml Inyectable 50ml	Dexametasona Fosfato Disódico	Glucocorticoide Antiinflamatorio Esteroidal	Frasco Ampolla Inyectable	Intravenosa (IV) / Intramuscular (IM)	2 mg/ml	Caninos y Felinos	0.1 a 0.5 mg/kg dosis única o cada 24 horas	Shock anafiláctico, edema cerebral por traumatismo, afecciones alérgicas agudas y urticaria.	t	DEXA-2MG-26	2029-03-02	55.00	10.00	Frasco 50ml	36.00	2026-11-02 00:00:00	2026-11-02 00:00:00
22	Betametasona Dipropionato 4mg/ml Inyectable	Betametasona	Corticosteroide Sintético	Ampolla Inyectable	Intramuscular (IM) / Subcutánea (SC)	4 mg/ml	Caninos y Felinos	0.1 a 0.2 mg/kg	Dermatitis alérgica grave por pulgas, prurito intratable y crisis alérgicas respiratorias.	t	BETA-4M-11	2028-07-02	35.00	6.00	Ampolla 5ml	30.00	2026-11-02 00:00:00	2026-11-02 00:00:00
23	Prednisolona Acetato 10mg/ml Suspensión Inyectable	Prednisolona Acetato	Glucocorticoide de Acción Intermedia	Frasco Suspensión Inyectable	Subcutánea (SC) / Intramuscular (IM)	10 mg/ml	Caninos y Felinos	0.5 a 1 mg/kg cada 24 horas	Enfermedades autoinmunes, asma felino y afecciones inflamatorias crónicas.	t	PRED-10-82	2028-09-02	28.00	5.00	Frasco 20ml	44.00	2026-11-02 00:00:00	2026-11-02 00:00:00
24	Difenhidramina Clorhidrato 10mg/ml Inyectable 20ml	Difenhidramina Clorhidrato	Antihistamínico Antagonista H1	Frasco Inyectable	Intramuscular (IM) / Subcutánea (SC)	10 mg/ml	Caninos y Felinos	1 a 2 mg/kg cada 8 a 12 horas	Picaduras de insectos, reacciones transfusionales o postvacunales agudas, rinitis alérgica.	t	DIFEN-10-26	2028-11-02	45.00	8.00	Frasco 20ml	29.00	2026-11-02 00:00:00	2026-11-02 00:00:00
25	Ketamina Clorhidrato 10% (100mg/ml) Inyectable 50ml	Ketamina Clorhidrato	Anestésico Disociativo Antagonista NMDA	Frasco Inyectable Multidosis	Intramuscular (IM) / Intravenosa (IV)	100 mg/ml (10%)	Caninos y Felinos	5 a 10 mg/kg IM / 2 a 5 mg/kg IV asociado a sedante	Inducción y mantenimiento de anestesia quirúrgica general para esterilizaciones y cirugías.	t	KETA-100-2026	2029-07-02	50.00	10.00	Frasco 50ml	110.00	2026-11-02 00:00:00	2026-11-02 00:00:00
26	Xilacina 2% Inyectable 30ml	Xilacina Clorhidrato	Sedante Agonista Alfa-2 Adrenérgico / Miorrelajante	Frasco Ampolla Inyectable	Intramuscular (IM) / Intravenosa (IV)	20 mg/ml (2%)	Caninos y Felinos	1 a 2 mg/kg IM / 0.5 a 1 mg/kg IV	Sedación profunda, analgesia y relajación muscular para curaciones, limpiezas de heridas y preanestesia.	t	XILA-20-95	2029-02-02	40.00	8.00	Frasco 30ml	64.00	2026-11-02 00:00:00	2026-11-02 00:00:00
27	Propofol 1% (10mg/ml) Emulsión Inyectable 20ml	Propofol	Anestésico General Intravenoso No Barbitúrico	Ampolla Emulsión Lipídica Blanca	Intravenosa estricta lenta (IV)	10 mg/ml (1%)	Caninos y Felinos	4 a 6 mg/kg para inducción hasta pérdida de reflejos	Inducción anestésica de recuperación rápida y suave, intubación endotraqueal segura.	t	PROP-10-33	2028-02-02	38.00	8.00	Ampolla 20ml	55.00	2026-11-02 00:00:00	2026-11-02 00:00:00
28	Midazolam 5mg/ml Inyectable 10ml	Midazolam	Benzodiacepina de Acción Corta / Anticonvulsivante	Vial Inyectable	Intravenosa (IV) / Intramuscular (IM)	5 mg/ml	Caninos y Felinos	0.2 a 0.4 mg/kg	Sedación prequirúrgica en pacientes geriátricos o cardiopatías y control del estatus epiléptico agudo.	t	MIDAZ-5M-08	2028-12-02	30.00	6.00	Vial 10ml	48.00	2026-11-02 00:00:00	2026-11-02 00:00:00
29	Diazepam 5mg/ml Inyectable Ampolla 2ml	Diazepam	Benzodiacepina Miorrelajante y Anticonvulsivo	Ampolla de Vidrio	Intravenosa lenta (IV) / Vía Rectal de Emergencia	5 mg/ml	Caninos y Felinos	0.5 a 1.0 mg/kg IV bolo lento	Detención inmediata de convulsiones por intoxicación con estricnina, organofosforados o epilepsia.	t	DIAZ-5M-26	2029-04-02	60.00	15.00	Ampolla 2ml	22.00	2026-11-02 00:00:00	2026-11-02 00:00:00
30	Acepromacina 1% Inyectable 20ml	Acepromacina Maleato	Neuroléptico Tranquilizante Fenotiazínico	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM)	10 mg/ml (1%)	Caninos	0.05 a 0.1 mg/kg	Tranquilización y reducción de estrés durante rescates de perros agresivos o con pánico.	t	ACEP-10-14	2028-11-02	25.00	5.00	Frasco 20ml	39.00	2026-11-02 00:00:00	2026-11-02 00:00:00
31	Atropina Sulfato 1% Inyectable 20ml	Atropina Sulfato	Anticolinérgico Antimuscarínico / Antídoto	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM) / Intravenosa (IV)	10 mg/ml (1%)	Caninos y Felinos	0.02 a 0.04 mg/kg (en intoxicación titular a efecto)	Prevención de bradicardia intraoperatoria y antídoto de rescate contra intoxicación por pesticidas carbamatos.	t	ATROP-1P-55	2029-08-02	40.00	8.00	Frasco 20ml	26.00	2026-11-02 00:00:00	2026-11-02 00:00:00
32	Lidocaína Clorhidrato 2% Inyectable 100ml	Lidocaína Clorhidrato sin Epinefrina	Anestésico Local y Antiarrítmico Clase Ib	Frasco Inyectable Multidosis	Infiltración local / Epidural / Intravenosa (IV)	20 mg/ml (2%)	Caninos y Felinos	1 a 2 mg/kg para infiltración local o bloqueo regional	Anestesia local infiltrativa para suturas de desgarros, bloqueos nerviosos y arritmias ventriculares.	t	LIDO-2P-2026	2029-05-02	35.00	7.00	Frasco 100ml	34.00	2026-11-02 00:00:00	2026-11-02 00:00:00
33	Ivermectina 1% Inyectable 50ml	Ivermectina	Antiparasitario Endectocida Avermectina	Frasco Ampolla Inyectable	Subcutánea estricta (SC)	10 mg/ml (1%)	Caninos y Felinos	0.2 a 0.4 mg/kg dosis única (evitar en razas Collie/pastores)	Tratamiento de sarna sarcóptica, sarna otodéctica, nematodosis gastrointestinales.	t	IVER-1P-40	2029-03-02	45.00	8.00	Frasco 50ml	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
34	Doramectina 1% Inyectable 50ml	Doramectina	Endectocida de Liberación Prolongada	Frasco Inyectable	Subcutánea (SC)	10 mg/ml (1%)	Caninos	0.2 mg/kg cada 14 a 21 días	Sarna demodécica generalizada severa, miasis cutáneas por gusano barrenador en perros de la calle.	t	DORA-1P-17	2029-01-02	30.00	5.00	Frasco 50ml	60.00	2026-11-02 00:00:00	2026-11-02 00:00:00
35	Imidocarb Dipropionato 12% Inyectable 20ml	Imidocarb Dipropionato	Hemoparasiticida Antiprotozoario	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM)	120 mg/ml (12%)	Caninos	5 a 6.6 mg/kg (repetir a los 14 días según cuadro)	Tratamiento específico de babesiosis canina (Babesia canis/gibsoni) y hepatozoonosis.	t	IMIDO-12-06	2028-09-02	20.00	4.00	Frasco 20ml	98.00	2026-11-02 00:00:00	2026-11-02 00:00:00
36	Levamisol Clorhidrato 10% Inyectable 100ml	Levamisol Clorhidrato	Antihelmíntico Inmunoestimulante	Frasco Inyectable	Subcutánea (SC)	100 mg/ml (10%)	Caninos	5 a 7.5 mg/kg dosis única	Control de nemátodos pulmonares e intestinales y estimulación inmunológica coadyuvante.	t	LEVA-10-72	2028-07-02	22.00	4.00	Frasco 100ml	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
37	Solución Ringer Lactato 500ml Bolsa Infusión	Sodio, Potasio, Calcio, Cloruro y Lactato	Cristaloide Isotónico Poliiónico Rehidratante	Bolsa para Infusión Intravenosa Estéril	Intravenosa por venoclisis (IV) / Subcutánea (SC)	Na+ 130, K+ 4, Ca++ 3, Cl- 109, Lactato 28 mEq/L	Caninos y Felinos	50 a 60 ml/kg/día mantenimiento (más reemplazo de deshidratación)	Reposición de líquidos en choque hipovolémico, deshidratación severa por parvovirus o gastroenteritis.	t	RINGER-500-26	2029-11-02	120.00	25.00	Bolsa 500ml	20.00	2026-11-02 00:00:00	2026-11-02 00:00:00
38	Solución Salina Fisiológica 0.9% Cloruro de Sodio 500ml	Cloruro de Sodio (NaCl)	Cristaloide Isotónico Normalizador Electrolítico	Bolsa para Infusión Estéril	Intravenosa (IV) / Lavado Quirúrgico	0.9% (154 mEq/L Na+ y Cl-)	Caninos y Felinos	40 a 60 ml/kg/día o según déficit hídrico	Hiponatremia, alcalosis metabólica, lavado estéril de heridas contaminadas y cavidad abdominal.	t	NACL-500-88	2029-11-02	110.00	25.00	Bolsa 500ml	18.00	2026-11-02 00:00:00	2026-11-02 00:00:00
39	Dextrosa al 5% en Solución Salina 500ml	Glucosa Monohidrato y Cloruro de Sodio	Solución Glucosalina Hidratante y Energética	Bolsa Infusión Intravenosa	Intravenosa lenta (IV)	5% Dextrosa (50 g/L)	Caninos y Felinos	30 a 50 ml/kg/día	Soporte calórico y glucémico inmediato en cachorros rescatados con hipoglucemia y desnutrición extrema.	t	DEXT-500-14	2029-05-02	75.00	15.00	Bolsa 500ml	22.00	2026-11-02 00:00:00	2026-11-02 00:00:00
40	Ranitidina Clorhidrato 25mg/ml Inyectable 20ml	Ranitidina Clorhidrato	Antiulceroso Antagonista de Receptores H2	Frasco Inyectable	Intravenosa lenta (IV) / Subcutánea (SC)	25 mg/ml	Caninos y Felinos	2 a 2.5 mg/kg cada 8 a 12 horas	Prevención y tratamiento de gastritis erosiva, úlceras gástricas y esofagitis por reflujo.	t	RANI-25-30	2028-07-02	40.00	8.00	Frasco 20ml	28.00	2026-11-02 00:00:00	2026-11-02 00:00:00
41	Omeprazol Sódico 40mg Polvo Liofilizado Inyectable	Omeprazol Sódico	Inhibidor Potente de la Bomba de Protones (IBP)	Vial Liofilizado con Solvente Reconstituyente	Intravenosa lenta (IV) en bolo de 5 minutos	40 mg por vial	Caninos y Felinos	1 mg/kg cada 12 a 24 horas	Hemorragia digestiva alta, vómitos sanguinolentos por gastroenteritis vírica y úlceras severas.	t	OMEP-40-2026	2028-11-02	50.00	10.00	Vial	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
42	Ondansetrón 2mg/ml Inyectable 20ml	Ondansetrón Clorhidrato	Antiemético Antagonista Serotoninérgico 5-HT3	Frasco Ampolla Inyectable	Intravenosa lenta (IV) / Subcutánea (SC)	2 mg/ml	Caninos y Felinos	0.2 a 0.5 mg/kg cada 8 a 12 horas	Control de vómitos incoercibles causados por parvovirus, pancreatitis aguda y uremia.	t	ONDAN-2M-19	2028-09-02	50.00	10.00	Frasco 20ml	46.00	2026-11-02 00:00:00	2026-11-02 00:00:00
43	Metoclopramida Clorhidrato 5mg/ml Inyectable 20ml	Metoclopramida Clorhidrato	Antiemético Procinético Gastrointestinal	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM) / Intravenosa (IV)	5 mg/ml	Caninos y Felinos	0.2 a 0.5 mg/kg cada 8 horas	Estimulación del vaciamiento gástrico, reflujo gastroesofágico y vómitos no obstructivos.	t	METO-5M-43	2028-12-02	40.00	8.00	Frasco 20ml	24.00	2026-11-02 00:00:00	2026-11-02 00:00:00
44	Maropitant (Cerenia) 10mg/ml Inyectable 20ml	Maropitant Citrato	Antiemético Antagonista del Receptor Neuroquinina-1 (NK-1)	Frasco Inyectable Refrigerado	Subcutánea (SC) refrigerado para menor ardor	10 mg/ml	Caninos y Felinos	1 mg/kg cada 24 horas por hasta 5 días continuos	Prevención y supresión de emesis periférica y central severa con efecto analgésico visceral.	t	MAROP-10-80	2028-07-02	30.00	5.00	Frasco 20ml	140.00	2026-11-02 00:00:00	2026-11-02 00:00:00
45	Complejo B Multivitamínico Inyectable 100ml	Tiamina (B1), Riboflavina (B2), Piridoxina (B6), Cianocobalamina (B12), Nicotinamida	Complejo Vitamínico Reconstituyente Neurotrófico	Frasco Inyectable Ámbar	Intramuscular profunda (IM) / Subcutánea (SC)	B1 10mg, B2 4mg, B6 4mg, B12 50mcg por ml	Caninos y Felinos	1 a 2 ml por animal según peso cada 48 horas	Tratamiento de anemias, convalecencia postinfecciosa, neuropatías y anorexia en rescatados.	t	COMPB-100-26	2029-05-02	60.00	10.00	Frasco 100ml	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
46	Vitamina K1 (Fitomenadiona) 10mg/ml Inyectable Ampolla 2ml	Fitomenadiona (Vitamina K1)	Factor de Coagulación Antihemorrágico	Ampolla Vidrio Ámbar	Subcutánea (SC) / Oral	10 mg/ml	Caninos y Felinos	2.5 a 5.0 mg/kg cada 12 horas por 21 a 30 días	Antídoto específico e indiscutible contra envenenamiento por raticidas anticoagulantes (Warfarina).	t	VITK-10-67	2028-11-02	50.00	12.00	Ampolla 2ml	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
47	Calcio Borogluconato con Magnesio Inyectable 100ml	Borogluconato de Calcio y Cloruro de Magnesio	Mineral Suplementario Remineralizante	Frasco Inyectable	Intravenosa muy lenta (IV) con auscultación cardíaca	Calcio elemental 20 mg/ml	Caninas Hembras en Lactancia	0.5 a 1.5 ml/kg IV muy lento durante 10 a 20 minutos	Tratamiento de eclampsia puerperal hipocalcémica (tetania de la lactancia) en perras recién paridas.	t	CALC-MAG-100	2029-03-02	30.00	6.00	Frasco 100ml	42.00	2026-11-02 00:00:00	2026-11-02 00:00:00
48	Dextrano Férrico 100mg/ml Inyectable 50ml	Hierro en forma de Dextrano Férrico	Antianémico Hematógeno	Frasco Inyectable	Intramuscular profunda (IM)	100 mg/ml Fe	Caninos y Felinos	10 a 20 mg/kg dosis única o semanal	Tratamiento de anemia ferropénica severa por infestaciones masivas de pulgas, garrapatas o anquilostomas.	t	HIERRO-100-26	2029-07-02	35.00	6.00	Frasco 50ml	40.00	2026-11-02 00:00:00	2026-11-02 00:00:00
49	Aminoácidos + Electrolitos Reconstituyente 500ml	Aminoácidos esenciales, Vitamina B y Dextrosa	Suplemento Nutricional Parenteral Coadyuvante	Frasco para Infusión	Intravenosa (IV) / Subcutánea (SC)	Solución Poliiónica con L-Arginina, L-Lisina, Glicina	Caninos y Felinos	2 a 5 ml/kg en fluidos diarios	Recuperación de animales caquécticos, inanición prolongada y quemaduras graves.	t	AMINO-500-11	2028-09-02	45.00	8.00	Frasco 500ml	50.00	2026-11-02 00:00:00	2026-11-02 00:00:00
50	Vacuna Antirrábica Canina y Felina Inyectable Rabisin 1 Dosis	Virus de la Rabia Inactivado Cepa Pasteur	Biológico Vacunal Inmunizante	Frasco Monodosis 1ml con Diluyente	Subcutánea (SC)	Mínimo 1 UI antigénica por dosis	Caninos y Felinos	1 dosis (1 ml) a partir de los 3 meses, revacunación anual	Inmunización activa obligatoria contra el virus de la rabia en animales urbanos y de albergue.	t	RAB-2026-90	2028-05-02	150.00	30.00	Dosis 1ml	25.00	2026-11-02 00:00:00	2026-11-02 00:00:00
51	Vacuna Séxtuple Canina Inyectable (DHPPi+L)	Distemper, Hepatitis, Parvovirus, Parainfluenza y Leptospira canicola/icterohaemorrhagiae	Biológico Vacunal Polivalente Canino	Vial Liofilizado + Vial Suspensión Leptospira	Subcutánea (SC)	Títulos protectores estándar OMS / OIE	Caninos	1 dosis (1 ml) a las 6, 9 y 12 semanas, refuerzo anual	Inmunización básica completa para prevenir moquillo, parvovirosis y leptospirosis canina.	t	SEXT-DHPP-26	2028-03-02	130.00	25.00	Dosis 1ml	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
52	Vacuna Triple Felina Inyectable (FVRCP)	Rinotraqueítis (Herpesvirus), Calicivirus y Panleucopenia Felina	Biológico Vacunal Felino Atenuado	Vial Monodosis con Diluyente	Subcutánea (SC)	Títulos atenuados protectores	Felinos	1 dosis a las 8 y 12 semanas, luego refuerzo anual	Prevención del complejo respiratorio viral felino y de la panleucopenia felina en albergue.	t	TRIP-FEL-2026	2028-04-02	90.00	20.00	Dosis 1ml	42.00	2026-11-02 00:00:00	2026-11-02 00:00:00
53	Suero Hiperinmune Anticanino Polivalente Inyectable 10ml	Inmunoglobulinas purificadas contra Distemper y Parvovirus Canino	Biológico Inmunoterapia Pasiva de Urgencia	Frasco Inyectable Refrigerado	Subcutánea (SC) / Intravenosa muy lenta (IV)	Anticuerpos neutralizantes de alta titulación	Caninos	1 a 2 ml/kg en estadíos iniciales de sospecha	Protección inmediata pasiva de rescates cachorros no vacunados expuestos a brotes de parvovirus o moquillo.	t	SUERO-HIP-01	2028-01-02	40.00	10.00	Frasco 10ml	120.00	2026-11-02 00:00:00	2026-11-02 00:00:00
54	Amoxicilina + Ácido Clavulánico 500mg/125mg Comprimidos	Amoxicilina Trihidrato / Clavulanato de Potasio	Antibiótico Betalactámico Oral	Caja Blíster x 20 Comprimidos	Oral (PO)	625 mg total (500mg / 125mg)	Caninos y Felinos	12.5 a 20 mg/kg cada 12 horas por 7 a 14 días	Infecciones periodontales, piodermas y heridas por mordedura tratadas ambulatoriamente.	f	AMOXCLAV-26	2028-11-02	85.00	15.00	Caja	50.00	2026-11-02 00:00:00	2026-11-02 02:46:08
55	Cefalexina 500mg Comprimidos Palatables	Cefalexina Monohidrato	Cefalosporina Oral de 1ra Generación	Caja Blíster x 30 Comprimidos	Oral (PO)	500 mg	Caninos	22 a 30 mg/kg cada 12 horas con comida	Foliculitis bacteriana superficial, pioderma profunda y cistitis bacterianas.	f	CEFA-500-44	2029-03-02	95.00	20.00	Caja	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
56	Doxiciclina 100mg Comprimidos Ranurados	Doxiciclina Monohidrato	Antibiótico Tetraciclina Oral	Caja x 20 Comprimidos	Oral (PO)	100 mg	Caninos y Felinos	10 mg/kg cada 24 horas por 28 días	Tratamiento estándar ambulatorio contra Ehrlichia canis, Mycoplasma haemofelis y Borrelia.	f	DOXI-100-26	2029-05-02	110.00	25.00	Caja	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
57	Meloxicam 1mg Comprimidos Masticables Palatables	Meloxicam	AINE Analgésico Antiartrítico Oral	Caja x 10 Comprimidos Masticables	Oral (PO)	1 mg	Caninos Pequeños y Medianos	0.1 mg/kg cada 24 horas con alimento	Manejo crónico de dolor articular y displasia de cadera en perros rescatados ancianos.	f	MELOX-1MG-71	2029-01-02	80.00	15.00	Caja	32.00	2026-11-02 00:00:00	2026-11-02 00:00:00
58	Prednisona 20mg Comprimidos	Prednisona	Corticosteroide Oral Inmunosupresor	Caja x 20 Comprimidos	Oral (PO)	20 mg	Caninos	0.5 a 2.0 mg/kg cada 12 a 24 horas (disminución gradual)	Dermatitis atópica, anemia hemolítica inmunomediada y lupus eritematoso sistémico.	f	PRED-20-55	2028-12-02	70.00	12.00	Caja	26.00	2026-11-02 00:00:00	2026-11-02 00:00:00
59	Fenbendazol 500mg Comprimidos Desparasitante	Fenbendazol	Antihelmíntico Benzimidazol Amplio Espectro	Caja x 10 Comprimidos	Oral (PO)	500 mg	Caninos y Felinos	50 mg/kg cada 24 horas durante 3 a 5 días seguidos	Eliminación completa de Toxocara, Ancylostoma, Trichuris vulpis y Giardia duodenalis.	f	FENB-500-99	2029-07-02	140.00	30.00	Caja	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
60	Silimarina + Complejo Hepático 100mg Cápsulas	Silimarina (Cardo Mariano) y Metionina	Hepatoprotector Antioxidante Regenerador Celular	Frasco x 60 Cápsulas	Oral (PO)	100 mg Silimarina activa	Caninos y Felinos	10 a 15 mg/kg cada 12 horas	Coadyuvante en daño hepático tóxico, hepatitis infecciosa y lipidosis hepática felina.	f	SILI-HEP-26	2029-02-02	55.00	10.00	Frasco	55.00	2026-11-02 00:00:00	2026-11-02 00:00:00
\.


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.medicamentos (id, id_medicamento, nombre, principio_activo, categoria_farmacologica, tipo_presentacion, via_administracion, concentracion, especie_destino, dosis_recomendada, indicacion_terapeutica, es_inyectable, lote, fecha_vencimiento, stock_actual, stock_minimo, unidad_medida, precio_unitario, created_at, updated_at) FROM stdin;
1	1	Enrofloxacina 10% Inyectable 100ml	Enrofloxacina	Antibiótico Fluoroquinolona	Frasco Ampolla Inyectable	Subcutánea (SC) / Intramuscular (IM)	100 mg/ml (10%)	Caninos y Felinos	5 mg/kg cada 24 horas por 5 a 7 días	Tratamiento de infecciones del tracto respiratorio, genitourinario y dérmico causadas por bacterias Gram positivas y Gram negativas.	t	ENRO-2026-01	2028-11-02	45.00	8.00	Frasco 100ml	65.00	2026-11-02 00:00:00	2026-11-02 00:00:00
2	2	Penicilina G Benzatínica + Procaínica 6.000.000 UI	Penicilina G Benzatínica y Procaína	Antibiótico Betalactámico	Frasco Ampolla con Diluyente	Intramuscular profunda (IM)	6.000.000 UI por vial	Caninos	20.000 a 40.000 UI/kg cada 48 a 72 horas	Infecciones bacterianas sistémicas graves, estreptococosis, heridas infectadas y tétanos en rescates clínicos.	t	PEN-6M-2026	2028-05-02	30.00	6.00	Frasco Ampolla	42.50	2026-11-02 00:00:00	2026-11-02 00:00:00
3	3	Ceftriaxona Sódica 1g Polvo Inyectable	Ceftriaxona Sódica	Cefalosporina de 3ra Generación	Vial Liofilizado + Solvente	Intravenosa lenta (IV) / Intramuscular (IM)	1000 mg (1 g)	Caninos y Felinos	25 a 50 mg/kg cada 12 a 24 horas	Infecciones graves del sistema nervioso central, sepsis, peritonitis, piometra y osteomielitis.	t	CEFT-1G-99	2028-07-02	60.00	10.00	Vial	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
4	4	Oxitetraciclina L.A. 200mg/ml Inyectable 100ml	Oxitetraciclina Larga Acción	Antibiótico Tetraciclina	Frasco Ampolla Inyectable	Intramuscular profunda (IM) / Subcutánea (SC)	200 mg/ml	Caninos	20 mg/kg cada 72 horas	Tratamiento de infecciones bacterianas agudas y crónicas, clamidiasis y anaplasmosis.	t	OXI-LA-2026	2028-09-02	25.00	5.00	Frasco 100ml	55.00	2026-11-02 00:00:00	2026-11-02 00:00:00
5	5	Ampicilina + Sulbactam 1.5g Inyectable	Ampicilina Sódica / Sulbactam Sódico	Aminopenicilina con Inhibidor de Betalactamasas	Vial Polvo para Reconstituir	Intravenosa (IV) / Subcutánea (SC)	1000 mg / 500 mg	Caninos y Felinos	20 a 30 mg/kg cada 8 horas	Neumonías por aspiración, mordeduras infectadas profundas, infecciones intraabdominales.	t	AMPSUL-26	2028-03-02	40.00	8.00	Vial	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
6	6	Gentamicina Sulfato 10% Inyectable 100ml	Gentamicina Sulfato	Antibiótico Aminoglucósido	Frasco Ampolla Inyectable	Intramuscular (IM) / Subcutánea (SC)	100 mg/ml (10%)	Caninos y Felinos	5 a 8 mg/kg cada 24 horas (monitorear función renal)	Infecciones urinarias refractarias, septicemias y heridas traumáticas expuestas.	t	GENT-10-88	2028-06-02	20.00	5.00	Frasco 100ml	48.00	2026-11-02 00:00:00	2026-11-02 00:00:00
7	7	Amoxicilina L.A. 15% Suspensión Inyectable 100ml	Amoxicilina Trihidrato	Penicilina Semisintética Larga Acción	Suspensión Inyectable Frasco	Intramuscular (IM) / Subcutánea (SC)	150 mg/ml (15%)	Caninos y Felinos	15 mg/kg cada 48 horas	Infecciones bacterianas del aparato digestivo, respiratorio y urogenital.	t	AMOX-LA-2026	2028-11-02	50.00	10.00	Frasco 100ml	52.00	2026-11-02 00:00:00	2026-11-02 00:00:00
8	8	Cefalotina Sódica 1g Polvo Inyectable	Cefalotina	Cefalosporina de 1ra Generación	Vial Inyectable Reconstituible	Intravenosa lenta (IV)	1000 mg	Caninos y Felinos	20 a 30 mg/kg cada 6 a 8 horas	Profilaxis quirúrgica pre y postoperatoria en cirugías de esterilización y traumatología.	t	CEFAL-1G-12	2028-04-02	55.00	10.00	Vial	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
9	9	Metronidazol 500mg/100ml Solución para Infusión	Metronidazol	Antibacteriano Nitroimidazol / Antiprotozoario	Frasco para Infusión Continua	Intravenosa por goteo lento (IV)	5 mg/ml (500mg/100ml)	Caninos y Felinos	15 a 25 mg/kg cada 12 horas	Infecciones por anaerobios estrictos, giardiasis severa y abscesos intraabdominales.	t	METRO-INF-26	2028-08-02	35.00	8.00	Frasco 100ml	28.00	2026-11-02 00:00:00	2026-11-02 00:00:00
10	10	Doxiciclina Inyectable 50mg/ml 50ml	Doxiciclina Hiclato	Tetraciclina de 2da Generación	Frasco Ampolla Inyectable	Intravenosa lenta (IV)	50 mg/ml	Caninos y Felinos	5 a 10 mg/kg cada 12 a 24 horas	Ehrlichiosis canina, hemoplasmosis felina, leptospirosis y neumonías atípicas.	t	DOXI-INJ-04	2028-02-02	28.00	6.00	Frasco 50ml	62.00	2026-11-02 00:00:00	2026-11-02 00:00:00
11	11	Meloxicam 0.5% Inyectable 20ml	Meloxicam	AINE Inhibidor selectivo COX-2	Frasco Ampolla Inyectable	Subcutánea (SC) / Intravenosa (IV)	5 mg/ml (0.5%)	Caninos y Felinos	0.2 mg/kg día inicial, 0.1 mg/kg mantenimiento	Control del dolor postoperatorio, traumatismos, osteoartritis aguda y lesiones articulares.	t	MELOX-05-26	2029-01-02	70.00	12.00	Frasco 20ml	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
12	12	Meloxicam 2% Inyectable 50ml	Meloxicam Concentrado	AINE Inhibidor selectivo COX-2	Frasco Ampolla Inyectable	Subcutánea (SC) / Intramuscular (IM)	20 mg/ml (2%)	Caninos Grandes	0.2 mg/kg inicial luego 0.1 mg/kg	Antiinflamatorio y analgésico de alta potencia para caninos de gran porte rescatados con fracturas.	t	MELOX-20-81	2028-10-02	30.00	5.00	Frasco 50ml	68.00	2026-11-02 00:00:00	2026-11-02 00:00:00
13	13	Ketoprofeno 1% Inyectable 20ml	Ketoprofeno	AINE Derivado del Ácido Propiónico	Frasco Ampolla Inyectable	Subcutánea (SC) / Intramuscular (IM)	10 mg/ml (1%)	Caninos y Felinos	2 mg/kg cada 24 horas por máximo 3 días	Alivio rápido de la inflamación musculoesquelética y dolor visceral moderado.	t	KETO-10-33	2028-05-02	42.00	8.00	Frasco 20ml	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
14	14	Carprofeno Inyectable 50mg/ml 20ml	Carprofeno	AINE Inhibidor selectivo COX-2	Frasco Inyectable	Subcutánea (SC) / Intravenosa (IV)	50 mg/ml	Caninos	4 mg/kg cada 24 horas o dividido cada 12 horas	Manejo del dolor y la inflamación postquirúrgica ortopédica y de tejidos blandos.	t	CARP-50-26	2028-09-02	35.00	6.00	Frasco 20ml	75.00	2026-11-02 00:00:00	2026-11-02 00:00:00
15	15	Dipirona (Metamizol) 50% Inyectable 50ml	Metamizol Sódico (Dipirona)	Analgésico Antipirético Espasmolítico	Frasco Ampolla Inyectable	Intravenosa lenta (IV) / Intramuscular (IM)	500 mg/ml (50%)	Caninos y Felinos	25 a 35 mg/kg cada 8 horas según necesidad	Tratamiento de fiebre alta refractaria, cólicos intestinales, dolor agudo por espasmos viscerales.	t	DIPI-50-77	2028-12-02	50.00	10.00	Frasco 50ml	32.00	2026-11-02 00:00:00	2026-11-02 00:00:00
16	16	Tramadol Clorhidrato 50mg/ml Inyectable 20ml	Tramadol Clorhidrato	Analgésico Opioide Atípico Sintético	Frasco Inyectable	Subcutánea (SC) / Intravenosa lenta (IV)	50 mg/ml	Caninos y Felinos	2 a 4 mg/kg cada 8 a 12 horas	Tratamiento del dolor moderado a severo oncológico, traumatismos severos y cirugías complejas.	t	TRAM-50-2026	2029-05-02	65.00	12.00	Frasco 20ml	58.00	2026-11-02 00:00:00	2026-11-02 00:00:00
17	17	Fentanilo Citrato 0.05mg/ml Ampolla 10ml	Fentanilo Citrato	Analgésico Opioide Potente Mu-Agonista	Ampolla de Vidrio	Intravenosa (IV) infusión continua o bolo lento	50 mcg/ml (0.05 mg/ml)	Caninos y Felinos	2 a 5 mcg/kg/hora en infusión continua (CRI)	Analgesia transquirúrgica de rescate crítico para animales politraumatizados o cirugías torácicas.	t	FENT-AMP-09	2028-07-02	24.00	4.00	Ampolla 10ml	85.00	2026-11-02 00:00:00	2026-11-02 00:00:00
18	18	Morfina Clorhidrato 10mg/ml Ampolla 1ml	Morfina Clorhidrato	Analgésico Narcótico Agonista Opioide Puro	Ampolla 1ml	Intramuscular (IM) / Subcutánea (SC)	10 mg/ml	Caninos	0.2 a 0.5 mg/kg cada 4 a 6 horas	Manejo del dolor agudo severo por quemaduras extensas o amputaciones de emergencia.	t	MORF-10-18	2028-05-02	30.00	5.00	Ampolla 1ml	40.00	2026-11-02 00:00:00	2026-11-02 00:00:00
19	19	Butorfanol Tartrato 10mg/ml Inyectable 10ml	Butorfanol Tartrato	Opioide Agonista-Antagonista / Antitusígeno	Vial Inyectable	Intravenosa (IV) / Subcutánea (SC)	10 mg/ml	Caninos y Felinos	0.1 a 0.4 mg/kg cada 4 a 8 horas	Analgesia visceral excelente y sedación combinada en felinos y cachorros caninos.	t	BUTOR-10-44	2028-11-02	20.00	4.00	Vial 10ml	92.00	2026-11-02 00:00:00	2026-11-02 00:00:00
20	20	Flunixin Meglumina 5% Inyectable 50ml	Flunixin Meglumina	AINE Potente No Esteroideo	Frasco Inyectable	Intravenosa (IV) lenta	50 mg/ml (5%)	Caninos	1 mg/kg cada 24 horas por máximo 2 días	Tratamiento del choque endotóxico, dolor osteoarticular agudo grave.	t	FLUN-50-61	2028-08-02	22.00	4.00	Frasco 50ml	58.00	2026-11-02 00:00:00	2026-11-02 00:00:00
21	21	Dexametasona 2mg/ml Inyectable 50ml	Dexametasona Fosfato Disódico	Glucocorticoide Antiinflamatorio Esteroidal	Frasco Ampolla Inyectable	Intravenosa (IV) / Intramuscular (IM)	2 mg/ml	Caninos y Felinos	0.1 a 0.5 mg/kg dosis única o cada 24 horas	Shock anafiláctico, edema cerebral por traumatismo, afecciones alérgicas agudas y urticaria.	t	DEXA-2MG-26	2029-03-02	55.00	10.00	Frasco 50ml	36.00	2026-11-02 00:00:00	2026-11-02 00:00:00
22	22	Betametasona Dipropionato 4mg/ml Inyectable	Betametasona	Corticosteroide Sintético	Ampolla Inyectable	Intramuscular (IM) / Subcutánea (SC)	4 mg/ml	Caninos y Felinos	0.1 a 0.2 mg/kg	Dermatitis alérgica grave por pulgas, prurito intratable y crisis alérgicas respiratorias.	t	BETA-4M-11	2028-07-02	35.00	6.00	Ampolla 5ml	30.00	2026-11-02 00:00:00	2026-11-02 00:00:00
23	23	Prednisolona Acetato 10mg/ml Suspensión Inyectable	Prednisolona Acetato	Glucocorticoide de Acción Intermedia	Frasco Suspensión Inyectable	Subcutánea (SC) / Intramuscular (IM)	10 mg/ml	Caninos y Felinos	0.5 a 1 mg/kg cada 24 horas	Enfermedades autoinmunes, asma felino y afecciones inflamatorias crónicas.	t	PRED-10-82	2028-09-02	28.00	5.00	Frasco 20ml	44.00	2026-11-02 00:00:00	2026-11-02 00:00:00
24	24	Difenhidramina Clorhidrato 10mg/ml Inyectable 20ml	Difenhidramina Clorhidrato	Antihistamínico Antagonista H1	Frasco Inyectable	Intramuscular (IM) / Subcutánea (SC)	10 mg/ml	Caninos y Felinos	1 a 2 mg/kg cada 8 a 12 horas	Picaduras de insectos, reacciones transfusionales o postvacunales agudas, rinitis alérgica.	t	DIFEN-10-26	2028-11-02	45.00	8.00	Frasco 20ml	29.00	2026-11-02 00:00:00	2026-11-02 00:00:00
25	25	Ketamina Clorhidrato 10% (100mg/ml) Inyectable 50ml	Ketamina Clorhidrato	Anestésico Disociativo Antagonista NMDA	Frasco Inyectable Multidosis	Intramuscular (IM) / Intravenosa (IV)	100 mg/ml (10%)	Caninos y Felinos	5 a 10 mg/kg IM / 2 a 5 mg/kg IV asociado a sedante	Inducción y mantenimiento de anestesia quirúrgica general para esterilizaciones y cirugías.	t	KETA-100-2026	2029-07-02	50.00	10.00	Frasco 50ml	110.00	2026-11-02 00:00:00	2026-11-02 00:00:00
26	26	Xilacina 2% Inyectable 30ml	Xilacina Clorhidrato	Sedante Agonista Alfa-2 Adrenérgico / Miorrelajante	Frasco Ampolla Inyectable	Intramuscular (IM) / Intravenosa (IV)	20 mg/ml (2%)	Caninos y Felinos	1 a 2 mg/kg IM / 0.5 a 1 mg/kg IV	Sedación profunda, analgesia y relajación muscular para curaciones, limpiezas de heridas y preanestesia.	t	XILA-20-95	2029-02-02	40.00	8.00	Frasco 30ml	64.00	2026-11-02 00:00:00	2026-11-02 00:00:00
27	27	Propofol 1% (10mg/ml) Emulsión Inyectable 20ml	Propofol	Anestésico General Intravenoso No Barbitúrico	Ampolla Emulsión Lipídica Blanca	Intravenosa estricta lenta (IV)	10 mg/ml (1%)	Caninos y Felinos	4 a 6 mg/kg para inducción hasta pérdida de reflejos	Inducción anestésica de recuperación rápida y suave, intubación endotraqueal segura.	t	PROP-10-33	2028-02-02	38.00	8.00	Ampolla 20ml	55.00	2026-11-02 00:00:00	2026-11-02 00:00:00
28	28	Midazolam 5mg/ml Inyectable 10ml	Midazolam	Benzodiacepina de Acción Corta / Anticonvulsivante	Vial Inyectable	Intravenosa (IV) / Intramuscular (IM)	5 mg/ml	Caninos y Felinos	0.2 a 0.4 mg/kg	Sedación prequirúrgica en pacientes geriátricos o cardiopatías y control del estatus epiléptico agudo.	t	MIDAZ-5M-08	2028-12-02	30.00	6.00	Vial 10ml	48.00	2026-11-02 00:00:00	2026-11-02 00:00:00
29	29	Diazepam 5mg/ml Inyectable Ampolla 2ml	Diazepam	Benzodiacepina Miorrelajante y Anticonvulsivo	Ampolla de Vidrio	Intravenosa lenta (IV) / Vía Rectal de Emergencia	5 mg/ml	Caninos y Felinos	0.5 a 1.0 mg/kg IV bolo lento	Detención inmediata de convulsiones por intoxicación con estricnina, organofosforados o epilepsia.	t	DIAZ-5M-26	2029-04-02	60.00	15.00	Ampolla 2ml	22.00	2026-11-02 00:00:00	2026-11-02 00:00:00
30	30	Acepromacina 1% Inyectable 20ml	Acepromacina Maleato	Neuroléptico Tranquilizante Fenotiazínico	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM)	10 mg/ml (1%)	Caninos	0.05 a 0.1 mg/kg	Tranquilización y reducción de estrés durante rescates de perros agresivos o con pánico.	t	ACEP-10-14	2028-11-02	25.00	5.00	Frasco 20ml	39.00	2026-11-02 00:00:00	2026-11-02 00:00:00
31	31	Atropina Sulfato 1% Inyectable 20ml	Atropina Sulfato	Anticolinérgico Antimuscarínico / Antídoto	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM) / Intravenosa (IV)	10 mg/ml (1%)	Caninos y Felinos	0.02 a 0.04 mg/kg (en intoxicación titular a efecto)	Prevención de bradicardia intraoperatoria y antídoto de rescate contra intoxicación por pesticidas carbamatos.	t	ATROP-1P-55	2029-08-02	40.00	8.00	Frasco 20ml	26.00	2026-11-02 00:00:00	2026-11-02 00:00:00
32	32	Lidocaína Clorhidrato 2% Inyectable 100ml	Lidocaína Clorhidrato sin Epinefrina	Anestésico Local y Antiarrítmico Clase Ib	Frasco Inyectable Multidosis	Infiltración local / Epidural / Intravenosa (IV)	20 mg/ml (2%)	Caninos y Felinos	1 a 2 mg/kg para infiltración local o bloqueo regional	Anestesia local infiltrativa para suturas de desgarros, bloqueos nerviosos y arritmias ventriculares.	t	LIDO-2P-2026	2029-05-02	35.00	7.00	Frasco 100ml	34.00	2026-11-02 00:00:00	2026-11-02 00:00:00
33	33	Ivermectina 1% Inyectable 50ml	Ivermectina	Antiparasitario Endectocida Avermectina	Frasco Ampolla Inyectable	Subcutánea estricta (SC)	10 mg/ml (1%)	Caninos y Felinos	0.2 a 0.4 mg/kg dosis única (evitar en razas Collie/pastores)	Tratamiento de sarna sarcóptica, sarna otodéctica, nematodosis gastrointestinales.	t	IVER-1P-40	2029-03-02	45.00	8.00	Frasco 50ml	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
34	34	Doramectina 1% Inyectable 50ml	Doramectina	Endectocida de Liberación Prolongada	Frasco Inyectable	Subcutánea (SC)	10 mg/ml (1%)	Caninos	0.2 mg/kg cada 14 a 21 días	Sarna demodécica generalizada severa, miasis cutáneas por gusano barrenador en perros de la calle.	t	DORA-1P-17	2029-01-02	30.00	5.00	Frasco 50ml	60.00	2026-11-02 00:00:00	2026-11-02 00:00:00
35	35	Imidocarb Dipropionato 12% Inyectable 20ml	Imidocarb Dipropionato	Hemoparasiticida Antiprotozoario	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM)	120 mg/ml (12%)	Caninos	5 a 6.6 mg/kg (repetir a los 14 días según cuadro)	Tratamiento específico de babesiosis canina (Babesia canis/gibsoni) y hepatozoonosis.	t	IMIDO-12-06	2028-09-02	20.00	4.00	Frasco 20ml	98.00	2026-11-02 00:00:00	2026-11-02 00:00:00
36	36	Levamisol Clorhidrato 10% Inyectable 100ml	Levamisol Clorhidrato	Antihelmíntico Inmunoestimulante	Frasco Inyectable	Subcutánea (SC)	100 mg/ml (10%)	Caninos	5 a 7.5 mg/kg dosis única	Control de nemátodos pulmonares e intestinales y estimulación inmunológica coadyuvante.	t	LEVA-10-72	2028-07-02	22.00	4.00	Frasco 100ml	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
37	37	Solución Ringer Lactato 500ml Bolsa Infusión	Sodio, Potasio, Calcio, Cloruro y Lactato	Cristaloide Isotónico Poliiónico Rehidratante	Bolsa para Infusión Intravenosa Estéril	Intravenosa por venoclisis (IV) / Subcutánea (SC)	Na+ 130, K+ 4, Ca++ 3, Cl- 109, Lactato 28 mEq/L	Caninos y Felinos	50 a 60 ml/kg/día mantenimiento (más reemplazo de deshidratación)	Reposición de líquidos en choque hipovolémico, deshidratación severa por parvovirus o gastroenteritis.	t	RINGER-500-26	2029-11-02	120.00	25.00	Bolsa 500ml	20.00	2026-11-02 00:00:00	2026-11-02 00:00:00
38	38	Solución Salina Fisiológica 0.9% Cloruro de Sodio 500ml	Cloruro de Sodio (NaCl)	Cristaloide Isotónico Normalizador Electrolítico	Bolsa para Infusión Estéril	Intravenosa (IV) / Lavado Quirúrgico	0.9% (154 mEq/L Na+ y Cl-)	Caninos y Felinos	40 a 60 ml/kg/día o según déficit hídrico	Hiponatremia, alcalosis metabólica, lavado estéril de heridas contaminadas y cavidad abdominal.	t	NACL-500-88	2029-11-02	110.00	25.00	Bolsa 500ml	18.00	2026-11-02 00:00:00	2026-11-02 00:00:00
39	39	Dextrosa al 5% en Solución Salina 500ml	Glucosa Monohidrato y Cloruro de Sodio	Solución Glucosalina Hidratante y Energética	Bolsa Infusión Intravenosa	Intravenosa lenta (IV)	5% Dextrosa (50 g/L)	Caninos y Felinos	30 a 50 ml/kg/día	Soporte calórico y glucémico inmediato en cachorros rescatados con hipoglucemia y desnutrición extrema.	t	DEXT-500-14	2029-05-02	75.00	15.00	Bolsa 500ml	22.00	2026-11-02 00:00:00	2026-11-02 00:00:00
40	40	Ranitidina Clorhidrato 25mg/ml Inyectable 20ml	Ranitidina Clorhidrato	Antiulceroso Antagonista de Receptores H2	Frasco Inyectable	Intravenosa lenta (IV) / Subcutánea (SC)	25 mg/ml	Caninos y Felinos	2 a 2.5 mg/kg cada 8 a 12 horas	Prevención y tratamiento de gastritis erosiva, úlceras gástricas y esofagitis por reflujo.	t	RANI-25-30	2028-07-02	40.00	8.00	Frasco 20ml	28.00	2026-11-02 00:00:00	2026-11-02 00:00:00
41	41	Omeprazol Sódico 40mg Polvo Liofilizado Inyectable	Omeprazol Sódico	Inhibidor Potente de la Bomba de Protones (IBP)	Vial Liofilizado con Solvente Reconstituyente	Intravenosa lenta (IV) en bolo de 5 minutos	40 mg por vial	Caninos y Felinos	1 mg/kg cada 12 a 24 horas	Hemorragia digestiva alta, vómitos sanguinolentos por gastroenteritis vírica y úlceras severas.	t	OMEP-40-2026	2028-11-02	50.00	10.00	Vial	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
42	42	Ondansetrón 2mg/ml Inyectable 20ml	Ondansetrón Clorhidrato	Antiemético Antagonista Serotoninérgico 5-HT3	Frasco Ampolla Inyectable	Intravenosa lenta (IV) / Subcutánea (SC)	2 mg/ml	Caninos y Felinos	0.2 a 0.5 mg/kg cada 8 a 12 horas	Control de vómitos incoercibles causados por parvovirus, pancreatitis aguda y uremia.	t	ONDAN-2M-19	2028-09-02	50.00	10.00	Frasco 20ml	46.00	2026-11-02 00:00:00	2026-11-02 00:00:00
43	43	Metoclopramida Clorhidrato 5mg/ml Inyectable 20ml	Metoclopramida Clorhidrato	Antiemético Procinético Gastrointestinal	Frasco Inyectable	Subcutánea (SC) / Intramuscular (IM) / Intravenosa (IV)	5 mg/ml	Caninos y Felinos	0.2 a 0.5 mg/kg cada 8 horas	Estimulación del vaciamiento gástrico, reflujo gastroesofágico y vómitos no obstructivos.	t	METO-5M-43	2028-12-02	40.00	8.00	Frasco 20ml	24.00	2026-11-02 00:00:00	2026-11-02 00:00:00
44	44	Maropitant (Cerenia) 10mg/ml Inyectable 20ml	Maropitant Citrato	Antiemético Antagonista del Receptor Neuroquinina-1 (NK-1)	Frasco Inyectable Refrigerado	Subcutánea (SC) refrigerado para menor ardor	10 mg/ml	Caninos y Felinos	1 mg/kg cada 24 horas por hasta 5 días continuos	Prevención y supresión de emesis periférica y central severa con efecto analgésico visceral.	t	MAROP-10-80	2028-07-02	30.00	5.00	Frasco 20ml	140.00	2026-11-02 00:00:00	2026-11-02 00:00:00
45	45	Complejo B Multivitamínico Inyectable 100ml	Tiamina (B1), Riboflavina (B2), Piridoxina (B6), Cianocobalamina (B12), Nicotinamida	Complejo Vitamínico Reconstituyente Neurotrófico	Frasco Inyectable Ámbar	Intramuscular profunda (IM) / Subcutánea (SC)	B1 10mg, B2 4mg, B6 4mg, B12 50mcg por ml	Caninos y Felinos	1 a 2 ml por animal según peso cada 48 horas	Tratamiento de anemias, convalecencia postinfecciosa, neuropatías y anorexia en rescatados.	t	COMPB-100-26	2029-05-02	60.00	10.00	Frasco 100ml	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
46	46	Vitamina K1 (Fitomenadiona) 10mg/ml Inyectable Ampolla 2ml	Fitomenadiona (Vitamina K1)	Factor de Coagulación Antihemorrágico	Ampolla Vidrio Ámbar	Subcutánea (SC) / Oral	10 mg/ml	Caninos y Felinos	2.5 a 5.0 mg/kg cada 12 horas por 21 a 30 días	Antídoto específico e indiscutible contra envenenamiento por raticidas anticoagulantes (Warfarina).	t	VITK-10-67	2028-11-02	50.00	12.00	Ampolla 2ml	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
47	47	Calcio Borogluconato con Magnesio Inyectable 100ml	Borogluconato de Calcio y Cloruro de Magnesio	Mineral Suplementario Remineralizante	Frasco Inyectable	Intravenosa muy lenta (IV) con auscultación cardíaca	Calcio elemental 20 mg/ml	Caninas Hembras en Lactancia	0.5 a 1.5 ml/kg IV muy lento durante 10 a 20 minutos	Tratamiento de eclampsia puerperal hipocalcémica (tetania de la lactancia) en perras recién paridas.	t	CALC-MAG-100	2029-03-02	30.00	6.00	Frasco 100ml	42.00	2026-11-02 00:00:00	2026-11-02 00:00:00
48	48	Dextrano Férrico 100mg/ml Inyectable 50ml	Hierro en forma de Dextrano Férrico	Antianémico Hematógeno	Frasco Inyectable	Intramuscular profunda (IM)	100 mg/ml Fe	Caninos y Felinos	10 a 20 mg/kg dosis única o semanal	Tratamiento de anemia ferropénica severa por infestaciones masivas de pulgas, garrapatas o anquilostomas.	t	HIERRO-100-26	2029-07-02	35.00	6.00	Frasco 50ml	40.00	2026-11-02 00:00:00	2026-11-02 00:00:00
49	49	Aminoácidos + Electrolitos Reconstituyente 500ml	Aminoácidos esenciales, Vitamina B y Dextrosa	Suplemento Nutricional Parenteral Coadyuvante	Frasco para Infusión	Intravenosa (IV) / Subcutánea (SC)	Solución Poliiónica con L-Arginina, L-Lisina, Glicina	Caninos y Felinos	2 a 5 ml/kg en fluidos diarios	Recuperación de animales caquécticos, inanición prolongada y quemaduras graves.	t	AMINO-500-11	2028-09-02	45.00	8.00	Frasco 500ml	50.00	2026-11-02 00:00:00	2026-11-02 00:00:00
50	50	Vacuna Antirrábica Canina y Felina Inyectable Rabisin 1 Dosis	Virus de la Rabia Inactivado Cepa Pasteur	Biológico Vacunal Inmunizante	Frasco Monodosis 1ml con Diluyente	Subcutánea (SC)	Mínimo 1 UI antigénica por dosis	Caninos y Felinos	1 dosis (1 ml) a partir de los 3 meses, revacunación anual	Inmunización activa obligatoria contra el virus de la rabia en animales urbanos y de albergue.	t	RAB-2026-90	2028-05-02	150.00	30.00	Dosis 1ml	25.00	2026-11-02 00:00:00	2026-11-02 00:00:00
51	51	Vacuna Séxtuple Canina Inyectable (DHPPi+L)	Distemper, Hepatitis, Parvovirus, Parainfluenza y Leptospira canicola/icterohaemorrhagiae	Biológico Vacunal Polivalente Canino	Vial Liofilizado + Vial Suspensión Leptospira	Subcutánea (SC)	Títulos protectores estándar OMS / OIE	Caninos	1 dosis (1 ml) a las 6, 9 y 12 semanas, refuerzo anual	Inmunización básica completa para prevenir moquillo, parvovirosis y leptospirosis canina.	t	SEXT-DHPP-26	2028-03-02	130.00	25.00	Dosis 1ml	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
52	52	Vacuna Triple Felina Inyectable (FVRCP)	Rinotraqueítis (Herpesvirus), Calicivirus y Panleucopenia Felina	Biológico Vacunal Felino Atenuado	Vial Monodosis con Diluyente	Subcutánea (SC)	Títulos atenuados protectores	Felinos	1 dosis a las 8 y 12 semanas, luego refuerzo anual	Prevención del complejo respiratorio viral felino y de la panleucopenia felina en albergue.	t	TRIP-FEL-2026	2028-04-02	90.00	20.00	Dosis 1ml	42.00	2026-11-02 00:00:00	2026-11-02 00:00:00
53	53	Suero Hiperinmune Anticanino Polivalente Inyectable 10ml	Inmunoglobulinas purificadas contra Distemper y Parvovirus Canino	Biológico Inmunoterapia Pasiva de Urgencia	Frasco Inyectable Refrigerado	Subcutánea (SC) / Intravenosa muy lenta (IV)	Anticuerpos neutralizantes de alta titulación	Caninos	1 a 2 ml/kg en estadíos iniciales de sospecha	Protección inmediata pasiva de rescates cachorros no vacunados expuestos a brotes de parvovirus o moquillo.	t	SUERO-HIP-01	2028-01-02	40.00	10.00	Frasco 10ml	120.00	2026-11-02 00:00:00	2026-11-02 00:00:00
54	54	Amoxicilina + Ácido Clavulánico 500mg/125mg Comprimidos	Amoxicilina Trihidrato / Clavulanato de Potasio	Antibiótico Betalactámico Oral	Caja Blíster x 20 Comprimidos	Oral (PO)	625 mg total (500mg / 125mg)	Caninos y Felinos	12.5 a 20 mg/kg cada 12 horas por 7 a 14 días	Infecciones periodontales, piodermas y heridas por mordedura tratadas ambulatoriamente.	f	AMOXCLAV-26	2028-11-02	85.00	15.00	Caja	50.00	2026-11-02 00:00:00	2026-11-02 02:46:08
55	55	Cefalexina 500mg Comprimidos Palatables	Cefalexina Monohidrato	Cefalosporina Oral de 1ra Generación	Caja Blíster x 30 Comprimidos	Oral (PO)	500 mg	Caninos	22 a 30 mg/kg cada 12 horas con comida	Foliculitis bacteriana superficial, pioderma profunda y cistitis bacterianas.	f	CEFA-500-44	2029-03-02	95.00	20.00	Caja	45.00	2026-11-02 00:00:00	2026-11-02 00:00:00
56	56	Doxiciclina 100mg Comprimidos Ranurados	Doxiciclina Monohidrato	Antibiótico Tetraciclina Oral	Caja x 20 Comprimidos	Oral (PO)	100 mg	Caninos y Felinos	10 mg/kg cada 24 horas por 28 días	Tratamiento estándar ambulatorio contra Ehrlichia canis, Mycoplasma haemofelis y Borrelia.	f	DOXI-100-26	2029-05-02	110.00	25.00	Caja	38.00	2026-11-02 00:00:00	2026-11-02 00:00:00
57	57	Meloxicam 1mg Comprimidos Masticables Palatables	Meloxicam	AINE Analgésico Antiartrítico Oral	Caja x 10 Comprimidos Masticables	Oral (PO)	1 mg	Caninos Pequeños y Medianos	0.1 mg/kg cada 24 horas con alimento	Manejo crónico de dolor articular y displasia de cadera en perros rescatados ancianos.	f	MELOX-1MG-71	2029-01-02	80.00	15.00	Caja	32.00	2026-11-02 00:00:00	2026-11-02 00:00:00
58	58	Prednisona 20mg Comprimidos	Prednisona	Corticosteroide Oral Inmunosupresor	Caja x 20 Comprimidos	Oral (PO)	20 mg	Caninos	0.5 a 2.0 mg/kg cada 12 a 24 horas (disminución gradual)	Dermatitis atópica, anemia hemolítica inmunomediada y lupus eritematoso sistémico.	f	PRED-20-55	2028-12-02	70.00	12.00	Caja	26.00	2026-11-02 00:00:00	2026-11-02 00:00:00
59	59	Fenbendazol 500mg Comprimidos Desparasitante	Fenbendazol	Antihelmíntico Benzimidazol Amplio Espectro	Caja x 10 Comprimidos	Oral (PO)	500 mg	Caninos y Felinos	50 mg/kg cada 24 horas durante 3 a 5 días seguidos	Eliminación completa de Toxocara, Ancylostoma, Trichuris vulpis y Giardia duodenalis.	f	FENB-500-99	2029-07-02	140.00	30.00	Caja	35.00	2026-11-02 00:00:00	2026-11-02 00:00:00
60	60	Silimarina + Complejo Hepático 100mg Cápsulas	Silimarina (Cardo Mariano) y Metionina	Hepatoprotector Antioxidante Regenerador Celular	Frasco x 60 Cápsulas	Oral (PO)	100 mg Silimarina activa	Caninos y Felinos	10 a 15 mg/kg cada 12 horas	Coadyuvante en daño hepático tóxico, hepatitis infecciosa y lipidosis hepática felina.	f	SILI-HEP-26	2029-02-02	55.00	10.00	Frasco	55.00	2026-11-02 00:00:00	2026-11-02 00:00:00
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2026_09_12_221455_create_bitacoras_table	1
5	2026_09_12_222537_create_mascotas_table	1
6	2026_09_12_222552_create_historial_clinicos_table	1
7	2026_09_12_222710_create_interesado_adopcions_table	1
8	2026_09_12_222746_create_adopcions_table	1
9	2026_09_12_222857_create_seguimiento_adopcions_table	1
10	2026_09_12_223015_create_donantes_table	1
11	2026_09_12_223222_create_donacions_table	1
12	2026_09_12_223258_create_tipo_aportes_table	1
13	2026_09_12_223317_create_aporte_dineros_table	1
14	2026_09_12_223413_create_articulo_inventarios_table	1
15	2026_09_12_223504_create_detalle_donacion_insumos_table	1
16	2026_09_12_223733_create_salida_inventarios_table	1
17	2026_09_12_223750_create_detalle_salidas_table	1
18	2026_09_12_223811_create_proveedors_table	1
19	2026_09_12_223828_create_compras_table	1
20	2026_09_12_223854_create_detalle_compras_table	1
21	2026_09_29_132536_create_personal_access_tokens_table	1
22	2026_09_29_132600_align_users_for_api_login	1
23	2026_09_29_154542_add_ci_to_users_table	1
24	2026_10_08_214454_add_estado_to_interesado_adopcions_table	1
25	2026_10_09_000001_add_ci_to_users_table	1
26	2026_10_10_020445_add_activo_to_users_table	1
27	2026_10_10_151815_expand_bitacoras_for_audit_retention	1
28	2026_10_14_000001_add_unique_name_to_articulo_inventarios_table	1
29	2026_10_14_195432_add_numero_documento_to_compras_and_donacions_table	1
30	2026_10_14_212114_add_historial_clinico_to_salida_inventarios_table	1
31	2026_10_14_214459_create_inventario_lotes_table	1
32	2026_10_14_220728_create_ajuste_inventarios_table	1
33	2026_10_14_222527_add_management_fields_to_proveedors_table	1
34	2026_11_02_024009_create_medicamentos_table	2
35	2026_11_05_141232_add_estado_to_proveedors_table	3
36	2026_11_13_000001_create_dosificaciones_fiscales_table	4
37	2026_11_13_000002_create_facturas_legales_table	4
38	2026_11_13_000003_create_detalle_facturas_legales_table	4
39	2026_11_13_000004_create_prescripciones_dosificacion_table	4
40	2026_11_13_000005_create_cronograma_tratamientos_table	4
41	2026_11_13_000006_create_auditoria_forense_table	4
42	2026_11_13_000007_create_facturas_compras_table	4
43	2026_11_13_000008_create_cierres_periodos_reportes_table	4
44	2026_11_13_000009_restrict_roles_to_four_actors	5
45	2026_11_16_000010_add_donante_and_postulante_roles	6
46	2026_11_21_000011_fix_all_check_constraints_and_sync_triggers	7
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
41	App\\Models\\User	6	patitas	28f252c557d327031f890ae68cdf78502a52de4a52de7f0283a75aa1bc6a78b6	["*"]	2026-11-12 21:53:06	\N	2026-11-13 01:19:50	2026-11-12 21:53:06
45	App\\Models\\User	51	public-donation	48009761dd6b9db9802d36841f6dd07d565838f569483ad2fd652caaade51754	["*"]	\N	\N	2026-11-16 20:24:37	2026-11-16 20:24:37
42	App\\Models\\User	6	patitas	31d0ea1c3e07d8a9f777efca18a95dd89aa512cddc9d811951ef5f8c9cfabe15	["*"]	2026-11-13 17:56:59	\N	2026-11-13 16:38:21	2026-11-13 17:56:59
22	App\\Models\\User	6	patitas	b352e12f6e8046357457f4434c73695ea6e4f1e8510df6fcd0f210f62a742eb8	["*"]	2026-11-10 20:51:55	\N	2026-11-10 20:26:19	2026-11-10 20:51:55
49	App\\Models\\User	6	patitas	d319e6d7dd9dfad8594255afefcab780ed7ff625b74b8fca965d92288a476800	["*"]	2026-11-17 17:15:20	\N	2026-11-17 17:04:36	2026-11-17 17:15:20
37	App\\Models\\User	6	patitas	e638e0409488f8ecc0729cd9c7b5ee1a4615aa03738ca4fa476380bee6d084c0	["*"]	2026-11-12 21:38:46	\N	2026-11-12 21:38:18	2026-11-12 21:38:46
\.


--
-- Data for Name: prescripciones_dosificacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.prescripciones_dosificacion (id, mascota_id, historial_clinico_id, articulo_id, veterinario_id, peso_mascota_kg, dosis_mg_kg, concentracion_farmaco, dosis_calculada_unidad, unidad_medida, frecuencia_horas, duracion_dias, observaciones_clinicas, estado, created_at, updated_at) FROM stdin;
1	3	\N	2	4	8.50	10.000	50.000	1.700	Bolsa	12	3	Tratamiento programado para Max con control FEFO.	COMPLETADO	2026-01-04 10:40:00	2026-01-04 10:40:00
2	4	\N	3	7	12.50	10.000	50.000	2.500	Frasco	12	3	Tratamiento programado para Tom con control FEFO.	COMPLETADO	2026-01-13 11:40:00	2026-01-13 11:40:00
3	5	\N	3	7	8.50	10.000	50.000	1.700	Frasco	12	3	Tratamiento programado para Bruno con control FEFO.	COMPLETADO	2026-02-04 10:40:00	2026-02-04 10:40:00
4	6	\N	4	8	12.50	10.000	50.000	2.500	Bidón	12	3	Tratamiento programado para Kira con control FEFO.	COMPLETADO	2026-02-13 11:40:00	2026-02-13 11:40:00
5	7	\N	4	8	8.50	10.000	50.000	1.700	Bidón	12	3	Tratamiento programado para Thor con control FEFO.	COMPLETADO	2026-03-04 10:40:00	2026-03-04 10:40:00
6	8	\N	5	9	12.50	10.000	50.000	2.500	Unidad	12	3	Tratamiento programado para Milo con control FEFO.	COMPLETADO	2026-03-13 11:40:00	2026-03-13 11:40:00
7	9	\N	5	9	8.50	10.000	50.000	1.700	Unidad	12	3	Tratamiento programado para Simba con control FEFO.	COMPLETADO	2026-04-04 10:40:00	2026-04-04 10:40:00
8	10	\N	7	10	12.50	10.000	50.000	2.500	Bolsa	12	3	Tratamiento programado para Daisy con control FEFO.	COMPLETADO	2026-04-13 11:40:00	2026-04-13 11:40:00
9	11	\N	7	10	8.50	10.000	50.000	1.700	Bolsa	12	3	Tratamiento programado para Firulais con control FEFO.	COMPLETADO	2026-05-04 10:40:00	2026-05-04 10:40:00
10	12	\N	8	11	12.50	10.000	50.000	2.500	Lata	12	3	Tratamiento programado para Tigre con control FEFO.	COMPLETADO	2026-05-13 11:40:00	2026-05-13 11:40:00
11	13	\N	8	11	8.50	10.000	50.000	1.700	Lata	12	3	Tratamiento programado para Oso con control FEFO.	COMPLETADO	2026-06-04 10:40:00	2026-06-04 10:40:00
12	14	\N	9	12	12.50	10.000	50.000	2.500	Sobre	12	3	Tratamiento programado para Blanca con control FEFO.	COMPLETADO	2026-06-13 11:40:00	2026-06-13 11:40:00
13	15	\N	9	12	8.50	10.000	50.000	1.700	Sobre	12	3	Tratamiento programado para Snoopy con control FEFO.	COMPLETADO	2026-07-04 10:40:00	2026-07-04 10:40:00
14	16	\N	10	13	12.50	10.000	50.000	2.500	Pote	12	3	Tratamiento programado para Sombra con control FEFO.	COMPLETADO	2026-07-13 11:40:00	2026-07-13 11:40:00
15	17	\N	10	13	8.50	10.000	50.000	1.700	Pote	12	3	Tratamiento programado para Ragnar con control FEFO.	COMPLETADO	2026-08-04 10:40:00	2026-08-04 10:40:00
16	18	\N	11	14	12.50	10.000	50.000	2.500	Pote	12	3	Tratamiento programado para Chispa con control FEFO.	COMPLETADO	2026-08-13 11:40:00	2026-08-13 11:40:00
17	19	\N	11	14	8.50	10.000	50.000	1.700	Pote	12	3	Tratamiento programado para Capitán con control FEFO.	COMPLETADO	2026-09-04 10:40:00	2026-09-04 10:40:00
18	20	\N	13	15	12.50	10.000	50.000	2.500	Dosis	12	3	Tratamiento programado para Pardo con control FEFO.	COMPLETADO	2026-09-13 11:40:00	2026-09-13 11:40:00
19	21	\N	13	15	8.50	10.000	50.000	1.700	Dosis	12	3	Tratamiento programado para Balto con control FEFO.	COMPLETADO	2026-10-04 10:40:00	2026-10-04 10:40:00
20	22	\N	14	2	12.50	10.000	50.000	2.500	Dosis	12	3	Tratamiento programado para Canela con control FEFO.	COMPLETADO	2026-10-13 11:40:00	2026-10-13 11:40:00
21	23	\N	14	2	8.50	10.000	50.000	1.700	Dosis	12	3	Tratamiento programado para Zeús con control FEFO.	ACTIVO	2026-11-04 10:40:00	2026-11-04 10:40:00
22	24	\N	15	4	12.50	10.000	50.000	2.500	Dosis	12	3	Tratamiento programado para Pelusa con control FEFO.	ACTIVO	2026-11-12 11:40:00	2026-11-12 11:40:00
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proveedor (id_proveedor, nombre_empresa, contacto_nombre, direccion, telefono, created_at, updated_at, estado) FROM stdin;
4	Laboratorios Drogavet Bolivia	Fernando Mercado Rojas	Villa 1ro de Mayo, Calle 3	71503712	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
5	Insumos Médicos Veterinarios San Juan	Verónica Castedo Barba	Pampa de la Isla, Av. Montecristo	67615860	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
6	Agropecuaria Cotoca Import-Export	Gabriela Suárez Torrico	Barrio Los Pozos, Calle Suárez Arana	64343864	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
7	Comercializadora Agrovet del Oriente	Marcelo Chávez Condori	Doble Vía a La Guardia, Km 6	71949329	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
8	Nutrición Animal Purina Bolivia	Marcelo Gutiérrez Pinto	Barrio Hamacas, Calle 4 Norte	67855827	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
9	Importadora Veterinaria Guabirá	Juan Carlos Torrico Salazar	Barrio Sirari, Calle Los Claveles	77159559	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
10	Distribuidora de Fármacos Vetsur	Juan Carlos Dorado Román	Radial 26, Barrio 24 de Septiembre	72024501	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
11	Clínica y Proveedora Veterinaria Urbarí	Jessica Pinto Pinto	Radial 10, Barrio 4 de Octubre	65803645	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
12	Suministros Hospitalarios Santa Cruz	Mateo Aguilera Morales	Barrio Urbari, Calle Mocoví	63297899	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
13	Química Industrial Oriente (Desinfectantes)	Andrea Fabiana Ugarte Morales	Zona Santos Dumont, 4to Anillo	72222327	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
14	Plásticos y Descartables Camba	Roberto Añez Mendoza	Barrio Guaracachi, Av. Brasil	69130329	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
15	Distribuidora de Alimentos PetFood SCZ	Gonzalo Torrico Pinto	Barrio La Cuchilla, Av. Moscú	71042996	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
16	Bayer Animal Health Bolivia	Mateo Suárez Ribera	Barrio Los Chacos, Calle Las Peñas	73539378	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
17	Zoetis Salud Animal Santa Cruz	Carlos Eduardo Chávez Vargas	Zona Parque Industrial, PI-12	71027410	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
18	Virbac Bolivia Distribuciones	Alejandra Torrico Hurtado	Av. Banzer, Km 8.5	77597914	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
19	Laboratorios Microsules Santa Cruz	Carla Mariana Cuéllar Suárez	Barrio Petrolero, Calle YPFB	77524868	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
20	Importadora FarmaOriente S.R.L.	Fernanda Aguilera Torrico	Zona El Trompillo, Calle Cochabamba	73989483	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
21	Distribuidora El Chaco Agroquímicos	Gonzalo Ribera Condori	Barrio Cordecruz, Manzano 14	76572272	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
22	Equipamientos Veterinarios del Sur	Verónica Añez Mercado	Barrio Remanso, Calle Las Lajas	65691868	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
23	Suturas e Instrumental Quirúrgico Bolivia	Leonardo Dorado Suárez	Barrio España, Calle Valencia	73557844	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
24	Distribuidora Mayorista Los Pozos	Mauricio Castedo Mamani	Barrio Magisterio, Av. Mutualista	78446121	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
25	Comercial Veterinaria La Ramada	Ramiro Castedo Cuéllar	Barrio Equipetrol, Calle 8 Este	68855660	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
26	Agroferretería y Mallas Montero	Mauricio Vargas Vargas	Barrio Las Palmas, Av. Las Palmeras	75000947	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
27	Laboratorios Biovet Santa Cruz	Gabriela Rojas Antelo	Plan 3000, Barrio El Quior	73172155	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
28	Distribuidora PetShop Las Palmas	Andrea Fabiana Condori Zabala	Villa 1ro de Mayo, Calle 3	62614526	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
29	Bioquímica Veterinaria San Gabriel	Valeria Dorado Hurtado	Pampa de la Isla, Av. Montecristo	69718135	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
30	Distribuidora de Granos y Harinas El Bajío	Fernando Gutiérrez Cuéllar	Barrio Los Pozos, Calle Suárez Arana	63246345	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
31	Importadora Médica Alemana S.R.L.	Ramiro Zabala Mendoza	Doble Vía a La Guardia, Km 6	76720779	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
32	Suministros Limpieza CleanOriente	Gabriel Añez Gutiérrez	Barrio Hamacas, Calle 4 Norte	62167273	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
33	Industrias Químicas del Oriente S.A.	Valeria Pinto Soliz	Barrio Sirari, Calle Los Claveles	68901053	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
34	Comercializadora de Vacunas InmunoVet	Víctor Hugo Román Mamani	Radial 26, Barrio 24 de Septiembre	74227296	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
35	Distribuidora Alimentos Royal Canin SCZ	Jessica Añez Mendoza	Radial 10, Barrio 4 de Octubre	74688816	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
36	Veterinaria Mayorista Cañoto	Jessica Ugarte Morales	Barrio Urbari, Calle Mocoví	65747970	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
37	Importadora Biofarm Bolivia	Valeria Flores Morales	Zona Santos Dumont, 4to Anillo	76794045	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
38	Suministros para Mascotas Animall	Daniela Cuéllar Chávez	Barrio Guaracachi, Av. Brasil	62544373	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
39	Agroveterinaria La Cuchilla	Ximena Ribera Román	Barrio La Cuchilla, Av. Moscú	69387129	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
40	Comercializadora de Forrajes y Alfalfa Warnes	Daniela Peña Dorado	Barrio Los Chacos, Calle Las Peñas	76929649	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
41	Distribuidora San Ignacio Insumos	Mauricio Justiniano Añez	Zona Parque Industrial, PI-12	71753332	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
42	Equipos Médicos BioTech Santa Cruz	Mario Alberto Dorado Dorado	Av. Banzer, Km 8.5	77729192	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
43	Distribuidora de Insumos Hospitalarios Hamacas	Bruno Gutiérrez Peña	Barrio Petrolero, Calle YPFB	66112467	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
44	Fábrica de Camas y Textil PetConfort	Adriana Ugarte Paz	Zona El Trompillo, Calle Cochabamba	67407510	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
45	Laboratorios Calier Santa Cruz	Álvaro Paz Mendoza	Barrio Cordecruz, Manzano 14	77696675	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
46	Distribuidora Farmacéutica del Oriente (DFO)	Miguel Ángel Ribera Dorado	Barrio Remanso, Calle Las Lajas	64802581	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
47	Suministros de Laboratorio BioDiagnóstico	Natalia Vargas Román	Barrio España, Calle Valencia	72880856	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
48	Agropecuaria Central Santa Cruz	Fernando Torrico Román	Barrio Magisterio, Av. Mutualista	73014034	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
49	Distribuidora Mayorista Plan 3000	Roberto Gutiérrez Añez	Barrio Equipetrol, Calle 8 Este	61717114	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
50	Servicios Integrales y Logística Veterinaria S.R.L.	Rocío Vargas Gutiérrez	Barrio Las Palmas, Av. Las Palmeras	61579476	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728	Activo
1	Veterinaria & Distribuidora El Paisano	Lic. Gonzalo Vargas	Av. Grigotá 4to Anillo	33529102	2026-11-01 14:00:12.780728	2026-11-01 18:17:19	Activo
2	Comercializadora AgroCruceña	Ing. Mario Mercado	Parque Industrial PI-34	33410293	2026-11-01 14:00:12.780728	2026-11-01 18:17:19	Activo
3	Importadora Médica Santa Cruz	Sra. Elena Claros	Calle España #240	33682910	2026-11-01 14:00:12.780728	2026-11-01 18:17:19	Activo
\.


--
-- Data for Name: proveedors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proveedors (id, nombre_empresa, nombre_contacto, telefono, direccion, created_at, updated_at, identificacion, tipo_insumo_provisto, activo, estado) FROM stdin;
4	Laboratorios Drogavet Bolivia	Fernando Mercado Rojas	71503712	Villa 1ro de Mayo, Calle 3	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000004	Insumos Veterinarios y Alimento	t	Activo
5	Insumos Médicos Veterinarios San Juan	Verónica Castedo Barba	67615860	Pampa de la Isla, Av. Montecristo	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000005	Insumos Veterinarios y Alimento	t	Activo
6	Agropecuaria Cotoca Import-Export	Gabriela Suárez Torrico	64343864	Barrio Los Pozos, Calle Suárez Arana	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000006	Insumos Veterinarios y Alimento	t	Activo
7	Comercializadora Agrovet del Oriente	Marcelo Chávez Condori	71949329	Doble Vía a La Guardia, Km 6	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000007	Insumos Veterinarios y Alimento	t	Activo
8	Nutrición Animal Purina Bolivia	Marcelo Gutiérrez Pinto	67855827	Barrio Hamacas, Calle 4 Norte	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000008	Insumos Veterinarios y Alimento	t	Activo
9	Importadora Veterinaria Guabirá	Juan Carlos Torrico Salazar	77159559	Barrio Sirari, Calle Los Claveles	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000009	Insumos Veterinarios y Alimento	t	Activo
10	Distribuidora de Fármacos Vetsur	Juan Carlos Dorado Román	72024501	Radial 26, Barrio 24 de Septiembre	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000010	Insumos Veterinarios y Alimento	t	Activo
11	Clínica y Proveedora Veterinaria Urbarí	Jessica Pinto Pinto	65803645	Radial 10, Barrio 4 de Octubre	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000011	Insumos Veterinarios y Alimento	t	Activo
12	Suministros Hospitalarios Santa Cruz	Mateo Aguilera Morales	63297899	Barrio Urbari, Calle Mocoví	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000012	Insumos Veterinarios y Alimento	t	Activo
13	Química Industrial Oriente (Desinfectantes)	Andrea Fabiana Ugarte Morales	72222327	Zona Santos Dumont, 4to Anillo	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000013	Insumos Veterinarios y Alimento	t	Activo
14	Plásticos y Descartables Camba	Roberto Añez Mendoza	69130329	Barrio Guaracachi, Av. Brasil	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000014	Insumos Veterinarios y Alimento	t	Activo
15	Distribuidora de Alimentos PetFood SCZ	Gonzalo Torrico Pinto	71042996	Barrio La Cuchilla, Av. Moscú	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000015	Insumos Veterinarios y Alimento	t	Activo
16	Bayer Animal Health Bolivia	Mateo Suárez Ribera	73539378	Barrio Los Chacos, Calle Las Peñas	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000016	Insumos Veterinarios y Alimento	t	Activo
17	Zoetis Salud Animal Santa Cruz	Carlos Eduardo Chávez Vargas	71027410	Zona Parque Industrial, PI-12	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000017	Insumos Veterinarios y Alimento	t	Activo
18	Virbac Bolivia Distribuciones	Alejandra Torrico Hurtado	77597914	Av. Banzer, Km 8.5	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000018	Insumos Veterinarios y Alimento	t	Activo
19	Laboratorios Microsules Santa Cruz	Carla Mariana Cuéllar Suárez	77524868	Barrio Petrolero, Calle YPFB	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000019	Insumos Veterinarios y Alimento	t	Activo
20	Importadora FarmaOriente S.R.L.	Fernanda Aguilera Torrico	73989483	Zona El Trompillo, Calle Cochabamba	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000020	Insumos Veterinarios y Alimento	t	Activo
21	Distribuidora El Chaco Agroquímicos	Gonzalo Ribera Condori	76572272	Barrio Cordecruz, Manzano 14	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000021	Insumos Veterinarios y Alimento	t	Activo
22	Equipamientos Veterinarios del Sur	Verónica Añez Mercado	65691868	Barrio Remanso, Calle Las Lajas	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000022	Insumos Veterinarios y Alimento	t	Activo
23	Suturas e Instrumental Quirúrgico Bolivia	Leonardo Dorado Suárez	73557844	Barrio España, Calle Valencia	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000023	Insumos Veterinarios y Alimento	t	Activo
24	Distribuidora Mayorista Los Pozos	Mauricio Castedo Mamani	78446121	Barrio Magisterio, Av. Mutualista	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000024	Insumos Veterinarios y Alimento	t	Activo
25	Comercial Veterinaria La Ramada	Ramiro Castedo Cuéllar	68855660	Barrio Equipetrol, Calle 8 Este	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000025	Insumos Veterinarios y Alimento	t	Activo
26	Agroferretería y Mallas Montero	Mauricio Vargas Vargas	75000947	Barrio Las Palmas, Av. Las Palmeras	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000026	Insumos Veterinarios y Alimento	t	Activo
27	Laboratorios Biovet Santa Cruz	Gabriela Rojas Antelo	73172155	Plan 3000, Barrio El Quior	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000027	Insumos Veterinarios y Alimento	t	Activo
28	Distribuidora PetShop Las Palmas	Andrea Fabiana Condori Zabala	62614526	Villa 1ro de Mayo, Calle 3	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000028	Insumos Veterinarios y Alimento	t	Activo
29	Bioquímica Veterinaria San Gabriel	Valeria Dorado Hurtado	69718135	Pampa de la Isla, Av. Montecristo	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000029	Insumos Veterinarios y Alimento	t	Activo
30	Distribuidora de Granos y Harinas El Bajío	Fernando Gutiérrez Cuéllar	63246345	Barrio Los Pozos, Calle Suárez Arana	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000030	Insumos Veterinarios y Alimento	t	Activo
31	Importadora Médica Alemana S.R.L.	Ramiro Zabala Mendoza	76720779	Doble Vía a La Guardia, Km 6	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000031	Insumos Veterinarios y Alimento	t	Activo
32	Suministros Limpieza CleanOriente	Gabriel Añez Gutiérrez	62167273	Barrio Hamacas, Calle 4 Norte	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000032	Insumos Veterinarios y Alimento	t	Activo
33	Industrias Químicas del Oriente S.A.	Valeria Pinto Soliz	68901053	Barrio Sirari, Calle Los Claveles	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000033	Insumos Veterinarios y Alimento	t	Activo
34	Comercializadora de Vacunas InmunoVet	Víctor Hugo Román Mamani	74227296	Radial 26, Barrio 24 de Septiembre	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000034	Insumos Veterinarios y Alimento	t	Activo
35	Distribuidora Alimentos Royal Canin SCZ	Jessica Añez Mendoza	74688816	Radial 10, Barrio 4 de Octubre	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000035	Insumos Veterinarios y Alimento	t	Activo
36	Veterinaria Mayorista Cañoto	Jessica Ugarte Morales	65747970	Barrio Urbari, Calle Mocoví	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000036	Insumos Veterinarios y Alimento	t	Activo
37	Importadora Biofarm Bolivia	Valeria Flores Morales	76794045	Zona Santos Dumont, 4to Anillo	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000037	Insumos Veterinarios y Alimento	t	Activo
38	Suministros para Mascotas Animall	Daniela Cuéllar Chávez	62544373	Barrio Guaracachi, Av. Brasil	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000038	Insumos Veterinarios y Alimento	t	Activo
39	Agroveterinaria La Cuchilla	Ximena Ribera Román	69387129	Barrio La Cuchilla, Av. Moscú	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000039	Insumos Veterinarios y Alimento	t	Activo
40	Comercializadora de Forrajes y Alfalfa Warnes	Daniela Peña Dorado	76929649	Barrio Los Chacos, Calle Las Peñas	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000040	Insumos Veterinarios y Alimento	t	Activo
2	Comercializadora AgroCruceña	Ing. Mario Mercado	33410293	Parque Industrial PI-34	2026-11-01 18:17:19	2026-11-01 18:17:19	NIT-1000002	Insumos Veterinarios y Alimento	t	Activo
3	Importadora Médica Santa Cruz	Sra. Elena Claros	33682910	Calle España #240	2026-11-01 18:17:19	2026-11-01 18:17:19	NIT-1000003	Insumos Veterinarios y Alimento	t	Activo
41	Distribuidora San Ignacio Insumos	Mauricio Justiniano Añez	71753332	Zona Parque Industrial, PI-12	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000041	Insumos Veterinarios y Alimento	t	Activo
42	Equipos Médicos BioTech Santa Cruz	Mario Alberto Dorado Dorado	77729192	Av. Banzer, Km 8.5	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000042	Insumos Veterinarios y Alimento	t	Activo
43	Distribuidora de Insumos Hospitalarios Hamacas	Bruno Gutiérrez Peña	66112467	Barrio Petrolero, Calle YPFB	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000043	Insumos Veterinarios y Alimento	t	Activo
44	Fábrica de Camas y Textil PetConfort	Adriana Ugarte Paz	67407510	Zona El Trompillo, Calle Cochabamba	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000044	Insumos Veterinarios y Alimento	t	Activo
45	Laboratorios Calier Santa Cruz	Álvaro Paz Mendoza	77696675	Barrio Cordecruz, Manzano 14	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000045	Insumos Veterinarios y Alimento	t	Activo
46	Distribuidora Farmacéutica del Oriente (DFO)	Miguel Ángel Ribera Dorado	64802581	Barrio Remanso, Calle Las Lajas	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000046	Insumos Veterinarios y Alimento	t	Activo
47	Suministros de Laboratorio BioDiagnóstico	Natalia Vargas Román	72880856	Barrio España, Calle Valencia	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000047	Insumos Veterinarios y Alimento	t	Activo
48	Agropecuaria Central Santa Cruz	Fernando Torrico Román	73014034	Barrio Magisterio, Av. Mutualista	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000048	Insumos Veterinarios y Alimento	t	Activo
49	Distribuidora Mayorista Plan 3000	Roberto Gutiérrez Añez	61717114	Barrio Equipetrol, Calle 8 Este	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000049	Insumos Veterinarios y Alimento	t	Activo
50	Servicios Integrales y Logística Veterinaria S.R.L.	Rocío Vargas Gutiérrez	61579476	Barrio Las Palmas, Av. Las Palmeras	2026-11-01 14:00:13	2026-11-01 14:00:13	NIT-1000050	Insumos Veterinarios y Alimento	t	Activo
1	Veterinaria & Distribuidora El Paisano	Lic. Gonzalo Vargas	33529102	Av. Grigotá 4to Anillo	2026-11-01 18:17:19	2026-11-01 18:17:19	NIT-1000001	Insumos Veterinarios y Alimento	t	Activo
\.


--
-- Data for Name: rol_permiso; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rol_permiso (id_rol, nombre_rol, descripcion, permisos_modulos, created_at) FROM stdin;
1	Administrador General	Control total del sistema, auditoría, reportes y configuración	TODOS	2026-11-01 14:00:12.780728
2	Supervisor de Refugio	Supervisión de operaciones diarias, inventario y bienestar	RESCATE,CLINICA,INVENTARIO,ADOPCIONES	2026-11-01 14:00:12.780728
3	Veterinario Jefe	Responsable de diagnósticos médicos, cirugías y farmacología	CLINICA,RESCATE,INVENTARIO	2026-11-01 14:00:12.780728
4	Veterinario de Turno Mañana	Atención médica clínica matutina y vacunación	CLINICA,RESCATE	2026-11-01 14:00:12.780728
5	Veterinario de Turno Tarde	Atención médica clínica vespertina y curaciones	CLINICA,RESCATE	2026-11-01 14:00:12.780728
6	Veterinario de Guardia Nocturna	Atención de emergencias críticas y monitoreo de internados	CLINICA,RESCATE	2026-11-01 14:00:12.780728
7	Cirujano Veterinario	Esterilizaciones masivas y cirugías reconstructivas	CLINICA,RESCATE	2026-11-01 14:00:12.780728
8	Auxiliar Veterinario 1	Apoyo en medicación, toma de temperatura y sujeción	CLINICA	2026-11-01 14:00:12.780728
9	Auxiliar Veterinario 2	Apoyo en preparación de quirófano y desparasitaciones	CLINICA	2026-11-01 14:00:12.780728
10	Recepcionista Principal	Registro de ingresos, atención a postulantes y donantes	RESCATE,ADOPCIONES,DONACIONES	2026-11-01 14:00:12.780728
11	Recepcionista Turno Tarde	Atención al público vespertino y recepción de donaciones	RESCATE,ADOPCIONES,DONACIONES	2026-11-01 14:00:12.780728
12	Encargado de Adopciones	Coordinación del programa de adopciones y contratos	ADOPCIONES,RESCATE	2026-11-01 14:00:12.780728
13	Evaluador de Adopciones 1	Entrevistas de idoneidad y scoring de vivienda	ADOPCIONES	2026-11-01 14:00:12.780728
14	Evaluador de Adopciones 2	Revisión de antecedentes y verificación de referencias	ADOPCIONES	2026-11-01 14:00:12.780728
15	Inspector de Seguimiento 1	Visitas domiciliarias de control post-adopción a 30 días	ADOPCIONES	2026-11-01 14:00:12.780728
16	Inspector de Seguimiento 2	Visitas domiciliarias de control post-adopción a 90 días	ADOPCIONES	2026-11-01 14:00:12.780728
17	Inspector de Seguimiento 3	Visitas domiciliarias de control post-adopción a 180 días	ADOPCIONES	2026-11-01 14:00:12.780728
18	Jefe de Almacén y Despensa	Control maestro de existencias, compras y recepción de carga	INVENTARIO,COMPRAS,PROVEEDORES	2026-11-01 14:00:12.780728
19	Auxiliar de Almacén	Despacho de alimentos y balance de existencias	INVENTARIO	2026-11-01 14:00:12.780728
20	Encargado de Compras	Gestión de pedidos con proveedores y cotizaciones	COMPRAS,PROVEEDORES	2026-11-01 14:00:12.780728
21	Encargado de Donaciones Monetarias	Control de pasarela QR, transferencias bancarias y recibos	DONACIONES,FINANZAS	2026-11-01 14:00:12.780728
22	Encargado de Donaciones en Especie	Recepción y clasificación de insumos y alimentos donados	DONACIONES,INVENTARIO	2026-11-01 14:00:12.780728
23	Auditor Interno	Consulta forense de bitácora y trazabilidad de operaciones	AUDITORIA,REPORTES	2026-11-01 14:00:12.780728
24	Coordinador de Voluntarios	Organización de turnos de paseos, limpieza y alimentación	RESCATE,VOLUNTARIADO	2026-11-01 14:00:12.780728
25	Conductor Unidad de Rescate 1	Operador de camioneta de rescate en zonas urbanas	RESCATE	2026-11-01 14:00:12.780728
26	Conductor Unidad de Rescate 2	Operador de camioneta de rescate en zonas periurbanas	RESCATE	2026-11-01 14:00:12.780728
27	Rescatista Canino de Campo	Captura humanitaria y traslado de caninos en emergencia	RESCATE	2026-11-01 14:00:12.780728
28	Rescatista Felino de Campo	Captura humanitaria y rescate en altura de felinos	RESCATE	2026-11-01 14:00:12.780728
29	Cuidador Canil Sector A	Alimentación e higiene de caniles de cuarentena	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
30	Cuidador Canil Sector B	Alimentación e higiene de caniles de recuperación	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
31	Cuidador Canil Sector C	Alimentación e higiene de perros listos para adopción	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
32	Cuidador Canil Sector D	Cuidado de cachorros y hembras en lactancia	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
33	Cuidador Canil Sector E	Cuidado de perros geriátricos o con discapacidad	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
34	Cuidador Gaterío Sector 1	Higiene y enriquecimiento ambiental de felinos adultos	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
35	Cuidador Gaterío Sector 2	Cuidado de gatitos neonatos y nodrizas	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
36	Encargado de Limpieza y Bioseguridad	Desinfección hospitalaria y manejo de residuos biológicos	INVENTARIO_CONSUMO	2026-11-01 14:00:12.780728
37	Nutricionista Animal	Formulación de dietas blandas y medicadas	CLINICA,INVENTARIO	2026-11-01 14:00:12.780728
38	Etólogo / Educador Canino	Rehabilitación de conducta y socialización para adopción	ADOPCIONES	2026-11-01 14:00:12.780728
39	Community Manager / Difusión	Publicación de casos de rescate y fichas de adopción	ADOPCIONES,DONACIONES	2026-11-01 14:00:12.780728
40	Fotógrafo de Mascotas	Sesiones fotográficas para perfiles de adopción	RESCATE,ADOPCIONES	2026-11-01 14:00:12.780728
41	Asistente Administrativo	Archivo de expedientes físicos y facturación	ADMINISTRACION	2026-11-01 14:00:12.780728
42	Gestor de Apadrinamientos	Seguimiento a donantes recurrentes y reportes de ahijados	DONACIONES	2026-11-01 14:00:12.780728
43	Asesor Legal Pro-Bono	Denuncias por maltrato animal y contratos legales	LEGAL	2026-11-01 14:00:12.780728
44	Operador de Call Center	Atención a reportes ciudadanos de abandono	RESCATE	2026-11-01 14:00:12.780728
45	Encargado de Farmacia Veterinaria	Custodia de estupefacientes y control de caducidades	INVENTARIO,CLINICA	2026-11-01 14:00:12.780728
46	Supervisor de Mermas y Descarte	Auditoría de alimentos vencidos o bolsas dañadas	INVENTARIO	2026-11-01 14:00:12.780728
47	Coordinador de Ferias de Adopción	Organización de eventos dominicales en parques de Santa Cruz	ADOPCIONES	2026-11-01 14:00:12.780728
48	Técnico de Soporte TI	Mantenimiento del servidor web, PostgreSQL y red	SISTEMAS	2026-11-01 14:00:12.780728
49	Analista de Datos / BI	Generación de indicadores gerenciales y tasas de adopción	REPORTES	2026-11-01 14:00:12.780728
50	Director Ejecutivo de Fundación	Representación legal y toma de decisiones estratégicas	TODOS	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: salida_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.salida_inventario (id_salida, id_usuario, fecha_salida, motivo, created_at, updated_at) FROM stdin;
1	2	2026-07-06	Consumo diario de alimento balanceado Caniles Sector B (Lote #1)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	3	2026-07-08	Consumo diario de alimento balanceado Caniles Sector C (Lote #2)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	4	2026-07-10	Despacho de desinfectantes y lavandina para bioseguridad (Lote #3)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	5	2026-07-12	Atención médica de urgencia en consultorio veterinario (Lote #4)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	6	2026-07-14	Jornada de vacunación y desparasitación masiva (Lote #5)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	7	2026-07-16	Alimentación especial de cachorros en guardería neonatal (Lote #6)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	8	2026-07-18	Curaciones y cambio de vendajes en área de internación (Lote #7)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	1	2026-07-20	Entrega de mantas y platos a nuevos caniles habilitados (Lote #8)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	2	2026-07-22	Consumo de arena sanitaria en gaterío sector 1 (Lote #9)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	3	2026-07-24	Consumo diario de alimento balanceado Caniles Sector A (Lote #10)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	4	2026-07-26	Consumo diario de alimento balanceado Caniles Sector B (Lote #11)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	5	2026-07-28	Consumo diario de alimento balanceado Caniles Sector C (Lote #12)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	6	2026-07-30	Despacho de desinfectantes y lavandina para bioseguridad (Lote #13)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	7	2026-08-01	Atención médica de urgencia en consultorio veterinario (Lote #14)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	8	2026-08-03	Jornada de vacunación y desparasitación masiva (Lote #15)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	1	2026-08-05	Alimentación especial de cachorros en guardería neonatal (Lote #16)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	2	2026-08-07	Curaciones y cambio de vendajes en área de internación (Lote #17)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	3	2026-08-09	Entrega de mantas y platos a nuevos caniles habilitados (Lote #18)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	4	2026-08-11	Consumo de arena sanitaria en gaterío sector 1 (Lote #19)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	5	2026-08-13	Consumo diario de alimento balanceado Caniles Sector A (Lote #20)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	6	2026-08-15	Consumo diario de alimento balanceado Caniles Sector B (Lote #21)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	7	2026-08-17	Consumo diario de alimento balanceado Caniles Sector C (Lote #22)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	8	2026-08-19	Despacho de desinfectantes y lavandina para bioseguridad (Lote #23)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	1	2026-08-21	Atención médica de urgencia en consultorio veterinario (Lote #24)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	2	2026-08-23	Jornada de vacunación y desparasitación masiva (Lote #25)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	3	2026-08-25	Alimentación especial de cachorros en guardería neonatal (Lote #26)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	4	2026-08-27	Curaciones y cambio de vendajes en área de internación (Lote #27)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	5	2026-08-29	Entrega de mantas y platos a nuevos caniles habilitados (Lote #28)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	6	2026-08-31	Consumo de arena sanitaria en gaterío sector 1 (Lote #29)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	7	2026-09-02	Consumo diario de alimento balanceado Caniles Sector A (Lote #30)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	8	2026-09-04	Consumo diario de alimento balanceado Caniles Sector B (Lote #31)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	1	2026-09-06	Consumo diario de alimento balanceado Caniles Sector C (Lote #32)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	2	2026-09-08	Despacho de desinfectantes y lavandina para bioseguridad (Lote #33)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	3	2026-09-10	Atención médica de urgencia en consultorio veterinario (Lote #34)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	4	2026-09-12	Jornada de vacunación y desparasitación masiva (Lote #35)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	5	2026-09-14	Alimentación especial de cachorros en guardería neonatal (Lote #36)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	6	2026-09-16	Curaciones y cambio de vendajes en área de internación (Lote #37)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	7	2026-09-18	Entrega de mantas y platos a nuevos caniles habilitados (Lote #38)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	8	2026-09-20	Consumo de arena sanitaria en gaterío sector 1 (Lote #39)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	1	2026-09-22	Consumo diario de alimento balanceado Caniles Sector A (Lote #40)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	2	2026-09-24	Consumo diario de alimento balanceado Caniles Sector B (Lote #41)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	3	2026-09-26	Consumo diario de alimento balanceado Caniles Sector C (Lote #42)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	4	2026-09-28	Despacho de desinfectantes y lavandina para bioseguridad (Lote #43)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	5	2026-09-30	Atención médica de urgencia en consultorio veterinario (Lote #44)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	6	2026-10-02	Jornada de vacunación y desparasitación masiva (Lote #45)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	7	2026-10-04	Alimentación especial de cachorros en guardería neonatal (Lote #46)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	8	2026-10-06	Curaciones y cambio de vendajes en área de internación (Lote #47)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	1	2026-10-08	Entrega de mantas y platos a nuevos caniles habilitados (Lote #48)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	2	2026-10-10	Consumo de arena sanitaria en gaterío sector 1 (Lote #49)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	3	2026-10-12	Consumo diario de alimento balanceado Caniles Sector A (Lote #50)	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: salida_inventarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.salida_inventarios (id, motivo, id_usuario, fecha_salida, created_at, updated_at, id_historial_clinico) FROM stdin;
1	Alimentación semanal de caniles generales	3	2026-01-25	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
2	Tratamiento de gatos en área de aislamiento clínico	2	2026-02-12	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
3	Limpieza y desinfección profunda de caniles	3	2026-03-01	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
4	Atención clínica y medicación de rescates	2	2026-11-11	2026-11-12 16:51:29	2026-11-12 16:51:29	1
5	Atención clínica y medicación de rescates	3	2026-11-08	2026-11-12 16:51:29	2026-11-12 16:51:29	2
6	Atención clínica y medicación de rescates	4	2026-11-05	2026-11-12 16:51:29	2026-11-12 16:51:29	3
7	Atención clínica y medicación de rescates	5	2026-11-02	2026-11-12 16:51:29	2026-11-12 16:51:29	4
8	Atención clínica y medicación de rescates	7	2026-10-30	2026-11-12 16:51:29	2026-11-12 16:51:29	5
9	Atención clínica y medicación de rescates	6	2026-10-27	2026-11-12 16:51:29	2026-11-12 16:51:29	6
10	Atención clínica y medicación de rescates	8	2026-10-24	2026-11-12 16:51:29	2026-11-12 16:51:29	7
11	se ensuciaron toda la ropa puesta los perritos | Destino: limpieza	5	2026-11-21	2026-11-21 10:44:30	2026-11-21 10:44:30	\N
\.


--
-- Data for Name: seguimiento_adopcion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seguimiento_adopcion (id_seguimiento, id_adopcion, id_usuario, estado_seguimiento, fecha_programada, fecha_realizada, reporte_bienestar, fotografias_evidencia, created_at, updated_at) FROM stdin;
2	2	17	Completado	2026-08-15	2026-08-17	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_002.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	3	18	Completado	2026-08-16	2026-08-18	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_003.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	4	19	Completado	2026-08-17	2026-08-19	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_004.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	5	20	Completado	2026-08-18	2026-08-20	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_005.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	6	15	Completado	2026-08-19	2026-08-21	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_006.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	7	16	Completado	2026-08-20	2026-08-22	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_007.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	8	17	Completado	2026-08-21	2026-08-23	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_008.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	9	18	Completado	2026-08-22	2026-08-24	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_009.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	10	19	Completado	2026-08-23	2026-08-25	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_010.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	11	20	Completado	2026-08-24	2026-08-26	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_011.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	12	15	Completado	2026-08-25	2026-08-27	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_012.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	13	16	Completado	2026-08-26	2026-08-28	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_013.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	14	17	Completado	2026-08-27	2026-08-29	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_014.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	15	18	Completado	2026-08-28	2026-08-30	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_015.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	16	19	Completado	2026-08-29	2026-08-31	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_016.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	17	20	Completado	2026-08-30	2026-09-01	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_017.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	18	15	Completado	2026-08-31	2026-09-02	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_018.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	19	16	Completado	2026-09-01	2026-09-03	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_019.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	20	17	Completado	2026-09-02	2026-09-04	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_020.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	21	18	Completado	2026-09-03	2026-09-05	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_021.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	22	19	Completado	2026-09-04	2026-09-06	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_022.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	23	20	Completado	2026-09-05	2026-09-07	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_023.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	24	15	Completado	2026-09-06	2026-09-08	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_024.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	25	16	Completado	2026-09-07	2026-09-09	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_025.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	26	17	Completado	2026-09-08	2026-09-10	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_026.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	27	18	Completado	2026-09-09	2026-09-11	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_027.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	28	19	Completado	2026-09-10	2026-09-12	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_028.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	29	20	Completado	2026-09-11	2026-09-13	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_029.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	30	15	Completado	2026-09-12	2026-09-14	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_030.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	31	16	Completado	2026-09-13	2026-09-15	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_031.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	32	17	Completado	2026-09-14	2026-09-16	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_032.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	33	18	Completado	2026-09-15	2026-09-17	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_033.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	34	19	Completado	2026-09-16	2026-09-18	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_034.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	35	20	Completado	2026-09-17	2026-09-19	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_035.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	36	15	Completado	2026-09-18	2026-09-20	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_036.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	37	16	Completado	2026-09-19	2026-09-21	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_037.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	38	17	Completado	2026-09-20	2026-09-22	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_038.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	39	18	Completado	2026-09-21	2026-09-23	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_039.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	40	19	Completado	2026-09-22	2026-09-24	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_040.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	41	20	Programado	2026-12-12	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_041.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	42	15	Programado	2026-12-13	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_042.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	43	16	Programado	2026-12-14	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_043.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	44	17	Programado	2026-12-15	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_044.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	45	18	Programado	2026-12-16	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_045.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	46	19	Programado	2026-12-17	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_046.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	47	20	Programado	2026-12-18	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_047.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	48	15	Programado	2026-12-19	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_048.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	49	16	Programado	2026-12-20	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_049.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	50	17	Programado	2026-12-21	\N	Visita de control programada en agenda	https://dbhogar.refugio.org/seguimientos/evidencia_adop_050.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
1	1	16	Concluido Satisfactorio	2026-02-15	2026-02-15	La mascota se adaptó perfectamente. Come bien y comparte con la familia.	/uploads/visitas/visita_20261121_104059_6b01ad7be8f2e_0.jpeg|https://refugio.org/evidencias/seg_firulais_1.jpg	2026-11-01 14:00:12.780728	2026-11-21 10:40:59
\.


--
-- Data for Name: seguimiento_adopcions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seguimiento_adopcions (id, estado_seguimiento, fecha_programada, fecha_realizada, fotografia, reporte_bienestar, id_adopcion, id_usuario, created_at, updated_at) FROM stdin;
2	Pendiente	2026-03-15	\N			1	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Pendiente	2026-03-22	\N			2	3	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Completado	2026-08-17	2026-08-19	https://dbhogar.refugio.org/seguimientos/evidencia_adop_004.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	4	19	2026-11-01 14:00:13	2026-11-01 14:00:13
5	Completado	2026-08-18	2026-08-20	https://dbhogar.refugio.org/seguimientos/evidencia_adop_005.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	5	20	2026-11-01 14:00:13	2026-11-01 14:00:13
6	Completado	2026-08-19	2026-08-21	https://dbhogar.refugio.org/seguimientos/evidencia_adop_006.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	6	15	2026-11-01 14:00:13	2026-11-01 14:00:13
7	Completado	2026-08-20	2026-08-22	https://dbhogar.refugio.org/seguimientos/evidencia_adop_007.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	7	16	2026-11-01 14:00:13	2026-11-01 14:00:13
8	Completado	2026-08-21	2026-08-23	https://dbhogar.refugio.org/seguimientos/evidencia_adop_008.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	8	17	2026-11-01 14:00:13	2026-11-01 14:00:13
9	Completado	2026-08-22	2026-08-24	https://dbhogar.refugio.org/seguimientos/evidencia_adop_009.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	9	18	2026-11-01 14:00:13	2026-11-01 14:00:13
10	Completado	2026-08-23	2026-08-25	https://dbhogar.refugio.org/seguimientos/evidencia_adop_010.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	10	19	2026-11-01 14:00:13	2026-11-01 14:00:13
11	Completado	2026-08-24	2026-08-26	https://dbhogar.refugio.org/seguimientos/evidencia_adop_011.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	11	20	2026-11-01 14:00:13	2026-11-01 14:00:13
12	Completado	2026-08-25	2026-08-27	https://dbhogar.refugio.org/seguimientos/evidencia_adop_012.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	12	15	2026-11-01 14:00:13	2026-11-01 14:00:13
13	Completado	2026-08-26	2026-08-28	https://dbhogar.refugio.org/seguimientos/evidencia_adop_013.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	13	16	2026-11-01 14:00:13	2026-11-01 14:00:13
14	Completado	2026-08-27	2026-08-29	https://dbhogar.refugio.org/seguimientos/evidencia_adop_014.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	14	17	2026-11-01 14:00:13	2026-11-01 14:00:13
15	Completado	2026-08-28	2026-08-30	https://dbhogar.refugio.org/seguimientos/evidencia_adop_015.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	15	18	2026-11-01 14:00:13	2026-11-01 14:00:13
16	Completado	2026-08-29	2026-08-31	https://dbhogar.refugio.org/seguimientos/evidencia_adop_016.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	16	19	2026-11-01 14:00:13	2026-11-01 14:00:13
17	Completado	2026-08-30	2026-09-01	https://dbhogar.refugio.org/seguimientos/evidencia_adop_017.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	17	20	2026-11-01 14:00:13	2026-11-01 14:00:13
18	Completado	2026-08-31	2026-09-02	https://dbhogar.refugio.org/seguimientos/evidencia_adop_018.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	18	15	2026-11-01 14:00:13	2026-11-01 14:00:13
19	Completado	2026-09-01	2026-09-03	https://dbhogar.refugio.org/seguimientos/evidencia_adop_019.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	19	16	2026-11-01 14:00:13	2026-11-01 14:00:13
20	Completado	2026-09-02	2026-09-04	https://dbhogar.refugio.org/seguimientos/evidencia_adop_020.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	20	17	2026-11-01 14:00:13	2026-11-01 14:00:13
21	Completado	2026-09-03	2026-09-05	https://dbhogar.refugio.org/seguimientos/evidencia_adop_021.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	21	18	2026-11-01 14:00:13	2026-11-01 14:00:13
22	Completado	2026-09-04	2026-09-06	https://dbhogar.refugio.org/seguimientos/evidencia_adop_022.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	22	19	2026-11-01 14:00:13	2026-11-01 14:00:13
23	Completado	2026-09-05	2026-09-07	https://dbhogar.refugio.org/seguimientos/evidencia_adop_023.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	23	20	2026-11-01 14:00:13	2026-11-01 14:00:13
24	Completado	2026-09-06	2026-09-08	https://dbhogar.refugio.org/seguimientos/evidencia_adop_024.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	24	15	2026-11-01 14:00:13	2026-11-01 14:00:13
25	Completado	2026-09-07	2026-09-09	https://dbhogar.refugio.org/seguimientos/evidencia_adop_025.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	25	16	2026-11-01 14:00:13	2026-11-01 14:00:13
26	Completado	2026-09-08	2026-09-10	https://dbhogar.refugio.org/seguimientos/evidencia_adop_026.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	26	17	2026-11-01 14:00:13	2026-11-01 14:00:13
27	Completado	2026-09-09	2026-09-11	https://dbhogar.refugio.org/seguimientos/evidencia_adop_027.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	27	18	2026-11-01 14:00:13	2026-11-01 14:00:13
28	Completado	2026-09-10	2026-09-12	https://dbhogar.refugio.org/seguimientos/evidencia_adop_028.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	28	19	2026-11-01 14:00:13	2026-11-01 14:00:13
29	Completado	2026-09-11	2026-09-13	https://dbhogar.refugio.org/seguimientos/evidencia_adop_029.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	29	20	2026-11-01 14:00:13	2026-11-01 14:00:13
30	Completado	2026-09-12	2026-09-14	https://dbhogar.refugio.org/seguimientos/evidencia_adop_030.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	30	15	2026-11-01 14:00:13	2026-11-01 14:00:13
31	Completado	2026-09-13	2026-09-15	https://dbhogar.refugio.org/seguimientos/evidencia_adop_031.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	31	16	2026-11-01 14:00:13	2026-11-01 14:00:13
32	Completado	2026-09-14	2026-09-16	https://dbhogar.refugio.org/seguimientos/evidencia_adop_032.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	32	17	2026-11-01 14:00:13	2026-11-01 14:00:13
33	Completado	2026-09-15	2026-09-17	https://dbhogar.refugio.org/seguimientos/evidencia_adop_033.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	33	18	2026-11-01 14:00:13	2026-11-01 14:00:13
34	Completado	2026-09-16	2026-09-18	https://dbhogar.refugio.org/seguimientos/evidencia_adop_034.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	34	19	2026-11-01 14:00:13	2026-11-01 14:00:13
35	Completado	2026-09-17	2026-09-19	https://dbhogar.refugio.org/seguimientos/evidencia_adop_035.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	35	20	2026-11-01 14:00:13	2026-11-01 14:00:13
36	Completado	2026-09-18	2026-09-20	https://dbhogar.refugio.org/seguimientos/evidencia_adop_036.jpg	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	36	15	2026-11-01 14:00:13	2026-11-01 14:00:13
37	Completado	2026-09-19	2026-09-21	https://dbhogar.refugio.org/seguimientos/evidencia_adop_037.jpg	El adoptante acondicionó rejas de seguridad en el patio. Animal sociable, activo y con peso saludable.	37	16	2026-11-01 14:00:13	2026-11-01 14:00:13
38	Completado	2026-09-20	2026-09-22	https://dbhogar.refugio.org/seguimientos/evidencia_adop_038.jpg	Control de los 3 meses cumplido satisfactoriamente. Excelente vínculo afectivo con los niños de la casa.	38	17	2026-11-01 14:00:13	2026-11-01 14:00:13
39	Completado	2026-09-21	2026-09-23	https://dbhogar.refugio.org/seguimientos/evidencia_adop_039.jpg	Última visita de 6 meses. Mascota esterilizada y en óptimas condiciones de salud y espacio físico.	39	18	2026-11-01 14:00:13	2026-11-01 14:00:13
40	Completado	2026-09-22	2026-09-24	https://dbhogar.refugio.org/seguimientos/evidencia_adop_040.jpg	Mascota adaptada favorablemente a su nuevo hogar, convive amistosamente con la familia, alimentación correcta.	40	19	2026-11-01 14:00:13	2026-11-01 14:00:13
41	Programado	2026-12-12	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_041.jpg	Visita de control programada en agenda	41	20	2026-11-01 14:00:13	2026-11-01 14:00:13
42	Programado	2026-12-13	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_042.jpg	Visita de control programada en agenda	42	15	2026-11-01 14:00:13	2026-11-01 14:00:13
43	Programado	2026-12-14	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_043.jpg	Visita de control programada en agenda	43	16	2026-11-01 14:00:13	2026-11-01 14:00:13
44	Programado	2026-12-15	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_044.jpg	Visita de control programada en agenda	44	17	2026-11-01 14:00:13	2026-11-01 14:00:13
45	Programado	2026-12-16	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_045.jpg	Visita de control programada en agenda	45	18	2026-11-01 14:00:13	2026-11-01 14:00:13
46	Programado	2026-12-17	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_046.jpg	Visita de control programada en agenda	46	19	2026-11-01 14:00:13	2026-11-01 14:00:13
47	Programado	2026-12-18	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_047.jpg	Visita de control programada en agenda	47	20	2026-11-01 14:00:13	2026-11-01 14:00:13
48	Programado	2026-12-19	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_048.jpg	Visita de control programada en agenda	48	15	2026-11-01 14:00:13	2026-11-01 14:00:13
49	Programado	2026-12-20	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_049.jpg	Visita de control programada en agenda	49	16	2026-11-01 14:00:13	2026-11-01 14:00:13
50	Programado	2026-12-21	\N	https://dbhogar.refugio.org/seguimientos/evidencia_adop_050.jpg	Visita de control programada en agenda	50	17	2026-11-01 14:00:13	2026-11-01 14:00:13
51	Programado	2026-12-21	\N	/images/default-check.png	Control post-adopción programado a los 30 días.	51	5	2026-11-21 10:36:58	2026-11-21 10:36:58
52	Programado	2027-02-19	\N	/images/default-check.png	Control post-adopción programado a los 90 días.	51	5	2026-11-21 10:36:58	2026-11-21 10:36:58
53	Programado	2027-05-20	\N	/images/default-check.png	Control post-adopción programado a los 180 días.	51	5	2026-11-21 10:36:58	2026-11-21 10:36:58
54	Programado	2026-12-21	\N	/images/default-check.png	Control post-adopción programado a los 30 días.	52	5	2026-11-21 10:40:09	2026-11-21 10:40:09
55	Programado	2027-02-19	\N	/images/default-check.png	Control post-adopción programado a los 90 días.	52	5	2026-11-21 10:40:09	2026-11-21 10:40:09
56	Programado	2027-05-20	\N	/images/default-check.png	Control post-adopción programado a los 180 días.	52	5	2026-11-21 10:40:09	2026-11-21 10:40:09
1	Concluido Satisfactorio	2026-02-15	2026-02-15	/uploads/visitas/visita_20261121_104059_6b01ad7be8f2e_0.jpeg|https://refugio.org/evidencias/seg_firulais_1.jpg	La mascota se adaptó perfectamente. Come bien y comparte con la familia.	1	5	2026-11-01 18:17:19	2026-11-21 10:40:59
\.


--
-- Data for Name: sesion_jwt; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sesion_jwt (token_hash, id_usuario, ip_cliente, user_agent, fecha_emision, fecha_expiracion, estado) FROM stdin;
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0001_11051	1	192.168.1.11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0002_21763	2	192.168.1.12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0003_90533	3	192.168.1.13	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0004_32604	4	192.168.1.14	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0005_57747	5	192.168.1.15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0006_25747	6	192.168.1.16	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0007_38344	7	192.168.1.17	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0008_51751	8	192.168.1.18	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0009_35008	9	192.168.1.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0010_17206	10	192.168.1.20	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0011_69108	11	192.168.1.21	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0012_73856	12	192.168.1.22	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0013_42951	13	192.168.1.23	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0014_20521	14	192.168.1.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0015_69712	15	192.168.1.25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0016_19362	16	192.168.1.26	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0017_11388	17	192.168.1.27	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0018_73576	18	192.168.1.28	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0019_60472	19	192.168.1.29	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0020_69083	20	192.168.1.30	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0021_91056	21	192.168.1.31	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0022_25644	22	192.168.1.32	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0023_44143	23	192.168.1.33	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0024_93855	24	192.168.1.34	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0025_44429	25	192.168.1.35	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
pXdDpIz37IZ2pTvxUHOgMdp4uX0UJOsKdPBqQipV	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36	eyJfdG9rZW4iOiJpSlVUWWhCaVFYblRibUtublY4SGcwWTZpd2JYZkRQOER5T2gwR2RlIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9sb2dpbiIsInJvdXRlIjoibG9naW4ifSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==	1795288940
\.


--
-- Data for Name: tipo_aporte; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipo_aporte (id_tipoaporte, nombre, descripcion) FROM stdin;
1	Aporte Monetario Efectivo	Donaciones presenciales en dinero efectivo en sede central
2	Pasarela Digital QR	Aportes procesados mediante código QR dinámico bancario
3	Transferencia Bancaria BNB	Transferencias electrónicas a cuenta corriente Banco Nacional
4	Transferencia Bancaria BCP	Transferencias electrónicas a cuenta corriente Banco de Crédito
5	Transferencia Banco Mercantil	Depósitos en cuenta corriente Banco Mercantil Santa Cruz
6	Aporte Débito Automático	Donaciones mensuales recurrentes domiciliadas en tarjeta
7	Alimento Balanceado Cachorro Canino	Bolsas de croquetas para cachorros hasta 12 meses
8	Alimento Balanceado Adulto Canino	Bolsas de croquetas estándar para perros adultos
9	Alimento Balanceado Senior Canino	Croquetas formuladas para perros mayores de 7 años
10	Alimento Húmedo Canino (Latas)	Comida enlatada paté y trozos en salsa para perros convalecientes
11	Alimento Húmedo Felino (Sobres)	Sobres pouches de alimento húmedo para gatos
12	Alimento Balanceado Felino Adulto	Bolsas de croquetas para gatos adultos
13	Alimento Balanceado Felino Kitten	Bolsas de croquetas para gatitos en crecimiento
14	Alimento Medicado Renal	Dieta especializada para soporte de función renal
15	Alimento Medicado Gastrointestinal	Dieta especializada para recuperación de enteritis
16	Alimento Medicado Hipoalergénico	Dieta con proteína hidrolizada para dermatitis alérgica
17	Leche Maternizada en Polvo	Sustituto lácteo para cachorros y gatitos huérfanos
18	Vacuna Óctuple Canina	Inmunización contra Parvovirus, Moquillo, Hepatitis y Leptospira
19	Vacuna Puppy DP	Primera vacuna temprana para cachorros lactantes
20	Vacuna Triple Felina	Inmunización contra Rinotraqueitis, Calicivirus y Panleucopenia
21	Vacuna Antirrábica	Dosis de vacuna antirrábica oficial para perros y gatos
22	Desparasitante Interno Tabletas	Antiparasitario oral de amplio espectro (Praziquantel/Pirantel)
23	Desparasitante Interno Suspensión	Jarabe antiparasitario pediátrico para cachorros
24	Pipetas Antipulgas y Garrapatas	Antiparasitario externo spot-on para perros y gatos
25	Pastillas Masticables Antipulgas	Comprimidos de protección trimestral contra garrapatas
26	Antibiótico Inyectable (Ceftriaxona)	Frascos ampolla para tratamiento de infecciones bacterianas
27	Antibiótico Oral (Amoxicilina/Clavulánico)	Comprimidos para infecciones dérmicas y respiratorias
28	Antiinflamatorio Inyectable (Meloxicam)	Analgésico no esteroideo para control de dolor
29	Suero Fisiológico al 0.9%	Solución cloruro de sodio en bolsas de 500ml para hidratación
30	Suero Ringer Lactato	Solución electrolítica balanceada para deshidratación severa
31	Complejo B y Vitaminas Inyectables	Polivitamínico hematopoyético para animales desnutridos
32	Curabichera en Aerosol	Larvicida cicatrizante para tratamiento de miasis en piel
33	Antiséptico Clorhexidina al 2%	Solución desinfectante para lavado de heridas y piel
34	Gasas Estériles y Vendas Elásticas	Material hospitalario para vendajes y apósitos
35	Jeringas Descartables de 3ml y 5ml	Material estéril para aplicación de inyecciones y medicación
36	Catéteres Intravenosos 22G y 24G	Agujas de vía venosa para canalización de sueros
37	Lavandina Concentrada (Hipoclorito)	Desinfectante clorado para esterilización de caniles
38	Detergente Industrial Enzimático	Limpiador para remoción de grasa y suciedad orgánica
39	Desinfectante Amonio Cuaternario	Virucida de 5ta generación para prevención de parvovirus
40	Arena Sanitaria para Gatos	Bolsas de bentonita absorbente para areneros felinos
41	Bolsas Plásticas para Residuos 100L	Bolsas gruesas para recojo de desechos diarios
42	Toallas de Papel y Absorbentes	Bobinas de papel secante para consultorio veterinario
43	Mantas y Colchas Térmicas	Frazadas para abrigo de cachorros y animales internados
44	Camas y Colchonetas Impermeables	Camas acolchadas con forro lavable para caniles
45	Correas y Collares de Paseo	Arneses y collares de nylon para socialización y ferias
46	Bozales Caninos de Canastilla	Bozales de seguridad para procedimientos veterinarios
47	Platos de Acero Inoxidable	Comederos y bebederos resistentes e higiénicos
48	Transportadoras Plásticas Talle M/L	Jaulas de transporte para visitas médicas y rescates
49	Caniles Desarmables de Metal	Estructuras de aislamiento para áreas de cuarentena
50	Material Quirúrgico (Hojas de Bisturí/Suturas)	Hilos de sutura absorbible vicryl y hojas descartables
\.


--
-- Data for Name: tipo_aportes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipo_aportes (id, nombre, descripcion, created_at, updated_at) FROM stdin;
1	Efectivo / Transferencia	Aportes monetarios directos a la cuenta bancaria del refugio	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Alimento Seco	Croquetas para perros y gatos de distintas edades	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Insumos Médicos	Medicamentos, vacunas, jeringas y gasas	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Artículos de Limpieza	Detergentes, desinfectantes y escobas	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Mobiliario / Accesorios	Camas, correas, platos y jaulas de transporte	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, nombre, email, rol, telefono, password, remember_token, created_at, updated_at, ci, activo) FROM stdin;
4	Dr. Mateo Vargas Ortiz	mateo.vargas@patitas.com	Veterinario	72109384	$2y$12$tJtzcQJeHt4ZSQaH9GrapejMKG26qY4.uiXZd785Nsg2anMk0HMRG	\N	2026-11-01 18:17:19	2026-11-01 18:17:19	4545678 CH	t
7	Ignacio Ribera Zabala	user7@losangelitos.org	Veterinario	64521452	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4500777	t
1	Carlos Eduardo Mendoza	carlos.mendoza@patitas.com	Administrador	71029384	$2y$12$8Yo0AEYJSNJfoJZcOIZFxeK9AcM883misx1b3WkdAHUZfW/a2n7Rm	\N	2026-11-01 18:17:18	2026-11-21 09:35:03	4512345 LP	t
5	Camila Suárez Roca	camila.suarez@patitas.com	Recepcionista	78901234	$2y$12$2EExLZRY9twnR85ukHXAFOrIZYti2a3Yec.IqJQT3syCIzhNccizi	\N	2026-11-01 18:17:19	2026-11-21 09:35:03	4556789 OR	t
2	Dra. Beatriz Morales Peña	beatriz.morales@patitas.com	Veterinario	75019283	$2y$12$jRI7teZUwLKm4lMo0KGVB.xyE4mbnnAU0760nXUH5vaAOEbOrHIIa	\N	2026-11-01 18:17:18	2026-11-21 09:35:03	4523456 SC	t
3	Lucía Fernández Claros	lucia.fernandez@patitas.com	Voluntario	68910293	$2y$12$96lI3nvtrMi2TH2jD3Fox.ZZSLV5GUqn6pWSKJxAsc01ixV72eNRW	\N	2026-11-01 18:17:18	2026-11-21 09:35:04	4534567 CB	t
6	Juan Ronaldo Rojas Ugarte	rojasugartejuanronaldo@gmail.com	Administrador	70000000	$2y$12$6a7tZ.letBDxCrDpajTffeWeSSg94UdrnkUO4BcKrUrLm9Uoqd2iS	\N	2026-11-02 01:42:33	2026-11-10 20:26:04	1000001	t
8	Gabriel Salazar Paz	user8@losangelitos.org	Veterinario	64451766	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4500888	t
9	Diego Armando Cuéllar Pinto	user9@losangelitos.org	Veterinario	78235632	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4500999	t
10	Jessica Rojas Cuéllar	user10@losangelitos.org	Veterinario	72233774	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501110	t
11	Víctor Hugo Dorado Rojas	user11@losangelitos.org	Veterinario	64291919	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501221	t
12	Rubén Añez Peña	user12@losangelitos.org	Veterinario	68859769	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501332	t
13	Tatiana Condori Saucedo	user13@losangelitos.org	Veterinario	67325268	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501443	t
14	Ignacio Flores Dorado	user14@losangelitos.org	Veterinario	72716685	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501554	t
15	Juan Carlos Torrico Salazar	user15@losangelitos.org	Veterinario	75417670	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501665	t
16	Gonzalo Morales Román	user16@losangelitos.org	Recepcionista	69228844	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501776	t
17	Jessica Justiniano Antelo	user17@losangelitos.org	Recepcionista	63565623	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501887	t
18	Óscar Rojas Añez	user18@losangelitos.org	Recepcionista	72522615	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4501998	t
19	Hugo Saucedo Mamani	user19@losangelitos.org	Recepcionista	69235743	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502109	t
20	Tatiana Peña Chávez	user20@losangelitos.org	Recepcionista	64326784	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502220	t
21	Juan Carlos Ribera Morales	user21@losangelitos.org	Recepcionista	72295367	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502331	t
22	Ignacio Morales Rojas	user22@losangelitos.org	Recepcionista	74529228	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502442	t
23	Rodrigo Montaño Cuéllar	user23@losangelitos.org	Recepcionista	76592398	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502553	t
24	Carlos Eduardo Barba Saucedo	user24@losangelitos.org	Recepcionista	76337278	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502664	t
25	Mateo Suárez Mamani	user25@losangelitos.org	Recepcionista	77345855	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	\N	2026-11-01 14:00:13	2026-11-01 14:00:13	4502775	t
51	angel	anjelradio@gmail.com	Donante	64447731	$2y$12$hzK.qcgzewAeOnEHlqe.kOc0/a9lp3r0sfdB2M6zlQwfmKylN1sSW	\N	2026-11-16 20:24:31	2026-11-16 20:24:31	\N	t
52	Roberto Justiniano (Donante)	donante@patitas.com	Donante	70010005	$2y$12$xiyXi6dPyHdoIo/MkcIatupGiqtwOVjSN3IND1STatL0V.TC6aAmG	\N	2026-11-21 09:35:04	2026-11-21 09:35:04	\N	t
53	Valeria Ribera (Postulante)	postulante@patitas.com	Postulante	70010006	$2y$12$40wUc8NMrkazRHVQZr.DEOIcBxyQCtzB9CIxmCG61UzM44e07N/l2	\N	2026-11-21 09:35:04	2026-11-21 09:35:04	\N	t
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuario (id_usuario, ci, nombre_completo, rol, telefono, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, created_at, updated_at) FROM stdin;
4	4500444	David Mendoza Salazar	Administrador	62913081	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	4500666	Juan Ronaldo Rojas Ugarte	Administrador	70000000	$2y$12$6a7tZ.letBDxCrDpajTffeWeSSg94UdrnkUO4BcKrUrLm9Uoqd2iS	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-10 20:26:04
7	4500777	Ignacio Ribera Zabala	Veterinario	64521452	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
5	4500555	Camila Suárez Roca	Recepcionista	78901234	$2y$12$2EExLZRY9twnR85ukHXAFOrIZYti2a3Yec.IqJQT3syCIzhNccizi	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-21 09:35:03
2	4500222	Dra. Beatriz Morales Peña	Veterinario	75019283	$2y$12$jRI7teZUwLKm4lMo0KGVB.xyE4mbnnAU0760nXUH5vaAOEbOrHIIa	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-21 09:35:03
3	4500333	Lucía Fernández Claros	Voluntario	68910293	$2y$12$96lI3nvtrMi2TH2jD3Fox.ZZSLV5GUqn6pWSKJxAsc01ixV72eNRW	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-21 09:35:04
8	4500888	Gabriel Salazar Paz	Veterinario	64451766	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
9	4500999	Diego Armando Cuéllar Pinto	Veterinario	78235632	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
10	4501110	Jessica Rojas Cuéllar	Veterinario	72233774	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
11	4501221	Víctor Hugo Dorado Rojas	Veterinario	64291919	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
12	4501332	Rubén Añez Peña	Veterinario	68859769	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
13	4501443	Tatiana Condori Saucedo	Veterinario	67325268	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
14	4501554	Ignacio Flores Dorado	Veterinario	72716685	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
15	4501665	Juan Carlos Torrico Salazar	Veterinario	75417670	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
16	4501776	Gonzalo Morales Román	Recepcionista	69228844	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
17	4501887	Jessica Justiniano Antelo	Recepcionista	63565623	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
18	4501998	Óscar Rojas Añez	Recepcionista	72522615	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
19	4502109	Hugo Saucedo Mamani	Recepcionista	69235743	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
20	4502220	Tatiana Peña Chávez	Recepcionista	64326784	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
21	4502331	Juan Carlos Ribera Morales	Recepcionista	72295367	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
22	4502442	Ignacio Morales Rojas	Recepcionista	74529228	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
23	4502553	Rodrigo Montaño Cuéllar	Recepcionista	76592398	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
24	4502664	Carlos Eduardo Barba Saucedo	Recepcionista	76337278	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
25	4502775	Mateo Suárez Mamani	Recepcionista	77345855	$2y$12$lQSiFkfSRACa3wq5EGjJneGG2iDvqYw02Q/rLXNJIQ8ArzwVYD18O	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:13
1	1000001	Carlos Eduardo Mendoza	Administrador	71029384	$2y$12$8Yo0AEYJSNJfoJZcOIZFxeK9AcM883misx1b3WkdAHUZfW/a2n7Rm	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-21 09:35:03
51	CI-51	angel	Donante	64447731	$2y$12$hzK.qcgzewAeOnEHlqe.kOc0/a9lp3r0sfdB2M6zlQwfmKylN1sSW	Activo	0	\N	2026-11-16 20:24:31	2026-11-16 20:24:31
52	CI-52	Roberto Justiniano (Donante)	Donante	70010005	$2y$12$xiyXi6dPyHdoIo/MkcIatupGiqtwOVjSN3IND1STatL0V.TC6aAmG	Activo	0	\N	2026-11-21 09:35:04	2026-11-21 09:35:04
53	CI-53	Valeria Ribera (Postulante)	Postulante	70010006	$2y$12$40wUc8NMrkazRHVQZr.DEOIcBxyQCtzB9CIxmCG61UzM44e07N/l2	Activo	0	\N	2026-11-21 09:35:04	2026-11-21 09:35:04
\.


--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.adopcion_id_adopcion_seq', 50, true);


--
-- Name: adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.adopcions_id_seq', 52, true);


--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ajuste_inventario_lotes_id_seq', 10, true);


--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ajuste_inventarios_id_seq', 8, true);


--
-- Name: alerta_inventario_id_alerta_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alerta_inventario_id_alerta_seq', 50, true);


--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.aporte_dinero_id_aporte_seq', 50, true);


--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.aporte_dineros_id_seq', 16, true);


--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.articulo_inventario_id_articulo_seq', 50, true);


--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.articulo_inventarios_id_seq', 108, true);


--
-- Name: auditoria_forense_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auditoria_forense_id_seq', 94, true);


--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bitacora_id_accion_seq', 50, true);


--
-- Name: bitacoras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bitacoras_id_seq', 225, true);


--
-- Name: cierres_periodos_reportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cierres_periodos_reportes_id_seq', 15, true);


--
-- Name: compra_id_compra_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compra_id_compra_seq', 50, true);


--
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compras_id_seq', 10, true);


--
-- Name: cronograma_tratamientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cronograma_tratamientos_id_seq', 88, true);


--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_compra_id_detallecompra_seq', 50, true);


--
-- Name: detalle_compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_compras_id_seq', 10, true);


--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_donacion_insumo_id_detalle_seq', 50, true);


--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_donacion_insumos_id_seq', 54, true);


--
-- Name: detalle_facturas_legales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_facturas_legales_id_seq', 44, true);


--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_salida_id_detallesalida_seq', 50, true);


--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_salida_lotes_id_seq', 10, true);


--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_salidas_id_seq', 11, true);


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donacion_id_donacion_seq', 80, true);


--
-- Name: donacions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donacions_id_seq', 94, true);


--
-- Name: donante_id_donante_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donante_id_donante_seq', 50, true);


--
-- Name: donantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donantes_id_seq', 59, true);


--
-- Name: dosificaciones_fiscales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dosificaciones_fiscales_id_seq', 2, true);


--
-- Name: evaluacion_idoneidad_id_evaluacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.evaluacion_idoneidad_id_evaluacion_seq', 50, true);


--
-- Name: facturas_compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facturas_compras_id_seq', 22, true);


--
-- Name: facturas_legales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facturas_legales_id_seq', 44, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, true);


--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.historial_clinico_id_historial_seq', 50, true);


--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.historial_clinicos_id_seq', 150, true);


--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.interesado_adopcion_id_interesado_seq', 65, true);


--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.interesado_adopcions_id_seq', 65, true);


--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventario_lotes_id_seq', 69, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, true);


--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mascota_id_mascota_seq', 80, true);


--
-- Name: mascotas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mascotas_id_seq', 50, true);


--
-- Name: medicamento_id_medicamento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.medicamento_id_medicamento_seq', 1, false);


--
-- Name: medicamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.medicamentos_id_seq', 60, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 46, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 61, true);


--
-- Name: prescripciones_dosificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.prescripciones_dosificacion_id_seq', 22, true);


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 50, true);


--
-- Name: proveedors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.proveedors_id_seq', 50, true);


--
-- Name: rol_permiso_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rol_permiso_id_rol_seq', 50, true);


--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.salida_inventario_id_salida_seq', 50, true);


--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.salida_inventarios_id_seq', 11, true);


--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seguimiento_adopcion_id_seguimiento_seq', 50, true);


--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seguimiento_adopcions_id_seq', 56, true);


--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_aporte_id_tipoaporte_seq', 50, true);


--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_aportes_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 53, true);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 50, true);


--
-- Name: adopcion adopcion_id_mascota_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT adopcion_id_mascota_key UNIQUE (id_mascota);


--
-- Name: adopcion adopcion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT adopcion_pkey PRIMARY KEY (id_adopcion);


--
-- Name: adopcions adopcions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcions
    ADD CONSTRAINT adopcions_pkey PRIMARY KEY (id);


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_pkey PRIMARY KEY (id);


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_unique UNIQUE (id_ajuste_inventario, id_inventario_lote);


--
-- Name: ajuste_inventarios ajuste_inventarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventarios
    ADD CONSTRAINT ajuste_inventarios_pkey PRIMARY KEY (id);


--
-- Name: alerta_inventario alerta_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_inventario
    ADD CONSTRAINT alerta_inventario_pkey PRIMARY KEY (id_alerta);


--
-- Name: aporte_dinero aporte_dinero_id_donacion_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT aporte_dinero_id_donacion_key UNIQUE (id_donacion);


--
-- Name: aporte_dinero aporte_dinero_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT aporte_dinero_pkey PRIMARY KEY (id_aporte);


--
-- Name: aporte_dineros aporte_dineros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dineros
    ADD CONSTRAINT aporte_dineros_pkey PRIMARY KEY (id);


--
-- Name: articulo_inventario articulo_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articulo_inventario
    ADD CONSTRAINT articulo_inventario_pkey PRIMARY KEY (id_articulo);


--
-- Name: articulo_inventarios articulo_inventarios_nombre_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articulo_inventarios
    ADD CONSTRAINT articulo_inventarios_nombre_unique UNIQUE (nombre);


--
-- Name: articulo_inventarios articulo_inventarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articulo_inventarios
    ADD CONSTRAINT articulo_inventarios_pkey PRIMARY KEY (id);


--
-- Name: auditoria_forense auditoria_forense_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria_forense
    ADD CONSTRAINT auditoria_forense_pkey PRIMARY KEY (id);


--
-- Name: bitacora bitacora_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (id_accion);


--
-- Name: bitacoras bitacoras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacoras
    ADD CONSTRAINT bitacoras_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: cierres_periodos_reportes cierres_periodos_reportes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cierres_periodos_reportes
    ADD CONSTRAINT cierres_periodos_reportes_pkey PRIMARY KEY (id);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);


--
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- Name: cronograma_tratamientos cronograma_tratamientos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cronograma_tratamientos
    ADD CONSTRAINT cronograma_tratamientos_pkey PRIMARY KEY (id);


--
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detallecompra);


--
-- Name: detalle_compras detalle_compras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compras
    ADD CONSTRAINT detalle_compras_pkey PRIMARY KEY (id);


--
-- Name: detalle_donacion_insumo detalle_donacion_insumo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT detalle_donacion_insumo_pkey PRIMARY KEY (id_detalle);


--
-- Name: detalle_donacion_insumos detalle_donacion_insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumos
    ADD CONSTRAINT detalle_donacion_insumos_pkey PRIMARY KEY (id);


--
-- Name: detalle_facturas_legales detalle_facturas_legales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_facturas_legales
    ADD CONSTRAINT detalle_facturas_legales_pkey PRIMARY KEY (id);


--
-- Name: detalle_salida_lotes detalle_salida_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_pkey PRIMARY KEY (id);


--
-- Name: detalle_salida_lotes detalle_salida_lotes_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_unique UNIQUE (id_detalle_salida, id_inventario_lote);


--
-- Name: detalle_salida detalle_salida_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT detalle_salida_pkey PRIMARY KEY (id_detallesalida);


--
-- Name: detalle_salidas detalle_salidas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salidas
    ADD CONSTRAINT detalle_salidas_pkey PRIMARY KEY (id);


--
-- Name: donacion donacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_pkey PRIMARY KEY (id_donacion);


--
-- Name: donacions donacions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacions
    ADD CONSTRAINT donacions_pkey PRIMARY KEY (id);


--
-- Name: donante donante_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donante
    ADD CONSTRAINT donante_pkey PRIMARY KEY (id_donante);


--
-- Name: donantes donantes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donantes
    ADD CONSTRAINT donantes_pkey PRIMARY KEY (id);


--
-- Name: dosificaciones_fiscales dosificaciones_fiscales_numero_autorizacion_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dosificaciones_fiscales
    ADD CONSTRAINT dosificaciones_fiscales_numero_autorizacion_unique UNIQUE (numero_autorizacion);


--
-- Name: dosificaciones_fiscales dosificaciones_fiscales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dosificaciones_fiscales
    ADD CONSTRAINT dosificaciones_fiscales_pkey PRIMARY KEY (id);


--
-- Name: evaluacion_idoneidad evaluacion_idoneidad_id_interesado_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluacion_idoneidad
    ADD CONSTRAINT evaluacion_idoneidad_id_interesado_key UNIQUE (id_interesado);


--
-- Name: evaluacion_idoneidad evaluacion_idoneidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluacion_idoneidad
    ADD CONSTRAINT evaluacion_idoneidad_pkey PRIMARY KEY (id_evaluacion);


--
-- Name: expediente_digital expediente_digital_id_mascota_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expediente_digital
    ADD CONSTRAINT expediente_digital_id_mascota_key UNIQUE (id_mascota);


--
-- Name: expediente_digital expediente_digital_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expediente_digital
    ADD CONSTRAINT expediente_digital_pkey PRIMARY KEY (nro_expediente);


--
-- Name: facturas_compras facturas_compras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_compras
    ADD CONSTRAINT facturas_compras_pkey PRIMARY KEY (id);


--
-- Name: facturas_legales facturas_legales_numero_autorizacion_numero_factura_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_legales
    ADD CONSTRAINT facturas_legales_numero_autorizacion_numero_factura_unique UNIQUE (numero_autorizacion, numero_factura);


--
-- Name: facturas_legales facturas_legales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_legales
    ADD CONSTRAINT facturas_legales_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: historial_clinico historial_clinico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT historial_clinico_pkey PRIMARY KEY (id_historial);


--
-- Name: historial_clinicos historial_clinicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinicos
    ADD CONSTRAINT historial_clinicos_pkey PRIMARY KEY (id);


--
-- Name: interesado_adopcion interesado_adopcion_ci_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interesado_adopcion
    ADD CONSTRAINT interesado_adopcion_ci_key UNIQUE (ci);


--
-- Name: interesado_adopcion interesado_adopcion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interesado_adopcion
    ADD CONSTRAINT interesado_adopcion_pkey PRIMARY KEY (id_interesado);


--
-- Name: interesado_adopcions interesado_adopcions_ci_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interesado_adopcions
    ADD CONSTRAINT interesado_adopcions_ci_unique UNIQUE (ci);


--
-- Name: interesado_adopcions interesado_adopcions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interesado_adopcions
    ADD CONSTRAINT interesado_adopcions_pkey PRIMARY KEY (id);


--
-- Name: inventario_lotes inventario_lotes_id_detalle_compra_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_compra_unique UNIQUE (id_detalle_compra);


--
-- Name: inventario_lotes inventario_lotes_id_detalle_donacion_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_donacion_unique UNIQUE (id_detalle_donacion);


--
-- Name: inventario_lotes inventario_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: mascota mascota_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mascota
    ADD CONSTRAINT mascota_pkey PRIMARY KEY (id_mascota);


--
-- Name: mascotas mascotas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mascotas
    ADD CONSTRAINT mascotas_pkey PRIMARY KEY (id);


--
-- Name: medicamento medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id_medicamento);


--
-- Name: medicamentos medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: prescripciones_dosificacion prescripciones_dosificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescripciones_dosificacion
    ADD CONSTRAINT prescripciones_dosificacion_pkey PRIMARY KEY (id);


--
-- Name: proveedor proveedor_nombre_empresa_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_nombre_empresa_key UNIQUE (nombre_empresa);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);


--
-- Name: proveedors proveedors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedors
    ADD CONSTRAINT proveedors_pkey PRIMARY KEY (id);


--
-- Name: rol_permiso rol_permiso_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_nombre_rol_key UNIQUE (nombre_rol);


--
-- Name: rol_permiso rol_permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_pkey PRIMARY KEY (id_rol);


--
-- Name: salida_inventario salida_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventario
    ADD CONSTRAINT salida_inventario_pkey PRIMARY KEY (id_salida);


--
-- Name: salida_inventarios salida_inventarios_historial_clinico_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_historial_clinico_unique UNIQUE (id_historial_clinico);


--
-- Name: salida_inventarios salida_inventarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_pkey PRIMARY KEY (id);


--
-- Name: seguimiento_adopcion seguimiento_adopcion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT seguimiento_adopcion_pkey PRIMARY KEY (id_seguimiento);


--
-- Name: seguimiento_adopcions seguimiento_adopcions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcions
    ADD CONSTRAINT seguimiento_adopcions_pkey PRIMARY KEY (id);


--
-- Name: sesion_jwt sesion_jwt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sesion_jwt
    ADD CONSTRAINT sesion_jwt_pkey PRIMARY KEY (token_hash);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: tipo_aporte tipo_aporte_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_aporte
    ADD CONSTRAINT tipo_aporte_nombre_key UNIQUE (nombre);


--
-- Name: tipo_aporte tipo_aporte_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_aporte
    ADD CONSTRAINT tipo_aporte_pkey PRIMARY KEY (id_tipoaporte);


--
-- Name: tipo_aportes tipo_aportes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_aportes
    ADD CONSTRAINT tipo_aportes_pkey PRIMARY KEY (id);


--
-- Name: users users_ci_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_ci_unique UNIQUE (ci);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_ci_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_ci_key UNIQUE (ci);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: ajuste_inventarios_articulo_created_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ajuste_inventarios_articulo_created_index ON public.ajuste_inventarios USING btree (id_articulo, created_at);


--
-- Name: ajuste_inventarios_created_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ajuste_inventarios_created_id_index ON public.ajuste_inventarios USING btree (created_at, id);


--
-- Name: auditoria_forense_modulo_fecha_evento_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditoria_forense_modulo_fecha_evento_index ON public.auditoria_forense USING btree (modulo, fecha_evento);


--
-- Name: auditoria_forense_severidad_fecha_evento_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditoria_forense_severidad_fecha_evento_index ON public.auditoria_forense USING btree (severidad, fecha_evento);


--
-- Name: bitacoras_created_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bitacoras_created_id_index ON public.bitacoras USING btree (created_at, id);


--
-- Name: bitacoras_modulo_resultado_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bitacoras_modulo_resultado_index ON public.bitacoras USING btree (modulo, resultado);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: failed_jobs_connection_queue_failed_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX failed_jobs_connection_queue_failed_at_index ON public.failed_jobs USING btree (connection, queue, failed_at);


--
-- Name: idx_adopcion_interesado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_adopcion_interesado ON public.adopcion USING btree (id_interesado);


--
-- Name: idx_adopcion_mascota; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_adopcion_mascota ON public.adopcion USING btree (id_mascota);


--
-- Name: idx_articulo_categoria; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_articulo_categoria ON public.articulo_inventario USING btree (categoria);


--
-- Name: idx_bitacora_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bitacora_fecha ON public.bitacora USING btree (fecha);


--
-- Name: idx_bitacora_usuario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bitacora_usuario ON public.bitacora USING btree (id_usuario);


--
-- Name: idx_donacion_donante; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_donacion_donante ON public.donacion USING btree (id_donante);


--
-- Name: idx_historial_mascota; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_historial_mascota ON public.historial_clinico USING btree (id_mascota);


--
-- Name: idx_mascota_especie; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mascota_especie ON public.mascota USING btree (especie);


--
-- Name: idx_mascota_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mascota_estado ON public.mascota USING btree (estado_actual);


--
-- Name: idx_seguimiento_adopcion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_seguimiento_adopcion ON public.seguimiento_adopcion USING btree (id_adopcion);


--
-- Name: idx_usuario_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usuario_ci ON public.usuario USING btree (ci);


--
-- Name: idx_usuario_rol; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usuario_rol ON public.usuario USING btree (rol);


--
-- Name: interesado_adopcions_estado_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX interesado_adopcions_estado_index ON public.interesado_adopcions USING btree (estado);


--
-- Name: inventario_lotes_fefo_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventario_lotes_fefo_index ON public.inventario_lotes USING btree (id_articulo, fecha_vencimiento, cantidad_disponible);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: medicamentos_es_inyectable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX medicamentos_es_inyectable_index ON public.medicamentos USING btree (es_inyectable);


--
-- Name: medicamentos_id_medicamento_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX medicamentos_id_medicamento_index ON public.medicamentos USING btree (id_medicamento);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: proveedors_active_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX proveedors_active_name_index ON public.proveedors USING btree (activo, nombre_empresa);


--
-- Name: proveedors_identificacion_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX proveedors_identificacion_index ON public.proveedors USING btree (identificacion);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: adopcion tr_actualizar_estado_mascota_adopcion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_actualizar_estado_mascota_adopcion AFTER INSERT ON public.adopcion FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_estado_mascota_adopcion();


--
-- Name: historial_clinico tr_actualizar_estado_por_historial; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_actualizar_estado_por_historial AFTER INSERT ON public.historial_clinico FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_estado_por_historial();


--
-- Name: detalle_compra tr_actualizar_stock_compra; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_actualizar_stock_compra AFTER INSERT ON public.detalle_compra FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_stock_por_compra();


--
-- Name: detalle_salida tr_descontar_stock_salida; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_descontar_stock_salida AFTER INSERT ON public.detalle_salida FOR EACH ROW EXECUTE FUNCTION public.fn_descontar_stock_por_salida();


--
-- Name: adopcion tr_registrar_bitacora_adopcion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_registrar_bitacora_adopcion AFTER INSERT ON public.adopcion FOR EACH ROW EXECUTE FUNCTION public.fn_registrar_bitacora_adopcion();


--
-- Name: adopcions tr_sync_adopcions; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_adopcions AFTER INSERT OR UPDATE ON public.adopcions FOR EACH ROW EXECUTE FUNCTION public.fn_sync_adopcions_to_singular();


--
-- Name: articulo_inventarios tr_sync_articulos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_articulos AFTER INSERT OR UPDATE ON public.articulo_inventarios FOR EACH ROW EXECUTE FUNCTION public.fn_sync_articulos_to_singular();


--
-- Name: donacions tr_sync_donacions; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_donacions AFTER INSERT OR UPDATE ON public.donacions FOR EACH ROW EXECUTE FUNCTION public.fn_sync_donacions_to_singular();


--
-- Name: donantes tr_sync_donantes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_donantes AFTER INSERT OR UPDATE ON public.donantes FOR EACH ROW EXECUTE FUNCTION public.fn_sync_donantes_to_singular();


--
-- Name: interesado_adopcions tr_sync_interesados; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_interesados AFTER INSERT OR UPDATE ON public.interesado_adopcions FOR EACH ROW EXECUTE FUNCTION public.fn_sync_interesados_to_singular();


--
-- Name: mascotas tr_sync_mascotas; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_mascotas AFTER INSERT OR UPDATE ON public.mascotas FOR EACH ROW EXECUTE FUNCTION public.fn_sync_mascotas_to_mascota();


--
-- Name: proveedors tr_sync_proveedors; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_proveedors AFTER INSERT OR UPDATE ON public.proveedors FOR EACH ROW EXECUTE FUNCTION public.fn_sync_proveedors_to_singular();


--
-- Name: seguimiento_adopcions tr_sync_seguimientos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_seguimientos AFTER INSERT OR UPDATE ON public.seguimiento_adopcions FOR EACH ROW EXECUTE FUNCTION public.fn_sync_seguimientos_to_singular();


--
-- Name: users tr_sync_users; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_users AFTER INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.fn_sync_users_to_usuario();


--
-- Name: articulo_inventario tr_verificar_stock_minimo_alerta; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_verificar_stock_minimo_alerta AFTER UPDATE OF stock_actual ON public.articulo_inventario FOR EACH ROW EXECUTE FUNCTION public.fn_verificar_stock_minimo_alerta();


--
-- Name: medicamentos trg_sync_medicamentos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_sync_medicamentos AFTER INSERT OR UPDATE ON public.medicamentos FOR EACH ROW EXECUTE FUNCTION public.sync_medicamentos_to_medicamento();


--
-- Name: adopcions adopcions_id_interesado_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcions
    ADD CONSTRAINT adopcions_id_interesado_foreign FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcions(id) ON DELETE CASCADE;


--
-- Name: adopcions adopcions_id_mascota_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcions
    ADD CONSTRAINT adopcions_id_mascota_foreign FOREIGN KEY (id_mascota) REFERENCES public.mascotas(id) ON DELETE CASCADE;


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_id_ajuste_inventario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_id_ajuste_inventario_foreign FOREIGN KEY (id_ajuste_inventario) REFERENCES public.ajuste_inventarios(id) ON DELETE RESTRICT;


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_id_inventario_lote_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_id_inventario_lote_foreign FOREIGN KEY (id_inventario_lote) REFERENCES public.inventario_lotes(id) ON DELETE RESTRICT;


--
-- Name: ajuste_inventarios ajuste_inventarios_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventarios
    ADD CONSTRAINT ajuste_inventarios_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE RESTRICT;


--
-- Name: ajuste_inventarios ajuste_inventarios_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ajuste_inventarios
    ADD CONSTRAINT ajuste_inventarios_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: aporte_dineros aporte_dineros_id_donacion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dineros
    ADD CONSTRAINT aporte_dineros_id_donacion_foreign FOREIGN KEY (id_donacion) REFERENCES public.donacions(id) ON DELETE CASCADE;


--
-- Name: auditoria_forense auditoria_forense_usuario_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria_forense
    ADD CONSTRAINT auditoria_forense_usuario_id_foreign FOREIGN KEY (usuario_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: bitacoras bitacoras_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacoras
    ADD CONSTRAINT bitacoras_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: cierres_periodos_reportes cierres_periodos_reportes_generado_por_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cierres_periodos_reportes
    ADD CONSTRAINT cierres_periodos_reportes_generado_por_foreign FOREIGN KEY (generado_por) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: compras compras_id_proveedor_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_id_proveedor_foreign FOREIGN KEY (id_proveedor) REFERENCES public.proveedors(id) ON DELETE CASCADE;


--
-- Name: compras compras_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: cronograma_tratamientos cronograma_tratamientos_administrado_por_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cronograma_tratamientos
    ADD CONSTRAINT cronograma_tratamientos_administrado_por_foreign FOREIGN KEY (administrado_por) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: cronograma_tratamientos cronograma_tratamientos_lote_inventario_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cronograma_tratamientos
    ADD CONSTRAINT cronograma_tratamientos_lote_inventario_id_foreign FOREIGN KEY (lote_inventario_id) REFERENCES public.inventario_lotes(id) ON DELETE SET NULL;


--
-- Name: cronograma_tratamientos cronograma_tratamientos_prescripcion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cronograma_tratamientos
    ADD CONSTRAINT cronograma_tratamientos_prescripcion_id_foreign FOREIGN KEY (prescripcion_id) REFERENCES public.prescripciones_dosificacion(id) ON DELETE CASCADE;


--
-- Name: detalle_compras detalle_compras_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compras
    ADD CONSTRAINT detalle_compras_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: detalle_compras detalle_compras_id_compra_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compras
    ADD CONSTRAINT detalle_compras_id_compra_foreign FOREIGN KEY (id_compra) REFERENCES public.compras(id) ON DELETE CASCADE;


--
-- Name: detalle_donacion_insumos detalle_donacion_insumos_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumos
    ADD CONSTRAINT detalle_donacion_insumos_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: detalle_donacion_insumos detalle_donacion_insumos_id_donacion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumos
    ADD CONSTRAINT detalle_donacion_insumos_id_donacion_foreign FOREIGN KEY (id_donacion) REFERENCES public.donacions(id) ON DELETE CASCADE;


--
-- Name: detalle_facturas_legales detalle_facturas_legales_factura_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_facturas_legales
    ADD CONSTRAINT detalle_facturas_legales_factura_id_foreign FOREIGN KEY (factura_id) REFERENCES public.facturas_legales(id) ON DELETE CASCADE;


--
-- Name: detalle_salida_lotes detalle_salida_lotes_id_detalle_salida_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_id_detalle_salida_foreign FOREIGN KEY (id_detalle_salida) REFERENCES public.detalle_salidas(id) ON DELETE CASCADE;


--
-- Name: detalle_salida_lotes detalle_salida_lotes_id_inventario_lote_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_id_inventario_lote_foreign FOREIGN KEY (id_inventario_lote) REFERENCES public.inventario_lotes(id) ON DELETE RESTRICT;


--
-- Name: detalle_salidas detalle_salidas_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salidas
    ADD CONSTRAINT detalle_salidas_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: detalle_salidas detalle_salidas_id_salida_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salidas
    ADD CONSTRAINT detalle_salidas_id_salida_foreign FOREIGN KEY (id_salida) REFERENCES public.salida_inventarios(id) ON DELETE CASCADE;


--
-- Name: donacions donacions_id_donante_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacions
    ADD CONSTRAINT donacions_id_donante_foreign FOREIGN KEY (id_donante) REFERENCES public.donantes(id) ON DELETE CASCADE;


--
-- Name: donacions donacions_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacions
    ADD CONSTRAINT donacions_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: dosificaciones_fiscales dosificaciones_fiscales_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dosificaciones_fiscales
    ADD CONSTRAINT dosificaciones_fiscales_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: facturas_compras facturas_compras_proveedor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_compras
    ADD CONSTRAINT facturas_compras_proveedor_id_foreign FOREIGN KEY (proveedor_id) REFERENCES public.proveedors(id) ON DELETE RESTRICT;


--
-- Name: facturas_compras facturas_compras_registrado_por_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_compras
    ADD CONSTRAINT facturas_compras_registrado_por_foreign FOREIGN KEY (registrado_por) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: facturas_legales facturas_legales_dosificacion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_legales
    ADD CONSTRAINT facturas_legales_dosificacion_id_foreign FOREIGN KEY (dosificacion_id) REFERENCES public.dosificaciones_fiscales(id) ON DELETE RESTRICT;


--
-- Name: facturas_legales facturas_legales_usuario_anulador_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_legales
    ADD CONSTRAINT facturas_legales_usuario_anulador_id_foreign FOREIGN KEY (usuario_anulador_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: facturas_legales facturas_legales_usuario_emisor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_legales
    ADD CONSTRAINT facturas_legales_usuario_emisor_id_foreign FOREIGN KEY (usuario_emisor_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: adopcion fk_adopcion_interesado; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT fk_adopcion_interesado FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcion(id_interesado) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: adopcion fk_adopcion_mascota; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT fk_adopcion_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: alerta_inventario fk_alerta_articulo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_inventario
    ADD CONSTRAINT fk_alerta_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: aporte_dinero fk_aporte_donacion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT fk_aporte_donacion FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bitacora fk_bitacora_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT fk_bitacora_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: compra fk_compra_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: compra fk_compra_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_compra fk_detallecompra_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detallecompra_cabecera FOREIGN KEY (id_compra) REFERENCES public.compra(id_compra) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: detalle_compra fk_detallecompra_insumo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detallecompra_insumo FOREIGN KEY (id_insumo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_salida fk_detallesalida_articulo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT fk_detallesalida_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_salida fk_detallesalida_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT fk_detallesalida_cabecera FOREIGN KEY (id_salida) REFERENCES public.salida_inventario(id_salida) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: donacion fk_donacion_donante; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_donante FOREIGN KEY (id_donante) REFERENCES public.donante(id_donante) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: donacion fk_donacion_tipo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_tipo FOREIGN KEY (tipo_aporte) REFERENCES public.tipo_aporte(id_tipoaporte) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: donacion fk_donacion_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_donacion_insumo fk_donacioninsumo_articulo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT fk_donacioninsumo_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_donacion_insumo fk_donacioninsumo_donacion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT fk_donacioninsumo_donacion FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: evaluacion_idoneidad fk_evaluacion_interesado; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluacion_idoneidad
    ADD CONSTRAINT fk_evaluacion_interesado FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcion(id_interesado) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: expediente_digital fk_expediente_mascota; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expediente_digital
    ADD CONSTRAINT fk_expediente_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historial_clinico fk_historial_mascota; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT fk_historial_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historial_clinico fk_historial_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: salida_inventario fk_salida_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventario
    ADD CONSTRAINT fk_salida_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: seguimiento_adopcion fk_seguimiento_adopcion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT fk_seguimiento_adopcion FOREIGN KEY (id_adopcion) REFERENCES public.adopcion(id_adopcion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: seguimiento_adopcion fk_seguimiento_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT fk_seguimiento_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sesion_jwt fk_sesion_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sesion_jwt
    ADD CONSTRAINT fk_sesion_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historial_clinicos historial_clinicos_id_mascota_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinicos
    ADD CONSTRAINT historial_clinicos_id_mascota_foreign FOREIGN KEY (id_mascota) REFERENCES public.mascotas(id) ON DELETE CASCADE;


--
-- Name: historial_clinicos historial_clinicos_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinicos
    ADD CONSTRAINT historial_clinicos_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: inventario_lotes inventario_lotes_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: inventario_lotes inventario_lotes_id_detalle_compra_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_compra_foreign FOREIGN KEY (id_detalle_compra) REFERENCES public.detalle_compras(id) ON DELETE SET NULL;


--
-- Name: inventario_lotes inventario_lotes_id_detalle_donacion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_donacion_foreign FOREIGN KEY (id_detalle_donacion) REFERENCES public.detalle_donacion_insumos(id) ON DELETE SET NULL;


--
-- Name: prescripciones_dosificacion prescripciones_dosificacion_articulo_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescripciones_dosificacion
    ADD CONSTRAINT prescripciones_dosificacion_articulo_id_foreign FOREIGN KEY (articulo_id) REFERENCES public.articulo_inventarios(id) ON DELETE RESTRICT;


--
-- Name: prescripciones_dosificacion prescripciones_dosificacion_historial_clinico_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescripciones_dosificacion
    ADD CONSTRAINT prescripciones_dosificacion_historial_clinico_id_foreign FOREIGN KEY (historial_clinico_id) REFERENCES public.historial_clinicos(id) ON DELETE SET NULL;


--
-- Name: prescripciones_dosificacion prescripciones_dosificacion_mascota_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescripciones_dosificacion
    ADD CONSTRAINT prescripciones_dosificacion_mascota_id_foreign FOREIGN KEY (mascota_id) REFERENCES public.mascotas(id) ON DELETE RESTRICT;


--
-- Name: prescripciones_dosificacion prescripciones_dosificacion_veterinario_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescripciones_dosificacion
    ADD CONSTRAINT prescripciones_dosificacion_veterinario_id_foreign FOREIGN KEY (veterinario_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: salida_inventarios salida_inventarios_historial_clinico_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_historial_clinico_foreign FOREIGN KEY (id_historial_clinico) REFERENCES public.historial_clinicos(id) ON DELETE SET NULL;


--
-- Name: salida_inventarios salida_inventarios_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: seguimiento_adopcions seguimiento_adopcions_id_adopcion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcions
    ADD CONSTRAINT seguimiento_adopcions_id_adopcion_foreign FOREIGN KEY (id_adopcion) REFERENCES public.adopcions(id) ON DELETE CASCADE;


--
-- Name: seguimiento_adopcions seguimiento_adopcions_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcions
    ADD CONSTRAINT seguimiento_adopcions_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


