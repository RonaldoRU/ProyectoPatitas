/**
 * Componente NavigationRail / MenuHamburguesa:
 * Barra de navegación lateral (y barra inferior adaptativa en teléfonos móviles) con panel desplegable de opciones.
 * Sin numeración de paquetes ni códigos de casos de uso.
 * El Dashboard se ubica como acceso principal directo fuera de los paquetes.
 */
import { Link } from '@inertiajs/react';
import React, { useEffect, useMemo, useState } from 'react';

export type FuncionInfo = {
    esSesion?: boolean;
    nombre: string;
    ruta: string;
    descripcion: string;
};

export type ModuloInfo = {
    id: string;
    etiquetaCorta: string;
    nombre: string;
    subtitulo: string;
    icono: (color: string) => React.ReactNode;
    funciones: FuncionInfo[];
};

// Catálogo de Módulos del Sistema (sin numeración de paquetes ni casos de uso)
export const MACRO_PAQUETES: ModuloInfo[] = [
    {
        id: 'seguridad',
        etiquetaCorta: 'Seguridad',
        nombre: 'Seguridad, Usuarios y Auditoría Forense',
        subtitulo: 'Control de acceso y trazabilidad',
        icono: (c) => (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
        ),
        funciones: [
            { esSesion: true, nombre: 'Iniciar Sesión en la Plataforma Web', ruta: '/login', descripcion: 'Estado de conexión activa con credenciales protegidas y token Sanctum.' },
            { nombre: 'Recuperar / Restablecer Contraseña', ruta: '/recuperar-password', descripcion: 'Restablecimiento de credenciales mediante código de verificación seguro.' },
            { nombre: 'Gestión de Cuentas y Roles', ruta: '/usuarios', descripcion: 'Catálogo de usuarios, modificación de datos, asignación de rol y estado.' },
            { nombre: 'Bitácora de Auditoría del Sistema', ruta: '/bitacora', descripcion: 'Registro inmutable de trazabilidad cronológica de todas las operaciones.' },
            { nombre: 'Auditoría Forense y Seguridad Inmutable', ruta: '/auditoria-forense', descripcion: 'Detección de accesos, verificación de hashes SHA-256 e integridad.' },
        ],
    },
    {
        id: 'inventario',
        etiquetaCorta: 'Almacén',
        nombre: 'Logística de Inventario, Despensa y Proveedores',
        subtitulo: 'Existencias, lotes y abastecimiento',
        icono: (c) => (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
                <line x1="12" y1="22.08" x2="12" y2="12"></line>
            </svg>
        ),
        funciones: [
            { nombre: 'Catálogo de Artículos, Stock y Mermas', ruta: '/articulos-inventario', descripcion: 'Alimentos e insumos médicos, umbrales mínimos de alerta y ajuste de mermas.' },
            { nombre: 'Entradas de Insumos y Donaciones Materiales', ruta: '/entradas-insumos', descripcion: 'Recepción de compras con lotes y registro de donaciones en especie.' },
            { nombre: 'Salidas y Consumo de Despensa', ruta: '/salidas-inventario', descripcion: 'Descargo de productos por raciones de alimentación y suministros del albergue.' },
            { nombre: 'Directorio de Proveedores Aliados', ruta: '/proveedores', descripcion: 'Gestión de proveedores de alimentos, medicamentos veterinarios y servicios.' },
            { nombre: 'Control de Vencimientos FEFO', ruta: '/control-vencimientos', descripcion: 'Monitoreo de caducidad de fármacos bajo norma SENASAG y alertas tempranas.' },
        ],
    },
    {
        id: 'clinica_adopciones',
        etiquetaCorta: 'Clínica',
        nombre: 'Gestión de Rescates, Clínica Veterinaria y Adopciones',
        subtitulo: 'Pacientes, tratamientos y familias',
        icono: (c) => (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
            </svg>
        ),
        funciones: [
            { nombre: 'Fichas de Rescate e Ingreso de Mascotas', ruta: '/mascotas', descripcion: 'Registro de acogida, fotografía con enlace visual, triaje sanitario y estado actual.' },
            { nombre: 'Expediente Clínico y Atención Médica', ruta: '/atenciones-clinicas', descripcion: 'Consultas médicas, cirugías, diagnósticos y descargo automático de fármacos.' },
            { nombre: 'Dosificación Automática y Tratamientos', ruta: '/dosificacion-clinica', descripcion: 'Cálculo de dosis por peso/especie y cronograma de tomas con rotación FEFO.' },
            { nombre: 'Postulantes y Evaluación de Idoneidad', ruta: '/postulantes', descripcion: 'Evaluación socio-ambiental, calificación de aptitud y filtro de adoptantes.' },
            { nombre: 'Formalización de Adopción y Visitas', ruta: '/adopciones', descripcion: 'Emisión de contrato/acta legal y agenda de visitas a 30, 90 y 180 días.' },
        ],
    },
    {
        id: 'pagos',
        etiquetaCorta: 'Donar',
        nombre: 'Donaciones Monetarias y Pasarela de Pagos',
        subtitulo: 'Recaudación solidaria y arqueo',
        icono: (c) => (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                <line x1="1" y1="10" x2="23" y2="10"></line>
            </svg>
        ),
        funciones: [
            { nombre: 'Donaciones en Efectivo y Libro de Donantes', ruta: '/donaciones', descripcion: 'Registro de aportes presenciales en Bolivianos (Bs.), directorio y recibos.' },
            { nombre: 'Pasarela Digital QR, Arqueo y Reembolsos', ruta: '/pasarela-pagos', descripcion: 'Cobros QR Simple y tarjeta, confirmación en línea, arqueo y reversiones.' },
        ],
    },
    {
        id: 'facturacion_reportes',
        etiquetaCorta: 'Fiscal',
        nombre: 'Facturación Legal (SIN), Tributación y Reportes',
        subtitulo: 'Normativa tributaria y balances',
        icono: (c) => (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16l4-2 4 2 4-2 4 2V8z"></path>
                <line x1="8" y1="10" x2="16" y2="10"></line>
                <line x1="8" y1="14" x2="14" y2="14"></line>
            </svg>
        ),
        funciones: [
            { nombre: 'Reportes Estadísticos y Gerenciales', ruta: '/reportes-gerenciales', descripcion: 'Exportación de balances ejecutivos en PDF/Excel para toma de decisiones.' },
            { nombre: 'Dosificación Fiscal y Parámetros SIN', ruta: '/dosificaciones-fiscales', descripcion: 'Gestión de autorizaciones tributarias, número de trámite y llave de dosificación.' },
            { nombre: 'Facturación Legal Computarizada y QR', ruta: '/facturas-legales', descripcion: 'Emisión con Código de Control V7, código QR tributario y control de anulaciones.' },
            { nombre: 'Libro de Compras y Ventas IVA Tributario', ruta: '/libro-iva', descripcion: 'Generación de planillas tributarias para el SIN con exportación en formato CSV.' },
            { nombre: 'Rendición de Cuentas Institucional', ruta: '/rendicion-cuentas', descripcion: 'Cierres de periodo bajo Ley N° 351 con sello digital inmutable SHA-256.' },
        ],
    },
];

interface MenuHamburguesaProps {
    abierto?: boolean;
    onClose?: () => void;
    rol?: string;
    tiempoConectado?: string;
}

export default function MenuHamburguesa({ rol: rolProp, tiempoConectado: tiempoConectadoProp }: MenuHamburguesaProps) {
    const [rutaActual, setRutaActual] = useState('');
    const [moduloSeleccionadoId, setModuloSeleccionadoId] = useState<string | null>(null);
    const [detectedRol, setDetectedRol] = useState<string>(rolProp ?? '');
    const [usuarioActual, setUsuarioActual] = useState<{ id?: number; nombre: string; rol: string; email?: string } | null>(null);
    const [sesionActiva, setSesionActiva] = useState(false);
    const [modalSesionAbierto, setModalSesionAbierto] = useState(false);
    const [timerLocal, setTimerLocal] = useState<string>(tiempoConectadoProp || '00:00:00');

    // Sincronizar cronómetro y sesión activa
    useEffect(() => {
        if (typeof window === 'undefined') {
            return;
        }

        const token = localStorage.getItem('token');
        const storedUser = localStorage.getItem('user');
        if (token) {
            setSesionActiva(true);
        }
        if (storedUser) {
            try {
                const parsed = JSON.parse(storedUser);
                setUsuarioActual(parsed);
                if (parsed?.rol && !rolProp) {
                    setDetectedRol(parsed.rol);
                }
            } catch {
                // ignorar
            }
        }

        let loginTime = localStorage.getItem('session_login_time');
        if (!loginTime && token) {
            loginTime = Date.now().toString();
            localStorage.setItem('session_login_time', loginTime);
        }

        const startMs = loginTime ? parseInt(loginTime, 10) : Date.now();
        const updateTimer = () => {
            const diffSeconds = Math.max(0, Math.floor((Date.now() - startMs) / 1000));
            const hours = Math.floor(diffSeconds / 3600);
            const minutes = Math.floor((diffSeconds % 3600) / 60);
            const seconds = diffSeconds % 60;
            const formatted = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
            setTimerLocal(formatted);
        };

        updateTimer();
        const interval = setInterval(updateTimer, 1000);
        return () => clearInterval(interval);
    }, [rolProp]);

    // Actualizar timer si viene por props
    useEffect(() => {
        if (tiempoConectadoProp) {
            setTimerLocal(tiempoConectadoProp);
        }
    }, [tiempoConectadoProp]);

    // Sincronizar rol actual
    useEffect(() => {
        if (rolProp) {
            setDetectedRol(rolProp);
            return;
        }

        const storedUser = localStorage.getItem('user');
        if (storedUser) {
            try {
                const parsed = JSON.parse(storedUser);
                if (parsed?.rol) {
                    setDetectedRol(parsed.rol);
                    return;
                }
            } catch {
                // ignorar
            }
        }
    }, [rolProp]);

    const esAdministrador = useMemo(() => {
        const rolNorm = (detectedRol || '').trim().toLowerCase();
        return rolNorm === '' || rolNorm.includes('admin');
    }, [detectedRol]);

    // Filtrado estricto de Módulos y Sub-opciones según el Rol del Usuario (RBAC)
    const modulosPermitidos = useMemo<ModuloInfo[]>(() => {
        const rolNorm = (detectedRol || '').trim().toLowerCase();

        // Funciones de sesión básicas (sin Gestión de Cuentas, Bitácora ni Auditoría Forense, que son exclusivas del Administrador)
        const filtrarSeguridadBasica = (m: ModuloInfo): ModuloInfo => ({
            ...m,
            funciones: m.funciones.filter(
                (f) => f.ruta === '/login' || f.ruta === '/recuperar-password'
            ),
        });

        // Funciones de Clínica para Recepcionista y Voluntario: solo Ficha (/mascotas), Postulantes (/postulantes) y Formalización (/adopciones)
        const filtrarClinicaRecepcionVoluntario = (m: ModuloInfo): ModuloInfo => ({
            ...m,
            funciones: m.funciones.filter(
                (f) => f.ruta === '/mascotas' || f.ruta === '/postulantes' || f.ruta === '/adopciones'
            ),
        });

        // 1. Rol Veterinario:
        // - Sin las 3 opciones de administrador en Seguridad (/usuarios, /bitacora, /auditoria-forense)
        // - En Almacén solo es visible el Catálogo de Artículos (/articulos-inventario)
        // - En Clínica ve Fichas de Mascotas, Expediente Clínico y Dosificación Automática
        // - Sin Dashboard, sin Donativos y sin Reportes/Fiscal
        if (rolNorm.includes('veterinari')) {
            return MACRO_PAQUETES.filter(
                (m) => m.id === 'seguridad' || m.id === 'inventario' || m.id === 'clinica_adopciones'
            ).map((m) => {
                if (m.id === 'seguridad') {
                    return filtrarSeguridadBasica(m);
                }
                if (m.id === 'inventario') {
                    return {
                        ...m,
                        funciones: m.funciones.filter((f) => f.ruta === '/articulos-inventario'),
                    };
                }
                if (m.id === 'clinica_adopciones') {
                    return {
                        ...m,
                        funciones: m.funciones.filter(
                            (f) =>
                                f.ruta === '/mascotas' ||
                                f.ruta === '/atenciones-clinicas' ||
                                f.ruta === '/dosificacion-clinica'
                        ),
                    };
                }
                return m;
            });
        }

        // 2. Rol Recepcionista:
        // - Todo lo que hay en Almacén
        // - En Clínica solo visualiza Ficha (/mascotas), Postulantes (/postulantes) y Formalización (/adopciones); los otros ocultos
        // - En Donativos ve todo (/donaciones, /pasarela-pagos)
        // - Puede generar Reportes / Facturación (módulo Fiscal completo)
        if (rolNorm.includes('recepcion')) {
            return MACRO_PAQUETES.filter(
                (m) =>
                    m.id === 'seguridad' ||
                    m.id === 'inventario' ||
                    m.id === 'clinica_adopciones' ||
                    m.id === 'pagos' ||
                    m.id === 'facturacion_reportes'
            ).map((m) => {
                if (m.id === 'seguridad') {
                    return filtrarSeguridadBasica(m);
                }
                if (m.id === 'clinica_adopciones') {
                    return filtrarClinicaRecepcionVoluntario(m);
                }
                return m;
            });
        }

        // 3. Rol Voluntario:
        // - Igual que Recepcionista en Almacén (todo), Clínica (solo Ficha, Postulantes y Formalización) y Donativos (todo)
        // - La única diferencia con Recepcionista es que el Voluntario NO puede generar reportes (sin módulo Fiscal/Reportes)
        if (rolNorm.includes('voluntar')) {
            return MACRO_PAQUETES.filter(
                (m) =>
                    m.id === 'seguridad' ||
                    m.id === 'inventario' ||
                    m.id === 'clinica_adopciones' ||
                    m.id === 'pagos'
            ).map((m) => {
                if (m.id === 'seguridad') {
                    return filtrarSeguridadBasica(m);
                }
                if (m.id === 'clinica_adopciones') {
                    return filtrarClinicaRecepcionVoluntario(m);
                }
                return m;
            });
        }

        // 4. Rol Donante o Postulante
        if (rolNorm.includes('donante') || rolNorm.includes('postulant')) {
            return [
                {
                    id: 'clinica_adopciones',
                    etiquetaCorta: 'Mascotas',
                    nombre: 'Animalitos en Adopción',
                    subtitulo: 'Catálogo público de mascotas rescatadas',
                    icono: (c) => (
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                        </svg>
                    ),
                    funciones: [
                        {
                            nombre: 'Mascotas Disponibles para Adopción',
                            ruta: '/mascotas',
                            descripcion: 'Conoce la fotografía, estado de recuperación y ficha de nuestros pequeños rescatados.',
                        },
                    ],
                },
                {
                    id: 'pagos',
                    etiquetaCorta: 'Donar',
                    nombre: 'Donaciones en Línea',
                    subtitulo: 'Aportes solidarios al refugio',
                    icono: (c) => (
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                            <line x1="1" y1="10" x2="23" y2="10"></line>
                        </svg>
                    ),
                    funciones: [
                        {
                            nombre: 'Aportes Solidarios (Únicos / Mensuales)',
                            ruta: '/pasarela-pagos',
                            descripcion: 'Dona en línea mediante QR o tarjeta y recibe tu constancia digital instantánea.',
                        },
                    ],
                },
            ];
        }

        // 5. Rol Administrador: Acceso a todos los módulos
        return MACRO_PAQUETES;
    }, [detectedRol]);

    useEffect(() => {
        if (typeof window !== 'undefined') {
            setRutaActual(window.location.pathname);
        }

        const handleKeyDown = (e: KeyboardEvent) => {
            if (e.key === 'Escape') {
                setModuloSeleccionadoId(null);
            }
        };
        window.addEventListener('keydown', handleKeyDown);
        return () => window.removeEventListener('keydown', handleKeyDown);
    }, []);

    const toggleModulo = (id: string) => {
        setModuloSeleccionadoId((prev) => (prev === id ? null : id));
    };

    const moduloSeleccionado = useMemo(() => {
        if (!moduloSeleccionadoId) {
            return null;
        }
        return modulosPermitidos.find((m) => m.id === moduloSeleccionadoId) ?? null;
    }, [moduloSeleccionadoId, modulosPermitidos]);

    const enDashboard = rutaActual === '/dashboard' || rutaActual === '/';

    return (
        <>
            {/* Barra lateral de navegación (se adapta a barra inferior en móvil) */}
            <aside
                className="agy-nav-rail"
                aria-label="Menú Principal de Módulos"
            >
                {/* Emblema Oficial del Refugio en la barra lateral */}
                <div
                    className="agy-nav-rail__logo-wrap"
                    style={{
                        marginBottom: '6px',
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                    }}
                    title="Refugio Angelitos de Edgar · Rescatados de la muerte"
                >
                    <img
                        src="/images/logo-refugio-angelitos.jpg"
                        alt="Logo Refugio Angelitos de Edgar"
                        style={{
                            width: '44px',
                            height: '44px',
                            borderRadius: '50%',
                            objectFit: 'cover',
                            border: '2px solid #7dd3fc',
                            boxShadow: '0 3px 10px rgba(0, 0, 0, 0.28)',
                        }}
                    />
                </div>

                {/*Acceso Principal Directo al Dashboard (exclusivo para Administrador)*/}
                {esAdministrador && (
                    <Link
                        href="/dashboard"
                        title="Dashboard Principal · Inteligencia Operativa"
                        aria-label="Dashboard Principal"
                        className={`agy-nav-rail__item ${enDashboard && !moduloSeleccionadoId ? 'agy-nav-rail__item--active' : ''}`}
                        onClick={() => setModuloSeleccionadoId(null)}
                    >
                        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                            <svg
                                width="20"
                                height="20"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke={enDashboard && !moduloSeleccionadoId ? '#ffffff' : '#a7f3d0'}
                                strokeWidth="2"
                                strokeLinecap="round"
                                strokeLinejoin="round"
                            >
                                <rect x="3" y="3" width="7" height="9" rx="1" />
                                <rect x="14" y="3" width="7" height="5" rx="1" />
                                <rect x="14" y="12" width="7" height="9" rx="1" />
                                <rect x="3" y="16" width="7" height="5" rx="1" />
                            </svg>
                        </div>
                        <span className="agy-nav-rail__label">Dashboard</span>
                    </Link>
                )}

                {esAdministrador && <div className="agy-nav-rail__divider" />}

                {/* Lista de Módulos sin numeración */}
                <nav className="agy-nav-rail__list">
                    {modulosPermitidos.map((modulo) => {
                        const esRutaActiva = modulo.funciones.some((f) => f.ruta === rutaActual);
                        const esSeleccionado = moduloSeleccionadoId === modulo.id;

                        return (
                            <button
                                key={modulo.id}
                                type="button"
                                onClick={() => toggleModulo(modulo.id)}
                                title={modulo.nombre}
                                aria-label={modulo.nombre}
                                aria-expanded={esSeleccionado}
                                className={`agy-nav-rail__item ${esSeleccionado ? 'agy-nav-rail__item--selected' : esRutaActiva ? 'agy-nav-rail__item--active' : ''}`}
                            >
                                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                                    {modulo.icono(esSeleccionado || esRutaActiva ? '#ffffff' : 'rgba(255,255,255,0.85)')}
                                </div>
                                <span className="agy-nav-rail__label">
                                    {modulo.etiquetaCorta}
                                </span>
                            </button>
                        );
                    })}
                </nav>

                {/* Pie: Rol actual */}
                <div
                    className="agy-nav-rail__footer"
                    title={`Rol activo: ${detectedRol || 'Usuario'}`}
                >
                    {detectedRol ? detectedRol.slice(0, 5) : 'STAFF'}
                </div>
            </aside>

            {/* Panel Desplegable de Funciones del Módulo */}
            {moduloSeleccionado && (
                <>
                    <div
                        onClick={() => setModuloSeleccionadoId(null)}
                        style={{
                            position: 'fixed',
                            inset: 0,
                            backgroundColor: 'rgba(15, 23, 42, 0.35)',
                            zIndex: 9980,
                            backdropFilter: 'blur(2px)',
                        }}
                    />

                    <div
                        role="dialog"
                        aria-label={`Opciones de ${moduloSeleccionado.nombre}`}
                        className="agy-nav-flyout"
                    >
                        {/* Cabecera del Módulo (Sin códigos P01/CUs) */}
                        <div
                            style={{
                                padding: '16px 18px 14px',
                                borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
                                display: 'flex',
                                alignItems: 'flex-start',
                                justifyContent: 'space-between',
                                gap: '10px',
                                backgroundColor: 'rgba(0, 0, 0, 0.16)',
                            }}
                        >
                            <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                                <div
                                    style={{
                                        width: '38px',
                                        height: '38px',
                                        borderRadius: '10px',
                                        backgroundColor: 'rgba(16, 185, 129, 0.2)',
                                        border: '1px solid rgba(52, 211, 153, 0.4)',
                                        display: 'grid',
                                        placeItems: 'center',
                                        flexShrink: 0,
                                    }}
                                >
                                    {moduloSeleccionado.icono('#6ee7b7')}
                                </div>
                                <div>
                                    <span style={{
                                        fontSize: '10.5px',
                                        fontWeight: 700,
                                        color: '#6ee7b7',
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                        display: 'block',
                                    }}>
                                        {moduloSeleccionado.subtitulo}
                                    </span>
                                    <h3
                                        style={{
                                            margin: '2px 0 0',
                                            fontSize: '14.5px',
                                            fontWeight: 700,
                                            color: '#ffffff',
                                            lineHeight: 1.25,
                                        }}
                                    >
                                        {moduloSeleccionado.nombre}
                                    </h3>
                                </div>
                            </div>
                            <button
                                type="button"
                                onClick={() => setModuloSeleccionadoId(null)}
                                title="Cerrar panel (Esc)"
                                aria-label="Cerrar panel"
                                style={{
                                    border: 'none',
                                    background: 'rgba(255, 255, 255, 0.1)',
                                    color: '#ffffff',
                                    fontSize: '14px',
                                    cursor: 'pointer',
                                    padding: '5px 9px',
                                    borderRadius: '6px',
                                    lineHeight: 1,
                                    flexShrink: 0,
                                }}
                            >
                                ✕
                            </button>
                        </div>

                        {/* Lista de Funciones Interactivas (Sin códigos CU) */}
                        <div
                            style={{
                                flex: '1 1 auto',
                                overflowY: 'auto',
                                padding: '12px',
                                display: 'flex',
                                flexDirection: 'column',
                                gap: '7px',
                            }}
                        >
                            {moduloSeleccionado.funciones.map((f, idx) => {
                                const esActivo = rutaActual === f.ruta;

                                // Si el usuario ya está autenticado y presiona Iniciar Sesión, abre el modal de sesión activa con el cronómetro
                                if (f.esSesion && sesionActiva) {
                                    return (
                                        <button
                                            key={idx}
                                            type="button"
                                            onClick={() => {
                                                setModuloSeleccionadoId(null);
                                                setModalSesionAbierto(true);
                                            }}
                                            style={{
                                                textDecoration: 'none',
                                                display: 'flex',
                                                alignItems: 'flex-start',
                                                gap: '12px',
                                                padding: '12px 14px',
                                                borderRadius: '10px',
                                                backgroundColor: 'rgba(16, 185, 129, 0.14)',
                                                border: '1px solid rgba(52, 211, 153, 0.38)',
                                                transition: 'all 0.14s ease',
                                                width: '100%',
                                                textAlign: 'left',
                                                cursor: 'pointer',
                                            }}
                                        >
                                            <div
                                                style={{
                                                    width: '8px',
                                                    height: '8px',
                                                    borderRadius: '50%',
                                                    backgroundColor: '#10b981',
                                                    boxShadow: '0 0 0 3px rgba(16, 185, 129, 0.28)',
                                                    marginTop: '5px',
                                                    flexShrink: 0,
                                                }}
                                            />
                                            <div style={{ flex: 1, minWidth: 0 }}>
                                                <div
                                                    style={{
                                                        fontSize: '13.5px',
                                                        fontWeight: 700,
                                                        color: '#ffffff',
                                                        lineHeight: 1.25,
                                                        marginBottom: '4px',
                                                    }}
                                                >
                                                    {f.nombre}
                                                </div>

                                                {/* Cronómetro en vivo dentro del apartado de Sesión */}
                                                <div
                                                    style={{
                                                        display: 'inline-flex',
                                                        alignItems: 'center',
                                                        gap: '6px',
                                                        padding: '3px 10px',
                                                        borderRadius: '999px',
                                                        backgroundColor: 'rgba(6, 95, 70, 0.65)',
                                                        border: '1px solid rgba(110, 231, 183, 0.45)',
                                                        color: '#a7f3d0',
                                                        fontSize: '11px',
                                                        fontWeight: 700,
                                                        margin: '2px 0 4px',
                                                        fontVariantNumeric: 'tabular-nums',
                                                    }}
                                                >
                                                    <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#34d399' }} />
                                                    <span>En línea: {timerLocal}</span>
                                                </div>

                                                <div
                                                    style={{
                                                        fontSize: '11.5px',
                                                        color: 'rgba(255, 255, 255, 0.72)',
                                                        lineHeight: 1.35,
                                                    }}
                                                >
                                                    Sesión activa iniciada. Conexión continua sin desconexión automática.
                                                </div>
                                            </div>
                                        </button>
                                    );
                                }

                                return (
                                    <Link
                                        key={idx}
                                        href={f.ruta}
                                        onClick={() => setModuloSeleccionadoId(null)}
                                        style={{
                                            textDecoration: 'none',
                                            display: 'flex',
                                            alignItems: 'flex-start',
                                            gap: '12px',
                                            padding: '12px 14px',
                                            borderRadius: '10px',
                                            backgroundColor: esActivo
                                                ? 'rgba(16, 185, 129, 0.2)'
                                                : 'rgba(255, 255, 255, 0.04)',
                                            border: esActivo
                                                ? '1px solid rgba(110, 231, 183, 0.45)'
                                                : '1px solid transparent',
                                            transition: 'all 0.14s ease',
                                        }}
                                    >
                                        <div
                                            style={{
                                                width: '7px',
                                                height: '7px',
                                                borderRadius: '50%',
                                                backgroundColor: esActivo ? '#34d399' : 'rgba(167, 243, 208, 0.5)',
                                                marginTop: '5px',
                                                flexShrink: 0,
                                            }}
                                        />
                                        <div style={{ flex: 1, minWidth: 0 }}>
                                            <div
                                                style={{
                                                    fontSize: '13.5px',
                                                    fontWeight: 700,
                                                    color: esActivo ? '#a7f3d0' : '#ffffff',
                                                    lineHeight: 1.25,
                                                    marginBottom: '3px',
                                                }}
                                            >
                                                {f.nombre}
                                            </div>
                                            <div
                                                style={{
                                                    fontSize: '11.5px',
                                                    color: 'rgba(255, 255, 255, 0.68)',
                                                    lineHeight: 1.35,
                                                }}
                                            >
                                                {f.descripcion}
                                            </div>
                                        </div>
                                    </Link>
                                );
                            })}
                        </div>
                    </div>
                </>
            )}

            {/* Modal de Sesión Activa y Cronómetro (Sin códigos P01/CU01) */}
            {modalSesionAbierto && (
                <div
                    style={{
                        position: 'fixed',
                        inset: 0,
                        backgroundColor: 'rgba(15, 23, 42, 0.65)',
                        zIndex: 10050,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        padding: '16px',
                        backdropFilter: 'blur(3px)',
                    }}
                    onClick={() => setModalSesionAbierto(false)}
                >
                    <div
                        style={{
                            backgroundColor: '#ffffff',
                            color: '#0f172a',
                            borderRadius: '16px',
                            maxWidth: '460px',
                            width: '100%',
                            boxShadow: '0 24px 48px rgba(0, 0, 0, 0.35)',
                            border: '1px solid #cbd5e1',
                            overflow: 'hidden',
                        }}
                        onClick={(e) => e.stopPropagation()}
                    >
                        <div style={{ backgroundColor: '#0d6e4f', color: '#ffffff', padding: '18px 22px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                            <div>
                                <div style={{ fontSize: '11px', fontWeight: 700, color: '#a7f3d0', letterSpacing: '0.06em', textTransform: 'uppercase' }}>
                                    Seguridad y Autenticación
                                </div>
                                <h3 style={{ margin: '2px 0 0', fontSize: '17px', fontWeight: 700 }}>
                                    Sesión Activa en la Plataforma
                                </h3>
                            </div>
                            <button
                                type="button"
                                onClick={() => setModalSesionAbierto(false)}
                                style={{ background: 'none', border: 'none', color: '#ffffff', fontSize: '18px', cursor: 'pointer', padding: '4px' }}
                            >
                                ✕
                            </button>
                        </div>

                        <div style={{ padding: '22px' }}>
                            <div style={{ backgroundColor: '#ecfdf5', border: '1.5px solid #6ee7b7', borderRadius: '12px', padding: '18px', textAlign: 'center', marginBottom: '18px' }}>
                                <div style={{ display: 'inline-flex', alignItems: 'center', gap: '6px', fontSize: '11.5px', fontWeight: 700, color: '#065f46', textTransform: 'uppercase', marginBottom: '4px' }}>
                                    <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#10b981', display: 'inline-block' }} />
                                    <span>Tiempo Conectado en la Plataforma</span>
                                </div>
                                <div style={{ fontSize: '34px', fontWeight: 800, color: '#064e3b', fontVariantNumeric: 'tabular-nums', letterSpacing: '1px' }}>
                                    {timerLocal}
                                </div>
                                <p style={{ margin: '6px 0 0', fontSize: '12px', color: '#047857' }}>
                                    Conexión continua activa sin límite de inactividad ni desconexión automática.
                                </p>
                            </div>

                            <div style={{ backgroundColor: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: '10px', padding: '14px', fontSize: '13px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                    <span style={{ color: '#64748b' }}>Usuario conectado:</span>
                                    <strong style={{ color: '#0f172a' }}>{usuarioActual?.nombre || 'Usuario Autorizado'}</strong>
                                </div>
                                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                    <span style={{ color: '#64748b' }}>Rol del sistema:</span>
                                    <span style={{ fontWeight: 700, color: '#065f46', backgroundColor: '#d1fae5', padding: '2px 8px', borderRadius: '6px', fontSize: '12px' }}>
                                        {detectedRol || usuarioActual?.rol || 'Administrador'}
                                    </span>
                                </div>
                                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                    <span style={{ color: '#64748b' }}>Estado de seguridad:</span>
                                    <span style={{ color: '#059669', fontWeight: 700 }}>Token Sanctum Activo</span>
                                </div>
                            </div>

                            <div style={{ marginTop: '20px', display: 'flex', justifyContent: 'flex-end' }}>
                                <button
                                    type="button"
                                    onClick={() => setModalSesionAbierto(false)}
                                    style={{
                                        padding: '10px 20px',
                                        borderRadius: '8px',
                                        border: 'none',
                                        backgroundColor: '#0d6e4f',
                                        color: '#ffffff',
                                        fontWeight: 700,
                                        fontSize: '13px',
                                        cursor: 'pointer',
                                    }}
                                >
                                    Continuar en la Plataforma
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </>
    );
}
