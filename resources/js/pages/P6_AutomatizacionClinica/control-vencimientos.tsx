import { Head, Link } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import authService from '@/services/authService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

interface LoteItem {
    id_lote: number;
    articulo_id: number;
    nombre: string;
    categoria: string;
    unidad_medida: string;
    cantidad_disponible: string | number;
    fecha_vencimiento: string;
    dias_restantes: number;
    estado: string;
    nivel_urgencia: 'critico' | 'alta' | 'media' | 'baja';
}

interface ResumenAlertas {
    total_vencidos: number;
    total_criticos_30: number;
    total_preventivos_60: number;
    total_vigentes: number;
}

export default function ControlVencimientos() {
    const [alertas, setAlertas] = useState<{
        vencidos: LoteItem[];
        criticos_30_dias: LoteItem[];
        preventivos_60_dias: LoteItem[];
        optimos: LoteItem[];
    }>({
        vencidos: [],
        criticos_30_dias: [],
        preventivos_60_dias: [],
        optimos: [],
    });
    const [resumen, setResumen] = useState<ResumenAlertas>({
        total_vencidos: 0,
        total_criticos_30: 0,
        total_preventivos_60: 0,
        total_vigentes: 0,
    });
    const [cargando, setCargando] = useState(true);
    const [filtro, setFiltro] = useState<'todos' | 'vencidos' | 'criticos' | 'preventivos'>('todos');
    const [busqueda, setBusqueda] = useState('');

    const token = authService.getToken();

    const cargarVencimientos = async () => {
        setCargando(true);
        try {
            const res = await fetch('/api/clinica/vencimientos', {
                headers: {
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
            });
            if (res.ok) {
                const data = await res.json();
                setAlertas(data.alertas);
                setResumen(data.resumen);
            }
        } catch (error) {
            console.error('Error cargando vencimientos:', error);
        } finally {
            setCargando(false);
        }
    };

    useEffect(() => {
        cargarVencimientos();
    }, []);

    const todosLosLotes = [
        ...alertas.vencidos,
        ...alertas.criticos_30_dias,
        ...alertas.preventivos_60_dias,
        ...alertas.optimos,
    ];

    const lotesFiltrados = todosLosLotes.filter((item) => {
        if (filtro === 'vencidos' && item.nivel_urgencia !== 'critico') return false;
        if (filtro === 'criticos' && item.nivel_urgencia !== 'alta') return false;
        if (filtro === 'preventivos' && item.nivel_urgencia !== 'media') return false;
        if (busqueda.trim()) {
            const query = busqueda.toLowerCase();
            return (
                item.nombre.toLowerCase().includes(query) ||
                item.categoria.toLowerCase().includes(query)
            );
        }
        return true;
    });

    return (
        <div className="dashboard-app">
            <Head title="Control y Alertas de Vencimiento de Fármacos (P6) - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Alertas de Vencimiento (P6)" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">P6: AUTOMATIZACIÓN CLÍNICA</p>
                                <h2>Control y Alertas Preventivas de Caducidad</h2>
                                <p>CU16: Monitoreo preventivo de lotes clínicos a 30 y 60 días para evitar pérdidas y suministros caducados.</p>
                            </div>
                            <button onClick={cargarVencimientos} className="submit-btn" style={{ width: 'auto', padding: '10px 20px', cursor: 'pointer' }} disabled={cargando}>
                                {cargando ? 'Actualizando...' : 'Recargar Lotes'}
                            </button>
                        </div>
                    </section>

                <div className="stats-grid" style={{ marginBottom: '24px' }}>
                    <div className="stat-card" style={{ borderLeft: '4px solid #ef4444' }}>
                        <span className="stat-label">Lotes Vencidos</span>
                        <span className="stat-value" style={{ color: '#ef4444' }}>{resumen.total_vencidos}</span>
                        <span className="stat-hint">Retirar de stock inmediatamente</span>
                    </div>
                    <div className="stat-card" style={{ borderLeft: '4px solid #f97316' }}>
                        <span className="stat-label">Alerta Crítica (&le; 30 días)</span>
                        <span className="stat-value" style={{ color: '#f97316' }}>{resumen.total_criticos_30}</span>
                        <span className="stat-hint">Priorizar consumo clínico</span>
                    </div>
                    <div className="stat-card" style={{ borderLeft: '4px solid #eab308' }}>
                        <span className="stat-label">Alerta Preventiva (&le; 60 días)</span>
                        <span className="stat-value" style={{ color: '#ca8a04' }}>{resumen.total_preventivos_60}</span>
                        <span className="stat-hint">Notificar a veterinarios</span>
                    </div>
                    <div className="stat-card" style={{ borderLeft: '4px solid #22c55e' }}>
                        <span className="stat-label">Vigentes (&gt; 60 días)</span>
                        <span className="stat-value" style={{ color: '#22c55e' }}>{resumen.total_vigentes}</span>
                        <span className="stat-hint">Stock en condición óptima</span>
                    </div>
                </div>

                <div className="table-card">
                    <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--dashboard-line)', display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '16px', backgroundColor: '#fcfdfb' }}>
                        <div className="filter-tabs" style={{ marginBottom: 0 }}>
                            <button
                                className={`filter-btn ${filtro === 'todos' ? 'active' : ''}`}
                                onClick={() => setFiltro('todos')}
                            >
                                <span>Todos</span>
                                <span style={{ padding: '2px 7px', borderRadius: '10px', fontSize: '11px', backgroundColor: filtro === 'todos' ? '#e1e89f' : '#edf1e9', color: filtro === 'todos' ? '#183d35' : '#65736d', fontWeight: 800 }}>{todosLosLotes.length}</span>
                            </button>
                            <button
                                className={`filter-btn ${filtro === 'vencidos' ? 'active' : ''}`}
                                onClick={() => setFiltro('vencidos')}
                            >
                                <span>Vencidos</span>
                                <span style={{ padding: '2px 7px', borderRadius: '10px', fontSize: '11px', backgroundColor: filtro === 'vencidos' ? '#fee2e2' : '#edf1e9', color: filtro === 'vencidos' ? '#b91c1c' : '#65736d', fontWeight: 800 }}>{resumen.total_vencidos}</span>
                            </button>
                            <button
                                className={`filter-btn ${filtro === 'criticos' ? 'active' : ''}`}
                                onClick={() => setFiltro('criticos')}
                            >
                                <span>&le; 30 días</span>
                                <span style={{ padding: '2px 7px', borderRadius: '10px', fontSize: '11px', backgroundColor: filtro === 'criticos' ? '#ffedd5' : '#edf1e9', color: filtro === 'criticos' ? '#c2410c' : '#65736d', fontWeight: 800 }}>{resumen.total_criticos_30}</span>
                            </button>
                            <button
                                className={`filter-btn ${filtro === 'preventivos' ? 'active' : ''}`}
                                onClick={() => setFiltro('preventivos')}
                            >
                                <span>&le; 60 días</span>
                                <span style={{ padding: '2px 7px', borderRadius: '10px', fontSize: '11px', backgroundColor: filtro === 'preventivos' ? '#fef9c3' : '#edf1e9', color: filtro === 'preventivos' ? '#854d0e' : '#65736d', fontWeight: 800 }}>{resumen.total_preventivos_60}</span>
                            </button>
                        </div>
                        <input
                            type="text"
                            placeholder="Buscar fármaco o categoría..."
                            value={busqueda}
                            onChange={(e) => setBusqueda(e.target.value)}
                            style={{ minHeight: '38px', padding: '0 12px', borderRadius: '4px', border: '1px solid var(--dashboard-line)', background: '#fff', fontSize: '12.5px', width: '260px' }}
                        />
                    </div>

                    <div className="table-responsive">
                        <table className="data-table">
                            <thead>
                                <tr>
                                    <th>Lote #</th>
                                    <th>Fármaco / Insumo</th>
                                    <th>Categoría</th>
                                    <th>Cant. Disponible</th>
                                    <th>Fecha Vencimiento</th>
                                    <th>Días Restantes</th>
                                    <th>Estado / Urgencia</th>
                                </tr>
                            </thead>
                            <tbody>
                                {cargando ? (
                                    <tr><td colSpan={7} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando lotes clínicos...</td></tr>
                                ) : lotesFiltrados.length === 0 ? (
                                    <tr><td colSpan={7} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay lotes que coincidan con el filtro seleccionado.</td></tr>
                                ) : (
                                    lotesFiltrados.map((item) => (
                                        <tr key={item.id_lote}>
                                            <td><strong style={{ color: 'var(--dashboard-forest)' }}>#{item.id_lote}</strong></td>
                                            <td><strong style={{ color: 'var(--dashboard-ink)' }}>{item.nombre}</strong></td>
                                            <td>{item.categoria}</td>
                                            <td>{item.cantidad_disponible} {item.unidad_medida}</td>
                                            <td>{item.fecha_vencimiento}</td>
                                            <td>
                                                {item.dias_restantes < 0 ? (
                                                    <span style={{ color: '#ef4444', fontWeight: 700 }}>Hace {Math.abs(item.dias_restantes)} días</span>
                                                ) : (
                                                    <span style={{ fontWeight: 600 }}>{item.dias_restantes} días</span>
                                                )}
                                            </td>
                                            <td>
                                                <span className={`badge-tag ${
                                                    item.nivel_urgencia === 'critico' ? 'badge-tag--danger' :
                                                    item.nivel_urgencia === 'alta' ? 'badge-tag--warning' :
                                                    item.nivel_urgencia === 'media' ? 'badge-tag--warning' : 'badge-tag--success'
                                                }`}>
                                                    {item.estado}
                                                </span>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
                </div>
            </main>
        </div>
    );
}
