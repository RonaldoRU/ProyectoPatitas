<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasColumn('users', 'user_name') && ! Schema::hasColumn('users', 'nombre')) {
            Schema::table('users', function (Blueprint $table): void {
                $table->renameColumn('user_name', 'nombre');
            });
        }

        if (Schema::hasColumn('users', 'correo') && ! Schema::hasColumn('users', 'email')) {
            Schema::table('users', function (Blueprint $table): void {
                $table->renameColumn('correo', 'email');
            });
        }

        Schema::table('users', function (Blueprint $table): void {
            $table->enum('rol', [
                'Administrador',
                'Veterinario',
                'Recepcionista',
                'Voluntario',
            ])->change();
        });

        if (Schema::hasColumn('password_reset_tokens', 'correo') && ! Schema::hasColumn('password_reset_tokens', 'email')) {
            Schema::table('password_reset_tokens', function (Blueprint $table): void {
                $table->renameColumn('correo', 'email');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('password_reset_tokens', 'email') && ! Schema::hasColumn('password_reset_tokens', 'correo')) {
            Schema::table('password_reset_tokens', function (Blueprint $table): void {
                $table->renameColumn('email', 'correo');
            });
        }

        if (Schema::hasColumn('users', 'nombre') && ! Schema::hasColumn('users', 'user_name')) {
            Schema::table('users', function (Blueprint $table): void {
                $table->string('rol')->change();
            });

            Schema::table('users', function (Blueprint $table): void {
                $table->renameColumn('nombre', 'user_name');
            });
        }

        if (Schema::hasColumn('users', 'email') && ! Schema::hasColumn('users', 'correo')) {
            Schema::table('users', function (Blueprint $table): void {
                $table->renameColumn('email', 'correo');
            });
        }
    }
};
