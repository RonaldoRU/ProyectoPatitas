<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cierres_periodos_reportes', function (Blueprint $table) {
            $table->id();
            $table->integer('anio');
            $table->integer('mes');
            $table->string('tipo_reporte', 40);
            $table->boolean('periodo_cerrado')->default(false);
            $table->string('hash_documento', 64);
            $table->foreignId('generado_por')->constrained('users')->restrictOnDelete();
            $table->timestamp('created_at')->useCurrent();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cierres_periodos_reportes');
    }
};
