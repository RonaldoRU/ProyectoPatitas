<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detalle_facturas_legales', function (Blueprint $table) {
            $table->id();
            $table->foreignId('factura_id')->constrained('facturas_legales')->cascadeOnDelete();
            $table->string('concepto', 255);
            $table->decimal('cantidad', 10, 2);
            $table->decimal('precio_unitario', 12, 2);
            $table->decimal('subtotal', 12, 2);
            $table->string('referencia_tipo', 30)->nullable();
            $table->unsignedBigInteger('referencia_id')->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detalle_facturas_legales');
    }
};
