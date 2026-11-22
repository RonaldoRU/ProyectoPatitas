import { Head } from '@inertiajs/react';
import React, { useEffect, useMemo, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';

interface MascotaItem { id: number; nombre: string; especie: string }
interface ArticuloItem { id: number; nombre: string; unidad_medida: string; stock_actual: string }
interface TomaItem { id: number; fecha_hora_programada: string; estado: string; lote?: { fecha_vencimiento: string | null } }
interface PrescripcionItem {
    id: number;
    peso_mascota_kg: string;
    dosis_calculada_unidad: string;
    unidad_medida: string;
    frecuencia_horas: number;
    duracion_dias: number;
    mascota?: MascotaItem;
    articulo?: ArticuloItem;
    cronograma?: TomaItem[];
}

export default function DosificacionClinica() {
    const [mascotas, setMascotas] = useState<MascotaItem[]>([]);
    const [articulos, setArticulos] = useState<ArticuloItem[]>([]);
    const [prescripciones, setPrescripciones] = useState<PrescripcionItem[]>([]);
    const [mensaje, setMensaje] = useState<string>('');

    const [mascotaId, setMascotaId] = useState('');
    const [articuloId, setArticuloId] = useState('');
    const [pesoKg, setPesoKg] = useState('12');
    const [dosisMgKg, setDosisMgKg] = useState('10');
    const [concentracion, setConcentracion] = useState('50');
    const [unidad, setUnidad] = useState('ml');
    const [frecuencia, setFrecuencia] = useState('8');
    const [duracion, setDuracion] = useState('5');

    const dosisEstimada = useMemo(() => {
        const p = parseFloat(pesoKg) || 0;
        const d = parseFloat(dosisMgKg) || 0;
        const c = parseFloat(concentracion) || 1;
        return ((p * d) / c).toFixed(3);
    }, [pesoKg, dosisMgKg, concentracion]);

    const cargar = async () => {
        const token = localStorage.getItem('token');
        const headers = { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) };
        const [catRes, listRes] = await Promise.all([
            fetch('/api/dosificacion-clinica/catalogos', { headers }),
            fetch('/api/dosificacion-clinica', { headers }),
        ]);
        if (catRes.ok) {
            const cat = await catRes.json();
            setMascotas(cat.mascotas || []);
            setArticulos(cat.articulos || []);
        }
        if (listRes.ok) {
            const list = await listRes.json();
            setPrescripciones(list.prescripciones || []);
        }
    };

    useEffect(() => {
        cargar();
    }, []);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        const token = localStorage.getItem('token');
        const res = await fetch('/api/dosificacion-clinica', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                ...(token ? { Authorization: `Bearer ${token}` } : {}),
            },
            body: JSON.stringify({
                mascota_id: Number(mascotaId),
                articulo_id: Number(articuloId),
                peso_mascota_kg: Number(pesoKg),
                dosis_mg_kg: Number(dosisMgKg),
                concentracion_farmaco: Number(concentracion),
                unidad_medida: unidad,
                frecuencia_horas: Number(frecuencia),
                duracion_dias: Number(duracion),
            }),
        });
        const data = await res.json();
        setMensaje(data.mensaje || data.message || 'Operación completada');
        if (res.ok) await cargar();
    };

    const marcarToma = async (tomaId: number) => {
        const token = localStorage.getItem('token');
        await fetch(`/api/dosificacion-clinica/tomas/${tomaId}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                ...(token ? { Authorization: `Bearer ${token}` } : {}),
            },
            body: JSON.stringify({ estado: 'ADMINISTRADO' }),
        });
        await cargar();
    };

    return (
        <div className="dashboard-app">
            <Head title="Dosificación Clínica Automática - Los Angelitos" />
            <main className="dashboard-main">
                <DashboardTopNav title="Dosificación Clínica Automática" />
                <div className="dashboard-content">
                    {mensaje && <div style={{ padding: '12px', borderRadius: '8px', backgroundColor: '#edf3ec', color: '#243d34', fontWeight: 700, marginBottom: '16px' }}>{mensaje}</div>}

                    <div className="dashboard-panel" style={{ padding: '20px', marginBottom: '20px' }}>
                        <h2 style={{ marginTop: 0, color: 'var(--dashboard-forest)' }}>Calculadora de Dosificación y Cronograma FEFO</h2>
                        <form onSubmit={handleSubmit} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '12px' }}>
                            <select value={mascotaId} onChange={(e) => setMascotaId(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                                <option value="">Seleccionar mascota...</option>
                                {mascotas.map((m) => <option key={m.id} value={m.id}>{m.nombre} ({m.especie})</option>)}
                            </select>
                            <select value={articuloId} onChange={(e) => setArticuloId(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                                <option value="">Seleccionar fármaco...</option>
                                {articulos.map((a) => <option key={a.id} value={a.id}>{a.nombre} (Stock: {a.stock_actual})</option>)}
                            </select>
                            <input type="number" step="0.01" placeholder="Peso (kg)" value={pesoKg} onChange={(e) => setPesoKg(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input type="number" step="0.001" placeholder="Dosis (mg/kg)" value={dosisMgKg} onChange={(e) => setDosisMgKg(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input type="number" step="0.001" placeholder="Concentración (mg/unidad)" value={concentracion} onChange={(e) => setConcentracion(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <input placeholder="Unidad (ml, comp)" value={unidad} onChange={(e) => setUnidad(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <select value={frecuencia} onChange={(e) => setFrecuencia(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                                <option value="8">Cada 8 horas</option>
                                <option value="12">Cada 12 horas</option>
                                <option value="24">Cada 24 horas</option>
                            </select>
                            <input type="number" min={1} placeholder="Duración (días)" value={duracion} onChange={(e) => setDuracion(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                            <div style={{ gridColumn: '1 / -1', display: 'flex', justifyContent: 'space-between', alignItems: 'center', backgroundColor: '#f8fafc', padding: '12px', borderRadius: '8px' }}>
                                <span>Dosis calculada por toma: <strong style={{ color: '#243d34', fontSize: '16px' }}>{dosisEstimada} {unidad}</strong></span>
                                <button type="submit" style={{ padding: '10px 20px', borderRadius: '8px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>
                                    Generar Prescripción y Cronograma
                                </button>
                            </div>
                        </form>
                    </div>

                    <div className="dashboard-panel" style={{ padding: '20px' }}>
                        <h3 style={{ marginTop: 0 }}>Prescripciones y Tomas Programadas</h3>
                        {prescripciones.map((p) => (
                            <div key={p.id} style={{ border: '1px solid #e2e8f0', borderRadius: '8px', padding: '14px', marginBottom: '12px' }}>
                                <div style={{ fontWeight: 700, marginBottom: '8px' }}>
                                    {p.mascota?.nombre} · {p.articulo?.nombre} — {p.dosis_calculada_unidad} {p.unidad_medida} cada {p.frecuencia_horas}h ({p.duracion_dias} días)
                                </div>
                                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                                    {(p.cronograma || []).slice(0, 8).map((t) => (
                                        <button
                                            key={t.id}
                                            type="button"
                                            disabled={t.estado === 'ADMINISTRADO'}
                                            onClick={() => marcarToma(t.id)}
                                            style={{
                                                padding: '6px 10px',
                                                borderRadius: '6px',
                                                border: '1px solid #cbd5e1',
                                                backgroundColor: t.estado === 'ADMINISTRADO' ? '#dcfce7' : '#fff',
                                                fontSize: '12px',
                                                cursor: t.estado === 'ADMINISTRADO' ? 'default' : 'pointer',
                                            }}
                                        >
                                            {new Date(t.fecha_hora_programada).toLocaleString('es-BO', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' })} · {t.estado}
                                        </button>
                                    ))}
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </main>
        </div>
    );
}

