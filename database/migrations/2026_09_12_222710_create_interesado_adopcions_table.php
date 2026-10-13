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
        Schema::create('interesado_adopcions', function (Blueprint $table) {
            $table->id();
            $table->string('ci', 20)->unique();
            $table->string('nombre');
            $table->string('direccion');
            $table->string('telefono');
            $table->string('situacion_casa');
            $table->string('referencias');
            $table->string('puntaje_evaluacion');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('interesado_adopcions');
    }
};
