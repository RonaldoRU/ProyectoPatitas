<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo Donacion: Cabecera que agrupa aportes recibidos (físicos o monetarios).
 * Vincula al donante, al usuario que registró la donación y sus detalles específicos.
 */
class Donacion extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_usuario',
        'tipo_aporte',
        'fecha',
        'numero_documento',
        'id_donante',
    ];

    /**
     * Relación: Persona o institución donante.
     */
    public function donante(): BelongsTo
    {
        return $this->belongsTo(Donante::class, 'id_donante');
    }

    /**
     * Relación: Usuario que registró la donación en el sistema.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    /**
     * Relación: Aportes monetarios asociados a esta donación.
     */
    public function aportesDinero(): HasMany
    {
        return $this->hasMany(AporteDinero::class, 'id_donacion');
    }

    /**
     * Relación: Insumos o artículos físicos recibidos en esta donación.
     */
    public function detallesInsumos(): HasMany
    {
        return $this->hasMany(DetalleDonacionInsumo::class, 'id_donacion');
    }
}
