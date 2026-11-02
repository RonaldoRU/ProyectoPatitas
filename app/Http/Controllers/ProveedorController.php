<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P5_Abastecimiento\ProveedorController as BaseProveedorController;
use App\Models\Proveedor;
use Illuminate\Database\Eloquent\Collection;

class ProveedorController extends BaseProveedorController
{
    /**
     * registrarProveedor() : Int
     */
    public function registrarProveedor(array $datos): int
    {
        $proveedor = Proveedor::query()->create($datos);

        return $proveedor->id;
    }

    /**
     * actualizarDatosContacto(tel: String, dir: String) : void
     */
    public function actualizarDatosContacto(int $idProveedor, string $tel, string $dir): void
    {
        $proveedor = Proveedor::query()->find($idProveedor);
        if ($proveedor) {
            $proveedor->update([
                'telefono' => $tel,
                'direccion' => $dir,
            ]);
        }
    }

    /**
     * listarProveedoresActivos() : List<Proveedor>
     */
    public function listarProveedoresActivos(): Collection
    {
        return Proveedor::query()
            ->where('activo', true)
            ->orderBy('nombre')
            ->get();
    }
}
