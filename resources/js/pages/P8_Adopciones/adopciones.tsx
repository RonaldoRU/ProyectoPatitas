import { Head } from '@inertiajs/react';
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
    id_adopcion?: number;
    estado_seguimiento: string;
    fecha_programada: string;
    fecha_realizada?: string | null;
    reporte_bienestar: string;
    fotografia?: string;
    usuario?: { id: number; nombre: string };
    adopcion?: {
        id?: number;
        fecha_adopcion?: string;
        interesado?: { id?: number; nombre: string; ci?: string; telefono: string; direccion: string };
        mascota?: { id?: number; nombre: string; especie: string; raza?: string; sexo?: string; foto?: string };
    };
}

export default function Adopciones() {
    const [tab, setTab] = useState<'adopciones' | 'seguimientos'>('adopciones');
    const [adopciones, setAdopciones] = useState<Adopcion[]>([]);
    const [seguimientos, setSeguimientos] = useState<Seguimiento[]>([]);
    const [cargando, setCargando] = useState(true);

    // Filtros de visitas
    const [filtroVisitasEstado, setFiltroVisitasEstado] = useState<string>('todos');
    const [busquedaVisita, setBusquedaVisita] = useState<string>('');

    // Modal Formalizar Adopción (CU22)
    const [modalFormalizar, setModalFormalizar] = useState(false);
    const [postulantesAprobados, setPostulantesAprobados] = useState<PostulanteAprobado[]>([]);
    const [mascotasDisponibles, setMascotasDisponibles] = useState<MascotaDisponible[]>([]);
    const [formAdopcion, setFormAdopcion] = useState({
        id_interesado: '',
        id_mascota: '',
        fecha_adopcion: new Date().toISOString().split('T')[0],
    });

    // Modal Acta Digital
    const [actaDigital, setActaDigital] = useState<any | null>(null);

    // Modal Consultar Visita (CU24)
    const [visitaAConsultar, setVisitaAConsultar] = useState<Seguimiento | null>(null);

    // Modal Registrar / Completar Visita (CU24)
    const [seguimientoACompletar, setSeguimientoACompletar] = useState<Seguimiento | null>(null);
    const [formSeguimiento, setFormSeguimiento] = useState({
        fecha_realizada: new Date().toISOString().split('T')[0],
        reporte_bienestar: '',
        fotografia: '/images/default-check.png',
        estado_seguimiento: 'Concluido Satisfactorio',
    });

    // Modal Programar / Nueva Visita (CU24)
    const [modalNuevaVisita, setModalNuevaVisita] = useState(false);
    const [formNuevaVisita, setFormNuevaVisita] = useState({
        id_adopcion: '',
        fecha_programada: new Date().toISOString().split('T')[0],
        fecha_realizada: '',
        estado_seguimiento: 'Pendiente',
        reporte_bienestar: '',
        fotografia: '/images/default-check.png',
    });

    const [guardando, setGuardando] = useState(false);

    const token = authService.getToken();

    const cargarDatos = async () => {
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
            console.error('Error cargando adopciones y seguimientos:', error);
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
                await cargarDatos();
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

    const abrirModalCompletar = (s: Seguimiento) => {
        setSeguimientoACompletar(s);
        setFormSeguimiento({
            fecha_realizada: s.fecha_realizada || new Date().toISOString().split('T')[0],
            reporte_bienestar: s.reporte_bienestar === 'Sin observaciones registradas' ? '' : (s.reporte_bienestar || ''),
            fotografia: s.fotografia || '/images/default-check.png',
            estado_seguimiento: s.estado_seguimiento === 'Pendiente' || s.estado_seguimiento === 'Programado' ? 'Concluido Satisfactorio' : s.estado_seguimiento,
        });
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
                body: JSON.stringify(formSeguimiento),
            });
            if (res.ok) {
                setSeguimientoACompletar(null);
                await cargarDatos();
                alert('¡Visita de seguimiento registrada y guardada exitosamente!');
            } else {
                const err = await res.json();
                alert(err.message || 'Error registrando visita de seguimiento.');
            }
        } catch (error) {
            console.error('Error registrando seguimiento:', error);
        } finally {
            setGuardando(false);
        }
    };

    const handleNuevaVisita = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!formNuevaVisita.id_adopcion) {
            alert('Por favor selecciona una adopción.');
            return;
        }

        setGuardando(true);
        try {
            const res = await fetch('/api/seguimientos', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: JSON.stringify(formNuevaVisita),
            });
            if (res.ok) {
                setModalNuevaVisita(false);
                setFormNuevaVisita({
                    id_adopcion: '',
                    fecha_programada: new Date().toISOString().split('T')[0],
                    fecha_realizada: '',
                    estado_seguimiento: 'Pendiente',
                    reporte_bienestar: '',
                    fotografia: '/images/default-check.png',
                });
                await cargarDatos();
                alert('¡Visita de control programada con éxito!');
            } else {
                const err = await res.json();
                alert(err.message || 'Error programando visita.');
            }
        } catch (error) {
            console.error('Error al programar visita:', error);
        } finally {
            setGuardando(false);
        }
    };

    useEffect(() => {
        cargarDatos();
    }, []);

    // Visitas filtradas
    const seguimientosFiltrados = seguimientos.filter((s) => {
        const matchesEstado =
            filtroVisitasEstado === 'todos'
                ? true
                : filtroVisitasEstado === 'Pendiente'
                ? s.estado_seguimiento === 'Pendiente' || s.estado_seguimiento === 'Programado' || !s.fecha_realizada
                : s.estado_seguimiento === 'Completado' || s.estado_seguimiento === 'Concluido Satisfactorio';

        const query = busquedaVisita.toLowerCase().trim();
        const matchesBusqueda =
            !query ||
            s.adopcion?.mascota?.nombre?.toLowerCase().includes(query) ||
            s.adopcion?.interesado?.nombre?.toLowerCase().includes(query) ||
            s.adopcion?.interesado?.ci?.toLowerCase().includes(query) ||
            s.reporte_bienestar?.toLowerCase().includes(query);

        return matchesEstado && matchesBusqueda;
    });

    const esVisitaPendiente = (s: Seguimiento) => {
        return (
            s.estado_seguimiento === 'Pendiente' ||
            s.estado_seguimiento === 'Programado' ||
            !s.fecha_realizada ||
            s.fecha_realizada === 'Pendiente'
        );
    };

    const getEstadoBadge = (estado: string) => {
        switch (estado) {
            case 'Concluido Satisfactorio':
            case 'Completado':
                return <span className="badge-tag badge-tag--success">{estado}</span>;
            case 'Pendiente':
                return <span className="badge-tag badge-tag--warning">Pendiente</span>;
            case 'Programado':
                return (
                    <span className="badge-tag" style={{ backgroundColor: '#e0f2fe', color: '#0369a1', fontWeight: 600 }}>
                        Programado
                    </span>
                );
            case 'Cancelado':
                return <span className="badge-tag badge-tag--danger">Cancelado</span>;
            default:
                return <span className="badge-tag">{estado}</span>;
        }
    };

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
                                <h2>
                                    {tab === 'adopciones'
                                        ? 'Formalización de Adopciones (CU22)'
                                        : 'Agenda de Visitas de Seguimiento Post-Adopción (CU24)'}
                                </h2>
                                <p>
                                    {tab === 'adopciones'
                                        ? 'CU22: Asignación legal de mascotas a postulantes aprobados y programación automática de visitas a 30, 90 y 180 días.'
                                        : 'CU24: Consulta y registro de visitas de control domiciliario, auditoría de bienestar animal y evidencias fotográficas.'}
                                </p>
                            </div>

                            {/* Botón de acción contextual según la pestaña activa */}
                            {tab === 'adopciones' ? (
                                <button
                                    type="button"
                                    onClick={abrirModalFormalizar}
                                    className="btn-crear"
                                >
                                    <span style={{ fontSize: '16px' }}>+</span> Formalizar Adopción (CU22)
                                </button>
                            ) : (
                                <button
                                    type="button"
                                    onClick={() => setModalNuevaVisita(true)}
                                    className="btn-crear"
                                    style={{ background: '#0284c7' }}
                                >
                                    <span style={{ fontSize: '16px' }}>+</span> Programar / Registrar Visita (CU24)
                                </button>
                            )}
                        </div>
                    </section>

                    <div className="filter-tabs">
                        <button
                            type="button"
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
                            type="button"
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
                                                            type="button"
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
                        <div>
                            {/* Barra de Búsqueda y Filtros de la Agenda */}
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '12px', marginBottom: '14px' }}>
                                <div style={{ display: 'flex', gap: '8px' }}>
                                    <button
                                        type="button"
                                        onClick={() => setFiltroVisitasEstado('todos')}
                                        style={{
                                            padding: '6px 14px',
                                            borderRadius: '6px',
                                            fontSize: '12.5px',
                                            fontWeight: 600,
                                            border: '1px solid #d1d5db',
                                            backgroundColor: filtroVisitasEstado === 'todos' ? '#183d35' : '#ffffff',
                                            color: filtroVisitasEstado === 'todos' ? '#ffffff' : '#374151',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Todas ({seguimientos.length})
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setFiltroVisitasEstado('Pendiente')}
                                        style={{
                                            padding: '6px 14px',
                                            borderRadius: '6px',
                                            fontSize: '12.5px',
                                            fontWeight: 600,
                                            border: '1px solid #d1d5db',
                                            backgroundColor: filtroVisitasEstado === 'Pendiente' ? '#d97706' : '#ffffff',
                                            color: filtroVisitasEstado === 'Pendiente' ? '#ffffff' : '#374151',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Pendientes ({seguimientos.filter((s) => esVisitaPendiente(s)).length})
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setFiltroVisitasEstado('Completado')}
                                        style={{
                                            padding: '6px 14px',
                                            borderRadius: '6px',
                                            fontSize: '12.5px',
                                            fontWeight: 600,
                                            border: '1px solid #d1d5db',
                                            backgroundColor: filtroVisitasEstado === 'Completado' ? '#16a34a' : '#ffffff',
                                            color: filtroVisitasEstado === 'Completado' ? '#ffffff' : '#374151',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Completadas ({seguimientos.filter((s) => !esVisitaPendiente(s)).length})
                                    </button>
                                </div>

                                <div style={{ minWidth: '260px' }}>
                                    <input
                                        type="text"
                                        placeholder="🔍 Buscar por mascota o adoptante..."
                                        value={busquedaVisita}
                                        onChange={(e) => setBusquedaVisita(e.target.value)}
                                        style={{
                                            width: '100%',
                                            padding: '7px 12px',
                                            borderRadius: '6px',
                                            border: '1px solid #d1d5db',
                                            fontSize: '13px',
                                        }}
                                    />
                                </div>
                            </div>

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
                                                <th style={{ minWidth: '210px' }}>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {cargando ? (
                                                <tr><td colSpan={7} style={{ textAlign: 'center', padding: '28px' }}>Cargando agenda de visitas...</td></tr>
                                            ) : seguimientosFiltrados.length === 0 ? (
                                                <tr><td colSpan={7} style={{ textAlign: 'center', padding: '28px', color: '#6b7280' }}>No se encontraron visitas de seguimiento registradas.</td></tr>
                                            ) : (
                                                seguimientosFiltrados.map((s) => {
                                                    const pendiente = esVisitaPendiente(s);
                                                    return (
                                                        <tr key={s.id}>
                                                            <td><strong>#{s.id}</strong></td>
                                                            <td>
                                                                <strong style={{ color: 'var(--dashboard-forest)' }}>
                                                                    {s.adopcion?.mascota?.nombre || 'Mascota'}
                                                                </strong>
                                                                <span style={{ display: 'block', fontSize: '11.5px', color: '#4b5563' }}>
                                                                    Adoptante: {s.adopcion?.interesado?.nombre || 'Adoptante'}
                                                                    {s.adopcion?.interesado?.telefono && ` (${s.adopcion.interesado.telefono})`}
                                                                </span>
                                                            </td>
                                                            <td>{s.fecha_programada}</td>
                                                            <td>
                                                                {s.fecha_realizada && s.fecha_realizada !== 'Pendiente' ? (
                                                                    <span style={{ fontWeight: 600, color: '#16a34a' }}>{s.fecha_realizada}</span>
                                                                ) : (
                                                                    <span style={{ color: '#d97706', fontStyle: 'italic' }}>Pendiente</span>
                                                                )}
                                                            </td>
                                                            <td>{getEstadoBadge(s.estado_seguimiento)}</td>
                                                            <td style={{ maxWidth: '280px', fontSize: '12.5px', color: '#374151' }}>
                                                                {s.reporte_bienestar || 'Sin observaciones registradas'}
                                                            </td>
                                                            <td>
                                                                <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flexWrap: 'wrap' }}>
                                                                    {/* Botón 1: Consultar Visita */}
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => setVisitaAConsultar(s)}
                                                                        className="btn-action-view"
                                                                        title="Consultar detalles completos de la visita"
                                                                        style={{ padding: '4px 10px', fontSize: '12px' }}
                                                                    >
                                                                        🔍 Consultar
                                                                    </button>

                                                                    {/* Botón 2: Registrar / Completar Visita */}
                                                                    {pendiente ? (
                                                                        <button
                                                                            type="button"
                                                                            onClick={() => abrirModalCompletar(s)}
                                                                            className="btn-action-primary"
                                                                            style={{
                                                                                padding: '4px 10px',
                                                                                fontSize: '12px',
                                                                                backgroundColor: '#16a34a',
                                                                                color: '#ffffff',
                                                                                borderRadius: '5px',
                                                                                border: 'none',
                                                                                cursor: 'pointer',
                                                                                fontWeight: 600,
                                                                            }}
                                                                        >
                                                                            📝 Registrar Visita
                                                                        </button>
                                                                    ) : (
                                                                        <div style={{ display: 'inline-flex', alignItems: 'center', gap: '4px' }}>
                                                                            <span className="badge-tag badge-tag--success" style={{ fontSize: '11px', padding: '2px 6px' }}>
                                                                                ✓ Auditado OK
                                                                            </span>
                                                                            <button
                                                                                type="button"
                                                                                onClick={() => abrirModalCompletar(s)}
                                                                                className="btn-action-view"
                                                                                title="Editar o complementar observaciones"
                                                                                style={{ padding: '2px 6px', fontSize: '11px' }}
                                                                            >
                                                                                ✏️ Editar
                                                                            </button>
                                                                        </div>
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
                        </div>
                    )}

                    {/* MODAL 1: Formalizar Adopción (CU22) */}
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

                    {/* MODAL 2: Consultar Visita de Seguimiento (CU24) */}
                    {visitaAConsultar && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '26px', width: '600px', maxWidth: '95vw', borderTop: '4px solid #0284c7' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid #e5e7eb', paddingBottom: '12px', marginBottom: '16px' }}>
                                    <div>
                                        <h2 style={{ fontSize: '19px', margin: 0, color: '#0f172a' }}>
                                            Ficha de Visita de Seguimiento #{visitaAConsultar.id}
                                        </h2>
                                        <span style={{ fontSize: '12px', color: '#64748b' }}>
                                            Control y Auditoría de Bienestar Animal (CU24)
                                        </span>
                                    </div>
                                    <div>
                                        {getEstadoBadge(visitaAConsultar.estado_seguimiento)}
                                    </div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '16px' }}>
                                    <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
                                        <h4 style={{ margin: '0 0 6px 0', fontSize: '13px', color: '#0369a1' }}>🐶 Mascota en Seguimiento</h4>
                                        <p style={{ margin: '2px 0', fontSize: '13px' }}><strong>Nombre:</strong> {visitaAConsultar.adopcion?.mascota?.nombre || 'N/D'}</p>
                                        <p style={{ margin: '2px 0', fontSize: '13px' }}><strong>Especie:</strong> {visitaAConsultar.adopcion?.mascota?.especie || 'N/D'}</p>
                                        <p style={{ margin: '2px 0', fontSize: '13px' }}><strong>Raza:</strong> {visitaAConsultar.adopcion?.mascota?.raza || 'Mestizo'}</p>
                                    </div>

                                    <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
                                        <h4 style={{ margin: '0 0 6px 0', fontSize: '13px', color: '#0369a1' }}>👤 Datos del Adoptante</h4>
                                        <p style={{ margin: '2px 0', fontSize: '13px' }}><strong>Nombre:</strong> {visitaAConsultar.adopcion?.interesado?.nombre || 'N/D'}</p>
                                        <p style={{ margin: '2px 0', fontSize: '13px' }}><strong>Teléfono:</strong> {visitaAConsultar.adopcion?.interesado?.telefono || 'N/D'}</p>
                                        <p style={{ margin: '2px 0', fontSize: '13px' }}><strong>Dirección:</strong> {visitaAConsultar.adopcion?.interesado?.direccion || 'N/D'}</p>
                                    </div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '16px' }}>
                                    <div style={{ padding: '10px', backgroundColor: '#fefce8', borderRadius: '6px', border: '1px solid #fef08a' }}>
                                        <span style={{ fontSize: '11px', color: '#854d0e', fontWeight: 600, display: 'block' }}>FECHA PROGRAMADA</span>
                                        <strong style={{ fontSize: '14px', color: '#713f12' }}>{visitaAConsultar.fecha_programada}</strong>
                                    </div>
                                    <div style={{ padding: '10px', backgroundColor: '#f0fdf4', borderRadius: '6px', border: '1px solid #bbf7d0' }}>
                                        <span style={{ fontSize: '11px', color: '#166534', fontWeight: 600, display: 'block' }}>FECHA REALIZADA</span>
                                        <strong style={{ fontSize: '14px', color: '#14532d' }}>
                                            {visitaAConsultar.fecha_realizada && visitaAConsultar.fecha_realizada !== 'Pendiente' ? visitaAConsultar.fecha_realizada : 'Aún pendiente'}
                                        </strong>
                                    </div>
                                </div>

                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, color: '#334155', marginBottom: '6px' }}>
                                        Reporte de Bienestar y Condiciones de Convivencia
                                    </label>
                                    <div style={{ padding: '12px', backgroundColor: '#f1f5f9', borderRadius: '6px', fontSize: '13px', color: '#1e293b', minHeight: '60px', whiteSpace: 'pre-line' }}>
                                        {visitaAConsultar.reporte_bienestar || 'Sin observaciones registradas.'}
                                    </div>
                                </div>

                                {visitaAConsultar.fotografia && visitaAConsultar.fotografia !== '/images/default-check.png' && (
                                    <div style={{ marginBottom: '16px' }}>
                                        <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, color: '#334155', marginBottom: '6px' }}>
                                            Evidencia Fotográfica de la Visita
                                        </label>
                                        <div style={{ textAlign: 'center', backgroundColor: '#f8fafc', padding: '10px', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
                                            <img
                                                src={visitaAConsultar.fotografia}
                                                alt="Evidencia visita"
                                                style={{ maxHeight: '180px', maxWidth: '100%', objectFit: 'contain', borderRadius: '6px' }}
                                                onError={(e) => {
                                                    (e.target as HTMLElement).style.display = 'none';
                                                }}
                                            />
                                            <span style={{ display: 'block', fontSize: '11px', color: '#64748b', marginTop: '4px' }}>
                                                {visitaAConsultar.fotografia}
                                            </span>
                                        </div>
                                    </div>
                                )}

                                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '16px' }}>
                                    <button
                                        type="button"
                                        onClick={() => {
                                            const s = visitaAConsultar;
                                            setVisitaAConsultar(null);
                                            abrirModalCompletar(s);
                                        }}
                                        style={{
                                            padding: '8px 16px',
                                            borderRadius: '6px',
                                            border: 'none',
                                            backgroundColor: '#16a34a',
                                            color: 'white',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                        }}
                                    >
                                        📝 Registrar / Editar Visita
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setVisitaAConsultar(null)}
                                        style={{
                                            padding: '8px 16px',
                                            borderRadius: '6px',
                                            border: '1px solid #cbd5e1',
                                            backgroundColor: '#f8fafc',
                                            color: '#334155',
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Cerrar
                                    </button>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* MODAL 3: Registrar / Completar Visita (CU24) */}
                    {seguimientoACompletar && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '520px', maxWidth: '95vw' }}>
                                <h2 style={{ marginBottom: '8px' }}>Registrar Visita Post-Adopción (CU24)</h2>
                                <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                    Mascota: <strong style={{ color: '#15803d' }}>{seguimientoACompletar.adopcion?.mascota?.nombre}</strong> | Adoptante: <strong>{seguimientoACompletar.adopcion?.interesado?.nombre}</strong>
                                </p>
                                <form onSubmit={handleCompletarSeguimiento}>
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha Realizada</label>
                                            <input
                                                type="date"
                                                required
                                                value={formSeguimiento.fecha_realizada}
                                                onChange={(e) => setFormSeguimiento({ ...formSeguimiento, fecha_realizada: e.target.value })}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Estado / Resultado</label>
                                            <select
                                                required
                                                value={formSeguimiento.estado_seguimiento}
                                                onChange={(e) => setFormSeguimiento({ ...formSeguimiento, estado_seguimiento: e.target.value })}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            >
                                                <option value="Concluido Satisfactorio">Concluido Satisfactorio</option>
                                                <option value="Completado">Completado</option>
                                                <option value="Pendiente">Pendiente de Revisión</option>
                                                <option value="Cancelado">Cancelado</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div style={{ marginBottom: '14px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>
                                            Informe de Bienestar / Estado de la Mascota
                                        </label>
                                        <textarea
                                            required
                                            rows={4}
                                            placeholder="Describa el estado de salud, peso, higiene, alimentación, adaptación y trato familiar observado durante la visita..."
                                            value={formSeguimiento.reporte_bienestar}
                                            onChange={(e) => setFormSeguimiento({ ...formSeguimiento, reporte_bienestar: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>

                                    <div style={{ marginBottom: '16px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>
                                            Fotografía / Evidencia de Visita (URL)
                                        </label>
                                        <input
                                            type="text"
                                            placeholder="https://ejemplo.org/evidencia-visita.jpg"
                                            value={formSeguimiento.fotografia}
                                            onChange={(e) => setFormSeguimiento({ ...formSeguimiento, fotografia: e.target.value })}
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
                                            {guardando ? 'Guardando...' : 'Guardar Visita de Control'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    )}

                    {/* MODAL 4: Programar / Registrar Nueva Visita de Seguimiento (CU24) */}
                    {modalNuevaVisita && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '520px', maxWidth: '95vw' }}>
                                <h2 style={{ marginBottom: '8px' }}>Programar / Registrar Visita de Control (CU24)</h2>
                                <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                    Selecciona una adopción formalizada para agendar una nueva auditoría o registrar una visita extraordinaria de bienestar.
                                </p>
                                <form onSubmit={handleNuevaVisita}>
                                    <div style={{ marginBottom: '12px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>
                                            Adopción Formalizada (Mascota - Adoptante)
                                        </label>
                                        <select
                                            required
                                            value={formNuevaVisita.id_adopcion}
                                            onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, id_adopcion: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        >
                                            <option value="">Selecciona la adopción...</option>
                                            {adopciones.map((adop) => (
                                                <option key={adop.id} value={adop.id}>
                                                    ADOP-#{adop.id}: {adop.mascota?.nombre} ({adop.mascota?.especie}) - Adoptante: {adop.interesado?.nombre}
                                                </option>
                                            ))}
                                        </select>
                                    </div>

                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha Programada</label>
                                            <input
                                                type="date"
                                                required
                                                value={formNuevaVisita.fecha_programada}
                                                onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, fecha_programada: e.target.value })}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha Realizada (opcional)</label>
                                            <input
                                                type="date"
                                                value={formNuevaVisita.fecha_realizada}
                                                onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, fecha_realizada: e.target.value })}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            />
                                        </div>
                                    </div>

                                    <div style={{ marginBottom: '12px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Estado Inicial</label>
                                        <select
                                            required
                                            value={formNuevaVisita.estado_seguimiento}
                                            onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, estado_seguimiento: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        >
                                            <option value="Pendiente">Pendiente</option>
                                            <option value="Programado">Programado</option>
                                            <option value="Concluido Satisfactorio">Concluido Satisfactorio</option>
                                            <option value="Completado">Completado</option>
                                        </select>
                                    </div>

                                    <div style={{ marginBottom: '14px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>
                                            Observaciones / Reporte Preliminar
                                        </label>
                                        <textarea
                                            rows={3}
                                            placeholder="Detalles u objetivos de la visita de seguimiento..."
                                            value={formNuevaVisita.reporte_bienestar}
                                            onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, reporte_bienestar: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>

                                    <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                                        <button
                                            type="button"
                                            onClick={() => setModalNuevaVisita(false)}
                                            style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #d1d5db', background: 'transparent', cursor: 'pointer' }}
                                        >
                                            Cancelar
                                        </button>
                                        <button
                                            type="submit"
                                            disabled={guardando}
                                            style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#0284c7', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                        >
                                            {guardando ? 'Programando...' : 'Guardar Visita'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    )}

                    {/* MODAL 5: Acta Digital (CU22) */}
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
                                        type="button"
                                        onClick={() => window.print()}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: '1px solid #16a34a', color: '#16a34a', background: 'transparent', cursor: 'pointer' }}
                                    >
                                        Imprimir / Guardar PDF
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setActaDigital(null)}
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
