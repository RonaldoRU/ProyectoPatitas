<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('prescripciones_dosificacion', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mascota_id')->constrained('mascotas')->restrictOnDelete();
            $table->foreignId('historial_clinico_id')->nullable()->constrained('historial_clinicos')->nullOnDelete();
            $table->foreignId('articulo_id')->constrained('articulo_inventarios')->restrictOnDelete();
            $table->foreignId('veterinario_id')->constrained('users')->restrictOnDelete();
            $table->decimal('peso_mascota_kg', 6, 2);
            $table->decimal('dosis_mg_kg', 8, 3);
            $table->decimal('concentracion_farmaco', 8, 3);
            $table->decimal('dosis_calculada_unidad', 8, 3);
            $table->string('unidad_medida', 20);
            $table->integer('frecuencia_horas');
            $table->integer('duracion_dias');
            $table->text('observaciones_clinicas')->nullable();
            $table->string('estado', 20)->default('ACTIVO');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('prescripciones_dosificacion');
    }
};
