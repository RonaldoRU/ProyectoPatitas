<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cronograma_tratamientos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('prescripcion_id')->constrained('prescripciones_dosificacion')->cascadeOnDelete();
            $table->foreignId('lote_inventario_id')->nullable()->constrained('inventario_lotes')->nullOnDelete();
            $table->timestamp('fecha_hora_programada');
            $table->timestamp('fecha_hora_administrada')->nullable();
            $table->foreignId('administrado_por')->nullable()->constrained('users')->nullOnDelete();
            $table->string('estado', 20)->default('PENDIENTE');
            $table->text('notas')->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cronograma_tratamientos');
    }
};
