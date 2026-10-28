import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { dashboard as dashboardApi } from '@/routes/api';
import { index as inventoryPage } from '@/routes/articulos-inventario';
import { index as clinicalPage } from '@/routes/atenciones-clinicas';
import { index as auditPage } from '@/routes/bitacora';
import { index as entryPage } from '@/routes/entradas-insumos';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as stockoutPage } from '@/routes/salidas-inventario';
import { index as usersPage } from '@/routes/usuarios';
import authService from '@/services/authService';
import type {AuthenticatedUser} from '@/services/authService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

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
    alertas_vencimiento: {
        proximos: ExpiryAlert[];
        vencidos: ExpiryAlert[];
        sin_fecha: ExpiryAlert[];
    };
    user: Pick<AuthenticatedUser, 'nombre' | 'rol'>;
};

type ExpiryAlert = {
    id: number;
    articulo: string;
    origen: string;
    fecha_vencimiento: string | null;
    dias_restantes: number | null;
    cantidad_disponible: string;
    unidad_medida: string;
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
    setError('');
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
        const intervalId = window.setInterval(() => {
            void loadDashboard();
        }, 60_000);

        return () => {
            active = false;
            window.clearInterval(intervalId);
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
    const expiryGroups: Array<{ key: string; title: string; alerts: ExpiryAlert[] }> = [
        { key: 'vencidos', title: 'Vencidos', alerts: data?.alertas_vencimiento.vencidos ?? [] },
        { key: 'proximos', title: 'Vencen en 30 días', alerts: data?.alertas_vencimiento.proximos ?? [] },
        { key: 'sin_fecha', title: 'Sin fecha de vencimiento', alerts: data?.alertas_vencimiento.sin_fecha ?? [] },
    ];

    return (
        <>
            <Head title="Inicio" />
            <div className="dashboard-app">
                <main className="dashboard-main">
                    <DashboardTopNav title="Inicio" alertasStock={stats.alertas_stock} user={user} />

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

                        {(user.rol === 'Administrador' || user.rol === 'Veterinario') && (
                            <section className="dashboard-expiry" aria-label="Alertas de vencimiento de medicamentos">
                                <div className="dashboard-section-heading">
                                    <div>
                                        <p className="dashboard-eyebrow">Control de medicamentos</p>
                                        <h2>Vencimientos y lotes por revisar</h2>
                                    </div>
                                </div>
                                {loading ? (
                                    <p className="dashboard-expiry__empty" role="status">Cargando alertas…</p>
                                ) : (
                                    <div className="dashboard-expiry__grid">
                                        {expiryGroups.map(({ key, title, alerts }) => (
                                            <article className={`dashboard-expiry__group dashboard-expiry__group--${key}`} key={key}>
                                                <h3>{title} <span>{alerts.length}</span></h3>
                                                {alerts.length === 0 ? (
                                                    <p className="dashboard-expiry__empty">Sin lotes pendientes.</p>
                                                ) : (
                                                    <ul>
                                                        {alerts.map((alert) => (
                                                            <li key={alert.id}>
                                                                <strong>{alert.articulo}</strong>
                                                                <span>
                                                                    {alert.fecha_vencimiento
                                                                        ? `Vence: ${formatDate(alert.fecha_vencimiento)}`
                                                                        : 'Fecha no registrada'}
                                                                    {' · '}{alert.cantidad_disponible} {alert.unidad_medida}
                                                                </span>
                                                                <small>Lote #{alert.id} · {alert.origen}</small>
                                                            </li>
                                                        ))}
                                                    </ul>
                                                )}
                                            </article>
                                        ))}
                                    </div>
                                )}
                            </section>
                        )}

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
