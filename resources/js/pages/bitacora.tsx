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
import bitacoraService from '@/services/bitacoraService';
import type { AuditEntry, AuditFilters, AuditPage } from '@/services/bitacoraService';
import '../../css/dashboard.css';
import '../../css/bitacora.css';

const initialFilters: AuditFilters = {
    usuario: '',
    accion: '',
    modulo: '',
    buscar: '',
    desde: '',
    hasta: '',
};

const emptyPage: AuditPage = {
    data: [],
    current_page: 1,
    last_page: 1,
    total: 0,
};

function formatDateTime(value: string): string {
    return new Intl.DateTimeFormat('es-BO', {
        dateStyle: 'medium',
        timeStyle: 'short',
    }).format(new Date(value));
}

export default function Bitacora() {
    const [filters, setFilters] = useState(initialFilters);
    const [appliedFilters, setAppliedFilters] = useState(initialFilters);
    const [page, setPage] = useState(emptyPage);
    const [currentPage, setCurrentPage] = useState(1);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        let active = true;
        let timer: number | undefined;
        let controller: AbortController | null = null;
        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return () => {
                active = false;
            };
        }

        const accessToken = token;

        async function loadAuditLog(showLoading: boolean): Promise<void> {
            controller = new AbortController();

            if (showLoading) {
                setLoading(true);
            }

            try {
                const result = await bitacoraService.index(
                    accessToken,
                    appliedFilters,
                    currentPage,
                    controller.signal,
                );

                if (active) {
                    setPage(result);
                    setError('');
                }
            } catch (cause) {
                if (cause instanceof DOMException && cause.name === 'AbortError') {
                    return;
                }

                if (cause instanceof Error && cause.message === 'Unauthenticated.') {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(cause instanceof Error ? cause.message : 'No se pudo consultar la bitácora.');
                }
            } finally {
                if (active) {
                    setLoading(false);

                    if (currentPage === 1) {
                        timer = window.setTimeout(() => {
                            void loadAuditLog(false);
                        }, 10_000);
                    }
                }
            }
        }

        void loadAuditLog(true);

        return () => {
            active = false;
            window.clearTimeout(timer);
            controller?.abort();
        };
    }, [appliedFilters, currentPage]);

    function applyFilters(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setCurrentPage(1);
        setAppliedFilters({ ...filters });
    }

    function clearFilters() {
        setFilters(initialFilters);
        setCurrentPage(1);
        setAppliedFilters(initialFilters);
    }

    function goToPage(nextPage: number) {
        if (nextPage < 1 || nextPage > page.last_page || nextPage === currentPage) {
            return;
        }

        setLoading(true);
        setCurrentPage(nextPage);
    }

    return (
        <>
            <Head title="Auditoría de seguridad" />
            <div className="dashboard-app">
                <aside className="dashboard-sidebar">
                    <Link className="dashboard-brand" href={dashboardPage.url()}>
                        <span className="dashboard-brand__badge">LA</span>
                        <span className="dashboard-brand__name">Los Angelitos</span>
                    </Link>

                    <nav className="dashboard-nav" aria-label="Navegación principal">
                        <Link className="dashboard-nav__item" href={dashboardPage.url()}>
                            <span aria-hidden="true">⌂</span>
                            <span>Inicio</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#ingresos`}>
                            <span aria-hidden="true">✿</span>
                            <span>Animales</span>
                        </Link>
                        <span className="dashboard-nav__item dashboard-nav__item--disabled" aria-disabled="true">
                            <span aria-hidden="true">♡</span>
                            <span>Adopciones</span>
                        </span>
                        <Link className="dashboard-nav__item" href={applicantsPage.url()}>
                            <span aria-hidden="true">♧</span>
                            <span>Postulantes</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={inventoryPage.url()}>
                            <span aria-hidden="true">◇</span>
                            <span>Inventario</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={entryPage.url()}>
                            <span aria-hidden="true">▤</span>
                            <span>Entradas</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={stockoutPage.url()}>
                            <span aria-hidden="true">↗</span>
                            <span>Salidas</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={clinicalPage.url()}>
                            <span aria-hidden="true">✚</span>
                            <span>Atención clínica</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={usersPage.url()}>
                            <span aria-hidden="true">▣</span>
                            <span>Usuarios</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item dashboard-nav__item--active"
                            href={auditPage.url()}
                            aria-current="page"
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

                <main className="dashboard-main audit-main">
                    <header className="dashboard-topbar">
                        <h1>Auditoría de seguridad</h1>
                        <div className="dashboard-topbar__actions">
                            <span className="audit-topbar-label">Registro de actividad</span>
                        </div>
                    </header>

                    <div className="dashboard-content audit-content">
                        <section className="audit-heading">
                            <p className="dashboard-eyebrow">Administración del refugio</p>
                            <h2>Bitácora de auditoría</h2>
                            <p>Consulta cronológica de operaciones completadas en el sistema.</p>
                            <span className="audit-refresh-indicator">Actualización automática cada 10 segundos en la primera página</span>
                        </section>

                        <form className="audit-filters" onSubmit={applyFilters}>
                            <div className="audit-filter-field">
                                <label htmlFor="audit-search">Búsqueda</label>
                                <input
                                    id="audit-search"
                                    type="search"
                                    value={filters.buscar}
                                    onChange={(event) => setFilters({ ...filters, buscar: event.target.value })}
                                    placeholder="Descripción o referencia"
                                />
                            </div>
                            <div className="audit-filter-field">
                                <label htmlFor="audit-user">Usuario</label>
                                <input
                                    id="audit-user"
                                    type="search"
                                    value={filters.usuario}
                                    onChange={(event) => setFilters({ ...filters, usuario: event.target.value })}
                                    placeholder="Nombre del usuario"
                                />
                            </div>
                            <div className="audit-filter-field">
                                <label htmlFor="audit-module">Módulo</label>
                                <select
                                    id="audit-module"
                                    value={filters.modulo}
                                    onChange={(event) => setFilters({ ...filters, modulo: event.target.value })}
                                >
                                    <option value="">Todos</option>
                                    <option value="autenticacion">Autenticación</option>
                                    <option value="usuarios">Usuarios</option>
                                    <option value="adopciones">Adopciones</option>
                                    <option value="mascotas">Mascotas</option>
                                    <option value="historiales_clinicos">Historial clínico</option>
                                    <option value="donaciones">Donaciones</option>
                                    <option value="inventario">Inventario</option>
                                </select>
                            </div>
                            <div className="audit-filter-field">
                                <label htmlFor="audit-action">Acción</label>
                                <input
                                    id="audit-action"
                                    type="search"
                                    value={filters.accion}
                                    onChange={(event) => setFilters({ ...filters, accion: event.target.value })}
                                    placeholder="Ej. Registrar usuario"
                                    list="audit-action-options"
                                />
                                <datalist id="audit-action-options">
                                    <option value="Iniciar sesión" />
                                    <option value="Cerrar sesión" />
                                    <option value="Restablecer contraseña" />
                                    <option value="Intento de inicio de sesión rechazado" />
                                    <option value="Registrar usuario" />
                                    <option value="Modificar datos de usuario" />
                                    <option value="Cambiar rol de usuario" />
                                    <option value="Suspender cuenta de usuario" />
                                    <option value="Reactivar cuenta de usuario" />
                                    <option value="Registrar postulante" />
                                    <option value="Modificar postulante" />
                                    <option value="Registrar adopción" />
                                </datalist>
                            </div>
                            <div className="audit-filter-field">
                                <label htmlFor="audit-from">Desde</label>
                                <input
                                    id="audit-from"
                                    type="date"
                                    value={filters.desde}
                                    onChange={(event) => setFilters({ ...filters, desde: event.target.value })}
                                />
                            </div>
                            <div className="audit-filter-field">
                                <label htmlFor="audit-to">Hasta</label>
                                <input
                                    id="audit-to"
                                    type="date"
                                    value={filters.hasta}
                                    onChange={(event) => setFilters({ ...filters, hasta: event.target.value })}
                                />
                            </div>
                            <div className="audit-filter-actions">
                                <button className="audit-filter-submit" type="submit">Filtrar</button>
                                <button className="audit-filter-clear" type="button" onClick={clearFilters}>Limpiar</button>
                            </div>
                        </form>

                        {error && <p className="audit-feedback audit-feedback--error" role="alert">{error}</p>}

                        <section className="audit-table-wrap" aria-label="Registro de acciones">
                            <table className="audit-table">
                                <thead>
                                    <tr>
                                        <th scope="col">ID</th>
                                        <th scope="col">Fecha y hora</th>
                                        <th scope="col">Usuario</th>
                                        <th scope="col">Acción</th>
                                        <th scope="col">Módulo</th>
                                        <th scope="col">Descripción / entidad</th>
                                        <th scope="col">Resultado</th>
                                        <th scope="col">Solicitud</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr><td className="audit-table-state" colSpan={8}>Cargando registros…</td></tr>
                                    ) : page.data.length === 0 ? (
                                        <tr><td className="audit-table-state" colSpan={8}>No hay acciones que coincidan con los filtros.</td></tr>
                                    ) : (
                                        page.data.map((entry: AuditEntry) => (
                                            <tr key={entry.id}>
                                                <td>{entry.id}</td>
                                                <td>{formatDateTime(entry.fecha_hora)}</td>
                                                <td className="audit-table-user">{entry.usuario}</td>
                                                <td><span className="audit-action-badge">{entry.tipo_accion}</span></td>
                                                <td>{entry.modulo}</td>
                                                <td>
                                                    {entry.descripcion || '—'}
                                                    {entry.entidad_tipo && <small className="audit-entity-reference">{entry.entidad_tipo} #{entry.entidad_id}</small>}
                                                    {entry.contexto && Object.entries(entry.contexto).map(([key, value]) => (
                                                        <small className="audit-entity-reference" key={key}>
                                                            {key.replaceAll('_', ' ')}:{' '}
                                                            {Array.isArray(value)
                                                                ? value.join(', ')
                                                                : typeof value === 'boolean'
                                                                    ? (value ? 'Sí' : 'No')
                                                                    : (value ?? '—')}
                                                        </small>
                                                    ))}
                                                </td>
                                                <td>
                                                    <span className={`audit-result-badge audit-result-badge--${entry.resultado}`}>
                                                        {entry.resultado === 'exitosa' ? 'Exitosa' : 'Fallida'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span className="audit-request-details">{entry.http_method || '—'} {entry.ruta || ''}</span>
                                                    <small className="audit-entity-reference">{entry.ip || 'IP no disponible'}</small>
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </section>

                        <footer className="audit-pagination">
                            <span>
                                {page.total} {page.total === 1 ? 'registro' : 'registros'}
                                {page.last_page > 1 && ` · Página ${page.current_page} de ${page.last_page}`}
                            </span>
                            <div>
                                <button type="button" onClick={() => goToPage(currentPage - 1)} disabled={loading || currentPage <= 1}>
                                    Anterior
                                </button>
                                <button type="button" onClick={() => goToPage(currentPage + 1)} disabled={loading || currentPage >= page.last_page}>
                                    Siguiente
                                </button>
                            </div>
                        </footer>
                    </div>
                </main>
            </div>
        </>
    );
}
