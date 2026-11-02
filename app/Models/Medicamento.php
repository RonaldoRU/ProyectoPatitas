<?php

namespace App\Models;

use Carbon\Carbon;
use Database\Factories\MedicamentoFactory;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Medicamento extends Model
{
    /** @use HasFactory<MedicamentoFactory> */
    use HasFactory;

    protected $table = 'medicamentos';

    protected $fillable = [
        'id_medicamento',
        'nombre',
        'principio_activo',
        'categoria_farmacologica',
        'tipo_presentacion',
        'via_administracion',
        'concentracion',
        'especie_destino',
        'dosis_recomendada',
        'indicacion_terapeutica',
        'es_inyectable',
        'lote',
        'fecha_vencimiento',
        'stock_actual',
        'stock_minimo',
        'unidad_medida',
        'precio_unitario',
    ];

    protected $casts = [
        'es_inyectable' => 'boolean',
        'fecha_vencimiento' => 'date',
        'stock_actual' => 'decimal:2',
        'stock_minimo' => 'decimal:2',
        'precio_unitario' => 'decimal:2',
    ];

    /**
     * Scope para filtrar únicamente medicamentos inyectables.
     */
    public function scopeInyectables(Builder $query): Builder
    {
        return $query->where('es_inyectable', true);
    }

    /**
     * Scope para filtrar medicamentos por especie de destino.
     */
    public function scopePorEspecie(Builder $query, string $especie): Builder
    {
        return $query->where(function (Builder $subQuery) use ($especie): void {
            $subQuery->where('especie_destino', 'like', '%'.$especie.'%')
                ->orWhere('especie_destino', 'Caninos y Felinos');
        });
    }

    /**
     * Scope para medicamentos vigentes (no vencidos).
     */
    public function scopeVigentes(Builder $query): Builder
    {
        return $query->where(function (Builder $subQuery): void {
            $subQuery->whereNull('fecha_vencimiento')
                ->orWhereDate('fecha_vencimiento', '>=', Carbon::today());
        });
    }

    /**
     * Scope para medicamentos próximos a vencer.
     */
    public function scopeProximosAVencer(Builder $query, int $dias = 30): Builder
    {
        $hoy = Carbon::today();

        return $query->whereNotNull('fecha_vencimiento')
            ->whereBetween('fecha_vencimiento', [$hoy, $hoy->copy()->addDays($dias)]);
    }
}
