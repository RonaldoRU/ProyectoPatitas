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

    // Checkout / Generador QR (CU26)
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
    } | null>(null);

    // Conciliación (CU29)
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

    // Comprobante Digital (CU28)
    const [comprobanteModal, setComprobanteModal] = useState<any | null>(null);

    // Modal Reembolso (CU30)
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

    // Simular Callback / Webhook bancario (CU27)
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

    // Confirmación manual por cajero (CU27 FA1)
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

    // Cargar Conciliación (CU29)
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

    // Ver comprobante (CU28)
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

    // Ejecutar Reembolso (CU30)
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

    return (
        <div className="dashboard-app">
            <Head title="Pasarela de Pagos Digitales y Recibos (P9) - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Pasarela y Pagos QR (P9)" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <p className="dashboard-eyebrow">P9: PASARELA DE DONACIONES Y RECAUDACIÓN</p>
                        <h2>Pasarela de Donaciones Monetarias y Cobro Digital</h2>
                        <p>CU26 a CU30: Generación de QR dinámico, checkout seguro, confirmación por Webhook y conciliación contable de caja.</p>
                    </section>

                <div className="filter-tabs">
                    <button
                        onClick={() => setTab('checkout')}
                        className={`filter-btn ${tab === 'checkout' ? 'active' : ''}`}
                    >
                        💳 Procesar Donación / Checkout QR (CU26)
                    </button>
                    <button
                        onClick={() => {
                            setTab('conciliacion');
                            cargarConciliacion();
                        }}
                        className={`filter-btn ${tab === 'conciliacion' ? 'active' : ''}`}
                    >
                        📊 Conciliación y Arqueo Financiero (CU29, CU30)
                    </button>
                </div>

                {tab === 'checkout' ? (
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px' }}>
                        {/* Formulario de Checkout */}
                        <div className="table-card" style={{ padding: '24px' }}>
                            <h2 style={{ marginBottom: '16px' }}>Generar Intención de Donación (CU26)</h2>
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
                                    {procesando ? 'Generando Pasarela...' : 'Generar Código QR de Pago'}
                                </button>
                            </form>
                        </div>

                        {/* Visualizador de QR y Simulación de Pagos */}
                        <div className="table-card" style={{ padding: '24px', textAlign: 'center' }}>
                            <h2 style={{ marginBottom: '16px' }}>Terminal de Pago Digital</h2>
                            {pagoIniciado ? (
                                <div>
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
                                            Escanea con cualquier App Bancaria
                                        </span>
                                    </div>

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
                                                <button
                                                    onClick={() => simularConfirmacionBancaria(pagoIniciado.transaccion_id)}
                                                    style={{ padding: '8px', borderRadius: '6px', border: 'none', background: '#16a34a', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                                >
                                                    Simular Notificación Bancaria (Webhook CU27)
                                                </button>
                                                <button
                                                    onClick={() => confirmarManual(pagoIniciado.aporte_id)}
                                                    style={{ padding: '8px', borderRadius: '6px', border: '1px solid #0284c7', background: 'transparent', color: '#0284c7', fontWeight: 600, cursor: 'pointer' }}
                                                >
                                                    Confirmar Manualmente por Cajero (FA1)
                                                </button>
                                            </>
                                        ) : (
                                            <button
                                                onClick={() => verComprobante(pagoIniciado.aporte_id)}
                                                style={{ padding: '10px', borderRadius: '6px', border: 'none', background: '#0284c7', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                            >
                                                Descargar Recibo / Certificado Digital (CU28)
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
                        {/* Conciliación Financiera (CU29) */}
                        <div className="stats-grid" style={{ marginBottom: '20px' }}>
                            <div className="stat-card" style={{ borderLeft: '4px solid #0284c7' }}>
                                <span className="stat-label">Total Recaudado</span>
                                <span className="stat-value" style={{ color: '#0284c7' }}>Bs. {resumenFinanciero.total_general.toFixed(2)}</span>
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
                            <div className="stat-card" style={{ borderLeft: '4px solid #ef4444' }}>
                                <span className="stat-label">Reembolsos / Anulaciones</span>
                                <span className="stat-value" style={{ color: '#ef4444' }}>Bs. {resumenFinanciero.total_reembolsado.toFixed(2)}</span>
                                <span className="stat-hint">Reversiones (CU30)</span>
                            </div>
                        </div>

                        {/* Arqueo por Canal */}
                        <div className="table-card" style={{ padding: '20px 24px', marginBottom: '24px' }}>
                            <h3 style={{ margin: '0 0 16px 0', fontFamily: 'Georgia, serif', fontSize: '18px', color: 'var(--dashboard-forest)' }}>
                                Arqueo por Canal de Recaudación (CU29)
                            </h3>
                            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px' }}>
                                {Object.entries(arqueoPorCanal).map(([canalNombre, datos]) => (
                                    <div key={canalNombre} style={{ padding: '14px 16px', borderRadius: '6px', border: '1px solid var(--dashboard-line)', backgroundColor: 'var(--dashboard-paper)' }}>
                                        <span style={{ fontSize: '11px', color: 'var(--dashboard-muted)', fontWeight: 700, textTransform: 'uppercase' }}>{canalNombre}</span>
                                        <h4 style={{ margin: '6px 0', fontSize: '20px', fontFamily: 'Georgia, serif', color: 'var(--dashboard-forest)' }}>Bs. {datos.total.toFixed(2)}</h4>
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
                                                    <td><strong style={{ color: 'var(--dashboard-forest)' }}>Bs. {parseFloat(t.monto).toFixed(2)}</strong></td>
                                                    <td style={{ fontSize: '12px' }}>{t.observaciones}</td>
                                                    <td>
                                                        <div style={{ display: 'flex', gap: '6px' }}>
                                                            <button
                                                                onClick={() => verComprobante(t.id)}
                                                                className="btn-action-view"
                                                            >
                                                                🧾 Recibo (CU28)
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
                                                                    ↩ Reembolso (CU30)
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

                {/* Modal Comprobante Digital (CU28) */}
                {comprobanteModal && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '28px', width: '560px', maxWidth: '95vw', border: '2px solid #0284c7' }}>
                            <div style={{ textAlign: 'center', borderBottom: '2px solid #e2e8f0', paddingBottom: '14px', marginBottom: '16px' }}>
                                <h2 style={{ color: '#0284c7', margin: 0 }}>RECIBO DIGITAL DE DONACIÓN</h2>
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
                                    <p style={{ margin: '2px 0', fontSize: '18px', fontWeight: 700, color: '#16a34a' }}>
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
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #0284c7', color: '#0284c7', background: 'transparent', cursor: 'pointer' }}
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

                {/* Modal Reembolso (CU30) */}
                {reembolsoTarget && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '500px', maxWidth: '95vw' }}>
                            <h2 style={{ marginBottom: '12px', color: '#ef4444' }}>Gestionar Reembolso / Reversión (CU30)</h2>
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
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#ef4444', color: 'white', fontWeight: 600, cursor: 'pointer' }}
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
