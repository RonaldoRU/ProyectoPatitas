/**
 * Vista de Formalización de Adopciones y Visitas Post-Adopción (P03 - CU22 & CU23):
 * - Formaliza la adopción de mascotas disponibles con postulantes previamente aprobados.
 * - Programa automáticamente visitas de control y seguimiento a los 30, 90 y 180 días.
 * - Permite emitir e imprimir el Acta Legal de Adopción y subir fotografías tomadas del animal durante la visita realizada.
 */
import { Head } from '@inertiajs/react';
import React, { useEffect, useState } from 'react';
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
    telefono?: string;
    puntaje_evaluacion?: string | number;
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

interface ImagenPreview {
    file: File;
    previewUrl: string;
    nombre: string;
}

function extraerListaImagenes(fotografia?: string | null): string[] {
    if (!fotografia || fotografia.trim() === '' || fotografia === '/images/default-check.png') {
        return [];
    }
    return fotografia
        .split('|')
        .map((u) => u.trim())
        .filter((u) => u.length > 0 && u !== '/images/default-check.png');
}

export default function Adopciones() {
    const [tab, setTab] = useState<'adopciones' | 'seguimientos'>('adopciones');
    const [adopciones, setAdopciones] = useState<Adopcion[]>([]);
    const [seguimientos, setSeguimientos] = useState<Seguimiento[]>([]);
    const [cargando, setCargando] = useState(true);

    // Filtros de visitas
    const [filtroVisitasEstado, setFiltroVisitasEstado] = useState<string>('todos');
    const [busquedaVisita, setBusquedaVisita] = useState<string>('');

    // Modal Formalizar Adopción
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

    // Modal Consultar Visita
    const [visitaAConsultar, setVisitaAConsultar] = useState<Seguimiento | null>(null);

    // Modal Registrar / Completar Visita
    const [seguimientoACompletar, setSeguimientoACompletar] = useState<Seguimiento | null>(null);
    const [formSeguimiento, setFormSeguimiento] = useState({
        fecha_realizada: new Date().toISOString().split('T')[0],
        reporte_bienestar: '',
        fotografia: '',
        estado_seguimiento: 'Concluido Satisfactorio',
    });
    const [archivosSeguimiento, setArchivosSeguimiento] = useState<ImagenPreview[]>([]);
    const [imagenesExistentesSeguimiento, setImagenesExistentesSeguimiento] = useState<string[]>([]);

    // Modal Programar / Nueva Visita
    const [modalNuevaVisita, setModalNuevaVisita] = useState(false);
    const [formNuevaVisita, setFormNuevaVisita] = useState({
        id_adopcion: '',
        fecha_programada: new Date().toISOString().split('T')[0],
        fecha_realizada: '',
        estado_seguimiento: 'Pendiente',
        reporte_bienestar: '',
        fotografia: '',
    });
    const [archivosNuevaVisita, setArchivosNuevaVisita] = useState<ImagenPreview[]>([]);

    const [guardando, setGuardando] = useState(false);
    const [mensajeExito, setMensajeExito] = useState<string>('');
    const [mensajeError, setMensajeError] = useState<string>('');

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
                if (Array.isArray(data.postulantes_aprobados)) {
                    setPostulantesAprobados(data.postulantes_aprobados);
                }
                if (Array.isArray(data.mascotas_disponibles)) {
                    setMascotasDisponibles(data.mascotas_disponibles);
                }
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
        setModalFormalizar(true);
        setMensajeError('');
        try {
            const [resAdop, resPost, resMasc] = await Promise.all([
                fetch('/api/adopciones', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
                fetch('/api/postulantes', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
                fetch('/api/mascotas', { headers: { Accept: 'application/json', Authorization: `Bearer ${token}` } }),
            ]);

            if (resAdop.ok) {
                const dataAdop = await resAdop.json();
                if (Array.isArray(dataAdop.postulantes_aprobados) && dataAdop.postulantes_aprobados.length > 0) {
                    setPostulantesAprobados(dataAdop.postulantes_aprobados);
                }
                if (Array.isArray(dataAdop.mascotas_disponibles) && dataAdop.mascotas_disponibles.length > 0) {
                    setMascotasDisponibles(dataAdop.mascotas_disponibles);
                }
            }

            if (resPost.ok) {
                const data = await resPost.json();
                const aprobados = (data.postulantes || []).filter(
                    (p: any) => String(p.estado || '').trim().toLowerCase() === 'aprobado'
                );
                if (aprobados.length > 0) {
                    setPostulantesAprobados(aprobados);
                }
            }
            if (resMasc.ok) {
                const data = await resMasc.json();
                const disponibles = (data.mascotas || []).filter((m: any) =>
                    String(m.estado_actual || '').toLowerCase().includes('disponible')
                );
                if (disponibles.length > 0) {
                    setMascotasDisponibles(disponibles);
                }
            }
        } catch (error) {
            console.error('Error abriendo formalización:', error);
        }
    };

    const handleFormalizar = async (e: React.FormEvent) => {
        e.preventDefault();
        setGuardando(true);
        setMensajeError('');
        setMensajeExito('');
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
                setMensajeExito('Adopción formalizada con éxito y 3 visitas de control programadas (30, 90 y 180 días).');
            } else {
                const err = await res.json();
                setMensajeError(err.message || 'Error formalizando adopción.');
            }
        } catch (error) {
            console.error('Error formalizando:', error);
            setMensajeError('No se pudo conectar con el servidor al formalizar la adopción.');
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

    const handleSeleccionarArchivosSeguimiento = (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files;
        if (!files || files.length === 0) return;

        const nuevos: ImagenPreview[] = [];
        Array.from(files).forEach((file) => {
            if (file.type.startsWith('image/')) {
                nuevos.push({
                    file,
                    previewUrl: URL.createObjectURL(file),
                    nombre: file.name,
                });
            }
        });

        setArchivosSeguimiento((prev) => [...prev, ...nuevos]);
        e.target.value = '';
    };

    const eliminarArchivoSeguimiento = (index: number) => {
        setArchivosSeguimiento((prev) => {
            const copia = [...prev];
            if (copia[index]) {
                URL.revokeObjectURL(copia[index].previewUrl);
            }
            copia.splice(index, 1);
            return copia;
        });
    };

    const eliminarImagenExistenteSeguimiento = (index: number) => {
        setImagenesExistentesSeguimiento((prev) => prev.filter((_, idx) => idx !== index));
    };

    const handleSeleccionarArchivosNuevaVisita = (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files;
        if (!files || files.length === 0) return;

        const nuevos: ImagenPreview[] = [];
        Array.from(files).forEach((file) => {
            if (file.type.startsWith('image/')) {
                nuevos.push({
                    file,
                    previewUrl: URL.createObjectURL(file),
                    nombre: file.name,
                });
            }
        });

        setArchivosNuevaVisita((prev) => [...prev, ...nuevos]);
        e.target.value = '';
    };

    const eliminarArchivoNuevaVisita = (index: number) => {
        setArchivosNuevaVisita((prev) => {
            const copia = [...prev];
            if (copia[index]) {
                URL.revokeObjectURL(copia[index].previewUrl);
            }
            copia.splice(index, 1);
            return copia;
        });
    };

    const abrirModalCompletar = (s: Seguimiento) => {
        setMensajeError('');
        setSeguimientoACompletar(s);
        const existentes = extraerListaImagenes(s.fotografia);
        setImagenesExistentesSeguimiento(existentes);
        setArchivosSeguimiento([]);
        setFormSeguimiento({
            fecha_realizada:
                s.fecha_realizada && s.fecha_realizada !== 'Pendiente'
                    ? s.fecha_realizada
                    : new Date().toISOString().split('T')[0],
            reporte_bienestar:
                s.reporte_bienestar === 'Sin observaciones registradas' ? '' : s.reporte_bienestar || '',
            fotografia: '',
            estado_seguimiento:
                s.estado_seguimiento === 'Pendiente' || s.estado_seguimiento === 'Programado'
                    ? 'Concluido Satisfactorio'
                    : s.estado_seguimiento,
        });
    };

    const handleCompletarSeguimiento = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!seguimientoACompletar) return;

        setGuardando(true);
        setMensajeError('');
        setMensajeExito('');
        try {
            const formData = new FormData();
            formData.append('fecha_realizada', formSeguimiento.fecha_realizada);
            formData.append('reporte_bienestar', formSeguimiento.reporte_bienestar);
            formData.append('estado_seguimiento', formSeguimiento.estado_seguimiento);

            // Combinar imágenes existentes conservadas y URL adicional opcional
            const urlsConservadas = [...imagenesExistentesSeguimiento];
            if (formSeguimiento.fotografia.trim() !== '') {
                urlsConservadas.push(formSeguimiento.fotografia.trim());
            }
            if (urlsConservadas.length > 0) {
                formData.append('fotografia', urlsConservadas.join('|'));
            }

            // Adjuntar archivos de imagen tomados durante la visita
            archivosSeguimiento.forEach((item) => {
                formData.append('imagenes[]', item.file);
            });

            const res = await fetch(`/api/seguimientos/${seguimientoACompletar.id}`, {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: formData,
            });

            if (res.ok) {
                archivosSeguimiento.forEach((item) => URL.revokeObjectURL(item.previewUrl));
                setArchivosSeguimiento([]);
                setSeguimientoACompletar(null);
                await cargarDatos();
                setMensajeExito('Visita de seguimiento e imágenes del animal registradas exitosamente.');
            } else {
                const err = await res.json();
                setMensajeError(err.message || 'Error registrando visita de seguimiento.');
            }
        } catch (error) {
            console.error('Error registrando seguimiento:', error);
            setMensajeError('Error de red al guardar la visita de seguimiento.');
        } finally {
            setGuardando(false);
        }
    };

    const handleNuevaVisita = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!formNuevaVisita.id_adopcion) {
            setMensajeError('Por favor selecciona una adopción formalizada.');
            return;
        }

        setGuardando(true);
        setMensajeError('');
        setMensajeExito('');
        try {
            const formData = new FormData();
            formData.append('id_adopcion', formNuevaVisita.id_adopcion);
            formData.append('fecha_programada', formNuevaVisita.fecha_programada);
            if (formNuevaVisita.fecha_realizada) {
                formData.append('fecha_realizada', formNuevaVisita.fecha_realizada);
            }
            formData.append('estado_seguimiento', formNuevaVisita.estado_seguimiento);
            formData.append('reporte_bienestar', formNuevaVisita.reporte_bienestar || 'Visita de control programada.');
            if (formNuevaVisita.fotografia.trim() !== '') {
                formData.append('fotografia', formNuevaVisita.fotografia.trim());
            }

            archivosNuevaVisita.forEach((item) => {
                formData.append('imagenes[]', item.file);
            });

            const res = await fetch('/api/seguimientos', {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    Authorization: `Bearer ${token}`,
                },
                body: formData,
            });
            if (res.ok) {
                archivosNuevaVisita.forEach((item) => URL.revokeObjectURL(item.previewUrl));
                setArchivosNuevaVisita([]);
                setModalNuevaVisita(false);
                setFormNuevaVisita({
                    id_adopcion: '',
                    fecha_programada: new Date().toISOString().split('T')[0],
                    fecha_realizada: '',
                    estado_seguimiento: 'Pendiente',
                    reporte_bienestar: '',
                    fotografia: '',
                });
                await cargarDatos();
                setMensajeExito('Visita de control e imágenes registradas con éxito.');
            } else {
                const err = await res.json();
                setMensajeError(err.message || 'Error programando visita.');
            }
        } catch (error) {
            console.error('Error al programar visita:', error);
            setMensajeError('Error de red al programar la visita.');
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

    const imprimirActaOficialPDF = () => {
        if (!actaDigital) return;
        const printWin = window.open('', '_blank');
        if (!printWin) return;

        printWin.document.write(`
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>Acta Oficial de Adopción - ${actaDigital.numero_acta}</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 40px; color: #1f2937; line-height: 1.6; max-width: 750px; margin: 0 auto; }
                    .header { text-align: center; border-bottom: 2px solid #16a34a; padding-bottom: 15px; margin-bottom: 25px; }
                    .title { color: #16a34a; margin: 0; font-size: 22px; font-weight: bold; }
                    .sub { color: #6b7280; font-size: 12px; margin-top: 4px; }
                    .acta-no { font-size: 14px; font-weight: bold; color: #1f2937; margin-top: 6px; }
                    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; background-color: #f9fafb; border: 1px solid #e5e7eb; border-radius: 8px; padding: 18px; margin-bottom: 20px; }
                    .grid h4 { margin: 0 0 10px 0; color: #16a34a; font-size: 14px; border-bottom: 1px solid #d1d5db; padding-bottom: 4px; }
                    .grid p { margin: 4px 0; font-size: 13px; }
                    .clauses { background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 16px; margin-bottom: 30px; font-size: 12px; color: #14532d; }
                    .clauses h4 { margin: 0 0 8px 0; font-size: 13px; }
                    .clauses ol { margin: 0; padding-left: 18px; }
                    .clauses li { margin-bottom: 6px; }
                    .signatures { display: flex; justify-content: space-between; margin-top: 60px; padding-top: 20px; }
                    .sign-box { width: 220px; border-top: 1px solid #64748b; text-align: center; font-size: 11px; color: #475569; padding-top: 6px; }
                    @media print { .no-print { display: none; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="margin-bottom: 20px; display: flex; gap: 10px;">
                    <button onclick="window.print()" style="padding: 10px 20px; background-color: #16a34a; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Imprimir Acta Oficial / Guardar PDF</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background-color: #e2e8f0; border: none; border-radius: 6px; cursor: pointer;">Cerrar</button>
                </div>
                <div class="header">
                    <h1 class="title">ACTA INSTITUCIONAL DE ADOPCIÓN RESPONSABLE</h1>
                    <div class="sub">ALBERGUE Y CENTRO DE RESCATE "LOS ANGELITOS DE EDGAR"</div>
                    <div class="sub">NIT: 4892019018 • Personería Jurídica N° 342/2021 • Santa Cruz, Bolivia</div>
                    <div class="acta-no">${actaDigital.numero_acta} • FECHA: ${actaDigital.fecha}</div>
                </div>

                <div class="grid">
                    <div>
                        <h4>Datos del Adoptante Responsable</h4>
                        <p><strong>Nombre Completo:</strong> ${actaDigital.adoptante?.nombre || 'N/A'}</p>
                        <p><strong>Cédula de Identidad:</strong> ${actaDigital.adoptante?.ci || 'N/A'}</p>
                        <p><strong>Teléfono de Contacto:</strong> ${actaDigital.adoptante?.telefono || 'N/A'}</p>
                        <p><strong>Dirección de Residencia:</strong> ${actaDigital.adoptante?.direccion || 'N/A'}</p>
                    </div>
                    <div>
                        <h4>Datos del Animal de Compañía</h4>
                        <p><strong>Nombre del Paciente:</strong> ${actaDigital.mascota?.nombre || 'N/A'}</p>
                        <p><strong>Especie / Sexo:</strong> ${actaDigital.mascota?.especie || 'Canino'} • ${actaDigital.mascota?.sexo || 'N/A'}</p>
                        <p><strong>Raza / Rasgos:</strong> ${actaDigital.mascota?.raza || 'Mestizo'}</p>
                        <p><strong>Estado Clínico:</strong> Esterilizado, vacunado y desparasitado</p>
                    </div>
                </div>

                <div class="clauses">
                    <h4>Términos y Compromisos Legales (Ley N° 700 de Defensa de los Animales)</h4>
                    <ol>
                        <li><strong>Guarda y Custodia Responsable:</strong> El adoptante asume de forma indivisible la provisión de alimentación adecuada, cobijo digno y bienestar biopsicosocial del animal.</li>
                        <li><strong>Atención Veterinaria Obligatoria:</strong> Garantizar el cumplimiento anual del esquema de inmunización (antirrábica y múltiple) y desparasitaciones periódicas.</li>
                        <li><strong>Prohibición Absoluta de Abandono o Traspaso:</strong> En caso de fuerza mayor que imposibilite la tenencia, el animal será retornado con exclusividad a este albergue. Queda prohibida su venta o cesión a terceros.</li>
                        <li><strong>Programa de Seguimiento Post-Adopción:</strong> El adoptante autoriza y se compromete a recibir las visitas de seguimiento a los 30, 90 y 180 días de formalizada la adopción.</li>
                    </ol>
                </div>

                <div class="signatures">
                    <div class="sign-box">
                        <strong>Firma y Huella del Adoptante</strong><br>
                        C.I. ${actaDigital.adoptante?.ci || '........................'}
                    </div>
                    <div class="sign-box">
                        <strong>Dirección del Albergue</strong><br>
                        Los Angelitos de Edgar
                    </div>
                </div>
            </body>
            </html>
        `);
        printWin.document.close();
    };

    return (
        <div className="dashboard-app">
            <Head title="Formalización de Adopciones y Control Post-Adopción - Los Angelitos" />

            <main className="dashboard-main">
                <DashboardTopNav title="Formalización y Visitas" />

                <div className="dashboard-content">
                    <section className="dashboard-intro">
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '16px' }}>
                            <div>
                                <p className="dashboard-eyebrow">GESTIÓN INTEGRAL DE ADOPCIONES</p>
                                <h2>
                                    {tab === 'adopciones'
                                        ? 'Formalización de Adopciones'
                                        : 'Agenda de Visitas de Seguimiento Post-Adopción'}
                                </h2>
                                <p>
                                    {tab === 'adopciones'
                                        ? 'Asignación legal de mascotas a postulantes aprobados y programación automática de visitas a 30, 90 y 180 días.'
                                        : 'Consulta y registro de visitas de control domiciliario, auditoría de bienestar animal y subida de fotografías de la visita.'}
                                </p>
                            </div>

                            {/* Botón de acción contextual según la pestaña activa */}
                            {tab === 'adopciones' ? (
                                <button
                                    type="button"
                                    onClick={abrirModalFormalizar}
                                    className="btn-crear"
                                >
                                    <span style={{ fontSize: '16px' }}>+</span> Formalizar Adopción
                                </button>
                            ) : (
                                <button
                                    type="button"
                                    onClick={() => {
                                        setMensajeError('');
                                        setModalNuevaVisita(true);
                                    }}
                                    className="btn-crear"
                                    style={{ background: '#183d35' }}
                                >
                                    <span style={{ fontSize: '16px' }}>+</span> Programar / Registrar Visita
                                </button>
                            )}
                        </div>
                    </section>

                    {mensajeExito && (
                        <div
                            style={{
                                marginBottom: '16px',
                                padding: '12px 16px',
                                backgroundColor: '#dcfce7',
                                border: '1px solid #86efac',
                                color: '#166534',
                                borderRadius: '8px',
                                fontSize: '13.5px',
                                fontWeight: 600,
                                display: 'flex',
                                justifyContent: 'space-between',
                                alignItems: 'center',
                            }}
                        >
                            <span>{mensajeExito}</span>
                            <button
                                type="button"
                                onClick={() => setMensajeExito('')}
                                style={{ background: 'none', border: 'none', color: '#166534', cursor: 'pointer', fontWeight: 700 }}
                            >
                                ✕
                            </button>
                        </div>
                    )}

                    {mensajeError && (
                        <div
                            style={{
                                marginBottom: '16px',
                                padding: '12px 16px',
                                backgroundColor: '#fee2e2',
                                border: '1px solid #fca5a5',
                                color: '#991b1b',
                                borderRadius: '8px',
                                fontSize: '13.5px',
                                fontWeight: 600,
                                display: 'flex',
                                justifyContent: 'space-between',
                                alignItems: 'center',
                            }}
                        >
                            <span>{mensajeError}</span>
                            <button
                                type="button"
                                onClick={() => setMensajeError('')}
                                style={{ background: 'none', border: 'none', color: '#991b1b', cursor: 'pointer', fontWeight: 700 }}
                            >
                                ✕
                            </button>
                        </div>
                    )}

                    <div className="filter-tabs">
                        <button
                            type="button"
                            onClick={() => setTab('adopciones')}
                            className={`filter-btn ${tab === 'adopciones' ? 'active' : ''}`}
                        >
                            <span>Adopciones Formalizadas</span>
                            <span
                                style={{
                                    padding: '2px 7px',
                                    borderRadius: '10px',
                                    fontSize: '11px',
                                    backgroundColor: tab === 'adopciones' ? '#e1e89f' : '#edf1e9',
                                    color: tab === 'adopciones' ? '#183d35' : '#65736d',
                                    fontWeight: 800,
                                }}
                            >
                                {adopciones.length}
                            </span>
                        </button>
                        <button
                            type="button"
                            onClick={() => setTab('seguimientos')}
                            className={`filter-btn ${tab === 'seguimientos' ? 'active' : ''}`}
                        >
                            <span>Agenda de Visitas de Seguimiento</span>
                            <span
                                style={{
                                    padding: '2px 7px',
                                    borderRadius: '10px',
                                    fontSize: '11px',
                                    backgroundColor: tab === 'seguimientos' ? '#e1e89f' : '#edf1e9',
                                    color: tab === 'seguimientos' ? '#183d35' : '#65736d',
                                    fontWeight: 800,
                                }}
                            >
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
                                            <tr>
                                                <td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>
                                                    Cargando adopciones registradas...
                                                </td>
                                            </tr>
                                        ) : adopciones.length === 0 ? (
                                            <tr>
                                                <td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: 'var(--dashboard-muted)' }}>
                                                    No hay adopciones formalizadas todavía.
                                                </td>
                                            </tr>
                                        ) : (
                                            adopciones.map((a) => (
                                                <tr key={a.id}>
                                                    <td>
                                                        <strong style={{ color: 'var(--dashboard-forest)', letterSpacing: '0.04em' }}>ADOP-#{a.id}</strong>
                                                    </td>
                                                    <td>{a.fecha_adopcion}</td>
                                                    <td>
                                                        <strong style={{ color: 'var(--dashboard-ink)' }}>{a.interesado?.nombre}</strong>
                                                        <span style={{ display: 'block', fontSize: '11px', color: 'var(--dashboard-muted)' }}>
                                                            CI: {a.interesado?.ci}
                                                        </span>
                                                    </td>
                                                    <td>{a.interesado?.telefono}</td>
                                                    <td>
                                                        <span style={{ color: 'var(--dashboard-forest)', fontWeight: 700 }}>{a.mascota?.nombre}</span>{' '}
                                                        <span style={{ color: 'var(--dashboard-muted)', fontSize: '11.5px' }}>
                                                            ({a.mascota?.especie} • {a.mascota?.raza || 'Mestizo'})
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button
                                                            type="button"
                                                            onClick={() => verActa(a.id)}
                                                            className="btn-action-view"
                                                        >
                                                            Emitir Acta Digital (PDF)
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
                                        placeholder="Buscar por mascota o adoptante..."
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
                                                <th>Fotos de la Visita</th>
                                                <th>Reporte de Bienestar</th>
                                                <th style={{ minWidth: '210px' }}>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {cargando ? (
                                                <tr>
                                                    <td colSpan={8} style={{ textAlign: 'center', padding: '28px' }}>
                                                        Cargando agenda de visitas...
                                                    </td>
                                                </tr>
                                            ) : seguimientosFiltrados.length === 0 ? (
                                                <tr>
                                                    <td colSpan={8} style={{ textAlign: 'center', padding: '28px', color: '#6b7280' }}>
                                                        No se encontraron visitas de seguimiento registradas.
                                                    </td>
                                                </tr>
                                            ) : (
                                                seguimientosFiltrados.map((s) => {
                                                    const pendiente = esVisitaPendiente(s);
                                                    const fotosVisita = extraerListaImagenes(s.fotografia);
                                                    const fotoMascotaFallback = s.adopcion?.mascota?.foto;

                                                    return (
                                                        <tr key={s.id}>
                                                            <td>
                                                                <strong>#{s.id}</strong>
                                                            </td>
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
                                                            <td>
                                                                {fotosVisita.length > 0 ? (
                                                                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                                                                        <img
                                                                            src={fotosVisita[0]}
                                                                            alt="Evidencia visita"
                                                                            onClick={() => setVisitaAConsultar(s)}
                                                                            style={{
                                                                                width: '44px',
                                                                                height: '44px',
                                                                                objectFit: 'cover',
                                                                                borderRadius: '8px',
                                                                                border: '2px solid #16a34a',
                                                                                cursor: 'pointer',
                                                                            }}
                                                                        />
                                                                        {fotosVisita.length > 1 && (
                                                                            <span
                                                                                style={{
                                                                                    fontSize: '11px',
                                                                                    fontWeight: 700,
                                                                                    color: '#0d6e4f',
                                                                                    backgroundColor: '#dcfce7',
                                                                                    padding: '2px 6px',
                                                                                    borderRadius: '99px',
                                                                                }}
                                                                            >
                                                                                +{fotosVisita.length - 1}
                                                                            </span>
                                                                        )}
                                                                    </div>
                                                                ) : fotoMascotaFallback ? (
                                                                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                                                                        <img
                                                                            src={fotoMascotaFallback}
                                                                            alt="Mascota"
                                                                            style={{
                                                                                width: '38px',
                                                                                height: '38px',
                                                                                objectFit: 'cover',
                                                                                borderRadius: '8px',
                                                                                opacity: 0.65,
                                                                                border: '1px dashed #94a3b8',
                                                                            }}
                                                                        />
                                                                        <span style={{ fontSize: '11px', color: '#64748b' }}>Sin foto de visita</span>
                                                                    </div>
                                                                ) : (
                                                                    <span style={{ fontSize: '11.5px', color: '#94a3b8' }}>Sin fotos subidas</span>
                                                                )}
                                                            </td>
                                                            <td style={{ maxWidth: '260px', fontSize: '12.5px', color: '#374151' }}>
                                                                {s.reporte_bienestar || 'Sin observaciones registradas'}
                                                            </td>
                                                            <td>
                                                                <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flexWrap: 'wrap' }}>
                                                                    {/* Botón 1: Consultar Visita */}
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => setVisitaAConsultar(s)}
                                                                        className="btn-action-view"
                                                                        title="Consultar detalles completos y fotografías de la visita"
                                                                        style={{ padding: '4px 10px', fontSize: '12px' }}
                                                                    >
                                                                        Consultar
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
                                                                                backgroundColor: '#183d35',
                                                                                color: '#ffffff',
                                                                                borderRadius: '5px',
                                                                                border: 'none',
                                                                                cursor: 'pointer',
                                                                                fontWeight: 600,
                                                                            }}
                                                                        >
                                                                            Registrar Visita
                                                                        </button>
                                                                    ) : (
                                                                        <div style={{ display: 'inline-flex', alignItems: 'center', gap: '4px' }}>
                                                                            <span className="badge-tag badge-tag--success" style={{ fontSize: '11px', padding: '2px 6px' }}>
                                                                                Auditado OK
                                                                            </span>
                                                                            <button
                                                                                type="button"
                                                                                onClick={() => abrirModalCompletar(s)}
                                                                                className="btn-action-view"
                                                                                title="Editar o subir nuevas fotos de la visita"
                                                                                style={{ padding: '2px 6px', fontSize: '11px' }}
                                                                            >
                                                                                Editar / Fotos
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

                    {/* MODAL 1: Formalizar Adopción */}
                    {modalFormalizar && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '500px', maxWidth: '95vw' }}>
                                <h2 style={{ marginBottom: '12px' }}>Formalizar Adopción</h2>
                                <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                    Al formalizar, el estado de la mascota cambiará a <strong>Adoptado</strong> y el sistema programará automáticamente las visitas de control a los <strong>30, 90 y 180 días</strong>.
                                </p>
                                <form onSubmit={handleFormalizar}>
                                    <div style={{ marginBottom: '12px' }}>
                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                                            <label style={{ fontSize: '13px', fontWeight: 600 }}>Adoptante Aprobado</label>
                                            <span style={{ fontSize: '11.5px', fontWeight: 700, color: '#0d6e4f', backgroundColor: '#dcfce7', padding: '2px 8px', borderRadius: '99px' }}>
                                                {postulantesAprobados.length} aprobados disponibles
                                            </span>
                                        </div>
                                        <select
                                            required
                                            value={formAdopcion.id_interesado}
                                            onChange={(e) => setFormAdopcion({ ...formAdopcion, id_interesado: e.target.value })}
                                            style={{ width: '100%', padding: '9px', border: '1px solid #d1d5db', borderRadius: '6px', fontSize: '13px' }}
                                        >
                                            <option value="">
                                                Selecciona un postulante aprobado ({postulantesAprobados.length} disponibles)...
                                            </option>
                                            {postulantesAprobados.map((p) => (
                                                <option key={p.id} value={p.id}>
                                                    {p.nombre} — CI: {p.ci} {p.puntaje_evaluacion ? `(${p.puntaje_evaluacion} pts - Aprobado)` : '(Aprobado)'}
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

                    {/* MODAL 2: Consultar Visita de Seguimiento */}
                    {visitaAConsultar && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000, padding: '16px' }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '26px', width: '640px', maxWidth: '95vw', maxHeight: '90vh', overflowY: 'auto', borderTop: '4px solid #183d35' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid #e5e7eb', paddingBottom: '12px', marginBottom: '16px' }}>
                                    <div>
                                        <h2 style={{ fontSize: '19px', margin: 0, color: '#0f172a' }}>
                                            Ficha de Visita de Seguimiento #{visitaAConsultar.id}
                                        </h2>
                                        <span style={{ fontSize: '12px', color: '#64748b' }}>
                                            Control y Auditoría Fotográfica de Bienestar Animal
                                        </span>
                                    </div>
                                    <div>{getEstadoBadge(visitaAConsultar.estado_seguimiento)}</div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '16px' }}>
                                    <div style={{ backgroundColor: '#ffffff', padding: '12px', borderRadius: '8px', border: '1px solid #dde1e4' }}>
                                        <h4 style={{ margin: '0 0 6px 0', fontSize: '13px', color: '#12354a' }}>Mascota en Seguimiento</h4>
                                        <p style={{ margin: '2px 0', fontSize: '13.5px' }}>
                                            <strong>Nombre:</strong> {visitaAConsultar.adopcion?.mascota?.nombre || 'N/D'}
                                        </p>
                                        <p style={{ margin: '2px 0', fontSize: '13.5px' }}>
                                            <strong>Especie:</strong> {visitaAConsultar.adopcion?.mascota?.especie || 'N/D'}
                                        </p>
                                        <p style={{ margin: '2px 0', fontSize: '13.5px' }}>
                                            <strong>Raza:</strong> {visitaAConsultar.adopcion?.mascota?.raza || 'Mestizo'}
                                        </p>
                                    </div>

                                    <div style={{ backgroundColor: '#ffffff', padding: '12px', borderRadius: '8px', border: '1px solid #dde1e4' }}>
                                        <h4 style={{ margin: '0 0 6px 0', fontSize: '13px', color: '#12354a' }}>Datos del Adoptante</h4>
                                        <p style={{ margin: '2px 0', fontSize: '13.5px' }}>
                                            <strong>Nombre:</strong> {visitaAConsultar.adopcion?.interesado?.nombre || 'N/D'}
                                        </p>
                                        <p style={{ margin: '2px 0', fontSize: '13.5px' }}>
                                            <strong>Teléfono:</strong> {visitaAConsultar.adopcion?.interesado?.telefono || 'N/D'}
                                        </p>
                                        <p style={{ margin: '2px 0', fontSize: '13.5px' }}>
                                            <strong>Dirección:</strong> {visitaAConsultar.adopcion?.interesado?.direccion || 'N/D'}
                                        </p>
                                    </div>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '16px' }}>
                                    <div style={{ padding: '10px', backgroundColor: '#ffffff', borderRadius: '6px', border: '1px solid #dde1e4' }}>
                                        <span style={{ fontSize: '11px', color: '#526068', fontWeight: 700, display: 'block', letterSpacing: '0.05em' }}>FECHA PROGRAMADA</span>
                                        <strong style={{ fontSize: '14px', color: '#12354a', fontFamily: 'var(--font-mono)' }}>{visitaAConsultar.fecha_programada}</strong>
                                    </div>
                                    <div style={{ padding: '10px', backgroundColor: '#ffffff', borderRadius: '6px', border: '1px solid #dde1e4' }}>
                                        <span style={{ fontSize: '11px', color: '#526068', fontWeight: 700, display: 'block', letterSpacing: '0.05em' }}>FECHA REALIZADA</span>
                                        <strong style={{ fontSize: '14px', color: '#165b4c', fontFamily: 'var(--font-mono)' }}>
                                            {visitaAConsultar.fecha_realizada && visitaAConsultar.fecha_realizada !== 'Pendiente'
                                                ? visitaAConsultar.fecha_realizada
                                                : 'Aún pendiente'}
                                        </strong>
                                    </div>
                                </div>

                                <div style={{ marginBottom: '16px' }}>
                                    <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, color: '#12354a', marginBottom: '6px' }}>
                                        Reporte de Bienestar y Condiciones de Convivencia
                                    </label>
                                    <div style={{ padding: '12px', backgroundColor: '#ffffff', border: '1px solid #dde1e4', borderRadius: '6px', fontSize: '14px', color: '#16262e', minHeight: '60px', whiteSpace: 'pre-line' }}>
                                        {visitaAConsultar.reporte_bienestar || 'Sin observaciones registradas.'}
                                    </div>
                                </div>

                                {(() => {
                                    const fotos = extraerListaImagenes(visitaAConsultar.fotografia);
                                    return (
                                        <div style={{ marginBottom: '16px' }}>
                                            <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 700, color: '#334155', marginBottom: '6px' }}>
                                                Fotografías del Animal en la Visita Realizada ({fotos.length})
                                            </label>
                                            {fotos.length > 0 ? (
                                                <div
                                                    style={{
                                                        display: 'grid',
                                                        gridTemplateColumns: 'repeat(auto-fill, minmax(160px, 1fr))',
                                                        gap: '10px',
                                                        backgroundColor: '#f8fafc',
                                                        padding: '12px',
                                                        borderRadius: '8px',
                                                        border: '1px solid #e2e8f0',
                                                    }}
                                                >
                                                    {fotos.map((url, idx) => (
                                                        <a
                                                            key={idx}
                                                            href={url}
                                                            target="_blank"
                                                            rel="noopener noreferrer"
                                                            style={{
                                                                display: 'block',
                                                                borderRadius: '8px',
                                                                overflow: 'hidden',
                                                                border: '1px solid #cbd5e1',
                                                                backgroundColor: '#ffffff',
                                                                textDecoration: 'none',
                                                            }}
                                                        >
                                                            <img
                                                                src={url}
                                                                alt={`Evidencia visita #${idx + 1}`}
                                                                style={{ width: '100%', height: '140px', objectFit: 'cover', display: 'block' }}
                                                            />
                                                            <span
                                                                style={{
                                                                    display: 'block',
                                                                    padding: '4px 8px',
                                                                    fontSize: '11px',
                                                                    color: '#0d6e4f',
                                                                    fontWeight: 600,
                                                                    textAlign: 'center',
                                                                }}
                                                            >
                                                                Ver fotografía #{idx + 1}
                                                            </span>
                                                        </a>
                                                    ))}
                                                </div>
                                            ) : (
                                                <div
                                                    style={{
                                                        padding: '14px',
                                                        backgroundColor: '#f8fafc',
                                                        borderRadius: '8px',
                                                        border: '1px dashed #cbd5e1',
                                                        textAlign: 'center',
                                                        fontSize: '12.5px',
                                                        color: '#64748b',
                                                    }}
                                                >
                                                    Aún no se han subido imágenes del animal para esta visita. Haz clic en <strong>Registrar / Editar Visita</strong> para subir las fotos tomadas.
                                                </div>
                                            )}
                                        </div>
                                    );
                                })()}

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
                                            backgroundColor: '#183d35',
                                            color: 'white',
                                            fontWeight: 600,
                                            cursor: 'pointer',
                                        }}
                                    >
                                        Registrar / Subir Fotos de la Visita
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

                    {/* MODAL 3: Registrar / Completar Visita con Subida de Imágenes */}
                    {seguimientoACompletar && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000, padding: '16px' }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '580px', maxWidth: '95vw', maxHeight: '92vh', overflowY: 'auto' }}>
                                <h2 style={{ marginBottom: '6px', color: '#0f172a' }}>Registrar Visita Post-Adopción</h2>
                                <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                    Mascota: <strong style={{ color: '#183d35' }}>{seguimientoACompletar.adopcion?.mascota?.nombre}</strong> ({seguimientoACompletar.adopcion?.mascota?.raza || seguimientoACompletar.adopcion?.mascota?.especie}) | Adoptante: <strong>{seguimientoACompletar.adopcion?.interesado?.nombre}</strong>
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
                                                <option value="Programado">Programado</option>
                                                <option value="Pendiente">Pendiente de Revisión</option>
                                                <option value="Alerta">Alerta de Bienestar</option>
                                                <option value="Cancelado">Cancelado</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div style={{ marginBottom: '14px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>
                                            Informe de Bienestar / Estado del Animal en la Visita
                                        </label>
                                        <textarea
                                            required
                                            rows={3}
                                            placeholder="Describa el estado de salud, peso, higiene, alimentación, adaptación y trato familiar observado durante la visita..."
                                            value={formSeguimiento.reporte_bienestar}
                                            onChange={(e) => setFormSeguimiento({ ...formSeguimiento, reporte_bienestar: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>

                                    {/* APARTADO PARA SUBIR IMÁGENES SACADAS DEL ANIMAL DE LA VISITA REALIZADA */}
                                    <div
                                        style={{
                                            marginBottom: '16px',
                                            padding: '14px',
                                            backgroundColor: '#f0fdf4',
                                            border: '1.5px dashed #16a34a',
                                            borderRadius: '10px',
                                        }}
                                    >
                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
                                            <label style={{ fontSize: '13.5px', fontWeight: 700, color: '#14532d' }}>
                                                Subir Imágenes del Animal de la Visita Realizada
                                            </label>
                                            <span style={{ fontSize: '11px', fontWeight: 600, color: '#166534', backgroundColor: '#dcfce7', padding: '2px 8px', borderRadius: '99px' }}>
                                                JPG, PNG, WEBP
                                            </span>
                                        </div>
                                        <p style={{ fontSize: '12px', color: '#166534', margin: '0 0 10px 0' }}>
                                            Selecciona una o varias fotografías tomadas al animal durante la visita domiciliaria para adjuntarlas como evidencia.
                                        </p>

                                        <label
                                            style={{
                                                display: 'flex',
                                                alignItems: 'center',
                                                justifyContent: 'center',
                                                gap: '8px',
                                                padding: '10px 14px',
                                                backgroundColor: '#183d35',
                                                color: '#ffffff',
                                                borderRadius: '8px',
                                                fontSize: '13px',
                                                fontWeight: 600,
                                                cursor: 'pointer',
                                                marginBottom: '10px',
                                                textAlign: 'center',
                                            }}
                                        >
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                <polyline points="17 8 12 3 7 8" />
                                                <line x1="12" y1="3" x2="12" y2="15" />
                                            </svg>
                                            <span>Seleccionar Fotos del Animal desde Dispositivo / Cámara</span>
                                            <input
                                                type="file"
                                                accept="image/*"
                                                multiple
                                                onChange={handleSeleccionarArchivosSeguimiento}
                                                style={{ display: 'none' }}
                                            />
                                        </label>

                                        {/* Galería de vista previa de fotos ya guardadas y nuevas fotos seleccionadas */}
                                        {(imagenesExistentesSeguimiento.length > 0 || archivosSeguimiento.length > 0) && (
                                            <div style={{ marginTop: '10px' }}>
                                                <span style={{ display: 'block', fontSize: '11.5px', fontWeight: 700, color: '#14532d', marginBottom: '6px' }}>
                                                    Vista previa de fotografías adjuntas ({imagenesExistentesSeguimiento.length + archivosSeguimiento.length}):
                                                </span>
                                                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(105px, 1fr))', gap: '8px' }}>
                                                    {imagenesExistentesSeguimiento.map((url, idx) => (
                                                        <div
                                                            key={`exist-${idx}`}
                                                            style={{
                                                                position: 'relative',
                                                                borderRadius: '8px',
                                                                overflow: 'hidden',
                                                                border: '1px solid #86efac',
                                                                backgroundColor: '#ffffff',
                                                            }}
                                                        >
                                                            <img
                                                                src={url}
                                                                alt={`Guardada ${idx + 1}`}
                                                                style={{ width: '100%', height: '82px', objectFit: 'cover', display: 'block' }}
                                                            />
                                                            <button
                                                                type="button"
                                                                onClick={() => eliminarImagenExistenteSeguimiento(idx)}
                                                                title="Quitar imagen"
                                                                style={{
                                                                    position: 'absolute',
                                                                    top: '4px',
                                                                    right: '4px',
                                                                    width: '22px',
                                                                    height: '22px',
                                                                    borderRadius: '50%',
                                                                    border: 'none',
                                                                    backgroundColor: 'rgba(220, 38, 38, 0.9)',
                                                                    color: '#ffffff',
                                                                    fontSize: '12px',
                                                                    fontWeight: 700,
                                                                    cursor: 'pointer',
                                                                }}
                                                            >
                                                                ✕
                                                            </button>
                                                            <span style={{ display: 'block', fontSize: '10px', padding: '2px 4px', color: '#166534', textAlign: 'center', backgroundColor: '#dcfce7' }}>
                                                                Guardada #{idx + 1}
                                                            </span>
                                                        </div>
                                                    ))}

                                                    {archivosSeguimiento.map((item, idx) => (
                                                        <div
                                                            key={`new-${idx}`}
                                                            style={{
                                                                position: 'relative',
                                                                borderRadius: '8px',
                                                                overflow: 'hidden',
                                                                border: '2px solid #16a34a',
                                                                backgroundColor: '#ffffff',
                                                            }}
                                                        >
                                                            <img
                                                                src={item.previewUrl}
                                                                alt={item.nombre}
                                                                style={{ width: '100%', height: '82px', objectFit: 'cover', display: 'block' }}
                                                            />
                                                            <button
                                                                type="button"
                                                                onClick={() => eliminarArchivoSeguimiento(idx)}
                                                                title="Quitar foto seleccionada"
                                                                style={{
                                                                    position: 'absolute',
                                                                    top: '4px',
                                                                    right: '4px',
                                                                    width: '22px',
                                                                    height: '22px',
                                                                    borderRadius: '50%',
                                                                    border: 'none',
                                                                    backgroundColor: 'rgba(220, 38, 38, 0.9)',
                                                                    color: '#ffffff',
                                                                    fontSize: '12px',
                                                                    fontWeight: 700,
                                                                    cursor: 'pointer',
                                                                }}
                                                            >
                                                                ✕
                                                            </button>
                                                            <span
                                                                style={{
                                                                    display: 'block',
                                                                    fontSize: '10px',
                                                                    padding: '2px 4px',
                                                                    color: '#14532d',
                                                                    textAlign: 'center',
                                                                    whiteSpace: 'nowrap',
                                                                    overflow: 'hidden',
                                                                    textOverflow: 'ellipsis',
                                                                }}
                                                            >
                                                                {item.nombre}
                                                            </span>
                                                        </div>
                                                    ))}
                                                </div>
                                            </div>
                                        )}

                                        <div style={{ marginTop: '10px' }}>
                                            <label style={{ display: 'block', fontSize: '11.5px', fontWeight: 600, color: '#374151', marginBottom: '3px' }}>
                                                O pegar enlace externo de imagen (opcional):
                                            </label>
                                            <input
                                                type="text"
                                                placeholder="https://ejemplo.org/foto-animal-visita.jpg"
                                                value={formSeguimiento.fotografia}
                                                onChange={(e) => setFormSeguimiento({ ...formSeguimiento, fotografia: e.target.value })}
                                                style={{ width: '100%', padding: '7px 10px', border: '1px solid #cbd5e1', borderRadius: '6px', fontSize: '12.5px', backgroundColor: '#ffffff' }}
                                            />
                                        </div>
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
                                            style={{ padding: '8px 18px', borderRadius: '6px', border: 'none', background: '#183d35', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                        >
                                            {guardando ? 'Subiendo y Guardando...' : 'Guardar Visita e Imágenes'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    )}

                    {/* MODAL 4: Programar / Registrar Nueva Visita de Seguimiento con Subida de Imágenes */}
                    {modalNuevaVisita && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000, padding: '16px' }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '24px', width: '580px', maxWidth: '95vw', maxHeight: '92vh', overflowY: 'auto' }}>
                                <h2 style={{ marginBottom: '6px', color: '#0f172a' }}>Programar / Registrar Visita de Control</h2>
                                <p style={{ fontSize: '13px', color: '#6b7280', marginBottom: '16px' }}>
                                    Selecciona una adopción formalizada para agendar una nueva auditoría o registrar una visita realizada adjuntando las fotografías tomadas al animal.
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
                                                    ADOP-#{adop.id}: {adop.mascota?.nombre} ({adop.mascota?.especie} - {adop.mascota?.raza || 'Mestizo'}) — Adoptante: {adop.interesado?.nombre}
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
                                            <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Fecha Realizada (si ya se visitó)</label>
                                            <input
                                                type="date"
                                                value={formNuevaVisita.fecha_realizada}
                                                onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, fecha_realizada: e.target.value })}
                                                style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                            />
                                        </div>
                                    </div>

                                    <div style={{ marginBottom: '12px' }}>
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, marginBottom: '4px' }}>Estado de la Visita</label>
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
                                            Observaciones / Informe de la Visita
                                        </label>
                                        <textarea
                                            rows={3}
                                            placeholder="Detalles u observaciones del estado del animal en el hogar adoptivo..."
                                            value={formNuevaVisita.reporte_bienestar}
                                            onChange={(e) => setFormNuevaVisita({ ...formNuevaVisita, reporte_bienestar: e.target.value })}
                                            style={{ width: '100%', padding: '8px', border: '1px solid #d1d5db', borderRadius: '6px' }}
                                        />
                                    </div>

                                    {/* APARTADO PARA SUBIR IMÁGENES DEL ANIMAL DE LA VISITA */}
                                    <div
                                        style={{
                                            marginBottom: '16px',
                                            padding: '14px',
                                            backgroundColor: '#f0fdf4',
                                            border: '1.5px dashed #16a34a',
                                            borderRadius: '10px',
                                        }}
                                    >
                                        <label style={{ display: 'block', fontSize: '13px', fontWeight: 700, color: '#14532d', marginBottom: '6px' }}>
                                            Subir Imágenes del Animal de la Visita Realizada
                                        </label>
                                        <label
                                            style={{
                                                display: 'flex',
                                                alignItems: 'center',
                                                justifyContent: 'center',
                                                gap: '8px',
                                                padding: '10px 14px',
                                                backgroundColor: '#183d35',
                                                color: '#ffffff',
                                                borderRadius: '8px',
                                                fontSize: '13px',
                                                fontWeight: 600,
                                                cursor: 'pointer',
                                                marginBottom: '8px',
                                                textAlign: 'center',
                                            }}
                                        >
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                <polyline points="17 8 12 3 7 8" />
                                                <line x1="12" y1="3" x2="12" y2="15" />
                                            </svg>
                                            <span>Seleccionar Fotos del Animal desde Dispositivo</span>
                                            <input
                                                type="file"
                                                accept="image/*"
                                                multiple
                                                onChange={handleSeleccionarArchivosNuevaVisita}
                                                style={{ display: 'none' }}
                                            />
                                        </label>

                                        {archivosNuevaVisita.length > 0 && (
                                            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(100px, 1fr))', gap: '8px', marginTop: '8px' }}>
                                                {archivosNuevaVisita.map((item, idx) => (
                                                    <div
                                                        key={idx}
                                                        style={{
                                                            position: 'relative',
                                                            borderRadius: '8px',
                                                            overflow: 'hidden',
                                                            border: '2px solid #16a34a',
                                                            backgroundColor: '#ffffff',
                                                        }}
                                                    >
                                                        <img
                                                            src={item.previewUrl}
                                                            alt={item.nombre}
                                                            style={{ width: '100%', height: '80px', objectFit: 'cover', display: 'block' }}
                                                        />
                                                        <button
                                                            type="button"
                                                            onClick={() => eliminarArchivoNuevaVisita(idx)}
                                                            style={{
                                                                position: 'absolute',
                                                                top: '4px',
                                                                right: '4px',
                                                                width: '22px',
                                                                height: '22px',
                                                                borderRadius: '50%',
                                                                border: 'none',
                                                                backgroundColor: 'rgba(220, 38, 38, 0.9)',
                                                                color: '#ffffff',
                                                                fontSize: '12px',
                                                                fontWeight: 700,
                                                                cursor: 'pointer',
                                                            }}
                                                        >
                                                            ✕
                                                        </button>
                                                    </div>
                                                ))}
                                            </div>
                                        )}
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
                                            style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#183d35', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                        >
                                            {guardando ? 'Guardando...' : 'Guardar Visita'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    )}

                    {/* MODAL 5: Acta Digital */}
                    {actaDigital && (
                        <div className="modal-backdrop" style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                            <div style={{ backgroundColor: 'white', borderRadius: '12px', padding: '28px', width: '600px', maxWidth: '95vw', border: '2px solid #16a34a' }}>
                                <div style={{ textAlign: 'center', borderBottom: '2px solid #e5e7eb', paddingBottom: '16px', marginBottom: '16px' }}>
                                    <h1 style={{ color: '#16a34a', fontSize: '22px', margin: 0 }}>ACTA DE ADOPCIÓN RESPONSABLE</h1>
                                    <span style={{ fontWeight: 600, color: '#4b5563' }}>{actaDigital.numero_acta}</span>
                                    <p style={{ fontSize: '12px', color: '#9ca3af', margin: '4px 0 0 0' }}>
                                        Refugio: {actaDigital.albergue} | Fecha: {actaDigital.fecha}
                                    </p>
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' }}>
                                    <div style={{ padding: '12px', backgroundColor: '#f9fafb', borderRadius: '8px' }}>
                                        <h4 style={{ margin: '0 0 8px 0', color: '#1f2937' }}>Datos del Adoptante</h4>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Nombre:</strong> {actaDigital.adoptante?.nombre}
                                        </p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>CI:</strong> {actaDigital.adoptante?.ci}
                                        </p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Teléfono:</strong> {actaDigital.adoptante?.telefono}
                                        </p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Dirección:</strong> {actaDigital.adoptante?.direccion}
                                        </p>
                                    </div>

                                    <div style={{ padding: '12px', backgroundColor: '#f9fafb', borderRadius: '8px' }}>
                                        <h4 style={{ margin: '0 0 8px 0', color: '#1f2937' }}>Datos de la Mascota</h4>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Nombre:</strong> {actaDigital.mascota?.nombre}
                                        </p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Especie:</strong> {actaDigital.mascota?.especie}
                                        </p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Raza:</strong> {actaDigital.mascota?.raza}
                                        </p>
                                        <p style={{ margin: '3px 0', fontSize: '13px' }}>
                                            <strong>Sexo:</strong> {actaDigital.mascota?.sexo}
                                        </p>
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
                                        onClick={imprimirActaOficialPDF}
                                        style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: '#16a34a', color: 'white', fontWeight: 600, cursor: 'pointer' }}
                                    >
                                        Imprimir Acta Oficial (PDF)
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
