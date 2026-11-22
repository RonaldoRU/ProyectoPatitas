import { Head } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';

interface EventoForense {
    id: number;
    fecha_evento: string;
    ip_origen: string;
    severidad: string;
    modulo: string;
    accion: string;
    tabla_afectada?: string;
    registro_id?: string;
    hash_integridad: string;
    payload_anterior?: Record<string, unknown> | null;
    payload_nuevo?: Record<string, unknown> | null;
    usuario?: { nombre: string; rol: string } | null;
}

export default function AuditoriaForensePage() {
    const [eventos, setEventos] = useState<EventoForense[]>([]);
    const [resumen, setResumen] = useState<Record<string, number>>({});
    const [severidad, setSeveridad] = useState('');
    const [modulo, setModulo] = useState('');
    const [seleccionado, setSeleccionado] = useState<EventoForense | null>(null);

    const cargar = async () => {
        const token = localStorage.getItem('token');
        const params = new URLSearchParams();
        if (severidad) params.set('severidad', severidad);
        if (modulo) params.set('modulo', modulo);

        const res = await fetch(`/api/auditoria-forense?${params.toString()}`, {
            headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        });
        if (res.ok) {
            const data = await res.json();
            setEventos(data.eventos || []);
            setResumen(data.resumen_severidad || {});
        }
    };

    useEffect(() => {
        cargar();
    }, [severidad]);

    return (
        <div className="dashboard-app">
            <Head title="Auditoría Forense - Los Angelitos" />
            <main className="dashboard-main">
                <DashboardTopNav title="Auditoría Forense" />
                <div className="dashboard-content">
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(160px, 1fr))', gap: '12px', marginBottom: '20px' }}>
                        {(['INFO', 'WARNING', 'CRITICAL', 'SECURITY_ALERT'] as const).map((sev) => (
                            <div key={sev} className="dashboard-panel" style={{ padding: '14px', textAlign: 'center' }}>
                                <div style={{ fontSize: '22px', fontWeight: 800, color: 'var(--dashboard-forest)' }}>{resumen[sev] || 0}</div>
                                <div style={{ fontSize: '11px', fontWeight: 700, color: '#64748b' }}>{sev}</div>
                            </div>
                        ))}
                    </div>

                    <div className="dashboard-panel" style={{ padding: '16px', marginBottom: '20px', display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                        <select value={severidad} onChange={(e) => setSeveridad(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                            <option value="">Todas las severidades</option>
                            <option value="INFO">INFO</option>
                            <option value="WARNING">WARNING</option>
                            <option value="CRITICAL">CRITICAL</option>
                            <option value="SECURITY_ALERT">SECURITY_ALERT</option>
                        </select>
                        <input placeholder="Filtrar por módulo..." value={modulo} onChange={(e) => setModulo(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1', flex: 1 }} />
                        <button type="button" onClick={cargar} style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>Buscar</button>
                    </div>

                    <div className="dashboard-panel" style={{ padding: '20px' }}>
                        <div style={{ overflowX: 'auto' }}>
                            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '12.5px' }}>
                                <thead>
                                    <tr style={{ backgroundColor: '#243d34', color: '#fff' }}>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Fecha</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Severidad</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Usuario / IP</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Módulo / Acción</th>
                                        <th style={{ padding: '10px', textAlign: 'left' }}>Hash SHA-256</th>
                                        <th style={{ padding: '10px', textAlign: 'center' }}>Diff</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {eventos.map((ev) => (
                                        <tr key={ev.id} style={{ borderBottom: '1px solid #e2e8f0' }}>
                                            <td style={{ padding: '10px' }}>{new Date(ev.fecha_evento).toLocaleString('es-BO')}</td>
                                            <td style={{ padding: '10px', fontWeight: 700 }}>{ev.severidad}</td>
                                            <td style={{ padding: '10px' }}>{ev.usuario?.nombre || 'Sistema'} · {ev.ip_origen}</td>
                                            <td style={{ padding: '10px' }}>{ev.modulo} · <strong>{ev.accion}</strong></td>
                                            <td style={{ padding: '10px', fontFamily: 'monospace', fontSize: '11px' }}>{ev.hash_integridad.slice(0, 16)}…</td>
                                            <td style={{ padding: '10px', textAlign: 'center' }}>
                                                <button type="button" onClick={() => setSeleccionado(ev)} style={{ padding: '4px 10px', borderRadius: '6px', border: '1px solid #cbd5e1', cursor: 'pointer' }}>Ver JSON</button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>

                    {seleccionado && (
                        <div className="dashboard-panel" style={{ padding: '20px', marginTop: '16px' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                <h3 style={{ margin: 0 }}>Detalle Inmutable #{seleccionado.id}</h3>
                                <button type="button" onClick={() => setSeleccionado(null)}>✕</button>
                            </div>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginTop: '12px' }}>
                                <pre style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '8px', fontSize: '11.5px', overflowX: 'auto' }}>
                                    Anterior:{'\n'}{JSON.stringify(seleccionado.payload_anterior, null, 2)}
                                </pre>
                                <pre style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '8px', fontSize: '11.5px', overflowX: 'auto' }}>
                                    Nuevo:{'\n'}{JSON.stringify(seleccionado.payload_nuevo, null, 2)}
                                </pre>
                            </div>
                        </div>
                    )}
                </div>
            </main>
        </div>
    );
}

