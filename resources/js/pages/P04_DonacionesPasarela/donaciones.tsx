/**
 * Vista de Recepción de Donaciones Físicas y Monetarias:
 * - Para Insumos Materiales: permite seleccionar artículos existentes, agregar múltiples filas y registrar un NUEVO ARTÍCULO directamente en el catálogo.
 * - Para Dinero en Efectivo / Monetario: registra la donación como PENDIENTE DE PAGO (nunca como pagada sin haber cancelado) y permite:
 *   1) Guardar como Pendiente y redirigir directamente a la Pasarela Digital (Tarjeta / QR) con todos los datos autocompletados.
 *   2) Dejar registrada como Pendiente de Pago en la tabla para pagarla posteriormente.
 * - Una vez cancelado y confirmado el pago en la pasarela, su estado pasa a PAGADO y habilita el Recibo Oficial.
 */
import { Head, router } from '@inertiajs/react';
import React, { useEffect, useState } from 'react';
import DashboardTopNav from '@/components/DashboardTopNav';
import authService from '@/services/authService';
import '../../../css/dashboard.css';

interface AporteDineroItem {
    id: number;
    monto: string;
    comprobante?: string;
    observaciones: string;
}

interface Donacion {
    id: number;
    tipo_aporte: string;
    fecha: string;
    numero_documento: string;
    donante?: { id: number; nombre: string; telefono: string; tipo_persona: string };
    aportes_dinero?: AporteDineroItem[];
    detalles_insumos?: Array<{ cantidad: string; articulo?: { nombre: string; unidad_medida: string } }>;
}

interface Articulo {
    id: number;
    nombre: string;
    categoria?: string;
    unidad_medida: string;
}

function esDonacionPendiente(donacion: Donacion): boolean {
    if (donacion.tipo_aporte !== 'Dinero') {
        return false;
    }
    const obs = donacion.aportes_dinero?.[0]?.observaciones || '';
    return obs.toLowerCase().includes('estado: pendiente');
}

function extraerConceptoLimpio(obs: string | undefined): string {
    if (!obs) {
        return 'Donación de apoyo al refugio';
    }
    const match = obs.match(/Concepto:\s*([^|]+)/i);
    if (match?.[1]) {
        return match[1].trim();
    }
    return obs.split('|')[0].trim();
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
    const [concepto, setConcepto] = useState('Donación de apoyo a alimentación y clínica');

    // Insumos
    const [lineasInsumo, setLineasInsumo] = useState<Array<{ id_articulo: number; cantidad: number }>>([
        { id_articulo: 0, cantidad: 1 },
    ]);

    // Apartado para registrar un NUEVO ARTÍCULO directamente desde el modal de donación
    const [mostrarFormNuevoArticulo, setMostrarFormNuevoArticulo] = useState(false);
    const [nuevoArtNombre, setNuevoArtNombre] = useState('');
    const [nuevoArtCategoria, setNuevoArtCategoria] = useState('Alimento');
    const [nuevoArtUnidad, setNuevoArtUnidad] = useState('Bolsa');
    const [nuevoArtStockMin, setNuevoArtStockMin] = useState('5');
    const [creandoArticulo, setCreandoArticulo] = useState(false);

    const token = authService.getToken();

    // Función para generar e imprimir el Recibo Oficial de Donación en PDF
    const imprimirReciboOficialPDF = (donacion: Donacion) => {
        const printWin = window.open('', '_blank');
        if (!printWin) {
            return;
        }

        const esDinero = donacion.aportes_dinero && donacion.aportes_dinero.length > 0;
        const montoVal = esDinero ? parseFloat(donacion.aportes_dinero![0].monto).toFixed(2) : '0.00';
        const conceptoTexto = esDinero ? extraerConceptoLimpio(donacion.aportes_dinero![0].observaciones) : '';

        const filasInsumos = (donacion.detalles_insumos || []).map((di, idx) => `
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; font-size: 13px;">${idx + 1}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; font-size: 13px; font-weight: 600;">${di.articulo?.nombre || 'Insumo / Alimento'}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; font-size: 13px; text-align: center;">${di.cantidad}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; font-size: 13px; text-align: center;">${di.articulo?.unidad_medida || 'Unidades'}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e2e8f0; font-size: 13px;">Albergue general / Farmacia veterinaria</td>
            </tr>
        `).join('');

        printWin.document.write(`
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>Recibo Oficial de Donación - ${donacion.numero_documento || donacion.id}</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 35px; color: #1e293b; background: #ffffff; }
                    .recibo-card { border: 2px solid #0d6e4f; border-radius: 12px; padding: 28px; }
                    .header { border-bottom: 2px solid #0d6e4f; padding-bottom: 15px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: flex-end; }
                    .title { color: #0d6e4f; margin: 0; font-size: 22px; font-weight: 800; letter-spacing: -0.01em; }
                    .subtitle { color: #475569; font-size: 12px; margin: 4px 0 0 0; text-transform: uppercase; font-weight: 600; }
                    .num-doc { text-align: right; font-size: 13px; color: #334155; }
                    .num-badge { display: inline-block; background-color: #ecfdf5; padding: 6px 12px; border-radius: 6px; font-weight: 800; color: #065f46; font-size: 15px; margin-top: 4px; border: 1px solid #6ee7b7; }
                    .grid-info { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; margin-bottom: 22px; }
                    .info-item { font-size: 13.5px; }
                    .info-item strong { display: block; font-size: 11px; text-transform: uppercase; color: #64748b; margin-bottom: 2px; }
                    table { width: 100%; border-collapse: collapse; margin: 18px 0; }
                    th { background-color: #0d6e4f; color: #ffffff; padding: 10px; font-size: 12px; text-transform: uppercase; text-align: left; }
                    .total-box { display: flex; justify-content: space-between; align-items: center; background: #ecfdf5; border: 1px solid #6ee7b7; padding: 14px 18px; border-radius: 8px; margin: 18px 0; }
                    .certificacion { font-size: 11.5px; color: #64748b; font-style: italic; line-height: 1.45; border-top: 1px solid #e2e8f0; padding-top: 14px; margin-top: 24px; }
                    .firmas-container { display: flex; justify-content: space-between; margin-top: 60px; padding-top: 10px; }
                    .firma-box { width: 42%; text-align: center; border-top: 1.5px dashed #475569; padding-top: 8px; font-size: 12.5px; color: #334155; }
                    .firma-box span { display: block; font-size: 11px; color: #64748b; margin-top: 3px; }
                    @media print { .no-print { display: none; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="margin-bottom: 22px; display: flex; gap: 12px;">
                    <button onclick="window.print()" style="padding: 10px 22px; background-color: #0d6e4f; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 14px;">Imprimir / Guardar en PDF</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background-color: #e2e8f0; border: none; border-radius: 6px; cursor: pointer; font-size: 14px;">Cerrar</button>
                </div>
                <div class="recibo-card">
                    <div class="header">
                        <div>
                            <h1 class="title">REFUGIO LOS ANGELITOS DE EDGAR</h1>
                            <p class="subtitle">Comprobante Oficial de Donación y Aporte Solidario • Santa Cruz, Bolivia</p>
                        </div>
                        <div class="num-doc">
                            <span>COMPROBANTE N°</span><br>
                            <span class="num-badge">${donacion.numero_documento || 'REC-' + String(donacion.id).padStart(6, '0')}</span>
                        </div>
                    </div>

                    <div class="grid-info">
                        <div class="info-item">
                            <strong>Donante / Benefactor</strong>
                            ${donacion.donante?.nombre || 'Donante Solidario'}
                        </div>
                        <div class="info-item">
                            <strong>Tipo de Persona / Entidad</strong>
                            ${donacion.donante?.tipo_persona || 'Persona Particular'}
                        </div>
                        <div class="info-item">
                            <strong>Teléfono de Contacto</strong>
                            ${donacion.donante?.telefono || 'No especificado'}
                        </div>
                        <div class="info-item">
                            <strong>Fecha de Recepción Oficial</strong>
                            ${donacion.fecha}
                        </div>
                        <div class="info-item">
                            <strong>Tipo de Aporte</strong>
                            ${donacion.tipo_aporte === 'Dinero' ? 'Aporte Monetario (Bolivianos)' : 'Donación Física / En Especie (Insumos)'}
                        </div>
                        <div class="info-item">
                            <strong>Estado del Aporte</strong>
                            <span style="color: #065f46; font-weight: 800;">PAGADO Y CONFIRMADO</span>
                        </div>
                    </div>

                    ${esDinero ? `
                        <div class="total-box">
                            <div>
                                <span style="font-size: 12px; color: #065f46; font-weight: 700; text-transform: uppercase;">Monto Cancelado y Acreditado</span>
                                <div style="font-size: 13px; color: #334155; margin-top: 2px;">${conceptoTexto}</div>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-size: 26px; font-weight: 800; color: #065f46;">Bs. ${montoVal}</span>
                                <div style="font-size: 11px; color: #64748b;">Moneda Oficial: Bolivianos (BOB)</div>
                            </div>
                        </div>
                    ` : `
                        <h3 style="color: #0d6e4f; font-size: 15px; margin: 16px 0 8px;">Detalle de Insumos y Artículos Entregados</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 8%;">#</th>
                                    <th style="width: 42%;">Artículo / Descripción</th>
                                    <th style="width: 15%; text-align: center;">Cantidad</th>
                                    <th style="width: 15%; text-align: center;">Unidad</th>
                                    <th style="width: 20%;">Destino en Refugio</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${filasInsumos || '<tr><td colspan="5" style="text-align:center; padding:16px;">Sin insumos detallados.</td></tr>'}
                            </tbody>
                        </table>
                    `}

                    <div class="certificacion">
                        El Refugio Los Angelitos de Edgar deja constancia formal de haber recibido la donación descrita anteriormente, la cual será destinada de manera exclusiva y transparente a la alimentación, atención veterinaria, rescate y protección integral de los animales bajo tutela del albergue.
                    </div>

                    <div class="firmas-container">
                        <div class="firma-box">
                            <strong>Firma del Donante</strong>
                            <span>Aclaración de Firma / C.I. o Razón Social</span>
                        </div>
                        <div class="firma-box">
                            <strong>Firma del Responsable Autorizado</strong>
                            <span>Personal Autorizado • Refugio Los Angelitos</span>
                        </div>
                    </div>
                </div>
            </body>
            </html>
        `);
        printWin.document.close();
    };

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
        void cargarDatos();
    }, []);

    // Registrar un nuevo artículo de inventario directamente desde el modal de donación
    const handleCrearNuevoArticulo = async () => {
        if (!nuevoArtNombre.trim()) {
            alert('Por favor ingresa el nombre del nuevo artículo.');
            return;
        }
        setCreandoArticulo(true);
        try {
            const res = await fetch('/api/articulos-inventario', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify({
                    nombre: nuevoArtNombre.trim(),
                    categoria: nuevoArtCategoria,
                    unidad_medida: nuevoArtUnidad,
                    stock_actual: 0,
                    stock_minimo_alerta: parseInt(nuevoArtStockMin, 10) || 5,
                }),
            });

            if (res.ok) {
                const data = await res.json();
                const creado: Articulo = data.articulo || data;
                setArticulos((prev) => [creado, ...prev]);

                // Asignarlo automáticamente a la última fila sin artículo o agregar una nueva fila con este artículo
                setLineasInsumo((prev) => {
                    const idxVacio = prev.findIndex((l) => !l.id_articulo || l.id_articulo === 0);
                    if (idxVacio !== -1) {
                        const copia = [...prev];
                        copia[idxVacio] = { ...copia[idxVacio], id_articulo: creado.id };
                        return copia;
                    }
                    return [...prev, { id_articulo: creado.id, cantidad: 1 }];
                });

                setNuevoArtNombre('');
                setMostrarFormNuevoArticulo(false);
            } else {
                const err = await res.json();
                alert(err.message || 'No se pudo registrar el nuevo artículo.');
            }
        } catch (error) {
            console.error('Error creando artículo:', error);
        } finally {
            setCreandoArticulo(false);
        }
    };

    // Redirigir a Pasarela de Pagos autocompletando todos los datos de una donación pendiente
    const irAPasarelaConDatos = (datos: {
        aporte_id?: number;
        donacion_id?: number;
        numero_documento?: string;
        nombre: string;
        telefono: string;
        monto: string | number;
        concepto: string;
    }) => {
        sessionStorage.setItem('pending_donation_checkout', JSON.stringify(datos));
        const params = new URLSearchParams({
            ...(datos.aporte_id ? { aporte_id: String(datos.aporte_id) } : {}),
            ...(datos.numero_documento ? { doc: datos.numero_documento } : {}),
            nombre: datos.nombre,
            telefono: datos.telefono || '',
            monto: String(datos.monto),
            concepto: datos.concepto || 'Donación de apoyo al refugio',
        });
        router.visit(`/pasarela-pagos?${params.toString()}`);
    };

    // Guardar donación (con soporte para dejar como Pendiente de Pago y redirigir a Pasarela QR/Tarjeta)
    const guardarDonacion = async (redirigirAPasarela: boolean) => {
        if (!donanteNombre.trim()) {
            alert('Por favor ingresa el nombre del donante.');
            return;
        }
        if (tipoAporte === 'Dinero' && (!monto || parseFloat(monto) <= 0)) {
            alert('Por favor ingresa un monto válido en Bolivianos (Bs.).');
            return;
        }
        if (tipoAporte === 'Insumos') {
            const validas = lineasInsumo.filter((l) => l.id_articulo > 0 && l.cantidad > 0);
            if (validas.length === 0) {
                alert('Selecciona al menos un artículo del catálogo o registra uno nuevo.');
                return;
            }
        }

        setGuardando(true);
        try {
            const payload: Record<string, unknown> = {
                tipo_aporte: tipoAporte,
                fecha: fecha,
                donante: {
                    nombre: donanteNombre.trim(),
                    telefono: donanteTelefono.trim() || '70000000',
                    tipo_persona: donanteTipo,
                },
            };

            if (tipoAporte === 'Dinero') {
                payload.monto = parseFloat(monto);
                payload.observaciones = concepto;
                // Toda donación en efectivo/monetaria desde aquí queda como PENDIENTE hasta que se cancele en pasarela
                payload.estado_pago = 'Pendiente';
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
                const donacionCreada: Donacion = data.donacion;
                const aporteCreado = donacionCreada.aportes_dinero?.[0];

                setModalCrear(false);

                if (tipoAporte === 'Dinero' && redirigirAPasarela) {
                    irAPasarelaConDatos({
                        aporte_id: aporteCreado?.id,
                        donacion_id: donacionCreada.id,
                        numero_documento: donacionCreada.numero_documento,
                        nombre: donanteNombre.trim(),
                        telefono: donanteTelefono.trim() || '70000000',
                        monto: parseFloat(monto),
                        concepto: concepto,
                    });
                    return;
                }

                setDonanteNombre('');
                setDonanteTelefono('');
                setMonto('');
                await cargarDatos();

                if (tipoAporte === 'Insumos') {
                    setReciboModal(donacionCreada);
                }
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

    const handleFormSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        // Si es Dinero, por defecto guarda como pendiente y redirige a la pasarela para cobrar por Tarjeta o QR
        void guardarDonacion(tipoAporte === 'Dinero');
    };

    return (
        <div className="dashboard-app">
            <Head title="Recepción de Donaciones Físicas y Monetarias - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Donaciones" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">RECEPCIÓN DE DONACIONES</p>
                                <h2>Recepción de Donaciones Físicas y Monetarias</h2>
                                <p>
                                    Registra insumos materiales (con opción de crear nuevos artículos en el catálogo) o intenciones de donación monetaria pendientes de pago para cobrar por Tarjeta o QR.
                                </p>
                            </div>
                            <button
                                type="button"
                                onClick={() => setModalCrear(true)}
                                className="btn-crear"
                            >
                                <span style={{ fontSize: '16px' }}>+</span> Registrar Donación
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
                                        <th>Estado de Pago</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {cargando ? (
                                        <tr><td colSpan={7} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando donaciones registradas...</td></tr>
                                    ) : donaciones.length === 0 ? (
                                        <tr><td colSpan={7} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay donaciones registradas todavía.</td></tr>
                                    ) : (
                                        donaciones.map((d) => {
                                            const pendiente = esDonacionPendiente(d);
                                            const aporte = d.aportes_dinero?.[0];

                                            return (
                                                <tr key={d.id}>
                                                    <td><strong style={{ color: 'var(--dashboard-forest)', letterSpacing: '0.04em' }}>{d.numero_documento}</strong></td>
                                                    <td>{d.fecha}</td>
                                                    <td>
                                                        <strong style={{ color: 'var(--dashboard-ink)' }}>{d.donante?.nombre || 'Donante Solidario'}</strong>
                                                        <span style={{ display: 'block', fontSize: '11px', color: 'var(--dashboard-muted)' }}>
                                                            {d.donante?.telefono || 'Sin teléfono'} ({d.donante?.tipo_persona || 'Particular'})
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span className={`badge-tag ${d.tipo_aporte === 'Dinero' ? 'badge-tag--info' : 'badge-tag--neutral'}`}>
                                                            {d.tipo_aporte === 'Dinero' ? 'Monetario (Bs.)' : 'Insumos Materiales'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        {aporte ? (
                                                            <div>
                                                                <span style={{ fontWeight: 800, color: 'var(--dashboard-ink)', fontVariantNumeric: 'tabular-nums' }}>
                                                                    Bs. {parseFloat(aporte.monto).toFixed(2)}
                                                                </span>
                                                                <span style={{ display: 'block', fontSize: '11.5px', color: 'var(--dashboard-muted)', marginTop: '2px' }}>
                                                                    {extraerConceptoLimpio(aporte.observaciones)}
                                                                </span>
                                                            </div>
                                                        ) : d.detalles_insumos && d.detalles_insumos.length > 0 ? (
                                                            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
                                                                {d.detalles_insumos.map((di, i) => (
                                                                    <span key={i} style={{ display: 'inline-block', backgroundColor: '#f1f5f9', padding: '2px 8px', borderRadius: '4px', fontSize: '11.5px', color: '#1e293b', border: '1px solid #e2e8f0' }}>
                                                                        <strong>{di.articulo?.nombre || 'Insumo'}</strong> ({di.cantidad} {di.articulo?.unidad_medida || 'unid'})
                                                                    </span>
                                                                ))}
                                                            </div>
                                                        ) : (
                                                            <span style={{ fontSize: '12px', color: 'var(--dashboard-muted)', fontStyle: 'italic' }}>
                                                                {d.tipo_aporte}
                                                            </span>
                                                        )}
                                                    </td>
                                                    <td>
                                                        {d.tipo_aporte === 'Insumos' ? (
                                                            <span className="badge-tag badge-tag--success">
                                                                INGRESADO A STOCK
                                                            </span>
                                                        ) : pendiente ? (
                                                            <span className="badge-tag badge-tag--warning">
                                                                PENDIENTE DE PAGO
                                                            </span>
                                                        ) : (
                                                            <span className="badge-tag badge-tag--success">
                                                                PAGADO / CONFIRMADO
                                                            </span>
                                                        )}
                                                    </td>
                                                    <td>
                                                        {pendiente ? (
                                                            <button
                                                                type="button"
                                                                onClick={() =>
                                                                    irAPasarelaConDatos({
                                                                        aporte_id: aporte?.id,
                                                                        donacion_id: d.id,
                                                                        numero_documento: d.numero_documento,
                                                                        nombre: d.donante?.nombre || 'Donante Solidario',
                                                                        telefono: d.donante?.telefono || '70000000',
                                                                        monto: aporte?.monto || '50',
                                                                        concepto: extraerConceptoLimpio(aporte?.observaciones),
                                                                    })
                                                                }
                                                                className="btn-action-primary"
                                                                style={{ backgroundColor: '#0284c7', color: '#ffffff', padding: '6px 12px', borderRadius: '6px' }}
                                                            >
                                                                Pagar con Tarjeta / QR →
                                                            </button>
                                                        ) : (
                                                            <button
                                                                type="button"
                                                                onClick={() => setReciboModal(d)}
                                                                className="btn-action-view"
                                                            >
                                                                Recibo Oficial
                                                            </button>
                                                        )}
                                                    </td>
                                                </tr>
                                            );
                                        })
                                    )}
                                </tbody>
                            </table>
                        </div>
                    </div>

                    {/* Modal Crear Donación */}
                    {modalCrear && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(15, 23, 42, 0.6)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000, padding: '16px' }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '14px', padding: '24px', width: '620px', maxWidth: '96vw', maxHeight: '92vh', overflowY: 'auto', boxShadow: '0 24px 48px rgba(0,0,0,0.25)' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                                    <h2 style={{ margin: 0, fontSize: '19px', color: '#0f172a' }}>Registrar Nueva Donación</h2>
                                    <button
                                        type="button"
                                        onClick={() => setModalCrear(false)}
                                        style={{ border: 'none', background: 'none', fontSize: '20px', cursor: 'pointer', color: '#64748b' }}
                                    >
                                        ✕
                                    </button>
                                </div>

                                <form onSubmit={handleFormSubmit}>
                                    {/* Selector de Tipo de Donación */}
                                    <div style={{ display: 'flex', gap: '10px', marginBottom: '16px' }}>
                                        <button
                                            type="button"
                                            onClick={() => setTipoAporte('Insumos')}
                                            style={{
                                                flex: 1,
                                                padding: '10px',
                                                borderRadius: '8px',
                                                border: '1.5px solid #0d6e4f',
                                                background: tipoAporte === 'Insumos' ? '#0d6e4f' : '#ffffff',
                                                color: tipoAporte === 'Insumos' ? '#ffffff' : '#0d6e4f',
                                                fontWeight: 700,
                                                fontSize: '13px',
                                                cursor: 'pointer',
                                            }}
                                        >
                                            Insumos Materiales (Alimento / Medicina)
                                        </button>
                                        <button
                                            type="button"
                                            onClick={() => setTipoAporte('Dinero')}
                                            style={{
                                                flex: 1,
                                                padding: '10px',
                                                borderRadius: '8px',
                                                border: '1.5px solid #0284c7',
                                                background: tipoAporte === 'Dinero' ? '#0284c7' : '#ffffff',
                                                color: tipoAporte === 'Dinero' ? '#ffffff' : '#0284c7',
                                                fontWeight: 700,
                                                fontSize: '13px',
                                                cursor: 'pointer',
                                            }}
                                        >
                                            Dinero en Efectivo / Monetario (Bs.)
                                        </button>
                                    </div>

                                    {/* Datos del Donante */}
                                    <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr 0.8fr', gap: '10px', marginBottom: '14px' }}>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, marginBottom: '4px', color: '#334155' }}>
                                                Nombre del Donante *
                                            </label>
                                            <input
                                                type="text"
                                                required
                                                placeholder="Ej. Juan Pérez o Empresa"
                                                value={donanteNombre}
                                                onChange={(e) => setDonanteNombre(e.target.value)}
                                                style={{ width: '100%', padding: '9px 10px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '13px' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, marginBottom: '4px', color: '#334155' }}>
                                                Teléfono / WhatsApp
                                            </label>
                                            <input
                                                type="text"
                                                placeholder="Ej. 70000000"
                                                value={donanteTelefono}
                                                onChange={(e) => setDonanteTelefono(e.target.value)}
                                                style={{ width: '100%', padding: '9px 10px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '13px' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, marginBottom: '4px', color: '#334155' }}>
                                                Tipo Donante
                                            </label>
                                            <select
                                                value={donanteTipo}
                                                onChange={(e) => setDonanteTipo(e.target.value)}
                                                style={{ width: '100%', padding: '9px 10px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '13px' }}
                                            >
                                                <option value="Particular">Particular</option>
                                                <option value="Empresa">Empresa</option>
                                                <option value="Institución">Institución</option>
                                            </select>
                                        </div>
                                    </div>

                                    {/* APARTADO SI Y SOLO SI ES DINERO EN EFECTIVO / MONETARIO */}
                                    {tipoAporte === 'Dinero' ? (
                                        <div>
                                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.4fr', gap: '12px', marginBottom: '14px' }}>
                                                <div>
                                                    <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, marginBottom: '4px', color: '#334155' }}>
                                                        Monto a Donar (Bs.) *
                                                    </label>
                                                    <input
                                                        type="number"
                                                        step="0.01"
                                                        min="1"
                                                        required
                                                        placeholder="Ej. 100.00"
                                                        value={monto}
                                                        onChange={(e) => setMonto(e.target.value)}
                                                        style={{ width: '100%', padding: '10px', border: '1.5px solid #0284c7', borderRadius: '6px', fontSize: '14px', fontWeight: 700 }}
                                                    />
                                                </div>
                                                <div>
                                                    <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, marginBottom: '4px', color: '#334155' }}>
                                                        Concepto o Destino del Aporte
                                                    </label>
                                                    <input
                                                        type="text"
                                                        value={concepto}
                                                        onChange={(e) => setConcepto(e.target.value)}
                                                        style={{ width: '100%', padding: '10px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '13px' }}
                                                    />
                                                </div>
                                            </div>

                                            {/* Aviso de Estado Pendiente de Pago y Opciones */}
                                            <div
                                                style={{
                                                    backgroundColor: '#f0f9ff',
                                                    border: '1px solid #bae6fd',
                                                    borderRadius: '10px',
                                                    padding: '14px',
                                                    marginBottom: '16px',
                                                }}
                                            >
                                                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '6px' }}>
                                                    <span style={{ fontSize: '11px', fontWeight: 800, padding: '2px 8px', borderRadius: '6px', backgroundColor: '#fef3c7', color: '#92400e' }}>
                                                        ESTADO INICIAL: PENDIENTE DE PAGO
                                                    </span>
                                                </div>
                                                <p style={{ margin: 0, fontSize: '12.5px', color: '#0369a1', lineHeight: 1.45 }}>
                                                    La donación monetaria <strong>no se marca como pagada directamente</strong> hasta que se confirme la cancelación. Puedes guardarla como pendiente y pasar directo a la <strong>Pasarela de Cobro (Tarjeta o Código QR)</strong> con estos datos autocompletados.
                                                </p>
                                            </div>

                                            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', marginTop: '14px' }}>
                                                <button
                                                    type="button"
                                                    disabled={guardando}
                                                    onClick={() => void guardarDonacion(true)}
                                                    style={{
                                                        width: '100%',
                                                        padding: '12px 16px',
                                                        borderRadius: '8px',
                                                        border: 'none',
                                                        backgroundColor: '#0284c7',
                                                        color: '#ffffff',
                                                        fontWeight: 800,
                                                        fontSize: '13.5px',
                                                        cursor: 'pointer',
                                                        boxShadow: '0 4px 12px rgba(2, 132, 199, 0.25)',
                                                    }}
                                                >
                                                    {guardando
                                                        ? 'Guardando y Redirigiendo...'
                                                        : '1. Guardar como Pendiente e Ir a Pagar (Tarjeta o QR) →'}
                                                </button>

                                                <div style={{ display: 'flex', gap: '10px', justifyContent: 'space-between' }}>
                                                    <button
                                                        type="button"
                                                        disabled={guardando}
                                                        onClick={() => void guardarDonacion(false)}
                                                        style={{
                                                            flex: 1,
                                                            padding: '10px 14px',
                                                            borderRadius: '8px',
                                                            border: '1px solid #0284c7',
                                                            backgroundColor: '#ffffff',
                                                            color: '#0284c7',
                                                            fontWeight: 700,
                                                            fontSize: '12.5px',
                                                            cursor: 'pointer',
                                                        }}
                                                    >
                                                        2. Dejar Guardado como Pendiente de Pago en Lista
                                                    </button>
                                                    <button
                                                        type="button"
                                                        onClick={() => setModalCrear(false)}
                                                        style={{
                                                            padding: '10px 16px',
                                                            borderRadius: '8px',
                                                            border: '1px solid #cbd5e1',
                                                            backgroundColor: '#f8fafc',
                                                            color: '#475569',
                                                            fontWeight: 600,
                                                            fontSize: '12.5px',
                                                            cursor: 'pointer',
                                                        }}
                                                    >
                                                        Cancelar
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    ) : (
                                        /* APARTADO DE INSUMOS MATERIALES CON CREACIÓN DE NUEVO ARTÍCULO */
                                        <div>
                                            <div style={{ marginBottom: '12px' }}>
                                                <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, marginBottom: '6px', color: '#334155' }}>
                                                    Artículos / Insumos Donados (Se suman automáticamente al stock)
                                                </label>
                                                {lineasInsumo.map((linea, idx) => (
                                                    <div key={idx} style={{ display: 'flex', gap: '8px', marginBottom: '8px', alignItems: 'center' }}>
                                                        <select
                                                            required
                                                            value={linea.id_articulo}
                                                            onChange={(e) => {
                                                                const val = parseInt(e.target.value, 10);
                                                                if (val === -1) {
                                                                    setMostrarFormNuevoArticulo(true);
                                                                    return;
                                                                }
                                                                const nuevas = [...lineasInsumo];
                                                                nuevas[idx].id_articulo = val;
                                                                setLineasInsumo(nuevas);
                                                            }}
                                                            style={{ flex: 1, padding: '9px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '13px' }}
                                                        >
                                                            <option value={0}>Selecciona artículo de inventario...</option>
                                                            {articulos.map((a) => (
                                                                <option key={a.id} value={a.id}>
                                                                    {a.nombre} ({a.unidad_medida})
                                                                </option>
                                                            ))}
                                                            <option value={-1} style={{ fontWeight: 700, color: '#0d6e4f' }}>
                                                                + Registrar un nuevo artículo que no está en la lista...
                                                            </option>
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
                                                            style={{ width: '88px', padding: '9px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '13px' }}
                                                        />
                                                        {lineasInsumo.length > 1 && (
                                                            <button
                                                                type="button"
                                                                onClick={() => setLineasInsumo(lineasInsumo.filter((_, i) => i !== idx))}
                                                                title="Quitar fila"
                                                                style={{ padding: '8px 10px', borderRadius: '6px', border: '1px solid #fecaca', background: '#fef2f2', color: '#dc2626', cursor: 'pointer', fontWeight: 700 }}
                                                            >
                                                                ✕
                                                            </button>
                                                        )}
                                                    </div>
                                                ))}

                                                {/* Botones para agregar otra fila o desplegar el formulario de nuevo artículo */}
                                                <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginTop: '8px' }}>
                                                    <button
                                                        type="button"
                                                        onClick={() => setLineasInsumo([...lineasInsumo, { id_articulo: 0, cantidad: 1 }])}
                                                        style={{ fontSize: '12px', padding: '6px 12px', borderRadius: '6px', border: '1px dashed #94a3b8', background: '#f8fafc', color: '#334155', fontWeight: 700, cursor: 'pointer' }}
                                                    >
                                                        + Agregar otra fila de artículo
                                                    </button>
                                                    <button
                                                        type="button"
                                                        onClick={() => setMostrarFormNuevoArticulo(!mostrarFormNuevoArticulo)}
                                                        style={{ fontSize: '12px', padding: '6px 12px', borderRadius: '6px', border: '1px solid #0d6e4f', background: '#ecfdf5', color: '#065f46', fontWeight: 800, cursor: 'pointer' }}
                                                    >
                                                        {mostrarFormNuevoArticulo ? 'Ocultar registro de nuevo artículo' : '+ Ingresar / Registrar Nuevo Artículo al Catálogo'}
                                                    </button>
                                                </div>
                                            </div>

                                            {/* APARTADO DESPLEGABLE PARA INGRESAR O REGISTRAR UN NUEVO ARTÍCULO */}
                                            {mostrarFormNuevoArticulo && (
                                                <div
                                                    style={{
                                                        backgroundColor: '#f0fdf4',
                                                        border: '1.5px solid #6ee7b7',
                                                        borderRadius: '10px',
                                                        padding: '14px',
                                                        marginBottom: '14px',
                                                    }}
                                                >
                                                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
                                                        <strong style={{ fontSize: '13px', color: '#065f46' }}>
                                                            Registrar Nuevo Artículo en el Catálogo de Inventario
                                                        </strong>
                                                        <button
                                                            type="button"
                                                            onClick={() => setMostrarFormNuevoArticulo(false)}
                                                            style={{ border: 'none', background: 'none', color: '#065f46', cursor: 'pointer', fontWeight: 700 }}
                                                        >
                                                            ✕
                                                        </button>
                                                    </div>

                                                    <div style={{ display: 'grid', gridTemplateColumns: '1.4fr 1fr 1fr', gap: '8px', marginBottom: '10px' }}>
                                                        <div>
                                                            <label style={{ display: 'block', fontSize: '11.5px', fontWeight: 700, color: '#065f46', marginBottom: '3px' }}>
                                                                Nombre del Artículo *
                                                            </label>
                                                            <input
                                                                type="text"
                                                                placeholder="Ej. Croquetas Cachorro 15kg"
                                                                value={nuevoArtNombre}
                                                                onChange={(e) => setNuevoArtNombre(e.target.value)}
                                                                style={{ width: '100%', padding: '7px 9px', borderRadius: '6px', border: '1px solid #a7f3d0', fontSize: '12.5px' }}
                                                            />
                                                        </div>
                                                        <div>
                                                            <label style={{ display: 'block', fontSize: '11.5px', fontWeight: 700, color: '#065f46', marginBottom: '3px' }}>
                                                                Categoría
                                                            </label>
                                                            <select
                                                                value={nuevoArtCategoria}
                                                                onChange={(e) => setNuevoArtCategoria(e.target.value)}
                                                                style={{ width: '100%', padding: '7px 9px', borderRadius: '6px', border: '1px solid #a7f3d0', fontSize: '12.5px' }}
                                                            >
                                                                <option value="Alimento">Alimento</option>
                                                                <option value="Medicamento">Medicamento</option>
                                                                <option value="Insumo Médico">Insumo Médico</option>
                                                                <option value="Higiene y Limpieza">Higiene y Limpieza</option>
                                                            </select>
                                                        </div>
                                                        <div>
                                                            <label style={{ display: 'block', fontSize: '11.5px', fontWeight: 700, color: '#065f46', marginBottom: '3px' }}>
                                                                Unidad de Medida
                                                            </label>
                                                            <select
                                                                value={nuevoArtUnidad}
                                                                onChange={(e) => setNuevoArtUnidad(e.target.value)}
                                                                style={{ width: '100%', padding: '7px 9px', borderRadius: '6px', border: '1px solid #a7f3d0', fontSize: '12.5px' }}
                                                            >
                                                                <option value="Bolsa">Bolsa</option>
                                                                <option value="Kg">Kg</option>
                                                                <option value="Frasco">Frasco</option>
                                                                <option value="Caja">Caja</option>
                                                                <option value="Unidad">Unidad</option>
                                                                <option value="Lata">Lata</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '10px' }}>
                                                        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                                                            <label style={{ fontSize: '11.5px', fontWeight: 700, color: '#065f46' }}>
                                                                Alerta Stock Mínimo:
                                                            </label>
                                                            <input
                                                                type="number"
                                                                min="1"
                                                                value={nuevoArtStockMin}
                                                                onChange={(e) => setNuevoArtStockMin(e.target.value)}
                                                                style={{ width: '64px', padding: '5px 8px', borderRadius: '6px', border: '1px solid #a7f3d0', fontSize: '12px' }}
                                                            />
                                                        </div>
                                                        <button
                                                            type="button"
                                                            disabled={creandoArticulo}
                                                            onClick={() => void handleCrearNuevoArticulo()}
                                                            style={{
                                                                padding: '7px 14px',
                                                                borderRadius: '6px',
                                                                border: 'none',
                                                                backgroundColor: '#0d6e4f',
                                                                color: '#ffffff',
                                                                fontWeight: 700,
                                                                fontSize: '12px',
                                                                cursor: 'pointer',
                                                            }}
                                                        >
                                                            {creandoArticulo ? 'Creando...' : 'Guardar y Seleccionar Artículo'}
                                                        </button>
                                                    </div>
                                                </div>
                                            )}

                                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '16px' }}>
                                                <button
                                                    type="button"
                                                    onClick={() => setModalCrear(false)}
                                                    style={{ padding: '9px 16px', borderRadius: '8px', border: '1px solid #cbd5e1', background: 'transparent', cursor: 'pointer', fontWeight: 600 }}
                                                >
                                                    Cancelar
                                                </button>
                                                <button
                                                    type="submit"
                                                    disabled={guardando}
                                                    style={{ padding: '9px 18px', borderRadius: '8px', border: 'none', background: '#0d6e4f', color: 'white', fontWeight: 700, cursor: 'pointer' }}
                                                >
                                                    {guardando ? 'Guardando...' : 'Registrar Ingreso de Insumos y Emitir Recibo'}
                                                </button>
                                            </div>
                                        </div>
                                    )}
                                </form>
                            </div>
                        </div>
                    )}

                    {/* Modal Recibo Institucional */}
                    {reciboModal && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '520px', maxWidth: '95vw', border: '2px solid #0d6e4f' }}>
                                <div style={{ textAlign: 'center', borderBottom: '2px dashed #d1d5db', paddingBottom: '12px', marginBottom: '14px' }}>
                                    <h2 style={{ color: '#0d6e4f', margin: 0 }}>RECIBO OFICIAL DE DONACIÓN</h2>
                                    <span>Los Angelitos de Edgar</span>
                                    <p style={{ fontSize: '12px', color: '#6b7280', margin: '4px 0 0 0' }}>Doc Ref: {reciboModal.numero_documento} | Fecha: {reciboModal.fecha}</p>
                                </div>

                                <p style={{ margin: '6px 0', fontSize: '14px' }}>
                                    <strong>Donante:</strong> {reciboModal.donante?.nombre} ({reciboModal.donante?.tipo_persona})
                                </p>
                                <p style={{ margin: '6px 0', fontSize: '14px' }}>
                                    <strong>Tipo de Donación:</strong> {reciboModal.tipo_aporte}
                                </p>

                                <div style={{ marginTop: '12px', marginBottom: '14px', padding: '14px', backgroundColor: '#f8fafc', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
                                    <span style={{ fontSize: '11px', fontWeight: 700, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em', display: 'block', marginBottom: '8px' }}>
                                        Detalle del Aporte Recibido:
                                    </span>
                                    {reciboModal.aportes_dinero && reciboModal.aportes_dinero.length > 0 ? (
                                        <div>
                                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                                                <span style={{ fontSize: '13px', color: '#334155', fontWeight: 600 }}>Monto Cancelado:</span>
                                                <strong style={{ fontSize: '22px', color: '#065f46', fontVariantNumeric: 'tabular-nums' }}>
                                                    Bs. {parseFloat(reciboModal.aportes_dinero[0].monto).toFixed(2)}
                                                </strong>
                                            </div>
                                            {reciboModal.aportes_dinero[0].observaciones && (
                                                <p style={{ margin: '8px 0 0 0', fontSize: '12px', color: '#64748b', backgroundColor: '#fff', padding: '8px', borderRadius: '6px', border: '1px dashed #cbd5e1' }}>
                                                    <strong>Concepto / Referencia:</strong> {extraerConceptoLimpio(reciboModal.aportes_dinero[0].observaciones)}
                                                </p>
                                            )}
                                        </div>
                                    ) : reciboModal.detalles_insumos && reciboModal.detalles_insumos.length > 0 ? (
                                        <div>
                                            <span style={{ fontSize: '13px', color: '#334155', fontWeight: 600, display: 'block', marginBottom: '6px' }}>Artículos / Insumos Entregados:</span>
                                            <ul style={{ margin: 0, paddingLeft: '18px', fontSize: '13px', color: '#1e293b' }}>
                                                {reciboModal.detalles_insumos.map((di, i) => (
                                                    <li key={i} style={{ marginBottom: '4px' }}>
                                                        <strong>{di.articulo?.nombre || 'Artículo'}</strong> — {di.cantidad} {di.articulo?.unidad_medida || 'unidades'}
                                                    </li>
                                                ))}
                                            </ul>
                                        </div>
                                    ) : (
                                        <span style={{ fontSize: '13px', color: '#64748b', fontStyle: 'italic' }}>
                                            Aporte registrado: {reciboModal.tipo_aporte}
                                        </span>
                                    )}
                                </div>

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                    <button
                                        type="button"
                                        onClick={() => imprimirReciboOficialPDF(reciboModal)}
                                        style={{ padding: '8px 18px', borderRadius: '6px', border: 'none', background: 'var(--dashboard-forest)', color: '#ffffff', fontWeight: 700, cursor: 'pointer' }}
                                    >
                                        Generar e Imprimir Recibo Oficial (PDF)
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setReciboModal(null)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid var(--dashboard-line)', background: '#f8fafc', color: 'var(--dashboard-ink)', cursor: 'pointer' }}
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
