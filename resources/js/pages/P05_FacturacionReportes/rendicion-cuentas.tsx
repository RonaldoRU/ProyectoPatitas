import { Head } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';

interface RendicionData {
    plantilla: string;
    fecha_inicio: string;
    fecha_fin: string;
    ingresos: { donaciones_monetarias: number; servicios_facturados: number; total: number };
    egresos: { facturas_compras_iva: number; compras_abastecimiento: number; total: number };
    balance: { saldo_neto: number; unidades_inventario_actual: number };
    hash_integridad: string;
    historial_emisiones: Array<{ id: number; anio: number; mes: number; hash_documento: string; created_at: string }>;
}

export default function RendicionCuentasPage() {
    const [fechaInicio, setFechaInicio] = useState(new Date(new Date().getFullYear(), 0, 1).toISOString().slice(0, 10));
    const [fechaFin, setFechaFin] = useState(new Date().toISOString().slice(0, 10));
    const [plantilla, setPlantilla] = useState('Informe Semestral Entidad Pública');
    const [data, setData] = useState<RendicionData | null>(null);
    const [mensaje, setMensaje] = useState('');

    const cargar = async () => {
        const token = localStorage.getItem('token');
        const params = new URLSearchParams({ fecha_inicio: fechaInicio, fecha_fin: fechaFin, plantilla });
        const res = await fetch(`/api/rendicion-cuentas?${params.toString()}`, {
            headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        });
        if (res.ok) {
            setData(await res.json());
        }
    };

    useEffect(() => {
        cargar();
    }, [fechaInicio, fechaFin, plantilla]);

    const emitirOficialPDF = async () => {
        const token = localStorage.getItem('token');
        const res = await fetch('/api/rendicion-cuentas/emitir', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                ...(token ? { Authorization: `Bearer ${token}` } : {}),
            },
            body: JSON.stringify({ fecha_inicio: fechaInicio, fecha_fin: fechaFin, plantilla }),
        });
        if (!res.ok) return;
        const json = await res.json();
        setMensaje(json.mensaje);
        await cargar();

        const d: RendicionData = json.datos;
        const win = window.open('', '_blank');
        if (!win) return;
        win.document.write(`
            <!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>${d.plantilla}</title>
            <style>body{font-family:sans-serif;padding:36px;color:#1e293b}h1{color:#243d34}table{width:100%;border-collapse:collapse;margin:20px 0}th,td{padding:10px;border-bottom:1px solid #e2e8f0;text-align:left}th{background:#243d34;color:#fff}.hash{font-family:monospace;font-size:11px;color:#475569;margin-top:24px}</style>
            </head><body>
                <button onclick="window.print()" style="padding:10px 16px;background:#243d34;color:#fff;border:none;border-radius:6px;cursor:pointer;">Imprimir / Guardar PDF</button>
                <h1>REFUGIO LOS ANGELITOS DE EDGAR — ${d.plantilla}</h1>
                <p>Período: ${d.fecha_inicio} al ${d.fecha_fin}</p>
                <table>
                    <thead><tr><th>Concepto</th><th>Monto (Bs.)</th></tr></thead>
                    <tbody>
                        <tr><td>Ingresos por Donaciones Monetarias</td><td>${d.ingresos.donaciones_monetarias.toFixed(2)}</td></tr>
                        <tr><td>Ingresos por Servicios Facturados</td><td>${d.ingresos.servicios_facturados.toFixed(2)}</td></tr>
                        <tr><td><strong>Total Ingresos</strong></td><td><strong>${d.ingresos.total.toFixed(2)}</strong></td></tr>
                        <tr><td>Egresos por Facturas de Compras IVA</td><td>${d.egresos.facturas_compras_iva.toFixed(2)}</td></tr>
                        <tr><td>Egresos por Abastecimiento</td><td>${d.egresos.compras_abastecimiento.toFixed(2)}</td></tr>
                        <tr><td><strong>Total Egresos</strong></td><td><strong>${d.egresos.total.toFixed(2)}</strong></td></tr>
                        <tr><td><strong>Saldo Neto del Período</strong></td><td><strong>${d.balance.saldo_neto.toFixed(2)}</strong></td></tr>
                    </tbody>
                </table>
                <div class="hash">Sello de Integridad SHA-256: ${d.hash_integridad}</div>
            </body></html>
        `);
        win.document.close();
    };

    return (
        <div className="dashboard-app">
            <Head title="Rendición de Cuentas - Los Angelitos" />
            <main className="dashboard-main">
                <DashboardTopNav title="Rendición de Cuentas" />
                <div className="dashboard-content">
                    {mensaje && <div style={{ padding: '12px', borderRadius: '8px', backgroundColor: '#dcfce7', color: '#166534', fontWeight: 700, marginBottom: '16px' }}>{mensaje}</div>}

                    <div className="dashboard-panel" style={{ padding: '16px', marginBottom: '20px', display: 'flex', gap: '12px', flexWrap: 'wrap', alignItems: 'center' }}>
                        <select value={plantilla} onChange={(e) => setPlantilla(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                            <option>Memoria Anual</option>
                            <option>Informe Semestral Entidad Pública</option>
                            <option>Balance para Donantes</option>
                        </select>
                        <input type="date" value={fechaInicio} onChange={(e) => setFechaInicio(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                        <input type="date" value={fechaFin} onChange={(e) => setFechaFin(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                        <button type="button" onClick={emitirOficialPDF} style={{ marginLeft: 'auto', padding: '10px 18px', borderRadius: '8px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>
                            Generar Documento Oficial PDF
                        </button>
                    </div>

                    {data && (
                        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '14px', marginBottom: '20px' }}>
                            <div className="dashboard-panel" style={{ padding: '16px', textAlign: 'center' }}><strong>Bs. {data.ingresos.total.toFixed(2)}</strong><div style={{ fontSize: '12px' }}>Total Ingresos</div></div>
                            <div className="dashboard-panel" style={{ padding: '16px', textAlign: 'center' }}><strong>Bs. {data.egresos.total.toFixed(2)}</strong><div style={{ fontSize: '12px' }}>Total Egresos</div></div>
                            <div className="dashboard-panel" style={{ padding: '16px', textAlign: 'center' }}><strong>Bs. {data.balance.saldo_neto.toFixed(2)}</strong><div style={{ fontSize: '12px' }}>Saldo Neto</div></div>
                            <div className="dashboard-panel" style={{ padding: '16px', textAlign: 'center' }}><code style={{ fontSize: '11px' }}>{data.hash_integridad.slice(0, 18)}…</code><div style={{ fontSize: '12px' }}>Hash SHA-256</div></div>
                        </div>
                    )}
                </div>
            </main>
        </div>
    );
}

