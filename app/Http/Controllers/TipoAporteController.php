<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P9_PagosDonaciones\TipoAporteController as BaseTipoAporteController;
use App\Models\TipoAporte;
use Illuminate\Database\Eloquent\Collection;

class TipoAporteController extends BaseTipoAporteController
{
    /**
     * listarTipos() : List<TipoAporte>
     */
    public function listarTipos(): Collection
    {
        return TipoAporte::query()->orderBy('nombre')->get();
    }
}
