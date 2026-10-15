import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import type { FormEvent } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { index as inventoryPage } from '@/routes/articulos-inventario';
import { index as clinicalPage } from '@/routes/atenciones-clinicas';
import { index as auditPage } from '@/routes/bitacora';
import { index as entryPage } from '@/routes/entradas-insumos';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as stockoutPage } from '@/routes/salidas-inventario';
import { index as usersPage } from '@/routes/usuarios';
import atencionClinicaService, { ClinicalAttentionRequestError } from '@/services/atencionClinicaService';
import type {
    ClinicalAttentionPayload,
    ClinicalCatalogs,
    ClinicalLineInput,
    RegisteredClinicalAttention,
} from '@/services/atencionClinicaService';
import '../../css/dashboard.css';
import '../../css/users.css';
import '../../css/entradas-insumos.css';
import '../../css/atenciones-clinicas.css';

type ClinicalLine = {
    id_articulo: string;
    cantidad: string;
};

const emptyCatalogs: ClinicalCatalogs = {
    mascotas: [],
    articulos: [],
};

const emptyLine = (): ClinicalLine => ({
    id_articulo: '',
    cantidad: '',
});

function localDate(): string {
    const date = new Date();
    const offset = date.getTimezoneOffset();

    return new Date(date.getTime() - offset * 60_000).toISOString().slice(0, 10);
}

export default function AtencionesClinicas() {
    const [catalogs, setCatalogs] = useState<ClinicalCatalogs>(emptyCatalogs);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [fecha, setFecha] = useState(localDate);
    const [mascotaId, setMascotaId] = useState('');
    const [diagnostico, setDiagnostico] = useState('');
    const [observacion, setObservacion] = useState('');
    const [procedimiento, setProcedimiento] = useState('');
    const [lineas, setLineas] = useState<ClinicalLine[]>([emptyLine()]);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState<RegisteredClinicalAttention | null>(null);

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
                const result = await atencionClinicaService.catalogos(accessToken);

                if (active) {
                    setCatalogs(result);
                }
            } catch (cause) {
                if (cause instanceof ClinicalAttentionRequestError && cause.status === 401) {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(cause instanceof Error
                        ? cause.message
                        : 'No se pudieron cargar las mascotas y los artículos.');
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

    function resetForm() {
        setFecha(localDate());
        setMascotaId('');
        setDiagnostico('');
        setObservacion('');
        setProcedimiento('');
        setLineas([emptyLine()]);
    }

    function updateLine(index: number, field: keyof ClinicalLine, value: string) {
        setLineas((current) => current.map((line, lineIndex) => (
            lineIndex === index ? { ...line, [field]: value } : line
        )));
    }

    async function submitAttention(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess(null);

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        const payload: ClinicalAttentionPayload = {
            fecha_atencion: fecha,
            id_mascota: Number(mascotaId),
            diagnostico: diagnostico.trim(),
            observacion: observacion.trim(),
            tipo_procedimiento: procedimiento.trim(),
            lineas: lineas.map((linea): ClinicalLineInput => ({
                id_articulo: Number(linea.id_articulo),
                cantidad: linea.cantidad,
            })),
        };

        setSubmitting(true);

        try {
            const result = await atencionClinicaService.store(token, payload);
            const updatedArticles = new Map(
                result.articulos_actualizados.map((article) => [article.id, article.stock_actual]),
            );

            setCatalogs((current) => ({
                ...current,
                articulos: current.articulos.map((article) => (
                    updatedArticles.has(article.id)
                        ? { ...article, stock_actual: updatedArticles.get(article.id) ?? article.stock_actual }
                        : article
                )),
            }));
            setSuccess(result);
            resetForm();
        } catch (cause) {
            if (cause instanceof ClinicalAttentionRequestError && cause.status === 401) {
                localStorage.removeItem('token');
                router.visit(loginPage.url());

                return;
            }

            setError(cause instanceof Error
                ? cause.message
                : 'No se pudo registrar la atención clínica.');
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <>
            <Head title="Registrar atención clínica" />
            <div className="dashboard-app">
                <aside className="dashboard-sidebar">
                    <Link className="dashboard-brand" href={dashboardPage.url()}>
                        <span className="dashboard-brand__badge">LA</span>
                        <span className="dashboard-brand__name">Los Angelitos</span>
                    </Link>

                    <nav className="dashboard-nav" aria-label="Navegación principal">
                        <Link className="dashboard-nav__item" href={dashboardPage.url()}>
                            <span aria-hidden="true">⌂</span><span>Inicio</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#ingresos`}>
                            <span aria-hidden="true">✿</span><span>Animales</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#adopciones`}>
                            <span aria-hidden="true">♡</span><span>Adopciones</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={applicantsPage.url()}>
                            <span aria-hidden="true">♧</span><span>Postulantes</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={inventoryPage.url()}>
                            <span aria-hidden="true">◇</span><span>Inventario</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={entryPage.url()}>
                            <span aria-hidden="true">▤</span><span>Entradas</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={stockoutPage.url()}>
                            <span aria-hidden="true">↗</span><span>Salidas</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item dashboard-nav__item--active"
                            href={clinicalPage.url()}
                            aria-current="page"
                        >
                            <span aria-hidden="true">✚</span><span>Atención clínica</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={usersPage.url()}>
                            <span aria-hidden="true">▣</span><span>Usuarios</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={auditPage.url()}>
                            <span aria-hidden="true">◷</span><span>Bitácora</span>
                        </Link>
                    </nav>

                    <div className="dashboard-sidebar__foot">
                        Refugio Los Angelitos de Edgar
                        <span>Santa Cruz de la Sierra</span>
                    </div>
                </aside>

                <main className="dashboard-main entry-main clinical-main">
                    <header className="dashboard-topbar">
                        <h1>Atención clínica</h1>
                        <div className="dashboard-topbar__actions">
                            <span className="clinical-role-label">Registro veterinario</span>
                        </div>
                    </header>

                    <div className="dashboard-content entry-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">Atención veterinaria</p>
                                <h2>Registrar tratamiento</h2>
                                <p>
                                    Registra la atención de una mascota y descuenta del inventario los medicamentos
                                    e insumos utilizados.
                                </p>
                            </div>
                        </section>

                        {error && <p className="users-feedback users-feedback--error" role="alert">{error}</p>}
                        {success && (
                            <section className="clinical-success" role="status">
                                <h3>Atención #{success.id} registrada</h3>
                                <p>
                                    {success.mascota}: {success.tipo_procedimiento}. Se generó la salida de inventario
                                    #{success.salida_inventario_id}.
                                </p>
                                <ul>
                                    {success.articulos_actualizados.map((article) => (
                                        <li key={article.id}>
                                            {article.nombre}: se utilizaron {article.cantidad}; quedan {article.stock_actual}.
                                        </li>
                                    ))}
                                </ul>
                            </section>
                        )}

                        <form className="entry-form" onSubmit={submitAttention}>
                            <section className="entry-card">
                                <div className="entry-card__heading">
                                    <span className="entry-card__step">1</span>
                                    <div>
                                        <h3>Datos de la atención</h3>
                                        <p>La atención quedará asociada a la mascota y al veterinario autenticado.</p>
                                    </div>
                                </div>

                                <div className="clinical-form-grid">
                                    <label className="entry-field">
                                        <span>Mascota</span>
                                        <select
                                            value={mascotaId}
                                            onChange={(event) => setMascotaId(event.target.value)}
                                            required
                                        >
                                            <option value="">Selecciona una mascota</option>
                                            {catalogs.mascotas.map((pet) => (
                                                <option key={pet.id} value={pet.id}>
                                                    {pet.nombre} — {pet.especie} ({pet.estado_actual})
                                                </option>
                                            ))}
                                        </select>
                                    </label>
                                    <label className="entry-field">
                                        <span>Fecha de atención</span>
                                        <input
                                            type="date"
                                            value={fecha}
                                            onChange={(event) => setFecha(event.target.value)}
                                            required
                                        />
                                    </label>
                                    <label className="entry-field clinical-form-grid__full">
                                        <span>Diagnóstico</span>
                                        <input
                                            maxLength={255}
                                            value={diagnostico}
                                            onChange={(event) => setDiagnostico(event.target.value)}
                                            required
                                        />
                                    </label>
                                    <label className="entry-field clinical-form-grid__full">
                                        <span>Procedimiento o tratamiento</span>
                                        <input
                                            maxLength={255}
                                            value={procedimiento}
                                            onChange={(event) => setProcedimiento(event.target.value)}
                                            required
                                        />
                                    </label>
                                    <label className="entry-field clinical-form-grid__full">
                                        <span>Observaciones</span>
                                        <textarea
                                            maxLength={255}
                                            rows={3}
                                            value={observacion}
                                            onChange={(event) => setObservacion(event.target.value)}
                                            required
                                        />
                                    </label>
                                </div>
                            </section>

                            <section className="entry-card">
                                <div className="entry-card__heading">
                                    <span className="entry-card__step">2</span>
                                    <div>
                                        <h3>Medicamentos e insumos aplicados</h3>
                                        <p>
                                            Las cantidades son unidades enteras. El stock se verifica nuevamente
                                            al guardar para evitar saldos negativos.
                                        </p>
                                    </div>
                                </div>

                                {loading ? (
                                    <p role="status">Cargando mascotas e inventario…</p>
                                ) : catalogs.articulos.length === 0 ? (
                                    <p role="status">No hay artículos en el inventario para registrar el consumo.</p>
                                ) : (
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
                                                    <div className="clinical-line__fields">
                                                        <label className="entry-field">
                                                            <span>Medicamento o insumo</span>
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
                                                                    Disponible: {selectedArticle.stock_actual}{' '}
                                                                    {selectedArticle.unidad_medida}
                                                                </small>
                                                            )}
                                                        </label>
                                                        <label className="entry-field">
                                                            <span>Cantidad utilizada</span>
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
                                )}

                                <div className="entry-lines__footer">
                                    <button
                                        className="entry-secondary-button"
                                        type="button"
                                        disabled={
                                            loading
                                            || lineas.length >= catalogs.articulos.length
                                            || catalogs.articulos.length === 0
                                        }
                                        onClick={() => setLineas((current) => [...current, emptyLine()])}
                                    >
                                        + Agregar artículo
                                    </button>
                                    <span>{lineas.length} artículo(s) en esta atención</span>
                                </div>
                            </section>

                            <div className="entry-submit-row">
                                <p>Si falta stock de un artículo, no se guardará la atención ni se modificará el inventario.</p>
                                <button
                                    className="users-add-button"
                                    type="submit"
                                    disabled={loading || submitting || catalogs.mascotas.length === 0 || catalogs.articulos.length === 0}
                                >
                                    {submitting ? 'Registrando…' : 'Registrar atención'}
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </>
    );
}
