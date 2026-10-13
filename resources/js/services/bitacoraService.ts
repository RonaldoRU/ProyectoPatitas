import { index as indexAuditRoute } from '@/routes/api/bitacora';

export type AuditFilters = {
    usuario: string;
    accion: string;
    modulo: string;
    buscar: string;
    desde: string;
    hasta: string;
};

export type AuditEntry = {
    id: number;
    id_usuario: number | null;
    usuario: string;
    tipo_accion: string;
    modulo: string;
    descripcion: string | null;
    entidad_tipo: string | null;
    entidad_id: string | null;
    fecha_hora: string;
    ip: string | null;
    http_method: string | null;
    ruta: string | null;
    resultado: 'exitosa' | 'fallida';
    contexto: Record<string, string | number | boolean | string[] | null> | null;
};

export type AuditPage = {
    data: AuditEntry[];
    current_page: number;
    last_page: number;
    total: number;
};

type ApiError = {
    message?: string;
    errors?: Record<string, string[]>;
};

async function readError(response: Response): Promise<Error> {
    const result = (await response.json()) as ApiError;
    const fieldMessage = Object.values(result.errors ?? {})[0]?.[0];

    return new Error(fieldMessage ?? result.message ?? 'No se pudo consultar la bitácora.');
}

const bitacoraService = {
    async index(
        token: string,
        filters: AuditFilters,
        page: number,
        signal: AbortSignal,
    ): Promise<AuditPage> {
        const response = await fetch(indexAuditRoute.url({
            query: {
                usuario: filters.usuario,
                accion: filters.accion,
                modulo: filters.modulo,
                buscar: filters.buscar,
                desde: filters.desde,
                hasta: filters.hasta,
                page,
                per_page: 25,
            },
        }), {
            headers: {
                Accept: 'application/json',
                Authorization: `Bearer ${token}`,
            },
            signal,
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as { bitacoras: AuditPage };

        return result.bitacoras;
    },
};

export default bitacoraService;
