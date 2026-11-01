--
-- PostgreSQL database dump
--

-- \restrict rTewcgaZdRcENWhPF4ucwSS2jid4qJ8O2dKaK5VPhZjbWaSLKYPRfIz9gDj1NGt

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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: fn_actualizar_estado_mascota_adopcion(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.fn_actualizar_estado_mascota_adopcion() OWNER TO postgres;

--
-- Name: fn_actualizar_estado_por_historial(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.fn_actualizar_estado_por_historial() OWNER TO postgres;

--
-- Name: fn_actualizar_stock_por_compra(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.fn_actualizar_stock_por_compra() OWNER TO postgres;

--
-- Name: fn_descontar_stock_por_salida(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.fn_descontar_stock_por_salida() OWNER TO postgres;

--
-- Name: fn_registrar_bitacora_adopcion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_registrar_bitacora_adopcion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO bitacora (
        id_usuario,
        fecha,
        hora,
        tipo_accion,
        tabla_afectada,
        id_registro_afectado
    )
    VALUES (
        1, -- Usuario administrador por defecto en trigger desatendido
        CURRENT_DATE,
        CURRENT_TIME,
        'Registro formal de adopción de mascota',
        'adopcion',
        NEW.id_adopcion
    );

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_registrar_bitacora_adopcion() OWNER TO postgres;

--
-- Name: fn_verificar_stock_minimo_alerta(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.fn_verificar_stock_minimo_alerta() OWNER TO postgres;

--
-- Name: sp_formalizar_adopcion(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
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


ALTER PROCEDURE public.sp_formalizar_adopcion(IN p_mascota_id integer, IN p_interesado_id integer, IN p_usuario_id integer) OWNER TO postgres;

--
-- Name: sp_registrar_atencion_medica(integer, integer, character varying, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
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


ALTER PROCEDURE public.sp_registrar_atencion_medica(IN p_mascota_id integer, IN p_usuario_id integer, IN p_tipo_procedimiento character varying, IN p_diagnostico text, IN p_observaciones text) OWNER TO postgres;

--
-- Name: sp_registrar_donacion_dinero(integer, integer, numeric, character varying, text); Type: PROCEDURE; Schema: public; Owner: postgres
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


ALTER PROCEDURE public.sp_registrar_donacion_dinero(IN p_donante_id integer, IN p_usuario_id integer, IN p_monto numeric, IN p_comprobante character varying, IN p_observaciones text) OWNER TO postgres;

--
-- Name: sp_registrar_salida(integer, integer, numeric, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
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


ALTER PROCEDURE public.sp_registrar_salida(IN p_usuario_id integer, IN p_articulo_id integer, IN p_cantidad numeric, IN p_motivo character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adopcion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adopcion (
    id_adopcion integer NOT NULL,
    id_mascota integer NOT NULL,
    id_interesado integer NOT NULL,
    fecha_adopcion date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.adopcion OWNER TO postgres;

--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adopcion_id_adopcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.adopcion_id_adopcion_seq OWNER TO postgres;

--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adopcion_id_adopcion_seq OWNED BY public.adopcion.id_adopcion;


--
-- Name: adopcions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adopcions (
    id bigint NOT NULL,
    fecha_adopcion character varying(255) NOT NULL,
    id_interesado bigint NOT NULL,
    id_mascota bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.adopcions OWNER TO postgres;

--
-- Name: adopcions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adopcions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.adopcions_id_seq OWNER TO postgres;

--
-- Name: adopcions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adopcions_id_seq OWNED BY public.adopcions.id;


--
-- Name: ajuste_inventario_lotes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ajuste_inventario_lotes (
    id bigint NOT NULL,
    id_ajuste_inventario bigint NOT NULL,
    id_inventario_lote bigint NOT NULL,
    cantidad numeric(12,2) NOT NULL
);


ALTER TABLE public.ajuste_inventario_lotes OWNER TO postgres;

--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ajuste_inventario_lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ajuste_inventario_lotes_id_seq OWNER TO postgres;

--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ajuste_inventario_lotes_id_seq OWNED BY public.ajuste_inventario_lotes.id;


--
-- Name: ajuste_inventarios; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.ajuste_inventarios OWNER TO postgres;

--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ajuste_inventarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ajuste_inventarios_id_seq OWNER TO postgres;

--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ajuste_inventarios_id_seq OWNED BY public.ajuste_inventarios.id;


--
-- Name: alerta_inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerta_inventario (
    id_alerta integer NOT NULL,
    id_articulo integer NOT NULL,
    nivel_criticidad character varying(20) DEFAULT 'Critico'::character varying NOT NULL,
    fecha_generada timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(20) DEFAULT 'Pendiente'::character varying NOT NULL,
    CONSTRAINT alerta_inventario_estado_check CHECK (((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'Atendida'::character varying, 'Descartada'::character varying])::text[]))),
    CONSTRAINT alerta_inventario_nivel_criticidad_check CHECK (((nivel_criticidad)::text = ANY ((ARRAY['Advertencia'::character varying, 'Critico'::character varying, 'Agotado'::character varying])::text[])))
);


ALTER TABLE public.alerta_inventario OWNER TO postgres;

--
-- Name: alerta_inventario_id_alerta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerta_inventario_id_alerta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerta_inventario_id_alerta_seq OWNER TO postgres;

--
-- Name: alerta_inventario_id_alerta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerta_inventario_id_alerta_seq OWNED BY public.alerta_inventario.id_alerta;


--
-- Name: aporte_dinero; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.aporte_dinero OWNER TO postgres;

--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aporte_dinero_id_aporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aporte_dinero_id_aporte_seq OWNER TO postgres;

--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aporte_dinero_id_aporte_seq OWNED BY public.aporte_dinero.id_aporte;


--
-- Name: aporte_dineros; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.aporte_dineros OWNER TO postgres;

--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aporte_dineros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aporte_dineros_id_seq OWNER TO postgres;

--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aporte_dineros_id_seq OWNED BY public.aporte_dineros.id;


--
-- Name: articulo_inventario; Type: TABLE; Schema: public; Owner: postgres
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
    CONSTRAINT articulo_inventario_categoria_check CHECK (((categoria)::text = ANY ((ARRAY['Alimento'::character varying, 'Medicamento'::character varying, 'Vacuna'::character varying, 'Limpieza'::character varying, 'Accesorio'::character varying])::text[]))),
    CONSTRAINT articulo_inventario_stock_actual_check CHECK ((stock_actual >= (0)::numeric)),
    CONSTRAINT articulo_inventario_stock_minimo_alerta_check CHECK ((stock_minimo_alerta >= (0)::numeric))
);


ALTER TABLE public.articulo_inventario OWNER TO postgres;

--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articulo_inventario_id_articulo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.articulo_inventario_id_articulo_seq OWNER TO postgres;

--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articulo_inventario_id_articulo_seq OWNED BY public.articulo_inventario.id_articulo;


--
-- Name: articulo_inventarios; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.articulo_inventarios OWNER TO postgres;

--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articulo_inventarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.articulo_inventarios_id_seq OWNER TO postgres;

--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articulo_inventarios_id_seq OWNED BY public.articulo_inventarios.id;


--
-- Name: bitacora; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.bitacora OWNER TO postgres;

--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bitacora_id_accion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bitacora_id_accion_seq OWNER TO postgres;

--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bitacora_id_accion_seq OWNED BY public.bitacora.id_accion;


--
-- Name: bitacoras; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.bitacoras OWNER TO postgres;

--
-- Name: bitacoras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bitacoras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bitacoras_id_seq OWNER TO postgres;

--
-- Name: bitacoras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bitacoras_id_seq OWNED BY public.bitacoras.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.compra OWNER TO postgres;

--
-- Name: compra_id_compra_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compra_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compra_id_compra_seq OWNER TO postgres;

--
-- Name: compra_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compra_id_compra_seq OWNED BY public.compra.id_compra;


--
-- Name: compras; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.compras OWNER TO postgres;

--
-- Name: compras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compras_id_seq OWNER TO postgres;

--
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;


--
-- Name: detalle_compra; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.detalle_compra OWNER TO postgres;

--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_compra_id_detallecompra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_compra_id_detallecompra_seq OWNER TO postgres;

--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_compra_id_detallecompra_seq OWNED BY public.detalle_compra.id_detallecompra;


--
-- Name: detalle_compras; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.detalle_compras OWNER TO postgres;

--
-- Name: detalle_compras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_compras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_compras_id_seq OWNER TO postgres;

--
-- Name: detalle_compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_compras_id_seq OWNED BY public.detalle_compras.id;


--
-- Name: detalle_donacion_insumo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_donacion_insumo (
    id_detalle integer NOT NULL,
    id_donacion integer NOT NULL,
    id_articulo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    fecha_vencimiento date,
    CONSTRAINT detalle_donacion_insumo_cantidad_check CHECK ((cantidad > (0)::numeric))
);


ALTER TABLE public.detalle_donacion_insumo OWNER TO postgres;

--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_donacion_insumo_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_donacion_insumo_id_detalle_seq OWNER TO postgres;

--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_donacion_insumo_id_detalle_seq OWNED BY public.detalle_donacion_insumo.id_detalle;


--
-- Name: detalle_donacion_insumos; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.detalle_donacion_insumos OWNER TO postgres;

--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_donacion_insumos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_donacion_insumos_id_seq OWNER TO postgres;

--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_donacion_insumos_id_seq OWNED BY public.detalle_donacion_insumos.id;


--
-- Name: detalle_salida; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_salida (
    id_detallesalida integer NOT NULL,
    id_salida integer NOT NULL,
    id_articulo integer NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    CONSTRAINT detalle_salida_cantidad_check CHECK ((cantidad > (0)::numeric))
);


ALTER TABLE public.detalle_salida OWNER TO postgres;

--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_salida_id_detallesalida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_salida_id_detallesalida_seq OWNER TO postgres;

--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_salida_id_detallesalida_seq OWNED BY public.detalle_salida.id_detallesalida;


--
-- Name: detalle_salida_lotes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_salida_lotes (
    id bigint NOT NULL,
    id_detalle_salida bigint NOT NULL,
    id_inventario_lote bigint NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.detalle_salida_lotes OWNER TO postgres;

--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_salida_lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_salida_lotes_id_seq OWNER TO postgres;

--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_salida_lotes_id_seq OWNED BY public.detalle_salida_lotes.id;


--
-- Name: detalle_salidas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_salidas (
    id bigint NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    id_salida bigint NOT NULL,
    id_articulo bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.detalle_salidas OWNER TO postgres;

--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_salidas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_salidas_id_seq OWNER TO postgres;

--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_salidas_id_seq OWNED BY public.detalle_salidas.id;


--
-- Name: donacion; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.donacion OWNER TO postgres;

--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donacion_id_donacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donacion_id_donacion_seq OWNER TO postgres;

--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donacion_id_donacion_seq OWNED BY public.donacion.id_donacion;


--
-- Name: donacions; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.donacions OWNER TO postgres;

--
-- Name: donacions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donacions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donacions_id_seq OWNER TO postgres;

--
-- Name: donacions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donacions_id_seq OWNED BY public.donacions.id;


--
-- Name: donante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donante (
    id_donante integer NOT NULL,
    nombre character varying(150) NOT NULL,
    tipo_persona character varying(50) DEFAULT 'Natural'::character varying,
    telefono character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT donante_tipo_persona_check CHECK (((tipo_persona)::text = ANY ((ARRAY['Natural'::character varying, 'Jurídica'::character varying])::text[])))
);


ALTER TABLE public.donante OWNER TO postgres;

--
-- Name: donante_id_donante_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donante_id_donante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donante_id_donante_seq OWNER TO postgres;

--
-- Name: donante_id_donante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donante_id_donante_seq OWNED BY public.donante.id_donante;


--
-- Name: donantes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donantes (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    telefono character varying(255) NOT NULL,
    tipo_persona character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.donantes OWNER TO postgres;

--
-- Name: donantes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donantes_id_seq OWNER TO postgres;

--
-- Name: donantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donantes_id_seq OWNED BY public.donantes.id;


--
-- Name: evaluacion_idoneidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluacion_idoneidad (
    id_evaluacion integer NOT NULL,
    id_interesado integer NOT NULL,
    puntaje_vivienda integer DEFAULT 0,
    puntaje_compromiso integer DEFAULT 0,
    puntaje_total integer DEFAULT 0,
    resultado character varying(30) DEFAULT 'Pendiente'::character varying,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT evaluacion_idoneidad_resultado_check CHECK (((resultado)::text = ANY ((ARRAY['Aprobado'::character varying, 'Rechazado'::character varying, 'Pendiente'::character varying])::text[])))
);


ALTER TABLE public.evaluacion_idoneidad OWNER TO postgres;

--
-- Name: evaluacion_idoneidad_id_evaluacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluacion_idoneidad_id_evaluacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.evaluacion_idoneidad_id_evaluacion_seq OWNER TO postgres;

--
-- Name: evaluacion_idoneidad_id_evaluacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluacion_idoneidad_id_evaluacion_seq OWNED BY public.evaluacion_idoneidad.id_evaluacion;


--
-- Name: expediente_digital; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.expediente_digital (
    nro_expediente character varying(50) NOT NULL,
    id_mascota integer NOT NULL,
    estado_clinico character varying(50) DEFAULT 'Inicial'::character varying,
    fecha_apertura date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.expediente_digital OWNER TO postgres;

--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: historial_clinico; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.historial_clinico OWNER TO postgres;

--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_clinico_id_historial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historial_clinico_id_historial_seq OWNER TO postgres;

--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_clinico_id_historial_seq OWNED BY public.historial_clinico.id_historial;


--
-- Name: historial_clinicos; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.historial_clinicos OWNER TO postgres;

--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_clinicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historial_clinicos_id_seq OWNER TO postgres;

--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_clinicos_id_seq OWNED BY public.historial_clinicos.id;


--
-- Name: interesado_adopcion; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.interesado_adopcion OWNER TO postgres;

--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interesado_adopcion_id_interesado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.interesado_adopcion_id_interesado_seq OWNER TO postgres;

--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interesado_adopcion_id_interesado_seq OWNED BY public.interesado_adopcion.id_interesado;


--
-- Name: interesado_adopcions; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.interesado_adopcions OWNER TO postgres;

--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interesado_adopcions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.interesado_adopcions_id_seq OWNER TO postgres;

--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interesado_adopcions_id_seq OWNED BY public.interesado_adopcions.id;


--
-- Name: inventario_lotes; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.inventario_lotes OWNER TO postgres;

--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_lotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_lotes_id_seq OWNER TO postgres;

--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_lotes_id_seq OWNED BY public.inventario_lotes.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: mascota; Type: TABLE; Schema: public; Owner: postgres
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
    foto character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT mascota_especie_check CHECK (((especie)::text = ANY ((ARRAY['Canino'::character varying, 'Felino'::character varying, 'Otro'::character varying])::text[]))),
    CONSTRAINT mascota_estado_actual_check CHECK (((estado_actual)::text = ANY ((ARRAY['En Recuperación'::character varying, 'En Tratamiento'::character varying, 'Disponible para Adopción'::character varying, 'Adoptado'::character varying, 'Fallecido'::character varying])::text[]))),
    CONSTRAINT mascota_sexo_check CHECK (((sexo)::text = ANY ((ARRAY['Macho'::character varying, 'Hembra'::character varying])::text[])))
);


ALTER TABLE public.mascota OWNER TO postgres;

--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mascota_id_mascota_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mascota_id_mascota_seq OWNER TO postgres;

--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mascota_id_mascota_seq OWNED BY public.mascota.id_mascota;


--
-- Name: mascotas; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.mascotas OWNER TO postgres;

--
-- Name: mascotas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mascotas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mascotas_id_seq OWNER TO postgres;

--
-- Name: mascotas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mascotas_id_seq OWNED BY public.mascotas.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNER TO postgres;

--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNED BY public.proveedor.id_proveedor;


--
-- Name: proveedors; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.proveedors OWNER TO postgres;

--
-- Name: proveedors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedors_id_seq OWNER TO postgres;

--
-- Name: proveedors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedors_id_seq OWNED BY public.proveedors.id;


--
-- Name: rol_permiso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol_permiso (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(255),
    permisos_modulos text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.rol_permiso OWNER TO postgres;

--
-- Name: rol_permiso_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rol_permiso_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_permiso_id_rol_seq OWNER TO postgres;

--
-- Name: rol_permiso_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rol_permiso_id_rol_seq OWNED BY public.rol_permiso.id_rol;


--
-- Name: salida_inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salida_inventario (
    id_salida integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_salida date DEFAULT CURRENT_DATE NOT NULL,
    motivo character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.salida_inventario OWNER TO postgres;

--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salida_inventario_id_salida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salida_inventario_id_salida_seq OWNER TO postgres;

--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salida_inventario_id_salida_seq OWNED BY public.salida_inventario.id_salida;


--
-- Name: salida_inventarios; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.salida_inventarios OWNER TO postgres;

--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salida_inventarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salida_inventarios_id_seq OWNER TO postgres;

--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salida_inventarios_id_seq OWNED BY public.salida_inventarios.id;


--
-- Name: seguimiento_adopcion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seguimiento_adopcion (
    id_seguimiento integer NOT NULL,
    id_adopcion integer NOT NULL,
    id_usuario integer NOT NULL,
    estado_seguimiento character varying(50) DEFAULT 'Programado'::character varying NOT NULL,
    fecha_programada date NOT NULL,
    fecha_realizada date,
    reporte_bienestar text,
    fotografias_evidencia character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT seguimiento_adopcion_estado_seguimiento_check CHECK (((estado_seguimiento)::text = ANY ((ARRAY['Programado'::character varying, 'Completado'::character varying, 'Alerta'::character varying, 'Incumplido'::character varying])::text[])))
);


ALTER TABLE public.seguimiento_adopcion OWNER TO postgres;

--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seguimiento_adopcion_id_seguimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seguimiento_adopcion_id_seguimiento_seq OWNER TO postgres;

--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seguimiento_adopcion_id_seguimiento_seq OWNED BY public.seguimiento_adopcion.id_seguimiento;


--
-- Name: seguimiento_adopcions; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.seguimiento_adopcions OWNER TO postgres;

--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seguimiento_adopcions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seguimiento_adopcions_id_seq OWNER TO postgres;

--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seguimiento_adopcions_id_seq OWNED BY public.seguimiento_adopcions.id;


--
-- Name: sesion_jwt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sesion_jwt (
    token_hash character varying(255) NOT NULL,
    id_usuario integer NOT NULL,
    ip_cliente character varying(45),
    user_agent character varying(255),
    fecha_emision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion timestamp without time zone NOT NULL,
    estado character varying(20) DEFAULT 'Activo'::character varying NOT NULL,
    CONSTRAINT sesion_jwt_estado_check CHECK (((estado)::text = ANY ((ARRAY['Activo'::character varying, 'Revocado'::character varying, 'Expirado'::character varying])::text[])))
);


ALTER TABLE public.sesion_jwt OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: tipo_aporte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_aporte (
    id_tipoaporte integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text
);


ALTER TABLE public.tipo_aporte OWNER TO postgres;

--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_aporte_id_tipoaporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_aporte_id_tipoaporte_seq OWNER TO postgres;

--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_aporte_id_tipoaporte_seq OWNED BY public.tipo_aporte.id_tipoaporte;


--
-- Name: tipo_aportes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_aportes (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.tipo_aportes OWNER TO postgres;

--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_aportes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_aportes_id_seq OWNER TO postgres;

--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_aportes_id_seq OWNED BY public.tipo_aportes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT usuario_estado_check CHECK (((estado)::text = ANY ((ARRAY['Activo'::character varying, 'Inactivo'::character varying, 'Suspendido'::character varying])::text[])))
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- Name: adopcion id_adopcion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcion ALTER COLUMN id_adopcion SET DEFAULT nextval('public.adopcion_id_adopcion_seq'::regclass);


--
-- Name: adopcions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcions ALTER COLUMN id SET DEFAULT nextval('public.adopcions_id_seq'::regclass);


--
-- Name: ajuste_inventario_lotes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventario_lotes ALTER COLUMN id SET DEFAULT nextval('public.ajuste_inventario_lotes_id_seq'::regclass);


--
-- Name: ajuste_inventarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventarios ALTER COLUMN id SET DEFAULT nextval('public.ajuste_inventarios_id_seq'::regclass);


--
-- Name: alerta_inventario id_alerta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_inventario ALTER COLUMN id_alerta SET DEFAULT nextval('public.alerta_inventario_id_alerta_seq'::regclass);


--
-- Name: aporte_dinero id_aporte; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dinero ALTER COLUMN id_aporte SET DEFAULT nextval('public.aporte_dinero_id_aporte_seq'::regclass);


--
-- Name: aporte_dineros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dineros ALTER COLUMN id SET DEFAULT nextval('public.aporte_dineros_id_seq'::regclass);


--
-- Name: articulo_inventario id_articulo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulo_inventario ALTER COLUMN id_articulo SET DEFAULT nextval('public.articulo_inventario_id_articulo_seq'::regclass);


--
-- Name: articulo_inventarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulo_inventarios ALTER COLUMN id SET DEFAULT nextval('public.articulo_inventarios_id_seq'::regclass);


--
-- Name: bitacora id_accion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacora ALTER COLUMN id_accion SET DEFAULT nextval('public.bitacora_id_accion_seq'::regclass);


--
-- Name: bitacoras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacoras ALTER COLUMN id SET DEFAULT nextval('public.bitacoras_id_seq'::regclass);


--
-- Name: compra id_compra; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_id_compra_seq'::regclass);


--
-- Name: compras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);


--
-- Name: detalle_compra id_detallecompra; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra ALTER COLUMN id_detallecompra SET DEFAULT nextval('public.detalle_compra_id_detallecompra_seq'::regclass);


--
-- Name: detalle_compras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compras ALTER COLUMN id SET DEFAULT nextval('public.detalle_compras_id_seq'::regclass);


--
-- Name: detalle_donacion_insumo id_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumo ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_donacion_insumo_id_detalle_seq'::regclass);


--
-- Name: detalle_donacion_insumos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumos ALTER COLUMN id SET DEFAULT nextval('public.detalle_donacion_insumos_id_seq'::regclass);


--
-- Name: detalle_salida id_detallesalida; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida ALTER COLUMN id_detallesalida SET DEFAULT nextval('public.detalle_salida_id_detallesalida_seq'::regclass);


--
-- Name: detalle_salida_lotes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida_lotes ALTER COLUMN id SET DEFAULT nextval('public.detalle_salida_lotes_id_seq'::regclass);


--
-- Name: detalle_salidas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salidas ALTER COLUMN id SET DEFAULT nextval('public.detalle_salidas_id_seq'::regclass);


--
-- Name: donacion id_donacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion ALTER COLUMN id_donacion SET DEFAULT nextval('public.donacion_id_donacion_seq'::regclass);


--
-- Name: donacions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacions ALTER COLUMN id SET DEFAULT nextval('public.donacions_id_seq'::regclass);


--
-- Name: donante id_donante; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donante ALTER COLUMN id_donante SET DEFAULT nextval('public.donante_id_donante_seq'::regclass);


--
-- Name: donantes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donantes ALTER COLUMN id SET DEFAULT nextval('public.donantes_id_seq'::regclass);


--
-- Name: evaluacion_idoneidad id_evaluacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluacion_idoneidad ALTER COLUMN id_evaluacion SET DEFAULT nextval('public.evaluacion_idoneidad_id_evaluacion_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: historial_clinico id_historial; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinico ALTER COLUMN id_historial SET DEFAULT nextval('public.historial_clinico_id_historial_seq'::regclass);


--
-- Name: historial_clinicos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinicos ALTER COLUMN id SET DEFAULT nextval('public.historial_clinicos_id_seq'::regclass);


--
-- Name: interesado_adopcion id_interesado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesado_adopcion ALTER COLUMN id_interesado SET DEFAULT nextval('public.interesado_adopcion_id_interesado_seq'::regclass);


--
-- Name: interesado_adopcions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesado_adopcions ALTER COLUMN id SET DEFAULT nextval('public.interesado_adopcions_id_seq'::regclass);


--
-- Name: inventario_lotes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes ALTER COLUMN id SET DEFAULT nextval('public.inventario_lotes_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: mascota id_mascota; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascota ALTER COLUMN id_mascota SET DEFAULT nextval('public.mascota_id_mascota_seq'::regclass);


--
-- Name: mascotas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascotas ALTER COLUMN id SET DEFAULT nextval('public.mascotas_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: proveedor id_proveedor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);


--
-- Name: proveedors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedors ALTER COLUMN id SET DEFAULT nextval('public.proveedors_id_seq'::regclass);


--
-- Name: rol_permiso id_rol; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso ALTER COLUMN id_rol SET DEFAULT nextval('public.rol_permiso_id_rol_seq'::regclass);


--
-- Name: salida_inventario id_salida; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventario ALTER COLUMN id_salida SET DEFAULT nextval('public.salida_inventario_id_salida_seq'::regclass);


--
-- Name: salida_inventarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventarios ALTER COLUMN id SET DEFAULT nextval('public.salida_inventarios_id_seq'::regclass);


--
-- Name: seguimiento_adopcion id_seguimiento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcion ALTER COLUMN id_seguimiento SET DEFAULT nextval('public.seguimiento_adopcion_id_seguimiento_seq'::regclass);


--
-- Name: seguimiento_adopcions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcions ALTER COLUMN id SET DEFAULT nextval('public.seguimiento_adopcions_id_seq'::regclass);


--
-- Name: tipo_aporte id_tipoaporte; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_aporte ALTER COLUMN id_tipoaporte SET DEFAULT nextval('public.tipo_aporte_id_tipoaporte_seq'::regclass);


--
-- Name: tipo_aportes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_aportes ALTER COLUMN id SET DEFAULT nextval('public.tipo_aportes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- Data for Name: adopcion; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: adopcions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adopcions (id, fecha_adopcion, id_interesado, id_mascota, created_at, updated_at) FROM stdin;
1	2026-02-01	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	2026-03-07	3	4	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: ajuste_inventario_lotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ajuste_inventario_lotes (id, id_ajuste_inventario, id_inventario_lote, cantidad) FROM stdin;
\.


--
-- Data for Name: ajuste_inventarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ajuste_inventarios (id, id_articulo, id_usuario, usuario_nombre, cantidad, stock_anterior, stock_nuevo, saldo_disponible_anterior, saldo_disponible_nuevo, motivo, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: alerta_inventario; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: aporte_dinero; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: aporte_dineros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aporte_dineros (id, monto, fecha_recepcion, comprobante, observaciones, id_donacion, created_at, updated_at) FROM stdin;
1	500.00	2026-01-20	TRF-BNB-9281039	Donación para fondo de alimento de emergencia	2	2026-11-01 18:17:19	2026-11-01 18:17:19
2	1500.00	2026-02-18	TRF-BISA-819203	Aporte destinado exclusivamente a esterilizaciones masivas	4	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: articulo_inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articulo_inventario (id_articulo, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at) FROM stdin;
1	Alimento Dog Chow Adulto 20kg	Alimento	Bolsa	150.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	Alimento Dog Chow Cachorro 15kg	Alimento	Bolsa	120.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	Alimento Pro Plan Adulto Raza Mediana 18kg	Alimento	Bolsa	80.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	Alimento Cat Chow Gatitos 8kg	Alimento	Bolsa	90.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	Alimento Whiskas Carne Adulto 10kg	Alimento	Bolsa	110.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	Alimento Medicado Renal Royal Canin 7.5kg	Alimento	Bolsa	35.00	5.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	Alimento Medicado Gastrointestinal Canino 10kg	Alimento	Bolsa	40.00	8.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	Latas Paté Pollo para Perro Convaleciente 400g	Alimento	Lata	250.00	30.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	Sobres Alimento Húmedo Whiskas Salmón 85g	Alimento	Sobre	400.00	50.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	Leche Maternizada Canina KMR en Polvo 500g	Alimento	Pote	60.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	Leche Maternizada Felina PetLac 400g	Alimento	Pote	55.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	Vacuna Óctuple Vanguard Plus 5/L	Vacuna	Dosis	180.00	25.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
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
24	Amoxicilina + Ácido Clavulánico 500mg Comp.	Medicamento	Caja	110.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	Antiinflamatorio Meloxicam 0.5% Inyectable 50ml	Medicamento	Frasco	70.00	12.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	Dexametasona 2mg/ml Inyectable 50ml	Medicamento	Frasco	80.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	Suero Fisiológico al 0.9% 500ml	Medicamento	Bolsa	320.00	40.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	Suero Ringer Lactato 500ml	Medicamento	Bolsa	280.00	35.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	Complejo B Inyectable Hematopoyético 100ml	Medicamento	Frasco	95.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	Tramadol Gotas Analgésico 20ml	Medicamento	Frasco	60.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	Curabichera Plata Aerosol Cicatrizante 400ml	Medicamento	Frasco	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	Solución Clorhexidina al 2% para Heridas 1 Litro	Medicamento	Frasco	75.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	Yodopovidona Solución Tópica al 10% 1 Litro	Medicamento	Frasco	80.00	12.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	Alcohol Medicinal al 70% 1 Litro	Limpieza	Botella	150.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
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
46	Guantes Quirúrgicos de Látex Talle M (Caja 100)	Limpieza	Caja	100.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	Collares Isabelinos de Protección Talle 3-5	Accesorio	Unidad	75.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	Platos Dobles de Acero Inoxidable para Perro	Accesorio	Unidad	120.00	15.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	Correas Resistentes de Paseo Nylon 2m	Accesorio	Unidad	85.00	10.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	Mantas Térmicas Acolchadas Lavables	Accesorio	Unidad	140.00	20.00	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: articulo_inventarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articulo_inventarios (id, nombre, categoria, unidad_medida, stock_actual, stock_minimo_alerta, created_at, updated_at) FROM stdin;
1	Croquetas Adulto Dog Chow 15kg	Alimento	Bolsa	25.00	5.00	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Cat Chow Gatitos 8kg	Alimento	Bolsa	12.00	3.00	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Ivermectina 1% Inyectable 50ml	Medicamento	Frasco	8.00	2.00	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Lavandina Concentrada 5L	Limpieza	Bidón	15.00	4.00	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Jeringas Descartables 3ml	Insumo Médico	Unidad	150.00	30.00	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: bitacora; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: bitacoras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bitacoras (id, tipo_accion, id_usuario, created_at, updated_at, usuario_nombre, modulo, descripcion, entidad_tipo, entidad_id, ip, http_method, ruta, resultado, contexto) FROM stdin;
1	Inicio de sesión en el sistema	1	2026-03-01 08:30:00	2026-03-01 08:30:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
2	Registro de consulta clínica - Mascota ID 1	2	2026-03-01 09:15:00	2026-03-01 09:15:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
3	Registro de nuevo interesado en adopción	5	2026-03-02 10:00:00	2026-03-02 10:00:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
4	Aprobación de solicitud de adopción ID 1	1	2026-03-02 11:30:00	2026-03-02 11:30:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
5	Registro de salida de alimentos de inventario	3	2026-03-03 14:20:00	2026-03-03 14:20:00	\N	sistema	\N	\N	\N	\N	\N	\N	exitosa	\N
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compras (id, monto_total, fecha_compra, id_proveedor, id_usuario, created_at, updated_at, numero_documento) FROM stdin;
1	1250.00	2026-01-05	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
2	840.00	2026-02-02	3	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
\.


--
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: detalle_compras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_compras (id, costo_unitario, fecha_vencimiento, cantidad, id_compra, id_articulo, created_at, updated_at) FROM stdin;
1	125.00	2027-05-20	10.00	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	85.00	2028-01-15	4.00	2	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	5.00	2028-10-10	100.00	2	5	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: detalle_donacion_insumo; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: detalle_donacion_insumos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_donacion_insumos (id, fecha_vencimiento, cantidad, id_donacion, id_articulo, created_at, updated_at) FROM stdin;
1	2027-06-30	20.00	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	2027-12-31	5.00	3	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	2028-05-15	100.00	3	5	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: detalle_salida; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: detalle_salida_lotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_salida_lotes (id, id_detalle_salida, id_inventario_lote, cantidad, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: detalle_salidas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_salidas (id, cantidad, id_salida, id_articulo, created_at, updated_at) FROM stdin;
1	3.00	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19
2	1.00	2	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	10.00	2	5	2026-11-01 18:17:19	2026-11-01 18:17:19
4	2.00	3	4	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: donacion; Type: TABLE DATA; Schema: public; Owner: postgres
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
\.


--
-- Data for Name: donacions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donacions (id, tipo_aporte, fecha, id_donante, id_usuario, created_at, updated_at, numero_documento) FROM stdin;
1	Alimento Seco	2026-01-10	1	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
2	Efectivo / Transferencia	2026-01-20	3	5	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
3	Insumos Médicos	2026-02-05	4	2	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
4	Efectivo / Transferencia	2026-02-18	2	1	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
5	Mobiliario / Accesorios	2026-03-05	5	5	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
\.


--
-- Data for Name: donante; Type: TABLE DATA; Schema: public; Owner: postgres
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
\.


--
-- Data for Name: donantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donantes (id, nombre, telefono, tipo_persona, created_at, updated_at) FROM stdin;
1	Empresa Avícola Sofía	70019283	Jurídica	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Fundación Bienestar Animal	33492019	Jurídica	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Roberto Pinto Saucedo	71390219	Natural	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Farmacia Chávez S.A.	800102030	Jurídica	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Gabriela Arteaga	76019283	Natural	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: evaluacion_idoneidad; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: expediente_digital; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: historial_clinico; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: historial_clinicos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historial_clinicos (id, fecha_atencion, diagnostico, observacion, tipo_procedimiento, id_mascota, id_usuario, created_at, updated_at) FROM stdin;
1	2026-01-16	Desnutrición leve y parasitosis intestinal.	Se administra antiparasitario interno y suplemento vitamínico.	Evaluación Inicial	1	2	2026-11-01 18:17:19	2026-11-01 18:17:19
2	2026-02-11	Infección respiratoria felina (Pérdida de apetito).	Tratamiento con antibiótico por 7 días y nebulización.	Consulta Médica	2	2	2026-11-01 18:17:19	2026-11-01 18:17:19
3	2026-03-02	Paciente clínicamente sano, apto para procedimiento.	Cirugía realizada sin complicaciones. Postoperatorio en observación.	Cirugía de Esterilización	3	4	2026-11-01 18:17:19	2026-11-01 18:17:19
4	2026-03-05	Saludable.	Aplicación de vacuna trivalente felina y desparasitación.	Vacunación	4	2	2026-11-01 18:17:19	2026-11-01 18:17:19
5	2026-03-06	Laceración superficial en pata delantera izquierda.	Limpieza de herida y aplicación de antiséptico en spray.	Curación	5	4	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: interesado_adopcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interesado_adopcion (id_interesado, ci, nombre, telefono, direccion, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at) FROM stdin;
1	5200219	Lucas Soliz Aguilera	68482358	Barrio Las Palmas, Av. Las Palmeras	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	5200438	Fernando Gutiérrez Chávez	79403825	Plan 3000, Barrio El Quior	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	5200657	Alejandra Salazar Suárez	72682426	Villa 1ro de Mayo, Calle 3	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	5200876	Carlos Eduardo Ribera Dorado	68943754	Pampa de la Isla, Av. Montecristo	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	5201095	Carla Mariana Saucedo Aguilera	79570351	Barrio Los Pozos, Calle Suárez Arana	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	5201314	Rodrigo Salazar Montaño	66493086	Doble Vía a La Guardia, Km 6	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	5201533	Carla Mariana Dorado Pinto	79701323	Barrio Hamacas, Calle 4 Norte	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	5201752	Claudia Patricia Justiniano Chávez	65946432	Barrio Sirari, Calle Los Claveles	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	5201971	Fernanda Pinto Román	78164651	Radial 26, Barrio 24 de Septiembre	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	5202190	Alejandra Justiniano Soliz	79313470	Radial 10, Barrio 4 de Octubre	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	5202409	Miguel Ángel Antelo Ugarte	76717873	Barrio Urbari, Calle Mocoví	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	5202628	María René Mercado Hurtado	71560194	Zona Santos Dumont, 4to Anillo	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	5202847	Jessica Gutiérrez Ribera	72002175	Barrio Guaracachi, Av. Brasil	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	5203066	Laura Morales Rojas	79586141	Barrio La Cuchilla, Av. Moscú	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	5203285	Óscar Mercado Vargas	68958241	Barrio Los Chacos, Calle Las Peñas	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	5203504	Fernando Suárez Castedo	64844090	Zona Parque Industrial, PI-12	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	5203723	Leonardo Montaño Gutiérrez	71128406	Av. Banzer, Km 8.5	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	5203942	Lucas Paz Flores	65341881	Barrio Petrolero, Calle YPFB	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	5204161	Natalia Vargas Saucedo	65758783	Zona El Trompillo, Calle Cochabamba	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	5204380	Lorena Hurtado Pinto	71388723	Barrio Cordecruz, Manzano 14	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	5204599	Sebastián Antelo Soliz	76779785	Barrio Remanso, Calle Las Lajas	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	5204818	Gonzalo Dorado Condori	64433868	Barrio España, Calle Valencia	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	5205037	Carolina Vargas Hurtado	76893470	Barrio Magisterio, Av. Mutualista	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	5205256	Andrea Fabiana Justiniano Paz	67611810	Barrio Equipetrol, Calle 8 Este	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	5205475	Claudia Patricia Añez Barba	66247681	Barrio Las Palmas, Av. Las Palmeras	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	5205694	Hugo Zabala Añez	72718284	Plan 3000, Barrio El Quior	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	5205913	Adriana Torrico Román	76576286	Villa 1ro de Mayo, Calle 3	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	5206132	Jorge Luis Ribera Aguilera	77520223	Pampa de la Isla, Av. Montecristo	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	5206351	Adriana Aguilera Aguilera	68238228	Barrio Los Pozos, Calle Suárez Arana	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	5206570	Mario Alberto Peña Añez	77826978	Doble Vía a La Guardia, Km 6	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	5206789	Daniela Torrico Suárez	79874138	Barrio Hamacas, Calle 4 Norte	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	5207008	María René Castedo Castedo	71578459	Barrio Sirari, Calle Los Claveles	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	5207227	Jorge Luis Soliz Román	76158019	Radial 26, Barrio 24 de Septiembre	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	5207446	Mario Alberto Gutiérrez Pinto	64136033	Radial 10, Barrio 4 de Octubre	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	5207665	Juan Carlos Barba Saucedo	79976512	Barrio Urbari, Calle Mocoví	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	5207884	Adriana Castedo Montaño	72417645	Zona Santos Dumont, 4to Anillo	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	5208103	Gabriela Justiniano Saucedo	79289302	Barrio Guaracachi, Av. Brasil	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	5208322	Daniela Cuéllar Dorado	75835586	Barrio La Cuchilla, Av. Moscú	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	5208541	Mario Alberto Salazar Ugarte	67864207	Barrio Los Chacos, Calle Las Peñas	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	5208760	Claudia Patricia Mamani Vargas	62748166	Zona Parque Industrial, PI-12	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	5208979	Rodrigo Mendoza Antelo	72566501	Av. Banzer, Km 8.5	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	5209198	Diana Ugarte Condori	67712246	Barrio Petrolero, Calle YPFB	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	5209417	Marcelo Aguilera Saucedo	73549252	Zona El Trompillo, Calle Cochabamba	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	5209636	Lucas Peña Chávez	61228942	Barrio Cordecruz, Manzano 14	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	5209855	Mónica Montaño Montaño	62137980	Barrio Remanso, Calle Las Lajas	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	5210074	Mauricio Suárez Barba	73466477	Barrio España, Calle Valencia	Casa propia con patio mediano, rejas frontales altas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	5210293	Diego Armando Ribera Salazar	65197362	Barrio Magisterio, Av. Mutualista	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	5210512	Hugo Román Aguilera	62637432	Barrio Equipetrol, Calle 8 Este	Casa en condominio cerrado con patio posterior privado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	5210731	Carlos Eduardo Chávez Aguilera	66917479	Barrio Las Palmas, Av. Las Palmeras	Casa familiar en anticrético con autorización expresa de tenencia	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	5210950	Claudia Patricia Morales Morales	74293324	Plan 3000, Barrio El Quior	Casa propia amurallada con patio amplio y jardín cerrado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
51	5211169	Miguel Ángel Antelo Paz	68310889	Villa 1ro de Mayo, Calle 3	Casa propia con patio mediano, rejas frontales altas	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
52	5211388	Camila Soliz Barba	71797640	Pampa de la Isla, Av. Montecristo	Departamento propio en 3er piso, se permiten mascotas pequeñas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
53	5211607	Tatiana Flores Montaño	64284806	Barrio Los Pozos, Calle Suárez Arana	Casa en condominio cerrado con patio posterior privado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
54	5211826	Víctor Hugo Román Flores	68937984	Doble Vía a La Guardia, Km 6	Casa familiar en anticrético con autorización expresa de tenencia	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
55	5212045	Fernanda Justiniano Pinto	68418590	Barrio Hamacas, Calle 4 Norte	Casa propia amurallada con patio amplio y jardín cerrado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
56	5212264	Óscar Flores Montaño	69166514	Barrio Sirari, Calle Los Claveles	Casa propia con patio mediano, rejas frontales altas	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
57	5212483	Natalia Peña Barba	76539400	Radial 26, Barrio 24 de Septiembre	Departamento propio en 3er piso, se permiten mascotas pequeñas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
58	5212702	Verónica Mendoza Ribera	66663136	Radial 10, Barrio 4 de Octubre	Casa en condominio cerrado con patio posterior privado	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	81	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
59	5212921	Juan Carlos Flores Ugarte	63587660	Barrio Urbari, Calle Mocoví	Casa familiar en anticrético con autorización expresa de tenencia	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	84	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
60	5213140	Bruno Zabala Paz	63701572	Zona Santos Dumont, 4to Anillo	Casa propia amurallada con patio amplio y jardín cerrado	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	87	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
61	5213359	Diego Armando Aguilera Añez	62984618	Barrio Guaracachi, Av. Brasil	Casa propia con patio mediano, rejas frontales altas	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	90	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
62	5213578	Lucía Chávez Añez	78045792	Barrio La Cuchilla, Av. Moscú	Departamento propio en 3er piso, se permiten mascotas pequeñas	Ing. Carlos Mendoza (YPFB - Cel 76543210), Lic. Andrea Justiniano (Amiga)	93	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
63	5213797	Lucía Peña Román	76440935	Barrio Los Chacos, Calle Las Peñas	Casa en condominio cerrado con patio posterior privado	Dr. Fernando Añez (Hospital Japonés - Cel 71098765), Lic. Paola Chávez (Colega)	96	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
64	5214016	Carla Mariana Suárez Justiniano	62748619	Zona Parque Industrial, PI-12	Casa familiar en anticrético con autorización expresa de tenencia	Dra. Laura Morales (Veterinaria Particular - Cel 77012345), Ing. Mario Suárez (Vecino)	75	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
65	5214235	Lucas Antelo Antelo	79069289	Av. Banzer, Km 8.5	Casa propia amurallada con patio amplio y jardín cerrado	Lic. Roberto Gutiérrez (Empresa Sofía - Cel 78054321), Sra. María Ribera (Familiar)	78	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: interesado_adopcions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interesado_adopcions (id, ci, nombre, direccion, telefono, situacion_casa, referencias, puntaje_evaluacion, created_at, updated_at, estado) FROM stdin;
1	4920193	Mariana Paz Soldán	Av. San Martín #450, Barrio Equipetrol	77391029	Casa propia con patio amplio completamente cerrado.	Dra. Claudia Ríos (Veterinaria Particular) - 71000000	95	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
2	8192039	Jorge Justiniano Rivero	Calle Arenales #123, Centro	71629384	Departamento propio en 3er piso (Permite mascotas pequeñas).	Ing. Roberto Justiniano (Hermano) - 72000000	88	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
3	3920192	Valeria Aguilera Banegas	Barrio Sirari, Calle 3 #12	69012938	Casa familiar con jardín interno.	Lic. Sofía Aguilera (Madre) - 73000000	90	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
4	9201938	Fernando Roca Pinto	Av. Busch y 3er Anillo	72819203	Alquiler con autorización firmada por el propietario.	Carlos Roca (Padre) - 74000000	75	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
5	5829103	Andrea Melgar Justiniano	Urb. Las Palmas, Calle 5	75591823	Quinta con muro perimetral alto y áreas verdes.	Dra. María Melgar - 75000000	98	2026-11-01 18:17:19	2026-11-01 18:17:19	Pendiente
\.


--
-- Data for Name: inventario_lotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario_lotes (id, id_articulo, id_detalle_compra, id_detalle_donacion, fecha_vencimiento, cantidad_inicial, cantidad_disponible, cantidad_vencida, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: mascota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mascota (id_mascota, nombre, especie, raza, sexo, edad_aproximada, estado_actual, zona_rescate, fecha_ingreso, foto, created_at, updated_at) FROM stdin;
1	Toby #1	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Barrio Las Palmas, Av. Las Palmeras	2025-10-01	https://dbhogar.refugio.org/fotos/mascota_001.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	Lola #2	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Plan 3000, Barrio El Quior	2025-10-05	https://dbhogar.refugio.org/fotos/mascota_002.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	Max #3	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Villa 1ro de Mayo, Calle 3	2025-10-09	https://dbhogar.refugio.org/fotos/mascota_003.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	Tom #4	Felino	Tabby Atigrado	Hembra	3 años	Disponible para Adopción	Pampa de la Isla, Av. Montecristo	2025-10-13	https://dbhogar.refugio.org/fotos/mascota_004.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	Bruno #5	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Los Pozos, Calle Suárez Arana	2025-10-17	https://dbhogar.refugio.org/fotos/mascota_005.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	Kira #6	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Doble Vía a La Guardia, Km 6	2025-10-21	https://dbhogar.refugio.org/fotos/mascota_006.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	Thor #7	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Hamacas, Calle 4 Norte	2025-10-25	https://dbhogar.refugio.org/fotos/mascota_007.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	Milo #8	Felino	Siamés Mix	Hembra	4 meses	Disponible para Adopción	Barrio Sirari, Calle Los Claveles	2025-10-29	https://dbhogar.refugio.org/fotos/mascota_008.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	Simba #9	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Radial 26, Barrio 24 de Septiembre	2025-11-02	https://dbhogar.refugio.org/fotos/mascota_009.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	Daisy #10	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Radial 10, Barrio 4 de Octubre	2025-11-06	https://dbhogar.refugio.org/fotos/mascota_010.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	Firulais #11	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Barrio Urbari, Calle Mocoví	2025-11-10	https://dbhogar.refugio.org/fotos/mascota_011.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	Tigre #12	Felino	Carey	Hembra	3 años	Disponible para Adopción	Zona Santos Dumont, 4to Anillo	2025-11-14	https://dbhogar.refugio.org/fotos/mascota_012.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	Oso #13	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Guaracachi, Av. Brasil	2025-11-18	https://dbhogar.refugio.org/fotos/mascota_013.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	Blanca #14	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Barrio La Cuchilla, Av. Moscú	2025-11-22	https://dbhogar.refugio.org/fotos/mascota_014.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	Snoopy #15	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Los Chacos, Calle Las Peñas	2025-11-26	https://dbhogar.refugio.org/fotos/mascota_015.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	Sombra #16	Felino	Persa Mix	Hembra	4 meses	Disponible para Adopción	Zona Parque Industrial, PI-12	2025-11-30	https://dbhogar.refugio.org/fotos/mascota_016.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	Ragnar #17	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Av. Banzer, Km 8.5	2025-12-04	https://dbhogar.refugio.org/fotos/mascota_017.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	Chispa #18	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Barrio Petrolero, Calle YPFB	2025-12-08	https://dbhogar.refugio.org/fotos/mascota_018.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	Capitán #19	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Zona El Trompillo, Calle Cochabamba	2025-12-12	https://dbhogar.refugio.org/fotos/mascota_019.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	Pardo #20	Felino	Común Europeo	Hembra	3 años	Disponible para Adopción	Barrio Cordecruz, Manzano 14	2025-12-16	https://dbhogar.refugio.org/fotos/mascota_020.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	Toby #21	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Remanso, Calle Las Lajas	2025-12-20	https://dbhogar.refugio.org/fotos/mascota_021.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	Lola #22	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Barrio España, Calle Valencia	2025-12-24	https://dbhogar.refugio.org/fotos/mascota_022.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	Max #23	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Magisterio, Av. Mutualista	2025-12-28	https://dbhogar.refugio.org/fotos/mascota_023.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	Tom #24	Felino	Angora Mix	Hembra	4 meses	Disponible para Adopción	Barrio Equipetrol, Calle 8 Este	2026-01-01	https://dbhogar.refugio.org/fotos/mascota_024.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	Bruno #25	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Barrio Las Palmas, Av. Las Palmeras	2026-01-05	https://dbhogar.refugio.org/fotos/mascota_025.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	Kira #26	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Plan 3000, Barrio El Quior	2026-01-09	https://dbhogar.refugio.org/fotos/mascota_026.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	Thor #27	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Villa 1ro de Mayo, Calle 3	2026-01-13	https://dbhogar.refugio.org/fotos/mascota_027.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	Milo #28	Felino	Mestizo / Criollo	Hembra	3 años	Disponible para Adopción	Pampa de la Isla, Av. Montecristo	2026-01-17	https://dbhogar.refugio.org/fotos/mascota_028.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	Simba #29	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Los Pozos, Calle Suárez Arana	2026-01-21	https://dbhogar.refugio.org/fotos/mascota_029.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	Daisy #30	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Doble Vía a La Guardia, Km 6	2026-01-25	https://dbhogar.refugio.org/fotos/mascota_030.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	Firulais #31	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Hamacas, Calle 4 Norte	2026-01-29	https://dbhogar.refugio.org/fotos/mascota_031.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	Tigre #32	Felino	Tabby Atigrado	Hembra	4 meses	Disponible para Adopción	Barrio Sirari, Calle Los Claveles	2026-02-02	https://dbhogar.refugio.org/fotos/mascota_032.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	Oso #33	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Radial 26, Barrio 24 de Septiembre	2026-02-06	https://dbhogar.refugio.org/fotos/mascota_033.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	Blanca #34	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Radial 10, Barrio 4 de Octubre	2026-02-10	https://dbhogar.refugio.org/fotos/mascota_034.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	Snoopy #35	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Barrio Urbari, Calle Mocoví	2026-02-14	https://dbhogar.refugio.org/fotos/mascota_035.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	Sombra #36	Felino	Siamés Mix	Hembra	3 años	Disponible para Adopción	Zona Santos Dumont, 4to Anillo	2026-02-18	https://dbhogar.refugio.org/fotos/mascota_036.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	Ragnar #37	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Guaracachi, Av. Brasil	2026-02-22	https://dbhogar.refugio.org/fotos/mascota_037.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	Chispa #38	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Barrio La Cuchilla, Av. Moscú	2026-02-26	https://dbhogar.refugio.org/fotos/mascota_038.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	Capitán #39	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Los Chacos, Calle Las Peñas	2026-03-02	https://dbhogar.refugio.org/fotos/mascota_039.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	Pardo #40	Felino	Carey	Hembra	4 meses	Disponible para Adopción	Zona Parque Industrial, PI-12	2026-03-06	https://dbhogar.refugio.org/fotos/mascota_040.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	Toby #41	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Av. Banzer, Km 8.5	2026-03-10	https://dbhogar.refugio.org/fotos/mascota_041.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	Lola #42	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Barrio Petrolero, Calle YPFB	2026-03-14	https://dbhogar.refugio.org/fotos/mascota_042.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	Max #43	Canino	Labrador Retriever Mix	Macho	2 años	Disponible para Adopción	Zona El Trompillo, Calle Cochabamba	2026-03-18	https://dbhogar.refugio.org/fotos/mascota_043.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	Tom #44	Felino	Persa Mix	Hembra	3 años	Disponible para Adopción	Barrio Cordecruz, Manzano 14	2026-03-22	https://dbhogar.refugio.org/fotos/mascota_044.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	Bruno #45	Canino	Poodle / Caniche Mix	Macho	5 años	Disponible para Adopción	Barrio Remanso, Calle Las Lajas	2026-03-26	https://dbhogar.refugio.org/fotos/mascota_045.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	Kira #46	Canino	Chihuahua Mix	Hembra	7 meses	Disponible para Adopción	Barrio España, Calle Valencia	2026-03-30	https://dbhogar.refugio.org/fotos/mascota_046.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	Thor #47	Canino	Golden Retriever Mix	Macho	4 años	Disponible para Adopción	Barrio Magisterio, Av. Mutualista	2026-04-03	https://dbhogar.refugio.org/fotos/mascota_047.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	Milo #48	Felino	Común Europeo	Hembra	4 meses	Disponible para Adopción	Barrio Equipetrol, Calle 8 Este	2026-04-07	https://dbhogar.refugio.org/fotos/mascota_048.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	Simba #49	Canino	Pitbull Terrier	Macho	8 meses	Disponible para Adopción	Barrio Las Palmas, Av. Las Palmeras	2026-04-11	https://dbhogar.refugio.org/fotos/mascota_049.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	Daisy #50	Canino	Pastor Alemán Mix	Hembra	1 año y medio	Disponible para Adopción	Plan 3000, Barrio El Quior	2026-04-15	https://dbhogar.refugio.org/fotos/mascota_050.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
51	Firulais #51	Canino	Labrador Retriever Mix	Macho	2 años	En Tratamiento	Villa 1ro de Mayo, Calle 3	2026-04-19	https://dbhogar.refugio.org/fotos/mascota_051.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
52	Tigre #52	Felino	Angora Mix	Hembra	3 años	En Tratamiento	Pampa de la Isla, Av. Montecristo	2026-04-23	https://dbhogar.refugio.org/fotos/mascota_052.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
53	Oso #53	Canino	Poodle / Caniche Mix	Macho	5 años	En Tratamiento	Barrio Los Pozos, Calle Suárez Arana	2026-04-27	https://dbhogar.refugio.org/fotos/mascota_053.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
54	Blanca #54	Canino	Chihuahua Mix	Hembra	7 meses	En Tratamiento	Doble Vía a La Guardia, Km 6	2026-05-01	https://dbhogar.refugio.org/fotos/mascota_054.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
55	Snoopy #55	Canino	Golden Retriever Mix	Macho	4 años	En Tratamiento	Barrio Hamacas, Calle 4 Norte	2026-05-05	https://dbhogar.refugio.org/fotos/mascota_055.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
56	Sombra #56	Felino	Mestizo / Criollo	Hembra	4 meses	En Tratamiento	Barrio Sirari, Calle Los Claveles	2026-05-09	https://dbhogar.refugio.org/fotos/mascota_056.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
57	Ragnar #57	Canino	Pitbull Terrier	Macho	8 meses	En Tratamiento	Radial 26, Barrio 24 de Septiembre	2026-05-13	https://dbhogar.refugio.org/fotos/mascota_057.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
58	Chispa #58	Canino	Pastor Alemán Mix	Hembra	1 año y medio	En Tratamiento	Radial 10, Barrio 4 de Octubre	2026-05-17	https://dbhogar.refugio.org/fotos/mascota_058.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
59	Capitán #59	Canino	Labrador Retriever Mix	Macho	2 años	En Tratamiento	Barrio Urbari, Calle Mocoví	2026-05-21	https://dbhogar.refugio.org/fotos/mascota_059.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
60	Pardo #60	Felino	Tabby Atigrado	Hembra	3 años	En Tratamiento	Zona Santos Dumont, 4to Anillo	2026-05-25	https://dbhogar.refugio.org/fotos/mascota_060.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
61	Toby #61	Canino	Poodle / Caniche Mix	Macho	5 años	En Tratamiento	Barrio Guaracachi, Av. Brasil	2026-05-29	https://dbhogar.refugio.org/fotos/mascota_061.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
62	Lola #62	Canino	Chihuahua Mix	Hembra	7 meses	En Tratamiento	Barrio La Cuchilla, Av. Moscú	2026-06-02	https://dbhogar.refugio.org/fotos/mascota_062.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
63	Max #63	Canino	Golden Retriever Mix	Macho	4 años	En Tratamiento	Barrio Los Chacos, Calle Las Peñas	2026-06-06	https://dbhogar.refugio.org/fotos/mascota_063.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
64	Tom #64	Felino	Siamés Mix	Hembra	4 meses	En Tratamiento	Zona Parque Industrial, PI-12	2026-06-10	https://dbhogar.refugio.org/fotos/mascota_064.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
65	Bruno #65	Canino	Pitbull Terrier	Macho	8 meses	En Tratamiento	Av. Banzer, Km 8.5	2026-06-14	https://dbhogar.refugio.org/fotos/mascota_065.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
66	Kira #66	Canino	Pastor Alemán Mix	Hembra	1 año y medio	En Recuperación	Barrio Petrolero, Calle YPFB	2026-06-18	https://dbhogar.refugio.org/fotos/mascota_066.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
67	Thor #67	Canino	Labrador Retriever Mix	Macho	2 años	En Recuperación	Zona El Trompillo, Calle Cochabamba	2026-06-22	https://dbhogar.refugio.org/fotos/mascota_067.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
68	Milo #68	Felino	Carey	Hembra	3 años	En Recuperación	Barrio Cordecruz, Manzano 14	2026-06-26	https://dbhogar.refugio.org/fotos/mascota_068.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
69	Simba #69	Canino	Poodle / Caniche Mix	Macho	5 años	En Recuperación	Barrio Remanso, Calle Las Lajas	2026-06-30	https://dbhogar.refugio.org/fotos/mascota_069.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
70	Daisy #70	Canino	Chihuahua Mix	Hembra	7 meses	En Recuperación	Barrio España, Calle Valencia	2026-07-04	https://dbhogar.refugio.org/fotos/mascota_070.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
71	Firulais #71	Canino	Golden Retriever Mix	Macho	4 años	En Recuperación	Barrio Magisterio, Av. Mutualista	2026-07-08	https://dbhogar.refugio.org/fotos/mascota_071.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
72	Tigre #72	Felino	Persa Mix	Hembra	4 meses	En Recuperación	Barrio Equipetrol, Calle 8 Este	2026-07-12	https://dbhogar.refugio.org/fotos/mascota_072.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
73	Oso #73	Canino	Pitbull Terrier	Macho	8 meses	En Recuperación	Barrio Las Palmas, Av. Las Palmeras	2026-07-16	https://dbhogar.refugio.org/fotos/mascota_073.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
74	Blanca #74	Canino	Pastor Alemán Mix	Hembra	1 año y medio	En Recuperación	Plan 3000, Barrio El Quior	2026-07-20	https://dbhogar.refugio.org/fotos/mascota_074.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
75	Snoopy #75	Canino	Labrador Retriever Mix	Macho	2 años	En Recuperación	Villa 1ro de Mayo, Calle 3	2026-07-24	https://dbhogar.refugio.org/fotos/mascota_075.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
76	Sombra #76	Felino	Común Europeo	Hembra	3 años	En Recuperación	Pampa de la Isla, Av. Montecristo	2026-07-28	https://dbhogar.refugio.org/fotos/mascota_076.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
77	Ragnar #77	Canino	Poodle / Caniche Mix	Macho	5 años	En Recuperación	Barrio Los Pozos, Calle Suárez Arana	2026-08-01	https://dbhogar.refugio.org/fotos/mascota_077.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
78	Chispa #78	Canino	Chihuahua Mix	Hembra	7 meses	En Recuperación	Doble Vía a La Guardia, Km 6	2026-08-05	https://dbhogar.refugio.org/fotos/mascota_078.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
79	Capitán #79	Canino	Golden Retriever Mix	Macho	4 años	En Recuperación	Barrio Hamacas, Calle 4 Norte	2026-08-09	https://dbhogar.refugio.org/fotos/mascota_079.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
80	Pardo #80	Felino	Angora Mix	Hembra	4 meses	En Recuperación	Barrio Sirari, Calle Los Claveles	2026-08-13	https://dbhogar.refugio.org/fotos/mascota_080.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: mascotas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mascotas (id, nombre, raza, edad, especie, estado_actual, fecha_ingreso, sexo, zona_rescate, foto, created_at, updated_at) FROM stdin;
1	Firulais	Mestizo	2 años	Perro	Adoptado	2026-01-15	Macho	Plan 3000, Av. Paurito	https://refugio.org/fotos/firulais.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Luna	Siamesa	1 año	Gato	En Tratamiento	2026-02-10	Hembra	Mercado Abasto Antiguo	https://refugio.org/fotos/luna.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Thor	Pitbull Mestizo	3 años	Perro	Disponible	2026-03-01	Macho	Villa 1ro de Mayo, Plaza Principal	https://refugio.org/fotos/thor.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Mimi	Común Europeo	5 meses	Gato	Adoptado	2026-03-04	Hembra	Av. Banzer Km 8	https://refugio.org/fotos/mimi.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Rocky	Criollo	4 años	Perro	Disponible	2026-03-06	Macho	Equipetrol, Calle 9	https://refugio.org/fotos/rocky.jpg	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
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
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedor (id_proveedor, nombre_empresa, contacto_nombre, direccion, telefono, created_at, updated_at) FROM stdin;
1	Distribuidora Veterinaria Santa Cruz S.R.L.	Fernanda Condori Hurtado	Barrio Equipetrol, Calle 8 Este	62113822	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	Alimentos Balanceados Sofía S.A.	Hugo Vargas Hurtado	Barrio Las Palmas, Av. Las Palmeras	64340135	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	Farmacia Veterinaria El Trébol	Gonzalo Mendoza Dorado	Plan 3000, Barrio El Quior	75275414	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	Laboratorios Drogavet Bolivia	Fernando Mercado Rojas	Villa 1ro de Mayo, Calle 3	71503712	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	Insumos Médicos Veterinarios San Juan	Verónica Castedo Barba	Pampa de la Isla, Av. Montecristo	67615860	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	Agropecuaria Cotoca Import-Export	Gabriela Suárez Torrico	Barrio Los Pozos, Calle Suárez Arana	64343864	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	Comercializadora Agrovet del Oriente	Marcelo Chávez Condori	Doble Vía a La Guardia, Km 6	71949329	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	Nutrición Animal Purina Bolivia	Marcelo Gutiérrez Pinto	Barrio Hamacas, Calle 4 Norte	67855827	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	Importadora Veterinaria Guabirá	Juan Carlos Torrico Salazar	Barrio Sirari, Calle Los Claveles	77159559	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	Distribuidora de Fármacos Vetsur	Juan Carlos Dorado Román	Radial 26, Barrio 24 de Septiembre	72024501	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	Clínica y Proveedora Veterinaria Urbarí	Jessica Pinto Pinto	Radial 10, Barrio 4 de Octubre	65803645	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	Suministros Hospitalarios Santa Cruz	Mateo Aguilera Morales	Barrio Urbari, Calle Mocoví	63297899	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	Química Industrial Oriente (Desinfectantes)	Andrea Fabiana Ugarte Morales	Zona Santos Dumont, 4to Anillo	72222327	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	Plásticos y Descartables Camba	Roberto Añez Mendoza	Barrio Guaracachi, Av. Brasil	69130329	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	Distribuidora de Alimentos PetFood SCZ	Gonzalo Torrico Pinto	Barrio La Cuchilla, Av. Moscú	71042996	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	Bayer Animal Health Bolivia	Mateo Suárez Ribera	Barrio Los Chacos, Calle Las Peñas	73539378	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	Zoetis Salud Animal Santa Cruz	Carlos Eduardo Chávez Vargas	Zona Parque Industrial, PI-12	71027410	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	Virbac Bolivia Distribuciones	Alejandra Torrico Hurtado	Av. Banzer, Km 8.5	77597914	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	Laboratorios Microsules Santa Cruz	Carla Mariana Cuéllar Suárez	Barrio Petrolero, Calle YPFB	77524868	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	Importadora FarmaOriente S.R.L.	Fernanda Aguilera Torrico	Zona El Trompillo, Calle Cochabamba	73989483	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	Distribuidora El Chaco Agroquímicos	Gonzalo Ribera Condori	Barrio Cordecruz, Manzano 14	76572272	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	Equipamientos Veterinarios del Sur	Verónica Añez Mercado	Barrio Remanso, Calle Las Lajas	65691868	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	Suturas e Instrumental Quirúrgico Bolivia	Leonardo Dorado Suárez	Barrio España, Calle Valencia	73557844	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	Distribuidora Mayorista Los Pozos	Mauricio Castedo Mamani	Barrio Magisterio, Av. Mutualista	78446121	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	Comercial Veterinaria La Ramada	Ramiro Castedo Cuéllar	Barrio Equipetrol, Calle 8 Este	68855660	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	Agroferretería y Mallas Montero	Mauricio Vargas Vargas	Barrio Las Palmas, Av. Las Palmeras	75000947	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	Laboratorios Biovet Santa Cruz	Gabriela Rojas Antelo	Plan 3000, Barrio El Quior	73172155	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	Distribuidora PetShop Las Palmas	Andrea Fabiana Condori Zabala	Villa 1ro de Mayo, Calle 3	62614526	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	Bioquímica Veterinaria San Gabriel	Valeria Dorado Hurtado	Pampa de la Isla, Av. Montecristo	69718135	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	Distribuidora de Granos y Harinas El Bajío	Fernando Gutiérrez Cuéllar	Barrio Los Pozos, Calle Suárez Arana	63246345	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	Importadora Médica Alemana S.R.L.	Ramiro Zabala Mendoza	Doble Vía a La Guardia, Km 6	76720779	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	Suministros Limpieza CleanOriente	Gabriel Añez Gutiérrez	Barrio Hamacas, Calle 4 Norte	62167273	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	Industrias Químicas del Oriente S.A.	Valeria Pinto Soliz	Barrio Sirari, Calle Los Claveles	68901053	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	Comercializadora de Vacunas InmunoVet	Víctor Hugo Román Mamani	Radial 26, Barrio 24 de Septiembre	74227296	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	Distribuidora Alimentos Royal Canin SCZ	Jessica Añez Mendoza	Radial 10, Barrio 4 de Octubre	74688816	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	Veterinaria Mayorista Cañoto	Jessica Ugarte Morales	Barrio Urbari, Calle Mocoví	65747970	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	Importadora Biofarm Bolivia	Valeria Flores Morales	Zona Santos Dumont, 4to Anillo	76794045	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	Suministros para Mascotas Animall	Daniela Cuéllar Chávez	Barrio Guaracachi, Av. Brasil	62544373	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	Agroveterinaria La Cuchilla	Ximena Ribera Román	Barrio La Cuchilla, Av. Moscú	69387129	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	Comercializadora de Forrajes y Alfalfa Warnes	Daniela Peña Dorado	Barrio Los Chacos, Calle Las Peñas	76929649	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	Distribuidora San Ignacio Insumos	Mauricio Justiniano Añez	Zona Parque Industrial, PI-12	71753332	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	Equipos Médicos BioTech Santa Cruz	Mario Alberto Dorado Dorado	Av. Banzer, Km 8.5	77729192	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	Distribuidora de Insumos Hospitalarios Hamacas	Bruno Gutiérrez Peña	Barrio Petrolero, Calle YPFB	66112467	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	Fábrica de Camas y Textil PetConfort	Adriana Ugarte Paz	Zona El Trompillo, Calle Cochabamba	67407510	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	Laboratorios Calier Santa Cruz	Álvaro Paz Mendoza	Barrio Cordecruz, Manzano 14	77696675	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	Distribuidora Farmacéutica del Oriente (DFO)	Miguel Ángel Ribera Dorado	Barrio Remanso, Calle Las Lajas	64802581	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	Suministros de Laboratorio BioDiagnóstico	Natalia Vargas Román	Barrio España, Calle Valencia	72880856	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	Agropecuaria Central Santa Cruz	Fernando Torrico Román	Barrio Magisterio, Av. Mutualista	73014034	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	Distribuidora Mayorista Plan 3000	Roberto Gutiérrez Añez	Barrio Equipetrol, Calle 8 Este	61717114	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	Servicios Integrales y Logística Veterinaria S.R.L.	Rocío Vargas Gutiérrez	Barrio Las Palmas, Av. Las Palmeras	61579476	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Data for Name: proveedors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedors (id, nombre_empresa, nombre_contacto, telefono, direccion, created_at, updated_at, identificacion, tipo_insumo_provisto, activo) FROM stdin;
1	Veterinaria & Distribuidora El Paisano	Lic. Gonzalo Vargas	33529102	Av. Grigotá 4to Anillo	2026-11-01 18:17:19	2026-11-01 18:17:19	\N	\N	t
2	Comercializadora AgroCruceña	Ing. Mario Mercado	33410293	Parque Industrial PI-34	2026-11-01 18:17:19	2026-11-01 18:17:19	\N	\N	t
3	Importadora Médica Santa Cruz	Sra. Elena Claros	33682910	Calle España #240	2026-11-01 18:17:19	2026-11-01 18:17:19	\N	\N	t
\.


--
-- Data for Name: rol_permiso; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: salida_inventario; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: salida_inventarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salida_inventarios (id, motivo, id_usuario, fecha_salida, created_at, updated_at, id_historial_clinico) FROM stdin;
1	Alimentación semanal de caniles generales	3	2026-01-25	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
2	Tratamiento de gatos en área de aislamiento clínico	2	2026-02-12	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
3	Limpieza y desinfección profunda de caniles	3	2026-03-01	2026-11-01 18:17:19	2026-11-01 18:17:19	\N
\.


--
-- Data for Name: seguimiento_adopcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seguimiento_adopcion (id_seguimiento, id_adopcion, id_usuario, estado_seguimiento, fecha_programada, fecha_realizada, reporte_bienestar, fotografias_evidencia, created_at, updated_at) FROM stdin;
1	1	16	Completado	2026-08-14	2026-08-16	Excelente estado nutricional y pelaje brillante. Se verificó carnet de vacunas al día y canil techado.	https://dbhogar.refugio.org/seguimientos/evidencia_adop_001.jpg	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
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
\.


--
-- Data for Name: seguimiento_adopcions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seguimiento_adopcions (id, estado_seguimiento, fecha_programada, fecha_realizada, fotografia, reporte_bienestar, id_adopcion, id_usuario, created_at, updated_at) FROM stdin;
1	Concluido Satisfactorio	2026-02-15	2026-02-15	https://refugio.org/evidencias/seg_firulais_1.jpg	La mascota se adaptó perfectamente. Come bien y comparte con la familia.	1	3	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Pendiente	2026-03-15	\N			1	3	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Pendiente	2026-03-22	\N			2	3	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: sesion_jwt; Type: TABLE DATA; Schema: public; Owner: postgres
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
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0026_41680	26	192.168.1.36	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0027_59625	27	192.168.1.37	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0028_97751	28	192.168.1.38	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0029_72952	29	192.168.1.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0030_33246	30	192.168.1.40	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0031_11830	31	192.168.1.41	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0032_32635	32	192.168.1.42	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0033_39129	33	192.168.1.43	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0034_14320	34	192.168.1.44	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0035_63120	35	192.168.1.45	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0036_54966	36	192.168.1.46	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0037_21257	37	192.168.1.47	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0038_24782	38	192.168.1.48	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0039_66923	39	192.168.1.49	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0040_86580	40	192.168.1.50	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0041_24673	41	192.168.1.51	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0042_49041	42	192.168.1.52	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0043_36271	43	192.168.1.53	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0044_20571	44	192.168.1.54	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0045_88847	45	192.168.1.55	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0046_93913	46	192.168.1.56	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0047_73552	47	192.168.1.57	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0048_75275	48	192.168.1.58	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Expirado
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0049_12184	49	192.168.1.59	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token_refugio_dbhogar_hash_0050_11645	50	192.168.1.60	Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0	2026-10-31 14:00:12.780728	2026-12-01 14:00:12.780728	Activo
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
\.


--
-- Data for Name: tipo_aporte; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: tipo_aportes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_aportes (id, nombre, descripcion, created_at, updated_at) FROM stdin;
1	Efectivo / Transferencia	Aportes monetarios directos a la cuenta bancaria del refugio	2026-11-01 18:17:19	2026-11-01 18:17:19
2	Alimento Seco	Croquetas para perros y gatos de distintas edades	2026-11-01 18:17:19	2026-11-01 18:17:19
3	Insumos Médicos	Medicamentos, vacunas, jeringas y gasas	2026-11-01 18:17:19	2026-11-01 18:17:19
4	Artículos de Limpieza	Detergentes, desinfectantes y escobas	2026-11-01 18:17:19	2026-11-01 18:17:19
5	Mobiliario / Accesorios	Camas, correas, platos y jaulas de transporte	2026-11-01 18:17:19	2026-11-01 18:17:19
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, nombre, email, rol, telefono, password, remember_token, created_at, updated_at, ci, activo) FROM stdin;
1	Carlos Eduardo Mendoza	carlos.mendoza@patitas.com	Administrador	71029384	$2y$12$PK2I.aiJnax9rzqLMXedWuJanvO8XgPtzAEK6WNz8wnPzDFrWwTOC	\N	2026-11-01 18:17:18	2026-11-01 18:17:18	4512345 LP	t
2	Dra. Beatriz Morales Peña	beatriz.morales@patitas.com	Veterinario	75019283	$2y$12$.Nacqp.pEnR4PYIu6Glee.9fltHCn/zY.7WtD4iVhez24EN5ifmuC	\N	2026-11-01 18:17:18	2026-11-01 18:17:18	4523456 SC	t
3	Lucía Fernández Claros	lucia.fernandez@patitas.com	Voluntario	68910293	$2y$12$WivyT9MactdsuF3vQ3Ize./g.9pq2RIrFff.A0NxWfxyhd.BX.EsS	\N	2026-11-01 18:17:18	2026-11-01 18:17:18	4534567 CB	t
4	Dr. Mateo Vargas Ortiz	mateo.vargas@patitas.com	Veterinario	72109384	$2y$12$tJtzcQJeHt4ZSQaH9GrapejMKG26qY4.uiXZd785Nsg2anMk0HMRG	\N	2026-11-01 18:17:19	2026-11-01 18:17:19	4545678 CH	t
5	Camila Suárez Roca	camila.suarez@patitas.com	Recepcionista	78901234	$2y$12$UxfD/vLjGftLQQvTbu/oo.rc.ZBIwZ8LWC5E81lbGNbDhC9TVqNme	\N	2026-11-01 18:17:19	2026-11-01 18:17:19	4556789 OR	t
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, ci, nombre_completo, rol, telefono, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, created_at, updated_at) FROM stdin;
1	1000001	Administrador General del Refugio	Administrador	61227602	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
2	4500222	Fernanda Torrico Zabala	Administrador	66795913	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
3	4500333	Ramiro Paz Román	Administrador	69928653	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
4	4500444	David Mendoza Salazar	Administrador	62913081	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
5	4500555	Carla Mariana Mamani Mendoza	Administrador	61733268	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
6	4500666	Óscar Paz Peña	Veterinario	75225821	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
7	4500777	Ignacio Ribera Zabala	Veterinario	64521452	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
8	4500888	Gabriel Salazar Paz	Veterinario	64451766	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
9	4500999	Diego Armando Cuéllar Pinto	Veterinario	78235632	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
10	4501110	Jessica Rojas Cuéllar	Veterinario	72233774	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
11	4501221	Víctor Hugo Dorado Rojas	Veterinario	64291919	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
12	4501332	Rubén Añez Peña	Veterinario	68859769	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
13	4501443	Tatiana Condori Saucedo	Veterinario	67325268	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
14	4501554	Ignacio Flores Dorado	Veterinario	72716685	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
15	4501665	Juan Carlos Torrico Salazar	Veterinario	75417670	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
16	4501776	Gonzalo Morales Román	Recepcionista	69228844	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
17	4501887	Jessica Justiniano Antelo	Recepcionista	63565623	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
18	4501998	Óscar Rojas Añez	Recepcionista	72522615	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
19	4502109	Hugo Saucedo Mamani	Recepcionista	69235743	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
20	4502220	Tatiana Peña Chávez	Recepcionista	64326784	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
21	4502331	Juan Carlos Ribera Morales	Recepcionista	72295367	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
22	4502442	Ignacio Morales Rojas	Recepcionista	74529228	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
23	4502553	Rodrigo Montaño Cuéllar	Recepcionista	76592398	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
24	4502664	Carlos Eduardo Barba Saucedo	Recepcionista	76337278	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
25	4502775	Mateo Suárez Mamani	Recepcionista	77345855	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
26	4502886	Rocío Paz Ribera	Encargado de Adopciones	68219392	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
27	4502997	Carolina Román Montaño	Encargado de Adopciones	67174860	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
28	4503108	Diana Soliz Mercado	Encargado de Adopciones	78480961	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
29	4503219	Paola Andrea Rojas Ugarte	Encargado de Adopciones	78825816	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
30	4503330	Camila Justiniano Ribera	Encargado de Adopciones	63568319	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
31	4503441	Valeria Morales Dorado	Encargado de Adopciones	65038064	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
32	4503552	Mateo Rojas Antelo	Encargado de Adopciones	64353023	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
33	4503663	Claudia Patricia Román Barba	Encargado de Adopciones	74048449	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
34	4503774	Sebastián Barba Mamani	Encargado de Adopciones	63774647	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
35	4503885	Camila Soliz Ugarte	Encargado de Adopciones	75800852	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
36	4503996	Natalia Castedo Cuéllar	Inspector de Seguimiento	64727983	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
37	4504107	Sofía Mamani Saucedo	Inspector de Seguimiento	72693161	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
38	4504218	Mauricio Soliz Paz	Inspector de Seguimiento	77822620	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
39	4504329	Víctor Hugo Chávez Dorado	Inspector de Seguimiento	68470779	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
40	4504440	David Condori Aguilera	Inspector de Seguimiento	62803670	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
41	4504551	Luis Fernando Barba Ribera	Inspector de Seguimiento	79763046	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
42	4504662	Gonzalo Montaño Añez	Inspector de Seguimiento	73342760	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
43	4504773	María René Ribera Condori	Auxiliar Veterinario	76477707	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
44	4504884	Cecilia Román Montaño	Auxiliar Veterinario	79955654	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
45	4504995	Mónica Mercado Gutiérrez	Auxiliar Veterinario	78368796	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
46	4505106	Hugo Aguilera Vargas	Auxiliar Veterinario	72796079	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
47	4505217	Sofía Antelo Rojas	Auxiliar Veterinario	77737842	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
48	4505328	David Mendoza Condori	Auxiliar Veterinario	74465783	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
49	4505439	Alejandra Montaño Vargas	Auxiliar Veterinario	64455298	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
50	4505550	Daniela Condori Torrico	Auxiliar Veterinario	65199948	$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy	Activo	0	\N	2026-11-01 14:00:12.780728	2026-11-01 14:00:12.780728
\.


--
-- Name: adopcion_id_adopcion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adopcion_id_adopcion_seq', 50, true);


--
-- Name: adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adopcions_id_seq', 1, false);


--
-- Name: ajuste_inventario_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ajuste_inventario_lotes_id_seq', 1, false);


--
-- Name: ajuste_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ajuste_inventarios_id_seq', 1, false);


--
-- Name: alerta_inventario_id_alerta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerta_inventario_id_alerta_seq', 50, true);


--
-- Name: aporte_dinero_id_aporte_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aporte_dinero_id_aporte_seq', 50, true);


--
-- Name: aporte_dineros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aporte_dineros_id_seq', 1, false);


--
-- Name: articulo_inventario_id_articulo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articulo_inventario_id_articulo_seq', 50, true);


--
-- Name: articulo_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articulo_inventarios_id_seq', 1, false);


--
-- Name: bitacora_id_accion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bitacora_id_accion_seq', 50, true);


--
-- Name: bitacoras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bitacoras_id_seq', 5, true);


--
-- Name: compra_id_compra_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compra_id_compra_seq', 50, true);


--
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compras_id_seq', 1, false);


--
-- Name: detalle_compra_id_detallecompra_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_compra_id_detallecompra_seq', 50, true);


--
-- Name: detalle_compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_compras_id_seq', 1, false);


--
-- Name: detalle_donacion_insumo_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_donacion_insumo_id_detalle_seq', 50, true);


--
-- Name: detalle_donacion_insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_donacion_insumos_id_seq', 1, false);


--
-- Name: detalle_salida_id_detallesalida_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_salida_id_detallesalida_seq', 50, true);


--
-- Name: detalle_salida_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_salida_lotes_id_seq', 1, false);


--
-- Name: detalle_salidas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_salidas_id_seq', 1, false);


--
-- Name: donacion_id_donacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donacion_id_donacion_seq', 80, true);


--
-- Name: donacions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donacions_id_seq', 1, false);


--
-- Name: donante_id_donante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donante_id_donante_seq', 50, true);


--
-- Name: donantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donantes_id_seq', 1, false);


--
-- Name: evaluacion_idoneidad_id_evaluacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluacion_idoneidad_id_evaluacion_seq', 50, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: historial_clinico_id_historial_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_clinico_id_historial_seq', 50, true);


--
-- Name: historial_clinicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_clinicos_id_seq', 1, false);


--
-- Name: interesado_adopcion_id_interesado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interesado_adopcion_id_interesado_seq', 65, true);


--
-- Name: interesado_adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interesado_adopcions_id_seq', 1, false);


--
-- Name: inventario_lotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_lotes_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: mascota_id_mascota_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mascota_id_mascota_seq', 80, true);


--
-- Name: mascotas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mascotas_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 33, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 50, true);


--
-- Name: proveedors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedors_id_seq', 1, false);


--
-- Name: rol_permiso_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_permiso_id_rol_seq', 50, true);


--
-- Name: salida_inventario_id_salida_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salida_inventario_id_salida_seq', 50, true);


--
-- Name: salida_inventarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salida_inventarios_id_seq', 1, false);


--
-- Name: seguimiento_adopcion_id_seguimiento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seguimiento_adopcion_id_seguimiento_seq', 50, true);


--
-- Name: seguimiento_adopcions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seguimiento_adopcions_id_seq', 1, false);


--
-- Name: tipo_aporte_id_tipoaporte_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_aporte_id_tipoaporte_seq', 50, true);


--
-- Name: tipo_aportes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_aportes_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 50, true);


--
-- Name: adopcion adopcion_id_mascota_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT adopcion_id_mascota_key UNIQUE (id_mascota);


--
-- Name: adopcion adopcion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT adopcion_pkey PRIMARY KEY (id_adopcion);


--
-- Name: adopcions adopcions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcions
    ADD CONSTRAINT adopcions_pkey PRIMARY KEY (id);


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_pkey PRIMARY KEY (id);


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_unique UNIQUE (id_ajuste_inventario, id_inventario_lote);


--
-- Name: ajuste_inventarios ajuste_inventarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventarios
    ADD CONSTRAINT ajuste_inventarios_pkey PRIMARY KEY (id);


--
-- Name: alerta_inventario alerta_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_inventario
    ADD CONSTRAINT alerta_inventario_pkey PRIMARY KEY (id_alerta);


--
-- Name: aporte_dinero aporte_dinero_id_donacion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT aporte_dinero_id_donacion_key UNIQUE (id_donacion);


--
-- Name: aporte_dinero aporte_dinero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT aporte_dinero_pkey PRIMARY KEY (id_aporte);


--
-- Name: aporte_dineros aporte_dineros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dineros
    ADD CONSTRAINT aporte_dineros_pkey PRIMARY KEY (id);


--
-- Name: articulo_inventario articulo_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulo_inventario
    ADD CONSTRAINT articulo_inventario_pkey PRIMARY KEY (id_articulo);


--
-- Name: articulo_inventarios articulo_inventarios_nombre_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulo_inventarios
    ADD CONSTRAINT articulo_inventarios_nombre_unique UNIQUE (nombre);


--
-- Name: articulo_inventarios articulo_inventarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulo_inventarios
    ADD CONSTRAINT articulo_inventarios_pkey PRIMARY KEY (id);


--
-- Name: bitacora bitacora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (id_accion);


--
-- Name: bitacoras bitacoras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacoras
    ADD CONSTRAINT bitacoras_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);


--
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detallecompra);


--
-- Name: detalle_compras detalle_compras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compras
    ADD CONSTRAINT detalle_compras_pkey PRIMARY KEY (id);


--
-- Name: detalle_donacion_insumo detalle_donacion_insumo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT detalle_donacion_insumo_pkey PRIMARY KEY (id_detalle);


--
-- Name: detalle_donacion_insumos detalle_donacion_insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumos
    ADD CONSTRAINT detalle_donacion_insumos_pkey PRIMARY KEY (id);


--
-- Name: detalle_salida_lotes detalle_salida_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_pkey PRIMARY KEY (id);


--
-- Name: detalle_salida_lotes detalle_salida_lotes_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_unique UNIQUE (id_detalle_salida, id_inventario_lote);


--
-- Name: detalle_salida detalle_salida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT detalle_salida_pkey PRIMARY KEY (id_detallesalida);


--
-- Name: detalle_salidas detalle_salidas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salidas
    ADD CONSTRAINT detalle_salidas_pkey PRIMARY KEY (id);


--
-- Name: donacion donacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_pkey PRIMARY KEY (id_donacion);


--
-- Name: donacions donacions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacions
    ADD CONSTRAINT donacions_pkey PRIMARY KEY (id);


--
-- Name: donante donante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donante
    ADD CONSTRAINT donante_pkey PRIMARY KEY (id_donante);


--
-- Name: donantes donantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donantes
    ADD CONSTRAINT donantes_pkey PRIMARY KEY (id);


--
-- Name: evaluacion_idoneidad evaluacion_idoneidad_id_interesado_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluacion_idoneidad
    ADD CONSTRAINT evaluacion_idoneidad_id_interesado_key UNIQUE (id_interesado);


--
-- Name: evaluacion_idoneidad evaluacion_idoneidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluacion_idoneidad
    ADD CONSTRAINT evaluacion_idoneidad_pkey PRIMARY KEY (id_evaluacion);


--
-- Name: expediente_digital expediente_digital_id_mascota_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expediente_digital
    ADD CONSTRAINT expediente_digital_id_mascota_key UNIQUE (id_mascota);


--
-- Name: expediente_digital expediente_digital_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expediente_digital
    ADD CONSTRAINT expediente_digital_pkey PRIMARY KEY (nro_expediente);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: historial_clinico historial_clinico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT historial_clinico_pkey PRIMARY KEY (id_historial);


--
-- Name: historial_clinicos historial_clinicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinicos
    ADD CONSTRAINT historial_clinicos_pkey PRIMARY KEY (id);


--
-- Name: interesado_adopcion interesado_adopcion_ci_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesado_adopcion
    ADD CONSTRAINT interesado_adopcion_ci_key UNIQUE (ci);


--
-- Name: interesado_adopcion interesado_adopcion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesado_adopcion
    ADD CONSTRAINT interesado_adopcion_pkey PRIMARY KEY (id_interesado);


--
-- Name: interesado_adopcions interesado_adopcions_ci_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesado_adopcions
    ADD CONSTRAINT interesado_adopcions_ci_unique UNIQUE (ci);


--
-- Name: interesado_adopcions interesado_adopcions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesado_adopcions
    ADD CONSTRAINT interesado_adopcions_pkey PRIMARY KEY (id);


--
-- Name: inventario_lotes inventario_lotes_id_detalle_compra_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_compra_unique UNIQUE (id_detalle_compra);


--
-- Name: inventario_lotes inventario_lotes_id_detalle_donacion_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_donacion_unique UNIQUE (id_detalle_donacion);


--
-- Name: inventario_lotes inventario_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: mascota mascota_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascota
    ADD CONSTRAINT mascota_pkey PRIMARY KEY (id_mascota);


--
-- Name: mascotas mascotas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascotas
    ADD CONSTRAINT mascotas_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: proveedor proveedor_nombre_empresa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_nombre_empresa_key UNIQUE (nombre_empresa);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);


--
-- Name: proveedors proveedors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedors
    ADD CONSTRAINT proveedors_pkey PRIMARY KEY (id);


--
-- Name: rol_permiso rol_permiso_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_nombre_rol_key UNIQUE (nombre_rol);


--
-- Name: rol_permiso rol_permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_pkey PRIMARY KEY (id_rol);


--
-- Name: salida_inventario salida_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventario
    ADD CONSTRAINT salida_inventario_pkey PRIMARY KEY (id_salida);


--
-- Name: salida_inventarios salida_inventarios_historial_clinico_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_historial_clinico_unique UNIQUE (id_historial_clinico);


--
-- Name: salida_inventarios salida_inventarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_pkey PRIMARY KEY (id);


--
-- Name: seguimiento_adopcion seguimiento_adopcion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT seguimiento_adopcion_pkey PRIMARY KEY (id_seguimiento);


--
-- Name: seguimiento_adopcions seguimiento_adopcions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcions
    ADD CONSTRAINT seguimiento_adopcions_pkey PRIMARY KEY (id);


--
-- Name: sesion_jwt sesion_jwt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion_jwt
    ADD CONSTRAINT sesion_jwt_pkey PRIMARY KEY (token_hash);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: tipo_aporte tipo_aporte_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_aporte
    ADD CONSTRAINT tipo_aporte_nombre_key UNIQUE (nombre);


--
-- Name: tipo_aporte tipo_aporte_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_aporte
    ADD CONSTRAINT tipo_aporte_pkey PRIMARY KEY (id_tipoaporte);


--
-- Name: tipo_aportes tipo_aportes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_aportes
    ADD CONSTRAINT tipo_aportes_pkey PRIMARY KEY (id);


--
-- Name: users users_ci_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_ci_unique UNIQUE (ci);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_ci_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_ci_key UNIQUE (ci);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: ajuste_inventarios_articulo_created_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ajuste_inventarios_articulo_created_index ON public.ajuste_inventarios USING btree (id_articulo, created_at);


--
-- Name: ajuste_inventarios_created_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ajuste_inventarios_created_id_index ON public.ajuste_inventarios USING btree (created_at, id);


--
-- Name: bitacoras_created_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bitacoras_created_id_index ON public.bitacoras USING btree (created_at, id);


--
-- Name: bitacoras_modulo_resultado_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bitacoras_modulo_resultado_index ON public.bitacoras USING btree (modulo, resultado);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: failed_jobs_connection_queue_failed_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX failed_jobs_connection_queue_failed_at_index ON public.failed_jobs USING btree (connection, queue, failed_at);


--
-- Name: idx_adopcion_interesado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_adopcion_interesado ON public.adopcion USING btree (id_interesado);


--
-- Name: idx_adopcion_mascota; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_adopcion_mascota ON public.adopcion USING btree (id_mascota);


--
-- Name: idx_articulo_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articulo_categoria ON public.articulo_inventario USING btree (categoria);


--
-- Name: idx_bitacora_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bitacora_fecha ON public.bitacora USING btree (fecha);


--
-- Name: idx_bitacora_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bitacora_usuario ON public.bitacora USING btree (id_usuario);


--
-- Name: idx_donacion_donante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_donacion_donante ON public.donacion USING btree (id_donante);


--
-- Name: idx_historial_mascota; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_historial_mascota ON public.historial_clinico USING btree (id_mascota);


--
-- Name: idx_mascota_especie; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mascota_especie ON public.mascota USING btree (especie);


--
-- Name: idx_mascota_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mascota_estado ON public.mascota USING btree (estado_actual);


--
-- Name: idx_seguimiento_adopcion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seguimiento_adopcion ON public.seguimiento_adopcion USING btree (id_adopcion);


--
-- Name: idx_usuario_ci; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_ci ON public.usuario USING btree (ci);


--
-- Name: idx_usuario_rol; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_rol ON public.usuario USING btree (rol);


--
-- Name: interesado_adopcions_estado_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX interesado_adopcions_estado_index ON public.interesado_adopcions USING btree (estado);


--
-- Name: inventario_lotes_fefo_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventario_lotes_fefo_index ON public.inventario_lotes USING btree (id_articulo, fecha_vencimiento, cantidad_disponible);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: proveedors_active_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX proveedors_active_name_index ON public.proveedors USING btree (activo, nombre_empresa);


--
-- Name: proveedors_identificacion_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX proveedors_identificacion_index ON public.proveedors USING btree (identificacion);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: adopcion tr_actualizar_estado_mascota_adopcion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_actualizar_estado_mascota_adopcion AFTER INSERT ON public.adopcion FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_estado_mascota_adopcion();


--
-- Name: historial_clinico tr_actualizar_estado_por_historial; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_actualizar_estado_por_historial AFTER INSERT ON public.historial_clinico FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_estado_por_historial();


--
-- Name: detalle_compra tr_actualizar_stock_compra; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_actualizar_stock_compra AFTER INSERT ON public.detalle_compra FOR EACH ROW EXECUTE FUNCTION public.fn_actualizar_stock_por_compra();


--
-- Name: detalle_salida tr_descontar_stock_salida; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_descontar_stock_salida AFTER INSERT ON public.detalle_salida FOR EACH ROW EXECUTE FUNCTION public.fn_descontar_stock_por_salida();


--
-- Name: adopcion tr_registrar_bitacora_adopcion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_registrar_bitacora_adopcion AFTER INSERT ON public.adopcion FOR EACH ROW EXECUTE FUNCTION public.fn_registrar_bitacora_adopcion();


--
-- Name: articulo_inventario tr_verificar_stock_minimo_alerta; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_verificar_stock_minimo_alerta AFTER UPDATE OF stock_actual ON public.articulo_inventario FOR EACH ROW EXECUTE FUNCTION public.fn_verificar_stock_minimo_alerta();


--
-- Name: adopcions adopcions_id_interesado_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcions
    ADD CONSTRAINT adopcions_id_interesado_foreign FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcions(id) ON DELETE CASCADE;


--
-- Name: adopcions adopcions_id_mascota_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcions
    ADD CONSTRAINT adopcions_id_mascota_foreign FOREIGN KEY (id_mascota) REFERENCES public.mascotas(id) ON DELETE CASCADE;


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_id_ajuste_inventario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_id_ajuste_inventario_foreign FOREIGN KEY (id_ajuste_inventario) REFERENCES public.ajuste_inventarios(id) ON DELETE RESTRICT;


--
-- Name: ajuste_inventario_lotes ajuste_inventario_lotes_id_inventario_lote_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventario_lotes
    ADD CONSTRAINT ajuste_inventario_lotes_id_inventario_lote_foreign FOREIGN KEY (id_inventario_lote) REFERENCES public.inventario_lotes(id) ON DELETE RESTRICT;


--
-- Name: ajuste_inventarios ajuste_inventarios_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventarios
    ADD CONSTRAINT ajuste_inventarios_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE RESTRICT;


--
-- Name: ajuste_inventarios ajuste_inventarios_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ajuste_inventarios
    ADD CONSTRAINT ajuste_inventarios_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: aporte_dineros aporte_dineros_id_donacion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dineros
    ADD CONSTRAINT aporte_dineros_id_donacion_foreign FOREIGN KEY (id_donacion) REFERENCES public.donacions(id) ON DELETE CASCADE;


--
-- Name: bitacoras bitacoras_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacoras
    ADD CONSTRAINT bitacoras_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: compras compras_id_proveedor_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_id_proveedor_foreign FOREIGN KEY (id_proveedor) REFERENCES public.proveedors(id) ON DELETE CASCADE;


--
-- Name: compras compras_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: detalle_compras detalle_compras_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compras
    ADD CONSTRAINT detalle_compras_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: detalle_compras detalle_compras_id_compra_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compras
    ADD CONSTRAINT detalle_compras_id_compra_foreign FOREIGN KEY (id_compra) REFERENCES public.compras(id) ON DELETE CASCADE;


--
-- Name: detalle_donacion_insumos detalle_donacion_insumos_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumos
    ADD CONSTRAINT detalle_donacion_insumos_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: detalle_donacion_insumos detalle_donacion_insumos_id_donacion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumos
    ADD CONSTRAINT detalle_donacion_insumos_id_donacion_foreign FOREIGN KEY (id_donacion) REFERENCES public.donacions(id) ON DELETE CASCADE;


--
-- Name: detalle_salida_lotes detalle_salida_lotes_id_detalle_salida_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_id_detalle_salida_foreign FOREIGN KEY (id_detalle_salida) REFERENCES public.detalle_salidas(id) ON DELETE CASCADE;


--
-- Name: detalle_salida_lotes detalle_salida_lotes_id_inventario_lote_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida_lotes
    ADD CONSTRAINT detalle_salida_lotes_id_inventario_lote_foreign FOREIGN KEY (id_inventario_lote) REFERENCES public.inventario_lotes(id) ON DELETE RESTRICT;


--
-- Name: detalle_salidas detalle_salidas_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salidas
    ADD CONSTRAINT detalle_salidas_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: detalle_salidas detalle_salidas_id_salida_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salidas
    ADD CONSTRAINT detalle_salidas_id_salida_foreign FOREIGN KEY (id_salida) REFERENCES public.salida_inventarios(id) ON DELETE CASCADE;


--
-- Name: donacions donacions_id_donante_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacions
    ADD CONSTRAINT donacions_id_donante_foreign FOREIGN KEY (id_donante) REFERENCES public.donantes(id) ON DELETE CASCADE;


--
-- Name: donacions donacions_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacions
    ADD CONSTRAINT donacions_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: adopcion fk_adopcion_interesado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT fk_adopcion_interesado FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcion(id_interesado) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: adopcion fk_adopcion_mascota; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adopcion
    ADD CONSTRAINT fk_adopcion_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: alerta_inventario fk_alerta_articulo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_inventario
    ADD CONSTRAINT fk_alerta_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: aporte_dinero fk_aporte_donacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aporte_dinero
    ADD CONSTRAINT fk_aporte_donacion FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bitacora fk_bitacora_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT fk_bitacora_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: compra fk_compra_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: compra fk_compra_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_compra fk_detallecompra_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detallecompra_cabecera FOREIGN KEY (id_compra) REFERENCES public.compra(id_compra) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: detalle_compra fk_detallecompra_insumo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detallecompra_insumo FOREIGN KEY (id_insumo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_salida fk_detallesalida_articulo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT fk_detallesalida_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_salida fk_detallesalida_cabecera; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_salida
    ADD CONSTRAINT fk_detallesalida_cabecera FOREIGN KEY (id_salida) REFERENCES public.salida_inventario(id_salida) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: donacion fk_donacion_donante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_donante FOREIGN KEY (id_donante) REFERENCES public.donante(id_donante) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: donacion fk_donacion_tipo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_tipo FOREIGN KEY (tipo_aporte) REFERENCES public.tipo_aporte(id_tipoaporte) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: donacion fk_donacion_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT fk_donacion_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_donacion_insumo fk_donacioninsumo_articulo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT fk_donacioninsumo_articulo FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventario(id_articulo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: detalle_donacion_insumo fk_donacioninsumo_donacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_donacion_insumo
    ADD CONSTRAINT fk_donacioninsumo_donacion FOREIGN KEY (id_donacion) REFERENCES public.donacion(id_donacion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: evaluacion_idoneidad fk_evaluacion_interesado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluacion_idoneidad
    ADD CONSTRAINT fk_evaluacion_interesado FOREIGN KEY (id_interesado) REFERENCES public.interesado_adopcion(id_interesado) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: expediente_digital fk_expediente_mascota; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expediente_digital
    ADD CONSTRAINT fk_expediente_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historial_clinico fk_historial_mascota; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT fk_historial_mascota FOREIGN KEY (id_mascota) REFERENCES public.mascota(id_mascota) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historial_clinico fk_historial_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinico
    ADD CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: salida_inventario fk_salida_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventario
    ADD CONSTRAINT fk_salida_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: seguimiento_adopcion fk_seguimiento_adopcion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT fk_seguimiento_adopcion FOREIGN KEY (id_adopcion) REFERENCES public.adopcion(id_adopcion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: seguimiento_adopcion fk_seguimiento_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcion
    ADD CONSTRAINT fk_seguimiento_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sesion_jwt fk_sesion_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sesion_jwt
    ADD CONSTRAINT fk_sesion_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historial_clinicos historial_clinicos_id_mascota_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinicos
    ADD CONSTRAINT historial_clinicos_id_mascota_foreign FOREIGN KEY (id_mascota) REFERENCES public.mascotas(id) ON DELETE CASCADE;


--
-- Name: historial_clinicos historial_clinicos_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_clinicos
    ADD CONSTRAINT historial_clinicos_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: inventario_lotes inventario_lotes_id_articulo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_articulo_foreign FOREIGN KEY (id_articulo) REFERENCES public.articulo_inventarios(id) ON DELETE CASCADE;


--
-- Name: inventario_lotes inventario_lotes_id_detalle_compra_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_compra_foreign FOREIGN KEY (id_detalle_compra) REFERENCES public.detalle_compras(id) ON DELETE SET NULL;


--
-- Name: inventario_lotes inventario_lotes_id_detalle_donacion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_lotes
    ADD CONSTRAINT inventario_lotes_id_detalle_donacion_foreign FOREIGN KEY (id_detalle_donacion) REFERENCES public.detalle_donacion_insumos(id) ON DELETE SET NULL;


--
-- Name: salida_inventarios salida_inventarios_historial_clinico_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_historial_clinico_foreign FOREIGN KEY (id_historial_clinico) REFERENCES public.historial_clinicos(id) ON DELETE SET NULL;


--
-- Name: salida_inventarios salida_inventarios_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salida_inventarios
    ADD CONSTRAINT salida_inventarios_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: seguimiento_adopcions seguimiento_adopcions_id_adopcion_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcions
    ADD CONSTRAINT seguimiento_adopcions_id_adopcion_foreign FOREIGN KEY (id_adopcion) REFERENCES public.adopcions(id) ON DELETE CASCADE;


--
-- Name: seguimiento_adopcions seguimiento_adopcions_id_usuario_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento_adopcions
    ADD CONSTRAINT seguimiento_adopcions_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict rTewcgaZdRcENWhPF4ucwSS2jid4qJ8O2dKaK5VPhZjbWaSLKYPRfIz9gDj1NGt

