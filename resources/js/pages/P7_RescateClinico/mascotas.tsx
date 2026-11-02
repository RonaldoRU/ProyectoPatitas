import { Head, Link } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import authService from '@/services/authService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

interface Mascota {
    id: number;
    nombre: string;
    especie: string;
    raza: string;
    edad: string;
    sexo: string;
    estado_actual: string;
    fecha_ingreso: string;
    zona_rescate: string;
    foto: string;
}

interface HistorialItem {
    id: number;
    fecha_atencion: string;
    diagnostico: string;
    observacion: string;
    tipo_procedimiento: string;
    usuario?: { nombre: string };
}

export default function Mascotas() {
    const [mascotas, setMascotas] = useState<Mascota[]>([]);
    const [cargando, setCargando] = useState(true);
    const [filtroEstado, setFiltroEstado] = useState('');
    const [filtroEspecie, setFiltroEspecie] = useState('');
    const [busqueda, setBusqueda] = useState('');

    const [modalCrear, setModalCrear] = useState(false);
    const [guardando, setGuardando] = useState(false);
    const [form, setForm] = useState({
        nombre: '',
        especie: 'Canino',
        raza: '',
        edad: '',
        sexo: 'Macho',
        zona_rescate: '',
        fecha_ingreso: new Date().toISOString().split('T')[0],
        foto: '',
        estado_actual: 'En Recuperación',
    });

    const [modalExpediente, setModalExpediente] = useState<Mascota | null>(null);
    const [historialMascota, setHistorialMascota] = useState<HistorialItem[]>([]);
    const [cargandoHistorial, setCargandoHistorial] = useState(false);

    const token = authService.getToken();

    const cargarMascotas = async () => {
        setCargando(true);
        try {
            const params = new URLSearchParams();
            if (filtroEstado) params.append('estado', filtroEstado);
            if (filtroEspecie) params.append('especie', filtroEspecie);
            if (busqueda) params.append('buscar', busqueda);

            const res = await fetch(`/api/mascotas?${params.toString()}`, {
                headers: {
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
            });
            if (res.ok) {
                const data = await res.json();
                setMascotas(data.mascotas);
            }
        } catch (error) {
            console.error('Error cargando mascotas:', error);
        } finally {
            setCargando(false);
        }
    };

    useEffect(() => {
        cargarMascotas();
    }, [filtroEstado, filtroEspecie]);

    const handleCrearMascota = async (e: React.FormEvent) => {
        e.preventDefault();
        setGuardando(true);
        try {
            const res = await fetch('/api/mascotas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify(form),
            });
            if (res.ok) {
                setModalCrear(false);
                setForm({
                    nombre: '',
                    especie: 'Canino',
                    raza: '',
                    edad: '',
                    sexo: 'Macho',
                    zona_rescate: '',
                    fecha_ingreso: new Date().toISOString().split('T')[0],
                    foto: '',
                    estado_actual: 'En Recuperación',
                });
                cargarMascotas();
            } else {
                const err = await res.json();
                alert(err.message || 'Error al registrar rescate.');
            }
        } catch (error) {
            console.error('Error creando mascota:', error);
        } finally {
            setGuardando(false);
        }
    };

    const verExpediente = async (mascota: Mascota) => {
        setModalExpediente(mascota);
        setCargandoHistorial(true);
        try {
            const res = await fetch(`/api/historial-clinico/mascota/${mascota.id}`, {
                headers: {
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
            });
            if (res.ok) {
                const data = await res.json();
                setHistorialMascota(data.historial_clinico || []);
            }
        } catch (error) {
            console.error('Error cargando expediente:', error);
        } finally {
            setCargandoHistorial(false);
        }
    };

    const imprimirExpedientePDF = () => {
        if (!modalExpediente) return;
        const printWin = window.open("", "_blank");
        if (!printWin) return;

        const filasHistorial = (historialMascota || []).map((h) => `
            <tr>
                <td style="padding: 10px; border-bottom: 1px solid #e5e7eb; font-size: 13px;">${h.fecha_atencion}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e5e7eb; font-size: 13px; font-weight: bold; color: #183d35;">${h.tipo_procedimiento}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e5e7eb; font-size: 13px;">${h.diagnostico}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e5e7eb; font-size: 13px;">${h.observacion}</td>
                <td style="padding: 10px; border-bottom: 1px solid #e5e7eb; font-size: 13px; color: #4b5563;">${h.usuario?.nombre || "Veterinario de Turno"}</td>
            </tr>
        `).join("");

        printWin.document.write(`
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>Expediente Clínico - ${modalExpediente.nombre}</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 30px; color: #1f2937; }
                    .header { border-bottom: 2px solid #183d35; padding-bottom: 15px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: flex-end; }
                    .title { color: #183d35; margin: 0; font-size: 24px; font-weight: 700; }
                    .subtitle { color: #6b7280; font-size: 13px; margin: 5px 0 0 0; }
                    .meta-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 18px; margin-bottom: 25px; }
                    .meta-item { font-size: 13px; }
                    .meta-item strong { display: block; color: #475569; font-size: 11px; text-transform: uppercase; margin-bottom: 2px; }
                    table { width: 100%; border-collapse: collapse; margin-bottom: 35px; }
                    th { background-color: #183d35; color: white; text-align: left; padding: 10px; font-size: 12px; text-transform: uppercase; }
                    .footer-sign { display: flex; justify-content: space-between; margin-top: 50px; padding-top: 20px; }
                    .sign-box { width: 220px; border-top: 1px solid #64748b; text-align: center; font-size: 12px; color: #475569; padding-top: 8px; }
                    @media print { .no-print { display: none; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="margin-bottom: 20px; display: flex; gap: 10px;">
                    <button onclick="window.print()" style="padding: 10px 20px; background-color: #183d35; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Imprimir Documento / Guardar PDF</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background-color: #e2e8f0; border: none; border-radius: 6px; cursor: pointer;">Cerrar</button>
                </div>
                <div class="header">
                    <div>
                        <h1 class="title">REFUGIO LOS ANGELITOS DE EDGAR</h1>
                        <p class="subtitle">EXPEDIENTE CLÍNICO VETERINARIO OFICIAL • REGISTRO SANITARIO</p>
                    </div>
                    <div style="text-align: right; font-size: 12px; color: #64748b;">
                        <strong>EXP-2026-${String(modalExpediente.id).padStart(5, "0")}</strong><br>
                        Fecha emisión: ${new Date().toLocaleDateString("es-BO")}
                    </div>
                </div>

                <div class="meta-grid">
                    <div class="meta-item"><strong>Nombre del Paciente</strong>${modalExpediente.nombre}</div>
                    <div class="meta-item"><strong>Especie / Raza</strong>${modalExpediente.especie} - ${modalExpediente.raza || "Mestizo"}</div>
                    <div class="meta-item"><strong>Sexo / Color</strong>${modalExpediente.sexo} • ${modalExpediente.color || "No especificado"}</div>
                    <div class="meta-item"><strong>Edad Estimada</strong>${modalExpediente.edad_aproximada || "Adulto joven"}</div>
                    <div class="meta-item"><strong>Fecha de Ingreso</strong>${modalExpediente.fecha_ingreso || "2026-01-15"}</div>
                    <div class="meta-item"><strong>Zona de Rescate</strong>${modalExpediente.zona_rescate || "Urbana"}</div>
                    <div class="meta-item"><strong>Estado Actual</strong><span style="font-weight: bold; color: #16a34a;">${modalExpediente.estado_actual}</span></div>
                    <div class="meta-item"><strong>Condición de Ingreso</strong>${modalExpediente.condicion_ingreso || "Rescatado"}</div>
                    <div class="meta-item"><strong>Microchip / Ficha</strong>REF-${String(modalExpediente.id).padStart(4, "0")}</div>
                </div>

                <h3 style="color: #183d35; font-size: 16px; margin-bottom: 12px; border-bottom: 1px solid #cbd5e1; padding-bottom: 6px;">Historial de Procedimientos y Atenciones Médicas</h3>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 15%;">Fecha</th>
                            <th style="width: 20%;">Procedimiento</th>
                            <th style="width: 25%;">Diagnóstico Clínico</th>
                            <th style="width: 25%;">Tratamiento / Insumos</th>
                            <th style="width: 15%;">Veterinario</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${filasHistorial || '<tr><td colspan="5" style="text-align:center; padding:20px;">Sin registros médicos.</td></tr>'}
                    </tbody>
                </table>

                <div class="footer-sign">
                    <div class="sign-box">
                        <strong>Médico Veterinario Responsable</strong><br>
                        Colegio Médico Veterinario (COMVET)
                    </div>
                    <div class="sign-box">
                        <strong>Dirección del Albergue</strong><br>
                        Refugio Los Angelitos de Edgar
                    </div>
                </div>
            </body>
            </html>
        `);
        printWin.document.close();
    };

    return (
        <div className="dashboard-app">
            <Head title="Gestión de Rescate y Mascotas (P7) - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Fichas de Mascotas (P7)" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">RESCATE Y FICHA CLÍNICA VETERINARIA</p>
                                <h2>Ficha de Rescate e Ingreso de Mascotas</h2>
                                <p>Registro de animales acogidos, diagnóstico inicial de salud y consulta del expediente médico.</p>
                            </div>
                            <button
                                type="button"
                                onClick={() => setModalCrear(true)}
                                className="btn-crear"
                            >
                                <span style={{ fontSize: '16px' }}>+</span> Registrar Nuevo Rescate
                            </button>
                        </div>
                    </section>

                <div className="table-card">
                    <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--dashboard-line)', display: 'flex', gap: '12px', flexWrap: 'wrap', alignItems: 'center', backgroundColor: '#fcfdfb' }}>
                        <select
                            value={filtroEstado}
                            onChange={(e) => setFiltroEstado(e.target.value)}
                            style={{ minHeight: '38px', padding: '0 12px', borderRadius: '4px', border: '1px solid var(--dashboard-line)', background: '#fff', fontSize: '12.5px', color: 'var(--dashboard-ink)' }}
                        >
                            <option value="">Todos los Estados</option>
                            <option value="En Recuperación">En Recuperación</option>
                            <option value="Disponible">Disponible para Adopción</option>
                            <option value="Adoptado">Adoptado</option>
                            <option value="Fallecido">Fallecido</option>
                        </select>

                        <select
                            value={filtroEspecie}
                            onChange={(e) => setFiltroEspecie(e.target.value)}
                            style={{ minHeight: '38px', padding: '0 12px', borderRadius: '4px', border: '1px solid var(--dashboard-line)', background: '#fff', fontSize: '12.5px', color: 'var(--dashboard-ink)' }}
                        >
                            <option value="">Todas las Especies</option>
                            <option value="Canino">Canino</option>
                            <option value="Felino">Felino</option>
                            <option value="Otro">Otro</option>
                        </select>

                        <div style={{ flex: 1, minWidth: '220px' }}>
                            <input
                                type="text"
                                placeholder="Buscar por nombre, raza o zona de rescate..."
                                value={busqueda}
                                onChange={(e) => setBusqueda(e.target.value)}
                                onKeyDown={(e) => e.key === 'Enter' && cargarMascotas()}
                                style={{ width: '100%', minHeight: '38px', padding: '0 12px', borderRadius: '4px', border: '1px solid var(--dashboard-line)', background: '#fff', fontSize: '12.5px', boxSizing: 'border-box' }}
                            />
                        </div>
                        <button
                            type="button"
                            onClick={cargarMascotas}
                            className="btn-action-view"
                            style={{ minHeight: '38px', padding: '0 16px' }}
                        >
                            Buscar
                        </button>
                    </div>

                    <div className="table-responsive">
                        <table className="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Especie / Raza</th>
                                    <th>Edad / Sexo</th>
                                    <th>Zona de Rescate</th>
                                    <th>Fecha Ingreso</th>
                                    <th>Estado Actual</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                {cargando ? (
                                    <tr><td colSpan={8} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando expediente de mascotas...</td></tr>
                                ) : mascotas.length === 0 ? (
                                    <tr><td colSpan={8} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay mascotas registradas.</td></tr>
                                ) : (
                                    mascotas.map((m) => (
                                        <tr key={m.id}>
                                            <td><strong style={{ color: 'var(--dashboard-forest)' }}>#{m.id}</strong></td>
                                            <td><strong style={{ color: 'var(--dashboard-ink)' }}>{m.nombre}</strong></td>
                                            <td>{m.especie} - {m.raza}</td>
                                            <td>{m.edad} ({m.sexo})</td>
                                            <td>{m.zona_rescate || 'No especificada'}</td>
                                            <td>{m.fecha_ingreso}</td>
                                            <td>
                                                <span className={`badge-tag ${
                                                    m.estado_actual === 'Disponible' ? 'badge-tag--success' :
                                                    m.estado_actual === 'Adoptado' ? 'badge-tag--info' :
                                                    m.estado_actual === 'En Recuperación' ? 'badge-tag--warning' : 'badge-tag--danger'
                                                }`}>
                                                    {m.estado_actual}
                                                </span>
                                            </td>
                                            <td>
                                                <button
                                                    onClick={() => verExpediente(m)}
                                                    className="btn-action-view"
                                                >
                                                    🩺 Expediente Clínico
                                                </button>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Modal Crear Mascota */}
                {modalCrear && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '500px', maxWidth: '95vw', maxHeight: '90vh', overflowY: 'auto' }}>
                            <h2 style={{ marginBottom: '16px' }}>Registrar Ficha de Rescate</h2>
                            <form onSubmit={handleCrearMascota}>
                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Nombre Temporal</label>
                                        <input
                                            type="text"
                                            required
                                            value={form.nombre}
                                            onChange={(e) => setForm({ ...form, nombre: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Especie</label>
                                        <select
                                            value={form.especie}
                                            onChange={(e) => setForm({ ...form, especie: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        >
                                            <option value="Canino">Canino</option>
                                            <option value="Felino">Felino</option>
                                            <option value="Otro">Otro</option>
                                        </select>
                                    </div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Raza</label>
                                        <input
                                            type="text"
                                            required
                                            placeholder="Ej. Mestizo, Criollo"
                                            value={form.raza}
                                            onChange={(e) => setForm({ ...form, raza: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Edad Estimada</label>
                                        <input
                                            type="text"
                                            required
                                            placeholder="Ej. 1 año, 6 meses"
                                            value={form.edad}
                                            onChange={(e) => setForm({ ...form, edad: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Sexo</label>
                                        <select
                                            value={form.sexo}
                                            onChange={(e) => setForm({ ...form, sexo: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        >
                                            <option value="Macho">Macho</option>
                                            <option value="Hembra">Hembra</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Estado Inicial</label>
                                        <select
                                            value={form.estado_actual}
                                            onChange={(e) => setForm({ ...form, estado_actual: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        >
                                            <option value="En Recuperación">En Recuperación</option>
                                            <option value="Disponible">Disponible</option>
                                        </select>
                                    </div>
                                </div>

                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Lugar o Zona de Rescate</label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="Ej. Zona Sur, Av. Principal esq. Calle 5"
                                        value={form.zona_rescate}
                                        onChange={(e) => setForm({ ...form, zona_rescate: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha de Ingreso</label>
                                    <input
                                        type="date"
                                        required
                                        value={form.fecha_ingreso}
                                        onChange={(e) => setForm({ ...form, fecha_ingreso: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
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
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#0284c7', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        {guardando ? 'Guardando...' : 'Guardar Ficha'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}

                {/* Modal Expediente Clínico */}
                {modalExpediente && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '650px', maxWidth: '95vw', maxHeight: '90vh', overflowY: 'auto' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                                <div>
                                    <h2 style={{ margin: 0 }}>Expediente Clínico: {modalExpediente.nombre}</h2>
                                    <span style={{ fontSize: '13px', color: '#6b7280' }}>
                                        {modalExpediente.especie} | {modalExpediente.raza} | {modalExpediente.sexo} | Rescatado en {modalExpediente.zona_rescate}
                                    </span>
                                </div>
                                <button
                                    onClick={() => setModalExpediente(null)}
                                    style={{ border: 'none', background: 'transparent', fontSize: '20px', cursor: 'pointer' }}
                                >
                                    &times;
                                </button>
                            </div>

                            {cargandoHistorial ? (
                                <p style={{ textAlign: 'center', padding: '20px' }}>Cargando expediente médico...</p>
                            ) : historialMascota.length === 0 ? (
                                <p style={{ textAlign: 'center', padding: '24px', color: '#6b7280' }}>
                                    No se registran atenciones clínicas para esta mascota todavía.
                                </p>
                            ) : (
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                                    {historialMascota.map((h) => (
                                        <div key={h.id} style={{ padding: '14px', borderRadius: '8px', border: '1px solid #e5e7eb', backgroundColor: '#f9fafb' }}>
                                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '6px' }}>
                                                <strong style={{ color: '#0369a1' }}>{h.tipo_procedimiento}</strong>
                                                <span style={{ fontSize: '12px', color: '#6b7280' }}>{h.fecha_atencion}</span>
                                            </div>
                                            <p style={{ margin: '4px 0', fontSize: '13px' }}><strong>Diagnóstico:</strong> {h.diagnostico}</p>
                                            <p style={{ margin: '4px 0', fontSize: '13px', color: '#4b5563' }}><strong>Observación:</strong> {h.observacion}</p>
                                            {h.usuario && (
                                                <span style={{ fontSize: '11px', color: '#9ca3af', display: 'block', marginTop: '6px' }}>
                                                    Atendido por: {h.usuario.nombre}
                                                </span>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            )}

                            <div style={{ marginTop: '20px', display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                <button
                                    type="button"
                                    onClick={imprimirExpedientePDF}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#183d35', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                >
                                    Imprimir Expediente (PDF)
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setModalExpediente(null)}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: '#f3f4f6', cursor: 'pointer' }}
                                >
                                    Cerrar Expediente
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
