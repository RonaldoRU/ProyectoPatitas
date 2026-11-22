/**
 * Vista de Gestión de Mascotas Rescatadas (P7 - CU19):
 * Permite registrar nuevas mascotas rescatadas, filtrar por especie o estado (En Recuperación, Disponible, Adoptado),
 * y consultar el expediente digital e historial de atención clínica de cada animal.
 */
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
    const [userRol, setUserRol] = useState<string>('');

    useEffect(() => {
        try {
            const raw = localStorage.getItem('user');
            if (raw) {
                const u = JSON.parse(raw);
                if (u?.rol) {
                    setUserRol(u.rol);
                    if (u.rol === 'Donante' || u.rol === 'Postulante') {
                        setFiltroEstado('Disponible');
                    }
                }
            }
        } catch {
            // ignore
        }
    }, []);

    const esExterno = userRol === 'Donante' || userRol === 'Postulante';

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
    const [modalEditar, setModalEditar] = useState<Mascota | null>(null);
    const [formEditar, setFormEditar] = useState({
        nombre: '',
        especie: 'Canino',
        raza: '',
        edad: '',
        sexo: 'Macho',
        zona_rescate: '',
        fecha_ingreso: '',
        foto: '',
        estado_actual: 'En Recuperación',
    });
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

    // Soporte para descarga / impresión de PDF mediante comando de voz
    useEffect(() => {
        const handleVoiceDownload = (e: Event) => {
            const customE = e as CustomEvent<{ action?: string }>;
            if (modalExpediente) {
                imprimirExpedientePDF();
            } else if (mascotas.length > 0) {
                verExpediente(mascotas[0]);
                setTimeout(() => {
                    imprimirExpedientePDF();
                }, 600);
            }
        };
        window.addEventListener('voice-download-pdf', handleVoiceDownload);
        return () => window.removeEventListener('voice-download-pdf', handleVoiceDownload);
    }, [modalExpediente, mascotas, historialMascota]);

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

    const abrirEditarMascota = (m: Mascota) => {
        setModalEditar(m);
        setFormEditar({
            nombre: m.nombre,
            especie: m.especie,
            raza: m.raza,
            edad: m.edad,
            sexo: m.sexo,
            zona_rescate: m.zona_rescate,
            fecha_ingreso: m.fecha_ingreso,
            foto: m.foto || '',
            estado_actual: m.estado_actual,
        });
    };

    const handleActualizarMascota = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!modalEditar) return;
        setGuardando(true);
        try {
            const res = await fetch(`/api/mascotas/${modalEditar.id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify(formEditar),
            });
            if (res.ok) {
                setModalEditar(null);
                cargarMascotas();
            } else {
                const err = await res.json();
                alert(err.message || 'Error al actualizar los datos de la mascota.');
            }
        } catch (error) {
            console.error('Error actualizando mascota:', error);
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
                    <div class="meta-item"><strong>Sexo / Especie</strong>${modalExpediente.sexo} • ${modalExpediente.especie}</div>
                    <div class="meta-item"><strong>Edad Estimada</strong>${modalExpediente.edad || "Adulto joven"}</div>
                    <div class="meta-item"><strong>Fecha de Ingreso</strong>${modalExpediente.fecha_ingreso || "2026-01-15"}</div>
                    <div class="meta-item"><strong>Zona de Rescate</strong>${modalExpediente.zona_rescate || "Urbana"}</div>
                    <div class="meta-item"><strong>Estado Actual</strong><span style="font-weight: bold; color: #243d34;">${modalExpediente.estado_actual}</span></div>
                    <div class="meta-item"><strong>Ficha / Registro</strong>REF-${String(modalExpediente.id).padStart(4, "0")}</div>
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
            <Head title="Gestión de Rescate y Mascotas - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Fichas de Mascotas Rescatadas" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">
                                    {esExterno ? 'ADOPCIÓN RESPONSABLE' : 'RESCATE Y FICHA CLÍNICA VETERINARIA'}
                                </p>
                                <h2>
                                    {esExterno ? 'Animalitos Rescatados en Busca de Familia' : 'Ficha de Rescate e Ingreso de Mascotas'}
                                </h2>
                                <p>
                                    {esExterno
                                        ? 'Conoce a nuestros pequeños rescatados, su fotografía y estado de recuperación. ¡Tú puedes cambiar su vida con una adopción o donación!'
                                        : 'Registro de animales acogidos, diagnóstico inicial de salud y consulta del expediente médico.'}
                                </p>
                            </div>
                            {!esExterno ? (
                                <button
                                    type="button"
                                    onClick={() => setModalCrear(true)}
                                    className="btn-crear"
                                >
                                    <span style={{ fontSize: '16px' }}>+</span> Registrar Nuevo Rescate
                                </button>
                            ) : (
                                <Link
                                    href="/pasarela-pagos"
                                    className="btn-crear"
                                    style={{ textDecoration: 'none', display: 'inline-flex', alignItems: 'center', gap: '8px', background: 'linear-gradient(135deg, #0d5f4e 0%, #17735f 100%)' }}
                                >
                                    Realizar Donación
                                </Link>
                            )}
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
                            <option value="Disponible">Disponible para Adopción</option>
                            <option value="En Recuperación">En Recuperación</option>
                            <option value="Adoptado">Adoptado</option>
                            {!esExterno && <option value="Fallecido">Fallecido</option>}
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
                                    <th style={{ width: '58px' }}>Foto</th>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Especie / Raza</th>
                                    <th>Edad / Sexo</th>
                                    <th>Zona de Rescate</th>
                                    <th>Enlace de Visualización (foto)</th>
                                    <th>Fecha Ingreso</th>
                                    <th>Estado Actual</th>
                                    <th>{esExterno ? 'Detalles' : 'Acciones'}</th>
                                </tr>
                            </thead>
                            <tbody>
                                {cargando ? (
                                    <tr><td colSpan={10} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando expediente de mascotas...</td></tr>
                                ) : mascotas.length === 0 ? (
                                    <tr><td colSpan={10} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay mascotas registradas.</td></tr>
                                ) : (
                                    mascotas.map((m) => {
                                        const estNorm = (m.estado_actual || '').toLowerCase();
                                        const badgeClass = estNorm.includes('disponible')
                                            ? 'badge-tag--success'
                                            : estNorm.includes('adoptado')
                                              ? 'badge-tag--info'
                                              : estNorm.includes('fallecido')
                                                ? 'badge-tag--danger'
                                                : 'badge-tag--warning';

                                        return (
                                            <tr key={m.id}>
                                                <td>
                                                    <a
                                                        href={m.foto || '#'}
                                                        target={m.foto ? '_blank' : undefined}
                                                        rel="noreferrer"
                                                        title={m.foto ? `Ver foto de ${m.nombre}` : m.nombre}
                                                        className="pet-earth-green-bg"
                                                        style={{ width: '54px', height: '54px', borderRadius: '10px', overflow: 'hidden', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
                                                    >
                                                        {m.foto ? (
                                                            <img
                                                                src={m.foto}
                                                                alt={m.nombre}
                                                                style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                                                                onError={(e) => {
                                                                    (e.target as HTMLElement).style.display = 'none';
                                                                }}
                                                            />
                                                        ) : (
                                                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#64748b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                                                <circle cx="12" cy="12" r="9" />
                                                                <path d="M9 10h.01M15 10h.01M9.5 15a3.5 3.5 0 0 0 5 0" />
                                                            </svg>
                                                        )}
                                                    </a>
                                                </td>
                                                <td><strong style={{ color: 'var(--dashboard-forest)' }}>#{m.id}</strong></td>
                                                <td><strong style={{ color: 'var(--dashboard-ink)' }}>{m.nombre}</strong></td>
                                                <td>{m.especie} - {m.raza}</td>
                                                <td>{m.edad} ({m.sexo})</td>
                                                <td>{m.zona_rescate || 'No especificada'}</td>
                                                <td>
                                                    {m.foto ? (
                                                        <a
                                                            href={m.foto}
                                                            target="_blank"
                                                            rel="noreferrer"
                                                            title={m.foto}
                                                            style={{
                                                                display: 'inline-block',
                                                                maxWidth: '210px',
                                                                overflow: 'hidden',
                                                                textOverflow: 'ellipsis',
                                                                whiteSpace: 'nowrap',
                                                                color: '#0d6e4f',
                                                                fontWeight: 700,
                                                                fontSize: '11.5px',
                                                                textDecoration: 'underline',
                                                            }}
                                                        >
                                                            {m.foto}
                                                        </a>
                                                    ) : (
                                                        <span style={{ fontSize: '11.5px', color: '#94a3b8' }}>Sin enlace</span>
                                                    )}
                                                </td>
                                                <td>{m.fecha_ingreso}</td>
                                                <td>
                                                    <span className={`badge-tag ${badgeClass}`}>
                                                        {m.estado_actual}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
                                                        <button
                                                            onClick={() => verExpediente(m)}
                                                            className="btn-action-view"
                                                            title={esExterno ? 'Ver ficha y estado de salud' : 'Ver expediente clínico'}
                                                        >
                                                            {esExterno ? 'Ver Ficha' : 'Expediente'}
                                                        </button>
                                                        {!esExterno && (
                                                            <button
                                                                onClick={() => abrirEditarMascota(m)}
                                                                className="btn-action-secondary"
                                                                title="Editar datos y estado"
                                                            >
                                                                Editar
                                                            </button>
                                                        )}
                                                    </div>
                                                </td>
                                            </tr>
                                        );
                                    })
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
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: 'var(--dashboard-forest)', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        {guardando ? 'Guardando...' : 'Guardar Ficha'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}

                {/* Modal Editar Mascota */}
                {modalEditar && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '520px', maxWidth: '95vw', maxHeight: '90vh', overflowY: 'auto' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                                <h2 style={{ margin: 0, fontSize: '18px', color: 'var(--dashboard-forest)' }}>Editar Ficha de Rescate #{modalEditar.id}</h2>
                                <button
                                    onClick={() => setModalEditar(null)}
                                    style={{ border: 'none', background: 'transparent', fontSize: '20px', cursor: 'pointer' }}
                                >
                                    &times;
                                </button>
                            </div>
                            <form onSubmit={handleActualizarMascota}>
                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Nombre</label>
                                        <input
                                            type="text"
                                            required
                                            value={formEditar.nombre}
                                            onChange={(e) => setFormEditar({ ...formEditar, nombre: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Especie</label>
                                        <select
                                            value={formEditar.especie}
                                            onChange={(e) => setFormEditar({ ...formEditar, especie: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
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
                                            value={formEditar.raza}
                                            onChange={(e) => setFormEditar({ ...formEditar, raza: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Edad Estimada</label>
                                        <input
                                            type="text"
                                            required
                                            value={formEditar.edad}
                                            onChange={(e) => setFormEditar({ ...formEditar, edad: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                        />
                                    </div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Sexo</label>
                                        <select
                                            value={formEditar.sexo}
                                            onChange={(e) => setFormEditar({ ...formEditar, sexo: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                        >
                                            <option value="Macho">Macho</option>
                                            <option value="Hembra">Hembra</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Estado Actual</label>
                                        <select
                                            value={formEditar.estado_actual}
                                            onChange={(e) => setFormEditar({ ...formEditar, estado_actual: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                        >
                                            <option value="En Recuperación">En Recuperación</option>
                                            <option value="Disponible">Disponible para Adopción</option>
                                            <option value="Adoptado">Adoptado</option>
                                            <option value="En tratamiento">En tratamiento</option>
                                            <option value="Fallecido">Fallecido</option>
                                        </select>
                                    </div>
                                </div>

                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Lugar o Zona de Rescate</label>
                                    <input
                                        type="text"
                                        required
                                        value={formEditar.zona_rescate}
                                        onChange={(e) => setFormEditar({ ...formEditar, zona_rescate: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                    />
                                </div>

                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha de Ingreso</label>
                                    <input
                                        type="date"
                                        required
                                        value={formEditar.fecha_ingreso}
                                        onChange={(e) => setFormEditar({ ...formEditar, fecha_ingreso: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px', boxSizing: 'border-box' }}
                                    />
                                </div>

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setModalEditar(null)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        type="submit"
                                        disabled={guardando}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: 'var(--dashboard-forest)', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        {guardando ? 'Actualizando...' : 'Guardar Cambios'}
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
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '16px' }}>
                                <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
                                    <div style={{ width: '64px', height: '64px', borderRadius: '10px', overflow: 'hidden', background: '#f1f5f9', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px solid #cbd5e1', flexShrink: 0 }}>
                                        {modalExpediente.foto ? (
                                            <img
                                                src={modalExpediente.foto}
                                                alt={modalExpediente.nombre}
                                                style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                                                onError={(e) => {
                                                    (e.target as HTMLElement).style.display = 'none';
                                                }}
                                            />
                                        ) : (
                                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#64748b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                                <circle cx="12" cy="12" r="9" />
                                                <path d="M9 10h.01M15 10h.01M9.5 15a3.5 3.5 0 0 0 5 0" />
                                            </svg>
                                        )}
                                    </div>
                                    <div>
                                        <h2 style={{ margin: 0, fontSize: '20px', color: '#183d35' }}>
                                            {esExterno ? 'Ficha de Mascota: ' : 'Expediente Clínico: '}{modalExpediente.nombre}
                                        </h2>
                                        <span style={{ fontSize: '13px', color: '#6b7280' }}>
                                            {modalExpediente.especie} | {modalExpediente.raza} | {modalExpediente.sexo} | Rescatado en {modalExpediente.zona_rescate}
                                        </span>
                                        <div style={{ marginTop: '6px', display: 'flex', alignItems: 'center', gap: '10px', flexWrap: 'wrap' }}>
                                            <span className={`badge-tag ${
                                                (modalExpediente.estado_actual || '').toLowerCase().includes('disponible') ? 'badge-tag--success' :
                                                (modalExpediente.estado_actual || '').toLowerCase().includes('adoptado') ? 'badge-tag--info' :
                                                (modalExpediente.estado_actual || '').toLowerCase().includes('fallecido') ? 'badge-tag--danger' : 'badge-tag--warning'
                                            }`}>
                                                Estado: {modalExpediente.estado_actual}
                                            </span>
                                            {modalExpediente.foto && (
                                                <a
                                                    href={modalExpediente.foto}
                                                    target="_blank"
                                                    rel="noreferrer"
                                                    style={{ fontSize: '12px', fontWeight: 700, color: '#0d6e4f', textDecoration: 'underline' }}
                                                >
                                                    Abrir fotografía original →
                                                </a>
                                            )}
                                        </div>
                                    </div>
                                </div>
                                <button
                                    onClick={() => setModalExpediente(null)}
                                    style={{ border: 'none', background: 'transparent', fontSize: '24px', cursor: 'pointer', color: '#64748b' }}
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
