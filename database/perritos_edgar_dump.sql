--
-- PostgreSQL database dump
--

-- \restrict nFSepjz2fwUeLI23IVGwYY1q3w42heKdQETZBvLWlMUafEePgABGzyphShwTwqv

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
-- SET transaction_timeout = 0;
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
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_detalle_donacion_foreign;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_detalle_compra_foreign;
ALTER TABLE IF EXISTS ONLY public.inventario_lotes DROP CONSTRAINT IF EXISTS inventario_lotes_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.historial_clinicos DROP CONSTRAINT IF EXISTS historial_clinicos_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.historial_clinicos DROP CONSTRAINT IF EXISTS historial_clinicos_id_mascota_foreign;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcion DROP CONSTRAINT IF EXISTS fk_seguimiento_usuario;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcion DROP CONSTRAINT IF EXISTS fk_seguimiento_adopcion;
ALTER TABLE IF EXISTS ONLY public.salida_inventario DROP CONSTRAINT IF EXISTS fk_salida_usuario;
ALTER TABLE IF EXISTS ONLY public.historial_clinico DROP CONSTRAINT IF EXISTS fk_historial_usuario;
ALTER TABLE IF EXISTS ONLY public.historial_clinico DROP CONSTRAINT IF EXISTS fk_historial_mascota;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS fk_donacion_usuario;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS fk_donacion_tipo;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS fk_donacion_donante;
ALTER TABLE IF EXISTS ONLY public.detalle_salida DROP CONSTRAINT IF EXISTS fk_detalle_salida_cabecera;
ALTER TABLE IF EXISTS ONLY public.detalle_salida DROP CONSTRAINT IF EXISTS fk_detalle_salida_articulo;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumo DROP CONSTRAINT IF EXISTS fk_detalle_donacion_cabecera;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumo DROP CONSTRAINT IF EXISTS fk_detalle_donacion_articulo;
ALTER TABLE IF EXISTS ONLY public.detalle_compra DROP CONSTRAINT IF EXISTS fk_detalle_compra_cabecera;
ALTER TABLE IF EXISTS ONLY public.detalle_compra DROP CONSTRAINT IF EXISTS fk_detalle_compra_articulo;
ALTER TABLE IF EXISTS ONLY public.compra DROP CONSTRAINT IF EXISTS fk_compra_usuario;
ALTER TABLE IF EXISTS ONLY public.compra DROP CONSTRAINT IF EXISTS fk_compra_proveedor;
ALTER TABLE IF EXISTS ONLY public.bitacora DROP CONSTRAINT IF EXISTS fk_bitacora_usuario;
ALTER TABLE IF EXISTS ONLY public.aporte_dinero DROP CONSTRAINT IF EXISTS fk_aporte_donacion;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS fk_adopcion_mascota;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS fk_adopcion_interesado;
ALTER TABLE IF EXISTS ONLY public.donacions DROP CONSTRAINT IF EXISTS donacions_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.donacions DROP CONSTRAINT IF EXISTS donacions_id_donante_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salidas DROP CONSTRAINT IF EXISTS detalle_salidas_id_salida_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salidas DROP CONSTRAINT IF EXISTS detalle_salidas_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_id_inventario_lote_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_id_detalle_salida_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumos DROP CONSTRAINT IF EXISTS detalle_donacion_insumos_id_donacion_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumos DROP CONSTRAINT IF EXISTS detalle_donacion_insumos_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_compras DROP CONSTRAINT IF EXISTS detalle_compras_id_compra_foreign;
ALTER TABLE IF EXISTS ONLY public.detalle_compras DROP CONSTRAINT IF EXISTS detalle_compras_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.compras DROP CONSTRAINT IF EXISTS compras_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.compras DROP CONSTRAINT IF EXISTS compras_id_proveedor_foreign;
ALTER TABLE IF EXISTS ONLY public.bitacoras DROP CONSTRAINT IF EXISTS bitacoras_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.aporte_dineros DROP CONSTRAINT IF EXISTS aporte_dineros_id_donacion_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventarios DROP CONSTRAINT IF EXISTS ajuste_inventarios_id_usuario_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventarios DROP CONSTRAINT IF EXISTS ajuste_inventarios_id_articulo_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_id_inventario_lote_foreign;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_id_ajuste_inventario_foreign;
ALTER TABLE IF EXISTS ONLY public.adopcions DROP CONSTRAINT IF EXISTS adopcions_id_mascota_foreign;
ALTER TABLE IF EXISTS ONLY public.adopcions DROP CONSTRAINT IF EXISTS adopcions_id_interesado_foreign;
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
DROP INDEX IF EXISTS public.jobs_queue_index;
DROP INDEX IF EXISTS public.inventario_lotes_fefo_index;
DROP INDEX IF EXISTS public.interesado_adopcions_estado_index;
DROP INDEX IF EXISTS public.failed_jobs_connection_queue_failed_at_index;
DROP INDEX IF EXISTS public.cache_locks_expiration_index;
DROP INDEX IF EXISTS public.cache_expiration_index;
DROP INDEX IF EXISTS public.bitacoras_modulo_resultado_index;
DROP INDEX IF EXISTS public.bitacoras_created_id_index;
DROP INDEX IF EXISTS public.ajuste_inventarios_created_id_index;
DROP INDEX IF EXISTS public.ajuste_inventarios_articulo_created_index;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_ci_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_unique;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_ci_unique;
ALTER TABLE IF EXISTS ONLY public.tipo_aportes DROP CONSTRAINT IF EXISTS tipo_aportes_pkey;
ALTER TABLE IF EXISTS ONLY public.tipo_aporte DROP CONSTRAINT IF EXISTS tipo_aporte_pkey;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcions DROP CONSTRAINT IF EXISTS seguimiento_adopcions_pkey;
ALTER TABLE IF EXISTS ONLY public.seguimiento_adopcion DROP CONSTRAINT IF EXISTS seguimiento_adopcion_pkey;
ALTER TABLE IF EXISTS ONLY public.salida_inventarios DROP CONSTRAINT IF EXISTS salida_inventarios_pkey;
ALTER TABLE IF EXISTS ONLY public.salida_inventarios DROP CONSTRAINT IF EXISTS salida_inventarios_historial_clinico_unique;
ALTER TABLE IF EXISTS ONLY public.salida_inventario DROP CONSTRAINT IF EXISTS salida_inventario_pkey;
ALTER TABLE IF EXISTS ONLY public.proveedors DROP CONSTRAINT IF EXISTS proveedors_pkey;
ALTER TABLE IF EXISTS ONLY public.proveedor DROP CONSTRAINT IF EXISTS proveedor_pkey;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
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
ALTER TABLE IF EXISTS ONLY public.donantes DROP CONSTRAINT IF EXISTS donantes_pkey;
ALTER TABLE IF EXISTS ONLY public.donante DROP CONSTRAINT IF EXISTS donante_pkey;
ALTER TABLE IF EXISTS ONLY public.donacions DROP CONSTRAINT IF EXISTS donacions_pkey;
ALTER TABLE IF EXISTS ONLY public.donacion DROP CONSTRAINT IF EXISTS donacion_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_salidas DROP CONSTRAINT IF EXISTS detalle_salidas_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_salida DROP CONSTRAINT IF EXISTS detalle_salida_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_unique;
ALTER TABLE IF EXISTS ONLY public.detalle_salida_lotes DROP CONSTRAINT IF EXISTS detalle_salida_lotes_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumos DROP CONSTRAINT IF EXISTS detalle_donacion_insumos_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_donacion_insumo DROP CONSTRAINT IF EXISTS detalle_donacion_insumo_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_compras DROP CONSTRAINT IF EXISTS detalle_compras_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_compra DROP CONSTRAINT IF EXISTS detalle_compra_pkey;
ALTER TABLE IF EXISTS ONLY public.compras DROP CONSTRAINT IF EXISTS compras_pkey;
ALTER TABLE IF EXISTS ONLY public.compra DROP CONSTRAINT IF EXISTS compra_pkey;
ALTER TABLE IF EXISTS ONLY public.cache DROP CONSTRAINT IF EXISTS cache_pkey;
ALTER TABLE IF EXISTS ONLY public.cache_locks DROP CONSTRAINT IF EXISTS cache_locks_pkey;
ALTER TABLE IF EXISTS ONLY public.bitacoras DROP CONSTRAINT IF EXISTS bitacoras_pkey;
ALTER TABLE IF EXISTS ONLY public.bitacora DROP CONSTRAINT IF EXISTS bitacora_pkey;
ALTER TABLE IF EXISTS ONLY public.articulo_inventarios DROP CONSTRAINT IF EXISTS articulo_inventarios_pkey;
ALTER TABLE IF EXISTS ONLY public.articulo_inventarios DROP CONSTRAINT IF EXISTS articulo_inventarios_nombre_unique;
ALTER TABLE IF EXISTS ONLY public.articulo_inventario DROP CONSTRAINT IF EXISTS articulo_inventario_pkey;
ALTER TABLE IF EXISTS ONLY public.aporte_dineros DROP CONSTRAINT IF EXISTS aporte_dineros_pkey;
ALTER TABLE IF EXISTS ONLY public.aporte_dinero DROP CONSTRAINT IF EXISTS aporte_dinero_pkey;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventarios DROP CONSTRAINT IF EXISTS ajuste_inventarios_pkey;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_unique;
ALTER TABLE IF EXISTS ONLY public.ajuste_inventario_lotes DROP CONSTRAINT IF EXISTS ajuste_inventario_lotes_pkey;
ALTER TABLE IF EXISTS ONLY public.adopcions DROP CONSTRAINT IF EXISTS adopcions_pkey;
ALTER TABLE IF EXISTS ONLY public.adopcion DROP CONSTRAINT IF EXISTS adopcion_pkey;
ALTER TABLE IF EXISTS public.usuario ALTER COLUMN id_usuario DROP DEFAULT;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_aportes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_aporte ALTER COLUMN id_tipoaporte DROP DEFAULT;
ALTER TABLE IF EXISTS public.seguimiento_adopcions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seguimiento_adopcion ALTER COLUMN id_seguimiento DROP DEFAULT;
ALTER TABLE IF EXISTS public.salida_inventarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.salida_inventario ALTER COLUMN id_salida DROP DEFAULT;
ALTER TABLE IF EXISTS public.proveedors ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.proveedor ALTER COLUMN id_proveedor DROP DEFAULT;
ALTER TABLE IF EXISTS public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.migrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.mascotas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.mascota ALTER COLUMN id_mascota DROP DEFAULT;
ALTER TABLE IF EXISTS public.jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inventario_lotes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.interesado_adopcions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.interesado_adopcion ALTER COLUMN id_interesado DROP DEFAULT;
ALTER TABLE IF EXISTS public.historial_clinicos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.historial_clinico ALTER COLUMN id_historial DROP DEFAULT;
ALTER TABLE IF EXISTS public.failed_jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.donantes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.donante ALTER COLUMN id_donante DROP DEFAULT;
ALTER TABLE IF EXISTS public.donacions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.donacion ALTER COLUMN id_donacion DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_salidas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_salida_lotes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_salida ALTER COLUMN id_detallesalida DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_donacion_insumos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_donacion_insumo ALTER COLUMN id_detalle DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_compras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_compra ALTER COLUMN id_detallecompra DROP DEFAULT;
ALTER TABLE IF EXISTS public.compras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.compra ALTER COLUMN id_compra DROP DEFAULT;
ALTER TABLE IF EXISTS public.bitacoras ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bitacora ALTER COLUMN id_accion DROP DEFAULT;
ALTER TABLE IF EXISTS public.articulo_inventarios ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.articulo_inventario ALTER COLUMN id_articulo DROP DEFAULT;
ALTER TABLE IF EXISTS public.aporte_dineros ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.aporte_dinero ALTER COLUMN id_aporte DROP DEFAULT;
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
DROP SEQUENCE IF EXISTS public.seguimiento_adopcions_id_seq;
DROP TABLE IF EXISTS public.seguimiento_adopcions;
DROP SEQUENCE IF EXISTS public.seguimiento_adopcion_id_seguimiento_seq;
DROP TABLE IF EXISTS public.seguimiento_adopcion;
DROP SEQUENCE IF EXISTS public.salida_inventarios_id_seq;
DROP TABLE IF EXISTS public.salida_inventarios;
DROP SEQUENCE IF EXISTS public.salida_inventario_id_salida_seq;
DROP TABLE IF EXISTS public.salida_inventario;
DROP SEQUENCE IF EXISTS public.proveedors_id_seq;
DROP TABLE IF EXISTS public.proveedors;
DROP SEQUENCE IF EXISTS public.proveedor_id_proveedor_seq;
DROP TABLE IF EXISTS public.proveedor;
DROP SEQUENCE IF EXISTS public.personal_access_tokens_id_seq;
DROP TABLE IF EXISTS public.personal_access_tokens;
DROP TABLE IF EXISTS public.password_reset_tokens;
DROP SEQUENCE IF EXISTS public.migrations_id_seq;
DROP TABLE IF EXISTS public.migrations;
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
DROP SEQUENCE IF EXISTS public.detalle_donacion_insumos_id_seq;
DROP TABLE IF EXISTS public.detalle_donacion_insumos;
DROP SEQUENCE IF EXISTS public.detalle_donacion_insumo_id_detalle_seq;
DROP TABLE IF EXISTS public.detalle_donacion_insumo;
DROP SEQUENCE IF EXISTS public.detalle_compras_id_seq;
DROP TABLE IF EXISTS public.detalle_compras;
DROP SEQUENCE IF EXISTS public.detalle_compra_id_detallecompra_seq;
DROP TABLE IF EXISTS public.detalle_compra;
DROP SEQUENCE IF EXISTS public.compras_id_seq;
DROP TABLE IF EXISTS public.compras;
DROP SEQUENCE IF EXISTS public.compra_id_compra_seq;
DROP TABLE IF EXISTS public.compra;
DROP TABLE IF EXISTS public.cache_locks;
DROP TABLE IF EXISTS public.cache;
DROP SEQUENCE IF EXISTS public.bitacoras_id_seq;
DROP TABLE IF EXISTS public.bitacoras;
DROP SEQUENCE IF EXISTS public.bitacora_id_accion_seq;
DROP TABLE IF EXISTS public.bitacora;
DROP SEQUENCE IF EXISTS public.articulo_inventarios_id_seq;
DROP TABLE IF EXISTS public.articulo_inventarios;
DROP SEQUENCE IF EXISTS public.articulo_inventario_id_articulo_seq;
DROP TABLE IF EXISTS public.articulo_inventario;
DROP SEQUENCE IF EXISTS public.aporte_dineros_id_seq;
DROP TABLE IF EXISTS public.aporte_dineros;
DROP SEQUENCE IF EXISTS public.aporte_dinero_id_aporte_seq;
DROP TABLE IF EXISTS public.aporte_dinero;
DROP SEQUENCE IF EXISTS public.ajuste_inventarios_id_seq;
DROP TABLE IF EXISTS public.ajuste_inventarios;
DROP SEQUENCE IF EXISTS public.ajuste_inventario_lotes_id_seq;
DROP TABLE IF EXISTS public.ajuste_inventario_lotes;
DROP SEQUENCE IF EXISTS public.adopcions_id_seq;
DROP TABLE IF EXISTS public.adopcions;
DROP SEQUENCE IF EXISTS public.adopcion_id_adopcion_seq;
DROP TABLE IF EXISTS public.adopcion;
DROP PROCEDURE IF EXISTS public.sp_registrar_salida(IN p_usuario_id integer, IN p_articulo_id integer, IN p_cantidad numeric, IN p_motivo character varying);
DROP PROCEDURE IF EXISTS public.sp_registrar_donacion_dinero(IN p_donante_id integer, IN p_usuario_id integer, IN p_monto numeric, IN p_comprobante character varying, IN p_observaciones text);
DROP FUNCTION IF EXISTS public.fn_registrar_bitacora_adopcion();
DROP FUNCTION IF EXISTS public.fn_descontar_stock_por_salida();
DROP FUNCTION IF EXISTS public.fn_actualizar_stock_por_compra();
DROP FUNCTION IF EXISTS public.fn_actualizar_estado_por_historial();
DROP FUNCTION IF EXISTS public.fn_actualizar_estado_mascota_adopcion();
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


    IF NEW.tipo_procedimiento IN (
        'Consulta Médica',
        'Curación'
    ) THEN


        UPDATE mascota
        SET estado_actual = 'En Tratamiento',
            updated_at = CURRENT_TIMESTAMP
        WHERE id_mascota = NEW.id_mascota;


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
    SET stock_actual = stock_actual + NEW.cantidad
    WHERE id_articulo = NEW.id_articulo;


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
    SET stock_actual = stock_actual - NEW.cantidad
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


    INSERT INTO bitacora (
        id_usuario,
        fecha,
        hora,
        tipo_accion
    )
    VALUES (
        1,
        CURRENT_DATE,
        CURRENT_TIME,
        'Registro de nueva adopción - ID ' || NEW.id_adopcion
    );


    RETURN NEW;


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
BEGIN


    -- 1. Registrar la donación
    INSERT INTO donacion (
        id_donante,
        id_usuario,
        id_tipo_aporte,
        fecha
    )
    VALUES (
        p_donante_id,
        p_usuario_id,
        1,
        CURRENT_DATE
    )
    RETURNING id_donacion INTO v_donacion_id;


    -- 2. Registrar el aporte de dinero
    INSERT INTO aporte_dinero (
        id_donacion,
        monto,
        fecha_recepcion,
        comprobante,
        observaciones
    )
    VALUES (
        v_donacion_id,
        p_monto,
        CURRENT_DATE,
        p_comprobante,
        p_observaciones
    );


    RAISE NOTICE 'Donación monetaria registrada con éxito.';


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
BEGIN


    -- 1. Registrar la salida
    INSERT INTO salida_inventario (
        id_usuario,
        fecha_salida,
        motivo
    )
    VALUES (
        p_usuario_id,
        CURRENT_DATE,
        p_motivo
    )
  RETURNING id_salida INTO v_salida_id;


    -- 2. Registrar el detalle de la salida
    INSERT INTO detalle_salida (
        id_salida,
        id_articulo,
        cantidad
    )
    VALUES (
        v_salida_id,
        p_articulo_id,
        p_cantidad
    );
    -- 3. Restar la cantidad del stock actual
    UPDATE articulo_inventario
    SET stock_actual = stock_actual - p_cantidad
    WHERE id_articulo = p_articulo_id;


    RAISE NOTICE 'Salida de inventario registrada con éxito.';


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
    fecha_adopcion date NOT NULL,
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
-- Name: aporte_dinero; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aporte_dinero (
    id_aporte integer NOT NULL,
    id_donacion integer NOT NULL,
    monto numeric(10,2) NOT NULL,
    fecha_recepcion date NOT NULL,
    comprobante character varying(100),
    observaciones text
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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
-- Name: bitacora; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bitacora (
    id_accion integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha date NOT NULL,
    hora time without time zone NOT NULL,
    tipo_accion character varying(100) NOT NULL,
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
-- Name: compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_compra date NOT NULL,
    monto_total numeric(10,2) DEFAULT 0.00 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
-- Name: detalle_compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_compra (
    id_detallecompra integer NOT NULL,
    id_compra integer NOT NULL,
    id_insumo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    costo_unitario numeric(10,2) NOT NULL,
    fecha_vencimiento date
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
    fecha_vencimiento date
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
-- Name: detalle_salida; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_salida (
    id_detallesalida integer NOT NULL,
    id_salida integer NOT NULL,
    id_articulo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL
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
    fecha date NOT NULL,
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
    tipo_persona character varying(50) NOT NULL,
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
    fecha_atencion date NOT NULL,
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
    puntaje_evaluacion integer,
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
    estado_actual character varying(50) NOT NULL,
    zona_rescate character varying(150),
    fecha_ingreso date NOT NULL,
    foto character varying(255),
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
    foto character varying(255) NOT NULL,
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
-- Name: proveedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proveedor (
    id_proveedor integer NOT NULL,
    nombre_empresa character varying(150) NOT NULL,
    contacto_nombre character varying(150),
    direccion character varying(255),
    telefono character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
    activo boolean DEFAULT true NOT NULL
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
-- Name: salida_inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salida_inventario (
    id_salida integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_salida date NOT NULL,
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
    estado_seguimiento character varying(50) NOT NULL,
    fecha_programada date NOT NULL,
    fecha_realizada date,
    reporte_bienestar text,
    fotografias_evidencia character varying(255),
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
    fotografia character varying(255) NOT NULL,
    reporte_bienestar character varying(255) NOT NULL,
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
    activo boolean DEFAULT true NOT NULL,
    CONSTRAINT users_rol_check CHECK (((rol)::text = ANY ((ARRAY['Administrador'::character varying, 'Veterinario'::character varying, 'Recepcionista'::character varying, 'Voluntario'::character varying])::text[])))
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
-- Name: bitacora id_accion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora ALTER COLUMN id_accion SET DEFAULT nextval('public.bitacora_id_accion_seq'::regclass);


--
-- Name: bitacoras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacoras ALTER COLUMN id SET DEFAULT nextval('public.bitacoras_id_seq'::regclass);


--
-- Name: compra id_compra; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_id_compra_seq'::regclass);


--
-- Name: compras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);


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
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: proveedor id_proveedor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);


--
-- Name: proveedors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedors ALTER COLUMN id SET DEFAULT nextval('public.proveedors_id_seq'::regclass);


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
1	1	1	2026-02-01	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	4	3	2026-03-07	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: adopcions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.adopcions (id, fecha_adopcion, id_interesado, id_mascota, created_at, updated_at) FROM stdin;
1	2026-02-01	1	1	2026-10-28 18:24:54	2026-10-28 18:24:54
2	2026-03-07	3	4	2026-10-28 18:24:54	2026-10-28 18:24:54
\.


--
-- Data for Name: ajuste_inventario_lotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ajuste_inventario_lotes (id, id_ajuste_inventario, id_inventario_lote, cantidad) FROM stdin;
\.


--
-- Data for Name: ajuste_inventarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ajuste_inventarios (id, id_articulo, id_usuario, usuario_nombre, cantidad, stock_anterior, stock_nuevo, saldo_disponible_anterior, saldo_disponible_nuevo, motivo, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: aporte_dinero; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.aporte_dinero (id_aporte, id_donacion, monto, fecha_recepcion, comprobante, observaciones) FROM stdin;
1	2	500.00	2026-01-20	TRF-BNB-9281039	Donación para fondo de alimento de emergencia
2	4	1500.00	2026-02-18	TRF-BISA-819203	Aporte destinado exclusivamente a esterilizaciones masivas
\.


--
-- Data for Name: aporte_dineros; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.aporte_dineros (id, monto, fecha_recepcion, comprobante, observaciones, id_donacion, created_at, updated_at) FROM stdin;
1	500.00	2026-01-20	TRF-BNB-9281039	Donación para fondo de alimento de emergencia	2	2026-10-28 18:24:55	2026-10-28 18:24:55
2	1500.00	2026-02-18	TRF-BISA-819203	Aporte destinado exclusivamente a esterilizaciones masivas	4	2026-10-28 18:24:55	2026-10-28 18:24:55
\.


--
-- Data for Name: articulo_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.articulo_inventario (id_articulo, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at) FROM stdin;
2	Cat Chow Gatitos 8kg	Alimento	Bolsa	12.00	3.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	Ivermectina 1% Inyectable 50ml	Medicamento	Frasco	8.00	2.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	Lavandina Concentrada 5L	Limpieza	Bidón	15.00	4.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
5	Jeringas Descartables 3ml	Insumo Médico	Unidad	150.00	30.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
1	Croquetas Adulto Dog Chow 15kg	Alimento	Bolsa	6.00	5.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: articulo_inventarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.articulo_inventarios (id, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at) FROM stdin;
1	Croquetas Adulto Dog Chow 15kg	Alimento	Bolsa	25.00	5.00	2026-10-28 18:24:55	2026-10-28 18:24:55
2	Cat Chow Gatitos 8kg	Alimento	Bolsa	12.00	3.00	2026-10-28 18:24:55	2026-10-28 18:24:55
3	Ivermectina 1% Inyectable 50ml	Medicamento	Frasco	8.00	2.00	2026-10-28 18:24:55	2026-10-28 18:24:55
4	Lavandina Concentrada 5L	Limpieza	Bidón	15.00	4.00	2026-10-28 18:24:55	2026-10-28 18:24:55
5	Jeringas Descartables 3ml	Insumo Médico	Unidad	150.00	30.00	2026-10-28 18:24:55	2026-10-28 18:24:55
\.


--
-- Data for Name: bitacora; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bitacora (id_accion, id_usuario, fecha, hora, tipo_accion, created_at) FROM stdin;
1	1	2026-03-01	08:30:00	Inicio de sesión en el sistema	2026-09-10 14:01:57.229297
2	2	2026-03-01	09:15:00	Registro de consulta clínica - Mascota ID 1	2026-09-10 14:01:57.229297
3	5	2026-03-02	10:00:00	Registro de nuevo interesado en adopción	2026-09-10 14:01:57.229297
4	1	2026-03-02	11:30:00	Aprobación de solicitud de adopción ID 1	2026-09-10 14:01:57.229297
5	3	2026-03-03	14:20:00	Registro de salida de alimentos de inventario	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: bitacoras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bitacoras (id, tipo_accion, id_usuario, created_at, updated_at, usuario_nombre, modulo, descripcion, entidad_tipo, entidad_id, ip, http_method, ruta, resultado, contexto) FROM stdin;
1	Inicio de sesión en el sistema	1	2026-03-01 08:30:00	2026-03-01 08:30:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
2	Registro de consulta clínica - Mascota ID 1	2	2026-03-01 09:15:00	2026-03-01 09:15:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
3	Registro de nuevo interesado en adopción	5	2026-03-02 10:00:00	2026-03-02 10:00:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
4	Aprobación de solicitud de adopción ID 1	1	2026-03-02 11:30:00	2026-03-02 11:30:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
5	Registro de salida de alimentos de inventario	3	2026-03-03 14:20:00	2026-03-03 14:20:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.compra (id_compra, id_proveedor, id_usuario, fecha_compra, monto_total, created_at, updated_at) FROM stdin;
1	1	1	2026-01-05	1250.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	3	1	2026-02-02	840.00	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.compras (id, monto_total, fecha_compra, id_proveedor, id_usuario, created_at, updated_at, numero_documento) FROM stdin;
1	1250.00	2026-01-05	1	1	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
2	840.00	2026-02-02	3	1	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
\.


--
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_compra (id_detallecompra, id_compra, id_insumo, cantidad, costo_unitario, fecha_vencimiento) FROM stdin;
1	1	1	10.00	125.00	2027-05-20
2	2	3	4.00	85.00	2028-01-15
3	2	5	100.00	5.00	2028-10-10
\.


--
-- Data for Name: detalle_compras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_compras (id, costo_unitario, fecha_vencimiento, cantidad, id_compra, id_articulo, created_at, updated_at) FROM stdin;
1	125.00	2027-05-20	10.00	1	1	2026-10-28 18:24:55	2026-10-28 18:24:55
2	85.00	2028-01-15	4.00	2	3	2026-10-28 18:24:55	2026-10-28 18:24:55
3	5.00	2028-10-10	100.00	2	5	2026-10-28 18:24:55	2026-10-28 18:24:55
\.


--
-- Data for Name: detalle_donacion_insumo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_donacion_insumo (id_detalle, id_donacion, id_articulo, cantidad, fecha_vencimiento) FROM stdin;
1	1	1	20.00	2027-06-30
2	3	3	5.00	2027-12-31
3	3	5	100.00	2028-05-15
\.


--
-- Data for Name: detalle_donacion_insumos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_donacion_insumos (id, fecha_vencimiento, cantidad, id_donacion, id_articulo, created_at, updated_at) FROM stdin;
1	2027-06-30	20.00	1	1	2026-10-28 18:24:55	2026-10-28 18:24:55
2	2027-12-31	5.00	3	3	2026-10-28 18:24:55	2026-10-28 18:24:55
3	2028-05-15	100.00	3	5	2026-10-28 18:24:55	2026-10-28 18:24:55
\.


--
-- Data for Name: detalle_salida; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_salida (id_detallesalida, id_salida, id_articulo, cantidad) FROM stdin;
1	1	1	3.00
2	2	3	1.00
3	2	5	10.00
4	3	4	2.00
5	4	1	2.00
6	1	1	5.00
7	1	1	5.00
8	1	1	5.00
\.


--
-- Data for Name: detalle_salida_lotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_salida_lotes (id, id_detalle_salida, id_inventario_lote, cantidad, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: detalle_salidas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_salidas (id, cantidad, id_salida, id_articulo, created_at, updated_at) FROM stdin;
1	3.00	1	1	2026-10-28 18:24:55	2026-10-28 18:24:55
2	1.00	2	3	2026-10-28 18:24:55	2026-10-28 18:24:55
3	10.00	2	5	2026-10-28 18:24:55	2026-10-28 18:24:55
4	2.00	3	4	2026-10-28 18:24:55	2026-10-28 18:24:55
\.


--
-- Data for Name: donacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donacion (id_donacion, id_donante, id_usuario, tipo_aporte, fecha, created_at, updated_at) FROM stdin;
1	1	1	2	2026-01-10	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	3	5	1	2026-01-20	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	4	2	3	2026-02-05	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	2	1	1	2026-02-18	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
5	5	5	5	2026-03-05	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: donacions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donacions (id, tipo_aporte, fecha, id_donante, id_usuario, created_at, updated_at, numero_documento) FROM stdin;
1	Alimento Seco	2026-01-10	1	1	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
2	Efectivo / Transferencia	2026-01-20	3	5	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
3	Insumos Médicos	2026-02-05	4	2	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
4	Efectivo / Transferencia	2026-02-18	2	1	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
5	Mobiliario / Accesorios	2026-03-05	5	5	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
\.


--
-- Data for Name: donante; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donante (id_donante, nombre, tipo_persona, telefono, created_at, updated_at) FROM stdin;
1	Empresa Avícola Sofía	Jurídica	70019283	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	Fundación Bienestar Animal	Jurídica	33492019	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	Roberto Pinto Saucedo	Natural	71390219	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	Farmacia Chávez S.A.	Jurídica	800102030	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
5	Gabriela Arteaga	Natural	76019283	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: donantes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.donantes (id, nombre, telefono, tipo_persona, created_at, updated_at) FROM stdin;
1	Empresa Avícola Sofía	70019283	Jurídica	2026-10-28 18:24:55	2026-10-28 18:24:55
2	Fundación Bienestar Animal	33492019	Jurídica	2026-10-28 18:24:55	2026-10-28 18:24:55
3	Roberto Pinto Saucedo	71390219	Natural	2026-10-28 18:24:55	2026-10-28 18:24:55
4	Farmacia Chávez S.A.	800102030	Jurídica	2026-10-28 18:24:55	2026-10-28 18:24:55
5	Gabriela Arteaga	76019283	Natural	2026-10-28 18:24:55	2026-10-28 18:24:55
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
1	1	2	2026-01-16	Evaluación Inicial	Desnutrición leve y parasitosis intestinal.	Se administra antiparasitario interno y suplemento vitamínico.	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	2	2	2026-02-11	Consulta Médica	Infección respiratoria felina (Pérdida de apetito).	Tratamiento con antibiótico por 7 días y nebulización.	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	3	4	2026-03-02	Cirugía de Esterilización	Paciente clínicamente sano, apto para procedimiento.	Cirugía realizada sin complicaciones. Postoperatorio en observación.	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	4	2	2026-03-05	Vacunación	Saludable.	Aplicación de vacuna trivalente felina y desparasitación.	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
5	5	4	2026-03-06	Curación	Laceración superficial en pata delantera izquierda.	Limpieza de herida y aplicación de antiséptico en spray.	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: historial_clinicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.historial_clinicos (id, fecha_atencion, diagnostico, observacion, tipo_procedimiento, id_mascota, id_usuario, created_at, updated_at) FROM stdin;
1	2026-01-16	Desnutrición leve y parasitosis intestinal.	Se administra antiparasitario interno y suplemento vitamínico.	Evaluación Inicial	1	2	2026-10-28 18:24:54	2026-10-28 18:24:54
2	2026-02-11	Infección respiratoria felina (Pérdida de apetito).	Tratamiento con antibiótico por 7 días y nebulización.	Consulta Médica	2	2	2026-10-28 18:24:54	2026-10-28 18:24:54
3	2026-03-02	Paciente clínicamente sano, apto para procedimiento.	Cirugía realizada sin complicaciones. Postoperatorio en observación.	Cirugía de Esterilización	3	4	2026-10-28 18:24:54	2026-10-28 18:24:54
4	2026-03-05	Saludable.	Aplicación de vacuna trivalente felina y desparasitación.	Vacunación	4	2	2026-10-28 18:24:54	2026-10-28 18:24:54
5	2026-03-06	Laceración superficial en pata delantera izquierda.	Limpieza de herida y aplicación de antiséptico en spray.	Curación	5	4	2026-10-28 18:24:54	2026-10-28 18:24:54
\.


--
-- Data for Name: interesado_adopcion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.interesado_adopcion (id_interesado, ci, nombre, telefono, direccion, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at) FROM stdin;
1	4920193	Mariana Paz Soldán	77391029	Av. San Martín #450, Barrio Equipetrol	Casa propia con patio amplio completamente cerrado.	Dra. Claudia Ríos (Veterinaria Particular) - 71000000	95	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	8192039	Jorge Justiniano Rivero	71629384	Calle Arenales #123, Centro	Departamento propio en 3er piso (Permite mascotas pequeñas).	Ing. Roberto Justiniano (Hermano) - 72000000	88	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	3920192	Valeria Aguilera Banegas	69012938	Barrio Sirari, Calle 3 #12	Casa familiar con jardín interno.	Lic. Sofía Aguilera (Madre) - 73000000	90	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	9201938	Fernando Roca Pinto	72819203	Av. Busch y 3er Anillo	Alquiler con autorización firmada por el propietario.	Carlos Roca (Padre) - 74000000	75	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
5	5829103	Andrea Melgar Justiniano	75591823	Urb. Las Palmas, Calle 5	Quinta con muro perimetral alto y áreas verdes.	Dra. María Melgar - 75000000	98	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: interesado_adopcions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.interesado_adopcions (id, ci, nombre, direccion, telefono, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at, estado) FROM stdin;
1	4920193	Mariana Paz Soldán	Av. San Martín #450, Barrio Equipetrol	77391029	Casa propia con patio amplio completamente cerrado.	Dra. Claudia Ríos (Veterinaria Particular) - 71000000	95	2026-10-28 18:24:54	2026-10-28 18:24:54	Pendiente
2	8192039	Jorge Justiniano Rivero	Calle Arenales #123, Centro	71629384	Departamento propio en 3er piso (Permite mascotas pequeñas).	Ing. Roberto Justiniano (Hermano) - 72000000	88	2026-10-28 18:24:54	2026-10-28 18:24:54	Pendiente
3	3920192	Valeria Aguilera Banegas	Barrio Sirari, Calle 3 #12	69012938	Casa familiar con jardín interno.	Lic. Sofía Aguilera (Madre) - 73000000	90	2026-10-28 18:24:54	2026-10-28 18:24:54	Pendiente
4	9201938	Fernando Roca Pinto	Av. Busch y 3er Anillo	72819203	Alquiler con autorización firmada por el propietario.	Carlos Roca (Padre) - 74000000	75	2026-10-28 18:24:54	2026-10-28 18:24:54	Pendiente
5	5829103	Andrea Melgar Justiniano	Urb. Las Palmas, Calle 5	75591823	Quinta con muro perimetral alto y áreas verdes.	Dra. María Melgar - 75000000	98	2026-10-28 18:24:54	2026-10-28 18:24:54	Pendiente
\.


--
-- Data for Name: inventario_lotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventario_lotes (id, id_articulo, id_detalle_compra, id_detalle_donacion, fecha_vencimiento, cantidad_inicial, cantidad_disponible, cantidad_vencida, created_at, updated_at) FROM stdin;
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
1	Firulais	Perro	Mestizo	Macho	2 años	Adoptado	Plan 3000, Av. Paurito	2026-01-15	https://refugio.org/fotos/firulais.jpg	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	Luna	Gato	Siamesa	Hembra	1 año	En Tratamiento	Mercado Abasto Antiguo	2026-02-10	https://refugio.org/fotos/luna.jpg	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	Thor	Perro	Pitbull Mestizo	Macho	3 años	Disponible	Villa 1ro de Mayo, Plaza Principal	2026-03-01	https://refugio.org/fotos/thor.jpg	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	Mimi	Gato	Común Europeo	Hembra	5 meses	Disponible	Av. Banzer Km 8	2026-03-04	https://refugio.org/fotos/mimi.jpg	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
5	Rocky	Perro	Criollo	Macho	4 años	Disponible	Equipetrol, Calle 9	2026-03-06	https://refugio.org/fotos/rocky.jpg	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: mascotas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mascotas (id, nombre, raza, edad, especie, estado_actual, fecha_ingreso, sexo, zona_rescate, foto, created_at, updated_at) FROM stdin;
1	Firulais	Mestizo	2 años	Perro	Adoptado	2026-01-15	Macho	Plan 3000, Av. Paurito	https://refugio.org/fotos/firulais.jpg	2026-10-28 18:24:54	2026-10-28 18:24:54
2	Luna	Siamesa	1 año	Gato	En Tratamiento	2026-02-10	Hembra	Mercado Abasto Antiguo	https://refugio.org/fotos/luna.jpg	2026-10-28 18:24:54	2026-10-28 18:24:54
3	Thor	Pitbull Mestizo	3 años	Perro	Disponible	2026-03-01	Macho	Villa 1ro de Mayo, Plaza Principal	https://refugio.org/fotos/thor.jpg	2026-10-28 18:24:54	2026-10-28 18:24:54
4	Mimi	Común Europeo	5 meses	Gato	Adoptado	2026-03-04	Hembra	Av. Banzer Km 8	https://refugio.org/fotos/mimi.jpg	2026-10-28 18:24:54	2026-10-28 18:24:54
5	Rocky	Criollo	4 años	Perro	Disponible	2026-03-06	Macho	Equipetrol, Calle 9	https://refugio.org/fotos/rocky.jpg	2026-10-28 18:24:54	2026-10-28 18:24:54
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
22	2026_09_29_132600_align_users_for_api_login	2
23	2026_09_29_154542_add_ci_to_users_table	2
24	2026_10_08_214454_add_estado_to_interesado_adopcions_table	2
25	2026_10_09_000001_add_ci_to_users_table	2
26	2026_10_10_020445_add_activo_to_users_table	2
27	2026_10_10_151815_expand_bitacoras_for_audit_retention	2
28	2026_10_14_000001_add_unique_name_to_articulo_inventarios_table	2
29	2026_10_14_195432_add_numero_documento_to_compras_and_donacions_table	2
30	2026_10_14_212114_add_historial_clinico_to_salida_inventarios_table	2
31	2026_10_14_214459_create_inventario_lotes_table	2
32	2026_10_14_220728_create_ajuste_inventarios_table	2
33	2026_10_14_222527_add_management_fields_to_proveedors_table	2
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
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proveedor (id_proveedor, nombre_empresa, contacto_nombre, direccion, telefono, created_at, updated_at) FROM stdin;
1	Veterinaria & Distribuidora El Paisano	Lic. Gonzalo Vargas	Av. Grigotá 4to Anillo	33529102	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	Comercializadora AgroCruceña	Ing. Mario Mercado	Parque Industrial PI-34	33410293	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	Importadora Médica Santa Cruz	Sra. Elena Claros	Calle España #240	33682910	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: proveedors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proveedors (id, nombre_empresa, nombre_contacto, telefono, direccion, created_at, updated_at, identificacion, tipo_insumo_provisto, activo) FROM stdin;
1	Veterinaria & Distribuidora El Paisano	Lic. Gonzalo Vargas	33529102	Av. Grigotá 4to Anillo	2026-10-28 18:24:55	2026-10-28 18:24:55	\N	\N	t
2	Comercializadora AgroCruceña	Ing. Mario Mercado	33410293	Parque Industrial PI-34	2026-10-28 18:24:55	2026-10-28 18:24:55	\N	\N	t
3	Importadora Médica Santa Cruz	Sra. Elena Claros	33682910	Calle España #240	2026-10-28 18:24:55	2026-10-28 18:24:55	\N	\N	t
\.


--
-- Data for Name: salida_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.salida_inventario (id_salida, id_usuario, fecha_salida, motivo, created_at, updated_at) FROM stdin;
1	3	2026-01-25	Alimentación semanal de caniles generales	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	2	2026-02-12	Tratamiento de gatos en área de aislamiento clínico	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	3	2026-03-01	Limpieza y desinfección profunda de caniles	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
4	3	2026-09-12	Alimentación semanal de caniles	2026-09-12 13:31:51.290551	2026-09-12 13:31:51.290551
\.


--
-- Data for Name: salida_inventarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.salida_inventarios (id, motivo, id_usuario, fecha_salida, created_at, updated_at, id_historial_clinico) FROM stdin;
1	Alimentación semanal de caniles generales	3	2026-01-25	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
2	Tratamiento de gatos en área de aislamiento clínico	2	2026-02-12	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
3	Limpieza y desinfección profunda de caniles	3	2026-03-01	2026-10-28 18:24:55	2026-10-28 18:24:55	\N
\.


--
-- Data for Name: seguimiento_adopcion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seguimiento_adopcion (id_seguimiento, id_adopcion, id_usuario, estado_seguimiento, fecha_programada, fecha_realizada, reporte_bienestar, fotografias_evidencia, created_at, updated_at) FROM stdin;
1	1	3	Concluido Satisfactorio	2026-02-15	2026-02-15	La mascota se adaptó perfectamente. Come bien y comparte con la familia.	https://refugio.org/evidencias/seg_firulais_1.jpg	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
2	1	3	Pendiente	2026-03-15	\N	\N	\N	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
3	2	3	Pendiente	2026-03-22	\N	\N	\N	2026-09-10 14:01:57.229297	2026-09-10 14:01:57.229297
\.


--
-- Data for Name: seguimiento_adopcions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seguimiento_adopcions (id, estado_seguimiento, fecha_programada, fecha_realizada, fotografia, reporte_bienestar, id_adopcion, id_usuario, created_at, updated_at) FROM stdin;
1	Concluido Satisfactorio	2026-02-15	2026-02-15	https://refugio.org/evidencias/seg_firulais_1.jpg	La mascota se adaptó perfectamente. Come bien y comparte con la familia.	1	3	2026-10-28 18:24:54	2026-10-28 18:24:54
2	Pendiente	2026-03-15	\N			1	3	2026-10-28 18:24:54	2026-10-28 18:24:54
3	Pendiente	2026-03-22	\N			2	3	2026-10-28 18:24:54	2026-10-28 18:24:54
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
QeAP8zZRGyU0ujrWjz25ZpBVPLyK6XHMD7V24Blm	\N	127.0.0.1	Symfony	eyJfdG9rZW4iOiJ0MmtObjJZQ0ZHZ2F0ZDFDeFJ3Sk5UV2FGMnpwWEF3OElQSUk0YkZxIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL2xvY2FsaG9zdCIsInJvdXRlIjoiaG9tZSJ9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19	1793213963
\.


--
-- Data for Name: tipo_aporte; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipo_aporte (id_tipoaporte, nombre, descripcion) FROM stdin;
1	Efectivo / Transferencia	Aportes monetarios directos a la cuenta bancaria del refugio
2	Alimento Seco	Croquetas para perros y gatos de distintas edades
3	Insumos Médicos	Medicamentos, vacunas, jeringas y gasas
4	Artículos de Limpieza	Detergentes, desinfectantes y escobas
5	Mobiliario / Accesorios	Camas, correas, platos y jaulas de transporte
\.


--
-- Data for Name: tipo_aportes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipo_aportes (id, nombre, descripcion, created_at, updated_at) FROM stdin;
1	Efectivo / Transferencia	Aportes monetarios directos a la cuenta bancaria del refugio	2026-10-28 18:24:55	2026-10-28 18:24:55
2	Alimento Seco	Croquetas para perros y gatos de distintas edades	2026-10-28 18:24:55	2026-10-28 18:24:55
3	Insumos Médicos	Medicamentos, vacunas, jeringas y gasas	2026-10-28 18:24:55	2026-10-28 18:24:55
4	Artículos de Limpieza	Detergentes, desinfectantes y escobas	2026-10-28 18:24:55	2026-10-28 18:24:55
5	Mobiliario / Accesorios	Camas, correas, platos y jaulas de transporte	2026-10-28 18:24:55	2026-10-28 18:24:55
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, nombre, email, rol, telefono, password, remember_token, created_at, updated_at, ci, activo) FROM stdin;
1	Carlos Eduardo Mendoza	carlos.mendoza@patitas.com	Administrador	71029384	$2y$12$7Yz3AWIWw6fNEgmqaYQavO8xzJik4nALCU9F384Ew.GODRMbhWdIC	\N	2026-10-28 18:24:53	2026-10-28 18:24:53	4512345 LP	t
2	Dra. Beatriz Morales Peña	beatriz.morales@patitas.com	Veterinario	75019283	$2y$12$M8lk1/d4JSdIxWvUUzMHs.OnUKEXX2L5bHpV37.sTMYAZQlN65ECK	\N	2026-10-28 18:24:53	2026-10-28 18:24:53	4523456 SC	t
3	Lucía Fernández Claros	lucia.fernandez@patitas.com	Voluntario	68910293	$2y$12$tZQazgis/RRPwsb/kYIqROUx/jo30HUK7Zr8ZjDBLTJXT4ASQDH8m	\N	2026-10-28 18:24:53	2026-10-28 18:24:53	4534567 CB	t
4	Dr. Mateo Vargas Ortiz	mateo.vargas@patitas.com	Veterinario	72109384	$2y$12$zCdcwge5c2BXoiLvciIPtOdM28JATWve1UrL0LyFRhZizgulRGDsq	\N	2026-10-28 18:24:54	2026-10-28 18:24:54	4545678 CH	t
5	Camila Suárez Roca	camila.suarez@patitas.com	Recepcionista	78901234	$2y$12$7SzUtKDGgbeXgXO/HBveCuwL7iAID4tEE6jb/ozXNfAMyxzeMZmpi	\N	2026-10-28 18:24:54	2026-10-28 18:24:54	4556789 OR	t
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuario (id_usuario, ci, nombre_completo, rol, telefono, created_at, updated_at) FROM stdin;
1	8349201	Carlos Eduardo Mendoza	Administrador	71029384	2026-09-10 13:52:08.795568	2026-09-10 13:52:08.795568
2	6291048	Dra. Beatriz Morales Peña	Veterinario	75019283	2026-09-10 13:52:08.795568	2026-09-10 13:52:08.795568
3	9182347	Lucía Fernández Claros	Voluntario	68910293	2026-09-10 13:52:08.795568	2026-09-10 13:52:08.795568
4	7410293	Dr. Mateo Vargas Ortiz	Veterinario	72109384	2026-09-10 13:52:08.795568	2026-09-10 13:52:08.795568
5	5938102	Camila Suárez Roca	Recepcionista	78901234	2026-09-10 13:52:08.795568	2026-09-10 13:52:08.795568
\.


--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.adopcion_id_adopcion_seq', 2, true);


--
-- Name: adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.adopcions_id_seq', 1, false);


--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ajuste_inventario_lotes_id_seq', 1, false);


--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ajuste_inventarios_id_seq', 1, false);


--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.aporte_dinero_id_aporte_seq', 2, true);


--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.aporte_dineros_id_seq', 1, false);


--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.articulo_inventario_id_articulo_seq', 5, true);


--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.articulo_inventarios_id_seq', 1, false);


--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bitacora_id_accion_seq', 5, true);


--
-- Name: bitacoras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bitacoras_id_seq', 5, true);


--
-- Name: compra_id_compra_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compra_id_compra_seq', 2, true);


--
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compras_id_seq', 1, false);


--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_compra_id_detallecompra_seq', 3, true);


--
-- Name: detalle_compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_compras_id_seq', 1, false);


--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_donacion_insumo_id_detalle_seq', 3, true);


--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_donacion_insumos_id_seq', 1, false);


--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_salida_id_detallesalida_seq', 8, true);


--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_salida_lotes_id_seq', 1, false);


--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_salidas_id_seq', 1, false);


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donacion_id_donacion_seq', 5, true);


--
-- Name: donacions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donacions_id_seq', 1, false);


--
-- Name: donante_id_donante_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donante_id_donante_seq', 5, true);


--
-- Name: donantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.donantes_id_seq', 1, false);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.historial_clinico_id_historial_seq', 5, true);


--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.historial_clinicos_id_seq', 1, false);


--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.interesado_adopcion_id_interesado_seq', 5, true);


--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.interesado_adopcions_id_seq', 1, false);


--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventario_lotes_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mascota_id_mascota_seq', 5, true);


--
-- Name: mascotas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mascotas_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 33, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 3, true);


--
-- Name: proveedors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.proveedors_id_seq', 1, false);


--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.salida_inventario_id_salida_seq', 4, true);


--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.salida_inventarios_id_seq', 1, false);


--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seguimiento_adopcion_id_seguimiento_seq', 3, true);


--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seguimiento_adopcions_id_seq', 1, false);


--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_aporte_id_tipoaporte_seq', 5, true);


--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_aportes_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 5, true);


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
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


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
-- Name: bitacoras bitacoras_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacoras
    ADD CONSTRAINT bitacoras_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE SET NULL;


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
-- Name: adopcion fk_adopcion_interesado; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT fk_adopcion_interesado FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcion(id_interesado);


--
-- Name: adopcion fk_adopcion_mascota; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT fk_adopcion_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota);


--
-- Name: aporte_dinero fk_aporte_donacion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT fk_aporte_donacion FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON DELETE CASCADE;


--
-- Name: bitacora fk_bitacora_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT fk_bitacora_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: compra fk_compra_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: compra fk_compra_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: detalle_compra fk_detalle_compra_articulo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detalle_compra_articulo FOREIGN KEY (id_insumo) REFERENCES public.articulo_inventario(id_articulo);


--
-- Name: detalle_compra fk_detalle_compra_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detalle_compra_cabecera FOREIGN KEY (id_compra) REFERENCES public.compra(id_compra) ON DELETE CASCADE;


--
-- Name: detalle_donacion_insumo fk_detalle_donacion_articulo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT fk_detalle_donacion_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo);


--
-- Name: detalle_donacion_insumo fk_detalle_donacion_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT fk_detalle_donacion_cabecera FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON DELETE CASCADE;


--
-- Name: detalle_salida fk_detalle_salida_articulo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT fk_detalle_salida_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo);


--
-- Name: detalle_salida fk_detalle_salida_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT fk_detalle_salida_cabecera FOREIGN KEY (id_salida) REFERENCES public.salida_inventario(id_salida) ON DELETE CASCADE;


--
-- Name: donacion fk_donacion_donante; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_donante FOREIGN KEY (id_donante) REFERENCES public.donante(id_donante);


--
-- Name: donacion fk_donacion_tipo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_tipo FOREIGN KEY (tipo_aporte) REFERENCES public.tipo_aporte(id_tipoaporte);


--
-- Name: donacion fk_donacion_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: historial_clinico fk_historial_mascota; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT fk_historial_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON DELETE CASCADE;


--
-- Name: historial_clinico fk_historial_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: salida_inventario fk_salida_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salida_inventario
    ADD CONSTRAINT fk_salida_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: seguimiento_adopcion fk_seguimiento_adopcion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT fk_seguimiento_adopcion FOREIGN KEY (id_adopcion) REFERENCES public.adopcion(id_adopcion) ON DELETE CASCADE;


--
-- Name: seguimiento_adopcion fk_seguimiento_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT fk_seguimiento_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


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

\unrestrict nFSepjz2fwUeLI23IVGwYY1q3w42heKdQETZBvLWlMUafEePgABGzyphShwTwqv

