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
        Schema::create('detalle_salidas', function (Blueprint $table) {
            $table->id();
            $table->decimal('cantidad', 10, 2);
            $table->foreignId('id_salida')->constrained('salida_inventarios')->onDelete('cascade');
            $table->foreignId('id_articulo')->constrained('articulo_inventarios')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('detalle_salidas');
    }
};
