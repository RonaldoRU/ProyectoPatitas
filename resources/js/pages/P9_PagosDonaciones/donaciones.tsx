import { Head, Link } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import authService from '@/services/authService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

interface Donacion {
    id: number;
    tipo_aporte: string;
    fecha: string;
    numero_documento: string;
    donante?: { id: number; nombre: string; telefono: string; tipo_persona: string };
    aportes_dinero?: Array<{ monto: string; observaciones: string }>;
    detalles_insumos?: Array<{ cantidad: string; articulo?: { nombre: string; unidad_medida: string } }>;
}

interface Articulo {
    id: number;
    nombre: string;
    unidad_medida: string;
}

export default function Donaciones() {
    const [donaciones, setDonaciones] = useState<Donacion[]>([]);
    const [articulos, setArticulos] = useState<Articulo[]>([]);
    const [cargando, setCargando] = useState(true);

    const [modalCrear, setModalCrear] = useState(false);
    const [guardando, setGuardando] = useState(false);
    const [reciboModal, setReciboModal] = useState<Donacion | null>(null);

    const [tipoAporte, setTipoAporte] = useState<'Insumos' | 'Dinero'>('Insumos');
    const [donanteNombre, setDonanteNombre] = useState('');
    const [donanteTelefono, setDonanteTelefono] = useState('');
    const [donanteTipo, setDonanteTipo] = useState('Particular');
    const [fecha, setFecha] = useState(new Date().toISOString().split('T')[0]);

    // Dinero
    const [monto, setMonto] = useState('');
    const [concepto, setConcepto] = useState('Aporte en efectivo / sede');

    // Insumos
    const [lineasInsumo, setLineasInsumo] = useState<Array<{ id_articulo: number; cantidad: number }>>([
        { id_articulo: 0, cantidad: 1 },
    ]);

    const token = authService.getToken();

    const cargarDatos = async () => {
        setCargando(true);
        try {
            const [resDon, resArt] = await Promise.all([
                fetch('/api/donaciones', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
                fetch('/api/articulos-inventario', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
            ]);

            if (resDon.ok) {
                const data = await resDon.json();
                setDonaciones(data.donaciones || []);
            }
            if (resArt.ok) {
                const data = await resArt.json();
                setArticulos(data.articulos || []);
            }
        } catch (error) {
            console.error('Error cargando donaciones:', error);
        } finally {
            setCargando(false);
        }
    };

    useEffect(() => {
        cargarDatos();
    }, []);

    const handleRegistrarDonacion = async (e: React.FormEvent) => {
        e.preventDefault();
        setGuardando(true);
        try {
            const payload: any = {
                tipo_aporte: tipoAporte,
                fecha: fecha,
                donante: {
                    nombre: donanteNombre,
                    telefono: donanteTelefono,
                    tipo_persona: donanteTipo,
                },
            };

            if (tipoAporte === 'Dinero') {
                payload.monto = parseFloat(monto);
                payload.observaciones = concepto;
            } else {
                payload.lineas = lineasInsumo.filter((l) => l.id_articulo > 0 && l.cantidad > 0);
            }

            const res = await fetch('/api/donaciones', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify(payload),
            });

            if (res.ok) {
                const data = await res.json();
                setModalCrear(false);
                setDonanteNombre('');
                setDonanteTelefono('');
                setMonto('');
                cargarDatos();
                setReciboModal(data.donacion);
            } else {
                const err = await res.json();
                alert(err.message || 'Error registrando donación.');
            }
        } catch (error) {
            console.error('Error:', error);
        } finally {
            setGuardando(false);
        }
    };

    return (
        <div className="dashboard-app">
            <Head title="Recepción de Donaciones Físicas y Efectivo (CU23) - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Donaciones (P9)" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">P9: RECEPCIÓN DE DONACIONES</p>
                                <h2>Recepción de Donaciones Físicas y Monetarias</h2>
                                <p>CU23: Insumos materiales (alimento, medicinas) con actualización inmediata de stock o aportes en efectivo.</p>
                            </div>
                            <button
                                type="button"
                                onClick={() => setModalCrear(true)}
                                className="btn-crear"
                            >
                                <span style={{ fontSize: '16px' }}>+</span> Registrar Donación (CU23)
                            </button>
                        </div>
                    </section>

                <div className="table-card">
                    <div className="table-responsive">
                        <table className="data-table">
                            <thead>
                                <tr>
                                    <th>Recibo / Doc #</th>
                                    <th>Fecha</th>
                                    <th>Donante</th>
                                    <th>Tipo Aporte</th>
                                    <th>Detalle Donado</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                {cargando ? (
                                    <tr><td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando donaciones registradas...</td></tr>
                                ) : donaciones.length === 0 ? (
                                    <tr><td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay donaciones registradas todavía.</td></tr>
                                ) : (
                                    donaciones.map((d) => (
                                        <tr key={d.id}>
                                            <td><strong style={{ color: 'var(--dashboard-forest)', letterSpacing: '0.04em' }}>{d.numero_documento}</strong></td>
                                            <td>{d.fecha}</td>
                                            <td>
                                                <strong style={{ color: 'var(--dashboard-ink)' }}>{d.donante?.nombre || 'Donante Anónimo'}</strong>
                                                <span style={{ display: 'block', fontSize: '11px', color: 'var(--dashboard-muted)' }}>
                                                    {d.donante?.telefono || 'Sin teléfono'} ({d.donante?.tipo_persona})
                                                </span>
                                            </td>
                                            <td>
                                                <span className={`badge-tag ${d.tipo_aporte === 'Dinero' ? 'badge-tag--success' : 'badge-tag--warning'}`}>
                                                    {d.tipo_aporte}
                                                </span>
                                            </td>
                                            <td>
                                                {d.tipo_aporte === 'Dinero' ? (
                                                    <span style={{ fontWeight: 700, color: 'var(--dashboard-forest)' }}>
                                                        Bs. {d.aportes_dinero?.[0]?.monto || '0.00'}
                                                    </span>
                                                ) : (
                                                    <span>
                                                        {(d.detalles_insumos || []).map((di, i) => (
                                                            <span key={i} style={{ display: 'inline-block', marginRight: '6px', backgroundColor: '#f1f5f9', padding: '2px 6px', borderRadius: '4px', fontSize: '11.5px' }}>
                                                                {di.articulo?.nombre} ({di.cantidad} {di.articulo?.unidad_medida})
                                                            </span>
                                                        ))}
                                                    </span>
                                                )}
                                            </td>
                                            <td>
                                                <button
                                                    onClick={() => setReciboModal(d)}
                                                    className="btn-action-view"
                                                >
                                                    🧾 Recibo Oficial
                                                </button>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Modal Crear Donación */}
                {modalCrear && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '560px', maxWidth: '95vw', maxHeight: '90vh', overflowY: 'auto' }}>
                            <h2 style={{ marginBottom: '14px' }}>Registrar Nueva Donación (CU23)</h2>
                            <form onSubmit={handleRegistrarDonacion}>
                                <div style={{ display: 'flex', gap: '12px', marginBottom: '14px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setTipoAporte('Insumos')}
                                        style={{
                                            flex: 1,
                                            padding: '8px',
                                            borderRadius: '6px',
                                            border: '1px solid #ea580c',
                                            background: tipoAporte === 'Insumos' ? '#ea580c' : 'white',
                                            color: tipoAporte === 'Insumos' ? 'white' : '#ea580c',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Insumos Materiales
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setTipoAporte('Dinero')}
                                        style={{
                                            flex: 1,
                                            padding: '8px',
                                            borderRadius: '6px',
                                            border: '1px solid #16a34a',
                                            background: tipoAporte === 'Dinero' ? '#16a34a' : 'white',
                                            color: tipoAporte === 'Dinero' ? 'white' : '#16a34a',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Dinero en Efectivo
                                    </button>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Nombre del Donante</label>
                                        <input
                                            type="text"
                                            required
                                            placeholder="Nombre completo o institución"
                                            value={donanteNombre}
                                            onChange={(e) => setDonanteNombre(e.target.value)}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Teléfono de Contacto</label>
                                        <input
                                            type="text"
                                            placeholder="Teléfono o WhatsApp"
                                            value={donanteTelefono}
                                            onChange={(e) => setDonanteTelefono(e.target.value)}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>
                                </div>

                                {tipoAporte === 'Dinero' ? (
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '14px' }}>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Monto Aportado (Bs.)</label>
                                            <input
                                                type="number"
                                                step="0.01"
                                                min="1"
                                                required
                                                placeholder="Ej. 100.00"
                                                value={monto}
                                                onChange={(e) => setMonto(e.target.value)}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Concepto</label>
                                            <input
                                                type="text"
                                                value={concepto}
                                                onChange={(e) => setConcepto(e.target.value)}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            />
                                        </div>
                                    </div>
                                ) : (
                                    <div style={{ marginBottom: '14px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '6px' }}>Insumos Donados (Suma al stock)</label>
                                        {lineasInsumo.map((linea, idx) => (
                                            <div key={idx} style={{ display: 'flex', gap: '8px', marginBottom: '8px' }}>
                                                <select
                                                    required
                                                    value={linea.id_articulo}
                                                    onChange={(e) => {
                                                        const nuevas = [...lineasInsumo];
                                                        nuevas[idx].id_articulo = parseInt(e.target.value);
                                                        setLineasInsumo(nuevas);
                                                    }}
                                                    style={{ flex: 1, padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                                >
                                                    <option value="">Selecciona artículo de inventario...</option>
                                                    {articulos.map((a) => (
                                                        <option key={a.id} value={a.id}>{a.nombre} ({a.unidad_medida})</option>
                                                    ))}
                                                </select>
                                                <input
                                                    type="number"
                                                    min="1"
                                                    required
                                                    placeholder="Cant."
                                                    value={linea.cantidad}
                                                    onChange={(e) => {
                                                        const nuevas = [...lineasInsumo];
                                                        nuevas[idx].cantidad = parseFloat(e.target.value) || 0;
                                                        setLineasInsumo(nuevas);
                                                    }}
                                                    style={{ width: '90px', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                                />
                                            </div>
                                        ))}
                                        <button
                                            type="button"
                                            onClick={() => setLineasInsumo([...lineasInsumo, { id_articulo: 0, cantidad: 1 }])}
                                            style={{ fontSize: '12px', padding: '4px 10px', borderRadius: '4px', border: '1px dashed #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                        >
                                            + Agregar otro artículo
                                        </button>
                                    </div>
                                )}

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '16px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setModalCrear(false)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        type="submit"
                                        disabled={guardando}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#ea580c', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        {guardando ? 'Guardando...' : 'Guardar y Emitir Recibo'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}

                {/* Modal Recibo Institucional */}
                {reciboModal && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '520px', maxWidth: '95vw', border: '2px solid #ea580c' }}>
                            <div style={{ textAlign: 'center', borderBottom: '2px dashed #d1d5db', paddingBottom: '12px', marginBottom: '14px' }}>
                                <h2 style={{ color: '#ea580c', margin: 0 }}>RECIBO OFICIAL DE DONACIÓN</h2>
                                <span>Los Angelitos de Edgar</span>
                                <p style={{ fontSize: '12px', color: '#6b7280', margin: '4px 0 0 0' }}>Doc Ref: {reciboModal.numero_documento} | Fecha: {reciboModal.fecha}</p>
                            </div>

                            <p style={{ margin: '6px 0', fontSize: '14px' }}>
                                <strong>Donante:</strong> {reciboModal.donante?.nombre} ({reciboModal.donante?.tipo_persona})
                            </p>
                            <p style={{ margin: '6px 0', fontSize: '14px' }}>
                                <strong>Tipo de Donación:</strong> {reciboModal.tipo_aporte}
                            </p>

                            <div style={{ padding: '12px', backgroundColor: '#fef3c7', borderRadius: '8px', margin: '14px 0', fontSize: '13px', color: '#92400e' }}>
                                ¡Gracias por apoyar el rescate, cuidado y alimentación de nuestros angelitos de cuatro patas!
                            </div>

                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                <button
                                    onClick={() => window.print()}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #ea580c', color: '#ea580c', background: 'transparent', cursor: 'pointer' }}
                                >
                                    Imprimir Recibo
                                </button>
                                <button
                                    onClick={() => setReciboModal(null)}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#374151', color: 'white', cursor: 'pointer' }}
                                >
                                    Cerrar
                                </button>
                            </div>
                        </div>
                    </div>
                )}
                    </div>
            </main>
        </div>
    );
}
