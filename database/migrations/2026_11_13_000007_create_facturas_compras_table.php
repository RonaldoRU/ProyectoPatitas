<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('facturas_compras', function (Blueprint $table) {
            $table->id();
            $table->foreignId('proveedor_id')->constrained('proveedors')->restrictOnDelete();
            $table->date('fecha_factura');
            $table->string('nit_proveedor', 20);
            $table->string('razon_social_proveedor', 200);
            $table->string('numero_factura', 30);
            $table->string('numero_autorizacion', 50);
            $table->string('codigo_control', 30)->nullable();
            $table->decimal('importe_total', 12, 2);
            $table->decimal('importe_exento', 12, 2)->default(0.00);
            $table->decimal('importe_base_cf', 12, 2);
            $table->decimal('credito_fiscal', 12, 2);
            $table->foreignId('registrado_por')->constrained('users')->restrictOnDelete();
            $table->timestamp('created_at')->useCurrent();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('facturas_compras');
    }
};
