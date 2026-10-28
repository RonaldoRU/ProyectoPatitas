<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Donacion extends Model
{
    protected $fillable = [
        'id_usuario',
        'tipo_aporte',
        'fecha',
        'numero_documento',
        'id_donante',
    ];

    public function donante(): BelongsTo
    {
        return $this->belongsTo(Donante::class, 'id_donante');
    }

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    public function aportesDinero(): HasMany
    {
        return $this->hasMany(AporteDinero::class, 'id_donacion');
    }

    public function detallesInsumos(): HasMany
    {
        return $this->hasMany(DetalleDonacionInsumo::class, 'id_donacion');
    }
}
