import React, { useState } from 'react';
import { router } from '@inertiajs/react';

interface PublicDonationModalProps {
    open: boolean;
    onClose: () => void;
}

interface ReciboDonacion {
    numero_recibo: string;
    transaccion_referencia: string;
    fecha_emision: string;
    frecuencia: string;
    monto: number;
    moneda: string;
    donante_nombre: string;
    donante_email: string;
    donante_telefono: string;
    albergue: string;
    albergue_nit: string;
    albergue_direccion: string;
    sello_digital: string;
    qr_payload: string;
    rol_asignado: string;
}

const MONTOS_PREDEFINIDOS = [10, 25, 50, 75, 100, 200];

export default function PublicDonationModal({ open, onClose }: PublicDonationModalProps) {
    const [tipoFrecuencia, setTipoFrecuencia] = useState<'unica' | 'mensual'>('mensual');
    const [montoSeleccionado, setMontoSeleccionado] = useState<number>(25);
    const [otroMonto, setOtroMonto] = useState<string>('');
    const [nombre, setNombre] = useState('');
    const [email, setEmail] = useState('');
    const [telefono, setTelefono] = useState('');
    const [password, setPassword] = useState('');
    const [passwordConfirmation, setPasswordConfirmation] = useState('');
    const [verPassword, setVerPassword] = useState(false);
    const [tipoRol, setTipoRol] = useState<'Donante' | 'Postulante'>('Donante');
    const [terminos, setTerminos] = useState(true);

    const [procesando, setProcesando] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [reciboEmitido, setReciboEmitido] = useState<ReciboDonacion | null>(null);

    if (!open) return null;

    const montoFinal = otroMonto.trim() !== '' ? parseFloat(otroMonto) : montoSeleccionado;

    const handleDonar = async (e: React.FormEvent) => {
        e.preventDefault();
        setError(null);

        if (!montoFinal || isNaN(montoFinal) || montoFinal < 1) {
            setError('Por favor ingresa un monto válido mayor o igual a Bs. 1');
            return;
        }

        if (password.length < 6) {
            setError('La contraseña debe tener al menos 6 caracteres para crear tu cuenta.');
            return;
        }

        if (password !== passwordConfirmation) {
            setError('Las contraseñas no coinciden.');
            return;
        }

        setProcesando(true);
        try {
            const res = await fetch('/api/donaciones/publica', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                },
                body: JSON.stringify({
                    tipo_frecuencia: tipoFrecuencia,
                    monto: montoFinal,
                    nombre,
                    email,
                    telefono: telefono || null,
                    password,
                    password_confirmation: passwordConfirmation,
                    tipo_rol: tipoRol,
                    terminos: terminos,
                }),
            });

            const data = await res.json();
            if (!res.ok) {
                const firstErr = data.errors ? Object.values(data.errors as Record<string, string[]>)[0]?.[0] : null;
                const msg = data.message || data.mensaje || firstErr || 'Error al procesar la donación.';
                throw new Error(String(msg));
            }

            setReciboEmitido(data.recibo);

            // Guardar sesión automática si se generó token
            if (data.token) {
                localStorage.setItem('token', data.token);
                if (data.usuario) {
                    localStorage.setItem('user', JSON.stringify(data.usuario));
                }
            }
        } catch (err) {
            setError(err instanceof Error ? err.message : 'Error inesperado al conectar con el servidor.');
        } finally {
            setProcesando(false);
        }
    };

    const descargarReciboPDF = () => {
        if (!reciboEmitido) return;
        const printWin = window.open('', '_blank');
        if (!printWin) return;

        printWin.document.write(`
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>Recibo Oficial ${reciboEmitido.numero_recibo} - Los Angelitos de Edgar</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; padding: 40px; color: #1e293b; background: #fff; }
                    .recibo-card { border: 2px solid #243d34; border-radius: 12px; padding: 28px; max-width: 650px; margin: 0 auto; }
                    .header { display: flex; justify-content: space-between; border-bottom: 2px solid #243d34; padding-bottom: 14px; margin-bottom: 16px; }
                    .title { color: #243d34; font-size: 22px; font-weight: 800; margin: 0; }
                    .datos-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px; font-size: 13px; }
                    .monto-box { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 16px; text-align: center; margin: 18px 0; }
                    .monto-val { font-size: 28px; font-weight: 800; color: #166534; }
                    .footer-sello { font-size: 11px; color: #64748b; word-break: break-all; border-top: 1px dashed #cbd5e1; padding-top: 12px; margin-top: 20px; }
                    @media print { .no-print { display: none; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="max-width: 650px; margin: 0 auto 16px; display: flex; gap: 10px;">
                    <button onclick="window.print()" style="padding: 10px 20px; background: #243d34; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Imprimir / Guardar en PDF</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background: #e2e8f0; border: none; border-radius: 6px; cursor: pointer;">Cerrar</button>
                </div>
                <div class="recibo-card">
                    <div class="header">
                        <div>
                            <h1 class="title">${reciboEmitido.albergue}</h1>
                            <p style="margin: 4px 0 0; font-size: 12px; color: #64748b;">${reciboEmitido.albergue_nit}</p>
                            <p style="margin: 2px 0 0; font-size: 11px; color: #64748b;">${reciboEmitido.albergue_direccion}</p>
                        </div>
                        <div style="text-align: right;">
                            <div style="font-size: 18px; font-weight: 800; color: #243d34;">RECIBO OFICIAL</div>
                            <div style="font-size: 14px; font-weight: 700; color: #a95a48;">${reciboEmitido.numero_recibo}</div>
                            <div style="font-size: 11px; color: #64748b; margin-top: 4px;">Emisión: ${reciboEmitido.fecha_emision}</div>
                        </div>
                    </div>

                    <div class="datos-grid">
                        <div><strong>Donante:</strong> ${reciboEmitido.donante_nombre}</div>
                        <div><strong>Correo:</strong> ${reciboEmitido.donante_email}</div>
                        <div><strong>Teléfono:</strong> ${reciboEmitido.donante_telefono}</div>
                        <div><strong>Modalidad:</strong> Donación ${reciboEmitido.frecuencia}</div>
                        <div><strong>Referencia:</strong> ${reciboEmitido.transaccion_referencia}</div>
                        <div><strong>Cuenta creada:</strong> Rol ${reciboEmitido.rol_asignado}</div>
                    </div>

                    <div class="monto-box">
                        <div style="font-size: 12px; text-transform: uppercase; font-weight: 700; color: #166534;">Importe Donado</div>
                        <div class="monto-val">Bs. ${reciboEmitido.monto.toFixed(2)}</div>
                        <div style="font-size: 12px; color: #166534; font-weight: 600; margin-top: 4px;">Aporte destinado al rescate, alimentación y salud veterinaria</div>
                    </div>

                    <div class="footer-sello">
                        <div><strong>Sello Digital SHA-256 de Autenticidad:</strong></div>
                        <code>${reciboEmitido.sello_digital}</code>
                        <div style="margin-top: 6px;">Constancia electrónica generada conforme a la Ley N° 164 y normativa tributaria boliviana. Enviado a ${reciboEmitido.donante_email}.</div>
                    </div>
                </div>
            </body>
            </html>
        `);
        printWin.document.close();
    };

    const irAlPanel = () => {
        onClose();
        router.visit('/mascotas');
    };

    return (
        <div
            role="dialog"
            aria-modal="true"
            style={{
                position: 'fixed',
                inset: 0,
                zIndex: 10050,
                backgroundColor: 'rgba(20, 35, 30, 0.72)',
                backdropFilter: 'blur(4px)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                padding: '16px',
                overflowY: 'auto',
            }}
            onClick={onClose}
        >
            <div
                style={{
                    backgroundColor: '#ffffff',
                    color: '#1e293b',
                    borderRadius: '20px',
                    width: '100%',
                    maxWidth: '460px',
                    maxHeight: '92vh',
                    display: 'flex',
                    flexDirection: 'column',
                    overflow: 'hidden',
                    boxShadow: '0 24px 60px rgba(0, 0, 0, 0.3)',
                    border: '1px solid #d5e2dc',
                }}
                onClick={(e) => e.stopPropagation()}
            >
                {/* Cabecera modal */}
                <div
                    style={{
                        padding: '16px 20px',
                        borderBottom: '1px solid #e2e8f0',
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        backgroundColor: '#f8faf9',
                    }}
                >
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="#0f766e" aria-hidden="true">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                        </svg>
                        <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 800, color: '#243d34' }}>
                            Donar al Refugio Los Angelitos
                        </h3>
                    </div>
                    <button
                        type="button"
                        onClick={onClose}
                        style={{
                            border: 'none',
                            background: 'none',
                            fontSize: '18px',
                            color: '#64748b',
                            cursor: 'pointer',
                            fontWeight: 700,
                            padding: '4px 8px',
                        }}
                    >
                        ✕
                    </button>
                </div>

                <div style={{ padding: '20px', overflowY: 'auto' }}>
                    {reciboEmitido ? (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', textAlign: 'center' }}>
                            <div style={{ width: '64px', height: '64px', borderRadius: '50%', backgroundColor: '#dcfce7', color: '#16a34a', display: 'grid', placeItems: 'center', fontSize: '30px', margin: '0 auto' }}>
                                ✓
                            </div>
                            <div>
                                <h3 style={{ margin: 0, fontSize: '18px', fontWeight: 800, color: '#166534' }}>
                                    ¡Donación Realizada con Éxito!
                                </h3>
                                <p style={{ fontSize: '13px', color: '#64748b', margin: '4px 0 0' }}>
                                    Hemos generado tu recibo oficial <strong>{reciboEmitido.numero_recibo}</strong> y enviado la constancia electrónica a <strong>{reciboEmitido.donante_email}</strong>.
                                </p>
                            </div>

                            <div style={{ padding: '16px', borderRadius: '12px', backgroundColor: '#f0fdf4', border: '1px solid #bbf7d0', textAlign: 'left', fontSize: '13px' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '6px' }}>
                                    <span style={{ color: '#64748b' }}>Monto Aportado:</span>
                                    <strong style={{ color: '#166534', fontSize: '16px' }}>Bs. {reciboEmitido.monto.toFixed(2)}</strong>
                                </div>
                                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '6px' }}>
                                    <span style={{ color: '#64748b' }}>Modalidad:</span>
                                    <span style={{ fontWeight: 600 }}>{reciboEmitido.frecuencia}</span>
                                </div>
                                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '6px' }}>
                                    <span style={{ color: '#64748b' }}>Rol asignado:</span>
                                    <span style={{ fontWeight: 700, color: '#243d34' }}>{reciboEmitido.rol_asignado}</span>
                                </div>
                                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                    <span style={{ color: '#64748b' }}>Sello Digital:</span>
                                    <span style={{ fontFamily: 'monospace', fontSize: '10px', color: '#475569' }}>{reciboEmitido.sello_digital.slice(0, 16)}...</span>
                                </div>
                            </div>

                            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                                <button
                                    type="button"
                                    onClick={descargarReciboPDF}
                                    style={{
                                        width: '100%',
                                        padding: '12px',
                                        borderRadius: '10px',
                                        border: '1px solid #243d34',
                                        backgroundColor: '#ffffff',
                                        color: '#243d34',
                                        fontWeight: 700,
                                        fontSize: '13.5px',
                                        cursor: 'pointer',
                                    }}
                                >
                                    Descargar / Imprimir Recibo Oficial (PDF)
                                </button>
                                <button
                                    type="button"
                                    onClick={irAlPanel}
                                    style={{
                                        width: '100%',
                                        padding: '12px',
                                        borderRadius: '10px',
                                        border: 'none',
                                        backgroundColor: '#243d34',
                                        color: '#ffffff',
                                        fontWeight: 700,
                                        fontSize: '13.5px',
                                        cursor: 'pointer',
                                    }}
                                >
                                    Entrar al Portal y Ver Animalitos en Adopción
                                </button>
                            </div>
                        </div>
                    ) : (
                        <form onSubmit={handleDonar} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                            {/* Selector Única / Mensual idéntico a Imagen */}
                            <div>
                                <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', letterSpacing: '0.05em', textTransform: 'uppercase', marginBottom: '6px' }}>
                                    ¿CÓMO QUIERES DONAR?
                                </label>
                                <div
                                    style={{
                                        display: 'flex',
                                        backgroundColor: '#e2e8f0',
                                        borderRadius: '999px',
                                        padding: '4px',
                                        gap: '4px',
                                    }}
                                >
                                    <button
                                        type="button"
                                        onClick={() => setTipoFrecuencia('unica')}
                                        style={{
                                            flex: 1,
                                            padding: '9px 12px',
                                            borderRadius: '999px',
                                            border: 'none',
                                            backgroundColor: tipoFrecuencia === 'unica' ? '#0f766e' : 'transparent',
                                            color: tipoFrecuencia === 'unica' ? '#ffffff' : '#334155',
                                            fontWeight: 700,
                                            fontSize: '13px',
                                            cursor: 'pointer',
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            gap: '6px',
                                            transition: 'all 0.15s ease',
                                        }}
                                    >
                                        <span>Única</span>
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setTipoFrecuencia('mensual')}
                                        style={{
                                            flex: 1,
                                            padding: '9px 12px',
                                            borderRadius: '999px',
                                            border: 'none',
                                            backgroundColor: tipoFrecuencia === 'mensual' ? '#0f766e' : 'transparent',
                                            color: tipoFrecuencia === 'mensual' ? '#ffffff' : '#334155',
                                            fontWeight: 700,
                                            fontSize: '13px',
                                            cursor: 'pointer',
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            gap: '6px',
                                            transition: 'all 0.15s ease',
                                        }}
                                    >
                                        <span>Mensual</span>
                                    </button>
                                </div>
                                <p style={{ fontSize: '12px', color: '#0f766e', fontWeight: 600, margin: '6px 0 0' }}>
                                    {tipoFrecuencia === 'mensual'
                                        ? 'Se cobrará automáticamente cada mes. Puedes cancelar cuando quieras desde tu panel.'
                                        : 'Aporte solidario directo en bolivianos (Bs.) para rescate y alimentación.'}
                                </p>
                            </div>

                            {/* Elige el Monto */}
                            <div>
                                <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', letterSpacing: '0.05em', textTransform: 'uppercase', marginBottom: '6px' }}>
                                    ELIGE EL MONTO
                                </label>
                                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '8px', marginBottom: '8px' }}>
                                    {MONTOS_PREDEFINIDOS.map((monto) => {
                                        const seleccionado = otroMonto === '' && montoSeleccionado === monto;
                                        return (
                                            <button
                                                key={monto}
                                                type="button"
                                                onClick={() => {
                                                    setMontoSeleccionado(monto);
                                                    setOtroMonto('');
                                                }}
                                                style={{
                                                    padding: '10px 8px',
                                                    borderRadius: '8px',
                                                    border: seleccionado ? '1.5px solid #0f766e' : '1px solid #cbd5e1',
                                                    backgroundColor: seleccionado ? '#f0fdf4' : '#ffffff',
                                                    color: seleccionado ? '#0f766e' : '#334155',
                                                    fontWeight: 700,
                                                    fontSize: '13.5px',
                                                    cursor: 'pointer',
                                                    display: 'flex',
                                                    alignItems: 'center',
                                                    justifyContent: 'center',
                                                    gap: '4px',
                                                }}
                                            >
                                                <span>Bs {monto}</span>
                                                {seleccionado && <span style={{ color: '#0f766e', fontSize: '12px' }}>✓</span>}
                                            </button>
                                        );
                                    })}
                                </div>
                                <div style={{ position: 'relative' }}>
                                    <span style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', fontWeight: 700, color: '#64748b', fontSize: '13px' }}>
                                        Bs
                                    </span>
                                    <input
                                        type="number"
                                        step="0.01"
                                        placeholder="Otro monto"
                                        value={otroMonto}
                                        onChange={(e) => setOtroMonto(e.target.value)}
                                        style={{
                                            width: '100%',
                                            padding: '9px 12px 9px 36px',
                                            borderRadius: '8px',
                                            border: otroMonto ? '1.5px solid #0f766e' : '1px solid #cbd5e1',
                                            fontSize: '13px',
                                            boxSizing: 'border-box',
                                        }}
                                    />
                                </div>
                            </div>

                            {/* Datos personales */}
                            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', textTransform: 'uppercase', marginBottom: '4px' }}>
                                        NOMBRE COMPLETO
                                    </label>
                                    <input
                                        type="text"
                                        placeholder="Tu nombre"
                                        required
                                        value={nombre}
                                        onChange={(e) => setNombre(e.target.value)}
                                        style={{ width: '100%', padding: '9px 12px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '13px', boxSizing: 'border-box' }}
                                    />
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr', gap: '8px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', textTransform: 'uppercase', marginBottom: '4px' }}>
                                            CORREO ELECTRÓNICO
                                        </label>
                                        <input
                                            type="email"
                                            placeholder="tu@correo.com"
                                            required
                                            value={email}
                                            onChange={(e) => setEmail(e.target.value)}
                                            style={{ width: '100%', padding: '9px 12px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '13px', boxSizing: 'border-box' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', textTransform: 'uppercase', marginBottom: '4px' }}>
                                            TELÉFONO
                                        </label>
                                        <input
                                            type="tel"
                                            placeholder="Ej. 71234567"
                                            value={telefono}
                                            onChange={(e) => setTelefono(e.target.value)}
                                            style={{ width: '100%', padding: '9px 12px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '13px', boxSizing: 'border-box' }}
                                        />
                                    </div>
                                </div>
                            </div>

                            {/* Aviso de cuenta automática */}
                            <div
                                style={{
                                    padding: '8px 12px',
                                    borderRadius: '8px',
                                    backgroundColor: '#f0fdf4',
                                    border: '1px solid #bbf7d0',
                                    color: '#166534',
                                    fontSize: '12px',
                                    fontWeight: 700,
                                }}
                            >
                                Crearemos tu cuenta al confirmar el primer pago.
                            </div>

                            {/* Contraseña para el usuario */}
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', textTransform: 'uppercase', marginBottom: '4px' }}>
                                        CONTRASEÑA
                                    </label>
                                    <div style={{ position: 'relative' }}>
                                        <input
                                            type={verPassword ? 'text' : 'password'}
                                            placeholder="Crea una contraseña"
                                            required
                                            minLength={6}
                                            value={password}
                                            onChange={(e) => setPassword(e.target.value)}
                                            style={{ width: '100%', padding: '9px 32px 9px 12px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '13px', boxSizing: 'border-box' }}
                                        />
                                        <button
                                            type="button"
                                            onClick={() => setVerPassword(!verPassword)}
                                            style={{ position: 'absolute', right: '8px', top: '50%', transform: 'translateY(-50%)', border: 'none', background: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', color: '#64748b' }}
                                            title="Ver/Ocultar contraseña"
                                        >
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                                <circle cx="12" cy="12" r="3" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <div>
                                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', textTransform: 'uppercase', marginBottom: '4px' }}>
                                        CONFIRMAR CONTRASEÑA
                                    </label>
                                    <input
                                        type={verPassword ? 'text' : 'password'}
                                        placeholder="Repite tu contraseña"
                                        required
                                        minLength={6}
                                        value={passwordConfirmation}
                                        onChange={(e) => setPasswordConfirmation(e.target.value)}
                                        style={{ width: '100%', padding: '9px 12px', borderRadius: '8px', border: '1px solid #cbd5e1', fontSize: '13px', boxSizing: 'border-box' }}
                                    />
                                </div>
                            </div>

                            {/* Selector de rol de usuario */}
                            <div>
                                <label style={{ display: 'block', fontSize: '11px', fontWeight: 800, color: '#64748b', textTransform: 'uppercase', marginBottom: '4px' }}>
                                    QUIERO REGISTRARME COMO:
                                </label>
                                <div style={{ display: 'flex', gap: '8px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setTipoRol('Donante')}
                                        style={{
                                            flex: 1,
                                            padding: '8px',
                                            borderRadius: '6px',
                                            border: tipoRol === 'Donante' ? '1.5px solid #0f766e' : '1px solid #cbd5e1',
                                            backgroundColor: tipoRol === 'Donante' ? '#f0fdf4' : '#fff',
                                            color: tipoRol === 'Donante' ? '#0f766e' : '#475569',
                                            fontWeight: 700,
                                            fontSize: '12px',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Donante Solidario
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setTipoRol('Postulante')}
                                        style={{
                                            flex: 1,
                                            padding: '8px',
                                            borderRadius: '6px',
                                            border: tipoRol === 'Postulante' ? '1.5px solid #0f766e' : '1px solid #cbd5e1',
                                            backgroundColor: tipoRol === 'Postulante' ? '#f0fdf4' : '#fff',
                                            color: tipoRol === 'Postulante' ? '#0f766e' : '#475569',
                                            fontWeight: 700,
                                            fontSize: '12px',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Postulante a Adopción
                                    </button>
                                </div>
                            </div>

                            {/* Checkbox de términos */}
                            <label style={{ display: 'flex', alignItems: 'flex-start', gap: '8px', fontSize: '11.5px', color: '#475569', cursor: 'pointer', lineHeight: 1.4 }}>
                                <input
                                    type="checkbox"
                                    required
                                    checked={terminos}
                                    onChange={(e) => setTerminos(e.target.checked)}
                                    style={{ marginTop: '2px' }}
                                />
                                <span>
                                    Acepto la <strong>Política de privacidad</strong>, los <strong>Términos y condiciones</strong>, y autorizo mi aporte solidario para el refugio Los Angelitos de Edgar.
                                </span>
                            </label>

                            {error && (
                                <div style={{ padding: '8px 12px', borderRadius: '6px', backgroundColor: '#fee2e2', color: '#991b1b', fontSize: '12.5px', fontWeight: 600 }}>
                                    {error}
                                </div>
                            )}

                            {/* Botón donar */}
                            <button
                                type="submit"
                                disabled={procesando}
                                style={{
                                    width: '100%',
                                    padding: '13px',
                                    borderRadius: '10px',
                                    border: 'none',
                                    backgroundColor: '#0f766e',
                                    color: '#ffffff',
                                    fontWeight: 800,
                                    fontSize: '14px',
                                    cursor: 'pointer',
                                    boxShadow: '0 4px 14px rgba(15, 118, 110, 0.35)',
                                    transition: 'background-color 0.15s ease',
                                }}
                            >
                                {procesando
                                    ? 'Procesando donación…'
                                    : `Donar Bs. ${Number(montoFinal).toFixed(2)} (${tipoFrecuencia === 'mensual' ? 'Mensual' : 'Única'})`}
                            </button>
                        </form>
                    )}
                </div>
            </div>
        </div>
    );
}
