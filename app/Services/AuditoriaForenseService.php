<?php

namespace App\Services;

use App\Models\AuditoriaForense;
use Illuminate\Http\Request;

class AuditoriaForenseService
{
    /**
     * Registra un evento inmutable en la bitácora forense con hash SHA-256.
     *
     * @param  array<string, mixed>|null  $anterior
     * @param  array<string, mixed>|null  $nuevo
     */
    public function registrar(
        Request $request,
        string $severidad,
        string $modulo,
        string $accion,
        ?string $tablaAfectada = null,
        string|int|null $registroId = null,
        ?array $anterior = null,
        ?array $nuevo = null
    ): AuditoriaForense {
        $fechaEvento = now();
        $usuarioId = $request->user()?->id;
        $ip = $request->ip() ?? '127.0.0.1';
        $payloadBase = json_encode([
            'fecha' => $fechaEvento->toIso8601String(),
            'usuario_id' => $usuarioId,
            'ip' => $ip,
            'severidad' => $severidad,
            'modulo' => $modulo,
            'accion' => $accion,
            'tabla' => $tablaAfectada,
            'registro_id' => $registroId !== null ? (string) $registroId : null,
            'anterior' => $anterior,
            'nuevo' => $nuevo,
        ], JSON_UNESCAPED_UNICODE) ?: '';

        return AuditoriaForense::query()->create([
            'fecha_evento' => $fechaEvento,
            'usuario_id' => $usuarioId,
            'ip_origen' => $ip,
            'user_agent' => substr((string) ($request->userAgent() ?? 'Desconocido'), 0, 500),
            'severidad' => $severidad,
            'modulo' => $modulo,
            'accion' => $accion,
            'tabla_afectada' => $tablaAfectada,
            'registro_id' => $registroId !== null ? (string) $registroId : null,
            'payload_anterior' => $anterior,
            'payload_nuevo' => $nuevo,
            'hash_integridad' => hash('sha256', $payloadBase),
        ]);
    }
}
