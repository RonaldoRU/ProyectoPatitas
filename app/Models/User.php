<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

/**
 * Modelo User: Representa los usuarios del sistema (Administrador, Veterinario, Voluntario, etc.).
 * Gestiona credenciales de acceso, autenticación web/API con Sanctum y roles de usuario.
 *
 * @property int $id
 * @property string $nombre
 * @property string|null $ci
 * @property string $email
 * @property string $telefono
 * @property string $password
 * @property string|null $remember_token
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 */
#[Fillable(['nombre', 'ci', 'email', 'telefono', 'rol', 'password', 'activo'])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Relación: Registros de auditoría generados por este usuario.
     */
    public function bitacoras(): HasMany
    {
        return $this->hasMany(Bitacora::class, 'id_usuario');
    }

    /**
     * Define las transformaciones automáticas de tipo de datos para los atributos.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'password' => 'hashed',
            'activo' => 'boolean',
        ];
    }
}
