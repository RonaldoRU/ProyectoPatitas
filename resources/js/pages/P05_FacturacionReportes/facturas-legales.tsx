import { Head } from '@inertiajs/react';
import React, { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';

interface FacturaLegal {
    id: number;
    numero_factura: number;
    numero_autorizacion: string;
    fecha_emision: string;
    nit_ci_cliente: string;
    razon_social_cliente: string;
    importe_total: string;
    debito_fiscal: string;
    codigo_control: string;
    cadena_qr: string;
    estado: 'EMITIDA' | 'ANULADA';
    motivo_anulacion?: string | null;
}

export default function FacturasLegales() {
    const [facturas, setFacturas] = useState<FacturaLegal[]>([]);
    const [dosificacionActiva, setDosificacionActiva] = useState<{ numero_autorizacion: string; correlativo_actual: number } | null>(null);
    const [mensaje, setMensaje] = useState<{ tipo: 'ok' | 'error'; texto: string } | null>(null);

    const [nitCi, setNitCi] = useState('');
    const [razonSocial, setRazonSocial] = useState('');
    const [concepto, setConcepto] = useState('Consulta veterinaria y atención clínica');
    const [cantidad, setCantidad] = useState('1');
    const [precio, setPrecio] = useState('100');
    const [descuento, setDescuento] = useState('0');

    const [anulandoId, setAnulandoId] = useState<number | null>(null);
    const [motivoAnulacion, setMotivoAnulacion] = useState('');
    const [passwordAnulacion, setPasswordAnulacion] = useState('');

    const cargar = async () => {
        const token = localStorage.getItem('token');
        const res = await fetch('/api/facturas-legales', {
            headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        });
        if (res.ok) {
            const data = await res.json();
            setFacturas(data.facturas || []);
            setDosificacionActiva(data.dosificacion_activa || null);
        }
    };

    useEffect(() => {
        cargar();
    }, []);

    const emitirFactura = async (e: React.FormEvent) => {
        e.preventDefault();
        setMensaje(null);
        const token = localStorage.getItem('token');
        const res = await fetch('/api/facturas-legales', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                ...(token ? { Authorization: `Bearer ${token}` } : {}),
            },
            body: JSON.stringify({
                nit_ci_cliente: nitCi,
                razon_social_cliente: razonSocial,
                descuento: Number(descuento),
                items: [{ concepto, cantidad: Number(cantidad), precio_unitario: Number(precio) }],
            }),
        });
        const data = await res.json();
        if (!res.ok) {
            setMensaje({ tipo: 'error', texto: data.mensaje || data.message || 'No se pudo emitir la factura.' });
            return;
        }
        setMensaje({ tipo: 'ok', texto: `${data.mensaje} Código Control: ${data.factura.codigo_control}` });
        setNitCi('');
        setRazonSocial('');
        await cargar();
    };

    const confirmarAnulacion = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!anulandoId) return;
        const token = localStorage.getItem('token');
        const res = await fetch(`/api/facturas-legales/${anulandoId}/anular`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                ...(token ? { Authorization: `Bearer ${token}` } : {}),
            },
            body: JSON.stringify({ motivo_anulacion: motivoAnulacion, password: passwordAnulacion }),
        });
        const data = await res.json();
        if (!res.ok) {
            setMensaje({ tipo: 'error', texto: data.mensaje || data.message || 'Error al anular.' });
            return;
        }
        setMensaje({ tipo: 'ok', texto: data.mensaje });
        setAnulandoId(null);
        setMotivoAnulacion('');
        setPasswordAnulacion('');
        await cargar();
    };

    const imprimirTicket = (f: FacturaLegal) => {
        const win = window.open('', '_blank');
        if (!win) return;
        win.document.write(`
            <html><body style="font-family: monospace; padding: 24px; max-width: 360px;">
                <h3 style="margin:0;">REFUGIO LOS ANGELITOS DE EDGAR</h3>
                <p style="margin:4px 0;">FACTURA N° ${f.numero_factura} (${f.estado})</p>
                <p style="margin:4px 0;">Autorización: ${f.numero_autorizacion}</p>
                <hr/>
                <p>NIT/CI: ${f.nit_ci_cliente}<br/>Razón Social: ${f.razon_social_cliente}</p>
                <p><strong>Total: Bs. ${Number(f.importe_total).toFixed(2)}</strong><br/>Débito Fiscal (13%): Bs. ${Number(f.debito_fiscal).toFixed(2)}</p>
                <p>Código de Control: <strong>${f.codigo_control}</strong></p>
                <p style="font-size:10px; word-break:break-all;">QR: ${f.cadena_qr}</p>
                <button onclick="window.print()">Imprimir Ticket</button>
            </body></html>
        `);
        win.document.close();
    };

    return (
        <div className="dashboard-app">
            <Head title="Facturación Legal - Los Angelitos" />
            <main className="dashboard-main">
                <DashboardTopNav title="Facturación Legal" />
                <div className="dashboard-content">
                    {mensaje && (
                        <div style={{ padding: '12px 16px', borderRadius: '8px', marginBottom: '16px', backgroundColor: mensaje.tipo === 'ok' ? '#dcfce7' : '#fee2e2', color: mensaje.tipo === 'ok' ? '#166534' : '#991b1b', fontWeight: 600 }}>
                            {mensaje.texto}
                        </div>
                    )}

                    <div className="dashboard-panel" style={{ padding: '20px', marginBottom: '20px' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px' }}>
                            <h2 style={{ margin: 0, color: 'var(--dashboard-forest)' }}>Emitir Factura Legal</h2>
                            <span style={{ fontSize: '12px', fontWeight: 700, color: dosificacionActiva ? '#166534' : '#991b1b' }}>
                                {dosificacionActiva ? `Autorización activa: ${dosificacionActiva.numero_autorizacion} (N° ${dosificacionActiva.correlativo_actual})` : 'Sin dosificación activa (configurar en Dosificación Fiscal)'}
                            </span>
                        </div>
                        <form onSubmit={emitirFactura} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '12px' }}>
                            <input placeholder="NIT / CI Cliente" value={nitCi} onChange={(e) => setNitCi(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input placeholder="Razón Social / Nombre" value={razonSocial} onChange={(e) => setRazonSocial(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input placeholder="Concepto" value={concepto} onChange={(e) => setConcepto(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input type="number" step="0.01" placeholder="Cantidad" value={cantidad} onChange={(e) => setCantidad(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input type="number" step="0.01" placeholder="Precio Unitario (Bs.)" value={precio} onChange={(e) => setPrecio(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input type="number" step="0.01" placeholder="Descuento (Bs.)" value={descuento} onChange={(e) => setDescuento(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <div style={{ gridColumn: '1 / -1' }}>
                                <button type="submit" disabled={!dosificacionActiva} style={{ padding: '10px 20px', borderRadius: '8px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>
                                    Emitir Factura con Código de Control y QR
                                </button>
                            </div>
                        </form>
                    </div>

                    {anulandoId && (
                        <div className="dashboard-panel" style={{ padding: '20px', marginBottom: '20px', border: '2px solid #dc2626' }}>
                            <h3 style={{ marginTop: 0, color: '#991b1b' }}>Anular Factura Legal</h3>
                            <form onSubmit={confirmarAnulacion} style={{ display: 'flex', flexWrap: 'wrap', gap: '10px' }}>
                                <input placeholder="Motivo formal obligatorio" value={motivoAnulacion} onChange={(e) => setMotivoAnulacion(e.target.value)} required minLength={5} style={{ flex: 2, padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <input type="password" placeholder="Contraseña de Administrador" value={passwordAnulacion} onChange={(e) => setPasswordAnulacion(e.target.value)} required style={{ flex: 1, padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <button type="submit" style={{ padding: '8px 16px', backgroundColor: '#dc2626', color: '#fff', border: 'none', borderRadius: '6px', fontWeight: 700, cursor: 'pointer' }}>Confirmar Anulación</button>
                                <button type="button" onClick={() => setAnulandoId(null)} style={{ padding: '8px 16px', backgroundColor: '#e2e8f0', border: 'none', borderRadius: '6px', cursor: 'pointer' }}>Cancelar</button>
                            </form>
                        </div>
                    )}

                    <div className="dashboard-panel" style={{ padding: '20px' }}>
                        <h3 style={{ marginTop: 0 }}>Facturas Emitidas</h3>
                        <div style={{ overflowX: 'auto' }}>
                            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
                                <thead>
                                    <tr style={{ backgroundColor: '#243d34', color: '#fff' }}>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>N°</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>NIT/CI</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Razón Social</th>
                                        <th style={{ padding: '10px', textAlign: 'right' }}>Total (Bs.)</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Código Control</th>
                                        <th style={{ padding: '10px', textAlign: 'center' }}>Estado</th>
                                        <th style={{ padding: '10px', textAlign: 'center' }}>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {facturas.map((f) => (
                                        <tr key={f.id} style={{ borderBottom: '1px solid #e2e8f0' }}>
                                            <td style={{ padding: '10px', fontWeight: 700 }}>{f.numero_factura}</td>
                                            <td style={{ padding: '10px' }}>{f.nit_ci_cliente}</td>
                                            <td style={{ padding: '10px' }}>{f.razon_social_cliente}</td>
                                            <td style={{ padding: '10px', textAlign: 'right' }}>{Number(f.importe_total).toFixed(2)}</td>
                                            <td style={{ padding: '10px', fontFamily: 'monospace' }}>{f.codigo_control}</td>
                                            <td style={{ padding: '10px', textAlign: 'center' }}>
                                                <span style={{ padding: '3px 8px', borderRadius: '12px', fontSize: '11px', fontWeight: 700, backgroundColor: f.estado === 'EMITIDA' ? '#dcfce7' : '#fee2e2', color: f.estado === 'EMITIDA' ? '#166534' : '#991b1b' }}>
                                                    {f.estado}
                                                </span>
                                            </td>
                                            <td style={{ padding: '10px', textAlign: 'center', display: 'flex', gap: '6px', justifyContent: 'center' }}>
                                                <button type="button" onClick={() => imprimirTicket(f)} style={{ padding: '5px 10px', borderRadius: '6px', border: '1px solid #cbd5e1', cursor: 'pointer' }}>Ticket</button>
                                                {f.estado === 'EMITIDA' && (
                                                    <button type="button" onClick={() => setAnulandoId(f.id)} style={{ padding: '5px 10px', borderRadius: '6px', border: 'none', backgroundColor: '#fee2e2', color: '#991b1b', cursor: 'pointer', fontWeight: 700 }}>Anular</button>
                                                )}
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}

