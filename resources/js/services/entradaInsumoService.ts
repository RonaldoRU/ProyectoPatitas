import {
    catalogos as entryCatalogsRoute,
    store as storeEntryRoute,
} from '@/routes/api/entradas-insumos';

export type EntryType = 'compra' | 'donacion';

export type EntryArticle = {
    id: number;
    nombre: string;
    categoria: string;
    unidad_medida: string;
    stock_actual: number | string;
    requiere_vencimiento: boolean;
};

export type EntrySupplier = {
    id: number;
    nombre_empresa: string;
    tipo_insumo_provisto: string | null;
};

export type EntryDonor = {
    id: number;
    nombre: string;
    tipo_persona: string;
};

export type EntryCatalogs = {
    articulos: EntryArticle[];
    proveedores: EntrySupplier[];
    donantes: EntryDonor[];
};

export type EntryLineInput = {
    id_articulo: number;
    cantidad: string;
    fecha_vencimiento: string | null;
    costo_unitario?: string;
};

export type EntryPayload = {
    tipo: EntryType;
    fecha: string;
    numero_documento: string | null;
    lineas: EntryLineInput[];
    id_proveedor?: number;
    id_donante?: number;
    donante?: {
        nombre: string;
        telefono: string;
        tipo_persona: string;
    };
};

export type RegisteredEntry = {
    id: number;
    tipo: EntryType;
    fecha: string;
    numero_documento: string | null;
    monto_total: string | null;
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

export class EntryRequestError extends Error {
    constructor(
        message: string,
        public readonly status: number,
    ) {
        super(message);
        this.name = 'EntryRequestError';
    }
}

async function throwResponseError(response: Response): Promise<never> {
    let result: ApiErrorResponse = {};

    try {
        result = (await response.json()) as ApiErrorResponse;
    } catch {
        throw new EntryRequestError(
            `El servidor respondió con el código ${response.status}.`,
            response.status,
        );
    }

    const validationMessage = Object.values(result.errors ?? {})[0]?.[0];

    throw new EntryRequestError(
        result.message ??
            validationMessage ??
            'No se pudo completar el registro.',
        response.status,
    );
}

function authHeaders(token: string): HeadersInit {
    return {
        Accept: 'application/json',
        Authorization: 'Bearer ' + token,
    };
}

const entradaInsumoService = {
    async catalogos(token: string): Promise<EntryCatalogs> {
        const response = await fetch(entryCatalogsRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            await throwResponseError(response);
        }

        return (await response.json()) as EntryCatalogs;
    },

    async store(token: string, entry: EntryPayload): Promise<RegisteredEntry> {
        const response = await fetch(storeEntryRoute.url(), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(entry),
        });

        if (!response.ok) {
            await throwResponseError(response);
        }

        const result = (await response.json()) as { entrada: RegisteredEntry };

        return result.entrada;
    },
};

export default entradaInsumoService;
