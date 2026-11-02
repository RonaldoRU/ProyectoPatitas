<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P2_Usuarios\UsuarioController as BaseUsuarioController;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UsuarioController extends BaseUsuarioController
{
    /**
     * buscarPorId(id: Int) : Usuario
     */
    public function buscarPorId(int $id): ?User
    {
        return User::query()->find($id);
    }

    /**
     * buscarPorCI(ci: String) : Usuario
     */
    public function buscarPorCI(string $ci): ?User
    {
        return User::query()->where('ci', $ci)->first();
    }

    /**
     * validarPassword(pass: String) : Boolean
     */
    public function validarPassword(User $usuario, string $pass): bool
    {
        return Hash::check($pass, $usuario->password);
    }

    /**
     * actualizarPassword(nuevaHash: String) : void
     */
    public function actualizarPassword(User $usuario, string $nuevaHash): void
    {
        $usuario->update([
            'password' => Hash::needsRehash($nuevaHash) ? Hash::make($nuevaHash) : $nuevaHash,
        ]);
    }

    /**
     * actualizarDatos(tel: String) : void
     */
    public function actualizarDatos(User $usuario, string $tel): void
    {
        $usuario->update([
            'telefono' => $tel,
        ]);
    }
}
