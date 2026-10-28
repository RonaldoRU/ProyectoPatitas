import { Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import authService from '@/services/authService';
import type { AuthenticatedUser } from '@/services/authService';
import MenuHamburguesa from './MenuHamburguesa';

interface DashboardTopNavProps {
    title: string;
    alertasStock?: number;
    user?: Pick<AuthenticatedUser, 'nombre' | 'rol'>;
}

function getInitials(name: string): string {
    return name
        .trim()
        .split(/\s+/)
        .slice(0, 2)
        .map((part) => part[0] ?? '')
        .join('')
        .toUpperCase();
}

export default function DashboardTopNav({ title, alertasStock = 0, user }: DashboardTopNavProps) {
    const [menuAbierto, setMenuAbierto] = useState(false);
    const [currentUser, setCurrentUser] = useState(user ?? { nombre: 'Usuario', rol: '' });
    const [loggingOut, setLoggingOut] = useState(false);

    useEffect(() => {
        if (!user) {
            const token = localStorage.getItem('token');
            if (token) {
                fetch('/api/dashboard', {
                    headers: {
                        Accept: 'application/json',
                        Authorization: `Bearer ${token}`,
                    },
                })
                    .then((r) => r.ok ? r.json() : null)
                    .then((data) => {
                        if (data?.user) setCurrentUser(data.user);
                    })
                    .catch(() => {});
            }
        } else {
            setCurrentUser(user);
        }
    }, [user]);

    const logout = async () => {
        const token = localStorage.getItem('token');
        setLoggingOut(true);
        try {
            if (token) await authService.logout(token);
        } catch (e) {
            console.error(e);
        } finally {
            localStorage.removeItem('token');
            router.visit(loginPage.url());
        }
    };

    const firstName = currentUser.nombre.trim().split(/\s+/)[0] || 'Usuario';

    return (
        <>
            <header className="dashboard-topbar">
                <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
                    {/* Botón Menú Hamburguesa */}
                    <button
                        type="button"
                        onClick={() => setMenuAbierto(true)}
                        aria-label="Abrir menú de módulos"
                        title="Ver módulos P1 a P10"
                        style={{
                            width: '40px',
                            height: '40px',
                            borderRadius: '8px',
                            border: '1px solid var(--dashboard-forest)',
                            backgroundColor: 'var(--dashboard-forest)',
                            color: '#ffffff',
                            display: 'flex',
                            flexDirection: 'column',
                            justifyContent: 'center',
                            alignItems: 'center',
                            gap: '4px',
                            cursor: 'pointer',
                            padding: '9px',
                            transition: 'all 0.15s ease',
                        }}
                        onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = 'var(--dashboard-forest-light)')}
                        onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = 'var(--dashboard-forest)')}
                    >
                        <span style={{ display: 'block', width: '18px', height: '2px', backgroundColor: '#ffffff', borderRadius: '1px' }} />
                        <span style={{ display: 'block', width: '18px', height: '2px', backgroundColor: '#e1e89f', borderRadius: '1px' }} />
                        <span style={{ display: 'block', width: '18px', height: '2px', backgroundColor: '#ffffff', borderRadius: '1px' }} />
                    </button>

                    {/* Branding Los Angelitos */}
                    <Link
                        href={dashboardPage.url()}
                        className="dashboard-brand"
                        style={{ padding: 0, textDecoration: 'none', color: 'inherit' }}
                    >
                        <span className="dashboard-brand__badge">LA</span>
                        <span className="dashboard-brand__name">Los Angelitos</span>
                    </Link>

                    <span style={{ color: 'var(--dashboard-line)', fontSize: '18px', margin: '0 4px' }}>/</span>

                    <h1 style={{ margin: 0, fontSize: '15px', fontWeight: 700, color: 'var(--dashboard-ink)' }}>
                        {title}
                    </h1>
                </div>

                <div className="dashboard-topbar__actions">
                    <Link
                        className="dashboard-alert-link"
                        href="/dashboard#inventario"
                        aria-label={`${alertasStock} alertas de stock`}
                        title="Ver alertas de stock"
                    >
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M6 9a6 6 0 1 1 12 0c0 4 1.5 5.5 1.5 5.5H4.5S6 13 6 9Z" />
                            <path d="M10 18a2 2 0 0 0 4 0" />
                        </svg>
                        {alertasStock > 0 && <span className="dashboard-alert-link__dot" />}
                    </Link>

                    <div className="dashboard-user">
                        <span className="dashboard-user__avatar">{getInitials(currentUser.nombre)}</span>
                        <span className="dashboard-user__details">
                            <strong>{firstName}</strong>
                            <span>{currentUser.rol}</span>
                        </span>
                    </div>

                    <button
                        className="dashboard-logout"
                        type="button"
                        onClick={logout}
                        disabled={loggingOut}
                    >
                        {loggingOut ? 'Saliendo…' : 'Salir'}
                    </button>
                </div>
            </header>

            {/* Menú Hamburguesa Drawer */}
            <MenuHamburguesa abierto={menuAbierto} onClose={() => setMenuAbierto(false)} />
        </>
    );
}
