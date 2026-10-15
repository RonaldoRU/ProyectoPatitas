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
        Schema::table('salida_inventarios', function (Blueprint $table) {
            $table->foreignId('id_historial_clinico')
                ->nullable();
            $table->unique('id_historial_clinico', 'salida_inventarios_historial_clinico_unique');
            $table->foreign('id_historial_clinico', 'salida_inventarios_historial_clinico_foreign')
                ->references('id')
                ->on('historial_clinicos')
                ->nullOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('salida_inventarios', function (Blueprint $table) {
            $table->dropForeign('salida_inventarios_historial_clinico_foreign');
            $table->dropUnique('salida_inventarios_historial_clinico_unique');
            $table->dropColumn('id_historial_clinico');
        });
    }
};
