/**
 * Vista de Catálogo de Artículos de Inventario (P02 - CU11 & CU14):
 * - Visualización estructurada y separada por categorías para evitar listados largos.
 * - Tarjetas interactivas por categoría, vista agrupada en bloques por categoría con paginación compacta
 *   y pestaña independiente para el historial de mermas.
 */
import { Head, router } from '@inertiajs/react';
import { useEffect, useMemo, useState } from 'react';
import type { FormEvent } from 'react';
import { login as loginPage } from '@/routes';
import ajusteInventarioService from '@/services/ajusteInventarioService';
import type { InventoryAdjustment } from '@/services/ajusteInventarioService';
import articuloInventarioService from '@/services/articuloInventarioService';
import type {
    InventoryArticle,
    InventoryArticleInput,
} from '@/services/articuloInventarioService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';
import '../../../css/users.css';
import '../../../css/inventario.css';

type ModalMode = 'create' | 'edit' | 'merma' | null;

type MermaForm = {
    cantidad: string;
    motivo: string;
};

const CATEGORIAS_SUGERIDAS = [
    'Alimento',
    'Medicamento',
    'Vacuna',
    'Limpieza',
    'Accesorio',
    'Insumos Médicos',
];

const initialForm: InventoryArticleInput = {
    nombre: '',
    categoria: 'Alimento',
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

function getCategoryMeta(categoria: string): {
    color: string;
    bg: string;
    border: string;
    descripcion: string;
    icono: React.ReactNode;
} {
    const norm = (categoria || '').toLowerCase();
    if (norm.includes('aliment') || norm.includes('comida') || norm.includes('nutri')) {
        return {
            color: '#12354a',
            bg: '#ffffff',
            border: '#dde1e4',
            descripcion: 'Raciones secas, húmedas, suplementos y nutrición animal',
            icono: (
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#165b4c" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M18 8h1a4 4 0 0 1 0 8h-1" />
                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z" />
                    <line x1="6" y1="1" x2="6" y2="4" />
                    <line x1="10" y1="1" x2="10" y2="4" />
                    <line x1="14" y1="1" x2="14" y2="4" />
                </svg>
            ),
        };
    }
    if (norm.includes('medic') || norm.includes('farmac') || norm.includes('insumo')) {
        return {
            color: '#12354a',
            bg: '#ffffff',
            border: '#dde1e4',
            descripcion: 'Antibióticos, analgésicos, antiparasitarios y material clínico',
            icono: (
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#12354a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z" />
                    <path d="m8.5 8.5 7 7" />
                </svg>
            ),
        };
    }
    if (norm.includes('vacun') || norm.includes('biolog')) {
        return {
            color: '#12354a',
            bg: '#ffffff',
            border: '#dde1e4',
            descripcion: 'Biológicos, inmunización antirrábica, séxtuple y triple felina',
            icono: (
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#165b4c" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="m18 2 4 4" />
                    <path d="m17 7 3-3" />
                    <path d="M19 9 8.7 19.3c-1 1-2.5 1-3.4 0l-.6-.6c-1-1-1-2.5 0-3.4L15 5" />
                    <path d="m9 11 4 4" />
                    <path d="m5 19-3 3" />
                    <path d="m14 4 6 6" />
                </svg>
            ),
        };
    }
    if (norm.includes('limpiez') || norm.includes('higien') || norm.includes('desinfec')) {
        return {
            color: '#12354a',
            bg: '#ffffff',
            border: '#dde1e4',
            descripcion: 'Desinfectantes, detergentes, bioseguridad y sanitización de caniles',
            icono: (
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#12354a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M3 22v-8a2 2 0 0 1 2-2h2.5" />
                    <path d="M12 2v4" />
                    <path d="m6.8 6.8-2.8-2.8" />
                    <path d="m17.2 6.8 2.8-2.8" />
                    <circle cx="12" cy="12" r="4" />
                </svg>
            ),
        };
    }
    return {
        color: '#12354a',
        bg: '#ffffff',
        border: '#dde1e4',
        descripcion: 'Collares, correas, camas, transportadoras y accesorios de refugio',
        icono: (
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#165b4c" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
            </svg>
        ),
    };
}

export default function ArticulosInventario() {
    const [articles, setArticles] = useState<InventoryArticle[]>([]);
    const [adjustments, setAdjustments] = useState<InventoryAdjustment[]>([]);
    const [search, setSearch] = useState('');
    const [categoriaActiva, setCategoriaActiva] = useState<string>('TODAS');
    const [vistaSeccion, setVistaSeccion] = useState<'catalogo' | 'mermas'>('catalogo');
    const [categoriasExpandidas, setCategoriasExpandidas] = useState<Record<string, boolean>>({});
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [modalMode, setModalMode] = useState<ModalMode>(null);
    const [selectedArticle, setSelectedArticle] =
        useState<InventoryArticle | null>(null);
    const [form, setForm] = useState<InventoryArticleInput>(initialForm);
    const [mermaForm, setMermaForm] = useState<MermaForm>(initialMermaForm);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');
    const [criticalAlert, setCriticalAlert] = useState('');

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

    // Búsqueda por texto
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

    // Agrupación de artículos por categoría
    const gruposPorCategoria = useMemo(() => {
        const map = new Map<string, InventoryArticle[]>();
        filteredArticles.forEach((article) => {
            const cat = (article.categoria || 'General').trim();
            if (!map.has(cat)) {
                map.set(cat, []);
            }
            map.get(cat)!.push(article);
        });

        return Array.from(map.entries())
            .map(([categoria, items]) => ({
                categoria,
                items,
                alertas: items.filter(
                    (a) => stockNumber(a.stock_actual) <= stockNumber(a.stock_minimo_alerta),
                ).length,
            }))
            .sort((a, b) => a.categoria.localeCompare(b.categoria, 'es'));
    }, [filteredArticles]);

    // Resumen de todas las categorías (sin filtro de búsqueda para las tarjetas superiores)
    const resumenCategoriasTotal = useMemo(() => {
        const map = new Map<string, { total: number; alertas: number }>();
        articles.forEach((article) => {
            const cat = (article.categoria || 'General').trim();
            const current = map.get(cat) ?? { total: 0, alertas: 0 };
            current.total += 1;
            if (stockNumber(article.stock_actual) <= stockNumber(article.stock_minimo_alerta)) {
                current.alertas += 1;
            }
            map.set(cat, current);
        });
        return Array.from(map.entries())
            .map(([categoria, stats]) => ({ categoria, ...stats }))
            .sort((a, b) => a.categoria.localeCompare(b.categoria, 'es'));
    }, [articles]);

    // Grupos visibles según la categoría seleccionada
    const gruposVisibles = useMemo(() => {
        if (categoriaActiva === 'TODAS') {
            return gruposPorCategoria;
        }
        return gruposPorCategoria.filter((g) => g.categoria === categoriaActiva);
    }, [gruposPorCategoria, categoriaActiva]);

    const lowStockCount = articles.filter(
        (article) =>
            stockNumber(article.stock_actual) <=
            stockNumber(article.stock_minimo_alerta),
    ).length;

    function toggleExpandirCategoria(cat: string) {
        setCategoriasExpandidas((prev) => ({
            ...prev,
            [cat]: !prev[cat],
        }));
    }

    function openCreateModal(categoriaPreseleccionada?: string) {
        setError('');
        setForm({
            ...initialForm,
            categoria:
                categoriaPreseleccionada ||
                (categoriaActiva !== 'TODAS' ? categoriaActiva : 'Alimento'),
        });
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
                    ? `Se registró ${savedArticle.nombre} en la categoría ${savedArticle.categoria}.`
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
            <Head title="Catálogo de inventario - Los Angelitos" />
            <div className="dashboard-app">
                <main className="dashboard-main inventory-main">
                    <DashboardTopNav title="Catálogo y Control de Stock" />

                    <div className="dashboard-content users-content inventory-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">
                                    Administración del refugio
                                </p>
                                <h2>Catálogo de artículos por categoría</h2>
                                <p>
                                    Visualiza los insumos organizados por categoría para un control ágil de existencias, alertas y mermas.
                                </p>
                            </div>
                            <button
                                className="users-add-button"
                                type="button"
                                onClick={() => openCreateModal()}
                            >
                                <span aria-hidden="true">+</span>
                                Nuevo artículo
                            </button>
                        </section>

                        {criticalAlert && (
                            <div
                                style={{
                                    backgroundColor: '#fef2f2',
                                    border: '1px solid #f87171',
                                    borderRadius: '8px',
                                    padding: '16px',
                                    marginBottom: '16px',
                                    color: '#991b1b',
                                    display: 'flex',
                                    alignItems: 'center',
                                    justifyContent: 'space-between',
                                    gap: '12px',
                                }}
                                role="alert"
                            >
                                <div>
                                    <strong style={{ display: 'block', fontSize: '15px', marginBottom: '4px' }}>
                                        Alerta de Inventario Crítico por Reducción de Stock
                                    </strong>
                                    <p style={{ margin: 0, fontSize: '13px' }}>{criticalAlert}</p>
                                </div>
                                <button
                                    type="button"
                                    onClick={() => setCriticalAlert('')}
                                    style={{
                                        background: 'transparent',
                                        border: '1px solid #f87171',
                                        borderRadius: '4px',
                                        padding: '4px 10px',
                                        color: '#991b1b',
                                        cursor: 'pointer',
                                        fontSize: '12px',
                                        fontWeight: 600,
                                    }}
                                >
                                    Cerrar Alerta
                                </button>
                            </div>
                        )}

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

                        {/* TARJETAS DE NAVEGACIÓN POR CATEGORÍA */}
                        <section aria-label="Selector de categorías de inventario">
                            <div
                                style={{
                                    display: 'grid',
                                    gridTemplateColumns: 'repeat(auto-fit, minmax(175px, 1fr))',
                                    gap: '12px',
                                }}
                            >
                                {/* Tarjeta general: Todas las categorías agrupadas */}
                                <button
                                    type="button"
                                    onClick={() => {
                                        setVistaSeccion('catalogo');
                                        setCategoriaActiva('TODAS');
                                    }}
                                    style={{
                                        textAlign: 'left',
                                        padding: '14px 16px',
                                        borderRadius: '10px',
                                        border:
                                            categoriaActiva === 'TODAS' && vistaSeccion === 'catalogo'
                                                ? '2px solid #183d35'
                                                : '1px solid var(--inventory-line)',
                                        backgroundColor:
                                            categoriaActiva === 'TODAS' && vistaSeccion === 'catalogo'
                                                ? '#183d35'
                                                : '#ffffff',
                                        color:
                                            categoriaActiva === 'TODAS' && vistaSeccion === 'catalogo'
                                                ? '#ffffff'
                                                : 'var(--inventory-ink)',
                                        cursor: 'pointer',
                                        transition: 'all 0.15s ease',
                                        boxShadow: '0 1px 3px rgba(0,0,0,0.04)',
                                    }}
                                >
                                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
                                        <span style={{ fontSize: '11.5px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.04em', opacity: 0.9 }}>
                                            Todas las Categorías
                                        </span>
                                        <span
                                            style={{
                                                fontSize: '11px',
                                                fontWeight: 700,
                                                padding: '2px 8px',
                                                borderRadius: '99px',
                                                backgroundColor:
                                                    categoriaActiva === 'TODAS' && vistaSeccion === 'catalogo'
                                                        ? 'rgba(255,255,255,0.2)'
                                                        : '#f1f5f9',
                                                color:
                                                    categoriaActiva === 'TODAS' && vistaSeccion === 'catalogo'
                                                        ? '#ffffff'
                                                        : '#334155',
                                            }}
                                        >
                                            {resumenCategoriasTotal.length} grupos
                                        </span>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: '8px' }}>
                                        <strong style={{ fontSize: '24px', fontFamily: 'Georgia, serif', fontWeight: 400 }}>
                                            {articles.length}
                                        </strong>
                                        {lowStockCount > 0 && (
                                            <span
                                                style={{
                                                    fontSize: '11px',
                                                    fontWeight: 700,
                                                    color:
                                                        categoriaActiva === 'TODAS' && vistaSeccion === 'catalogo'
                                                            ? '#fecaca'
                                                            : '#b91c1c',
                                                }}
                                            >
                                                {lowStockCount} en alerta
                                            </span>
                                        )}
                                    </div>
                                </button>

                                {/* Tarjetas individuales por cada Categoría */}
                                {resumenCategoriasTotal.map((catItem) => {
                                    const meta = getCategoryMeta(catItem.categoria);
                                    const activa =
                                        categoriaActiva === catItem.categoria &&
                                        vistaSeccion === 'catalogo';

                                    return (
                                        <button
                                            key={catItem.categoria}
                                            type="button"
                                            onClick={() => {
                                                setVistaSeccion('catalogo');
                                                setCategoriaActiva(catItem.categoria);
                                            }}
                                            style={{
                                                textAlign: 'left',
                                                padding: '14px 16px',
                                                borderRadius: '10px',
                                                border: activa
                                                    ? `2px solid ${meta.color}`
                                                    : `1px solid ${meta.border}`,
                                                backgroundColor: activa ? meta.bg : '#ffffff',
                                                cursor: 'pointer',
                                                transition: 'all 0.15s ease',
                                                boxShadow: activa
                                                    ? '0 3px 10px rgba(0,0,0,0.06)'
                                                    : '0 1px 2px rgba(0,0,0,0.03)',
                                            }}
                                        >
                                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
                                                <div style={{ display: 'flex', alignItems: 'center', gap: '7px' }}>
                                                    {meta.icono}
                                                    <span style={{ fontSize: '13px', fontWeight: 700, color: meta.color }}>
                                                        {catItem.categoria}
                                                    </span>
                                                </div>
                                                <span
                                                    style={{
                                                        fontSize: '11px',
                                                        fontWeight: 700,
                                                        padding: '2px 7px',
                                                        borderRadius: '99px',
                                                        backgroundColor: meta.bg,
                                                        color: meta.color,
                                                        border: `1px solid ${meta.border}`,
                                                    }}
                                                >
                                                    {catItem.total} ítems
                                                </span>
                                            </div>
                                            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: '4px' }}>
                                                <span style={{ fontSize: '11.5px', color: '#64748b' }}>
                                                    {activa ? 'Categoría filtrada' : 'Clic para filtrar'}
                                                </span>
                                                {catItem.alertas > 0 ? (
                                                    <span
                                                        style={{
                                                            fontSize: '11px',
                                                            fontWeight: 700,
                                                            color: '#9b3929',
                                                            backgroundColor: '#fff0eb',
                                                            padding: '1px 7px',
                                                            borderRadius: '4px',
                                                        }}
                                                    >
                                                        {catItem.alertas} reponer
                                                    </span>
                                                ) : (
                                                    <span
                                                        style={{
                                                            fontSize: '11px',
                                                            fontWeight: 700,
                                                            color: '#315d37',
                                                            backgroundColor: '#e7f0e5',
                                                            padding: '1px 7px',
                                                            borderRadius: '4px',
                                                        }}
                                                    >
                                                        Stock OK
                                                    </span>
                                                )}
                                            </div>
                                        </button>
                                    );
                                })}
                            </div>
                        </section>

                        {/* BARRA DE HERRAMIENTAS: PESTAÑAS (CATÁLOGO / MERMAS) Y BUSCADOR */}
                        <section
                            style={{
                                display: 'flex',
                                justifyContent: 'space-between',
                                alignItems: 'center',
                                flexWrap: 'wrap',
                                gap: '12px',
                                backgroundColor: '#ffffff',
                                padding: '12px 16px',
                                borderRadius: '8px',
                                border: '1px solid var(--inventory-line)',
                            }}
                            aria-label="Filtros y búsqueda en inventario"
                        >
                            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
                                <button
                                    type="button"
                                    onClick={() => setVistaSeccion('catalogo')}
                                    style={{
                                        padding: '8px 14px',
                                        borderRadius: '6px',
                                        fontSize: '12.5px',
                                        fontWeight: 700,
                                        border: 'none',
                                        backgroundColor: vistaSeccion === 'catalogo' ? '#183d35' : '#f1f5f9',
                                        color: vistaSeccion === 'catalogo' ? '#ffffff' : '#334155',
                                        cursor: 'pointer',
                                    }}
                                >
                                    Catálogo por Categorías ({filteredArticles.length})
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setVistaSeccion('mermas')}
                                    style={{
                                        padding: '8px 14px',
                                        borderRadius: '6px',
                                        fontSize: '12.5px',
                                        fontWeight: 700,
                                        border: 'none',
                                        backgroundColor: vistaSeccion === 'mermas' ? '#183d35' : '#f1f5f9',
                                        color: vistaSeccion === 'mermas' ? '#ffffff' : '#334155',
                                        cursor: 'pointer',
                                    }}
                                >
                                    Historial de Mermas ({adjustments.length})
                                </button>

                                {categoriaActiva !== 'TODAS' && vistaSeccion === 'catalogo' && (
                                    <button
                                        type="button"
                                        onClick={() => setCategoriaActiva('TODAS')}
                                        style={{
                                            padding: '6px 12px',
                                            borderRadius: '6px',
                                            fontSize: '12px',
                                            fontWeight: 600,
                                            border: '1px solid #cbd5e1',
                                            backgroundColor: '#f8fafc',
                                            color: '#0f172a',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Mostrando: {categoriaActiva} (Ver todas ✕)
                                    </button>
                                )}
                            </div>

                            <label className="inventory-search" style={{ margin: 0 }}>
                                <span style={{ display: 'none' }}>Buscar artículo</span>
                                <input
                                    type="search"
                                    value={search}
                                    onChange={(event) =>
                                        setSearch(event.target.value)
                                    }
                                    placeholder="Buscar por nombre, categoría o unidad de medida..."
                                />
                            </label>
                        </section>

                        {/* CONTENIDO PRINCIPAL: BLOQUES SEPARADOS POR CATEGORÍA O HISTORIAL DE MERMAS */}
                        {vistaSeccion === 'catalogo' ? (
                            loading ? (
                                <section className="users-table-wrap">
                                    <div className="users-table-state" style={{ padding: '36px', textAlign: 'center' }}>
                                        Cargando catálogo por categorías…
                                    </div>
                                </section>
                            ) : error && articles.length === 0 ? (
                                <section className="users-table-wrap">
                                    <div className="users-table-state users-table-state--error" style={{ padding: '36px', textAlign: 'center' }}>
                                        {error}
                                    </div>
                                </section>
                            ) : gruposVisibles.length === 0 ? (
                                <section className="users-table-wrap">
                                    <div className="users-table-state" style={{ padding: '36px', textAlign: 'center' }}>
                                        {search
                                            ? 'No hay artículos que coincidan con la búsqueda.'
                                            : 'Todavía no hay artículos registrados.'}
                                    </div>
                                </section>
                            ) : (
                                <div
                                    style={{
                                        display: 'grid',
                                        gridTemplateColumns:
                                            gruposVisibles.length === 1
                                                ? '1fr'
                                                : 'repeat(auto-fit, minmax(460px, 1fr))',
                                        gap: '18px',
                                        alignItems: 'start',
                                    }}
                                    aria-label="Catálogo de artículos de inventario separado por categorías"
                                >
                                    {gruposVisibles.map((grupo) => {
                                        const meta = getCategoryMeta(grupo.categoria);
                                        const expandida =
                                            categoriaActiva !== 'TODAS' ||
                                            Boolean(categoriasExpandidas[grupo.categoria]);
                                        const LIMITE_COMPACTO = 5;
                                        const itemsMostrados = expandida
                                            ? grupo.items
                                            : grupo.items.slice(0, LIMITE_COMPACTO);
                                        const hayMasItems =
                                            grupo.items.length > LIMITE_COMPACTO &&
                                            categoriaActiva === 'TODAS';

                                        return (
                                            <section
                                                key={grupo.categoria}
                                                className="users-table-wrap"
                                                style={{
                                                    borderRadius: '10px',
                                                    border: `1px solid ${meta.border}`,
                                                    backgroundColor: '#ffffff',
                                                    overflow: 'hidden',
                                                    boxShadow: '0 2px 6px rgba(0,0,0,0.03)',
                                                }}
                                            >
                                                {/* Cabecera de la Categoría */}
                                                <header
                                                    style={{
                                                        padding: '14px 18px',
                                                        backgroundColor: meta.bg,
                                                        borderBottom: `1px solid ${meta.border}`,
                                                        display: 'flex',
                                                        justifyContent: 'space-between',
                                                        alignItems: 'center',
                                                        flexWrap: 'wrap',
                                                        gap: '10px',
                                                    }}
                                                >
                                                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                                        <div
                                                            style={{
                                                                width: '34px',
                                                                height: '34px',
                                                                borderRadius: '8px',
                                                                backgroundColor: '#ffffff',
                                                                border: `1px solid ${meta.border}`,
                                                                display: 'flex',
                                                                alignItems: 'center',
                                                                justifyContent: 'center',
                                                            }}
                                                        >
                                                            {meta.icono}
                                                        </div>
                                                        <div>
                                                            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                                                <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 700, color: meta.color }}>
                                                                    {grupo.categoria}
                                                                </h3>
                                                                <span
                                                                    style={{
                                                                        fontSize: '11px',
                                                                        fontWeight: 700,
                                                                        padding: '2px 8px',
                                                                        borderRadius: '99px',
                                                                        backgroundColor: '#ffffff',
                                                                        color: meta.color,
                                                                        border: `1px solid ${meta.border}`,
                                                                    }}
                                                                >
                                                                    {grupo.items.length} artículos
                                                                </span>
                                                                {grupo.alertas > 0 && (
                                                                    <span
                                                                        style={{
                                                                            fontSize: '11px',
                                                                            fontWeight: 700,
                                                                            padding: '2px 8px',
                                                                            borderRadius: '99px',
                                                                            backgroundColor: '#fff0eb',
                                                                            color: '#9b3929',
                                                                            border: '1px solid #fdba74',
                                                                        }}
                                                                    >
                                                                        {grupo.alertas} en alerta
                                                                    </span>
                                                                )}
                                                            </div>
                                                            <p style={{ margin: '2px 0 0', fontSize: '11.5px', color: '#475569' }}>
                                                                {meta.descripcion}
                                                            </p>
                                                        </div>
                                                    </div>

                                                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                                                        <button
                                                            type="button"
                                                            onClick={() => openCreateModal(grupo.categoria)}
                                                            style={{
                                                                padding: '5px 10px',
                                                                borderRadius: '6px',
                                                                border: `1px solid ${meta.border}`,
                                                                backgroundColor: '#ffffff',
                                                                color: meta.color,
                                                                fontSize: '11.5px',
                                                                fontWeight: 700,
                                                                cursor: 'pointer',
                                                            }}
                                                        >
                                                            + Agregar en {grupo.categoria}
                                                        </button>
                                                        {categoriaActiva === 'TODAS' && (
                                                            <button
                                                                type="button"
                                                                onClick={() => setCategoriaActiva(grupo.categoria)}
                                                                style={{
                                                                    padding: '5px 10px',
                                                                    borderRadius: '6px',
                                                                    border: 'none',
                                                                    backgroundColor: meta.color,
                                                                    color: '#ffffff',
                                                                    fontSize: '11.5px',
                                                                    fontWeight: 600,
                                                                    cursor: 'pointer',
                                                                }}
                                                            >
                                                                Solo esta categoría
                                                            </button>
                                                        )}
                                                    </div>
                                                </header>

                                                {/* Tabla compacta de la categoría */}
                                                <div style={{ overflowX: 'auto' }}>
                                                    <table className="users-table" style={{ minWidth: '100%' }}>
                                                        <thead>
                                                            <tr>
                                                                <th scope="col">Artículo</th>
                                                                <th scope="col">Stock actual</th>
                                                                <th scope="col">Mínimo</th>
                                                                <th scope="col">Estado</th>
                                                                <th scope="col">Acciones</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            {itemsMostrados.map((article) => {
                                                                const isLowStock =
                                                                    stockNumber(article.stock_actual) <=
                                                                    stockNumber(article.stock_minimo_alerta);

                                                                return (
                                                                    <tr key={article.id}>
                                                                        <td className="users-table-name">
                                                                            <span style={{ display: 'block', fontWeight: 700, color: '#0f172a' }}>
                                                                                {article.nombre}
                                                                            </span>
                                                                            <span style={{ fontSize: '11px', color: '#64748b' }}>
                                                                                Unidad: {article.unidad_medida} • {article.categoria}
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <strong style={{ fontSize: '13.5px', color: isLowStock ? '#9b3929' : '#0f172a' }}>
                                                                                {formatStock(article.stock_actual)}
                                                                            </strong>{' '}
                                                                            <span style={{ fontSize: '11px', color: '#64748b' }}>
                                                                                {article.unidad_medida}
                                                                            </span>
                                                                        </td>
                                                                        <td style={{ fontSize: '12.5px', color: '#475569' }}>
                                                                            {stockNumber(article.stock_minimo_alerta).toLocaleString('es-BO')}
                                                                        </td>
                                                                        <td>
                                                                            <span
                                                                                className={`inventory-status ${isLowStock ? 'inventory-status--low' : 'inventory-status--ok'}`}
                                                                            >
                                                                                {isLowStock ? 'Reponer' : 'Disponible'}
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <div className="users-row-actions">
                                                                                <button
                                                                                    className="users-action-button"
                                                                                    type="button"
                                                                                    disabled={submitting}
                                                                                    onClick={() => openEditModal(article)}
                                                                                    aria-label={`Editar ${article.nombre}`}
                                                                                >
                                                                                    Editar
                                                                                </button>
                                                                                <button
                                                                                    className="users-action-button"
                                                                                    type="button"
                                                                                    disabled={
                                                                                        submitting ||
                                                                                        stockNumber(article.stock_actual) < 1
                                                                                    }
                                                                                    onClick={() => openMermaModal(article)}
                                                                                    aria-label={`Registrar merma de ${article.nombre}`}
                                                                                >
                                                                                    Merma
                                                                                </button>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                );
                                                            })}
                                                        </tbody>
                                                    </table>
                                                </div>

                                                {/* Botón para expandir o contraer cuando la categoría tiene más de 5 artículos */}
                                                {hayMasItems && (
                                                    <div
                                                        style={{
                                                            padding: '10px 16px',
                                                            backgroundColor: '#f8fafc',
                                                            borderTop: '1px solid #e2e8f0',
                                                            textAlign: 'center',
                                                        }}
                                                    >
                                                        <button
                                                            type="button"
                                                            onClick={() => toggleExpandirCategoria(grupo.categoria)}
                                                            style={{
                                                                background: 'none',
                                                                border: 'none',
                                                                color: meta.color,
                                                                fontSize: '12.5px',
                                                                fontWeight: 700,
                                                                cursor: 'pointer',
                                                            }}
                                                        >
                                                            {expandida
                                                                ? `Mostrar menos artículos de ${grupo.categoria} ▲`
                                                                : `Ver los ${grupo.items.length - LIMITE_COMPACTO} artículos restantes de ${grupo.categoria} (${grupo.items.length} en total) ▼`}
                                                        </button>
                                                    </div>
                                                )}
                                            </section>
                                        );
                                    })}
                                </div>
                            )
                        ) : (
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
                        )}
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
                                        : 'Completa los datos del catálogo asignando su categoría correspondiente.'}
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
                                        list="categorias-catalogo-list"
                                        value={form.categoria}
                                        onChange={(event) =>
                                            setForm((current) => ({
                                                ...current,
                                                categoria: event.target.value,
                                            }))
                                        }
                                        placeholder="Ej. Alimento"
                                    />
                                    <datalist id="categorias-catalogo-list">
                                        {CATEGORIAS_SUGERIDAS.map((cat) => (
                                            <option key={cat} value={cat} />
                                        ))}
                                    </datalist>
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
