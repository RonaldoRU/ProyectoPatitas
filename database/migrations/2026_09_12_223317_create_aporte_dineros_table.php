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
        Schema::create('aporte_dineros', function (Blueprint $table) {
            $table->id();
            $table->decimal('monto', 10, 2);
            $table->date('fecha_recepcion');
            $table->string('comprobante', 100)->nullable();
            $table->text('observaciones')->nullable();
            $table->foreignId('id_donacion')->constrained('donacions')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('aporte_dineros');
    }
};
