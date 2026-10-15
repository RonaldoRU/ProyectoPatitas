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
        Schema::table('compras', function (Blueprint $table): void {
            $table->string('numero_documento', 100)->nullable();
        });

        Schema::table('donacions', function (Blueprint $table): void {
            $table->string('numero_documento', 100)->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('donacions', function (Blueprint $table): void {
            $table->dropColumn('numero_documento');
        });

        Schema::table('compras', function (Blueprint $table): void {
            $table->dropColumn('numero_documento');
        });
    }
};
