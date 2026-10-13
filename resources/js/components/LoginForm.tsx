import { Link, router } from '@inertiajs/react';
import { useEffect, useState  } from 'react';
import type {FormEvent} from 'react';
import { dashboard as dashboardPage } from '@/routes';
import { recover as recoverPassword } from '@/routes/password';
import authService from '@/services/authService';
import InputField from './InputField';

export default function LoginForm() {
    const [usuario, setUsuario] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [enviando, setEnviando] = useState(false);
    const [espera, setEspera] = useState(0);

    useEffect(() => {
        if (espera <= 0) {
            return undefined;
        }

        const timer = window.setTimeout(() => {
            setEspera((actual) => Math.max(0, actual - 1));
        }, 1000);

        return () => window.clearTimeout(timer);
    }, [espera]);

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
            setEspera(5);
            setUsuario('');
            setPassword('');
            router.visit(dashboardPage.url());
        } catch (cause) {
            const message = cause instanceof Error ? cause.message : 'No fue posible iniciar sesión. Inténtalo de nuevo.';
            const retryAfter = cause instanceof Error
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

    return (
        <section className="form-panel">
            <div className="form-card">
                <div className="form-heading">
                    <span className="form-heading__eyebrow">Panel del refugio</span>
                    <h2>Qué bueno verte.</h2>
                    <p>Ingresa con tu cuenta del equipo.</p>
                </div>

                <form onSubmit={login}>
                    <InputField
                        id="usuario"
                        label="Correo electrónico"
                        type="email"
                        value={usuario}
                        onChange={setUsuario}
                        placeholder="nombre@refugio.org"
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
                        ¿Olvidaste tu contraseña?
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

                <p className="form-footnote">Acceso exclusivo para personal autorizado.</p>
            </div>
        </section>
    );
}