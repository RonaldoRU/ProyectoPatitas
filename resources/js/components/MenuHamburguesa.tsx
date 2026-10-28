import { Link } from '@inertiajs/react';
import { useEffect, useMemo, useState } from 'react';

type PaqueteInfo = {
    numero: string;
    nombre: string;
    badgeBg: string;
    badgeColor: string;
    funciones: Array<{
        nombre: string;
        ruta: string;
        casoUso: string;
        icono: string;
        descripcion: string;
    }>;
};

const PAQUETES: PaqueteInfo[] = [
    {
        numero: 'P1',
        nombre: 'Seguridad y Autenticación',
        badgeBg: '#fee2e2',
        badgeColor: '#991b1b',
        funciones: [
            { nombre: 'Iniciar Sesión', ruta: '/login', casoUso: 'CU1', icono: '🔐', descripcion: 'Autenticación segura y bitácora de accesos.' },
            { nombre: 'Recuperar Contraseña', ruta: '/recuperar-password', casoUso: 'CU3', icono: '🔑', descripcion: 'Restablecimiento con token temporal.' },
        ],
    },
    {
        numero: 'P2',
        nombre: 'Administración de Usuarios (RBAC)',
        badgeBg: '#dbeafe',
        badgeColor: '#1e40af',
        funciones: [
            { nombre: 'Gestión de Usuarios y Roles', ruta: '/usuarios', casoUso: 'CU4-CU8', icono: '👥', descripcion: 'Altas, bajas lógicas y asignación de roles.' },
        ],
    },
    {
        numero: 'P3',
        nombre: 'Auditoría y Bitácora',
        badgeBg: '#f1f5f9',
        badgeColor: '#334155',
        funciones: [
            { nombre: 'Bitácora de Eventos', ruta: '/bitacora', casoUso: 'CU9, CU10', icono: '📜', descripcion: 'Registro inmutable de trazabilidad e IP.' },
        ],
    },
    {
        numero: 'P4',
        nombre: 'Catálogo y Existencias',
        badgeBg: '#e0f2fe',
        badgeColor: '#075985',
        funciones: [
            { nombre: 'Catálogo y Control de Stock', ruta: '/articulos-inventario', casoUso: 'CU11, CU14, CU17', icono: '📦', descripcion: 'Artículos, stock mínimo y ajustes manuales.' },
        ],
    },
    {
        numero: 'P5',
        nombre: 'Abastecimiento y Proveedores',
        badgeBg: '#fef3c7',
        badgeColor: '#92400e',
        funciones: [
            { nombre: 'Proveedores Registrados', ruta: '/proveedores', casoUso: 'CU18', icono: '🏢', descripcion: 'Directorio de proveedores e historial.' },
            { nombre: 'Entradas de Insumos', ruta: '/entradas-insumos', casoUso: 'CU12', icono: '📥', descripcion: 'Recepción con control de lotes y vencimiento.' },
            { nombre: 'Salidas y Consumos', ruta: '/salidas-inventario', casoUso: 'CU13', icono: '📤', descripcion: 'Descargo de productos y costeo de salida.' },
        ],
    },
    {
        numero: 'P6',
        nombre: 'Automatización Clínica',
        badgeBg: '#ffe4e6',
        badgeColor: '#9f1239',
        funciones: [
            { nombre: 'Control de Vencimientos', ruta: '/control-vencimientos', casoUso: 'CU16', icono: '⏰', descripcion: 'Semáforo de caducidad a 30 y 60 días.' },
        ],
    },
    {
        numero: 'P7',
        nombre: 'Rescate y Ficha Clínica',
        badgeBg: '#e0f2fe',
        badgeColor: '#0369a1',
        funciones: [
            { nombre: 'Fichas de Mascotas Rescatadas', ruta: '/mascotas', casoUso: 'CU19', icono: '🐾', descripcion: 'Ingreso, zona de rescate y ficha médica.' },
            { nombre: 'Atención Médica Veterinaria', ruta: '/atenciones-clinicas', casoUso: 'CU20, CU15', icono: '🩺', descripcion: 'Consultas médicas y descargo automático.' },
        ],
    },
    {
        numero: 'P8',
        nombre: 'Adopciones y Seguimiento',
        badgeBg: '#dcfce7',
        badgeColor: '#166534',
        funciones: [
            { nombre: 'Postulantes y Evaluación', ruta: '/postulantes', casoUso: 'CU21', icono: '📋', descripcion: 'Evaluación y scoring de aptitud (0-100 pts).' },
            { nombre: 'Formalización y Visitas', ruta: '/adopciones', casoUso: 'CU22, CU24', icono: '🏠', descripcion: 'Acta de adopción y visitas a 30, 90 y 180 días.' },
        ],
    },
    {
        numero: 'P9',
        nombre: 'Pagos y Donaciones',
        badgeBg: '#f3e8ff',
        badgeColor: '#6b21a8',
        funciones: [
            { nombre: 'Donaciones Físicas y Efectivo', ruta: '/donaciones', casoUso: 'CU23', icono: '🎁', descripcion: 'Recepción de aportes con recibo oficial.' },
            { nombre: 'Pasarela QR y Conciliación', ruta: '/pasarela-pagos', casoUso: 'CU26-CU30', icono: '💳', descripcion: 'QR dinámico, Webhook bancario y arqueo.' },
        ],
    },
    {
        numero: 'P10',
        nombre: 'Indicadores Gerenciales',
        badgeBg: '#e0e7ff',
        badgeColor: '#3730a3',
        funciones: [
            { nombre: 'Dashboard General', ruta: '/dashboard', casoUso: 'Tablero', icono: '📈', descripcion: 'Resumen operativo, alertas y métricas clave.' },
            { nombre: 'Reportes e Indicadores', ruta: '/reportes-gerenciales', casoUso: 'CU25', icono: '📊', descripcion: 'Evolución semestral, rotación y balance.' },
        ],
    },
];

interface MenuHamburguesaProps {
    abierto: boolean;
    onClose: () => void;
}

export default function MenuHamburguesa({ abierto, onClose }: MenuHamburguesaProps) {
    const [filtro, setFiltro] = useState('');
    const [rutaActual, setRutaActual] = useState('');
    const [paquetesAbiertos, setPaquetesAbiertos] = useState<Record<string, boolean>>({});

    useEffect(() => {
        if (typeof window !== 'undefined') {
            const current = window.location.pathname;
            setRutaActual(current);

            // Auto-expandir únicamente el paquete al que pertenece la ruta actual para ubicar al usuario
            const inicial: Record<string, boolean> = {};
            PAQUETES.forEach((p) => {
                const tieneRuta = p.funciones.some((f) => f.ruta === current);
                if (tieneRuta) {
                    inicial[p.numero] = true;
                }
            });
            setPaquetesAbiertos(inicial);
        }

        const handleKeyDown = (e: KeyboardEvent) => {
            if (e.key === 'Escape') onClose();
        };
        window.addEventListener('keydown', handleKeyDown);
        return () => window.removeEventListener('keydown', handleKeyDown);
    }, [abierto, onClose]);

    // Despliegue independiente por paquete
    const togglePaquete = (numero: string) => {
        setPaquetesAbiertos((prev) => ({
            ...prev,
            [numero]: !prev[numero],
        }));
    };

    const paquetesFiltrados = useMemo(() => {
        const query = filtro.toLowerCase().trim();
        if (!query) return PAQUETES;

        return PAQUETES.map((paquete) => {
            const coincidePaquete =
                paquete.nombre.toLowerCase().includes(query) ||
                paquete.numero.toLowerCase().includes(query);

            const funciones = paquete.funciones.filter(
                (f) =>
                    coincidePaquete ||
                    f.nombre.toLowerCase().includes(query) ||
                    f.casoUso.toLowerCase().includes(query) ||
                    f.descripcion.toLowerCase().includes(query)
            );

            return { ...paquete, funciones };
        }).filter((p) => p.funciones.length > 0);
    }, [filtro]);

    // Si hay búsqueda activa, expandir los paquetes que coinciden
    const isSearching = filtro.trim().length > 0;

    if (!abierto) return null;

    return (
        <div
            style={{
                position: 'fixed',
                inset: 0,
                zIndex: 9999,
                backgroundColor: 'rgba(24, 61, 53, 0.65)',
                backdropFilter: 'blur(4px)',
                display: 'flex',
                animation: 'fadeOverlay 0.2s ease',
            }}
            onClick={onClose}
        >
            <aside
                style={{
                    width: '100%',
                    maxWidth: '430px',
                    height: '100vh',
                    backgroundColor: '#183d35',
                    color: '#ffffff',
                    display: 'flex',
                    flexDirection: 'column',
                    boxShadow: '4px 0 28px rgba(0,0,0,0.35)',
                    animation: 'slideFromLeft 0.25s cubic-bezier(0.16, 1, 0.3, 1)',
                    overflow: 'hidden',
                }}
                onClick={(e) => e.stopPropagation()}
            >
                {/* Cabecera Drawer */}
                <div
                    style={{
                        padding: '18px 20px 14px',
                        borderBottom: '1px solid rgba(255, 255, 255, 0.12)',
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '12px',
                        backgroundColor: '#14332c',
                        flexShrink: 0,
                    }}
                >
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                            <span
                                style={{
                                    width: '38px',
                                    height: '38px',
                                    borderRadius: '50%',
                                    backgroundColor: '#e1e89f',
                                    color: '#183d35',
                                    display: 'grid',
                                    placeItems: 'center',
                                    fontWeight: 800,
                                    fontSize: '13px',
                                    boxShadow: '0 2px 6px rgba(0,0,0,0.2)',
                                    flexShrink: 0,
                                }}
                            >
                                LA
                            </span>
                            <div>
                                <h2 style={{ fontFamily: 'Georgia, serif', fontSize: '18px', margin: 0, color: '#ffffff', lineHeight: 1.2 }}>
                                    Los Angelitos
                                </h2>
                                <span style={{ fontSize: '11px', color: 'rgba(255,255,255,0.7)', display: 'block', marginTop: '2px' }}>
                                    Módulos y Casos de Uso (P1 - P10)
                                </span>
                            </div>
                        </div>
                        <button
                            type="button"
                            onClick={onClose}
                            aria-label="Cerrar menú"
                            style={{
                                width: '32px',
                                height: '32px',
                                borderRadius: '50%',
                                border: 'none',
                                backgroundColor: 'rgba(255,255,255,0.12)',
                                color: '#ffffff',
                                cursor: 'pointer',
                                display: 'grid',
                                placeItems: 'center',
                                fontSize: '15px',
                                transition: 'background-color 0.15s ease',
                                flexShrink: 0,
                            }}
                            onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.22)')}
                            onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.12)')}
                        >
                            ✕
                        </button>
                    </div>

                    {/* Buscador de funciones */}
                    <div style={{ position: 'relative' }}>
                        <input
                            type="text"
                            placeholder="Buscar módulo o caso de uso (ej. rescate, QR, vacunas)..."
                            value={filtro}
                            onChange={(e) => setFiltro(e.target.value)}
                            style={{
                                width: '100%',
                                padding: '9px 34px 9px 36px',
                                borderRadius: '6px',
                                border: '1px solid rgba(255,255,255,0.22)',
                                backgroundColor: 'rgba(0, 0, 0, 0.28)',
                                color: '#ffffff',
                                fontSize: '12.5px',
                                outline: 'none',
                                boxSizing: 'border-box',
                                fontFamily: "'Instrument Sans', sans-serif",
                            }}
                        />
                        <span style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', fontSize: '13px', opacity: 0.7 }}>
                            🔍
                        </span>
                        {filtro && (
                            <button
                                type="button"
                                onClick={() => setFiltro('')}
                                style={{
                                    position: 'absolute',
                                    right: '10px',
                                    top: '50%',
                                    transform: 'translateY(-50%)',
                                    background: 'none',
                                    border: 'none',
                                    color: 'rgba(255,255,255,0.7)',
                                    cursor: 'pointer',
                                    fontSize: '12px',
                                }}
                            >
                                ✕
                            </button>
                        )}
                    </div>

                    {/* Subtítulo limpio e informativo */}
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: '11px', color: 'rgba(255,255,255,0.65)' }}>
                        <span>Catálogo de 10 paquetes</span>
                        <span style={{ color: '#e1e89f', fontSize: '10.5px' }}>Toca cada paquete para ver sus CUs</span>
                    </div>
                </div>

                {/* Lista de Paquetes con Despliegue Individual */}
                <nav
                    style={{
                        flex: '1 1 auto',
                        overflowY: 'auto',
                        padding: '14px 16px',
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '10px',
                        minHeight: 0,
                    }}
                >
                    {paquetesFiltrados.length === 0 ? (
                        <div style={{ textAlign: 'center', color: 'rgba(255,255,255,0.65)', padding: '40px 16px', fontSize: '13px' }}>
                            <p style={{ margin: 0, fontWeight: 600 }}>No se encontraron coincidencias para "{filtro}".</p>
                            <p style={{ fontSize: '12px', marginTop: '6px', opacity: 0.7 }}>Prueba con términos como 'rescate', 'adopciones', 'vacunas' o 'QR'.</p>
                        </div>
                    ) : (
                        paquetesFiltrados.map((paquete) => {
                            const estaAbierto = isSearching ? true : !!paquetesAbiertos[paquete.numero];
                            const contieneRutaActiva = paquete.funciones.some((f) => f.ruta === rutaActual);

                            return (
                                <div
                                    key={paquete.numero}
                                    style={{
                                        flexShrink: 0,
                                        width: '100%',
                                        backgroundColor: contieneRutaActiva ? 'rgba(40, 86, 75, 0.55)' : 'rgba(255, 255, 255, 0.05)',
                                        borderRadius: '8px',
                                        border: contieneRutaActiva
                                            ? '1px solid rgba(225, 232, 159, 0.45)'
                                            : '1px solid rgba(255, 255, 255, 0.1)',
                                        overflow: 'hidden',
                                        boxShadow: '0 2px 6px rgba(0, 0, 0, 0.15)',
                                        transition: 'background-color 0.15s ease, border-color 0.15s ease',
                                    }}
                                >
                                    {/* Botón Cabecera de Paquete (Despliegue independiente) */}
                                    <button
                                        type="button"
                                        onClick={() => togglePaquete(paquete.numero)}
                                        aria-expanded={estaAbierto}
                                        style={{
                                            width: '100%',
                                            minHeight: '52px',
                                            padding: '11px 14px',
                                            backgroundColor: estaAbierto ? 'rgba(0, 0, 0, 0.22)' : 'transparent',
                                            border: 'none',
                                            borderBottom: estaAbierto ? '1px solid rgba(255, 255, 255, 0.08)' : 'none',
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'space-between',
                                            gap: '12px',
                                            cursor: 'pointer',
                                            color: '#ffffff',
                                            textAlign: 'left',
                                            boxSizing: 'border-box',
                                            transition: 'background-color 0.15s ease',
                                        }}
                                        onMouseEnter={(e) => {
                                            if (!estaAbierto) e.currentTarget.style.backgroundColor = 'rgba(255, 255, 255, 0.08)';
                                        }}
                                        onMouseLeave={(e) => {
                                            if (!estaAbierto) e.currentTarget.style.backgroundColor = 'transparent';
                                        }}
                                    >
                                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', minWidth: 0, flex: 1 }}>
                                            <span
                                                style={{
                                                    minWidth: '34px',
                                                    height: '24px',
                                                    padding: '0 6px',
                                                    borderRadius: '4px',
                                                    backgroundColor: '#e1e89f',
                                                    color: '#183d35',
                                                    display: 'inline-flex',
                                                    alignItems: 'center',
                                                    justifyContent: 'center',
                                                    fontSize: '11px',
                                                    fontWeight: 800,
                                                    letterSpacing: '0.04em',
                                                    flexShrink: 0,
                                                }}
                                            >
                                                {paquete.numero}
                                            </span>
                                            <div style={{ minWidth: 0, flex: 1 }}>
                                                <div
                                                    style={{
                                                        fontSize: '13.5px',
                                                        color: '#ffffff',
                                                        fontFamily: "'Instrument Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
                                                        fontWeight: 600,
                                                        lineHeight: 1.3,
                                                        whiteSpace: 'nowrap',
                                                        overflow: 'hidden',
                                                        textOverflow: 'ellipsis',
                                                    }}
                                                >
                                                    {paquete.nombre}
                                                </div>
                                                <div style={{ fontSize: '11px', color: 'rgba(255, 255, 255, 0.62)', marginTop: '2px', lineHeight: 1.2 }}>
                                                    {paquete.funciones.length} {paquete.funciones.length === 1 ? 'caso de uso' : 'casos de uso'}
                                                </div>
                                            </div>
                                        </div>

                                        <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flexShrink: 0 }}>
                                            <span
                                                style={{
                                                    fontSize: '11px',
                                                    color: estaAbierto ? '#e1e89f' : 'rgba(255, 255, 255, 0.65)',
                                                    fontWeight: 600,
                                                }}
                                            >
                                                {estaAbierto ? 'Ocultar' : 'Ver CUs'}
                                            </span>
                                            <svg
                                                viewBox="0 0 20 20"
                                                fill="currentColor"
                                                style={{
                                                    width: '15px',
                                                    height: '15px',
                                                    color: estaAbierto ? '#e1e89f' : 'rgba(255, 255, 255, 0.65)',
                                                    transform: estaAbierto ? 'rotate(180deg)' : 'rotate(0deg)',
                                                    transition: 'transform 0.2s ease',
                                                    flexShrink: 0,
                                                }}
                                            >
                                                <path
                                                    fillRule="evenodd"
                                                    d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                                    clipRule="evenodd"
                                                />
                                            </svg>
                                        </div>
                                    </button>

                                    {/* Despliegue de Casos de Uso del Paquete */}
                                    {estaAbierto && (
                                        <div
                                            style={{
                                                display: 'flex',
                                                flexDirection: 'column',
                                                backgroundColor: 'rgba(0, 0, 0, 0.2)',
                                                borderTop: '1px solid rgba(255, 255, 255, 0.06)',
                                            }}
                                        >
                                            {paquete.funciones.map((f, i) => {
                                                const activa = rutaActual === f.ruta;
                                                return (
                                                    <Link
                                                        key={i}
                                                        href={f.ruta}
                                                        onClick={onClose}
                                                        style={{
                                                            flexShrink: 0,
                                                            display: 'flex',
                                                            alignItems: 'flex-start',
                                                            gap: '12px',
                                                            padding: '11px 14px 11px 16px',
                                                            textDecoration: 'none',
                                                            color: activa ? '#ffffff' : 'rgba(255, 255, 255, 0.88)',
                                                            backgroundColor: activa ? 'rgba(40, 86, 75, 0.7)' : 'transparent',
                                                            borderLeft: activa ? '4px solid #e1e89f' : '4px solid transparent',
                                                            borderBottom:
                                                                i < paquete.funciones.length - 1
                                                                    ? '1px solid rgba(255, 255, 255, 0.05)'
                                                                    : 'none',
                                                            transition: 'background-color 0.15s ease',
                                                        }}
                                                        onMouseEnter={(e) => {
                                                            if (!activa) e.currentTarget.style.backgroundColor = 'rgba(255, 255, 255, 0.07)';
                                                        }}
                                                        onMouseLeave={(e) => {
                                                            if (!activa) e.currentTarget.style.backgroundColor = 'transparent';
                                                        }}
                                                    >
                                                        <span style={{ fontSize: '16px', lineHeight: 1.2, marginTop: '2px', flexShrink: 0 }}>
                                                            {f.icono}
                                                        </span>
                                                        <div style={{ flex: 1, minWidth: 0 }}>
                                                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '8px' }}>
                                                                <span
                                                                    style={{
                                                                        fontSize: '12.5px',
                                                                        fontWeight: activa ? 700 : 600,
                                                                        color: '#ffffff',
                                                                    }}
                                                                >
                                                                    {f.nombre}
                                                                </span>
                                                                <span
                                                                    style={{
                                                                        fontSize: '10px',
                                                                        fontWeight: 700,
                                                                        backgroundColor: 'rgba(225, 232, 159, 0.2)',
                                                                        color: '#e1e89f',
                                                                        padding: '2px 6px',
                                                                        borderRadius: '4px',
                                                                        border: '1px solid rgba(225, 232, 159, 0.35)',
                                                                        whiteSpace: 'nowrap',
                                                                        flexShrink: 0,
                                                                    }}
                                                                >
                                                                    {f.casoUso}
                                                                </span>
                                                            </div>
                                                            <p
                                                                style={{
                                                                    margin: '3px 0 0 0',
                                                                    fontSize: '11px',
                                                                    color: 'rgba(255, 255, 255, 0.65)',
                                                                    lineHeight: 1.35,
                                                                }}
                                                            >
                                                                {f.descripcion}
                                                            </p>
                                                        </div>
                                                    </Link>
                                                );
                                            })}
                                        </div>
                                    )}
                                </div>
                            );
                        })
                    )}
                </nav>

                {/* Pie Drawer */}
                <div
                    style={{
                        padding: '13px 18px',
                        borderTop: '1px solid rgba(255, 255, 255, 0.12)',
                        backgroundColor: '#14332c',
                        fontSize: '11.5px',
                        color: 'rgba(255, 255, 255, 0.75)',
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        flexShrink: 0,
                    }}
                >
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                        <span>🐾</span>
                        <span>Refugio Los Angelitos de Edgar</span>
                    </div>
                    <span style={{ color: 'rgba(255, 255, 255, 0.5)' }}>Santa Cruz, Bolivia</span>
                </div>
            </aside>
        </div>
    );
}
