import {
    catalogos as stockoutCatalogsRoute,
    store as storeStockoutRoute,
} from '@/routes/api/salidas-inventario';

export type StockoutArticle = {
    id: number;
    nombre: string;
    categoria: string;
    unidad_medida: string;
    stock_actual: number | string;
};

export type StockoutCatalogs = {
    articulos: StockoutArticle[];
};

export type StockoutLineInput = {
    id_articulo: number;
    cantidad: string;
};

export type StockoutPayload = {
    motivo: string;
    destino: string;
    fecha_salida: string;
    lineas: StockoutLineInput[];
};

export type RegisteredStockout = {
    id: number;
    motivo: string;
    destino: string;
    fecha_salida: string;
    articulos: string[];
    articulos_actualizados: Array<{
        id: number;
        stock_actual: string;
    }>;
};

type ApiErrorResponse = {
    message?: string;
    errors?: Record<string, string[]>;
};

export class StockoutRequestError extends Error {
    constructor(message: string, public readonly status: number) {
        super(message);
        this.name = 'StockoutRequestError';
    }
}

async function throwResponseError(response: Response): Promise<never> {
    let result: ApiErrorResponse = {};

    try {
        result = (await response.json()) as ApiErrorResponse;
    } catch {
        throw new StockoutRequestError(
            `El servidor respondió con el código ${response.status}.`,
            response.status,
        );
    }

    const validationMessage = Object.values(result.errors ?? {})[0]?.[0];

    throw new StockoutRequestError(
        result.message ?? validationMessage ?? 'No se pudo completar la salida.',
        response.status,
    );
}

function authHeaders(token: string): HeadersInit {
    return {
        Accept: 'application/json',
        Authorization: `Bearer ${token}`,
    };
}

const salidaInventarioService = {
    async catalogos(token: string): Promise<StockoutCatalogs> {
        const response = await fetch(stockoutCatalogsRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            await throwResponseError(response);
        }

        return (await response.json()) as StockoutCatalogs;
    },

    async store(token: string, payload: StockoutPayload): Promise<RegisteredStockout> {
        const response = await fetch(storeStockoutRoute.url(), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(payload),
        });

        if (!response.ok) {
            await throwResponseError(response);
        }

        const result = (await response.json()) as { salida: RegisteredStockout };

        return result.salida;
    },
};

export default salidaInventarioService;
