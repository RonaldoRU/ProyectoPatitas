import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useMemo, useState } from 'react';
import type { FormEvent } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { index as inventoryPage } from '@/routes/articulos-inventario';
import { index as clinicalPage } from '@/routes/atenciones-clinicas';
import { index as auditPage } from '@/routes/bitacora';
import { index as entryPage } from '@/routes/entradas-insumos';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as suppliersPage } from '@/routes/proveedores';
import { index as stockoutPage } from '@/routes/salidas-inventario';
import { index as usersPage } from '@/routes/usuarios';
import ajusteInventarioService from '@/services/ajusteInventarioService';
import type { InventoryAdjustment } from '@/services/ajusteInventarioService';
import articuloInventarioService from '@/services/articuloInventarioService';
import type {
    InventoryArticle,
    InventoryArticleInput,
} from '@/services/articuloInventarioService';
import '../../css/dashboard.css';
import '../../css/users.css';
import '../../css/inventario.css';

type ModalMode = 'create' | 'edit' | 'merma' | null;

type MermaForm = {
    cantidad: string;
    motivo: string;
};

const initialForm: InventoryArticleInput = {
    nombre: '',
    categoria: '',
    unidad_medida: '',
    stock_minimo_alerta: '',
};

const initialMermaForm: MermaForm = {
    cantidad: '',
    motivo: '',
};

function stockNumber(value: number | string): number {
    return Number(value);
}

function formatStock(value: number | string): string {
    return stockNumber(value).toLocaleString('es-BO', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 2,
    });
}

export default function ArticulosInventario() {
    const [articles, setArticles] = useState<InventoryArticle[]>([]);
    const [adjustments, setAdjustments] = useState<InventoryAdjustment[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [modalMode, setModalMode] = useState<ModalMode>(null);
    const [selectedArticle, setSelectedArticle] =
        useState<InventoryArticle | null>(null);
    const [form, setForm] = useState<InventoryArticleInput>(initialForm);
    const [mermaForm, setMermaForm] = useState<MermaForm>(initialMermaForm);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    useEffect(() => {
        let active = true;
        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return () => {
                active = false;
            };
        }

        const accessToken = token;

        async function loadArticles() {
            try {
                const [articlesResult, adjustmentsResult] = await Promise.all([
                    articuloInventarioService.index(accessToken),
                    ajusteInventarioService.index(accessToken),
                ]);

                if (active) {
                    setArticles(articlesResult);
                    setAdjustments(adjustmentsResult);
                }
            } catch (cause) {
                if (
                    cause instanceof Error &&
                    cause.message === 'Unauthenticated.'
                ) {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(
                        cause instanceof Error
                            ? cause.message
                            : 'No se pudo cargar el catálogo de inventario.',
                    );
                }
            } finally {
                if (active) {
                    setLoading(false);
                }
            }
        }

        void loadArticles();

        return () => {
            active = false;
        };
    }, []);

    const filteredArticles = useMemo(() => {
        const query = search.trim().toLocaleLowerCase('es');

        if (!query) {
            return articles;
        }

        return articles.filter((article) =>
            [article.nombre, article.categoria, article.unidad_medida].some(
                (value) => value.toLocaleLowerCase('es').includes(query),
            ),
        );
    }, [articles, search]);

    const lowStockCount = articles.filter(
        (article) =>
            stockNumber(article.stock_actual) <=
            stockNumber(article.stock_minimo_alerta),
    ).length;

    function openCreateModal() {
        setError('');
        setForm(initialForm);
        setMermaForm(initialMermaForm);
        setSelectedArticle(null);
        setModalMode('create');
    }

    function openEditModal(article: InventoryArticle) {
        setError('');
        setForm({
            nombre: article.nombre,
            categoria: article.categoria,
            unidad_medida: article.unidad_medida,
            stock_minimo_alerta: String(article.stock_minimo_alerta),
        });
        setSelectedArticle(article);
        setModalMode('edit');
    }

    function openMermaModal(article: InventoryArticle) {
        setError('');
        setSuccess('');
        setMermaForm(initialMermaForm);
        setSelectedArticle(article);
        setModalMode('merma');
    }

    function closeModal() {
        if (submitting) {
            return;
        }

        setModalMode(null);
        setSelectedArticle(null);
        setForm(initialForm);
        setMermaForm(initialMermaForm);
        setError('');
    }

    async function submitArticle(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess('');

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        if (
            modalMode === null ||
            (modalMode === 'edit' && selectedArticle === null)
        ) {
            return;
        }

        setSubmitting(true);

        try {
            let savedArticle: InventoryArticle;

            if (modalMode === 'create') {
                savedArticle = await articuloInventarioService.store(
                    token,
                    form,
                );
            } else if (selectedArticle !== null) {
                savedArticle = await articuloInventarioService.update(
                    token,
                    selectedArticle.id,
                    form,
                );
            } else {
                return;
            }

            setArticles((current) => {
                const next =
                    modalMode === 'create'
                        ? [...current, savedArticle]
                        : current.map((article) =>
                              article.id === savedArticle.id
                                  ? savedArticle
                                  : article,
                          );

                return next.sort(
                    (first, second) =>
                        first.categoria.localeCompare(second.categoria, 'es') ||
                        first.nombre.localeCompare(second.nombre, 'es'),
                );
            });
            setSuccess(
                modalMode === 'create'
                    ? `Se registró ${savedArticle.nombre} en el catálogo.`
                    : `Se actualizaron los datos de ${savedArticle.nombre}.`,
            );
            setModalMode(null);
            setSelectedArticle(null);
            setForm(initialForm);
        } catch (cause) {
            if (
                cause instanceof Error &&
                cause.message === 'Unauthenticated.'
            ) {
                localStorage.removeItem('token');
                router.visit(loginPage.url());

                return;
            }

            setError(
                cause instanceof Error
                    ? cause.message
                    : 'No se pudo guardar el artículo de inventario.',
            );
        } finally {
            setSubmitting(false);
        }
    }

    async function submitMerma(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess('');

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        if (selectedArticle === null || modalMode !== 'merma') {
            return;
        }

        setSubmitting(true);

        try {
            const result = await ajusteInventarioService.store(token, {
                id_articulo: selectedArticle.id,
                cantidad: Number(mermaForm.cantidad),
                motivo: mermaForm.motivo,
            });

            setArticles((current) =>
                current.map((article) =>
                    article.id === selectedArticle.id
                        ? { ...article, stock_actual: result.stock_actual }
                        : article,
                ),
            );
            setAdjustments((current) =>
                [result.ajuste, ...current].slice(0, 50),
            );
            setSuccess(
                `Se registró la merma de ${mermaForm.cantidad} ${selectedArticle.unidad_medida} de ${selectedArticle.nombre}.`,
            );
            setModalMode(null);
            setSelectedArticle(null);
            setMermaForm(initialMermaForm);
        } catch (cause) {
            if (
                cause instanceof Error &&
                cause.message === 'Unauthenticated.'
            ) {
                localStorage.removeItem('token');
                router.visit(loginPage.url());

                return;
            }

            setError(
                cause instanceof Error
                    ? cause.message
                    : 'No se pudo registrar la merma de inventario.',
            );
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <>
            <Head title="Catálogo de inventario" />
            <div className="dashboard-app">
                <aside className="dashboard-sidebar">
                    <Link
                        className="dashboard-brand"
                        href={dashboardPage.url()}
                    >
                        <span className="dashboard-brand__badge">LA</span>
                        <span className="dashboard-brand__name">
                            Los Angelitos
                        </span>
                    </Link>

                    <nav
                        className="dashboard-nav"
                        aria-label="Navegación principal"
                    >
                        <Link
                            className="dashboard-nav__item"
                            href={dashboardPage.url()}
                        >
                            <span aria-hidden="true">⌂</span>
                            <span>Inicio</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={`${dashboardPage.url()}#ingresos`}
                        >
                            <span aria-hidden="true">✿</span>
                            <span>Animales</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={`${dashboardPage.url()}#adopciones`}
                        >
                            <span aria-hidden="true">♡</span>
                            <span>Adopciones</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={applicantsPage.url()}
                        >
                            <span aria-hidden="true">♧</span>
                            <span>Postulantes</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item dashboard-nav__item--active"
                            href={inventoryPage.url()}
                            aria-current="page"
                        >
                            <span aria-hidden="true">◇</span>
                            <span>Inventario</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={entryPage.url()}
                        >
                            <span aria-hidden="true">▤</span>
                            <span>Entradas</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={suppliersPage.url()}
                        >
                            <span aria-hidden="true">▧</span>
                            <span>Proveedores</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={stockoutPage.url()}
                        >
                            <span aria-hidden="true">↗</span>
                            <span>Salidas</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={clinicalPage.url()}
                        >
                            <span aria-hidden="true">✚</span>
                            <span>Atención clínica</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={usersPage.url()}
                        >
                            <span aria-hidden="true">▣</span>
                            <span>Usuarios</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item"
                            href={auditPage.url()}
                        >
                            <span aria-hidden="true">◷</span>
                            <span>Bitácora</span>
                        </Link>
                    </nav>

                    <div className="dashboard-sidebar__foot">
                        Refugio Los Angelitos de Edgar
                        <span>Santa Cruz de la Sierra</span>
                    </div>
                </aside>

                <main className="dashboard-main inventory-main">
                    <header className="dashboard-topbar">
                        <h1>Inventario</h1>
                        <div className="dashboard-topbar__actions">
                            <span className="users-topbar-label">
                                Administración de artículos
                            </span>
                        </div>
                    </header>

                    <div className="dashboard-content users-content inventory-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">
                                    Administración del refugio
                                </p>
                                <h2>Catálogo de artículos</h2>
                                <p>
                                    Registra y actualiza los insumos, alimentos
                                    y medicamentos del refugio.
                                </p>
                            </div>
                            <button
                                className="users-add-button"
                                type="button"
                                onClick={openCreateModal}
                            >
                                <span aria-hidden="true">+</span>
                                Nuevo artículo
                            </button>
                        </section>

                        {success && (
                            <p
                                className="users-feedback users-feedback--success"
                                role="status"
                            >
                                {success}
                            </p>
                        )}
                        {error && modalMode === null && (
                            <p
                                className="users-feedback users-feedback--error"
                                role="alert"
                            >
                                {error}
                            </p>
                        )}

                        <section
                            className="inventory-summary"
                            aria-label="Resumen de inventario"
                        >
                            <article className="inventory-summary__card">
                                <span>Artículos en catálogo</span>
                                <strong>{articles.length}</strong>
                            </article>
                            <article className="inventory-summary__card inventory-summary__card--alert">
                                <span>En nivel de alerta</span>
                                <strong>{lowStockCount}</strong>
                            </article>
                        </section>

                        <section
                            className="inventory-toolbar"
                            aria-label="Búsqueda en inventario"
                        >
                            <label className="inventory-search">
                                <span>Buscar artículo</span>
                                <input
                                    type="search"
                                    value={search}
                                    onChange={(event) =>
                                        setSearch(event.target.value)
                                    }
                                    placeholder="Nombre, categoría o unidad de medida"
                                />
                            </label>
                        </section>

                        <section
                            className="users-table-wrap"
                            aria-label="Catálogo de artículos de inventario"
                        >
                            <table className="users-table inventory-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Artículo</th>
                                        <th scope="col">Categoría</th>
                                        <th scope="col">Unidad de medida</th>
                                        <th scope="col">Stock actual</th>
                                        <th scope="col">Stock mínimo</th>
                                        <th scope="col">Estado</th>
                                        <th scope="col">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr>
                                            <td
                                                className="users-table-state"
                                                colSpan={7}
                                            >
                                                Cargando catálogo…
                                            </td>
                                        </tr>
                                    ) : error && articles.length === 0 ? (
                                        <tr>
                                            <td
                                                className="users-table-state users-table-state--error"
                                                colSpan={7}
                                            >
                                                {error}
                                            </td>
                                        </tr>
                                    ) : filteredArticles.length === 0 ? (
                                        <tr>
                                            <td
                                                className="users-table-state"
                                                colSpan={7}
                                            >
                                                {search
                                                    ? 'No hay artículos que coincidan con la búsqueda.'
                                                    : 'Todavía no hay artículos registrados.'}
                                            </td>
                                        </tr>
                                    ) : (
                                        filteredArticles.map((article) => {
                                            const isLowStock =
                                                stockNumber(
                                                    article.stock_actual,
                                                ) <=
                                                stockNumber(
                                                    article.stock_minimo_alerta,
                                                );

                                            return (
                                                <tr key={article.id}>
                                                    <td className="users-table-name">
                                                        {article.nombre}
                                                    </td>
                                                    <td>{article.categoria}</td>
                                                    <td>
                                                        {article.unidad_medida}
                                                    </td>
                                                    <td>
                                                        {formatStock(
                                                            article.stock_actual,
                                                        )}
                                                    </td>
                                                    <td>
                                                        {stockNumber(
                                                            article.stock_minimo_alerta,
                                                        ).toLocaleString(
                                                            'es-BO',
                                                        )}
                                                    </td>
                                                    <td>
                                                        <span
                                                            className={`inventory-status ${isLowStock ? 'inventory-status--low' : 'inventory-status--ok'}`}
                                                        >
                                                            {isLowStock
                                                                ? 'Reponer'
                                                                : 'Disponible'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div className="users-row-actions">
                                                            <button
                                                                className="users-action-button"
                                                                type="button"
                                                                disabled={
                                                                    submitting
                                                                }
                                                                onClick={() =>
                                                                    openEditModal(
                                                                        article,
                                                                    )
                                                                }
                                                                aria-label={`Editar ${article.nombre}`}
                                                            >
                                                                Editar
                                                            </button>
                                                            <button
                                                                className="users-action-button"
                                                                type="button"
                                                                disabled={
                                                                    submitting ||
                                                                    stockNumber(
                                                                        article.stock_actual,
                                                                    ) < 1
                                                                }
                                                                onClick={() =>
                                                                    openMermaModal(
                                                                        article,
                                                                    )
                                                                }
                                                                aria-label={`Registrar merma de ${article.nombre}`}
                                                            >
                                                                Merma
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            );
                                        })
                                    )}
                                </tbody>
                            </table>
                        </section>

                        <section
                            className="users-table-wrap"
                            aria-label="Historial de mermas de inventario"
                        >
                            <div className="inventory-history-heading">
                                <div>
                                    <h2>Mermas recientes</h2>
                                    <p>
                                        Registro de los últimos 50 movimientos;
                                        el detalle completo también queda en la
                                        bitácora.
                                    </p>
                                </div>
                            </div>
                            <table className="users-table inventory-history-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Fecha</th>
                                        <th scope="col">Artículo</th>
                                        <th scope="col">Cantidad</th>
                                        <th scope="col">Saldo anterior</th>
                                        <th scope="col">Saldo nuevo</th>
                                        <th scope="col">Responsable</th>
                                        <th scope="col">Motivo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr>
                                            <td
                                                className="users-table-state"
                                                colSpan={7}
                                            >
                                                Cargando historial…
                                            </td>
                                        </tr>
                                    ) : adjustments.length === 0 ? (
                                        <tr>
                                            <td
                                                className="users-table-state"
                                                colSpan={7}
                                            >
                                                Todavía no hay mermas
                                                registradas.
                                            </td>
                                        </tr>
                                    ) : (
                                        adjustments.map((adjustment) => (
                                            <tr key={adjustment.id}>
                                                <td>
                                                    {new Date(
                                                        adjustment.created_at,
                                                    ).toLocaleString('es-BO')}
                                                </td>
                                                <td className="users-table-name">
                                                    {adjustment.articulo.nombre}
                                                </td>
                                                <td>
                                                    {adjustment.cantidad.toLocaleString(
                                                        'es-BO',
                                                    )}{' '}
                                                    {
                                                        adjustment.articulo
                                                            .unidad_medida
                                                    }
                                                </td>
                                                <td>
                                                    {formatStock(
                                                        adjustment.saldo_disponible_anterior,
                                                    )}
                                                </td>
                                                <td>
                                                    {formatStock(
                                                        adjustment.saldo_disponible_nuevo,
                                                    )}
                                                </td>
                                                <td>
                                                    {adjustment.usuario_nombre}
                                                </td>
                                                <td>{adjustment.motivo}</td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </section>
                    </div>
                </main>
            </div>

            {modalMode !== null && (
                <div
                    className="user-modal-backdrop"
                    onMouseDown={(event) => {
                        if (event.target === event.currentTarget) {
                            closeModal();
                        }
                    }}
                >
                    <section
                        className="user-modal inventory-modal"
                        role="dialog"
                        aria-modal="true"
                        aria-labelledby="inventory-modal-title"
                    >
                        <header className="user-modal__header">
                            <div>
                                <h2 id="inventory-modal-title">
                                    {modalMode === 'create'
                                        ? 'Nuevo artículo'
                                        : modalMode === 'edit'
                                          ? 'Editar artículo'
                                          : 'Registrar merma'}
                                </h2>
                                <p>
                                    {modalMode === 'merma'
                                        ? 'Registra la cantidad retirada y el motivo. El movimiento no se puede editar ni eliminar.'
                                        : 'Completa los datos del catálogo. El stock actual se actualiza desde los movimientos.'}
                                </p>
                            </div>
                            <button
                                className="user-modal__close"
                                type="button"
                                onClick={closeModal}
                                aria-label="Cerrar formulario"
                            >
                                ×
                            </button>
                        </header>

                        {modalMode === 'merma' ? (
                            <form className="user-form" onSubmit={submitMerma}>
                                <label className="user-form__field user-form__field--full">
                                    <span>Artículo</span>
                                    <input
                                        readOnly
                                        value={selectedArticle?.nombre ?? ''}
                                    />
                                </label>
                                <p className="inventory-merma-stock">
                                    Stock disponible:{' '}
                                    <strong>
                                        {formatStock(
                                            selectedArticle?.stock_actual ?? 0,
                                        )}
                                    </strong>{' '}
                                    {selectedArticle?.unidad_medida}
                                </p>
                                <label className="user-form__field">
                                    <span>
                                        Cantidad de merma (unidades a retirar)
                                    </span>
                                    <input
                                        required
                                        type="number"
                                        min="1"
                                        max={Math.floor(
                                            stockNumber(
                                                selectedArticle?.stock_actual ??
                                                    0,
                                            ),
                                        )}
                                        step="1"
                                        value={mermaForm.cantidad}
                                        onChange={(event) =>
                                            setMermaForm((current) => ({
                                                ...current,
                                                cantidad: event.target.value,
                                            }))
                                        }
                                    />
                                </label>
                                <label className="user-form__field user-form__field--full">
                                    <span>Motivo de la merma</span>
                                    <textarea
                                        required
                                        maxLength={1000}
                                        value={mermaForm.motivo}
                                        onChange={(event) =>
                                            setMermaForm((current) => ({
                                                ...current,
                                                motivo: event.target.value,
                                            }))
                                        }
                                        placeholder="Describe la causa del ajuste"
                                    />
                                </label>
                                {error && (
                                    <p
                                        className="users-feedback users-feedback--error user-form__error"
                                        role="alert"
                                    >
                                        {error}
                                    </p>
                                )}
                                <div className="user-form__actions">
                                    <button
                                        className="user-cancel-button"
                                        type="button"
                                        onClick={closeModal}
                                        disabled={submitting}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        className="btn-primary user-submit-button"
                                        type="submit"
                                        disabled={submitting}
                                    >
                                        {submitting
                                            ? 'Registrando…'
                                            : 'Registrar merma'}
                                    </button>
                                </div>
                            </form>
                        ) : (
                            <form
                                className="user-form"
                                onSubmit={submitArticle}
                            >
                                <label className="user-form__field user-form__field--full">
                                    <span>Nombre del artículo</span>
                                    <input
                                        required
                                        maxLength={150}
                                        value={form.nombre}
                                        onChange={(event) =>
                                            setForm((current) => ({
                                                ...current,
                                                nombre: event.target.value,
                                            }))
                                        }
                                        placeholder="Ej. Alimento para perros adultos"
                                    />
                                </label>
                                <label className="user-form__field">
                                    <span>Categoría</span>
                                    <input
                                        required
                                        maxLength={50}
                                        value={form.categoria}
                                        onChange={(event) =>
                                            setForm((current) => ({
                                                ...current,
                                                categoria: event.target.value,
                                            }))
                                        }
                                        placeholder="Ej. Alimento"
                                    />
                                </label>
                                <label className="user-form__field">
                                    <span>Unidad de medida</span>
                                    <input
                                        required
                                        maxLength={20}
                                        value={form.unidad_medida}
                                        onChange={(event) =>
                                            setForm((current) => ({
                                                ...current,
                                                unidad_medida:
                                                    event.target.value,
                                            }))
                                        }
                                        placeholder="Ej. Bolsa"
                                    />
                                </label>
                                <label className="user-form__field user-form__field--full">
                                    <span>Stock mínimo de alerta</span>
                                    <input
                                        required
                                        type="number"
                                        min="0"
                                        max="99999999.99"
                                        step="0.01"
                                        value={form.stock_minimo_alerta}
                                        onChange={(event) =>
                                            setForm((current) => ({
                                                ...current,
                                                stock_minimo_alerta:
                                                    event.target.value,
                                            }))
                                        }
                                    />
                                </label>
                                {error && (
                                    <p
                                        className="users-feedback users-feedback--error user-form__error"
                                        role="alert"
                                    >
                                        {error}
                                    </p>
                                )}
                                <div className="user-form__actions">
                                    <button
                                        className="user-cancel-button"
                                        type="button"
                                        onClick={closeModal}
                                        disabled={submitting}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        className="btn-primary user-submit-button"
                                        type="submit"
                                        disabled={submitting}
                                    >
                                        {submitting
                                            ? 'Guardando…'
                                            : modalMode === 'create'
                                              ? 'Registrar artículo'
                                              : 'Guardar cambios'}
                                    </button>
                                </div>
                            </form>
                        )}
                    </section>
                </div>
            )}
        </>
    );
}
