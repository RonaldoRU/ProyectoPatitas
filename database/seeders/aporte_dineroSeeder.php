<?php

namespace Database\Seeders;

use App\Models\AporteDinero;
use Illuminate\Database\Seeder;

class aporte_dineroSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        AporteDinero::query()->upsert([
            [
                'id' => 3,
                'id_donacion' => 81,
                'monto' => 250.00,
                'fecha_recepcion' => '2026-10-19',
                'comprobante' => 'CAJA-EFEC-2026-001',
                'observaciones' => 'Donación en efectivo en recepción para alimentación de cachorros rescatados.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'id_donacion' => 82,
                'monto' => 180.00,
                'fecha_recepcion' => '2026-10-21',
                'comprobante' => 'CAJA-EFEC-2026-002',
                'observaciones' => 'Aporte voluntario en efectivo por cuota de recuperación de esterilización y vacunación.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'id_donacion' => 83,
                'monto' => 500.00,
                'fecha_recepcion' => '2026-10-23',
                'comprobante' => 'CAJA-EFEC-2026-003',
                'observaciones' => 'Donación en ventanilla para compra urgente de antibióticos y analgésicos de casos críticos.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 6,
                'id_donacion' => 84,
                'monto' => 320.00,
                'fecha_recepcion' => '2026-10-25',
                'comprobante' => 'CAJA-EFEC-2026-004',
                'observaciones' => 'Recaudación de alcancía solidaria en efectivo de la jornada dominical de adopción.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 7,
                'id_donacion' => 85,
                'monto' => 150.00,
                'fecha_recepcion' => '2026-10-27',
                'comprobante' => 'CAJA-EFEC-2026-005',
                'observaciones' => 'Aporte en caja directa de padrino para mantenimiento y desparasitación mensual.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 8,
                'id_donacion' => 86,
                'monto' => 400.00,
                'fecha_recepcion' => '2026-10-29',
                'comprobante' => 'CAJA-EFEC-2026-006',
                'observaciones' => 'Donación en efectivo para cubrir radiografías y yeso traumatológico de rescate de emergencia.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 9,
                'id_donacion' => 87,
                'monto' => 200.00,
                'fecha_recepcion' => '2026-10-31',
                'comprobante' => 'CAJA-EFEC-2026-007',
                'observaciones' => 'Contribución solidaria en ventanilla de visitante para insumos de limpieza y desinfección.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 10,
                'id_donacion' => 88,
                'monto' => 350.00,
                'fecha_recepcion' => '2026-11-01',
                'comprobante' => 'CAJA-EFEC-2026-008',
                'observaciones' => 'Aporte en efectivo de familia adoptante como fondo de auxilio médico para nuevos rescates.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 11,
                'id_donacion' => 89,
                'monto' => 120.00,
                'fecha_recepcion' => '2026-10-30',
                'comprobante' => 'STK-QR-2026-901',
                'observaciones' => 'Canal: QR | Estado: Confirmado | Concepto: Donación Solidaria Simple QR Campaña Vacunación',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 12,
                'id_donacion' => 90,
                'monto' => 300.00,
                'fecha_recepcion' => '2026-11-01',
                'comprobante' => 'STK-QR-2026-902',
                'observaciones' => 'Canal: QR | Estado: Confirmado | Concepto: Aporte QR Apadrinamiento Max | Ref Banco: BCP-QR-889921',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ], ['id'], ['id_donacion', 'monto', 'fecha_recepcion', 'comprobante', 'observaciones', 'updated_at']);
    }
}
