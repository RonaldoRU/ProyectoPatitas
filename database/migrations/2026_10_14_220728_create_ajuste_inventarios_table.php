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
        Schema::create('ajuste_inventarios', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('id_articulo')->constrained('articulo_inventarios')->restrictOnDelete();
            $table->foreignId('id_usuario')->nullable()->constrained('users')->nullOnDelete();
            $table->string('usuario_nombre');
            $table->unsignedInteger('cantidad');
            $table->decimal('stock_anterior', 12, 2);
            $table->decimal('stock_nuevo', 12, 2);
            $table->decimal('saldo_disponible_anterior', 12, 2);
            $table->decimal('saldo_disponible_nuevo', 12, 2);
            $table->text('motivo');
            $table->timestamps();
            $table->index(['created_at', 'id'], 'ajuste_inventarios_created_id_index');
            $table->index(['id_articulo', 'created_at'], 'ajuste_inventarios_articulo_created_index');
        });

        Schema::create('ajuste_inventario_lotes', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('id_ajuste_inventario')
                ->constrained('ajuste_inventarios')
                ->restrictOnDelete();
            $table->foreignId('id_inventario_lote')
                ->constrained('inventario_lotes')
                ->restrictOnDelete();
            $table->decimal('cantidad', 12, 2);
            $table->unique(['id_ajuste_inventario', 'id_inventario_lote'], 'ajuste_inventario_lotes_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ajuste_inventario_lotes');
        Schema::dropIfExists('ajuste_inventarios');
    }
};
