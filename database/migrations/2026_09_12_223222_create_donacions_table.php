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
        Schema::create('donacions', function (Blueprint $table) {
            $table->id();
            $table->string('tipo_aporte');
            $table->date('fecha');
            $table->foreignId('id_donante')->constrained('donantes')->onDelete('cascade');
            $table->foreignId('id_usuario')->constrained('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('donacions');
    }
};
