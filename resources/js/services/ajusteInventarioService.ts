import {
    index as inventoryAdjustmentsRoute,
    store as storeInventoryAdjustmentRoute,
} from '@/routes/api/ajustes-inventario';
import { authHeaders, readApiError } from '@/services/apiSupport';

export type InventoryAdjustment = {
    id: number;
    cantidad: number;
    saldo_disponible_anterior: number | string;
    saldo_disponible_nuevo: number | string;
    usuario_nombre: string;
    motivo: string;
    created_at: string;
    articulo: {
        id: number;
        nombre: string;
        unidad_medida: string;
    };
};

export type InventoryAdjustmentInput = {
    id_articulo: number;
    cantidad: number;
    motivo: string;
};

const ajusteInventarioService = {
    async index(token: string): Promise<InventoryAdjustment[]> {
        const response = await fetch(inventoryAdjustmentsRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as {
            ajustes: InventoryAdjustment[];
        };

        return result.ajustes;
    },

    async store(
        token: string,
        adjustment: InventoryAdjustmentInput,
    ): Promise<{ ajuste: InventoryAdjustment; stock_actual: number | string }> {
        const response = await fetch(storeInventoryAdjustmentRoute.url(), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(adjustment),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        return (await response.json()) as {
            ajuste: InventoryAdjustment;
            stock_actual: number | string;
        };
    },
};

export default ajusteInventarioService;
