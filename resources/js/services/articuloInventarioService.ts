import {
    index as indexInventoryRoute,
    store as storeInventoryRoute,
    update as updateInventoryRoute,
} from '@/routes/api/articulos-inventario';
import { authHeaders, readApiError } from '@/services/apiSupport';

export type InventoryArticle = {
    id: number;
    nombre: string;
    categoria: string;
    unidad_medida: string;
    stock_actual: number | string;
    stock_minimo_alerta: number | string;
    created_at: string | null;
    updated_at: string | null;
};

export type InventoryArticleInput = Pick<
    InventoryArticle,
    'nombre' | 'categoria' | 'unidad_medida' | 'stock_minimo_alerta'
>;

const articuloInventarioService = {
    async index(token: string): Promise<InventoryArticle[]> {
        const response = await fetch(indexInventoryRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as {
            articulos: InventoryArticle[];
        };

        return result.articulos;
    },

    async store(
        token: string,
        article: InventoryArticleInput,
    ): Promise<InventoryArticle> {
        const response = await fetch(storeInventoryRoute.url(), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(article),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as {
            articulo: InventoryArticle;
        };

        return result.articulo;
    },

    async update(
        token: string,
        articleId: number,
        article: InventoryArticleInput,
    ): Promise<InventoryArticle> {
        const response = await fetch(updateInventoryRoute.url(articleId), {
            method: 'PATCH',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(article),
        });

        if (!response.ok) {
            throw await readApiError(response);
        }

        const result = (await response.json()) as {
            articulo: InventoryArticle;
        };

        return result.articulo;
    },
};

export default articuloInventarioService;
