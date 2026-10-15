<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('proveedors', function (Blueprint $table): void {
            $table->string('identificacion', 50)->nullable();
            $table->string('tipo_insumo_provisto', 255)->nullable();
            $table->boolean('activo')->default(true);
            $table->index(['activo', 'nombre_empresa'], 'proveedors_active_name_index');
            $table->index('identificacion', 'proveedors_identificacion_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('proveedors', function (Blueprint $table) {
            $table->dropIndex('proveedors_active_name_index');
            $table->dropIndex('proveedors_identificacion_index');
            $table->dropColumn(['identificacion', 'tipo_insumo_provisto', 'activo']);
        });
    }
};
