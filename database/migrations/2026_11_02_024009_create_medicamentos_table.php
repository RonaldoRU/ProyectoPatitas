<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('medicamentos', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('id_medicamento')->nullable()->index();
            $table->string('nombre');
            $table->string('principio_activo');
            $table->string('categoria_farmacologica', 100);
            $table->string('tipo_presentacion', 100);
            $table->string('via_administracion', 100);
            $table->string('concentracion', 100);
            $table->string('especie_destino', 100)->default('Caninos y Felinos');
            $table->string('dosis_recomendada', 255);
            $table->text('indicacion_terapeutica');
            $table->boolean('es_inyectable')->default(false)->index();
            $table->string('lote', 50)->nullable();
            $table->date('fecha_vencimiento')->nullable();
            $table->decimal('stock_actual', 12, 2)->default(0);
            $table->decimal('stock_minimo', 12, 2)->default(5);
            $table->string('unidad_medida', 50)->default('Frasco');
            $table->decimal('precio_unitario', 10, 2)->default(0.00);
            $table->timestamps();
        });

        Schema::create('medicamento', function (Blueprint $table) {
            $table->increments('id_medicamento');
            $table->string('nombre');
            $table->string('principio_activo');
            $table->string('categoria_farmacologica', 100);
            $table->string('tipo_presentacion', 100);
            $table->string('via_administracion', 100);
            $table->string('concentracion', 100);
            $table->string('especie_destino', 100)->default('Caninos y Felinos');
            $table->string('dosis_recomendada', 255);
            $table->text('indicacion_terapeutica');
            $table->boolean('es_inyectable')->default(false);
            $table->string('lote', 50)->nullable();
            $table->date('fecha_vencimiento')->nullable();
            $table->decimal('stock_actual', 12, 2)->default(0);
            $table->decimal('stock_minimo', 12, 2)->default(5);
            $table->string('unidad_medida', 50)->default('Frasco');
            $table->decimal('precio_unitario', 10, 2)->default(0.00);
            $table->timestamps();
        });

        // Trigger bi-direccional para PostgreSQL
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
                CREATE OR REPLACE FUNCTION sync_medicamentos_to_medicamento()
                RETURNS TRIGGER AS $$
                BEGIN
                    INSERT INTO medicamento (
                        id_medicamento, nombre, principio_activo, categoria_farmacologica,
                        tipo_presentacion, via_administracion, concentracion, especie_destino,
                        dosis_recomendada, indicacion_terapeutica, es_inyectable, lote,
                        fecha_vencimiento, stock_actual, stock_minimo, unidad_medida,
                        precio_unitario, created_at, updated_at
                    ) VALUES (
                        NEW.id, NEW.nombre, NEW.principio_activo, NEW.categoria_farmacologica,
                        NEW.tipo_presentacion, NEW.via_administracion, NEW.concentracion, NEW.especie_destino,
                        NEW.dosis_recomendada, NEW.indicacion_terapeutica, NEW.es_inyectable, NEW.lote,
                        NEW.fecha_vencimiento, NEW.stock_actual, NEW.stock_minimo, NEW.unidad_medida,
                        NEW.precio_unitario, NEW.created_at, NEW.updated_at
                    )
                    ON CONFLICT (id_medicamento) DO UPDATE SET
                        nombre = EXCLUDED.nombre,
                        principio_activo = EXCLUDED.principio_activo,
                        categoria_farmacologica = EXCLUDED.categoria_farmacologica,
                        tipo_presentacion = EXCLUDED.tipo_presentacion,
                        via_administracion = EXCLUDED.via_administracion,
                        concentracion = EXCLUDED.concentracion,
                        especie_destino = EXCLUDED.especie_destino,
                        dosis_recomendada = EXCLUDED.dosis_recomendada,
                        indicacion_terapeutica = EXCLUDED.indicacion_terapeutica,
                        es_inyectable = EXCLUDED.es_inyectable,
                        lote = EXCLUDED.lote,
                        fecha_vencimiento = EXCLUDED.fecha_vencimiento,
                        stock_actual = EXCLUDED.stock_actual,
                        stock_minimo = EXCLUDED.stock_minimo,
                        unidad_medida = EXCLUDED.unidad_medida,
                        precio_unitario = EXCLUDED.precio_unitario,
                        updated_at = EXCLUDED.updated_at;
                    RETURN NEW;
                END;
                $$ LANGUAGE plpgsql;

                DROP TRIGGER IF EXISTS trg_sync_medicamentos ON medicamentos;
                CREATE TRIGGER trg_sync_medicamentos
                AFTER INSERT OR UPDATE ON medicamentos
                FOR EACH ROW EXECUTE FUNCTION sync_medicamentos_to_medicamento();
            SQL);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared('DROP TRIGGER IF EXISTS trg_sync_medicamentos ON medicamentos;');
            DB::unprepared('DROP FUNCTION IF EXISTS sync_medicamentos_to_medicamento();');
        }
        Schema::dropIfExists('medicamentos');
        Schema::dropIfExists('medicamento');
    }
};
