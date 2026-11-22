<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('dosificaciones_fiscales', function (Blueprint $table) {
            $table->id();
            $table->string('nit_emisor', 20);
            $table->string('numero_autorizacion', 50)->unique();
            $table->text('llave_dosificacion');
            $table->integer('numero_inicial')->default(1);
            $table->integer('numero_final');
            $table->integer('correlativo_actual')->default(1);
            $table->date('fecha_limite_emision');
            $table->text('leyenda_tributaria');
            $table->boolean('activa')->default(true);
            $table->foreignId('created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('dosificaciones_fiscales');
    }
};
