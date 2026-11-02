import { Head, Link } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import authService from '@/services/authService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

interface Transaccion {
    id: number;
    monto: string;
    fecha_recepcion: string;
    comprobante: string;
    observaciones: string;
    donacion?: {
        donante?: { nombre: string; telefono: string };
    };
}

interface ArqueoCanal {
    cantidad: number;
    total: number;
}

export default function PasarelaPagos() {
    const [tab, setTab] = useState<'checkout' | 'conciliacion'>('checkout');

    // Checkout / Generador QR 
    const [donanteNombre, setDonanteNombre] = useState('');
    const [donanteTelefono, setDonanteTelefono] = useState('');
    const [monto, setMonto] = useState('50');
    const [canal, setCanal] = useState<'QR' | 'Tarjeta' | 'Transferencia'>('QR');
    const [concepto, setConcepto] = useState('Donación de apoyo a alimentación');

    const [procesando, setProcesando] = useState(false);
    const [pagoIniciado, setPagoIniciado] = useState<{
        transaccion_id: string;
        monto: number;
        canal: string;
        concepto: string;
        estado: string;
        qr_payload: string;
        aporte_id: number;
        stripe?: {
            client_secret: string;
            payment_intent_id: string;
            publishable_key: string;
        } | null;
    } | null>(null);

    // Campos de tarjeta para Stripe Sandbox
    const [tarjetaNumero, setTarjetaNumero] = useState('4242 4242 4242 4242');
    const [tarjetaExp, setTarjetaExp] = useState('12/28');
    const [tarjetaCvc, setTarjetaCvc] = useState('123');
    const [procesandoTarjeta, setProcesandoTarjeta] = useState(false);

    // Conciliación 
    const [cargandoConciliacion, setCargandoConciliacion] = useState(false);
    const [resumenFinanciero, setResumenFinanciero] = useState({
        total_transacciones: 0,
        total_general: 0,
        total_confirmado: 0,
        total_pendiente: 0,
        total_reembolsado: 0,
    });
    const [arqueoPorCanal, setArqueoPorCanal] = useState<Record<string, ArqueoCanal>>({});
    const [transacciones, setTransacciones] = useState<Transaccion[]>([]);

    // Comprobante Digital 
    const [comprobanteModal, setComprobanteModal] = useState<any | null>(null);

    // Modal Reembolso 
    const [reembolsoTarget, setReembolsoTarget] = useState<Transaccion | null>(null);
    const [motivoReembolso, setMotivoReembolso] = useState('');

    const token = authService.getToken();

    const handleIniciarPago = async (e: React.FormEvent) => {
        e.preventDefault();
        setProcesando(true);
        try {
            const res = await fetch('/api/pasarela/iniciar', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify({
                    donante_nombre: donanteNombre,
                    donante_telefono: donanteTelefono,
                    monto: parseFloat(monto),
                    canal: canal,
                    concepto: concepto,
                }),
            });

            if (res.ok) {
                const data = await res.json();
                setPagoIniciado(data);
            } else {
                const err = await res.json();
                alert(err.message || 'Error procesando pasarela.');
            }
        } catch (error) {
            console.error('Error:', error);
        } finally {
            setProcesando(false);
        }
    };

    // Simular Callback / Webhook bancario 
    const simularConfirmacionBancaria = async (transaccionId: string) => {
        try {
            const res = await fetch('/api/pasarela/webhook', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
                body: JSON.stringify({
                    transaccion_id: transaccionId,
                    estado: 'CONFIRMED',
                }),
            });
            if (res.ok) {
                alert('¡Webhook bancario recibido con éxito! La transacción fue confirmada.');
                if (pagoIniciado) {
                    setPagoIniciado({ ...pagoIniciado, estado: 'Confirmado' });
                }
                cargarConciliacion();
            }
        } catch (error) {
            console.error('Error en webhook:', error);
        }
    };

    // Confirmación de pago con tarjeta en Stripe Sandbox
    const confirmarPagoTarjetaStripe = async (aporteId: number) => {
        setProcesandoTarjeta(true);
        try {
            const res = await fetch('/api/pasarela/confirmar-tarjeta', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify({
                    id: aporteId,
                    payment_method: 'pm_card_visa',
                }),
            });

            if (res.ok) {
                const data = await res.json();
                alert(data.mensaje || '¡Pago con tarjeta procesado exitosamente en Stripe Sandbox!');
                if (pagoIniciado) {
                    setPagoIniciado({ ...pagoIniciado, estado: 'Confirmado' });
                }
                cargarConciliacion();
            } else {
                const err = await res.json();
                alert(err.mensaje || 'Error procesando tarjeta con Stripe.');
            }
        } catch (error) {
            console.error('Error procesando tarjeta con Stripe:', error);
            alert('Error de comunicación con Stripe Sandbox.');
        } finally {
            setProcesandoTarjeta(false);
        }
    };

    // Confirmación manual por cajero 
    const confirmarManual = async (aporteId: number) => {
        const refBanco = prompt('Ingrese el número de referencia bancaria o autorización móvil:');
        if (!refBanco) return;

        try {
            const res = await fetch('/api/pasarela/confirmar-manual', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify({
                    id: aporteId,
                    numero_comprobante_banco: refBanco,
                }),
            });
            if (res.ok) {
                alert('¡Transacción validada y confirmada manualmente!');
                if (pagoIniciado) {
                    setPagoIniciado({ ...pagoIniciado, estado: 'Confirmado' });
                }
                cargarConciliacion();
            }
        } catch (error) {
            console.error('Error confirmando manualmente:', error);
        }
    };

    // Cargar Conciliación 
    const cargarConciliacion = async () => {
        setCargandoConciliacion(true);
        try {
            const res = await fetch('/api/pasarela/conciliacion', {
                headers: { Accept: 'application/json', Authorization: `Bearer ${token}` },
            });
            if (res.ok) {
                const data = await res.json();
                setResumenFinanciero(data.resumen);
                setArqueoPorCanal(data.por_canal);
                setTransacciones(data.transacciones);
            }
        } catch (error) {
            console.error('Error en conciliación:', error);
        } finally {
            setCargandoConciliacion(false);
        }
    };

    // Ver comprobante 
    const verComprobante = async (aporteId: number) => {
        try {
            const res = await fetch(`/api/pasarela/comprobante/${aporteId}`, {
                headers: { Accept: 'application/json', Authorization: `Bearer ${token}` },
            });
            if (res.ok) {
                const data = await res.json();
                setComprobanteModal(data.comprobante);
            }
        } catch (error) {
            console.error('Error obteniendo comprobante:', error);
        }
    };

    // Ejecutar Reembolso 
    const handleReembolso = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!reembolsoTarget) return;

        try {
            const res = await fetch('/api/pasarela/reembolso', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify({
                    id: reembolsoTarget.id,
                    justificacion: motivoReembolso,
                }),
            });
            if (res.ok) {
                alert('Transacción reembolsada y registrada en bitácora.');
                setReembolsoTarget(null);
                setMotivoReembolso('');
                cargarConciliacion();
            } else {
                const err = await res.json();
                alert(err.message || 'Error en reembolso.');
            }
        } catch (error) {
            console.error('Error reembolsando:', error);
        }
    };

    useEffect(() => {
        cargarConciliacion();
    }, []);

    const imprimirReciboDigitalPDF = () => {
        if (!comprobanteModal) return;
        const printWin = window.open("", "_blank");
        if (!printWin) return;

        printWin.document.write(`
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>Comprobante Oficial - ${comprobanteModal.numero_recibo}</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 40px; color: #1e293b; max-width: 650px; margin: 0 auto; }
                    .receipt-box { border: 2px solid #183d35; border-radius: 10px; padding: 25px; }
                    .header { text-align: center; border-bottom: 2px dashed #cbd5e1; padding-bottom: 15px; margin-bottom: 20px; }
                    .title { color: #183d35; margin: 0; font-size: 22px; font-weight: bold; }
                    .nit { font-size: 12px; color: #64748b; margin-top: 4px; }
                    .badge-num { font-size: 14px; font-weight: bold; color: #183d35; margin-top: 6px; }
                    .row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 13px; }
                    .label { color: #64748b; font-weight: 600; width: 140px; }
                    .value { flex: 1; text-align: right; font-weight: 500; }
                    .amount-box { background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 6px; padding: 12px; text-align: center; margin: 20px 0; }
                    .amount-val { font-size: 24px; font-weight: bold; color: #183d35; }
                    .amount-lit { font-size: 12px; color: #166534; font-style: italic; margin-top: 4px; }
                    .stamp-box { background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 10px; font-size: 11px; color: #64748b; word-break: break-all; margin-top: 15px; }
                    .signatures { display: flex; justify-content: space-between; margin-top: 40px; padding-top: 20px; }
                    .sign-line { width: 200px; border-top: 1px solid #94a3b8; text-align: center; font-size: 11px; color: #64748b; padding-top: 6px; }
                    @media print { .no-print { display: none; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="margin-bottom: 20px; display: flex; gap: 10px;">
                    <button onclick="window.print()" style="padding: 10px 20px; background-color: #183d35; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Imprimir Comprobante Oficial (PDF)</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background-color: #e2e8f0; border: none; border-radius: 6px; cursor: pointer;">Cerrar</button>
                </div>
                <div class="receipt-box">
                    <div class="header">
                        <h1 class="title">ALBERGUE LOS ANGELITOS DE EDGAR</h1>
                        <div class="nit">${comprobanteModal.albergue_nit || "NIT: 4892019018 • Personería Jurídica N° 342/2021"}</div>
                        <div class="nit">${comprobanteModal.albergue_direccion || "Santa Cruz de la Sierra, Bolivia"}</div>
                        <div class="badge-num">COMPROBANTE OFICIAL DE DONACIÓN: ${comprobanteModal.numero_recibo}</div>
                    </div>

                    <div class="row">
                        <span class="label">Fecha y Hora:</span>
                        <span class="value">${comprobanteModal.fecha_emision} ${comprobanteModal.hora_emision || ""}</span>
                    </div>
                    <div class="row">
                        <span class="label">Aportante / Donante:</span>
                        <span class="value"><strong>${comprobanteModal.donante?.nombre || "Donante Solidario"}</strong></span>
                    </div>
                    <div class="row">
                        <span class="label">Tipo de Persona:</span>
                        <span class="value">${comprobanteModal.donante?.tipo_persona || "Natural"}</span>
                    </div>
                    <div class="row">
                        <span class="label">Canal / Medio:</span>
                        <span class="value">${comprobanteModal.canal || "Caja Central"}</span>
                    </div>
                    <div class="row">
                        <span class="label">Transacción Ref.:</span>
                        <span class="value">${comprobanteModal.transaccion_referencia}</span>
                    </div>
                    <div class="row">
                        <span class="label">Concepto y Destino:</span>
                        <span class="value">${comprobanteModal.detalle}</span>
                    </div>
                    <div class="row">
                        <span class="label">Cajero / Operador:</span>
                        <span class="value">${comprobanteModal.cajero_responsable || "Caja Central"}</span>
                    </div>

                    <div class="amount-box">
                        <div class="amount-val">Bs. ${Number(comprobanteModal.monto).toFixed(2)}</div>
                        <div class="amount-lit">Son: ${comprobanteModal.monto_literal || ""}</div>
                    </div>

                    <div class="stamp-box">
                        <strong>Sello Criptográfico Digital SHA-256:</strong><br>
                        ${comprobanteModal.sello_digital}
                    </div>

                    <div class="signatures">
                        <div class="sign-line">Firma del Donante / Aportante</div>
                        <div class="sign-line">Firma y Sello de Recibido<br>Caja Central y Tesorería</div>
                    </div>
                </div>
            </body>
            </html>
        `);
        printWin.document.close();
    };

    return (
        <div className="dashboard-app">
            <Head title="Pasarela de Pagos Digitales y Recibos (P9) - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Pasarela y Pagos QR (P9)" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <p className="dashboard-eyebrow">PASARELA DE DONACIONES Y RECAUDACIÓN</p>
                        <h2>Pasarela de Donaciones Monetarias y Cobro Digital</h2>
                        <p>Generación de cobros seguros, registro de aportes y conciliación contable de ingresos.</p>
                    </section>

                <div className="filter-tabs">
                    <button
                        onClick={() => setTab('checkout')}
                        className={`filter-btn ${tab === 'checkout' ? 'active' : ''}`}
                    >
                        Procesar Donación / Checkout QR
                    </button>
                    <button
                        onClick={() => {
                            setTab('conciliacion');
                            cargarConciliacion();
                        }}
                        className={`filter-btn ${tab === 'conciliacion' ? 'active' : ''}`}
                    >
                        Conciliación y Arqueo Financiero
                    </button>
                </div>

                {tab === 'checkout' ? (
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px' }}>
                        {/* Formulario de Checkout */}
                        <div className="table-card" style={{ padding: '24px' }}>
                            <h2 style={{ marginBottom: '16px' }}>Generar Intención de Donación</h2>
                            <form onSubmit={handleIniciarPago}>
                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Nombre del Donante / Cliente</label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="Ej. Juan Pérez"
                                        value={donanteNombre}
                                        onChange={(e) => setDonanteNombre(e.target.value)}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Teléfono / WhatsApp</label>
                                    <input
                                        type="text"
                                        placeholder="70000000"
                                        value={donanteTelefono}
                                        onChange={(e) => setDonanteTelefono(e.target.value)}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Monto a Aportar (Bs.)</label>
                                    <div style={{ display: 'flex', gap: '8px', marginBottom: '8px' }}>
                                        {['20', '50', '100', '200'].map((val) => (
                                            <button
                                                type="button"
                                                key={val}
                                                onClick={() => setMonto(val)}
                                                style={{
                                                    flex: 1,
                                                    padding: '6px',
                                                    borderRadius: '6px',
                                                    border: '1px solid #0284c7',
                                                    background: monto === val ? '#0284c7' : 'white',
                                                    color: monto === val ? 'white' : '#0284c7',
                                                    fontWeight: 600,
                                                    cursor: 'pointer',
                                                }}
                                            >
                                                Bs. {val}
                                            </button>
                                        ))}
                                    </div>
                                    <input
                                        type="number"
                                        min="1"
                                        required
                                        value={monto}
                                        onChange={(e) => setMonto(e.target.value)}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Método de Pago</label>
                                    <select
                                        value={canal}
                                        onChange={(e) => setCanal(e.target.value as any)}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    >
                                        <option value="QR">Código QR Dinámico (Simple QR)</option>
                                        <option value="Tarjeta">Tarjeta de Crédito / Débito</option>
                                        <option value="Transferencia">Transferencia Bancaria</option>
                                    </select>
                                </div>

                                <div style={{ marginBottom: '18px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Concepto o Causa</label>
                                    <input
                                        type="text"
                                        value={concepto}
                                        onChange={(e) => setConcepto(e.target.value)}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <button
                                    type="submit"
                                    disabled={procesando}
                                    style={{
                                        width: '100%',
                                        padding: '12px',
                                        borderRadius: '8px',
                                        border: 'none',
                                        background: '#0284c7',
                                        color: 'white',
                                        fontSize: '15px',
                                        fontWeight: 600,
                                        cursor: 'pointer',
                                    }}
                                >
                                    {procesando ? 'Procesando Pasarela...' : canal === 'Tarjeta' ? '💳 Iniciar Pasarela Tarjeta (Stripe Sandbox)' : canal === 'QR' ? '📱 Generar Código QR de Pago' : '🏦 Iniciar Transferencia Bancaria'}
                                </button>
                            </form>
                        </div>

                        {/* Visualizador de QR y Simulación de Pagos */}
                        <div className="table-card" style={{ padding: '24px', textAlign: 'center' }}>
                            <h2 style={{ marginBottom: '16px' }}>Terminal de Pago Digital</h2>
                            {pagoIniciado ? (
                                <div>
                                    {pagoIniciado.canal === 'Tarjeta' ? (
                                        <div style={{ marginBottom: '16px' }}>
                                            {/* Tarjeta Visual de Crédito / Débito */}
                                            <div style={{
                                                background: 'linear-gradient(135deg, #4f46e5 0%, #312e81 100%)',
                                                borderRadius: '16px',
                                                padding: '20px',
                                                color: 'white',
                                                textAlign: 'left',
                                                boxShadow: '0 8px 20px rgba(79, 70, 229, 0.25)',
                                                marginBottom: '16px',
                                                position: 'relative',
                                                overflow: 'hidden',
                                            }}>
                                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                                                    <span style={{ fontSize: '11px', textTransform: 'uppercase', letterSpacing: '1px', background: 'rgba(255,255,255,0.2)', padding: '3px 8px', borderRadius: '4px' }}>
                                                        Stripe Sandbox Test Mode
                                                    </span>
                                                    <span style={{ fontSize: '18px', fontWeight: 800, fontStyle: 'italic' }}>VISA</span>
                                                </div>
                                                <div style={{ fontSize: '18px', letterSpacing: '3px', fontWeight: 600, fontFamily: 'monospace', marginBottom: '16px' }}>
                                                    {tarjetaNumero || '4242 4242 4242 4242'}
                                                </div>
                                                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px' }}>
                                                    <div>
                                                        <span style={{ fontSize: '9px', opacity: 0.8, display: 'block' }}>TITULAR</span>
                                                        <strong>{donanteNombre ? donanteNombre.toUpperCase() : 'DONANTE SOLIDARIO'}</strong>
                                                    </div>
                                                    <div>
                                                        <span style={{ fontSize: '9px', opacity: 0.8, display: 'block' }}>VENCE</span>
                                                        <strong>{tarjetaExp}</strong>
                                                    </div>
                                                </div>
                                            </div>

                                            {/* Inputs de simulación de tarjeta */}
                                            <div style={{ textAlign: 'left', backgroundColor: '#f8fafc', padding: '14px', borderRadius: '8px', border: '1px solid #e2e8f0', marginBottom: '14px' }}>
                                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
                                                    <span style={{ fontSize: '12px', fontWeight: 600, color: '#334155' }}>Tarjeta de Prueba Oficial Stripe</span>
                                                    <span style={{ fontSize: '11px', color: '#6366f1', fontWeight: 600 }}>Sandbox 4242</span>
                                                </div>
                                                <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr 1fr', gap: '8px', marginBottom: '8px' }}>
                                                    <div>
                                                        <label style={{ fontSize: '11px', color: '#64748b', display: 'block' }}>Número</label>
                                                        <input
                                                            type="text"
                                                            value={tarjetaNumero}
                                                            onChange={(e) => setTarjetaNumero(e.target.value)}
                                                            style={{ width: '100%', padding: '6px 8px', border: '1px solid #cbd5e1', borderRadius: '4px', fontSize: '12px', fontFamily: 'monospace' }}
                                                        />
                                                    </div>
                                                    <div>
                                                        <label style={{ fontSize: '11px', color: '#64748b', display: 'block' }}>Exp.</label>
                                                        <input
                                                            type="text"
                                                            value={tarjetaExp}
                                                            onChange={(e) => setTarjetaExp(e.target.value)}
                                                            style={{ width: '100%', padding: '6px 8px', border: '1px solid #cbd5e1', borderRadius: '4px', fontSize: '12px', textAlign: 'center' }}
                                                        />
                                                    </div>
                                                    <div>
                                                        <label style={{ fontSize: '11px', color: '#64748b', display: 'block' }}>CVC</label>
                                                        <input
                                                            type="text"
                                                            value={tarjetaCvc}
                                                            onChange={(e) => setTarjetaCvc(e.target.value)}
                                                            style={{ width: '100%', padding: '6px 8px', border: '1px solid #cbd5e1', borderRadius: '4px', fontSize: '12px', textAlign: 'center' }}
                                                        />
                                                    </div>
                                                </div>
                                                {pagoIniciado.stripe?.payment_intent_id && (
                                                    <div style={{ fontSize: '11px', color: '#64748b', marginTop: '6px' }}>
                                                        <strong>Stripe Intent:</strong> {pagoIniciado.stripe.payment_intent_id}
                                                    </div>
                                                )}
                                            </div>
                                        </div>
                                    ) : (
                                        <div style={{
                                            display: 'inline-block',
                                            padding: '16px',
                                            backgroundColor: '#f8fafc',
                                            border: '2px dashed #0284c7',
                                            borderRadius: '12px',
                                            marginBottom: '16px',
                                        }}>
                                            {/* Mock SVG QR Code */}
                                            <svg width="180" height="180" viewBox="0 0 100 100" style={{ display: 'block', margin: '0 auto' }}>
                                                <rect width="100" height="100" fill="#ffffff" />
                                                {/* Pattern corners */}
                                                <rect x="5" y="5" width="28" height="28" fill="#0f172a" />
                                                <rect x="9" y="9" width="20" height="20" fill="#ffffff" />
                                                <rect x="13" y="13" width="12" height="12" fill="#0f172a" />

                                                <rect x="67" y="5" width="28" height="28" fill="#0f172a" />
                                                <rect x="71" y="9" width="20" height="20" fill="#ffffff" />
                                                <rect x="75" y="13" width="12" height="12" fill="#0f172a" />

                                                <rect x="5" y="67" width="28" height="28" fill="#0f172a" />
                                                <rect x="9" y="71" width="20" height="20" fill="#ffffff" />
                                                <rect x="13" y="75" width="12" height="12" fill="#0f172a" />

                                                {/* Random looking blocks */}
                                                <rect x="40" y="10" width="8" height="8" fill="#0f172a" />
                                                <rect x="50" y="20" width="8" height="8" fill="#0f172a" />
                                                <rect x="40" y="40" width="20" height="20" fill="#0284c7" />
                                                <rect x="10" y="45" width="10" height="10" fill="#0f172a" />
                                                <rect x="70" y="45" width="15" height="10" fill="#0f172a" />
                                                <rect x="45" y="70" width="10" height="20" fill="#0f172a" />
                                                <rect x="70" y="70" width="20" height="10" fill="#0f172a" />
                                            </svg>
                                            <span style={{ fontSize: '11px', color: '#64748b', marginTop: '8px', display: 'block' }}>
                                                {pagoIniciado.canal === 'Transferencia' ? 'Código QR para Pago por Transferencia' : 'Escanea con cualquier App Bancaria'}
                                            </span>
                                        </div>
                                    )}

                                    <div style={{ marginBottom: '16px', textAlign: 'left', backgroundColor: '#f1f5f9', padding: '12px', borderRadius: '8px' }}>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>ID Transacción:</strong> {pagoIniciado.transaccion_id}</p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Monto:</strong> Bs. {pagoIniciado.monto.toFixed(2)}</p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Concepto:</strong> {pagoIniciado.concepto}</p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Estado:</strong>{' '}
                                            <span style={{
                                                padding: '2px 8px',
                                                borderRadius: '4px',
                                                fontWeight: 600,
                                                fontSize: '12px',
                                                backgroundColor: pagoIniciado.estado === 'Confirmado' ? '#dcfce7' : '#fef9c3',
                                                color: pagoIniciado.estado === 'Confirmado' ? '#15803d' : '#854d0e',
                                            }}>
                                                {pagoIniciado.estado}
                                            </span>
                                        </p>
                                    </div>

                                    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                                        {pagoIniciado.estado === 'Pendiente' ? (
                                            <>
                                                {pagoIniciado.canal === 'Tarjeta' ? (
                                                    <button
                                                        onClick={() => confirmarPagoTarjetaStripe(pagoIniciado.aporte_id)}
                                                        disabled={procesandoTarjeta}
                                                        style={{
                                                            padding: '12px',
                                                            borderRadius: '6px',
                                                            border: 'none',
                                                            background: '#4f46e5',
                                                            color: 'white',
                                                            fontWeight: 600,
                                                            cursor: 'pointer',
                                                            fontSize: '14px',
                                                        }}
                                                    >
                                                        {procesandoTarjeta ? 'Procesando en Stripe Sandbox...' : '💳 Pagar Bs. ' + pagoIniciado.monto.toFixed(2) + ' con Stripe Sandbox'}
                                                    </button>
                                                ) : (
                                                    <button
                                                        onClick={() => simularConfirmacionBancaria(pagoIniciado.transaccion_id)}
                                                        style={{ padding: '8px', borderRadius: '6px', border: 'none', background: '#183d35', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                                    >
                                                        Simular Notificación Bancaria en Línea
                                                    </button>
                                                )}
                                                <button
                                                    onClick={() => confirmarManual(pagoIniciado.aporte_id)}
                                                    style={{ padding: '8px', borderRadius: '6px', border: '1px solid #183d35', background: 'transparent', color: '#183d35', fontWeight: 600, cursor: 'pointer' }}
                                                >
                                                    Confirmar Manualmente por Caja
                                                </button>
                                            </>
                                        ) : (
                                            <button
                                                onClick={() => verComprobante(pagoIniciado.aporte_id)}
                                                style={{ padding: '10px', borderRadius: '6px', border: 'none', background: '#183d35', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                            >
                                                Descargar Recibo / Certificado Digital
                                            </button>
                                        )}
                                    </div>
                                </div>
                            ) : (
                                <div style={{ padding: '60px 20px', color: '#94a3b8' }}>
                                    <p>Completa el formulario y genera el código QR dinámico para iniciar la recaudación.</p>
                                </div>
                            )}
                        </div>
                    </div>
                ) : (
                    <div>
                        {/* Conciliación Financiera */}
                        <div className="stats-grid" style={{ marginBottom: '20px' }}>
                            <div className="stat-card" style={{ borderLeft: '4px solid #183d35' }}>
                                <span className="stat-label">Total Recaudado</span>
                                <span className="stat-value" style={{ color: '#183d35' }}>Bs. {resumenFinanciero.total_general.toFixed(2)}</span>
                                <span className="stat-hint">{resumenFinanciero.total_transacciones} transacciones registradas</span>
                            </div>
                            <div className="stat-card" style={{ borderLeft: '4px solid #16a34a' }}>
                                <span className="stat-label">Confirmado en Caja</span>
                                <span className="stat-value" style={{ color: '#16a34a' }}>Bs. {resumenFinanciero.total_confirmado.toFixed(2)}</span>
                                <span className="stat-hint">Fondos acreditados</span>
                            </div>
                            <div className="stat-card" style={{ borderLeft: '4px solid #eab308' }}>
                                <span className="stat-label">Pendiente de Pago</span>
                                <span className="stat-value" style={{ color: '#ca8a04' }}>Bs. {resumenFinanciero.total_pendiente.toFixed(2)}</span>
                                <span className="stat-hint">QRs no liquidados</span>
                            </div>
                            <div className="stat-card" style={{ borderLeft: '4px solid #b91c1c' }}>
                                <span className="stat-label">Reembolsos / Anulaciones</span>
                                <span className="stat-value" style={{ color: '#b91c1c' }}>Bs. {resumenFinanciero.total_reembolsado.toFixed(2)}</span>
                                <span className="stat-hint">Reversiones procesadas</span>
                            </div>
                        </div>

                        {/* Arqueo por Canal */}
                        <div className="table-card" style={{ padding: '20px 24px', marginBottom: '24px' }}>
                            <h3 style={{ margin: '0 0 16px 0', fontFamily: 'Georgia, serif', fontSize: '18px', color: 'var(--dashboard-forest)' }}>
                                Arqueo por Canal de Recaudación
                            </h3>
                            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px' }}>
                                {Object.entries(arqueoPorCanal).map(([canalNombre, datos]) => (
                                    <div key={canalNombre} style={{ padding: '14px 16px', borderRadius: '6px', border: '1px solid var(--dashboard-line)', backgroundColor: 'var(--dashboard-paper)' }}>
                                        <span style={{ fontSize: '11px', color: 'var(--dashboard-muted)', fontWeight: 700, textTransform: 'uppercase' }}>{canalNombre}</span>
                                        <h4 style={{ margin: '6px 0', fontSize: '20px', fontFamily: "'Instrument Sans', system-ui, sans-serif", fontWeight: 700, fontVariantNumeric: 'tabular-nums', letterSpacing: '-0.02em', color: 'var(--dashboard-forest)' }}>Bs. {datos.total.toFixed(2)}</h4>
                                        <span style={{ fontSize: '11.5px', color: 'var(--dashboard-muted)' }}>{datos.cantidad} transacciones</span>
                                    </div>
                                ))}
                            </div>
                        </div>

                        {/* Tabla de Transacciones */}
                        <div className="table-card">
                            <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--dashboard-line)', backgroundColor: '#fcfdfb' }}>
                                <h3 style={{ margin: 0, fontFamily: 'Georgia, serif', fontSize: '16px', color: 'var(--dashboard-forest)' }}>
                                    Historial de Transacciones Monetarias
                                </h3>
                            </div>
                            <div className="table-responsive">
                                <table className="data-table">
                                    <thead>
                                        <tr>
                                            <th>Ref #</th>
                                            <th>Fecha</th>
                                            <th>Donante</th>
                                            <th>Monto</th>
                                            <th>Canal y Detalle</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {cargandoConciliacion ? (
                                            <tr><td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando arqueo y transacciones...</td></tr>
                                        ) : transacciones.length === 0 ? (
                                            <tr><td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay transacciones monetarias registradas.</td></tr>
                                        ) : (
                                            transacciones.map((t) => (
                                                <tr key={t.id}>
                                                    <td><strong style={{ color: 'var(--dashboard-forest)' }}>{t.comprobante}</strong></td>
                                                    <td>{t.fecha_recepcion}</td>
                                                    <td><strong style={{ color: 'var(--dashboard-ink)' }}>{t.donacion?.donante?.nombre || 'Donante Anónimo'}</strong></td>
                                                    <td><strong style={{ color: 'var(--dashboard-forest)', fontFamily: "'Instrument Sans', system-ui, sans-serif", fontWeight: 700, fontVariantNumeric: 'tabular-nums' }}>Bs. {parseFloat(t.monto).toFixed(2)}</strong></td>
                                                    <td style={{ fontSize: '12px' }}>{t.observaciones}</td>
                                                    <td>
                                                        <div style={{ display: 'flex', gap: '6px' }}>
                                                            <button
                                                                onClick={() => verComprobante(t.id)}
                                                                className="btn-action-view"
                                                            >
                                                                Recibo Digital
                                                            </button>
                                                            {!t.observaciones.includes('Estado: Reembolsado') && (
                                                                <button
                                                                    onClick={() => {
                                                                        setReembolsoTarget(t);
                                                                        setMotivoReembolso('');
                                                                    }}
                                                                    className="btn-action-secondary"
                                                                    style={{ color: '#b91c1c', borderColor: '#fca5a5' }}
                                                                >
                                                                    Reembolso
                                                                </button>
                                                            )}
                                                        </div>
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                )}

                {/* Modal Comprobante Digital */}
                {comprobanteModal && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '28px', width: '560px', maxWidth: '95vw', border: '2px solid #183d35' }}>
                            <div style={{ textAlign: 'center', borderBottom: '2px solid #e2e8f0', paddingBottom: '14px', marginBottom: '16px' }}>
                                <h2 style={{ color: '#183d35', margin: 0 }}>RECIBO DIGITAL DE DONACIÓN</h2>
                                <span>{comprobanteModal.albergue}</span>
                                <p style={{ fontSize: '12px', color: '#64748b', margin: '4px 0 0 0' }}>
                                    Recibo N°: <strong>{comprobanteModal.numero_recibo}</strong> | Fecha: {comprobanteModal.fecha_emision}
                                </p>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '16px' }}>
                                <div>
                                    <span style={{ fontSize: '12px', color: '#64748b' }}>Donante:</span>
                                    <p style={{ margin: '2px 0', fontWeight: 600 }}>{comprobanteModal.donante?.nombre}</p>
                                </div>
                                <div>
                                    <span style={{ fontSize: '12px', color: '#64748b' }}>Monto Aportado:</span>
                                    <p style={{ margin: '2px 0', fontSize: '18px', fontWeight: 700, color: '#183d35' }}>
                                        Bs. {comprobanteModal.monto?.toFixed(2)}
                                    </p>
                                </div>
                            </div>

                            <div style={{ padding: '10px', backgroundColor: '#f8fafc', borderRadius: '6px', fontSize: '12px', marginBottom: '16px' }}>
                                <p style={{ margin: '2px 0' }}><strong>Ref. Bancaria:</strong> {comprobanteModal.transaccion_referencia}</p>
                                <p style={{ margin: '2px 0' }}><strong>Detalle:</strong> {comprobanteModal.detalle}</p>
                                <p style={{ margin: '2px 0', color: '#64748b' }}><strong>Sello Digital Criptográfico:</strong> {comprobanteModal.sello_digital?.substring(0, 32)}...</p>
                            </div>

                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                <button
                                    onClick={() => window.print()}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #183d35', color: '#183d35', background: 'transparent', cursor: 'pointer' }}
                                >
                                    Imprimir / Guardar PDF
                                </button>
                                <button
                                    onClick={() => setComprobanteModal(null)}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#334155', color: 'white', cursor: 'pointer' }}
                                >
                                    Cerrar
                                </button>
                            </div>
                        </div>
                    </div>
                )}

                {/* Modal Reembolso */}
                {reembolsoTarget && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '500px', maxWidth: '95vw' }}>
                            <h2 style={{ marginBottom: '12px', color: '#b91c1c' }}>Gestionar Reembolso / Reversión</h2>
                            <p style={{ fontSize: '13px', color: '#64748b', marginBottom: '14px' }}>
                                Transacción: <strong>{reembolsoTarget.comprobante}</strong> por <strong>Bs. {reembolsoTarget.monto}</strong>
                            </p>
                            <form onSubmit={handleReembolso}>
                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Justificación Administrativa de la Reversión</label>
                                    <textarea
                                        required
                                        rows={3}
                                        placeholder="Ingrese el motivo de duplicidad de cobro, error de digitación o solicitud formal del aportante..."
                                        value={motivoReembolso}
                                        onChange={(e) => setMotivoReembolso(e.target.value)}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>
                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setReembolsoTarget(null)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        type="submit"
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#b91c1c', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        Aprobar Reembolso
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}
                </div>
            </main>
        </div>
    );
}
