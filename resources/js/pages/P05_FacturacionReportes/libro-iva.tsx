import { Head } from '@inertiajs/react';
import React, { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';

interface VentaRow {
    correlativo: number;
    fecha: string;
    numero_factura: number;
    estado_iva: string;
    nit_ci_cliente: string;
    razon_social: string;
    importe_total: number;
    debito_fiscal: number;
    codigo_control: string;
}

interface CompraRow {
    id: number;
    correlativo: number;
    fecha: string;
    nit_proveedor: string;
    razon_social_proveedor: string;
    numero_factura: string;
    importe_total: number;
    credito_fiscal: number;
}

export default function LibroIvaPage() {
    const [anio, setAnio] = useState(String(new Date().getFullYear()));
    const [mes, setMes] = useState(String(new Date().getMonth() + 1));
    const [ventas, setVentas] = useState<VentaRow[]>([]);
    const [compras, setCompras] = useState<CompraRow[]>([]);
    const [proveedores, setProveedores] = useState<Array<{ id: number; nombre: string; nit?: string }>>([]);
    const [resumen, setResumen] = useState({ total_ventas: 0, total_debito_fiscal: 0, total_compras: 0, total_credito_fiscal: 0, saldo_iva: 0 });
    const [tab, setTab] = useState<'ventas' | 'compras'>('ventas');

    const [proveedorId, setProveedorId] = useState('');
    const [fechaFactura, setFechaFactura] = useState(new Date().toISOString().slice(0, 10));
    const [nitProv, setNitProv] = useState('');
    const [razonProv, setRazonProv] = useState('');
    const [nroFactura, setNroFactura] = useState('');
    const [nroAutorizacion, setNroAutorizacion] = useState('');
    const [importeTotal, setImporteTotal] = useState('');

    const cargar = async () => {
        const token = localStorage.getItem('token');
        const res = await fetch(`/api/libro-iva?anio=${anio}&mes=${mes}`, {
            headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        });
        if (res.ok) {
            const data = await res.json();
            setVentas(data.ventas || []);
            setCompras(data.compras || []);
            setProveedores(data.proveedores || []);
            if (data.resumen) setResumen(data.resumen);
        }
    };

    useEffect(() => {
        cargar();
    }, [anio, mes]);

    const registrarCompra = async (e: React.FormEvent) => {
        e.preventDefault();
        const token = localStorage.getItem('token');
        const res = await fetch('/api/libro-iva/compras', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                ...(token ? { Authorization: `Bearer ${token}` } : {}),
            },
            body: JSON.stringify({
                proveedor_id: Number(proveedorId),
                fecha_factura: fechaFactura,
                nit_proveedor: nitProv,
                razon_social_proveedor: razonProv,
                numero_factura: nroFactura,
                numero_autorizacion: nroAutorizacion,
                importe_total: Number(importeTotal),
            }),
        });
        if (res.ok) {
            setNroFactura('');
            setImporteTotal('');
            await cargar();
        }
    };

    const descargarCsv = async (tipo: 'ventas' | 'compras') => {
        const token = localStorage.getItem('token');
        const res = await fetch(`/api/libro-iva/exportar-csv?anio=${anio}&mes=${mes}&tipo=${tipo}`, {
            headers: { ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        });
        if (!res.ok) return;
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `libro-${tipo}-iva-${anio}-${mes}.csv`;
        a.click();
        URL.revokeObjectURL(url);
    };

    return (
        <div className="dashboard-app">
            <Head title="Libro Compras y Ventas IVA - Los Angelitos" />
            <main className="dashboard-main">
                <DashboardTopNav title="Libro de Compras y Ventas IVA" />
                <div className="dashboard-content">
                    <div className="dashboard-panel" style={{ padding: '16px', marginBottom: '20px', display: 'flex', gap: '12px', flexWrap: 'wrap', alignItems: 'center' }}>
                        <input type="number" value={anio} onChange={(e) => setAnio(e.target.value)} style={{ width: '90px', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                        <select value={mes} onChange={(e) => setMes(e.target.value)} style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                            {Array.from({ length: 12 }, (_, i) => <option key={i + 1} value={i + 1}>Mes {i + 1}</option>)}
                        </select>
                        <button type="button" onClick={() => setTab('ventas')} style={{ padding: '8px 14px', borderRadius: '6px', border: 'none', backgroundColor: tab === 'ventas' ? 'var(--dashboard-forest)' : '#e2e8f0', color: tab === 'ventas' ? '#fff' : '#1e293b', fontWeight: 700, cursor: 'pointer' }}>Libro Ventas ({ventas.length})</button>
                        <button type="button" onClick={() => setTab('compras')} style={{ padding: '8px 14px', borderRadius: '6px', border: 'none', backgroundColor: tab === 'compras' ? 'var(--dashboard-forest)' : '#e2e8f0', color: tab === 'compras' ? '#fff' : '#1e293b', fontWeight: 700, cursor: 'pointer' }}>Libro Compras ({compras.length})</button>
                        <button type="button" onClick={() => descargarCsv(tab)} style={{ marginLeft: 'auto', padding: '8px 14px', borderRadius: '6px', border: '1px solid #243d34', backgroundColor: '#fff', color: '#243d34', fontWeight: 700, cursor: 'pointer' }}>⬇ Exportar CSV ({tab})</button>
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '12px', marginBottom: '20px' }}>
                        <div className="dashboard-panel" style={{ padding: '14px', textAlign: 'center' }}><strong>Bs. {resumen.total_debito_fiscal.toFixed(2)}</strong><div style={{ fontSize: '11px' }}>Débito Fiscal (13%)</div></div>
                        <div className="dashboard-panel" style={{ padding: '14px', textAlign: 'center' }}><strong>Bs. {resumen.total_credito_fiscal.toFixed(2)}</strong><div style={{ fontSize: '11px' }}>Crédito Fiscal (13%)</div></div>
                        <div className="dashboard-panel" style={{ padding: '14px', textAlign: 'center' }}><strong>Bs. {resumen.saldo_iva.toFixed(2)}</strong><div style={{ fontSize: '11px' }}>Saldo IVA</div></div>
                    </div>

                    {tab === 'compras' && (
                        <div className="dashboard-panel" style={{ padding: '20px', marginBottom: '20px' }}>
                            <h3 style={{ marginTop: 0 }}>Registrar Factura de Compra</h3>
                            <form onSubmit={registrarCompra} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '10px' }}>
                                <select value={proveedorId} onChange={(e) => {
                                    setProveedorId(e.target.value);
                                    const p = proveedores.find((x) => String(x.id) === e.target.value);
                                    if (p) { setRazonProv(p.nombre); setNitProv(p.nit || ''); }
                                }} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                                    <option value="">Proveedor...</option>
                                    {proveedores.map((p) => <option key={p.id} value={p.id}>{p.nombre}</option>)}
                                </select>
                                <input type="date" value={fechaFactura} onChange={(e) => setFechaFactura(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <input placeholder="NIT Proveedor" value={nitProv} onChange={(e) => setNitProv(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <input placeholder="Razón Social" value={razonProv} onChange={(e) => setRazonProv(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <input placeholder="N° Factura" value={nroFactura} onChange={(e) => setNroFactura(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <input placeholder="N° Autorización" value={nroAutorizacion} onChange={(e) => setNroAutorizacion(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <input type="number" step="0.01" placeholder="Importe Total (Bs.)" value={importeTotal} onChange={(e) => setImporteTotal(e.target.value)} required style={{ padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1' }} />
                                <button type="submit" style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', backgroundColor: 'var(--dashboard-forest)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>Guardar Compra</button>
                            </form>
                        </div>
                    )}

                    <div className="dashboard-panel" style={{ padding: '20px', overflowX: 'auto' }}>
                        {tab === 'ventas' ? (
                            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '12.5px' }}>
                                <thead>
                                    <tr style={{ backgroundColor: '#243d34', color: '#fff' }}>
                                        <th style={{ padding: '9px' }}>N°</th><th>Fecha</th><th>N° Factura</th><th>Estado</th><th>NIT/CI</th><th>Razón Social</th><th>Total (Bs.)</th><th>Débito 13%</th><th>Código Control</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {ventas.map((v) => (
                                        <tr key={v.correlativo} style={{ borderBottom: '1px solid #e2e8f0' }}>
                                            <td style={{ padding: '9px' }}>{v.correlativo}</td><td>{v.fecha}</td><td>{v.numero_factura}</td><td><strong>{v.estado_iva}</strong></td><td>{v.nit_ci_cliente}</td><td>{v.razon_social}</td><td>{v.importe_total.toFixed(2)}</td><td>{v.debito_fiscal.toFixed(2)}</td><td style={{ fontFamily: 'monospace' }}>{v.codigo_control}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        ) : (
                            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '12.5px' }}>
                                <thead>
                                    <tr style={{ backgroundColor: '#243d34', color: '#fff' }}>
                                        <th style={{ padding: '9px' }}>N°</th><th>Fecha</th><th>NIT Proveedor</th><th>Razón Social</th><th>N° Factura</th><th>Total (Bs.)</th><th>Crédito 13%</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {compras.map((c) => (
                                        <tr key={c.id} style={{ borderBottom: '1px solid #e2e8f0' }}>
                                            <td style={{ padding: '9px' }}>{c.correlativo}</td><td>{c.fecha}</td><td>{c.nit_proveedor}</td><td>{c.razon_social_proveedor}</td><td>{c.numero_factura}</td><td>{c.importe_total.toFixed(2)}</td><td>{c.credito_fiscal.toFixed(2)}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        )}
                    </div>
                </div>
            </main>
        </div>
    );
}

