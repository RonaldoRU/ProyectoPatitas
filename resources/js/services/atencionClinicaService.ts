import {
    catalogos as clinicalCatalogsRoute,
    store as storeClinicalAttentionRoute,
} from '@/routes/api/atenciones-clinicas';

export type ClinicalPet = {
    id: number;
    nombre: string;
    especie: string;
    raza: string;
    estado_actual: string;
};

export type ClinicalArticle = {
    id: number;
    nombre: string;
    categoria: string;
    unidad_medida: string;
    stock_actual: number | string;
};

export type ClinicalCatalogs = {
    mascotas: ClinicalPet[];
    articulos: ClinicalArticle[];
};

export type ClinicalLineInput = {
    id_articulo: number;
    cantidad: string;
};

export type ClinicalAttentionPayload = {
    fecha_atencion: string;
    id_mascota: number;
    diagnostico: string;
    observacion: string;
    tipo_procedimiento: string;
    lineas: ClinicalLineInput[];
};

export type RegisteredClinicalAttention = {
    id: number;
    fecha_atencion: string;
    mascota: string;
    diagnostico: string;
    tipo_procedimiento: string;
    salida_inventario_id: number;
    articulos_actualizados: Array<{
        id: number;
        nombre: string;
        cantidad: number;
        stock_actual: string;
    }>;
};

type ApiErrorResponse = {
    message?: string;
    errors?: Record<string, string[]>;
};

export class ClinicalAttentionRequestError extends Error {
    constructor(message: string, public readonly status: number) {
        super(message);
        this.name = 'ClinicalAttentionRequestError';
    }
}

async function throwResponseError(response: Response): Promise<never> {
    let result: ApiErrorResponse = {};

    try {
        result = (await response.json()) as ApiErrorResponse;
    } catch {
        throw new ClinicalAttentionRequestError(
            `El servidor respondió con el código ${response.status}.`,
            response.status,
        );
    }

    const validationMessage = Object.values(result.errors ?? {})[0]?.[0];

    throw new ClinicalAttentionRequestError(
        result.message ?? validationMessage ?? 'No se pudo registrar la atención clínica.',
        response.status,
    );
}

function authHeaders(token: string): HeadersInit {
    return {
        Accept: 'application/json',
        Authorization: `Bearer ${token}`,
    };
}

const atencionClinicaService = {
    async catalogos(token: string): Promise<ClinicalCatalogs> {
        const response = await fetch(clinicalCatalogsRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            await throwResponseError(response);
        }

        return (await response.json()) as ClinicalCatalogs;
    },

    async store(token: string, payload: ClinicalAttentionPayload): Promise<RegisteredClinicalAttention> {
        const response = await fetch(storeClinicalAttentionRoute.url(), {
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

        const result = (await response.json()) as { atencion: RegisteredClinicalAttention };

        return result.atencion;
    },
};

export default atencionClinicaService;
