<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        // 1. Eliminar restricciones CHECK legadas restrictivas que bloquean registros de distintos roles/estados
        $dropChecks = [
            'ALTER TABLE IF EXISTS seguimiento_adopcion DROP CONSTRAINT IF EXISTS seguimiento_adopcion_estado_seguimiento_check',
            'ALTER TABLE IF EXISTS seguimiento_adopcions DROP CONSTRAINT IF EXISTS seguimiento_adopcions_estado_seguimiento_check',
            'ALTER TABLE IF EXISTS articulo_inventario DROP CONSTRAINT IF EXISTS articulo_inventario_categoria_check',
            'ALTER TABLE IF EXISTS articulo_inventarios DROP CONSTRAINT IF EXISTS articulo_inventarios_categoria_check',
            'ALTER TABLE IF EXISTS donante DROP CONSTRAINT IF EXISTS donante_tipo_persona_check',
            'ALTER TABLE IF EXISTS donantes DROP CONSTRAINT IF EXISTS donantes_tipo_persona_check',
            'ALTER TABLE IF EXISTS mascota DROP CONSTRAINT IF EXISTS mascota_especie_check',
            'ALTER TABLE IF EXISTS mascota DROP CONSTRAINT IF EXISTS mascota_estado_actual_check',
            'ALTER TABLE IF EXISTS mascota DROP CONSTRAINT IF EXISTS mascota_sexo_check',
            'ALTER TABLE IF EXISTS mascotas DROP CONSTRAINT IF EXISTS mascotas_especie_check',
            'ALTER TABLE IF EXISTS mascotas DROP CONSTRAINT IF EXISTS mascotas_estado_actual_check',
            'ALTER TABLE IF EXISTS mascotas DROP CONSTRAINT IF EXISTS mascotas_sexo_check',
            'ALTER TABLE IF EXISTS evaluacion_idoneidad DROP CONSTRAINT IF EXISTS evaluacion_idoneidad_resultado_check',
            'ALTER TABLE IF EXISTS alerta_inventario DROP CONSTRAINT IF EXISTS alerta_inventario_estado_check',
            'ALTER TABLE IF EXISTS alerta_inventario DROP CONSTRAINT IF EXISTS alerta_inventario_nivel_criticidad_check',
            'ALTER TABLE IF EXISTS usuario DROP CONSTRAINT IF EXISTS usuario_estado_check',
            'ALTER TABLE IF EXISTS usuario DROP CONSTRAINT IF EXISTS usuario_rol_check',
            'ALTER TABLE IF EXISTS users DROP CONSTRAINT IF EXISTS users_rol_check',
            'ALTER TABLE IF EXISTS sesion_jwt DROP CONSTRAINT IF EXISTS sesion_jwt_estado_check',
        ];

        foreach ($dropChecks as $sql) {
            DB::statement($sql);
        }

        // 2. Ampliar columnas de fotografías y reportes para soportar múltiples imágenes y descripciones extensas
        $alterColumns = [
            'ALTER TABLE IF EXISTS seguimiento_adopcions ALTER COLUMN fotografia TYPE TEXT',
            'ALTER TABLE IF EXISTS seguimiento_adopcions ALTER COLUMN reporte_bienestar TYPE TEXT',
            'ALTER TABLE IF EXISTS seguimiento_adopcion ALTER COLUMN fotografias_evidencia TYPE TEXT',
            'ALTER TABLE IF EXISTS seguimiento_adopcion ALTER COLUMN reporte_bienestar TYPE TEXT',
            'ALTER TABLE IF EXISTS mascotas ALTER COLUMN foto TYPE TEXT',
            'ALTER TABLE IF EXISTS mascota ALTER COLUMN foto TYPE TEXT',
        ];

        foreach ($alterColumns as $sql) {
            DB::statement($sql);
        }

        // 3. Blindar todas las funciones de sincronización (fn_sync_*) con EXCEPTION WHEN OTHERS THEN RETURN NEW
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION public.fn_sync_seguimientos_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_adopcions_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_articulos_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_donacions_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_donantes_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_interesados_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_mascotas_to_mascota()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_proveedors_to_singular()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_sync_users_to_usuario()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.sync_medicamentos_to_medicamento()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.fn_registrar_bitacora_adopcion()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
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
$function$;
SQL);

        // 4. Sincronizar secuencias de claves primarias en todas las tablas con columna 'id'
        $tables = DB::select("
            SELECT table_name
            FROM information_schema.columns
            WHERE table_schema = 'public' AND column_name = 'id'
              AND data_type IN ('integer', 'bigint')
        ");

        foreach ($tables as $t) {
            $table = $t->table_name;
            try {
                DB::statement("
                    SELECT setval(
                        pg_get_serial_sequence('\"{$table}\"', 'id'),
                        GREATEST(COALESCE((SELECT MAX(id) FROM \"{$table}\"), 1), 1),
                        true
                    )
                    WHERE pg_get_serial_sequence('\"{$table}\"', 'id') IS NOT NULL
                ");
            } catch (Throwable) {
                // ignorar tablas sin secuencia serial
            }
        }
    }

    public function down(): void
    {
        // No revertir correcciones de integridad
    }
};
