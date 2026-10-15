<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('articulo_inventarios', function (Blueprint $table): void {
            $table->unique('nombre', 'articulo_inventarios_nombre_unique');
        });
    }

    public function down(): void
    {
        Schema::table('articulo_inventarios', function (Blueprint $table): void {
            $table->dropUnique('articulo_inventarios_nombre_unique');
        });
    }
};
