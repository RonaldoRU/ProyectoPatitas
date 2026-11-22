<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Agrega el atributo `estado` a la tabla `proveedors` (y `proveedor` si existe).
     */
    public function up(): void
    {
        if (! Schema::hasColumn('proveedors', 'estado')) {
            Schema::table('proveedors', function (Blueprint $table): void {
                $table->string('estado', 50)->default('Activo');
            });

            DB::table('proveedors')
                ->where('activo', false)
                ->update(['estado' => 'Inactivo']);
        }

        if (Schema::hasTable('proveedor') && ! Schema::hasColumn('proveedor', 'estado')) {
            Schema::table('proveedor', function (Blueprint $table): void {
                $table->string('estado', 50)->default('Activo');
            });
        }
    }

    /**
     * Revierte la columna `estado` de las tablas de proveedores.
     */
    public function down(): void
    {
        if (Schema::hasColumn('proveedors', 'estado')) {
            Schema::table('proveedors', function (Blueprint $table): void {
                $table->dropColumn('estado');
            });
        }

        if (Schema::hasTable('proveedor') && Schema::hasColumn('proveedor', 'estado')) {
            Schema::table('proveedor', function (Blueprint $table): void {
                $table->dropColumn('estado');
            });
        }
    }
};
