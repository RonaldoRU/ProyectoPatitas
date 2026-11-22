<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        $rolesPermitidos = ['Administrador', 'Veterinario', 'Recepcionista', 'Voluntario'];
        $usuariosExcluidos = DB::table('users')
            ->whereNotIn('rol', $rolesPermitidos)
            ->pluck('id')
            ->all();

        if (count($usuariosExcluidos) > 0) {
            $fallbackAdminId = DB::table('users')
                ->whereIn('rol', $rolesPermitidos)
                ->orderByRaw("CASE WHEN rol = 'Administrador' THEN 0 ELSE 1 END, id ASC")
                ->value('id');

            if ($fallbackAdminId !== null) {
                $tablasConIdUsuario = [
                    'bitacoras' => 'id_usuario',
                    'compras' => 'id_usuario',
                    'donacions' => 'id_usuario',
                    'historial_clinicos' => 'id_usuario',
                    'salida_inventarios' => 'id_usuario',
                    'ajuste_inventarios' => 'id_usuario',
                ];

                foreach ($tablasConIdUsuario as $tabla => $columna) {
                    if (DB::getSchemaBuilder()->hasTable($tabla) && DB::getSchemaBuilder()->hasColumn($tabla, $columna)) {
                        DB::table($tabla)->whereIn($columna, $usuariosExcluidos)->update([$columna => $fallbackAdminId]);
                    }
                }
            }

            DB::table('personal_access_tokens')
                ->where('tokenable_type', 'App\\Models\\User')
                ->whereIn('tokenable_id', $usuariosExcluidos)
                ->delete();

            DB::table('users')->whereIn('id', $usuariosExcluidos)->delete();
        }

        if (DB::getSchemaBuilder()->hasTable('usuario')) {
            DB::table('usuario')->whereNotIn('rol', $rolesPermitidos)->delete();
        }

        if (DB::getDriverName() === 'pgsql') {
            DB::statement('ALTER TABLE users DROP CONSTRAINT IF EXISTS users_rol_check');
            DB::statement("ALTER TABLE users ADD CONSTRAINT users_rol_check CHECK (rol IN ('Administrador', 'Veterinario', 'Recepcionista', 'Voluntario'))");
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('ALTER TABLE users DROP CONSTRAINT IF EXISTS users_rol_check');
            DB::statement("ALTER TABLE users ADD CONSTRAINT users_rol_check CHECK (rol IN ('Administrador', 'Veterinario', 'Recepcionista', 'Voluntario', 'Auxiliar Veterinario', 'Encargado de Adopciones', 'Inspector de Seguimiento'))");
        }
    }
};
