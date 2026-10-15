<?php

namespace App\Console\Commands;

use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;

#[Signature('app:expirar-lotes-inventario')]
#[Description('Retira del stock los lotes de medicamentos vencidos y registra la operación.')]
class ExpirarLotesInventario extends Command
{
    public function handle(InventarioLotesService $inventario, AuditoriaService $auditoria): int
    {
        $resultado = $inventario->procesarVencidos($auditoria);

        $this->info(sprintf(
            'Lotes retirados: %d; unidades retiradas: %s; artículos afectados: %d.',
            $resultado['lotes'],
            $resultado['cantidad'],
            $resultado['articulos'],
        ));

        return self::SUCCESS;
    }
}
