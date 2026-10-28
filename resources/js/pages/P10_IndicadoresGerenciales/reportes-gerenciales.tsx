import { Head, Link } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

type EvolucionMes = {
    mes: string;
    adopciones: number;
    rescates: number;
    ingresos_donaciones: number;
};

type TopInsumo = {
    nombre: string;
    categoria: string;
    unidad_medida: string;
    total_consumido: number | string;
};

type PoblacionItem = {
    estado_actual?: string;
    especie?: string;
    total: number;
};

type ReporteData = {
    evolucion_mensual: EvolucionMes[];
    top_insumos_consumidos: TopInsumo[];
    poblacion_por_estado: PoblacionItem[];
    poblacion_por_especie: PoblacionItem[];
    indicadores_clave: {
        total_rescates_historico: number;
        total_adopciones_historico: number;
        tasa_adopcion_porcentaje: number;
        total_donaciones_monto: number;
    };
};

export default function ReportesGerencialesPage() {
    const [data, setData] = useState<ReporteData | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const token = localStorage.getItem('token');
        fetch('/api/reportes-gerenciales', {
            headers: {
                Accept: 'application/json',
                Authorization: `Bearer ${token ?? ''}`,
            },
        })
            .then(async (res) => {
                if (!res.ok) throw new Error('No se pudo cargar el reporte gerencial.');
                return res.json();
            })
            .then((resData) => {
                setData(resData);
                setLoading(false);
            })
            .catch((err: Error) => {
                setError(err.message);
                setLoading(false);
            });
    }, []);

    const exportarReporte = () => {
        if (!data) return;
        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `reporte-gerencial-${new Date().toISOString().slice(0, 10)}.json`;
        a.click();
        URL.revokeObjectURL(url);
    };

    return (
        <>
            <Head title="Reportes Gerenciales (P10) - Los Angelitos" />
            <div className="dashboard-app">
                <main className="dashboard-main">
                    <DashboardTopNav title="Reportes Gerenciales (P10)" />

                    <div className="dashboard-content">
                        <section className="dashboard-intro">
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                                <div>
                                    <p className="dashboard-eyebrow">MÉTRICAS OPERATIVAS Y DE IMPACTO</p>
                                    <h2>Indicadores Gerenciales y Estadísticas</h2>
                                    <p>CU25: Evolución semestral de adopciones vs rescates, rotación de insumos médicos y balance financiero.</p>
                                </div>
                                <div style={{ display: 'flex', gap: '10px' }}>
                                    <button
                                        type="button"
                                        onClick={() => window.print()}
                                        style={{
                                            padding: '8px 16px',
                                            borderRadius: '6px',
                                            border: '1px solid var(--dashboard-line)',
                                            backgroundColor: 'white',
                                            color: 'var(--dashboard-ink)',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                            fontSize: '13px',
                                        }}
                                    >
                                        🖨️ Imprimir
                                    </button>
                                    <button
                                        type="button"
                                        onClick={exportarReporte}
                                        disabled={!data}
                                        style={{
                                            padding: '8px 18px',
                                            borderRadius: '6px',
                                            border: 'none',
                                            backgroundColor: 'var(--dashboard-forest)',
                                            color: 'white',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                            fontSize: '13px',
                                        }}
                                    >
                                        📥 Exportar JSON
                                    </button>
                                </div>
                            </div>
                        </section>

                        {error && (
                            <div className="dashboard-error" role="alert">
                                <span>{error}</span>
                                <button type="button" onClick={() => window.location.reload()}>
                                    Reintentar
                                </button>
                            </div>
                        )}

                        {loading ? (
                            <p style={{ padding: '24px', color: 'var(--dashboard-muted)' }}>Cargando métricas consolidadas…</p>
                        ) : data ? (
                            <div style={{ display: 'flex', flexDirection: 'column', gap: '28px' }}>
                                {/* Indicadores clave */}
                                <section className="dashboard-stats">
                                    <article className="dashboard-stat">
                                        <span className="dashboard-stat__number" style={{ color: 'var(--dashboard-forest)' }}>
                                            {data.indicadores_clave.tasa_adopcion_porcentaje}%
                                        </span>
                                        <span className="dashboard-stat__label">Tasa de Adopción</span>
                                        <span className="dashboard-stat__detail">Efectividad global albergue</span>
                                    </article>

                                    <article className="dashboard-stat">
                                        <span className="dashboard-stat__number">
                                            {data.indicadores_clave.total_adopciones_historico}
                                        </span>
                                        <span className="dashboard-stat__label">Total Adopciones</span>
                                        <span className="dashboard-stat__detail">Mascotas con hogar formal</span>
                                    </article>

                                    <article className="dashboard-stat">
                                        <span className="dashboard-stat__number">
                                            {data.indicadores_clave.total_rescates_historico}
                                        </span>
                                        <span className="dashboard-stat__label">Total Rescatados</span>
                                        <span className="dashboard-stat__detail">Animales asistidos</span>
                                    </article>

                                    <article className="dashboard-stat">
                                        <span className="dashboard-stat__number" style={{ color: 'var(--dashboard-coral)' }}>
                                            Bs. {data.indicadores_clave.total_donaciones_monto.toFixed(2)}
                                        </span>
                                        <span className="dashboard-stat__label">Fondos Recaudados</span>
                                        <span className="dashboard-stat__detail">Aportes en donaciones</span>
                                    </article>
                                </section>

                                {/* Tabla Evolución Semestral */}
                                <section className="dashboard-intakes">
                                    <div className="dashboard-section-heading">
                                        <div>
                                            <p className="dashboard-eyebrow">TENDENCIA HISTÓRICA</p>
                                            <h2>Evolución de Rescates, Adopciones y Fondos (Últimos 6 meses)</h2>
                                        </div>
                                    </div>

                                    <div className="intake-table" role="table">
                                        <div className="intake-table__head" role="row">
                                            <span role="columnheader">Mes</span>
                                            <span role="columnheader">Rescates Ingresados</span>
                                            <span role="columnheader">Adopciones Formalizadas</span>
                                            <span role="columnheader">Recaudación Monetaria</span>
                                        </div>

                                        {data.evolucion_mensual.map((item, idx) => (
                                            <div className="intake-table__row" role="row" key={idx}>
                                                <span role="cell" style={{ fontWeight: 700 }}>
                                                    {item.mes}
                                                </span>
                                                <span role="cell" style={{ color: 'var(--dashboard-coral)', fontWeight: 600 }}>
                                                    🐾 {item.rescates} rescatados
                                                </span>
                                                <span role="cell" style={{ color: 'var(--dashboard-forest)', fontWeight: 600 }}>
                                                    ❤️ {item.adopciones} adoptados
                                                </span>
                                                <span role="cell" style={{ fontWeight: 700 }}>
                                                    Bs. {Number(item.ingresos_donaciones).toFixed(2)}
                                                </span>
                                            </div>
                                        ))}
                                    </div>
                                </section>

                                {/* Columnas: Insumos consumidos y Población */}
                                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: '24px' }}>
                                    <section style={{ backgroundColor: 'white', borderRadius: '8px', padding: '24px', border: '1px solid var(--dashboard-line)' }}>
                                        <p className="dashboard-eyebrow">INVENTARIO Y CLÍNICA</p>
                                        <h3 style={{ fontFamily: 'Georgia, serif', fontSize: '18px', margin: '4px 0 16px', color: 'var(--dashboard-forest)' }}>
                                            Top Insumos con Mayor Rotación
                                        </h3>
                                        {data.top_insumos_consumidos.length === 0 ? (
                                            <p style={{ color: 'var(--dashboard-muted)', fontSize: '13px' }}>Sin salidas registradas todavía.</p>
                                        ) : (
                                            <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'flex', flexDirection: 'column', gap: '10px' }}>
                                                {data.top_insumos_consumidos.map((ins, i) => (
                                                    <li key={i} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 14px', backgroundColor: 'var(--dashboard-paper)', borderRadius: '6px' }}>
                                                        <div>
                                                            <strong style={{ fontSize: '13px', color: 'var(--dashboard-ink)' }}>{ins.nombre}</strong>
                                                            <span style={{ display: 'block', fontSize: '11px', color: 'var(--dashboard-muted)' }}>{ins.categoria}</span>
                                                        </div>
                                                        <span style={{ fontWeight: 700, color: 'var(--dashboard-forest)', backgroundColor: '#e1e89f', padding: '3px 8px', borderRadius: '4px', fontSize: '12px' }}>
                                                            {ins.total_consumido} {ins.unidad_medida}
                                                        </span>
                                                    </li>
                                                ))}
                                            </ul>
                                        )}
                                    </section>

                                    <section style={{ backgroundColor: 'white', borderRadius: '8px', padding: '24px', border: '1px solid var(--dashboard-line)' }}>
                                        <p className="dashboard-eyebrow">POBLACIÓN ALBERGUE</p>
                                        <h3 style={{ fontFamily: 'Georgia, serif', fontSize: '18px', margin: '4px 0 16px', color: 'var(--dashboard-forest)' }}>
                                            Censo Actual de Mascotas
                                        </h3>
                                        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                                            <div>
                                                <span style={{ fontSize: '12px', fontWeight: 600, color: 'var(--dashboard-muted)', display: 'block', marginBottom: '8px' }}>Por Estado Clínico:</span>
                                                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                                                    {data.poblacion_por_estado.map((item, idx) => (
                                                        <span key={idx} style={{ backgroundColor: 'var(--dashboard-paper)', padding: '5px 12px', borderRadius: '9999px', fontSize: '12px', fontWeight: 600, color: 'var(--dashboard-forest)' }}>
                                                            {item.estado_actual}: <strong>{item.total}</strong>
                                                        </span>
                                                    ))}
                                                </div>
                                            </div>
                                            <div>
                                                <span style={{ fontSize: '12px', fontWeight: 600, color: 'var(--dashboard-muted)', display: 'block', marginBottom: '8px' }}>Por Especie:</span>
                                                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                                                    {data.poblacion_por_especie.map((item, idx) => (
                                                        <span key={idx} style={{ backgroundColor: '#fef3c7', color: '#92400e', padding: '5px 12px', borderRadius: '9999px', fontSize: '12px', fontWeight: 600 }}>
                                                            {item.especie}: <strong>{item.total}</strong>
                                                        </span>
                                                    ))}
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                </div>
                            </div>
                        ) : null}
                    </div>
                </main>
            </div>
        </>
    );
}
