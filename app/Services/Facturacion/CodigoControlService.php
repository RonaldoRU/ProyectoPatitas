<?php

namespace App\Services\Facturacion;

/**
 * Generador de Código de Control Tributario (Verhoeff + AllegedRC4 + Base64).
 */
class CodigoControlService
{
    private const VERHOEFF_D = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
        [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
        [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
        [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
        [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
        [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
        [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
        [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
        [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
    ];

    private const VERHOEFF_P = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
        [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
        [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
        [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
        [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
        [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
        [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
    ];

    private const VERHOEFF_INV = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

    private const DICCIONARIO_BASE64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

    public function generar(
        string $numeroAutorizacion,
        int $numeroFactura,
        string $nitCiCliente,
        string $fechaYmd,
        float $montoTotal,
        string $llaveDosificacion
    ): string {
        $montoRedondeado = (string) ((int) round($montoTotal));
        $nitLimpio = preg_replace('/\D/', '', $nitCiCliente) ?: '0';

        $nroFacturaV = $this->agregarVerhoeff((string) $numeroFactura, 2);
        $nitV = $this->agregarVerhoeff($nitLimpio, 2);
        $fechaV = $this->agregarVerhoeff($fechaYmd, 2);
        $montoV = $this->agregarVerhoeff($montoRedondeado, 2);

        $suma = (int) $nroFacturaV + (int) $nitV + (int) $fechaV + (int) $montoV;
        $verhoeff5 = $this->agregarVerhoeff((string) $suma, 5);
        $digitos = substr($verhoeff5, -5);

        $pos = 0;
        $cadenas = [];
        for ($i = 0; $i < 5; $i++) {
            $len = ((int) $digitos[$i]) + 1;
            $cadenas[] = substr($llaveDosificacion, $pos, $len);
            $pos += $len;
        }

        $concatenada = ($numeroAutorizacion.$cadenas[0])
            .($nroFacturaV.$cadenas[1])
            .($nitV.$cadenas[2])
            .($fechaV.$cadenas[3])
            .($montoV.$cadenas[4]);

        $rc4 = $this->allegedRc4($concatenada, $llaveDosificacion.$digitos);
        $sumaTotal = 0;
        $sumasParciales = [0, 0, 0, 0, 0];
        $longitud = strlen($rc4);

        for ($i = 0; $i < $longitud; $i++) {
            $ascii = ord($rc4[$i]);
            $sumaTotal += $ascii;
            $sumasParciales[$i % 5] += $ascii;
        }

        $acumulado = 0;
        for ($i = 0; $i < 5; $i++) {
            $acumulado += intdiv($sumaTotal * $sumasParciales[$i], ((int) $digitos[$i]) + 1);
        }

        $base64 = $this->codificarBase64($acumulado);
        $finalHex = $this->allegedRc4($base64, $llaveDosificacion.$digitos);

        return implode('-', str_split($finalHex, 2));
    }

    private function agregarVerhoeff(string $valor, int $veces): string
    {
        for ($i = 0; $i < $veces; $i++) {
            $c = 0;
            $invertido = strrev($valor);
            $len = strlen($invertido);
            for ($j = 0; $j < $len; $j++) {
                $c = self::VERHOEFF_D[$c][self::VERHOEFF_P[($j + 1) % 8][(int) $invertido[$j]]];
            }
            $valor .= (string) self::VERHOEFF_INV[$c];
        }

        return $valor;
    }

    private function allegedRc4(string $mensaje, string $llave): string
    {
        $state = range(0, 255);
        $x = 0;
        $y = 0;
        $index1 = 0;
        $index2 = 0;
        $lenLlave = max(1, strlen($llave));

        for ($i = 0; $i < 256; $i++) {
            $index2 = (ord($llave[$index1]) + $state[$i] + $index2) % 256;
            [$state[$i], $state[$index2]] = [$state[$index2], $state[$i]];
            $index1 = ($index1 + 1) % $lenLlave;
        }

        $resultado = '';
        $lenMensaje = strlen($mensaje);
        for ($i = 0; $i < $lenMensaje; $i++) {
            $x = ($x + 1) % 256;
            $y = ($state[$x] + $y) % 256;
            [$state[$x], $state[$y]] = [$state[$y], $state[$x]];
            $n = ord($mensaje[$i]) ^ $state[($state[$x] + $state[$y]) % 256];
            $resultado .= strtoupper(str_pad(dechex($n), 2, '0', STR_PAD_LEFT));
        }

        return $resultado;
    }

    private function codificarBase64(int $numero): string
    {
        if ($numero === 0) {
            return '0';
        }

        $palabra = '';
        while ($numero > 0) {
            $resto = $numero % 64;
            $palabra = self::DICCIONARIO_BASE64[$resto].$palabra;
            $numero = intdiv($numero, 64);
        }

        return $palabra;
    }
}
