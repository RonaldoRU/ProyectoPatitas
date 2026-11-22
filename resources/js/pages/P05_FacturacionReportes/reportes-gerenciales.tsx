/**
 * Vista de Reportes Gerenciales y Estadísticas (P10 - CU25):
 * Ofrece gráficos e indicadores semestrales:
 * - Tasa global de adopción vs rescates.
 * - Balance financiero y fondos recaudados.
 * - Rotación de insumos médicos más utilizados.
 * - Exportación a PDF imprimible, CSV y JSON dinámico.
 */
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

type MascotaRescatada = {
    id: number;
    nombre: string;
    especie: string;
    raza: string | null;
    sexo: string | null;
    edad: string | null;
    estado_actual: string;
    zona_rescate: string | null;
    fecha_ingreso: string;
};

type ReporteData = {
    periodo?: {
        fecha_desde: string;
        fecha_hasta: string;
        especie: string;
    };
    evolucion_mensual: EvolucionMes[];
    mascotas_rescatadas?: MascotaRescatada[];
    top_insumos_consumidos: TopInsumo[];
    poblacion_por_estado: PoblacionItem[];
    poblacion_por_especie: PoblacionItem[];
    indicadores_clave: {
        total_rescates_historico: number;
        total_rescates_periodo?: number;
        total_adopciones_historico: number;
        tasa_adopcion_porcentaje: number;
        total_donaciones_monto: number;
    };
};

export default function ReportesGerencialesPage() {
    const [data, setData] = useState<ReporteData | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [fechaDesde, setFechaDesde] = useState('');
    const [fechaHasta, setFechaHasta] = useState('');
    const [especieFiltro, setEspecieFiltro] = useState('');

    const cargarReporte = (desde?: string, hasta?: string, especie?: string) => {
        setLoading(true);
        setError('');
        const token = localStorage.getItem('token');
        const params = new URLSearchParams();
        if (desde) params.set('fecha_desde', desde);
        if (hasta) params.set('fecha_hasta', hasta);
        if (especie) params.set('especie', especie);
        const queryStr = params.toString() ? `?${params.toString()}` : '';

        fetch(`/api/reportes-gerenciales${queryStr}`, {
            headers: {
                Accept: 'application/json',
                Authorization: `Bearer ${token ?? ''}`,
            },
        })
            .then(async (res) => {
                if (!res.ok) throw new Error('No se pudo cargar el reporte gerencial.');
                return res.json();
            })
            .then((resData: ReporteData) => {
                setData(resData);
                if (!desde && resData.periodo?.fecha_desde) {
                    setFechaDesde(resData.periodo.fecha_desde);
                }
                if (!hasta && resData.periodo?.fecha_hasta) {
                    setFechaHasta(resData.periodo.fecha_hasta);
                }
                setLoading(false);
            })
            .catch((err: Error) => {
                setError(err.message);
                setLoading(false);
            });
    };

    useEffect(() => {
        cargarReporte();
    }, []);

    const exportarCSV = () => {
        if (!data) return;

        let csv = "\uFEFF";
        csv += "INFORME GERENCIAL CONSOLIDADO - ALBERGUE LOS ANGELITOS DE EDGAR\r\n";
        csv += `Fecha de generación:;${new Date().toLocaleString("es-BO")}\r\n\r\n`;

        csv += "--- INDICADORES GENERALES ---\r\n";
        csv += `Tasa Global de Adopción;${data.indicadores_clave.tasa_adopcion_porcentaje}%\r\n`;
        csv += `Total Animales Rescatados;${data.indicadores_clave.total_rescates_historico}\r\n`;
        csv += `Total Animales Adoptados;${data.indicadores_clave.total_adopciones_historico}\r\n`;
        csv += `Total Fondos Recaudados (BOB);${Number(data.indicadores_clave.total_donaciones_monto).toFixed(2)}\r\n\r\n`;

        csv += "--- EVOLUCIÓN HISTÓRICA MENSUAL ---\r\n";
        csv += "Mes;Rescates;Adopciones;Recaudación Donaciones (BOB)\r\n";
        data.evolucion_mensual.forEach((m) => {
            csv += `${m.mes};${m.rescates};${m.adopciones};${Number(m.ingresos_donaciones).toFixed(2)}\r\n`;
        });
        csv += "\r\n";

        csv += "--- TOP MEDICAMENTOS E INSUMOS CONSUMIDOS ---\r\n";
        csv += "Insumo / Medicamento;Categoría;Unidad de Medida;Total Consumido\r\n";
        data.top_insumos_consumidos.forEach((ins) => {
            csv += `"${ins.nombre}";${ins.categoria};${ins.unidad_medida};${ins.total_consumido}\r\n`;
        });
        csv += "\r\n";

        csv += "--- POBLACIÓN DE ANIMALES POR ESTADO ---\r\n";
        csv += "Estado en Albergue;Total Animales\r\n";
        data.poblacion_por_estado.forEach((p) => {
            csv += `${p.estado_actual};${p.total}\r\n`;
        });
        csv += "\r\n";

        csv += "--- MASCOTAS RESCATADAS POR FECHA DE INGRESO ---\r\n";
        csv += "ID;Nombre;Especie;Raza;Sexo;Edad;Fecha de Ingreso;Zona de Rescate;Estado Actual\r\n";
        (data.mascotas_rescatadas || []).forEach((m) => {
            csv += `${m.id};"${m.nombre}";${m.especie};"${m.raza || ''}";"${m.sexo || ''}";"${m.edad || ''}";${m.fecha_ingreso};"${m.zona_rescate || ''}";"${m.estado_actual}"\r\n`;
        });

        const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
        const url = URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = `reporte-gerencial-dinamico-${new Date().toISOString().slice(0, 10)}.csv`;
        a.click();
        URL.revokeObjectURL(url);
    };

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

    const exportarReportePDF = () => {
        if (!data) return;
        const printWin = window.open('', '_blank');
        if (!printWin) return;

        const filasSemestre = (data.evolucion_mensual || []).map((s: EvolucionMes) => `
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; font-weight: 600;">${s.mes}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; text-align: center;">${s.rescates}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; text-align: center;">${s.adopciones}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; text-align: right; color: #243d34; font-weight: 700;">Bs. ${parseFloat(String(s.ingresos_donaciones)).toFixed(2)}</td>
            </tr>
        `).join('');

        const filasMascotas = (data.mascotas_rescatadas || []).map((m: MascotaRescatada) => `
            <tr>
                <td style="padding: 8px 10px; border-bottom: 1px solid #e2e8f0;">#${m.id}</td>
                <td style="padding: 8px 10px; border-bottom: 1px solid #e2e8f0; font-weight: 600;">${m.nombre}</td>
                <td style="padding: 8px 10px; border-bottom: 1px solid #e2e8f0;">${m.especie}${m.raza ? ` (${m.raza})` : ''}</td>
                <td style="padding: 8px 10px; border-bottom: 1px solid #e2e8f0;">${m.fecha_ingreso}</td>
                <td style="padding: 8px 10px; border-bottom: 1px solid #e2e8f0;">${m.zona_rescate || '-'}</td>
                <td style="padding: 8px 10px; border-bottom: 1px solid #e2e8f0;">${m.estado_actual}</td>
            </tr>
        `).join('');

        printWin.document.write(`
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>Reporte Gerencial Oficial - Los Angelitos</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; padding: 35px; color: #1e293b; background: #ffffff; }
                    .header { border-bottom: 2px solid #243d34; padding-bottom: 14px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: flex-end; }
                    .title { color: #243d34; font-size: 22px; font-weight: 800; margin: 0; }
                    .kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 24px; }
                    .kpi-card { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px; text-align: center; }
                    .kpi-val { font-size: 22px; font-weight: 800; color: #243d34; }
                    .kpi-lbl { font-size: 11px; color: #64748b; text-transform: uppercase; font-weight: 700; margin-top: 4px; }
                    table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
                    th { background: #243d34; color: white; padding: 10px; font-size: 12px; text-align: left; }
                    @media print { .no-print { display: none; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="margin-bottom: 20px; display: flex; gap: 10px;">
                    <button onclick="window.print()" style="padding: 10px 20px; background-color: #243d34; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Imprimir / Guardar en PDF</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background-color: #e2e8f0; border: none; border-radius: 6px; cursor: pointer;">Cerrar</button>
                </div>
                <div class="header">
                    <div>
                        <h1 class="title">REFUGIO LOS ANGELITOS DE EDGAR</h1>
                        <p style="margin: 4px 0 0; color: #64748b; font-size: 12px; font-weight: 600;">INFORME Y BALANCE GERENCIAL OPERATIVO • SANTA CRUZ, BOLIVIA</p>
                    </div>
                    <div style="text-align: right; font-size: 12px; color: #64748b;">
                        Fecha de generación: ${new Date().toLocaleDateString("es-BO")}
                    </div>
                </div>

                <div class="kpis">
                    <div class="kpi-card">
                        <div class="kpi-val">${data.indicadores_clave.total_rescates_historico}</div>
                        <div class="kpi-lbl">Total Rescates</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-val">${data.indicadores_clave.total_adopciones_historico}</div>
                        <div class="kpi-lbl">Total Adopciones</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-val">${data.indicadores_clave.tasa_adopcion_porcentaje}%</div>
                        <div class="kpi-lbl">Tasa de Adopción</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-val">Bs. ${parseFloat(String(data.indicadores_clave.total_donaciones_monto)).toFixed(2)}</div>
                        <div class="kpi-lbl">Fondos Recaudados</div>
                    </div>
                </div>

                <h3 style="color: #243d34; font-size: 15px; margin-bottom: 10px;">Evolución y Actividad Semestral</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Mes</th>
                            <th style="text-align: center;">Rescates</th>
                            <th style="text-align: center;">Adopciones</th>
                            <th style="text-align: right;">Donaciones Recaudadas</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${filasSemestre}
                    </tbody>
                </table>

                <h3 style="color: #243d34; font-size: 15px; margin-bottom: 10px;">Detalle de Animales Rescatados por Fecha de Ingreso (${(data.mascotas_rescatadas || []).length})</h3>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Especie / Raza</th>
                            <th>Fecha de Ingreso</th>
                            <th>Zona de Rescate</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${filasMascotas}
                    </tbody>
                </table>
            </body>
            </html>
        `);
        printWin.document.close();
    };

    // Escucha de comando de voz para descargar / generar PDF
    useEffect(() => {
        const handleVoiceDownload = () => {
            exportarReportePDF();
        };
        window.addEventListener('voice-download-pdf', handleVoiceDownload);
        return () => window.removeEventListener('voice-download-pdf', handleVoiceDownload);
    }, [data]);

    return (
        <>
            <Head title="Reportes Gerenciales - Los Angelitos" />
            <div className="dashboard-app">
                <main className="dashboard-main">
                    <DashboardTopNav title="Reportes e Indicadores" />

                    <div className="dashboard-content">
                        <section className="dashboard-intro">
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                                <div>
                                    <p className="dashboard-eyebrow">MÉTRICAS OPERATIVAS Y DE IMPACTO</p>
                                    <h2>Indicadores Gerenciales y Estadísticas</h2>
                                    <p>Evolución semestral de adopciones vs rescates, rotación de insumos médicos y balance financiero.</p>
                                </div>
                                <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                                    <button
                                        type="button"
                                        onClick={exportarReportePDF}
                                        style={{
                                            padding: '8px 16px',
                                            borderRadius: '6px',
                                            border: '1px solid var(--dashboard-forest)',
                                            backgroundColor: 'white',
                                            color: 'var(--dashboard-forest)',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                            fontSize: '13px',
                                        }}
                                    >
                                        Reporte Oficial (Imprimir / PDF)
                                    </button>
                                    <button
                                        type="button"
                                        onClick={exportarCSV}
                                        disabled={!data}
                                        style={{
                                            padding: '8px 16px',
                                            borderRadius: '6px',
                                            border: '1px solid var(--dashboard-forest)',
                                            backgroundColor: '#f0fdf4',
                                            color: '#183d35',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                            fontSize: '13px',
                                        }}
                                    >
                                        Exportar CSV Dinámico
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
                                        Exportar JSON Dinámico
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
                                {/* Filtros por fecha de ingreso y especie */}
                                <section style={{ backgroundColor: 'white', borderRadius: '8px', padding: '16px 20px', border: '1px solid var(--dashboard-line)', display: 'flex', flexWrap: 'wrap', gap: '12px', alignItems: 'flex-end' }}>
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                                        <label htmlFor="rep-desde" style={{ fontSize: '12px', fontWeight: 700, color: 'var(--dashboard-muted)' }}>Desde (Fecha Ingreso)</label>
                                        <input id="rep-desde" type="date" value={fechaDesde} onChange={(e) => setFechaDesde(e.target.value)} style={{ padding: '7px 10px', borderRadius: '6px', border: '1px solid #cbd5e1', fontSize: '13px' }} />
                                    </div>
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                                        <label htmlFor="rep-hasta" style={{ fontSize: '12px', fontWeight: 700, color: 'var(--dashboard-muted)' }}>Hasta (Fecha Ingreso)</label>
                                        <input id="rep-hasta" type="date" value={fechaHasta} onChange={(e) => setFechaHasta(e.target.value)} style={{ padding: '7px 10px', borderRadius: '6px', border: '1px solid #cbd5e1', fontSize: '13px' }} />
                                    </div>
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                                        <label htmlFor="rep-especie" style={{ fontSize: '12px', fontWeight: 700, color: 'var(--dashboard-muted)' }}>Especie</label>
                                        <select id="rep-especie" value={especieFiltro} onChange={(e) => setEspecieFiltro(e.target.value)} style={{ padding: '7px 10px', borderRadius: '6px', border: '1px solid #cbd5e1', fontSize: '13px', backgroundColor: '#fff' }}>
                                            <option value="">Todas</option>
                                            <option value="Canino">Canino</option>
                                            <option value="Felino">Felino</option>
                                        </select>
                                    </div>
                                    <button
                                        type="button"
                                        onClick={() => cargarReporte(fechaDesde, fechaHasta, especieFiltro)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, fontSize: '13px', cursor: 'pointer' }}
                                    >
                                        Filtrar Fechas
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => {
                                            setFechaDesde('');
                                            setFechaHasta('');
                                            setEspecieFiltro('');
                                            cargarReporte('', '', '');
                                        }}
                                        style={{ padding: '8px 14px', borderRadius: '6px', border: '1px solid #cbd5e1', backgroundColor: '#f8fafc', color: '#334155', fontWeight: 600, fontSize: '13px', cursor: 'pointer' }}
                                    >
                                        Ver Todo el Historial
                                    </button>
                                </section>

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
                                            <h2>Evolución de Rescates, Adopciones y Fondos ({data.periodo ? `${data.periodo.fecha_desde} al ${data.periodo.fecha_hasta}` : 'Historial Completo'})</h2>
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
                                                    {item.rescates} rescatados
                                                </span>
                                                <span role="cell" style={{ color: 'var(--dashboard-forest)', fontWeight: 600 }}>
                                                    {item.adopciones} adoptados
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

                                {/* Registro Detallado de Mascotas Rescatadas por Fecha de Ingreso */}
                                <section className="dashboard-intakes">
                                    <div className="dashboard-section-heading">
                                        <div>
                                            <p className="dashboard-eyebrow">TRAZABILIDAD DE RESCATES</p>
                                            <h2>Animales Rescatados por Fecha de Ingreso ({(data.mascotas_rescatadas || []).length} registros)</h2>
                                        </div>
                                    </div>

                                    {(data.mascotas_rescatadas || []).length === 0 ? (
                                        <p style={{ color: 'var(--dashboard-muted)', fontSize: '14px', padding: '16px 0' }}>
                                            No se encontraron mascotas rescatadas en el rango de fechas seleccionado.
                                        </p>
                                    ) : (
                                        <div style={{ overflowX: 'auto', backgroundColor: '#ffffff', borderRadius: '8px', border: '1px solid var(--dashboard-line)' }}>
                                            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
                                                <thead>
                                                    <tr style={{ backgroundColor: 'var(--dashboard-paper)', textAlign: 'left', borderBottom: '1px solid var(--dashboard-line)' }}>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>ID</th>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>Fecha de Ingreso</th>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>Nombre</th>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>Especie / Raza</th>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>Sexo / Edad</th>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>Zona de Rescate</th>
                                                        <th style={{ padding: '10px 12px', color: 'var(--dashboard-forest)' }}>Estado Actual</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {(data.mascotas_rescatadas || []).map((m) => (
                                                        <tr key={m.id} style={{ borderBottom: '1px solid #f1f5f9' }}>
                                                            <td style={{ padding: '9px 12px', fontWeight: 700, color: 'var(--dashboard-muted)' }}>#{m.id}</td>
                                                            <td style={{ padding: '9px 12px', fontWeight: 700, color: 'var(--dashboard-coral)' }}>{m.fecha_ingreso}</td>
                                                            <td style={{ padding: '9px 12px', fontWeight: 700, color: 'var(--dashboard-ink)' }}>{m.nombre}</td>
                                                            <td style={{ padding: '9px 12px' }}>{m.especie}{m.raza ? ` · ${m.raza}` : ''}</td>
                                                            <td style={{ padding: '9px 12px', color: '#475569' }}>{m.sexo || '-'}{m.edad ? ` (${m.edad})` : ''}</td>
                                                            <td style={{ padding: '9px 12px', color: '#475569' }}>{m.zona_rescate || '-'}</td>
                                                            <td style={{ padding: '9px 12px' }}>
                                                                <span style={{ backgroundColor: '#edf3ec', color: 'var(--dashboard-forest)', padding: '3px 9px', borderRadius: '999px', fontSize: '11.5px', fontWeight: 700 }}>
                                                                    {m.estado_actual}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    ))}
                                                </tbody>
                                            </table>
                                        </div>
                                    )}
                                </section>
                            </div>
                        ) : null}
                    </div>
                </main>
            </div>
        </>
    );
}
