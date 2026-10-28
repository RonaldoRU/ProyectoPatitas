import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import type { FormEvent } from 'react';
import { login as loginPage } from '@/routes';
import authService from '@/services/authService';
import '../../../css/recuperar.css';

type FormMessage = {
    type: 'success' | 'error' | '';
    text: string;
};

export default function RecuperarPassword() {
    const [email, setEmail] = useState('');
    const [codigo, setCodigo] = useState('');
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [codigoEnviado, setCodigoEnviado] = useState(false);
    const [loadingPaso1, setLoadingPaso1] = useState(false);
    const [loadingPaso2, setLoadingPaso2] = useState(false);
    const [resetComplete, setResetComplete] = useState(false);
    const [msgPaso1, setMsgPaso1] = useState<FormMessage>({ type: '', text: '' });
    const [msgPaso2, setMsgPaso2] = useState<FormMessage>({ type: '', text: '' });

    useEffect(() => {
        if (!resetComplete) {
            return;
        }

        const timer = window.setTimeout(() => router.visit(loginPage.url()), 2000);

        return () => window.clearTimeout(timer);
    }, [resetComplete]);

    async function handleSolicitarCodigo(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setLoadingPaso1(true);
        setMsgPaso1({ type: '', text: '' });

        try {
            await authService.solicitarCodigo(email);
            setCodigoEnviado(true);
            setMsgPaso1({
                type: 'success',
                text: 'Si el correo está registrado, enviaremos un código válido por 10 minutos.',
            });
        } catch (cause) {
            setMsgPaso1({
                type: 'error',
                text: cause instanceof Error ? cause.message : 'No fue posible solicitar el código.',
            });
        } finally {
            setLoadingPaso1(false);
        }
    }

    async function handleRestablecer(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setMsgPaso2({ type: '', text: '' });

        if (password !== confirmPassword) {
            setMsgPaso2({ type: 'error', text: 'Las contraseñas no coinciden.' });

            return;
        }

        setLoadingPaso2(true);

        try {
            await authService.restablecerPassword(email, codigo, password, confirmPassword);
            setResetComplete(true);
            setMsgPaso2({
                type: 'success',
                text: 'Contraseña actualizada. Volverás al inicio de sesión en un momento.',
            });
        } catch (cause) {
            setMsgPaso2({
                type: 'error',
                text: cause instanceof Error ? cause.message : 'No fue posible restablecer la contraseña.',
            });
        } finally {
            setLoadingPaso2(false);
        }
    }

    return (
        <>
            <Head title="Recuperar contraseña" />
            <main className="recovery-page">
                <header className="recovery-header">
                    <Link className="recovery-brand" href={loginPage.url()}>
                        <span className="recovery-brand__mark">LA</span>
                        <span>Los Angelitos de Edgar</span>
                    </Link>
                    <Link className="recovery-back" href={loginPage.url()}>
                        Volver al inicio de sesión
                    </Link>
                </header>

                <div className="recovery-intro">
                    <span className="recovery-kicker">Acceso al refugio</span>
                    <h1>Recupera tu cuenta</h1>
                    <p>Te enviaremos un código para que puedas elegir una contraseña nueva.</p>
                </div>

                <div className="recovery-flow">
                    <section className="recovery-card">
                        <span className="recovery-step">Paso 1 de 2</span>
                        <h2>Solicitar código</h2>
                        <p className="recovery-description">
                            Ingresa el correo asociado a tu cuenta del refugio.
                        </p>

                        <form className="recovery-form" onSubmit={handleSolicitarCodigo}>
                            <div className="recovery-field">
                                <label htmlFor="recovery-email">Correo electrónico</label>
                                <input
                                    id="recovery-email"
                                    type="email"
                                    autoComplete="email"
                                    placeholder="nombre@refugio.org"
                                    value={email}
                                    onChange={(event) => setEmail(event.target.value)}
                                    required
                                />
                            </div>

                            {msgPaso1.text && (
                                <p className={`recovery-message recovery-message--${msgPaso1.type}`} role={msgPaso1.type === 'error' ? 'alert' : 'status'}>
                                    {msgPaso1.text}
                                </p>
                            )}

                            <button className="recovery-submit" type="submit" disabled={loadingPaso1}>
                                {loadingPaso1 ? 'Enviando…' : 'Enviar código'}
                            </button>
                        </form>
                    </section>

                    <div className="recovery-divider" aria-hidden="true">
                        <span />
                        <p>Luego de recibir el código</p>
                        <span />
                    </div>

                    <section className={`recovery-card${codigoEnviado ? '' : ' recovery-card--locked'}`}>
                        <span className="recovery-step">Paso 2 de 2</span>
                        <h2>Define una contraseña nueva</h2>
                        <p className="recovery-description">
                            El código vence en 10 minutos y solo se puede usar una vez.
                        </p>

                        <form className="recovery-form" onSubmit={handleRestablecer}>
                            <div className="recovery-field">
                                <label htmlFor="recovery-code">Código de verificación</label>
                                <input
                                    id="recovery-code"
                                    type="text"
                                    inputMode="numeric"
                                    autoComplete="one-time-code"
                                    placeholder="6 dígitos"
                                    pattern="[0-9]{6}"
                                    maxLength={6}
                                    value={codigo}
                                    onChange={(event) => setCodigo(event.target.value.replace(/\D/g, '').slice(0, 6))}
                                    disabled={!codigoEnviado || resetComplete}
                                    required
                                />
                            </div>

                            <div className="recovery-field">
                                <label htmlFor="recovery-password">Nueva contraseña</label>
                                <input
                                    id="recovery-password"
                                    type="password"
                                    autoComplete="new-password"
                                    placeholder="Mínimo 8 caracteres con mayúscula, minúscula, número y símbolo"
                                    minLength={8}
                                    value={password}
                                    onChange={(event) => setPassword(event.target.value)}
                                    disabled={!codigoEnviado || resetComplete}
                                    required
                                />
                            </div>

                            <div className="recovery-field">
                                <label htmlFor="recovery-confirm-password">Confirmar contraseña</label>
                                <input
                                    id="recovery-confirm-password"
                                    type="password"
                                    autoComplete="new-password"
                                    placeholder="Repite la contraseña"
                                    minLength={8}
                                    value={confirmPassword}
                                    onChange={(event) => setConfirmPassword(event.target.value)}
                                    disabled={!codigoEnviado || resetComplete}
                                    required
                                />
                            </div>

                            {msgPaso2.text && (
                                <p className={`recovery-message recovery-message--${msgPaso2.type}`} role={msgPaso2.type === 'error' ? 'alert' : 'status'}>
                                    {msgPaso2.text}
                                </p>
                            )}

                            <button
                                className="recovery-submit"
                                type="submit"
                                disabled={!codigoEnviado || loadingPaso2 || resetComplete}
                            >
                                {loadingPaso2 ? 'Actualizando…' : 'Restablecer contraseña'}
                            </button>
                        </form>
                    </section>
                </div>

                <footer className="recovery-footer">
                    ¿Ya recordaste tu contraseña? <Link href={loginPage.url()}>Inicia sesión</Link>
                </footer>
            </main>
        </>
    );
}
