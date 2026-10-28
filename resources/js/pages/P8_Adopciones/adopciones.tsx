import { Head, Link } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import authService from '@/services/authService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';

interface Adopcion {
    id: number;
    fecha_adopcion: string;
    interesado?: { id: number; nombre: string; ci: string; telefono: string; direccion: string };
    mascota?: { id: number; nombre: string; especie: string; raza: string; sexo: string; foto: string };
}

interface PostulanteAprobado {
    id: number;
    nombre: string;
    ci: string;
    estado: string;
}

interface MascotaDisponible {
    id: number;
    nombre: string;
    especie: string;
    raza: string;
    estado_actual: string;
}

interface Seguimiento {
    id: number;
    estado_seguimiento: string;
    fecha_programada: string;
    fecha_realizada?: string;
    reporte_bienestar: string;
    fotografia?: string;
    adopcion?: {
        interesado?: { nombre: string; telefono: string; direccion: string };
        mascota?: { nombre: string; especie: string };
    };
}

export default function Adopciones() {
    const [tab, setTab] = useState<'adopciones' | 'seguimientos'>('adopciones');
    const [adopciones, setAdopciones] = useState<Adopcion[]>([]);
    const [seguimientos, setSeguimientos] = useState<Seguimiento[]>([]);
    const [cargando, setCargando] = useState(true);

    const [modalFormalizar, setModalFormalizar] = useState(false);
    const [postulantesAprobados, setPostulantesAprobados] = useState<PostulanteAprobado[]>([]);
    const [mascotasDisponibles, setMascotasDisponibles] = useState<MascotaDisponible[]>([]);
    const [formAdopcion, setFormAdopcion] = useState({
        id_interesado: '',
        id_mascota: '',
        fecha_adopcion: new Date().toISOString().split('T')[0],
    });
    const [guardando, setGuardando] = useState(false);

    // Modal Acta
    const [actaDigital, setActaDigital] = useState<any | null>(null);

    // Modal Completar Seguimiento
    const [seguimientoACompletar, setSeguimientoACompletar] = useState<Seguimiento | null>(null);
    const [formSeguimiento, setFormSeguimiento] = useState({
        fecha_realizada: new Date().toISOString().split('T')[0],
        reporte_bienestar: '',
        fotografia: '/images/default-check.png',
    });

    const token = authService.getToken(); const cargarDatos = async () => {
        setCargando(true);
        try {
            const [resAdop, resSeg] = await Promise.all([
                fetch('/api/adopciones', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
                fetch('/api/seguimientos', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
            ]);

            if (resAdop.ok) {
                const data = await resAdop.json();
                setAdopciones(data.adopciones || []);
            }
            if (resSeg.ok) {
                const data = await resSeg.json();
                setSeguimientos(data.seguimientos || []);
            }
        } catch (error) {
            console.error('Error cargando adopciones:', error);
        } finally {
            setCargando(false);
        }
    };

    const abrirModalFormalizar = async () => {
        try {
            const [resPost, resMasc] = await Promise.all([
                fetch('/api/postulantes', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
                fetch('/api/mascotas?estado=Disponible', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
            ]);

            if (resPost.ok) {
                const data = await resPost.json();
                setPostulantesAprobados(
                    (data.postulantes || []).filter((p: any) => p.estado === 'Aprobado')
                );
            }
            if (resMasc.ok) {
                const data = await resMasc.json();
                setMascotasDisponibles(data.mascotas || []);
            }
            setModalFormalizar(true);
        } catch (error) {
            console.error('Error abriendo formalización:', error);
        }
    };

    const handleFormalizar = async (e: React.FormEvent) => {
        e.preventDefault();
        setGuardando(true);
        try {
            const res = await fetch('/api/adopciones', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify(formAdopcion),
            });
            if (res.ok) {
                setModalFormalizar(false);
                setFormAdopcion({
                    id_interesado: '',
                    id_mascota: '',
                    fecha_adopcion: new Date().toISOString().split('T')[0],
                });
                cargarDatos();
                alert('¡Adopción formalizada con éxito y 3 visitas de control programadas (30, 90 y 180 días)!');
            } else {
                const err = await res.json();
                alert(err.message || 'Error formalizando adopción.');
            }
        } catch (error) {
            console.error('Error formalizando:', error);
        } finally {
            setGuardando(false);
        }
    };

    const verActa = async (adopcionId: number) => {
        try {
            const res = await fetch(`/api/adopciones/${adopcionId}/acta`, {
                headers: { Accept: 'application/json', Authorization: `Bearer ${token}` },
            });
            if (res.ok) {
                const data = await res.json();
                setActaDigital(data.acta);
            }
        } catch (error) {
            console.error('Error obteniendo acta:', error);
        }
    };

    const handleCompletarSeguimiento = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!seguimientoACompletar) return;

        setGuardando(true);
        try {
            const res = await fetch(`/api/seguimientos/${seguimientoACompletar.id}`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify({
                    fecha_realizada: formSeguimiento.fecha_realizada,
                    reporte_bienestar: formSeguimiento.reporte_bienestar,
                    fotografia: formSeguimiento.fotografia,
                    estado_seguimiento: 'Completado',
                }),
            });
            if (res.ok) {
                setSeguimientoACompletar(null);
                cargarDatos();
                alert('¡Visita de seguimiento registrada y completada!');
            }
        } catch (error) {
            console.error('Error registrando seguimiento:', error);
        } finally {
            setGuardando(false);
        }
    };

    useEffect(() => {
        cargarDatos();
    }, []);

    return (
        <div className="dashboard-app">
            <Head title="Formalización de Adopciones y Control Post-Adopción (P8) - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Adopciones y Visitas (P8)" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">P8: GESTIÓN INTEGRAL DE ADOPCIONES</p>
                                <h2>Formalización de Adopciones y Visitas de Control</h2>
                                <p>CU22, CU24: Asignación legal a postulantes aprobados y auditoría post-adopción a 30, 90 y 180 días.</p>
                            </div>
                            <button
                                type="button"
                                onClick={abrirModalFormalizar}
                                className="btn-crear"
                            >
                                <span style={{ fontSize: '16px' }}>+</span> Formalizar Adopción (CU22)
                            </button>
                        </div>
                    </section>

                <div className="filter-tabs">
                    <button
                        onClick={() => setTab('adopciones')}
                        className={`filter-btn ${tab === 'adopciones' ? 'active' : ''}`}
                    >
                        <span>Adopciones Formalizadas</span>
                        <span style={{
                            padding: '2px 7px',
                            borderRadius: '10px',
                            fontSize: '11px',
                            backgroundColor: tab === 'adopciones' ? '#e1e89f' : '#edf1e9',
                            color: tab === 'adopciones' ? '#183d35' : '#65736d',
                            fontWeight: 800,
                        }}>
                            {adopciones.length}
                        </span>
                    </button>
                    <button
                        onClick={() => setTab('seguimientos')}
                        className={`filter-btn ${tab === 'seguimientos' ? 'active' : ''}`}
                    >
                        <span>Agenda de Visitas de Seguimiento</span>
                        <span style={{
                            padding: '2px 7px',
                            borderRadius: '10px',
                            fontSize: '11px',
                            backgroundColor: tab === 'seguimientos' ? '#e1e89f' : '#edf1e9',
                            color: tab === 'seguimientos' ? '#183d35' : '#65736d',
                            fontWeight: 800,
                        }}>
                            {seguimientos.length}
                        </span>
                    </button>
                </div>

                {tab === 'adopciones' ? (
                    <div className="table-card">
                        <div className="table-responsive">
                            <table className="data-table">
                                <thead>
                                    <tr>
                                        <th>Código Adopción</th>
                                        <th>Fecha Formalización</th>
                                        <th>Adoptante Aprobado</th>
                                        <th>Teléfono / Contacto</th>
                                        <th>Mascota Adoptada</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {cargando ? (
                                        <tr><td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>Cargando adopciones registradas...</td></tr>
                                    ) : adopciones.length === 0 ? (
                                        <tr><td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>No hay adopciones formalizadas todavía.</td></tr>
                                    ) : (
                                        adopciones.map((a) => (
                                            <tr key={a.id}>
                                                <td><strong style={{ color: 'var(--dashboard-forest)', letterSpacing: '0.04em' }}>ADOP-#{a.id}</strong></td>
                                                <td>{a.fecha_adopcion}</td>
                                                <td>
                                                    <strong style={{ color: 'var(--dashboard-ink)' }}>{a.interesado?.nombre}</strong>
                                                    <span style={{ display: 'block', fontSize: '11px', color: 'var(--dashboard-muted)' }}>CI: {a.interesado?.ci}</span>
                                                </td>
                                                <td>{a.interesado?.telefono}</td>
                                                <td>
                                                    <span style={{ color: 'var(--dashboard-forest)', fontWeight: 700 }}>{a.mascota?.nombre}</span> <span style={{ color: 'var(--dashboard-muted)', fontSize: '11.5px' }}>({a.mascota?.especie})</span>
                                                </td>
                                                <td>
                                                    <button
                                                        onClick={() => verActa(a.id)}
                                                        className="btn-action-view"
                                                    >
                                                        📄 Emitir Acta Digital (PDF)
                                                    </button>
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </div>
                    </div>
                ) : (
                    <div className="table-card">
                        <div className="table-responsive">
                            <table className="data-table">
                                <thead>
                                    <tr>
                                        <th>Visita #</th>
                                        <th>Mascota / Adoptante</th>
                                        <th>Fecha Programada</th>
                                        <th>Fecha Realizada</th>
                                        <th>Estado</th>
                                        <th>Reporte de Bienestar</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {cargando ? (
                                        <tr><td colSpan={7} style={{ textAlign: 'center', padding: '24px' }}>Cargando visitas...</td></tr>
                                    ) : seguimientos.length === 0 ? (
                                        <tr><td colSpan={7} style={{ textAlign: 'center', padding: '24px' }}>No hay visitas programadas.</td></tr>
                                    ) : (
                                        seguimientos.map((s) => (
                                            <tr key={s.id}>
                                                <td>#{s.id}</td>
                                                <td>
                                                    <strong>{s.adopcion?.mascota?.nombre}</strong>
                                                    <span style={{ display: 'block', fontSize: '11px', color: '#6b7280' }}>
                                                        Adoptante: {s.adopcion?.interesado?.nombre} ({s.adopcion?.interesado?.telefono})
                                                    </span>
                                                </td>
                                                <td>{s.fecha_programada}</td>
                                                <td>{s.fecha_realizada || 'Pendiente'}</td>
                                                <td>
                                                    <span className={`badge-tag ${s.estado_seguimiento === 'Completado' ? 'badge-tag--success' : 'badge-tag--warning'}`}>
                                                        {s.estado_seguimiento}
                                                    </span>
                                                </td>
                                                <td>{s.reporte_bienestar || 'Sin observaciones registradas'}</td>
                                                <td>
                                                    {s.estado_seguimiento === 'Programado' ? (
                                                        <button
                                                            onClick={() => {
                                                                setSeguimientoACompletar(s);
                                                                setFormSeguimiento({
                                                                    fecha_realizada: new Date().toISOString().split('T')[0],
                                                                    reporte_bienestar: '',
                                                                    fotografia: '/images/default-check.png',
                                                                });
                                                            }}
                                                            className="btn-action-primary"
                                                        >
                                                            📝 Registrar Visita (CU24)
                                                        </button>
                                                    ) : (
                                                        <span className="badge-tag badge-tag--success">✓ Auditado OK</span>
                                                    )}
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )}

                {/* Modal Formalizar Adopción */}
                {modalFormalizar && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '500px', maxWidth: '95vw' }}>
                            <h2 style={{ marginBottom: '12px' }}>Formalizar Adopción (CU22)</h2>
                            <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                Al formalizar, el estado de la mascota cambiará a <strong>Adoptado</strong> y el sistema programará automáticamente las visitas de control a los <strong>30, 90 y 180 días</strong>.
                            </p>
                            <form onSubmit={handleFormalizar}>
                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Adoptante Aprobado</label>
                                    <select
                                        required
                                        value={formAdopcion.id_interesado}
                                        onChange={(e) => setFormAdopcion({ ...formAdopcion, id_interesado: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    >
                                        <option value="">Selecciona un postulante aprobado...</option>
                                        {postulantesAprobados.map((p) => (
                                            <option key={p.id} value={p.id}>
                                                {p.nombre} (CI: {p.ci})
                                            </option>
                                        ))}
                                    </select>
                                </div>

                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Mascota Disponible</label>
                                    <select
                                        required
                                        value={formAdopcion.id_mascota}
                                        onChange={(e) => setFormAdopcion({ ...formAdopcion, id_mascota: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    >
                                        <option value="">Selecciona una mascota disponible...</option>
                                        {mascotasDisponibles.map((m) => (
                                            <option key={m.id} value={m.id}>
                                                {m.nombre} ({m.especie} - {m.raza})
                                            </option>
                                        ))}
                                    </select>
                                </div>

                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha de Formalización / Entrega</label>
                                    <input
                                        type="date"
                                        required
                                        value={formAdopcion.fecha_adopcion}
                                        onChange={(e) => setFormAdopcion({ ...formAdopcion, fecha_adopcion: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setModalFormalizar(false)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        type="submit"
                                        disabled={guardando}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#16a34a', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        {guardando ? 'Formalizando...' : 'Confirmar Adopción'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}

                {/* Modal Acta Digital */}
                {actaDigital && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '28px', width: '600px', maxWidth: '95vw', border: '2px solid #16a34a' }}>
                            <div style={{ textAlign: 'center', borderBottom: '2px solid #e5e7eb', paddingBottom: '16px', marginBottom: '16px' }}>
                                <h1 style={{ color: '#16a34a', fontSize: '22px', margin: 0 }}>ACTA DE ADOPCIÓN RESPONSABLE</h1>
                                <span style={{ fontWeight: 600, color: '#4b5563' }}>{actaDigital.numero_acta}</span>
                                <p style={{ fontSize: '12px', color: '#9ca3af', margin: '4px 0 0 0' }}>Refugio: {actaDigital.albergue} | Fecha: {actaDigital.fecha}</p>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' }}>
                                <div style={{ padding: '12px', backgroundColor: '#f9fafb', borderRadius: '8px' }}>
                                    <h4 style={{ margin: '0 0 8px 0', color: '#1f2937' }}>Datos del Adoptante</h4>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Nombre:</strong> {actaDigital.adoptante?.nombre}</p>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>CI:</strong> {actaDigital.adoptante?.ci}</p>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Teléfono:</strong> {actaDigital.adoptante?.telefono}</p>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Dirección:</strong> {actaDigital.adoptante?.direccion}</p>
                                </div>

                                <div style={{ padding: '12px', backgroundColor: '#f9fafb', borderRadius: '8px' }}>
                                    <h4 style={{ margin: '0 0 8px 0', color: '#1f2937' }}>Datos de la Mascota</h4>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Nombre:</strong> {actaDigital.mascota?.nombre}</p>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Especie:</strong> {actaDigital.mascota?.especie}</p>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Raza:</strong> {actaDigital.mascota?.raza}</p>
                                    <p style={{ margin: '3px 0', fontSize: '13px' }}><strong>Sexo:</strong> {actaDigital.mascota?.sexo}</p>
                                </div>
                            </div>

                            <div style={{ padding: '12px', backgroundColor: '#ecfdf5', borderRadius: '8px', border: '1px solid #a7f3d0', marginBottom: '20px' }}>
                                <p style={{ margin: 0, fontSize: '12px', color: '#065f46', lineHeight: 1.5 }}>
                                    <strong>Compromiso Institucional:</strong> {actaDigital.compromiso}
                                </p>
                            </div>

                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                <button
                                    onClick={() => window.print()}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #16a34a', color: '#16a34a', background: 'transparent', cursor: 'pointer' }}
                                >
                                    Imprimir / Guardar PDF
                                </button>
                                <button
                                    onClick={() => setActaDigital(null)}
                                    style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#374151', color: 'white', cursor: 'pointer' }}
                                >
                                    Cerrar
                                </button>
                            </div>
                        </div>
                    </div>
                )}

                {/* Modal Registrar Visita */}
                {seguimientoACompletar && (
                    <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                        <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '500px', maxWidth: '95vw' }}>
                            <h2 style={{ marginBottom: '12px' }}>Registrar Visita Post-Adopción (CU24)</h2>
                            <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                Mascota: <strong>{seguimientoACompletar.adopcion?.mascota?.nombre}</strong> | Adoptante: <strong>{seguimientoACompletar.adopcion?.interesado?.nombre}</strong>
                            </p>
                            <form onSubmit={handleCompletarSeguimiento}>
                                <div style={{ marginBottom: '12px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha Realizada</label>
                                    <input
                                        type="date"
                                        required
                                        value={formSeguimiento.fecha_realizada}
                                        onChange={(e) => setFormSeguimiento({ ...formSeguimiento, fecha_realizada: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Informe de Bienestar / Estado de la Mascota</label>
                                    <textarea
                                        required
                                        rows={4}
                                        placeholder="Describa el estado de salud, alimentación, peso, higiene y trato familiar observado en la visita domiciliaria..."
                                        value={formSeguimiento.reporte_bienestar}
                                        onChange={(e) => setFormSeguimiento({ ...formSeguimiento, reporte_bienestar: e.target.value })}
                                        style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                    />
                                </div>

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setSeguimientoACompletar(null)}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        type="submit"
                                        disabled={guardando}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#0284c7', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        {guardando ? 'Guardando...' : 'Completar Visita'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}
                    </div>
            </main>
        </div>
    );
}
