<?php

namespace App\Http\Controllers\P04_DonacionesPasarela;

use App\Http\Controllers\Controller;
use App\Models\AporteDinero;
use App\Models\ArticuloInventario;
use App\Models\DetalleDonacionInsumo;
use App\Models\Donacion;
use App\Models\Donante;
use App\Models\User;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\Rule;

/**
 * Paquete P9: Pasarela de Pagos, Donaciones Monetarias y Recibos Digitales
 * Casos de Uso:
 * - CU23: Registrar Recepción de Donaciones Físicas y Monetarias
 */
class DonacionController extends Controller
{
    /**
     * CU23: Listar Donaciones Registradas (Físicas y Monetarias)
     */
    public function index(): JsonResponse
    {
        $donaciones = Donacion::query()
            ->with([
                'donante:id,nombre,telefono,tipo_persona',
                'usuario:id,nombre',
                'aportesDinero',
                'detallesInsumos.articulo:id,nombre,unidad_medida',
            ])
            ->orderByDesc('id')
            ->get();

        return response()->json(['donaciones' => $donaciones]);
    }

    /**
     * CU23: Registrar Recepción de Donación de Dinero o Insumos Materiales
     */
    public function store(
        Request $request,
        AuditoriaService $auditoria,
        InventarioLotesService $inventario,
    ): JsonResponse {
        $validated = $request->validate([
            'tipo_aporte' => ['required', Rule::in(['Insumos', 'Dinero'])],
            'fecha' => ['required', 'date'],
            'numero_documento' => ['nullable', 'string', 'max:100'],
            'id_donante' => ['nullable', 'integer', 'exists:donantes,id'],
            'donante' => ['required_without:id_donante', 'nullable', 'array'],
            'donante.nombre' => ['required_with:donante', 'string', 'max:255'],
            'donante.telefono' => ['required_with:donante', 'string', 'max:50'],
            'donante.tipo_persona' => ['required_with:donante', 'string', 'max:50'],
            // Si es dinero
            'monto' => ['required_if:tipo_aporte,Dinero', 'nullable', 'numeric', 'min:0.01'],
            'comprobante' => ['nullable', 'string', 'max:100'],
            'observaciones' => ['nullable', 'string', 'max:500'],
            'estado_pago' => ['nullable', 'string', Rule::in(['Pendiente', 'Confirmado', 'Pagado'])],
            // Si son insumos
            'lineas' => ['required_if:tipo_aporte,Insumos', 'nullable', 'array', 'min:1'],
            'lineas.*.id_articulo' => ['required_with:lineas', 'integer', 'exists:articulo_inventarios,id'],
            'lineas.*.cantidad' => ['required_with:lineas', 'numeric', 'min:0.01'],
            'lineas.*.fecha_vencimiento' => ['nullable', 'date'],
        ]);

        $donacion = DB::transaction(function () use ($request, $validated, $auditoria, $inventario): Donacion {
            $donanteId = $validated['id_donante'] ?? null;
            if ($donanteId === null && isset($validated['donante'])) {
                $donante = Donante::query()->create($validated['donante']);
                $donanteId = $donante->id;
            }

            $donacion = Donacion::query()->create([
                'tipo_aporte' => $validated['tipo_aporte'],
                'fecha' => $validated['fecha'],
                'numero_documento' => $validated['numero_documento'] ?? 'DON-'.now()->format('YmdHis'),
                'id_donante' => $donanteId,
                'id_usuario' => $request->user()->getKey(),
            ]);

            if ($validated['tipo_aporte'] === 'Dinero') {
                $estadoPago = $validated['estado_pago'] ?? 'Confirmado';
                $conceptoBase = $validated['observaciones'] ?? 'Donación en efectivo / presencial';
                $obsFinal = $estadoPago === 'Pendiente'
                    ? "Canal: Pasarela Digital | Estado: Pendiente | Concepto: {$conceptoBase}"
                    : (str_contains($conceptoBase, 'Estado:') ? $conceptoBase : "Canal: Efectivo | Estado: Confirmado | Concepto: {$conceptoBase}");

                AporteDinero::query()->create([
                    'monto' => $validated['monto'],
                    'fecha_recepcion' => $validated['fecha'],
                    'comprobante' => $validated['comprobante'] ?? $donacion->numero_documento,
                    'observaciones' => $obsFinal,
                    'id_donacion' => $donacion->id,
                ]);
            } else {
                foreach ($validated['lineas'] as $linea) {
                    $articulo = ArticuloInventario::lockForUpdate()->findOrFail($linea['id_articulo']);
                    $articulo->increment('stock_actual', $linea['cantidad']);

                    $detalle = DetalleDonacionInsumo::query()->create([
                        'id_donacion' => $donacion->id,
                        'id_articulo' => $articulo->id,
                        'cantidad' => $linea['cantidad'],
                        'fecha_vencimiento' => $linea['fecha_vencimiento'] ?? null,
                    ]);

                    $inventario->crearLoteDonacion($detalle);
                }
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar donación '.strtolower($validated['tipo_aporte']),
                'donaciones',
                entidad: $donacion,
                contexto: [
                    'tipo' => $validated['tipo_aporte'],
                    'documento' => $donacion->numero_documento,
                ],
            );

            return $donacion;
        });

        return response()->json([
            'mensaje' => 'Donación registrada correctamente y recibo generado.',
            'donacion' => $donacion->load(['donante', 'aportesDinero', 'detallesInsumos.articulo']),
        ], 201);
    }

    public function show(Donacion $donacion): JsonResponse
    {
        return response()->json([
            'donacion' => $donacion->load(['donante', 'usuario', 'aportesDinero', 'detallesInsumos.articulo']),
        ]);
    }

    /**
     * Registro público de donación de dinero (Única o Mensual) desde el portal web.
     * Genera automáticamente cuenta de usuario (Donante/Postulante), recibo digital con sello SHA-256 y envía correo electrónico.
     */
    public function storePublica(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'tipo_frecuencia' => ['required', Rule::in(['unica', 'mensual'])],
            'monto' => ['required', 'numeric', 'min:1'],
            'nombre' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'telefono' => ['nullable', 'string', 'max:50'],
            'password' => ['required', 'string', 'min:6'],
            'password_confirmation' => ['required', 'same:password'],
            'tipo_rol' => ['nullable', Rule::in(['Donante', 'Postulante'])],
            'terminos' => ['accepted'],
        ]);

        $resultado = DB::transaction(function () use ($request, $validated, $auditoria): array {
            $rolAsignado = $validated['tipo_rol'] ?? 'Donante';

            // 1. Buscar o crear Donante
            $donante = Donante::query()->firstOrCreate(
                ['nombre' => $validated['nombre']],
                [
                    'telefono' => $validated['telefono'] ?: 'Sin teléfono',
                    'tipo_persona' => 'Natural',
                ]
            );

            // 2. Buscar o crear Usuario con rol Donante o Postulante
            $user = User::query()->where('email', $validated['email'])->first();
            if (! $user) {
                $user = User::query()->create([
                    'nombre' => $validated['nombre'],
                    'email' => $validated['email'],
                    'telefono' => $validated['telefono'] ?: '70000000',
                    'rol' => $rolAsignado,
                    'password' => Hash::make($validated['password']),
                    'activo' => true,
                ]);
            }

            // 3. Registrar Donación de dinero
            $docNum = 'DON-WEB-'.now()->format('YmdHis').'-'.rand(100, 999);
            $donacion = Donacion::query()->create([
                'tipo_aporte' => 'Dinero',
                'fecha' => Carbon::today()->toDateString(),
                'numero_documento' => $docNum,
                'id_donante' => $donante->id,
                'id_usuario' => $user->id,
            ]);

            // 4. Registrar Aporte de dinero
            $frecuenciaTexto = $validated['tipo_frecuencia'] === 'mensual' ? 'Mensual (Recurrente)' : 'Única';
            $obs = "Donación online {$frecuenciaTexto} | Estado: Confirmado | Donante: {$validated['nombre']} ({$validated['email']})";

            $aporte = AporteDinero::query()->create([
                'monto' => $validated['monto'],
                'fecha_recepcion' => Carbon::today()->toDateString(),
                'comprobante' => $docNum,
                'observaciones' => $obs,
                'id_donacion' => $donacion->id,
            ]);

            // 5. Construir Comprobante / Recibo Digital Oficial
            $montoFloat = (float) $validated['monto'];
            $reciboNum = 'REC-'.str_pad((string) $aporte->id, 6, '0', STR_PAD_LEFT);
            $selloDigital = hash('sha256', $docNum.$montoFloat.Carbon::today()->toDateString().$validated['email']);
            $qrPayload = sprintf('STK-DON|%s|%.2f|Bs|%s|%s|%s', $reciboNum, $montoFloat, $frecuenciaTexto, $validated['nombre'], now()->toIso8601String());

            $recibo = [
                'numero_recibo' => $reciboNum,
                'transaccion_referencia' => $docNum,
                'fecha_emision' => now()->format('d/m/Y H:i'),
                'frecuencia' => $frecuenciaTexto,
                'monto' => $montoFloat,
                'moneda' => 'Bs',
                'donante_nombre' => $validated['nombre'],
                'donante_email' => $validated['email'],
                'donante_telefono' => $validated['telefono'] ?: 'Sin teléfono',
                'albergue' => 'Albergue Los Angelitos de Edgar',
                'albergue_nit' => 'NIT: 4892019018 • Personería Jurídica N° 342/2021',
                'albergue_direccion' => 'Av. San Martín #450, Santa Cruz de la Sierra, Bolivia',
                'sello_digital' => $selloDigital,
                'qr_payload' => $qrPayload,
                'rol_asignado' => $user->rol,
            ];

            // 6. Enviar constancia electrónica por correo
            try {
                Mail::raw(
                    "Estimado(a) {$validated['nombre']},\n\n".
                    "Agradecemos profundamente tu generoso aporte solidario al Refugio Los Angelitos de Edgar.\n\n".
                    "DETALLE DE TU COMPROBANTE ELECTRÓNICO:\n".
                    "- N° Recibo: {$reciboNum}\n".
                    "- Referencia: {$docNum}\n".
                    "- Modalidad: {$frecuenciaTexto}\n".
                    '- Monto: Bs. '.number_format($montoFloat, 2)."\n".
                    '- Fecha: '.now()->format('d/m/Y H:i')."\n".
                    "- Sello Digital SHA-256: {$selloDigital}\n\n".
                    "ACCESO A TU CUENTA DE {$user->rol}:\n".
                    "- Usuario/Email: {$validated['email']}\n".
                    "- Podrás ingresar a la plataforma para ver los animalitos disponibles para adopción y realizar nuevas donaciones.\n\n".
                    "Atentamente,\n".
                    "Refugio Los Angelitos de Edgar\n".
                    'Santa Cruz de la Sierra, Bolivia',
                    function ($message) use ($validated, $reciboNum): void {
                        $message->to($validated['email'])
                            ->subject("Comprobante de Donación Oficial {$reciboNum} - Los Angelitos de Edgar");
                    }
                );
            } catch (\Throwable $e) {
                Log::info("Notificación electrónica de recibo registrada para {$validated['email']}: ".$e->getMessage());
            }

            // 7. Auditoría
            $auditoria->registrar(
                $request,
                $user,
                "Donación online pública ({$frecuenciaTexto})",
                'donaciones',
                entidad: $donacion,
                contexto: [
                    'monto' => $montoFloat,
                    'frecuencia' => $frecuenciaTexto,
                    'recibo' => $reciboNum,
                ],
            );

            $token = $user->createToken('public-donation')->plainTextToken;

            return [
                'recibo' => $recibo,
                'usuario' => [
                    'id' => $user->id,
                    'nombre' => $user->nombre,
                    'email' => $user->email,
                    'rol' => $user->rol,
                ],
                'token' => $token,
            ];
        });

        return response()->json([
            'mensaje' => '¡Donación procesada con éxito! Se ha generado tu recibo oficial y enviado la constancia electrónica a tu correo.',
            'recibo' => $resultado['recibo'],
            'usuario' => $resultado['usuario'],
            'token' => $resultado['token'],
        ], 201);
    }
}
