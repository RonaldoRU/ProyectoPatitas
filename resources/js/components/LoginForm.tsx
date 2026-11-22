import { Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import type { FormEvent } from 'react';
import { dashboard as dashboardPage } from '@/routes';
import { recover as recoverPassword } from '@/routes/password';
import authService from '@/services/authService';
import InputField from './InputField';

interface LoginFormProps {
    modoExterno?: 'login' | 'registro';
    onCambiarModo?: (modo: 'login' | 'registro') => void;
}

/**
 * Componente LoginForm:
 * - Apartado unificado para Iniciar Sesión con una cuenta existente o Crearse una cuenta nueva
 *   como Donante o Postulante a Adopción.
 * - Estética humana, cálida y artesanal inspirada en los colores del Refugio Angelitos de Edgar.
 */
export default function LoginForm({ modoExterno, onCambiarModo }: LoginFormProps) {
    const [modoRegistro, setModoRegistro] = useState(modoExterno === 'registro');

    // Estados para Login
    const [usuario, setUsuario] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [enviando, setEnviando] = useState(false);
    const [espera, setEspera] = useState(0);

    // Estados para Crear Cuenta (Donante o Postulante)
    const [regNombre, setRegNombre] = useState('');
    const [regEmail, setRegEmail] = useState('');
    const [regTelefono, setRegTelefono] = useState('');
    const [regRol, setRegRol] = useState<'Donante' | 'Postulante'>('Postulante');
    const [regPassword, setRegPassword] = useState('');
    const [regPasswordConfirmation, setRegPasswordConfirmation] = useState('');

    useEffect(() => {
        if (modoExterno === 'registro') {
            setModoRegistro(true);
            setError('');
        } else if (modoExterno === 'login') {
            setModoRegistro(false);
            setError('');
        }
    }, [modoExterno]);

    useEffect(() => {
        if (espera <= 0) {
            return undefined;
        }

        const timer = window.setTimeout(() => {
            setEspera((actual) => Math.max(0, actual - 1));
        }, 1000);

        return () => window.clearTimeout(timer);
    }, [espera]);

    function cambiarModo(nuevoModo: boolean) {
        setError('');
        setModoRegistro(nuevoModo);
        onCambiarModo?.(nuevoModo ? 'registro' : 'login');
    }

    function redirigirPorRol(rol?: string) {
        const r = (rol || '').trim().toLowerCase();
        if (r === 'donante' || r === 'postulante') {
            router.visit('/mascotas');
        } else if (r.includes('veterinari')) {
            router.visit('/atenciones-clinicas');
        } else if (r.includes('recepcion') || r.includes('voluntar')) {
            router.visit('/articulos-inventario');
        } else {
            router.visit(dashboardPage.url());
        }
    }

    async function login(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();

        if (espera > 0) {
            return;
        }

        setError('');
        setEnviando(true);

        try {
            const response = await authService.login(usuario, password);
            localStorage.setItem('token', response.token);
            if (response.usuario) {
                localStorage.setItem('user', JSON.stringify(response.usuario));
            }
            localStorage.setItem('session_login_time', Date.now().toString());
            localStorage.removeItem('session_expires_at');
            setUsuario('');
            setPassword('');
            redirigirPorRol(response.usuario?.rol);
        } catch (cause) {
            const message =
                cause instanceof Error
                    ? cause.message
                    : 'No fue posible iniciar sesión. Inténtalo de nuevo.';
            const retryAfter =
                cause instanceof Error
                    ? (cause as Error & { retryAfter?: number }).retryAfter
                    : undefined;

            if (typeof retryAfter === 'number' && retryAfter > 0) {
                setEspera(retryAfter);
            }

            setError(message);
        } finally {
            setEnviando(false);
        }
    }

    async function registrarCuentaPublica(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');

        if (regPassword !== regPasswordConfirmation) {
            setError('Las contraseñas no coinciden.');
            return;
        }

        setEnviando(true);
        try {
            const res = await fetch('/api/registro-publico', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                },
                body: JSON.stringify({
                    nombre: regNombre,
                    email: regEmail,
                    telefono: regTelefono,
                    rol: regRol,
                    password: regPassword,
                    password_confirmation: regPasswordConfirmation,
                }),
            });

            const data = await res.json();

            if (!res.ok) {
                const firstErr =
                    data?.errors && Object.values(data.errors)[0]
                        ? (Object.values(data.errors)[0] as string[])[0]
                        : null;
                throw new Error(firstErr || data?.message || data?.mensaje || 'No se pudo crear la cuenta.');
            }

            localStorage.setItem('token', data.token);
            if (data.usuario) {
                localStorage.setItem('user', JSON.stringify(data.usuario));
            }
            localStorage.setItem('session_login_time', Date.now().toString());
            localStorage.removeItem('session_expires_at');

            router.visit('/mascotas');
        } catch (cause) {
            setError(cause instanceof Error ? cause.message : 'Error al registrar la cuenta.');
        } finally {
            setEnviando(false);
        }
    }

    return (
        <section className="form-panel" id="apartado-acceso">
            <div className="form-card">
                {/* Cabecera del Formulario con el Logotipo Oficial y Dibujo Lineal */}
                <div className="form-card__brand-strip">
                    <img
                        src="/images/logo-refugio-angelitos.jpg"
                        alt="Logotipo Oficial Refugio Angelitos de Edgar"
                        className="form-card__brand-logo"
                    />
                    <div>
                        <span className="form-card__brand-title">Refugio Angelitos de Edgar</span>
                        <span className="form-card__brand-motto">"Rescatados de la muerte"</span>
                    </div>
                </div>

                {/* Conmutador de Pestañas: Iniciar Sesión vs Crear Cuenta */}
                <div className="form-mode-tabs" role="tablist" aria-label="Opciones de acceso al refugio">
                    <button
                        type="button"
                        role="tab"
                        aria-selected={!modoRegistro}
                        onClick={() => cambiarModo(false)}
                        className={`form-mode-tab ${!modoRegistro ? 'form-mode-tab--active' : ''}`}
                    >
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                            <polyline points="10 17 15 12 10 7" />
                            <line x1="15" y1="12" x2="3" y2="12" />
                        </svg>
                        <span>Iniciar Sesión</span>
                    </button>
                    <button
                        type="button"
                        role="tab"
                        aria-selected={modoRegistro}
                        onClick={() => cambiarModo(true)}
                        className={`form-mode-tab ${modoRegistro ? 'form-mode-tab--active' : ''}`}
                    >
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                            <circle cx="8.5" cy="7" r="4" />
                            <line x1="20" y1="8" x2="20" y2="14" />
                            <line x1="23" y1="11" x2="17" y2="11" />
                        </svg>
                        <span>Crear Cuenta</span>
                    </button>
                </div>

                {!modoRegistro ? (
                    <>
                        <div className="form-heading">
                            <span className="form-heading__eyebrow">Acceso al Portal del Refugio</span>
                            <h2>Qué bueno tenerte aquí.</h2>
                            <p>Ingresa con tu cuenta de equipo, voluntariado, donante o postulante.</p>
                        </div>

                        <form onSubmit={login}>
                            <InputField
                                id="usuario"
                                label="Correo electrónico"
                                type="email"
                                value={usuario}
                                onChange={setUsuario}
                                placeholder="nombre@patitas.com"
                                autoComplete="username"
                                required
                            />

                            <InputField
                                id="password"
                                label="Contraseña"
                                type="password"
                                value={password}
                                onChange={setPassword}
                                placeholder="Tu contraseña"
                                autoComplete="current-password"
                                required
                            />

                            <Link className="login-forgot" href={recoverPassword.url()}>
                                ¿Deseas cambiar o recuperar tu contraseña?
                            </Link>

                            {error && (
                                <p className="form-message form-message--error" role="alert">
                                    {error}
                                </p>
                            )}

                            <button className="btn-primary" type="submit" disabled={enviando || espera > 0}>
                                {enviando ? 'Ingresando…' : espera > 0 ? `Espera ${espera}s` : 'Iniciar sesión'}
                            </button>
                        </form>

                        {/* Invitación clara para crear cuenta como Donante o Postulante */}
                        <div className="form-switch-box">
                            <p className="form-switch-box__label">
                                ¿Visitas el refugio por primera vez y aún no tienes cuenta?
                            </p>
                            <button
                                type="button"
                                onClick={() => cambiarModo(true)}
                                className="form-switch-box__btn"
                            >
                                Crear cuenta como Donante o Postulante a Adopción
                            </button>
                        </div>
                    </>
                ) : (
                    <>
                        <div className="form-heading" style={{ marginBottom: '16px' }}>
                            <span className="form-heading__eyebrow">Registro Ciudadano y Solidario</span>
                            <h2 style={{ fontSize: '26px' }}>Únete a nuestra familia</h2>
                            <p style={{ fontSize: '13px' }}>
                                Con tu cuenta podrás conocer el estado de cada animalito rescatado (modo consulta) y realizar aportes solidarios en línea.
                            </p>
                        </div>

                        <form onSubmit={registrarCuentaPublica}>
                            {/* Selector de Rol: Donante o Postulante con ilustraciones lineales SVG */}
                            <div style={{ marginBottom: '12px' }}>
                                <label
                                    style={{
                                        display: 'block',
                                        fontSize: '11.5px',
                                        fontWeight: 800,
                                        color: '#12354a',
                                        marginBottom: '6px',
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.04em',
                                    }}
                                >
                                    Elige cómo deseas participar *
                                </label>
                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setRegRol('Postulante')}
                                        style={{
                                            padding: '10px 8px',
                                            borderRadius: '8px',
                                            border: regRol === 'Postulante' ? '2px solid #12354a' : '1px solid #cbd5e1',
                                            backgroundColor: '#ffffff',
                                            color: regRol === 'Postulante' ? '#12354a' : '#475569',
                                            fontWeight: 700,
                                            fontSize: '12.5px',
                                            cursor: 'pointer',
                                            textAlign: 'center',
                                        }}
                                    >
                                        Postulante a Adoptar
                                        <span style={{ display: 'block', fontSize: '11px', fontWeight: 500, marginTop: '2px', color: '#475569' }}>
                                            Ver fichas y apoyar
                                        </span>
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setRegRol('Donante')}
                                        style={{
                                            padding: '10px 8px',
                                            borderRadius: '8px',
                                            border: regRol === 'Donante' ? '2px solid #12354a' : '1px solid #cbd5e1',
                                            backgroundColor: '#ffffff',
                                            color: regRol === 'Donante' ? '#12354a' : '#475569',
                                            fontWeight: 700,
                                            fontSize: '12.5px',
                                            cursor: 'pointer',
                                            textAlign: 'center',
                                        }}
                                    >
                                        Donante Solidario
                                        <span style={{ display: 'block', fontSize: '11px', fontWeight: 500, marginTop: '2px', color: '#475569' }}>
                                            Apadrinar y donar
                                        </span>
                                    </button>
                                </div>
                            </div>

                            <InputField
                                id="reg_nombre"
                                label="Nombre completo"
                                type="text"
                                value={regNombre}
                                onChange={setRegNombre}
                                placeholder="Tu nombre y apellidos"
                                required
                            />

                            <InputField
                                id="reg_email"
                                label="Correo electrónico"
                                type="email"
                                value={regEmail}
                                onChange={setRegEmail}
                                placeholder="tucorreo@ejemplo.com"
                                required
                            />

                            <InputField
                                id="reg_telefono"
                                label="Teléfono / WhatsApp"
                                type="text"
                                value={regTelefono}
                                onChange={setRegTelefono}
                                placeholder="Ej. 70000000"
                                required
                            />

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px' }}>
                                <InputField
                                    id="reg_password"
                                    label="Contraseña"
                                    type="password"
                                    value={regPassword}
                                    onChange={setRegPassword}
                                    placeholder="Mín. 6 caracteres"
                                    required
                                />
                                <InputField
                                    id="reg_password_confirmation"
                                    label="Confirmar"
                                    type="password"
                                    value={regPasswordConfirmation}
                                    onChange={setRegPasswordConfirmation}
                                    placeholder="Repite contraseña"
                                    required
                                />
                            </div>

                            {error && (
                                <p className="form-message form-message--error" role="alert">
                                    {error}
                                </p>
                            )}

                            <button className="btn-primary" type="submit" disabled={enviando}>
                                {enviando ? 'Creando cuenta…' : `Crear cuenta como ${regRol}`}
                            </button>
                        </form>

                        <div
                            style={{
                                marginTop: '14px',
                                paddingTop: '12px',
                                borderTop: '1px solid #e2e8f0',
                                textAlign: 'center',
                            }}
                        >
                            <button
                                type="button"
                                onClick={() => cambiarModo(false)}
                                style={{
                                    border: 'none',
                                    background: 'none',
                                    color: '#12354a',
                                    fontSize: '12.5px',
                                    fontWeight: 700,
                                    cursor: 'pointer',
                                    textDecoration: 'underline',
                                }}
                            >
                                ¿Ya tienes una cuenta? Volver a Iniciar sesión
                            </button>
                        </div>
                    </>
                )}
            </div>
        </section>
    );
}
