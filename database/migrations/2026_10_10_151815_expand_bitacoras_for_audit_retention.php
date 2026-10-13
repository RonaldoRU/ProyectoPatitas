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
        Schema::table('bitacoras', function (Blueprint $table): void {
            $table->string('usuario_nombre')->nullable()->after('id_usuario');
            $table->string('modulo', 100)->default('sistema')->after('tipo_accion');
            $table->text('descripcion')->nullable()->after('modulo');
            $table->string('entidad_tipo', 100)->nullable()->after('descripcion');
            $table->string('entidad_id', 64)->nullable()->after('entidad_tipo');
            $table->string('ip', 45)->nullable()->after('entidad_id');
            $table->string('http_method', 10)->nullable()->after('ip');
            $table->string('ruta', 255)->nullable()->after('http_method');
            $table->string('resultado', 20)->default('exitosa')->after('ruta');
            $table->json('contexto')->nullable()->after('resultado');
        });

        DB::table('bitacoras')
            ->whereNull('bitacoras.usuario_nombre')
            ->update([
                'usuario_nombre' => DB::raw(
                    "COALESCE((SELECT users.nombre FROM users WHERE users.id = bitacoras.id_usuario), 'Usuario no disponible')",
                ),
            ]);

        if (DB::connection()->getDriverName() === 'sqlite') {
            Schema::create('bitacoras_audit_rebuild', function (Blueprint $table): void {
                $table->id();
                $table->string('tipo_accion');
                $table->unsignedBigInteger('id_usuario')->nullable();
                $table->string('usuario_nombre')->nullable();
                $table->string('modulo', 100)->default('sistema');
                $table->text('descripcion')->nullable();
                $table->string('entidad_tipo', 100)->nullable();
                $table->string('entidad_id', 64)->nullable();
                $table->string('ip', 45)->nullable();
                $table->string('http_method', 10)->nullable();
                $table->string('ruta', 255)->nullable();
                $table->string('resultado', 20)->default('exitosa');
                $table->json('contexto')->nullable();
                $table->timestamps();
                $table->foreign('id_usuario', 'bitacoras_id_usuario_foreign')
                    ->references('id')
                    ->on('users')
                    ->nullOnDelete();
            });

            $columns = [
                'id',
                'tipo_accion',
                'id_usuario',
                'usuario_nombre',
                'modulo',
                'descripcion',
                'entidad_tipo',
                'entidad_id',
                'ip',
                'http_method',
                'ruta',
                'resultado',
                'contexto',
                'created_at',
                'updated_at',
            ];

            DB::table('bitacoras_audit_rebuild')->insertUsing(
                $columns,
                DB::table('bitacoras')->select($columns),
            );
            Schema::drop('bitacoras');
            Schema::rename('bitacoras_audit_rebuild', 'bitacoras');

            Schema::table('bitacoras', function (Blueprint $table): void {
                $table->index(['created_at', 'id'], 'bitacoras_created_id_index');
                $table->index(['modulo', 'resultado'], 'bitacoras_modulo_resultado_index');
            });
        } else {
            Schema::table('bitacoras', function (Blueprint $table): void {
                $table->dropForeign('bitacoras_id_usuario_foreign');
                $table->unsignedBigInteger('id_usuario')->nullable()->change();
                $table->foreign('id_usuario', 'bitacoras_id_usuario_foreign')
                    ->references('id')
                    ->on('users')
                    ->nullOnDelete();
                $table->index(['created_at', 'id'], 'bitacoras_created_id_index');
                $table->index(['modulo', 'resultado'], 'bitacoras_modulo_resultado_index');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('bitacoras', function (Blueprint $table): void {
            $table->dropIndex('bitacoras_created_id_index');
            $table->dropIndex('bitacoras_modulo_resultado_index');
            $table->dropColumn([
                'usuario_nombre',
                'modulo',
                'descripcion',
                'entidad_tipo',
                'entidad_id',
                'ip',
                'http_method',
                'ruta',
                'resultado',
                'contexto',
            ]);
        });
    }
};
