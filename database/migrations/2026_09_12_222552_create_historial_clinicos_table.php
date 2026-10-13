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
        Schema::create('historial_clinicos', function (Blueprint $table) {
            $table->id();
            $table->string('fecha_atencion');
            $table->string('diagnostico');
            $table->string('observacion');
            $table->string('tipo_procedimiento');
            $table->foreignId('id_mascota')->constrained('mascotas')->onDelete('cascade');
            $table->foreignId('id_usuario')->constrained('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('historial_clinicos');
    }
};
