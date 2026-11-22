<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('facturas_legales', function (Blueprint $table) {
            $table->id();
            $table->foreignId('dosificacion_id')->constrained('dosificaciones_fiscales')->restrictOnDelete();
            $table->integer('numero_factura');
            $table->string('numero_autorizacion', 50);
            $table->timestamp('fecha_emision')->useCurrent();
            $table->string('nit_ci_cliente', 20);
            $table->string('complemento_ci', 5)->nullable();
            $table->string('razon_social_cliente', 200);
            $table->decimal('subtotal', 12, 2);
            $table->decimal('descuento', 12, 2)->default(0.00);
            $table->decimal('importe_total', 12, 2);
            $table->decimal('importe_base_cf', 12, 2);
            $table->decimal('debito_fiscal', 12, 2);
            $table->string('codigo_control', 30);
            $table->text('cadena_qr');
            $table->string('estado', 15)->default('EMITIDA');
            $table->text('motivo_anulacion')->nullable();
            $table->timestamp('fecha_anulacion')->nullable();
            $table->foreignId('usuario_emisor_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('usuario_anulador_id')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->unique(['numero_autorizacion', 'numero_factura']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('facturas_legales');
    }
};
