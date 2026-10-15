import {
    index as suppliersIndexRoute,
    status as supplierStatusRoute,
    store as storeSupplierRoute,
    update as updateSupplierRoute,
} from '@/routes/api/proveedores';
import { authHeaders, readApiError } from '@/services/apiSupport';

export type Supplier = {
    id: number;
    nombre_empresa: string;
    nombre_contacto: string;
    telefono: string;
    direccion: string;
    identificacion: string | null;
    tipo_insumo_provisto: string | null;
    activo: boolean;
    created_at: string;
    updated_at: string;
};

export type SupplierInput = Pick<
    Supplier,
    'nombre_empresa' | 'nombre_contacto' | 'telefono' | 'direccion'
> & {
    identificacion: string | null;
    tipo_insumo_provisto: string;
};

const proveedorService = {
    async index(token: string): Promise<Supplier[]> {
        const response = await fetch(suppliersIndexRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as { proveedores: Supplier[] };

        return result.proveedores;
    },

    async store(token: string, supplier: SupplierInput): Promise<Supplier> {
        const response = await fetch(storeSupplierRoute.url(), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(supplier),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as { proveedor: Supplier };

        return result.proveedor;
    },

    async update(
        token: string,
        supplierId: number,
        supplier: SupplierInput,
    ): Promise<Supplier> {
        const response = await fetch(updateSupplierRoute.url(supplierId), {
            method: 'PATCH',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(supplier),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as { proveedor: Supplier };

        return result.proveedor;
    },

    async setActive(
        token: string,
        supplierId: number,
        active: boolean,
    ): Promise<Supplier> {
        const response = await fetch(supplierStatusRoute.url(supplierId), {
            method: 'PATCH',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ activo: active }),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as { proveedor: Supplier };

        return result.proveedor;
    },
};

export default proveedorService;
