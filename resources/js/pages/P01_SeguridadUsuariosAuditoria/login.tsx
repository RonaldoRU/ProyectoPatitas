import { Head, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import BrandPanel from '@/components/BrandPanel';
import LegalComplianceModal from '@/components/LegalComplianceModal';
import LoginForm from '@/components/LoginForm';
import PublicDonationModal from '@/components/PublicDonationModal';
import '../../../css/login.css';

export default function Login() {
    const [mostrarMarcoLegal, setMostrarMarcoLegal] = useState(false);
    const [mostrarDonar, setMostrarDonar] = useState(false);
    const [modoAcceso, setModoAcceso] = useState<'login' | 'registro'>('login');
    const [usuarioLogueado, setUsuarioLogueado] = useState<{ nombre: string; rol: string } | null>(null);
    const [tiempoEnLinea, setTiempoEnLinea] = useState<string>('00:00:00');

    // Comprobar si el usuario ya tiene sesión activa para no botarlo
    useEffect(() => {
        try {
            const token = localStorage.getItem('token');
            const userStr = localStorage.getItem('user');
            if (token && userStr) {
                const user = JSON.parse(userStr);
                setUsuarioLogueado(user);

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
                    setTiempoEnLinea(
                        `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
                    );
                };
                updateTimer();
                const interval = setInterval(updateTimer, 1000);
                return () => clearInterval(interval);
            }
        } catch {
            // Continuar mostrando el formulario si hay datos corruptos
        }
    }, []);

    const handleIrAAcceso = (modo: 'login' | 'registro') => {
        setModoAcceso(modo);
        const el = document.getElementById('apartado-acceso');
        if (el) {
            el.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    };

    const obtenerRutaContinuar = (rol?: string) => {
        const r = (rol || '').trim().toLowerCase();
        if (r === 'donante' || r === 'postulante') {
            return '/mascotas';
        }
        if (r.includes('veterinari')) {
            return '/atenciones-clinicas';
        }
        if (r.includes('recepcion') || r.includes('voluntar')) {
            return '/articulos-inventario';
        }
        return '/dashboard';
    };

    return (
        <>
            <Head title="Refugio Angelitos de Edgar - Portal e Inicio de Sesión" />
            <main className="login-screen">
                {/* Columna izquierda: Portal informativo dinámico con foto proporcionada, logo oficial y mascotas reales */}
                <BrandPanel
                    onOpenDonar={() => setMostrarDonar(true)}
                    onOpenMarcoLegal={() => setMostrarMarcoLegal(true)}
                    onIrAAcceso={handleIrAAcceso}
                />

                {/* Columna derecha: Apartado de Inicio de Sesión / Creación de Cuenta o Sesión Activa */}
                <div className="login-access-column">
                    {usuarioLogueado ? (
                        <div className="active-session-card" id="apartado-acceso">
                            <img
                                src="/images/logo-refugio-angelitos.jpg"
                                alt="Logotipo Refugio Angelitos de Edgar"
                                style={{
                                    width: '64px',
                                    height: '64px',
                                    borderRadius: '50%',
                                    objectFit: 'cover',
                                    border: '2px solid #165b4c',
                                    margin: '0 auto 14px',
                                    display: 'block',
                                }}
                            />
                            <h2 style={{ fontSize: '20px', color: '#12354a', margin: '0 0 6px', fontWeight: 800 }}>
                                Sesión Activa en el Refugio
                            </h2>
                            <p style={{ fontSize: '13px', color: '#52635c', margin: '0 0 18px' }}>
                                Conectado como <strong>{usuarioLogueado.nombre}</strong> ({usuarioLogueado.rol}). Tu sesión permanece abierta.
                            </p>

                            {/* Cronómetro en vivo con tipografía monospaciada uniforme y sin fondo de color */}
                            <div style={{ backgroundColor: '#ffffff', border: '1px solid #dde1e4', borderRadius: '10px', padding: '14px', marginBottom: '18px' }}>
                                <span style={{ fontSize: '11.5px', fontWeight: 700, color: '#526068', textTransform: 'uppercase', display: 'block', letterSpacing: '0.06em' }}>
                                    Tiempo Conectado en la Plataforma
                                </span>
                                <span style={{ fontSize: '20px', fontWeight: 700, color: '#12354a', fontFamily: 'var(--font-mono)', fontVariantNumeric: 'tabular-nums' }}>
                                    {tiempoEnLinea}
                                </span>
                            </div>

                            <button
                                type="button"
                                onClick={() => router.visit(obtenerRutaContinuar(usuarioLogueado.rol))}
                                style={{ width: '100%', padding: '12px', borderRadius: '8px', border: 'none', backgroundColor: '#12354a', color: '#ffffff', fontWeight: 700, fontSize: '14px', cursor: 'pointer', marginBottom: '10px' }}
                            >
                                Ir a mi Panel del Refugio
                            </button>

                            <button
                                type="button"
                                onClick={() => {
                                    localStorage.removeItem('token');
                                    localStorage.removeItem('user');
                                    localStorage.removeItem('session_login_time');
                                    setUsuarioLogueado(null);
                                }}
                                style={{ width: '100%', padding: '10px', borderRadius: '8px', border: '1px solid #cbd5e1', backgroundColor: '#ffffff', color: '#475569', fontWeight: 600, fontSize: '13px', cursor: 'pointer' }}
                            >
                                Cerrar Sesión para Cambiar de Cuenta
                            </button>
                        </div>
                    ) : (
                        <LoginForm
                            modoExterno={modoAcceso}
                            onCambiarModo={setModoAcceso}
                        />
                    )}
                </div>
            </main>

            <LegalComplianceModal open={mostrarMarcoLegal} onClose={() => setMostrarMarcoLegal(false)} />
            <PublicDonationModal open={mostrarDonar} onClose={() => setMostrarDonar(false)} />
        </>
    );
}
