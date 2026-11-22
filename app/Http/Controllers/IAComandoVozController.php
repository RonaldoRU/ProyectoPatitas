<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Services\IA\ReporteToolService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Controlador de Inteligencia Artificial para Comandos de Voz especializado en Reportes PDF específicos.
 * Procesa instrucciones en lenguaje natural de forma rápida mediante:
 * 1. Google Gemini API con Tool Calling (1 solo round-trip rápido cuando se envía texto o audio).
 * 2. Motor semántico NLU local instantáneo (respuesta en milisegundos).
 */
class IAComandoVozController extends Controller
{
    public function __construct(
        private readonly ReporteToolService $reporteToolService
    ) {}

    /**
     * Retorna la información de estado de Google Gemini sin exponer la API key.
     */
    public function info(): JsonResponse
    {
        $geminiKey = config('services.gemini.api_key');
        $model = config('services.gemini.model', 'gemini-2.0-flash');
        $activoGemini = ! empty($geminiKey);

        return response()->json([
            'proveedor' => 'Google Gemini',
            'modo' => $activoGemini ? 'gemini' : 'local',
            'modelo' => $activoGemini ? $model : 'semantico_local',
            'configurado_en_env' => $activoGemini,
            'especialidad' => 'reportes_pdf',
            'herramientas' => $this->reporteToolService->nombresHerramientas(),
        ]);
    }

    /**
     * Procesa un comando de voz (texto o audio) para generar reportes PDF específicos de forma rápida.
     */
    public function procesar(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'comando' => ['nullable', 'string', 'max:500'],
            'audio' => ['nullable', 'string'],
            'audio_mime' => ['nullable', 'string', 'max:50'],
            'contexto_pantalla' => ['nullable', 'string', 'max:100'],
        ]);

        $comando = isset($validated['comando']) ? trim($validated['comando']) : null;
        $audio = $validated['audio'] ?? null;
        $audioMime = $validated['audio_mime'] ?? 'audio/webm';
        $contexto = $validated['contexto_pantalla'] ?? 'general';
        $user = $request->user();

        if (empty($comando) && empty($audio)) {
            return response()->json([
                'accion' => 'ayuda',
                'mensaje_hablado' => 'Dime qué reporte específico deseas generar: gerencial, mascotas, donaciones, inventario, adopciones, postulantes, visitas, atenciones clínicas, IVA, compras o mermas.',
                'motor_usado' => 'Local (NLU)',
                'herramienta_usada' => null,
                'reporte' => null,
            ]);
        }

        $geminiKey = config('services.gemini.api_key');
        $modelo = config('services.gemini.model', 'gemini-2.0-flash');

        // 1. Procesamiento con Google Gemini API + Tool Calling si está configurado
        if (! empty($geminiKey)) {
            try {
                $resultado = $this->llamarGeminiConTools($comando, $audio, $audioMime, $contexto, $geminiKey, $modelo, $user);
                if ($resultado !== null) {
                    return response()->json($resultado);
                }
            } catch (\Throwable $e) {
                Log::warning('Fallo en Google Gemini API, usando motor local rápido: '.$e->getMessage());
            }
        }

        // 2. Motor NLU Semántico Local Instantáneo (<15ms)
        if (! empty($comando)) {
            $resultadoLocal = $this->clasificadorSemanticoLocal($comando, $user);

            return response()->json($resultadoLocal);
        }

        return response()->json([
            'accion' => 'ayuda',
            'mensaje_hablado' => 'No pude procesar el audio en este momento. Intenta decir qué reporte deseas generar: gerencial, mascotas, donaciones, inventario, adopciones, postulantes, visitas o atenciones clínicas.',
            'motor_usado' => 'Local (NLU)',
            'herramienta_usada' => null,
            'reporte' => null,
        ]);
    }

    /**
     * Llamada optimizada a Google Gemini API con Function Calling (Tool Calling).
     *
     * @return array<string, mixed>|null
     */
    private function llamarGeminiConTools(
        ?string $comando,
        ?string $audio,
        string $audioMime,
        string $contexto,
        string $apiKey,
        string $modelo,
        ?User $user
    ): ?array {
        $hoy = now()->toDateString();

        $systemPrompt = <<<PROMPT
Eres el Asistente de Voz especialista en generar reportes PDF específicos para el "Refugio Angelitos de Edgar".
Fecha actual: {$hoy}. Pantalla activa: "{$contexto}".

Reglas estrictas:
1. SOLO generas reportes usando las herramientas declaradas (gerencial, mascotas, donaciones, inventario, adopciones, postulantes, visitas_seguimiento, atenciones_clinicas, facturacion_iva, compras_proveedores, salidas_mermas).
2. NUNCA hagas preguntas aclaratorias. Usa valores por defecto e invoca la herramienta de inmediato.
3. La moneda oficial del refugio (Santa Cruz, Bolivia) es el boliviano (Bs). Siempre expresa montos en "bolivianos".
4. Convierte fechas relativas ("este mes", "hoy", "último trimestre") a YYYY-MM-DD usando {$hoy}.
5. Si piden algo fuera de reportes (ej. cerrar sesión), responde brevemente indicando que solo generas reportes.
PROMPT;

        $parts = [];

        if (! empty($audio)) {
            $mimeLimpio = trim(explode(';', $audioMime)[0]) ?: 'audio/webm';
            $parts[] = [
                'inline_data' => [
                    'mime_type' => $mimeLimpio,
                    'data' => $audio,
                ],
            ];
            $parts[] = [
                'text' => 'Escucha el comando de voz y llama de inmediato a la herramienta de reporte específico correspondiente.',
            ];
        } else {
            $parts[] = [
                'text' => "Solicitud del usuario: \"{$comando}\"",
            ];
        }

        $userContent = [
            'role' => 'user',
            'parts' => $parts,
        ];

        $payload = [
            'system_instruction' => [
                'parts' => [
                    ['text' => $systemPrompt],
                ],
            ],
            'contents' => [$userContent],
            'tools' => [
                [
                    'functionDeclarations' => $this->reporteToolService->toolDeclarations(),
                ],
            ],
            'generationConfig' => [
                'temperature' => 0.1,
            ],
        ];

        $modelosCandidatos = array_values(array_unique([
            $modelo,
            'gemini-2.0-flash',
            'gemini-flash-latest',
        ]));

        $response = null;
        $modeloUsado = $modelo;
        $url = '';

        foreach ($modelosCandidatos as $candidato) {
            $url = "https://generativelanguage.googleapis.com/v1beta/models/{$candidato}:generateContent?key={$apiKey}";
            try {
                $intento = Http::withHeaders([
                    'Content-Type' => 'application/json',
                ])->timeout(8)->post($url, $payload);

                if ($intento->successful()) {
                    $response = $intento;
                    $modeloUsado = $candidato;
                    break;
                }

                Log::warning("Error en llamada a Gemini API ({$candidato}, HTTP {$intento->status()}): ".$intento->body());

                if (! in_array($intento->status(), [404, 429, 503], true)) {
                    return null;
                }
            } catch (\Throwable $e) {
                Log::warning("Excepción llamando a Gemini API ({$candidato}): ".$e->getMessage());
            }
        }

        if ($response === null) {
            return null;
        }

        $modelo = $modeloUsado;

        $data = $response->json();
        $candidateParts = $data['candidates'][0]['content']['parts'] ?? [];

        if (! is_array($candidateParts) || count($candidateParts) === 0) {
            return null;
        }

        $functionCallPart = null;
        foreach ($candidateParts as $part) {
            if (is_array($part) && isset($part['functionCall']['name'])) {
                $functionCallPart = $part;
                break;
            }
        }

        if ($functionCallPart !== null) {
            $toolName = (string) $functionCallPart['functionCall']['name'];
            $args = is_array($functionCallPart['functionCall']['args'] ?? null)
                ? $functionCallPart['functionCall']['args']
                : [];

            $resultadoHerramienta = $this->reporteToolService->ejecutar($toolName, $args, $user);

            // Turno 2 rápido (máximo 4s) para respuesta hablada natural con fallback instantáneo
            $mensajeHablado = $this->obtenerRespuestaFinalGemini(
                $url,
                $systemPrompt,
                $userContent,
                $functionCallPart,
                $toolName,
                $resultadoHerramienta['resumen_para_ia']
            ) ?? $resultadoHerramienta['mensaje_defecto'];

            if (! empty($resultadoHerramienta['sin_datos'])) {
                return [
                    'accion' => 'sin_datos',
                    'mensaje_hablado' => $resultadoHerramienta['mensaje_defecto'],
                    'motor_usado' => "Google Gemini ({$modelo})",
                    'herramienta_usada' => $toolName,
                    'reporte' => null,
                ];
            }

            if (! $resultadoHerramienta['autorizado'] || $resultadoHerramienta['reporte'] === null) {
                return [
                    'accion' => 'fuera_de_alcance',
                    'mensaje_hablado' => $mensajeHablado,
                    'motor_usado' => "Google Gemini ({$modelo})",
                    'herramienta_usada' => $toolName,
                    'reporte' => null,
                ];
            }

            return [
                'accion' => 'generar_reporte_pdf',
                'mensaje_hablado' => $mensajeHablado,
                'motor_usado' => "Google Gemini ({$modelo})",
                'herramienta_usada' => $toolName,
                'reporte' => $resultadoHerramienta['reporte'],
            ];
        }

        $textoRespuesta = '';
        foreach ($candidateParts as $part) {
            if (is_array($part) && isset($part['text'])) {
                $textoRespuesta .= trim((string) $part['text']).' ';
            }
        }
        $textoRespuesta = trim($textoRespuesta);

        if ($textoRespuesta === '') {
            return null;
        }

        return [
            'accion' => 'fuera_de_alcance',
            'mensaje_hablado' => $textoRespuesta,
            'motor_usado' => "Google Gemini ({$modelo})",
            'herramienta_usada' => null,
            'reporte' => null,
        ];
    }

    /**
     * Segundo turno rápido de Tool Calling (timeout corto de 4s).
     *
     * @param  array<string, mixed>  $userContent
     * @param  array<string, mixed>  $functionCallPart
     * @param  array<string, mixed>  $resumenParaIa
     */
    private function obtenerRespuestaFinalGemini(
        string $url,
        string $systemPrompt,
        array $userContent,
        array $functionCallPart,
        string $toolName,
        array $resumenParaIa
    ): ?string {
        try {
            $response = Http::withHeaders([
                'Content-Type' => 'application/json',
            ])->timeout(4)->post($url, [
                'system_instruction' => [
                    'parts' => [
                        ['text' => $systemPrompt.' Responde en una sola oración breve y natural en español confirmando el reporte generado y sus cifras clave.'],
                    ],
                ],
                'contents' => [
                    $userContent,
                    [
                        'role' => 'model',
                        'parts' => [$functionCallPart],
                    ],
                    [
                        'role' => 'function',
                        'parts' => [
                            [
                                'functionResponse' => [
                                    'name' => $toolName,
                                    'response' => $resumenParaIa,
                                ],
                            ],
                        ],
                    ],
                ],
                'generationConfig' => [
                    'temperature' => 0.2,
                ],
            ]);

            if ($response->successful()) {
                $text = $response->json('candidates.0.content.parts.0.text');
                if (is_string($text) && trim($text) !== '') {
                    return trim($text);
                }
            }
        } catch (\Throwable $e) {
            Log::info('Segundo turno de Gemini omitido, usando mensaje por defecto: '.$e->getMessage());
        }

        return null;
    }

    /**
     * Motor NLU semántico local instantáneo especializado en reportes específicos del refugio.
     *
     * @return array<string, mixed>
     */
    private function clasificadorSemanticoLocal(string $comando, ?User $user): array
    {
        $c = mb_strtolower($comando, 'UTF-8');

        // Ayuda
        if (str_contains($c, 'ayuda') || str_contains($c, 'que puedes hacer') || str_contains($c, 'qué puedes hacer') || str_contains($c, 'comandos')) {
            return [
                'accion' => 'ayuda',
                'mensaje_hablado' => 'Puedo generar al instante reportes en PDF de: mascotas (perros, gatos, disponibles), adopciones, postulantes, visitas de seguimiento, atenciones clínicas, inventario (por categoría, stock bajo o vencimientos), salidas/mermas, compras a proveedores, donaciones, libro IVA y reporte gerencial.',
                'motor_usado' => 'Local (NLU)',
                'herramienta_usada' => null,
                'reporte' => null,
            ];
        }

        // Extraer rango de fechas rápido si menciona "este mes" o "hoy"
        $fechasArgs = [];
        if (str_contains($c, 'este mes') || str_contains($c, 'mes actual')) {
            $fechasArgs['fecha_desde'] = now()->startOfMonth()->toDateString();
            $fechasArgs['fecha_hasta'] = now()->endOfMonth()->toDateString();
        } elseif (str_contains($c, 'hoy')) {
            $fechasArgs['fecha_desde'] = now()->toDateString();
            $fechasArgs['fecha_hasta'] = now()->toDateString();
        }

        // 1. Reporte de Visitas de Seguimiento Post-Adopción
        if (str_contains($c, 'visita') || str_contains($c, 'seguimiento')) {
            $args = [];
            if (str_contains($c, 'pendient') || str_contains($c, 'programad')) {
                $args['estado_seguimiento'] = 'Pendiente';
            } elseif (str_contains($c, 'complet') || str_contains($c, 'concluid') || str_contains($c, 'realizad')) {
                $args['estado_seguimiento'] = 'Concluido Satisfactorio';
            }

            return $this->construirRespuestaHerramientaLocal('generar_reporte_visitas_seguimiento', $args, $user);
        }

        // 2. Reporte de Postulantes a Adopción
        if (str_contains($c, 'postulante') || str_contains($c, 'idoneidad') || str_contains($c, 'interesado')) {
            $args = [];
            if (str_contains($c, 'aprobado')) {
                $args['estado'] = 'Aprobado';
            } elseif (str_contains($c, 'pendiente')) {
                $args['estado'] = 'Pendiente';
            } elseif (str_contains($c, 'rechazado')) {
                $args['estado'] = 'Rechazado';
            }

            return $this->construirRespuestaHerramientaLocal('generar_reporte_postulantes', $args, $user);
        }

        // 3. Reporte de Atenciones Clínicas / Expediente Médico
        if (str_contains($c, 'clinica') || str_contains($c, 'clínica') || str_contains($c, 'atencion') || str_contains($c, 'atención') || str_contains($c, 'cirugia') || str_contains($c, 'cirugía') || str_contains($c, 'consulta') || str_contains($c, 'veterinari')) {
            $args = $fechasArgs;
            if (str_contains($c, 'cirugia') || str_contains($c, 'cirugía')) {
                $args['tipo_procedimiento'] = 'Cirugía';
            } elseif (str_contains($c, 'consulta')) {
                $args['tipo_procedimiento'] = 'Consulta';
            } elseif (str_contains($c, 'vacun')) {
                $args['tipo_procedimiento'] = 'Vacunación';
            }

            return $this->construirRespuestaHerramientaLocal('generar_reporte_atenciones_clinicas', $args, $user);
        }

        // 4. Reporte Tributario / Facturación IVA
        if (str_contains($c, 'iva') || str_contains($c, 'factura') || str_contains($c, 'tributar') || str_contains($c, 'fiscal') || str_contains($c, 'sin')) {
            return $this->construirRespuestaHerramientaLocal('generar_reporte_facturacion_iva', [
                'mes' => now()->month,
                'anio' => now()->year,
            ], $user);
        }

        // 5. Reporte de Compras y Proveedores
        if (str_contains($c, 'compra') || str_contains($c, 'proveedor') || str_contains($c, 'abastecimiento')) {
            return $this->construirRespuestaHerramientaLocal('generar_reporte_compras_proveedores', $fechasArgs, $user);
        }

        // 6. Reporte de Salidas y Mermas
        if (str_contains($c, 'merma') || str_contains($c, 'ajuste') || str_contains($c, 'salida') || str_contains($c, 'consumo') || str_contains($c, 'despensa')) {
            $args = ['tipo' => str_contains($c, 'merma') || str_contains($c, 'ajuste') ? 'mermas' : 'salidas'];

            return $this->construirRespuestaHerramientaLocal('generar_reporte_salidas_mermas', $args, $user);
        }

        // 7. Reporte de Mascotas / Rescates
        if (str_contains($c, 'mascota') || str_contains($c, 'perro') || str_contains($c, 'canin') || str_contains($c, 'gato') || str_contains($c, 'felin') || str_contains($c, 'rescate')) {
            $args = $fechasArgs;
            if (str_contains($c, 'perro') || str_contains($c, 'canin')) {
                $args['especie'] = 'Canino';
            } elseif (str_contains($c, 'gato') || str_contains($c, 'felin')) {
                $args['especie'] = 'Felino';
            }
            if (str_contains($c, 'en adopcion') || str_contains($c, 'en adopción') || str_contains($c, 'disponible')) {
                $args['estado_actual'] = 'Disponible';
            } elseif (str_contains($c, 'tratamiento')) {
                $args['estado_actual'] = 'En Tratamiento';
            } elseif (str_contains($c, 'recuperacion') || str_contains($c, 'recuperación')) {
                $args['estado_actual'] = 'En Recuperación';
            } elseif (str_contains($c, 'adoptado')) {
                $args['estado_actual'] = 'Adoptado';
            }

            return $this->construirRespuestaHerramientaLocal('generar_reporte_mascotas', $args, $user);
        }

        // 8. Reporte de Adopciones Formalizadas
        if (str_contains($c, 'adopcion') || str_contains($c, 'adopción') || str_contains($c, 'adoptante')) {
            return $this->construirRespuestaHerramientaLocal('generar_reporte_adopciones', $fechasArgs, $user);
        }

        // 9. Reporte de Donaciones
        if (str_contains($c, 'donacion') || str_contains($c, 'donación') || str_contains($c, 'aporte') || str_contains($c, 'recaud')) {
            $args = $fechasArgs;
            if (str_contains($c, 'dinero') || str_contains($c, 'efectivo') || str_contains($c, 'monetari')) {
                $args['tipo_aporte'] = 'Dinero';
            } elseif (str_contains($c, 'insumo') || str_contains($c, 'especie')) {
                $args['tipo_aporte'] = 'Insumos';
            }

            return $this->construirRespuestaHerramientaLocal('generar_reporte_donaciones', $args, $user);
        }

        // 10. Reporte de Inventario / Stock / Categorías / Vencimientos
        if (str_contains($c, 'inventario') || str_contains($c, 'stock') || str_contains($c, 'insumo') || str_contains($c, 'medicamento') || str_contains($c, 'alimento') || str_contains($c, 'vacuna') || str_contains($c, 'limpieza') || str_contains($c, 'vencer') || str_contains($c, 'vencimiento')) {
            $args = [];
            if (str_contains($c, 'vencer') || str_contains($c, 'vencimiento') || str_contains($c, 'caduc')) {
                $args['dias_vencimiento'] = 30;
            } elseif (str_contains($c, 'bajo') || str_contains($c, 'critico') || str_contains($c, 'crítico') || str_contains($c, 'alerta') || str_contains($c, 'reponer')) {
                $args['solo_bajo_stock'] = true;
            }

            if (str_contains($c, 'alimento')) {
                $args['categoria'] = 'Alimento';
            } elseif (str_contains($c, 'medicamento') || str_contains($c, 'farmac')) {
                $args['categoria'] = 'Medicamento';
            } elseif (str_contains($c, 'vacuna')) {
                $args['categoria'] = 'Vacuna';
            } elseif (str_contains($c, 'limpieza')) {
                $args['categoria'] = 'Limpieza';
            } elseif (str_contains($c, 'accesorio')) {
                $args['categoria'] = 'Accesorio';
            }

            return $this->construirRespuestaHerramientaLocal('generar_reporte_inventario', $args, $user);
        }

        // 11. Reporte Gerencial / Indicadores / Balance / PDF genérico
        if (str_contains($c, 'gerencial') || str_contains($c, 'indicador') || str_contains($c, 'balance') || str_contains($c, 'estadistica') || str_contains($c, 'estadística') || str_contains($c, 'semestre') || str_contains($c, 'reporte') || str_contains($c, 'informe') || str_contains($c, 'pdf')) {
            return $this->construirRespuestaHerramientaLocal('generar_reporte_gerencial', ['meses' => 6], $user);
        }

        return [
            'accion' => 'fuera_de_alcance',
            'mensaje_hablado' => 'Solo estoy especializado en generar reportes en PDF. Puedes pedirme un reporte gerencial, de mascotas, donaciones, inventario, adopciones, postulantes, visitas, atenciones clínicas o IVA.',
            'motor_usado' => 'Local (NLU)',
            'herramienta_usada' => null,
            'reporte' => null,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function construirRespuestaHerramientaLocal(string $toolName, array $args, ?User $user): array
    {
        $resultado = $this->reporteToolService->ejecutar($toolName, $args, $user);

        if (! empty($resultado['sin_datos'])) {
            return [
                'accion' => 'sin_datos',
                'mensaje_hablado' => $resultado['mensaje_defecto'],
                'motor_usado' => 'Local (NLU)',
                'herramienta_usada' => $toolName,
                'reporte' => null,
            ];
        }

        if (! $resultado['autorizado'] || $resultado['reporte'] === null) {
            return [
                'accion' => 'fuera_de_alcance',
                'mensaje_hablado' => $resultado['mensaje_defecto'],
                'motor_usado' => 'Local (NLU)',
                'herramienta_usada' => $toolName,
                'reporte' => null,
            ];
        }

        return [
            'accion' => 'generar_reporte_pdf',
            'mensaje_hablado' => $resultado['mensaje_defecto'],
            'motor_usado' => 'Local (NLU)',
            'herramienta_usada' => $toolName,
            'reporte' => $resultado['reporte'],
        ];
    }
}
