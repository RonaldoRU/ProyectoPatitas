import { Head } from '@inertiajs/react';
import React, { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';

interface Dosificacion {
    id: number;
    nit_emisor: string;
    numero_autorizacion: string;
    numero_inicial: number;
    numero_final: number;
    correlativo_actual: number;
    fecha_limite_emision: string;
    leyenda_tributaria: string;
    activa: boolean;
    creador?: { nombre: string };
}

export default function DosificacionesFiscales() {
    const [dosificaciones, setDosificaciones] = useState<Dosificacion[]>([]);
    const [cargando, setCargando] = useState(true);
    const [guardando, setGuardando] = useState(false);
    const [mensaje, setMensaje] = useState<{ tipo: 'ok' | 'error'; texto: string } | null>(null);

    const [nitEmisor, setNitEmisor] = useState('');
    const [numeroAutorizacion, setNumeroAutorizacion] = useState('');
    const [llaveDosificacion, setLlaveDosificacion] = useState('');
    const [numeroInicial, setNumeroInicial] = useState('1');
    const [numeroFinal, setNumeroFinal] = useState('1000');
    const [fechaLimite, setFechaLimite] = useState('');
    const [leyenda, setLeyenda] = useState('Ley N° 453: Tienes derecho a recibir información sobre las características y contenidos de los servicios que utilices.');

    const cargar = async () => {
        setCargando(true);
        const token = localStorage.getItem('token');
        try {
            const res = await fetch('/api/dosificaciones-fiscales', {
                headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
            });
            if (res.ok) {
                const data = await res.json();
                setDosificaciones(data.dosificaciones || []);
            }
        } finally {
            setCargando(false);
        }
    };

    useEffect(() => {
        cargar();
    }, []);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setGuardando(true);
        setMensaje(null);
        const token = localStorage.getItem('token');

        try {
            const res = await fetch('/api/dosificaciones-fiscales', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    ...(token ? { Authorization: `Bearer ${token}` } : {}),
                },
                body: JSON.stringify({
                    nit_emisor: nitEmisor,
                    numero_autorizacion: numeroAutorizacion,
                    llave_dosificacion: llaveDosificacion,
                    numero_inicial: Number(numeroInicial),
                    numero_final: Number(numeroFinal),
                    fecha_limite_emision: fechaLimite,
                    leyenda_tributaria: leyenda,
                }),
            });

            const data = await res.json();
            if (!res.ok) {
                setMensaje({ tipo: 'error', texto: data.mensaje || data.message || 'No se pudo registrar la dosificación.' });
                return;
            }

            setMensaje({ tipo: 'ok', texto: data.mensaje });
            setNumeroAutorizacion('');
            setLlaveDosificacion('');
            await cargar();
        } finally {
            setGuardando(false);
        }
    };

    return (
        <div className="dashboard-app">
            <Head title="Dosificación Fiscal - Los Angelitos" />
            <main className="dashboard-main">
                <DashboardTopNav title="Dosificación Fiscal" />
                <div className="dashboard-content">
                    {mensaje && (
                        <div
                            style={{
                                padding: '12px 16px',
                                borderRadius: '8px',
                                marginBottom: '16px',
                                backgroundColor: mensaje.tipo === 'ok' ? '#dcfce7' : '#fee2e2',
                                color: mensaje.tipo === 'ok' ? '#166534' : '#991b1b',
                                fontWeight: 600,
                            }}
                        >
                            {mensaje.texto}
                        </div>
                    )}

                    <div className="dashboard-panel" style={{ padding: '20px', marginBottom: '20px' }}>
                        <h2 style={{ marginTop: 0, color: 'var(--dashboard-forest)' }}>Registrar Nueva Dosificación Tributaria</h2>
                        <form onSubmit={handleSubmit} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '12px' }}>
                            <div>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>NIT Emisor</label>
                                <input className="dashboard-input" value={nitEmisor} onChange={(e) => setNitEmisor(e.target.value)} required placeholder="Ej: 1020304021" style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>N° Autorización</label>
                                <input className="dashboard-input" value={numeroAutorizacion} onChange={(e) => setNumeroAutorizacion(e.target.value)} required placeholder="Ej: 290400110022" style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>N° Inicial</label>
                                <input type="number" min={1} value={numeroInicial} onChange={(e) => setNumeroInicial(e.target.value)} required style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>N° Final</label>
                                <input type="number" min={1} value={numeroFinal} onChange={(e) => setNumeroFinal(e.target.value)} required style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>Fecha Límite Emisión</label>
                                <input type="date" value={fechaLimite} onChange={(e) => setFechaLimite(e.target.value)} required style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>Llave de Dosificación (AES-256)</label>
                                <input type="password" value={llaveDosificacion} onChange={(e) => setLlaveDosificacion(e.target.value)} required minLength={10} placeholder="Mínimo 10 caracteres" style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div style={{ gridColumn: '1 / -1' }}>
                                <label style={{ display: 'block', fontSize: '12px', fontWeight: 700, marginBottom: '4px' }}>Leyenda Tributaria</label>
                                <input value={leyenda} onChange={(e) => setLeyenda(e.target.value)} required style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            </div>
                            <div style={{ gridColumn: '1 / -1' }}>
                                <button type="submit" disabled={guardando} style={{ padding: '10px 20px', borderRadius: '8px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>
                                    {guardando ? 'Guardando...' : 'Activar Dosificación Fiscal'}
                                </button>
                            </div>
                        </form>
                    </div>

                    <div className="dashboard-panel" style={{ padding: '20px' }}>
                        <h3 style={{ marginTop: 0 }}>Historial de Dosificaciones</h3>
                        {cargando ? (
                            <p>Cargando...</p>
                        ) : (
                            <div style={{ overflowX: 'auto' }}>
                                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
                                    <thead>
                                        <tr style={{ backgroundColor: '#243d34', color: '#fff' }}>
                                            <th style={{ padding: '10px', textAlign: 'left' }}>NIT</th>
                                            <th style={{ padding: '10px', textAlign: 'left' }}>Autorización</th>
                                            <th style={{ padding: '10px', textAlign: 'center' }}>Rango</th>
                                            <th style={{ padding: '10px', textAlign: 'center' }}>Correlativo Actual</th>
                                            <th style={{ padding: '10px', textAlign: 'center' }}>Fecha Límite</th>
                                            <th style={{ padding: '10px', textAlign: 'center' }}>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {dosificaciones.map((d) => (
                                            <tr key={d.id} style={{ borderBottom: '1px solid #e2e8f0' }}>
                                                <td style={{ padding: '10px' }}>{d.nit_emisor}</td>
                                                <td style={{ padding: '10px', fontWeight: 600 }}>{d.numero_autorizacion}</td>
                                                <td style={{ padding: '10px', textAlign: 'center' }}>{d.numero_inicial} - {d.numero_final}</td>
                                                <td style={{ padding: '10px', textAlign: 'center' }}>{d.correlativo_actual}</td>
                                                <td style={{ padding: '10px', textAlign: 'center' }}>{d.fecha_limite_emision?.slice(0, 10)}</td>
                                                <td style={{ padding: '10px', textAlign: 'center' }}>
                                                    <span style={{ padding: '3px 8px', borderRadius: '12px', fontSize: '11px', fontWeight: 700, backgroundColor: d.activa ? '#dcfce7' : '#e2e8f0', color: d.activa ? '#166534' : '#475569' }}>
                                                        {d.activa ? 'ACTIVA' : 'INACTIVA'}
                                                    </span>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>
            </main>
        </div>
    );
}

