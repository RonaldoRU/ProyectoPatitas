import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useMemo, useState } from 'react';
import type { FormEvent } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { index as inventoryPage } from '@/routes/articulos-inventario';
import { index as clinicalPage } from '@/routes/atenciones-clinicas';
import { index as auditPage } from '@/routes/bitacora';
import { index as entryPage } from '@/routes/entradas-insumos';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as stockoutPage } from '@/routes/salidas-inventario';
import { index as usersPage } from '@/routes/usuarios';
import salidaInventarioService, { StockoutRequestError } from '@/services/salidaInventarioService';
import type {
    RegisteredStockout,
    StockoutCatalogs,
    StockoutLineInput,
} from '@/services/salidaInventarioService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';
import '../../../css/users.css';
import '../../../css/entradas-insumos.css';
import '../../../css/salidas-inventario.css';

type StockoutLine = {
    id_articulo: string;
    cantidad: string;
};

const emptyCatalogs: StockoutCatalogs = {
    articulos: [],
};

const emptyLine = (): StockoutLine => ({
    id_articulo: '',
    cantidad: '',
});

function localDate(): string {
    const date = new Date();
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return `${year}-${month}-${day}`;
}

export default function SalidasInventario() {
    const [catalogs, setCatalogs] = useState<StockoutCatalogs>(emptyCatalogs);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [fecha, setFecha] = useState(localDate);
    const [motivo, setMotivo] = useState('');
    const [destino, setDestino] = useState('');
    const [lineas, setLineas] = useState<StockoutLine[]>([emptyLine()]);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState<RegisteredStockout | null>(null);

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

        async function loadCatalogs() {
            try {
                const result = await salidaInventarioService.catalogos(accessToken);

                if (active) {
                    setCatalogs(result);
                }
            } catch (cause) {
                if (cause instanceof StockoutRequestError && cause.status === 401) {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(cause instanceof Error
                        ? cause.message
                        : 'No se pudo cargar el catálogo de inventario.');
                }
            } finally {
                if (active) {
                    setLoading(false);
                }
            }
        }

        void loadCatalogs();

        return () => {
            active = false;
        };
    }, []);

    const unidadesSeleccionadas = useMemo(() => lineas.reduce(
        (total, linea) => total + (Number(linea.cantidad) || 0),
        0,
    ), [lineas]);

    function updateLine(index: number, field: keyof StockoutLine, value: string) {
        setLineas((current) => current.map((line, lineIndex) => (
            lineIndex === index ? { ...line, [field]: value } : line
        )));
    }

    function resetForm() {
        setFecha(localDate());
        setMotivo('');
        setDestino('');
        setLineas([emptyLine()]);
    }

    async function submitStockout(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess(null);

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        const payload = {
            motivo: motivo.trim(),
            destino: destino.trim(),
            fecha_salida: fecha,
            lineas: lineas.map((linea): StockoutLineInput => ({
                id_articulo: Number(linea.id_articulo),
                cantidad: linea.cantidad,
            })),
        };

        setSubmitting(true);

        try {
            const result = await salidaInventarioService.store(token, payload);
            const updatedArticles = new Map(
                result.articulos_actualizados.map((article) => [article.id, article.stock_actual]),
            );

            setCatalogs((current) => ({
                articulos: current.articulos.map((article) => (
                    updatedArticles.has(article.id)
                        ? {
                            ...article,
                            stock_actual: updatedArticles.get(article.id) ?? article.stock_actual,
                        }
                        : article
                )),
            }));
            setSuccess(result);
            resetForm();
        } catch (cause) {
            if (cause instanceof StockoutRequestError && cause.status === 401) {
                localStorage.removeItem('token');
                router.visit(loginPage.url());

                return;
            }

            setError(cause instanceof Error
                ? cause.message
                : 'No se pudo registrar la salida del inventario.');
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <>
            <Head title="Registrar salida de despensa - Los Angelitos" />
            <div className="dashboard-app">
                <main className="dashboard-main entry-main">
                    <DashboardTopNav title="Salidas de Inventario (P5)" />

                    <div className="dashboard-content users-content entry-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">Control de inventario</p>
                                <h2>Registrar una salida</h2>
                                <p>Documenta el consumo y descuenta las cantidades de las existencias.</p>
                            </div>
                        </section>

                        {success && (
                            <section className="entry-feedback entry-feedback--success" role="status">
                                <strong>Salida registrada</strong>
                                <span>
                                    {success.articulos.join(', ')} se descontaron del inventario
                                    {' '}y quedaron asociados a {success.destino}.
                                </span>
                            </section>
                        )}

                        {error && <p className="entry-feedback entry-feedback--error" role="alert">{error}</p>}

                        {catalogs.articulos.length === 0 && !loading && (
                            <p className="entry-feedback entry-feedback--notice" role="status">
                                No hay artículos registrados para seleccionar.
                            </p>
                        )}

                        <form className="entry-form" onSubmit={submitStockout}>
                            <section className="entry-card">
                                <div className="entry-card__heading">
                                    <span className="entry-card__step">1</span>
                                    <div>
                                        <h3>Datos del consumo</h3>
                                        <p>Registra cuándo se retira el insumo y a qué área se entrega.</p>
                                    </div>
                                </div>

                                <div className="entry-grid">
                                    <label className="entry-field">
                                        <span>Fecha de salida</span>
                                        <input
                                            type="date"
                                            value={fecha}
                                            onChange={(event) => setFecha(event.target.value)}
                                            required
                                        />
                                    </label>
                                    <label className="entry-field">
                                        <span>Área o destino</span>
                                        <input
                                            value={destino}
                                            onChange={(event) => setDestino(event.target.value)}
                                            maxLength={100}
                                            placeholder="Ej.: Cocina, limpieza, atención veterinaria"
                                            required
                                        />
                                    </label>
                                    <label className="entry-field">
                                        <span>Motivo del consumo</span>
                                        <input
                                            value={motivo}
                                            onChange={(event) => setMotivo(event.target.value)}
                                            maxLength={143}
                                            placeholder="Ej.: Alimentación diaria del refugio"
                                            required
                                        />
                                    </label>
                                </div>
                            </section>

                            <section className="entry-card">
                                <div className="entry-card__heading">
                                    <span className="entry-card__step">2</span>
                                    <div>
                                        <h3>Artículos retirados</h3>
                                        <p>Selecciona los artículos y verifica el stock disponible antes de confirmar.</p>
                                    </div>
                                </div>

                                <div className="entry-lines">
                                    {lineas.map((linea, index) => {
                                        const selectedIds = lineas
                                            .filter((_, lineIndex) => lineIndex !== index)
                                            .map((item) => item.id_articulo);
                                        const selectedArticle = catalogs.articulos.find(
                                            (article) => String(article.id) === linea.id_articulo,
                                        );

                                        return (
                                            <fieldset className="entry-line" key={index}>
                                                <legend>Artículo {index + 1}</legend>
                                                <div className="entry-line__fields stockout-line__fields">
                                                    <label className="entry-field entry-field--article">
                                                        <span>Artículo</span>
                                                        <select
                                                            value={linea.id_articulo}
                                                            onChange={(event) => updateLine(
                                                                index,
                                                                'id_articulo',
                                                                event.target.value,
                                                            )}
                                                            required
                                                        >
                                                            <option value="">Selecciona un artículo</option>
                                                            {catalogs.articulos
                                                                .filter((article) => (
                                                                    !selectedIds.includes(String(article.id))
                                                                    || String(article.id) === linea.id_articulo
                                                                ))
                                                                .map((article) => (
                                                                    <option key={article.id} value={article.id}>
                                                                        {article.nombre} — {article.categoria}
                                                                    </option>
                                                                ))}
                                                        </select>
                                                        {selectedArticle && (
                                                            <small>
                                                                Disponible: {selectedArticle.stock_actual} {selectedArticle.unidad_medida}
                                                            </small>
                                                        )}
                                                    </label>
                                                    <label className="entry-field">
                                                        <span>Cantidad a retirar (unidades enteras)</span>
                                                        <input
                                                            type="number"
                                                            min="1"
                                                            max={selectedArticle
                                                                ? String(Math.floor(Number(selectedArticle.stock_actual)))
                                                                : undefined}
                                                            step="1"
                                                            value={linea.cantidad}
                                                            onChange={(event) => updateLine(
                                                                index,
                                                                'cantidad',
                                                                event.target.value,
                                                            )}
                                                            required
                                                        />
                                                    </label>
                                                    {lineas.length > 1 && (
                                                        <button
                                                            className="entry-remove-line"
                                                            type="button"
                                                            onClick={() => setLineas((current) => (
                                                                current.filter((_, lineIndex) => lineIndex !== index)
                                                            ))}
                                                            aria-label={`Quitar artículo ${index + 1}`}
                                                        >
                                                            Quitar
                                                        </button>
                                                    )}
                                                </div>
                                            </fieldset>
                                        );
                                    })}
                                </div>

                                <div className="entry-lines__footer">
                                    <button
                                        className="entry-secondary-button"
                                        type="button"
                                        disabled={lineas.length >= catalogs.articulos.length}
                                        onClick={() => setLineas((current) => [...current, emptyLine()])}
                                    >
                                        + Agregar artículo
                                    </button>
                                    <p className="entry-total">
                                        Unidades a retirar <strong>
                                            {unidadesSeleccionadas.toLocaleString('es-BO', { maximumFractionDigits: 0 })}
                                        </strong>
                                    </p>
                                </div>
                            </section>

                            <div className="entry-submit-row">
                                <p>Si una cantidad excede las existencias, la salida completa será rechazada.</p>
                                <button
                                    className="users-add-button"
                                    type="submit"
                                    disabled={loading || submitting || catalogs.articulos.length === 0}
                                >
                                    {submitting ? 'Registrando…' : 'Confirmar salida'}
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </>
    );
}
