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
        Schema::create('seguimiento_adopcions', function (Blueprint $table) {
            $table->id();
            $table->string('estado_seguimiento');
            $table->date('fecha_programada');
            $table->date('fecha_realizada')->nullable();
            $table->string('fotografia');
            $table->string('reporte_bienestar');
            $table->foreignId('id_adopcion')->constrained('adopcions')->onDelete('cascade');
            $table->foreignId('id_usuario')->constrained('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('seguimiento_adopcions');
    }
};
