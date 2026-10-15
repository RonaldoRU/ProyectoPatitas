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
import entradaInsumoService, {
    EntryRequestError,
} from '@/services/entradaInsumoService';
import type {
    EntryCatalogs,
    EntryLineInput,
    EntryPayload,
    EntryType,
    RegisteredEntry,
} from '@/services/entradaInsumoService';
import '../../css/dashboard.css';
import '../../css/users.css';
import '../../css/entradas-insumos.css';

type EntryLine = {
    id_articulo: string;
    cantidad: string;
    costo_unitario: string;
    fecha_vencimiento: string;
};

const emptyCatalogs: EntryCatalogs = {
    articulos: [],
    proveedores: [],
    donantes: [],
};

const emptyLine = (): EntryLine => ({
    id_articulo: '',
    cantidad: '',
    costo_unitario: '',
    fecha_vencimiento: '',
});

function localDate(): string {
    const date = new Date();
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return `${year}-${month}-${day}`;
}

function formatMoney(value: number): string {
    return new Intl.NumberFormat('es-BO', {
        style: 'currency',
        currency: 'BOB',
        maximumFractionDigits: 2,
    }).format(value);
}

export default function EntradasInsumos() {
    const [catalogs, setCatalogs] = useState<EntryCatalogs>(emptyCatalogs);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [tipo, setTipo] = useState<EntryType>('compra');
    const [fecha, setFecha] = useState(localDate);
    const [numeroDocumento, setNumeroDocumento] = useState('');
    const [proveedorSeleccionado, setProveedorSeleccionado] = useState('');
    const [donanteSeleccionado, setDonanteSeleccionado] = useState('nuevo');
    const [donante, setDonante] = useState({
        nombre: '',
        telefono: '',
        tipo_persona: 'Natural',
    });
    const [lineas, setLineas] = useState<EntryLine[]>([emptyLine()]);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState<RegisteredEntry | null>(null);

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
                const result =
                    await entradaInsumoService.catalogos(accessToken);

                if (active) {
                    setCatalogs(result);
                }
            } catch (cause) {
                if (
                    cause instanceof EntryRequestError &&
                    cause.status === 401
                ) {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(
                        cause instanceof Error
                            ? cause.message
                            : 'No se pudo cargar el catálogo para registrar entradas.',
                    );
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

    const totalEstimado = useMemo(
        () =>
            tipo === 'compra'
                ? lineas.reduce(
                      (total, linea) =>
                          total +
                          (Number(linea.cantidad) || 0) *
                              (Number(linea.costo_unitario) || 0),
                      0,
                  )
                : 0,
        [lineas, tipo],
    );

    function updateLine(index: number, field: keyof EntryLine, value: string) {
        setLineas((current) =>
            current.map((line, lineIndex) =>
                lineIndex === index ? { ...line, [field]: value } : line,
            ),
        );
    }

    function resetForm() {
        setFecha(localDate());
        setNumeroDocumento('');
        setProveedorSeleccionado('');
        setDonanteSeleccionado('nuevo');
        setDonante({
            nombre: '',
            telefono: '',
            tipo_persona: 'Natural',
        });
        setLineas([emptyLine()]);
    }

    async function submitEntry(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess(null);

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        const preparedLines: EntryLineInput[] = lineas.map((linea) => ({
            id_articulo: Number(linea.id_articulo),
            cantidad: linea.cantidad,
            fecha_vencimiento: linea.fecha_vencimiento || null,
            ...(tipo === 'compra'
                ? { costo_unitario: linea.costo_unitario }
                : {}),
        }));

        const payload: EntryPayload = {
            tipo,
            fecha,
            numero_documento: numeroDocumento.trim() || null,
            lineas: preparedLines,
            ...(tipo === 'compra'
                ? { id_proveedor: Number(proveedorSeleccionado) }
                : donanteSeleccionado === 'nuevo'
                  ? { donante }
                  : { id_donante: Number(donanteSeleccionado) }),
        };

        setSubmitting(true);

        try {
            const entry = await entradaInsumoService.store(token, payload);
            const updatedArticles = new Map(
                entry.articulos_actualizados.map((article) => [
                    article.id,
                    article.stock_actual,
                ]),
            );

            setCatalogs((current) => ({
                ...current,
                articulos: current.articulos.map((article) =>
                    updatedArticles.has(article.id)
                        ? {
                              ...article,
                              stock_actual:
                                  updatedArticles.get(article.id) ??
                                  article.stock_actual,
                          }
                        : article,
                ),
            }));
            setSuccess(entry);
            resetForm();
        } catch (cause) {
            if (cause instanceof EntryRequestError && cause.status === 401) {
                localStorage.removeItem('token');
                router.visit(loginPage.url());

                return;
            }

            setError(
                cause instanceof Error
                    ? cause.message
                    : 'No se pudo registrar la entrada de insumos.',
            );
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <>
            <Head title="Registrar entrada de insumos" />
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
                            className="dashboard-nav__item"
                            href={inventoryPage.url()}
                        >
                            <span aria-hidden="true">◇</span>
                            <span>Inventario</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item dashboard-nav__item--active"
                            href={entryPage.url()}
                            aria-current="page"
                        >
                            <span aria-hidden="true">▤</span>
                            <span>Entradas</span>
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

                <main className="dashboard-main entry-main">
                    <header className="dashboard-topbar">
                        <h1>Entradas de insumos</h1>
                        <div className="dashboard-topbar__actions">
                            <span className="users-topbar-label">
                                Compras y donaciones
                            </span>
                        </div>
                    </header>

                    <div className="dashboard-content users-content entry-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">
                                    Control de inventario
                                </p>
                                <h2>Registrar una entrada</h2>
                                <p>
                                    Registra la recepción y actualiza el stock
                                    en una sola operación.
                                </p>
                            </div>
                        </section>

                        {success && (
                            <section
                                className="entry-feedback entry-feedback--success"
                                role="status"
                            >
                                <strong>
                                    {success.tipo === 'compra'
                                        ? 'Compra registrada'
                                        : 'Donación registrada'}
                                </strong>
                                <span>
                                    {success.articulos.join(', ')} — el stock
                                    quedó actualizado.
                                    {success.monto_total !== null
                                        ? ` Total: ${formatMoney(Number(success.monto_total))}.`
                                        : ''}
                                </span>
                            </section>
                        )}

                        {error && (
                            <p
                                className="entry-feedback entry-feedback--error"
                                role="alert"
                            >
                                {error}
                            </p>
                        )}

                        {catalogs.articulos.length === 0 && !loading && (
                            <p
                                className="entry-feedback entry-feedback--notice"
                                role="status"
                            >
                                Para registrar una entrada primero deben existir
                                artículos en el catálogo.
                            </p>
                        )}

                        <form className="entry-form" onSubmit={submitEntry}>
                            <section className="entry-card">
                                <div className="entry-card__heading">
                                    <span className="entry-card__step">1</span>
                                    <div>
                                        <h3>Datos de recepción</h3>
                                        <p>
                                            Indica si es una compra o una
                                            donación y quién la entrega.
                                        </p>
                                    </div>
                                </div>

                                <div className="entry-grid">
                                    <label className="entry-field">
                                        <span>Tipo de entrada</span>
                                        <select
                                            value={tipo}
                                            onChange={(event) =>
                                                setTipo(
                                                    event.target
                                                        .value as EntryType,
                                                )
                                            }
                                            required
                                        >
                                            <option value="compra">
                                                Compra
                                            </option>
                                            <option value="donacion">
                                                Donación de insumos
                                            </option>
                                        </select>
                                    </label>
                                    <label className="entry-field">
                                        <span>Fecha de recepción</span>
                                        <input
                                            type="date"
                                            value={fecha}
                                            onChange={(event) =>
                                                setFecha(event.target.value)
                                            }
                                            required
                                        />
                                    </label>
                                    <label className="entry-field">
                                        <span>
                                            Número de documento
                                            {tipo === 'donacion'
                                                ? ' (opcional)'
                                                : ''}
                                        </span>
                                        <input
                                            type="text"
                                            value={numeroDocumento}
                                            onChange={(event) =>
                                                setNumeroDocumento(
                                                    event.target.value,
                                                )
                                            }
                                            maxLength={100}
                                            required={tipo === 'compra'}
                                            placeholder="Factura, recibo o comprobante"
                                        />
                                    </label>
                                </div>

                                {tipo === 'compra' ? (
                                    <div className="entry-party">
                                        <label className="entry-field">
                                            <span>Proveedor</span>
                                            <select
                                                value={proveedorSeleccionado}
                                                onChange={(event) =>
                                                    setProveedorSeleccionado(
                                                        event.target.value,
                                                    )
                                                }
                                                required
                                                disabled={
                                                    loading ||
                                                    catalogs.proveedores
                                                        .length === 0
                                                }
                                            >
                                                <option value="">
                                                    Selecciona un proveedor
                                                    activo
                                                </option>
                                                {catalogs.proveedores.map(
                                                    (item) => (
                                                        <option
                                                            key={item.id}
                                                            value={item.id}
                                                        >
                                                            {
                                                                item.nombre_empresa
                                                            }
                                                            {item.tipo_insumo_provisto
                                                                ? ` — ${item.tipo_insumo_provisto}`
                                                                : ''}
                                                        </option>
                                                    ),
                                                )}
                                            </select>
                                        </label>
                                        {catalogs.proveedores.length === 0 &&
                                            !loading && (
                                                <small>
                                                    No hay proveedores activos.
                                                    Solicita al administrador
                                                    que registre uno en el
                                                    directorio.
                                                </small>
                                            )}
                                        <Link
                                            className="entry-supplier-link"
                                            href={suppliersPage.url()}
                                        >
                                            Consultar directorio de proveedores
                                        </Link>
                                    </div>
                                ) : (
                                    <div className="entry-party">
                                        <label className="entry-field">
                                            <span>Donante</span>
                                            <select
                                                value={donanteSeleccionado}
                                                onChange={(event) =>
                                                    setDonanteSeleccionado(
                                                        event.target.value,
                                                    )
                                                }
                                            >
                                                <option value="nuevo">
                                                    Registrar un donante nuevo
                                                </option>
                                                {catalogs.donantes.map(
                                                    (item) => (
                                                        <option
                                                            key={item.id}
                                                            value={item.id}
                                                        >
                                                            {item.nombre} (
                                                            {item.tipo_persona})
                                                        </option>
                                                    ),
                                                )}
                                            </select>
                                        </label>
                                        {donanteSeleccionado === 'nuevo' && (
                                            <div className="entry-grid entry-grid--party">
                                                <label className="entry-field">
                                                    <span>
                                                        Nombre del donante
                                                    </span>
                                                    <input
                                                        value={donante.nombre}
                                                        onChange={(event) =>
                                                            setDonante({
                                                                ...donante,
                                                                nombre: event
                                                                    .target
                                                                    .value,
                                                            })
                                                        }
                                                        maxLength={255}
                                                        required
                                                    />
                                                </label>
                                                <label className="entry-field">
                                                    <span>Teléfono</span>
                                                    <input
                                                        value={donante.telefono}
                                                        onChange={(event) =>
                                                            setDonante({
                                                                ...donante,
                                                                telefono:
                                                                    event.target
                                                                        .value,
                                                            })
                                                        }
                                                        maxLength={255}
                                                        required
                                                    />
                                                </label>
                                                <label className="entry-field">
                                                    <span>Tipo de persona</span>
                                                    <input
                                                        value={
                                                            donante.tipo_persona
                                                        }
                                                        onChange={(event) =>
                                                            setDonante({
                                                                ...donante,
                                                                tipo_persona:
                                                                    event.target
                                                                        .value,
                                                            })
                                                        }
                                                        maxLength={255}
                                                        required
                                                    />
                                                </label>
                                            </div>
                                        )}
                                    </div>
                                )}
                            </section>

                            <section className="entry-card">
                                <div className="entry-card__heading">
                                    <span className="entry-card__step">2</span>
                                    <div>
                                        <h3>Artículos recibidos</h3>
                                        <p>
                                            Agrega cada artículo, su cantidad y,
                                            si corresponde, vencimiento.
                                        </p>
                                    </div>
                                </div>

                                <div className="entry-lines">
                                    {lineas.map((linea, index) => {
                                        const selectedIds = lineas
                                            .filter(
                                                (_, lineIndex) =>
                                                    lineIndex !== index,
                                            )
                                            .map((item) => item.id_articulo);
                                        const selectedArticle =
                                            catalogs.articulos.find(
                                                (article) =>
                                                    String(article.id) ===
                                                    linea.id_articulo,
                                            );

                                        return (
                                            <fieldset
                                                className="entry-line"
                                                key={index}
                                            >
                                                <legend>
                                                    Artículo {index + 1}
                                                </legend>
                                                <div className="entry-line__fields">
                                                    <label className="entry-field entry-field--article">
                                                        <span>Artículo</span>
                                                        <select
                                                            value={
                                                                linea.id_articulo
                                                            }
                                                            onChange={(event) =>
                                                                updateLine(
                                                                    index,
                                                                    'id_articulo',
                                                                    event.target
                                                                        .value,
                                                                )
                                                            }
                                                            required
                                                        >
                                                            <option value="">
                                                                Selecciona un
                                                                artículo
                                                            </option>
                                                            {catalogs.articulos
                                                                .filter(
                                                                    (article) =>
                                                                        !selectedIds.includes(
                                                                            String(
                                                                                article.id,
                                                                            ),
                                                                        ) ||
                                                                        String(
                                                                            article.id,
                                                                        ) ===
                                                                            linea.id_articulo,
                                                                )
                                                                .map(
                                                                    (
                                                                        article,
                                                                    ) => (
                                                                        <option
                                                                            key={
                                                                                article.id
                                                                            }
                                                                            value={
                                                                                article.id
                                                                            }
                                                                        >
                                                                            {
                                                                                article.nombre
                                                                            }{' '}
                                                                            —{' '}
                                                                            {
                                                                                article.unidad_medida
                                                                            }
                                                                        </option>
                                                                    ),
                                                                )}
                                                        </select>
                                                        {selectedArticle && (
                                                            <small>
                                                                Stock actual:{' '}
                                                                {
                                                                    selectedArticle.stock_actual
                                                                }{' '}
                                                                {
                                                                    selectedArticle.unidad_medida
                                                                }
                                                            </small>
                                                        )}
                                                    </label>
                                                    <label className="entry-field">
                                                        <span>
                                                            Cantidad (unidades
                                                            enteras)
                                                        </span>
                                                        <input
                                                            type="number"
                                                            min="1"
                                                            max="999999"
                                                            step="1"
                                                            value={
                                                                linea.cantidad
                                                            }
                                                            onChange={(event) =>
                                                                updateLine(
                                                                    index,
                                                                    'cantidad',
                                                                    event.target
                                                                        .value,
                                                                )
                                                            }
                                                            required
                                                        />
                                                    </label>
                                                    {tipo === 'compra' && (
                                                        <label className="entry-field">
                                                            <span>
                                                                Costo unitario
                                                                (Bs.)
                                                            </span>
                                                            <input
                                                                type="number"
                                                                min="0"
                                                                max="999999.99"
                                                                step="0.01"
                                                                value={
                                                                    linea.costo_unitario
                                                                }
                                                                onChange={(
                                                                    event,
                                                                ) =>
                                                                    updateLine(
                                                                        index,
                                                                        'costo_unitario',
                                                                        event
                                                                            .target
                                                                            .value,
                                                                    )
                                                                }
                                                                required
                                                            />
                                                        </label>
                                                    )}
                                                    <label className="entry-field">
                                                        <span>
                                                            Fecha de vencimiento
                                                            {selectedArticle?.requiere_vencimiento
                                                                ? ' (obligatoria para medicamentos)'
                                                                : ' (opcional)'}
                                                        </span>
                                                        <input
                                                            type="date"
                                                            min={
                                                                selectedArticle?.requiere_vencimiento
                                                                    ? localDate()
                                                                    : undefined
                                                            }
                                                            value={
                                                                linea.fecha_vencimiento
                                                            }
                                                            onChange={(event) =>
                                                                updateLine(
                                                                    index,
                                                                    'fecha_vencimiento',
                                                                    event.target
                                                                        .value,
                                                                )
                                                            }
                                                            required={
                                                                selectedArticle?.requiere_vencimiento ??
                                                                false
                                                            }
                                                        />
                                                    </label>
                                                    {lineas.length > 1 && (
                                                        <button
                                                            className="entry-remove-line"
                                                            type="button"
                                                            onClick={() =>
                                                                setLineas(
                                                                    (current) =>
                                                                        current.filter(
                                                                            (
                                                                                _,
                                                                                lineIndex,
                                                                            ) =>
                                                                                lineIndex !==
                                                                                index,
                                                                        ),
                                                                )
                                                            }
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
                                        disabled={
                                            lineas.length >=
                                            catalogs.articulos.length
                                        }
                                        onClick={() =>
                                            setLineas((current) => [
                                                ...current,
                                                emptyLine(),
                                            ])
                                        }
                                    >
                                        + Agregar artículo
                                    </button>
                                    {tipo === 'compra' && (
                                        <p className="entry-total">
                                            Total estimado{' '}
                                            <strong>
                                                {formatMoney(totalEstimado)}
                                            </strong>
                                        </p>
                                    )}
                                </div>
                            </section>

                            <div className="entry-submit-row">
                                <p>
                                    El registro, sus líneas y el incremento de
                                    stock se guardan juntos.
                                </p>
                                <button
                                    className="users-add-button"
                                    type="submit"
                                    disabled={
                                        loading ||
                                        submitting ||
                                        catalogs.articulos.length === 0
                                    }
                                >
                                    {submitting
                                        ? 'Registrando…'
                                        : tipo === 'compra'
                                          ? 'Confirmar compra'
                                          : 'Confirmar donación'}
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </>
    );
}
