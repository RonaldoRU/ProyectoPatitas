<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('auditoria_forense', function (Blueprint $table) {
            $table->id();
            $table->timestampTz('fecha_evento')->useCurrent();
            $table->foreignId('usuario_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('ip_origen', 45);
            $table->text('user_agent')->nullable();
            $table->string('severidad', 20)->default('INFO');
            $table->string('modulo', 60);
            $table->string('accion', 50);
            $table->string('tabla_afectada', 60)->nullable();
            $table->string('registro_id', 50)->nullable();
            $table->jsonb('payload_anterior')->nullable();
            $table->jsonb('payload_nuevo')->nullable();
            $table->string('hash_integridad', 64);

            $table->index(['severidad', 'fecha_evento']);
            $table->index(['modulo', 'fecha_evento']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('auditoria_forense');
    }
};
