<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('inventario_lotes', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('id_articulo')->constrained('articulo_inventarios')->cascadeOnDelete();
            $table->foreignId('id_detalle_compra')->nullable()->unique()
                ->constrained('detalle_compras')->nullOnDelete();
            $table->foreignId('id_detalle_donacion')->nullable()->unique()
                ->constrained('detalle_donacion_insumos')->nullOnDelete();
            $table->date('fecha_vencimiento')->nullable();
            $table->decimal('cantidad_inicial', 10, 2);
            $table->decimal('cantidad_disponible', 10, 2)->default(0);
            $table->decimal('cantidad_vencida', 10, 2)->default(0);
            $table->timestamps();
            $table->index(['id_articulo', 'fecha_vencimiento', 'cantidad_disponible'], 'inventario_lotes_fefo_index');
        });

        Schema::create('detalle_salida_lotes', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('id_detalle_salida')->constrained('detalle_salidas')->cascadeOnDelete();
            $table->foreignId('id_inventario_lote')->constrained('inventario_lotes')->restrictOnDelete();
            $table->decimal('cantidad', 10, 2);
            $table->timestamps();
            $table->unique(['id_detalle_salida', 'id_inventario_lote'], 'detalle_salida_lotes_unique');
        });

        DB::table('articulo_inventarios')
            ->orderBy('id')
            ->chunkById(200, function ($articulos): void {
                foreach ($articulos as $articulo) {
                    $compras = DB::table('detalle_compras')
                        ->where('id_articulo', $articulo->id)
                        ->selectRaw("'compra' as origen, id as id_origen, fecha_vencimiento, cantidad");
                    $donaciones = DB::table('detalle_donacion_insumos')
                        ->where('id_articulo', $articulo->id)
                        ->selectRaw("'donacion' as origen, id as id_origen, fecha_vencimiento, cantidad");

                    $detalles = $compras->unionAll($donaciones)
                        ->orderByRaw('CASE WHEN fecha_vencimiento IS NULL THEN 1 ELSE 0 END')
                        ->orderBy('fecha_vencimiento')
                        ->orderBy('id_origen')
                        ->get();

                    $stockRestante = max(0, (int) round((float) $articulo->stock_actual * 100));

                    foreach ($detalles as $detalle) {
                        $cantidadInicial = max(0, (int) round((float) $detalle->cantidad * 100));
                        $cantidadDisponible = min($cantidadInicial, $stockRestante);
                        $stockRestante -= $cantidadDisponible;

                        DB::table('inventario_lotes')->insert([
                            'id_articulo' => $articulo->id,
                            'id_detalle_compra' => $detalle->origen === 'compra' ? $detalle->id_origen : null,
                            'id_detalle_donacion' => $detalle->origen === 'donacion' ? $detalle->id_origen : null,
                            'fecha_vencimiento' => $detalle->fecha_vencimiento,
                            'cantidad_inicial' => number_format($cantidadInicial / 100, 2, '.', ''),
                            'cantidad_disponible' => number_format($cantidadDisponible / 100, 2, '.', ''),
                            'cantidad_vencida' => '0.00',
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);
                    }

                    if ($stockRestante > 0) {
                        DB::table('inventario_lotes')->insert([
                            'id_articulo' => $articulo->id,
                            'fecha_vencimiento' => null,
                            'cantidad_inicial' => number_format($stockRestante / 100, 2, '.', ''),
                            'cantidad_disponible' => number_format($stockRestante / 100, 2, '.', ''),
                            'cantidad_vencida' => '0.00',
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);
                    }
                }
            });
    }

    public function down(): void
    {
        Schema::dropIfExists('detalle_salida_lotes');
        Schema::dropIfExists('inventario_lotes');
    }
};
