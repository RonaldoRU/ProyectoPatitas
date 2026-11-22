import { Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import authService from '@/services/authService';
import type { AuthenticatedUser } from '@/services/authService';
import LegalComplianceModal from './LegalComplianceModal';
import MenuHamburguesa from './MenuHamburguesa';
import VoiceCommandAssistant from './VoiceCommandAssistant';

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

/**
 * Componente DashboardTopNav: Barra superior de navegación unificada para todas las páginas del sistema.
 * Muestra el título de la vista actual, alertas de inventario, información del usuario activo,
 * botón de menú lateral (hamburguesa) y acción de cerrar sesión.
 */
export default function DashboardTopNav({ title, alertasStock = 0, user }: DashboardTopNavProps) {
    const [currentUser, setCurrentUser] = useState(user ?? { nombre: 'Usuario', rol: '' });
    const [loggingOut, setLoggingOut] = useState(false);
    const [mostrarModalSalir, setMostrarModalSalir] = useState(false);
    const [mostrarMarcoLegal, setMostrarMarcoLegal] = useState(false);
    const [tiempoConectado, setTiempoConectado] = useState<string>('00:00:00');

    // Cronómetro progresivo de tiempo conectado en la plataforma (no expira ni bota al usuario)
    useEffect(() => {
        let loginTime = localStorage.getItem('session_login_time');
        if (!loginTime) {
            loginTime = Date.now().toString();
            localStorage.setItem('session_login_time', loginTime);
        }
        const startMs = parseInt(loginTime, 10);

        const updateTimer = () => {
            const diffSeconds = Math.max(0, Math.floor((Date.now() - startMs) / 1000));
            const hours = Math.floor(diffSeconds / 3600);
            const minutes = Math.floor((diffSeconds % 3600) / 60);
            const seconds = diffSeconds % 60;
            const formatted = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
            setTiempoConectado(formatted);
        };

        updateTimer();
        const interval = setInterval(updateTimer, 1000);
        return () => clearInterval(interval);
    }, []);

    // Si no se pasaron datos de usuario por props, intenta leer de localStorage o consulta API
    useEffect(() => {
        if (!user) {
            const storedUser = localStorage.getItem('user');
            if (storedUser) {
                try {
                    const parsed = JSON.parse(storedUser);
                    if (parsed && parsed.rol) {
                        setCurrentUser(parsed);
                    }
                } catch {
                    // ignorar
                }
            }

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
                        if (data?.user) {
                            setCurrentUser(data.user);
                            localStorage.setItem('user', JSON.stringify(data.user));
                        }
                    })
                    .catch(() => {});
            }
        } else {
            setCurrentUser(user);
        }
    }, [user]);

    // Función para revocar token, limpiar almacenamiento local y volver al login
    const logout = async () => {
        const token = localStorage.getItem('token');
        setLoggingOut(true);
        try {
            if (token) await authService.logout(token);
        } catch (e) {
            console.error(e);
        } finally {
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            localStorage.removeItem('session_login_time');
            localStorage.removeItem('session_expires_at');
            router.visit(loginPage.url());
        }
    };

    const firstName = currentUser.nombre.trim().split(/\s+/)[0] || 'Usuario';

    return (
        <>
            <header className="dashboard-topbar">
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px', flexWrap: 'wrap' }}>
                    {/* Branding Oficial Refugio Angelitos de Edgar con logotipo circular */}
                    <Link
                        href={currentUser.rol === 'Administrador' ? dashboardPage.url() : '/mascotas'}
                        className="dashboard-brand"
                        style={{ padding: 0, textDecoration: 'none', color: 'inherit', display: 'inline-flex', alignItems: 'center', gap: '10px' }}
                    >
                        <img
                            src="/images/logo-refugio-angelitos.jpg"
                            alt="Logo Refugio Angelitos de Edgar"
                            style={{
                                width: '40px',
                                height: '40px',
                                borderRadius: '50%',
                                objectFit: 'cover',
                                border: '2px solid #165b4c',
                                boxShadow: '0 2px 6px rgba(18, 53, 74, 0.16)',
                                flexShrink: 0,
                            }}
                        />
                        <div style={{ display: 'flex', flexDirection: 'column', lineHeight: 1.15 }}>
                            <span className="dashboard-brand__name" style={{ fontSize: '16px', fontWeight: 800, color: '#12354a' }}>
                                Refugio Angelitos de Edgar
                            </span>
                            <span style={{ fontSize: '10.5px', fontWeight: 700, color: '#c85a44', fontStyle: 'italic' }}>
                                "Rescatados de la muerte"
                            </span>
                        </div>
                    </Link>

                    <span style={{ color: 'var(--dashboard-line)', fontSize: '18px', margin: '0 4px' }}>/</span>

                    <div style={{ display: 'inline-flex', alignItems: 'center', gap: '7px' }}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#165b4c" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                            <path d="M12 13c-2.2 0-4 1.6-4 3.5S9.8 20 12 20s4-1.6 4-3.5S14.2 13 12 13Z" />
                            <circle cx="7.5" cy="10.5" r="1.5" />
                            <circle cx="10.5" cy="8" r="1.5" />
                            <circle cx="13.5" cy="8" r="1.5" />
                            <circle cx="16.5" cy="10.5" r="1.5" />
                        </svg>
                        <h1 style={{ margin: 0, fontSize: '15px', fontWeight: 800, color: 'var(--dashboard-ink)' }}>
                            {title}
                        </h1>
                    </div>
                </div>

                <div className="dashboard-topbar__actions">
                    <button
                        type="button"
                        onClick={() => setMostrarMarcoLegal(true)}
                        title="Consultar Marco Legal Boliviano"
                        style={{
                            display: 'inline-flex',
                            alignItems: 'center',
                            gap: '6px',
                            padding: '6px 12px',
                            borderRadius: '999px',
                            border: '1px solid var(--dashboard-line)',
                            backgroundColor: '#f1f6f3',
                            color: 'var(--dashboard-forest)',
                            fontSize: '12px',
                            fontWeight: 700,
                            cursor: 'pointer',
                        }}
                    >
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                            <path d="M12 3v18M6 8l-4 8h8l-4-8zm12 0l-4 8h8l-4-8zM3 21h18" />
                        </svg>
                        <span>Marco Legal</span>
                    </button>

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
                        onClick={() => setMostrarModalSalir(true)}
                        disabled={loggingOut}
                    >
                        {loggingOut ? 'Saliendo…' : 'Salir'}
                    </button>
                </div>
            </header>

            {/* Modal de Confirmación para Salir de Sesión */}
            {mostrarModalSalir && (
                <div
                    style={{
                        position: 'fixed',
                        inset: 0,
                        zIndex: 10000,
                        backgroundColor: 'rgba(28, 43, 38, 0.65)',
                        backdropFilter: 'blur(3px)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        padding: '16px',
                    }}
                    onClick={() => setMostrarModalSalir(false)}
                >
                    <div
                        style={{
                            backgroundColor: '#ffffff',
                            borderRadius: '12px',
                            padding: '28px 24px 22px',
                            maxWidth: '420px',
                            width: '100%',
                            boxShadow: '0 20px 40px rgba(0, 0, 0, 0.25)',
                            border: '1px solid var(--dashboard-line)',
                            textAlign: 'center',
                        }}
                        onClick={(e) => e.stopPropagation()}
                    >
                        <div
                            style={{
                                width: '48px',
                                height: '48px',
                                borderRadius: '50%',
                                backgroundColor: '#fef3c7',
                                color: '#92400e',
                                display: 'grid',
                                placeItems: 'center',
                                margin: '0 auto 16px',
                            }}
                        >
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                <polyline points="16 17 21 12 16 7"></polyline>
                                <line x1="21" y1="12" x2="9" y2="12"></line>
                            </svg>
                        </div>
                        <h3 style={{ margin: '0 0 8px', fontSize: '18px', color: 'var(--dashboard-forest)' }}>
                            ¿Deseas cerrar tu sesión?
                        </h3>
                        <p style={{ margin: '0 0 24px', fontSize: '13.5px', color: 'var(--dashboard-muted)', lineHeight: 1.45 }}>
                            Puedes continuar trabajando en el refugio o cerrar tu sesión de forma segura.
                        </p>
                        <div style={{ display: 'flex', gap: '10px', justifyContent: 'center' }}>
                            <button
                                type="button"
                                onClick={() => setMostrarModalSalir(false)}
                                style={{
                                    flex: 1,
                                    padding: '10px 16px',
                                    borderRadius: '6px',
                                    border: '1px solid var(--dashboard-line)',
                                    backgroundColor: '#f8fafc',
                                    color: 'var(--dashboard-ink)',
                                    fontSize: '13px',
                                    fontWeight: 600,
                                    cursor: 'pointer',
                                    transition: 'background-color 0.12s ease',
                                }}
                                onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = '#e2e8f0')}
                                onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = '#f8fafc')}
                            >
                                Seguir trabajando
                            </button>
                            <button
                                type="button"
                                onClick={() => {
                                    setMostrarModalSalir(false);
                                    logout();
                                }}
                                disabled={loggingOut}
                                style={{
                                    flex: 1,
                                    padding: '10px 16px',
                                    borderRadius: '6px',
                                    border: 'none',
                                    backgroundColor: 'var(--dashboard-coral)',
                                    color: '#ffffff',
                                    fontSize: '13px',
                                    fontWeight: 700,
                                    cursor: 'pointer',
                                    transition: 'opacity 0.12s ease',
                                }}
                                onMouseEnter={(e) => (e.currentTarget.style.opacity = '0.9')}
                                onMouseLeave={(e) => (e.currentTarget.style.opacity = '1')}
                            >
                                {loggingOut ? 'Saliendo…' : 'Cerrar sesión'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Barra lateral de navegación con iconos y panel interactivo */}
            <MenuHamburguesa rol={currentUser.rol} tiempoConectado={tiempoConectado} />

            {/* Asistente de Comandos de Voz para Descarga de PDFs */}
            <VoiceCommandAssistant />

            {/* Modal de Marco Legal Boliviano */}
            <LegalComplianceModal open={mostrarMarcoLegal} onClose={() => setMostrarMarcoLegal(false)} />
        </>
    );
}
