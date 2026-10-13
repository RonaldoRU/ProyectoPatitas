import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { dashboard as dashboardApi } from '@/routes/api';
import { index as auditPage } from '@/routes/bitacora';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as usersPage } from '@/routes/usuarios';
import authService from '@/services/authService';
import type {AuthenticatedUser} from '@/services/authService';
import '../../css/dashboard.css';

type DashboardData = {
    stats: {
        animales_refugio: number;
        listos_adopcion: number;
        adopciones_mes: number;
        alertas_stock: number;
    };
    ultimos_ingresos: Array<{
        nombre: string;
        especie: string;
        zona_rescate: string | null;
        fecha_ingreso: string;
        estado_actual: string;
    }>;
    user: Pick<AuthenticatedUser, 'nombre' | 'rol'>;
};

const emptyStats: DashboardData['stats'] = {
    animales_refugio: 0,
    listos_adopcion: 0,
    adopciones_mes: 0,
    alertas_stock: 0,
};

function getInitials(name: string): string {
    return name
        .trim()
        .split(/\s+/)
        .slice(0, 2)
        .map((part) => part[0] ?? '')
        .join('')
        .toUpperCase();
}

function getStatus(status: string): { label: string; className: string } {
    if (status === 'Disponible') {
        return { label: 'Listo', className: 'status-tag status-tag--ready' };
    }

    if (status === 'Adoptado') {
        return { label: 'Adoptado', className: 'status-tag status-tag--adopted' };
    }

    if (status === 'Fallecido') {
        return { label: 'Fallecido', className: 'status-tag status-tag--closed' };
    }

    return { label: 'En tratamiento', className: 'status-tag status-tag--care' };
}

function formatDate(value: string): string {
    const date = new Date(`${value.slice(0, 10)}T12:00:00`);

    if (Number.isNaN(date.getTime())) {
return value;
}

    return date.toLocaleDateString('es-BO', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
    });
}

export default function Dashboard() {
    const [data, setData] = useState<DashboardData | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [loggingOut, setLoggingOut] = useState(false);

    useEffect(() => {
        let active = true;
        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return () => {
                active = false;
            };
        }

        async function loadDashboard() {
            try {
                const response = await fetch(dashboardApi.url(), {
                    headers: {
                        Accept: 'application/json',
                        Authorization: `Bearer ${token}`,
                    },
                });

                if (response.status === 401) {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (!response.ok) {
                    throw new Error('No se pudieron cargar los datos del refugio.');
                }

                const result = (await response.json()) as DashboardData;

                if (active) {
setData(result);
}
            } catch (cause) {
                if (active) {
                    setError(
                        cause instanceof Error
                            ? cause.message
                            : 'No se pudo conectar con el servidor.',
                    );
                }
            } finally {
                if (active) {
setLoading(false);
}
            }
        }

        void loadDashboard();

        return () => {
            active = false;
        };
    }, []);

    async function logout() {
        const token = localStorage.getItem('token');
        setLoggingOut(true);

        try {
            if (token) {
await authService.logout(token);
}
        } catch (cause) {
            console.error(cause);
        } finally {
            localStorage.removeItem('token');
            router.visit(loginPage.url());
        }
    }

    const stats = data?.stats ?? emptyStats;
    const user = data?.user ?? { nombre: 'Cargando...', rol: '' };
    const firstName = user.nombre.trim().split(/\s+/)[0] || 'equipo';

    return (
        <>
            <Head title="Inicio" />
            <div className="dashboard-app">
                <aside className="dashboard-sidebar">
                    <Link className="dashboard-brand" href={dashboardPage.url()}>
                        <span className="dashboard-brand__badge">LA</span>
                        <span className="dashboard-brand__name">Los Angelitos</span>
                    </Link>

                    <nav className="dashboard-nav" aria-label="Navegación principal">
                        <Link
                            className="dashboard-nav__item dashboard-nav__item--active"
                            href={dashboardPage.url()}
                            aria-current="page"
                        >
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 11.5 12 4l8 7.5M6 10v9h5v-5h2v5h5v-9" />
                            </svg>
                            <span>Inicio</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#ingresos`}>
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <ellipse cx="12" cy="16" rx="6" ry="5" />
                                <ellipse cx="5.5" cy="8.5" rx="2.2" ry="3" />
                                <ellipse cx="10.5" cy="5.3" rx="2.2" ry="3" />
                                <ellipse cx="15.3" cy="6.3" rx="2" ry="2.7" />
                                <ellipse cx="18.7" cy="9.8" rx="1.9" ry="2.5" />
                            </svg>
                            <span>Animales</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#adopciones`}>
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10Z" />
                            </svg>
                            <span>Adopciones</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={applicantsPage.url()}>
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="9" cy="8" r="3" />
                                <path d="M3.5 19v-1.5a5.5 5.5 0 0 1 11 0V19M16 5.5a3 3 0 0 1 0 5.8M17 14a4 4 0 0 1 3.5 4v1" />
                            </svg>
                            <span>Postulantes</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#inventario`}>
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5v-9Z" />
                                <path d="m4.5 7.8 7.5 4.3 7.5-4.3M12 12v8.5M8 5.3l8 4.6" />
                            </svg>
                            <span>Inventario</span>
                        </Link>
                        <span className="dashboard-nav__item dashboard-nav__item--disabled" aria-disabled="true">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 7h16v12H4zM7 7V4h10v3M8 11h8M8 15h5" />
                            </svg>
                            <span>Donaciones</span>
                        </span>
                        <Link className="dashboard-nav__item" href={usersPage.url()}>
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <rect x="4" y="5" width="16" height="14" rx="1" />
                                <circle cx="9" cy="11" r="2" />
                                <path d="M6.5 16a2.5 2.5 0 0 1 5 0M14 10h3M14 14h3" />
                            </svg>
                            <span>Usuarios</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={auditPage.url()}>
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="8.5" />
                                <path d="M12 7.5V12l3 2" />
                            </svg>
                            <span>Bitácora</span>
                        </Link>
                    </nav>

                    <div className="dashboard-sidebar__foot">
                        Refugio Los Angelitos de Edgar
                        <span>Santa Cruz de la Sierra</span>
                    </div>
                </aside>

                <main className="dashboard-main">
                    <header className="dashboard-topbar">
                        <h1>Inicio</h1>
                        <div className="dashboard-topbar__actions">
                            <a
                                className="dashboard-alert-link"
                                href="#inventario"
                                aria-label={`${stats.alertas_stock} alertas de stock`}
                                title="Ver alertas de stock"
                            >
                                <svg viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M6 9a6 6 0 1 1 12 0c0 4 1.5 5.5 1.5 5.5H4.5S6 13 6 9Z" />
                                    <path d="M10 18a2 2 0 0 0 4 0" />
                                </svg>
                                {stats.alertas_stock > 0 && <span className="dashboard-alert-link__dot" />}
                            </a>
                            <div className="dashboard-user">
                                <span className="dashboard-user__avatar">{getInitials(user.nombre)}</span>
                                <span className="dashboard-user__details">
                                    <strong>{firstName}</strong>
                                    <span>{user.rol}</span>
                                </span>
                            </div>
                            <button
                                className="dashboard-logout"
                                type="button"
                                onClick={() => void logout()}
                                disabled={loggingOut}
                            >
                                {loggingOut ? 'Saliendo…' : 'Salir'}
                            </button>
                        </div>
                    </header>

                    <div className="dashboard-content">
                        <section className="dashboard-intro">
                            <p className="dashboard-eyebrow">Resumen del refugio</p>
                            <h2>Buenos días, {firstName}</h2>
                            <p>Esto es lo que está pasando hoy en el refugio.</p>
                        </section>

                        {error && (
                            <div className="dashboard-error" role="alert">
                                <span>{error}</span>
                                <button type="button" onClick={() => window.location.reload()}>
                                    Reintentar
                                </button>
                            </div>
                        )}

                        <section className="dashboard-stats" aria-label="Indicadores del refugio">
                            <article className="dashboard-stat">
                                <span className="dashboard-stat__number">
                                    {loading ? '—' : stats.animales_refugio}
                                </span>
                                <span className="dashboard-stat__label">Animales en refugio</span>
                                <span className="dashboard-stat__detail">Bajo cuidado activo</span>
                            </article>
                            <article className="dashboard-stat">
                                <span className="dashboard-stat__number">
                                    {loading ? '—' : stats.listos_adopcion}
                                </span>
                                <span className="dashboard-stat__label">Listos para adopción</span>
                                <span className="dashboard-stat__detail">Disponibles actualmente</span>
                            </article>
                            <article className="dashboard-stat">
                                <span className="dashboard-stat__number">
                                    {loading ? '—' : stats.adopciones_mes}
                                </span>
                                <span className="dashboard-stat__label">Adopciones este mes</span>
                                <span className="dashboard-stat__detail">Familias y mascotas</span>
                            </article>
                            <article className="dashboard-stat" id="inventario">
                                <span
                                    className={`dashboard-stat__number${stats.alertas_stock > 0 ? ' dashboard-stat__number--alert' : ''}`}
                                >
                                    {loading ? '—' : stats.alertas_stock}
                                </span>
                                <span className="dashboard-stat__label">Alertas de stock</span>
                                <span className="dashboard-stat__detail">Productos bajo mínimo</span>
                            </article>
                        </section>

                        <section className="dashboard-intakes" id="ingresos">
                            <div className="dashboard-section-heading">
                                <div>
                                    <p className="dashboard-eyebrow">Actividad reciente</p>
                                    <h2>Últimos ingresos</h2>
                                </div>
                                <span className="dashboard-section-heading__count">
                                    {data?.ultimos_ingresos.length ?? 0} registros
                                </span>
                            </div>

                            <div className="intake-table" role="table" aria-label="Últimos ingresos al refugio">
                                <div className="intake-table__head" role="row">
                                    <span role="columnheader">Animal</span>
                                    <span role="columnheader">Zona de rescate</span>
                                    <span role="columnheader">Fecha de ingreso</span>
                                    <span role="columnheader">Estado</span>
                                </div>

                                {loading ? (
                                    <div className="intake-empty" role="status">Cargando ingresos…</div>
                                ) : data?.ultimos_ingresos.length ? (
                                    data.ultimos_ingresos.map((animal) => {
                                        const status = getStatus(animal.estado_actual);

                                        return (
                                            <div
                                                className="intake-table__row"
                                                role="row"
                                                key={`${animal.nombre}-${animal.fecha_ingreso}`}
                                            >
                                                <span className="intake-animal" role="cell">
                                                    <strong>{animal.nombre}</strong>
                                                    <span>{animal.especie}</span>
                                                </span>
                                                <span className="intake-zone" role="cell">
                                                    {animal.zona_rescate || 'Sin zona registrada'}
                                                </span>
                                                <span className="intake-date" role="cell">
                                                    {formatDate(animal.fecha_ingreso)}
                                                </span>
                                                <span role="cell">
                                                    <span className={status.className}>{status.label}</span>
                                                </span>
                                            </div>
                                        );
                                    })
                                ) : (
                                    <div className="intake-empty" role="status">
                                        No hay ingresos recientes.
                                    </div>
                                )}
                            </div>
                        </section>
                    </div>
                </main>
            </div>
        </>
    );
}