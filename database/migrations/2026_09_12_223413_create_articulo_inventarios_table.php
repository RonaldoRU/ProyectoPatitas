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
        Schema::create('articulo_inventarios', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 150);
            $table->string('categoria', 50);
            $table->string('unidad_medida', 20);
            $table->decimal('stock_actual', 10, 2)->default(0.00);
            $table->decimal('stock_minimo_alerta', 10, 2)->default(0.00);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('articulo_inventarios');
    }
};
