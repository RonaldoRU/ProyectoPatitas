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
        Schema::create('salida_inventarios', function (Blueprint $table) {
            $table->id();
            $table->string('motivo', 255);
            $table->foreignId('id_usuario')->constrained('users')->onDelete('cascade');
            $table->date('fecha_salida');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('salida_inventarios');
    }
};
