<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            UserSeeder::class,
            bitacoraSeeder::class,
            mascotaSeeder::class,
            historial_clinicoSeeder::class,
            interesado_adopcionSeeder::class,
            adopcionSeeder::class,
            seguimiento_adopcionSeeder::class,
            donanteSeeder::class,
            tipo_aporteSeeder::class,
            donacionSeeder::class,
            aporte_dineroSeeder::class,
            articulo_inventarioSeeder::class,
            detalle_donacion_articuloSeeder::class,
            salida_inventarioSeeder::class,
            detalle_salidaSeeder::class,
            proveedorSeeder::class,
            compraSeeder::class,
            detalle_compraSeeder::class,
        ]);
    }
}
