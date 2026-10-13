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
        Schema::create('adopcions', function (Blueprint $table) {
            $table->id();
            $table->string('fecha_adopcion');
            $table->foreignId('id_interesado')->constrained('interesado_adopcions')->onDelete('cascade');
            $table->foreignId('id_mascota')->constrained('mascotas')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('adopcions');
    }
};
