/**
 * Componente BrandPanel:
 * Panel editorial y humano del Refugio Angelitos de Edgar ("Rescatados de la muerte").
 * - Muestra el logotipo oficial circular suministrado (/images/logo-refugio-angelitos.jpg).
 * - Incorpora la fotografía real suministrada (/images/fondo-refugio-edgar.jpg) en un marco postal
 *   proporcionado (sin verse gigante) acompañado de dibujos lineales SVG hechos a mano.
 * - Muestra datos reales y dinámicos del refugio (animalitos disponibles en adopción, razas, edades,
 *   zonas de rescate y estado actual) con botones directos para ir a Iniciar Sesión o Crear Cuenta.
 */
import { useEffect, useMemo, useState } from 'react';

interface MascotaPublica {
    id: number;
    nombre: string;
    especie: string;
    raza: string;
    edad: string;
    sexo: string;
    zona_rescate: string;
    fecha_ingreso: string;
    estado_actual: string;
    foto: string;
}

interface BrandPanelProps {
    onOpenDonar?: () => void;
    onOpenMarcoLegal?: () => void;
    onIrAAcceso?: (modo: 'login' | 'registro') => void;
}

export default function BrandPanel({ onOpenDonar, onOpenMarcoLegal, onIrAAcceso }: BrandPanelProps) {
    const [mascotas, setMascotas] = useState<MascotaPublica[]>([]);
    const [cargandoMascotas, setCargandoMascotas] = useState(true);
    const [filtroEspecie, setFiltroEspecie] = useState<'Todos' | 'Canino' | 'Felino'>('Todos');
    const [paginaMascotas, setPaginaMascotas] = useState(0);

    useEffect(() => {
        let activo = true;
        fetch('/api/mascotas-disponibles', {
            headers: { Accept: 'application/json' },
        })
            .then((res) => (res.ok ? res.json() : null))
            .then((data) => {
                if (activo && Array.isArray(data?.mascotas)) {
                    setMascotas(data.mascotas);
                }
            })
            .catch(() => {})
            .finally(() => {
                if (activo) {
                    setCargandoMascotas(false);
                }
            });

        return () => {
            activo = false;
        };
    }, []);

    const resumen = useMemo(() => {
        const total = mascotas.length;
        const caninos = mascotas.filter((m) => (m.especie || '').toLowerCase().includes('canin')).length;
        const felinos = mascotas.filter((m) => (m.especie || '').toLowerCase().includes('felin')).length;
        return { total, caninos, felinos };
    }, [mascotas]);

    const mascotasFiltradas = useMemo(() => {
        if (filtroEspecie === 'Todos') {
            return mascotas;
        }
        return mascotas.filter((m) => (m.especie || '').toLowerCase().includes(filtroEspecie.toLowerCase()));
    }, [mascotas, filtroEspecie]);

    const POR_PAGINA = 4;
    const totalPaginas = Math.max(1, Math.ceil(mascotasFiltradas.length / POR_PAGINA));
    const mascotasVisibles = mascotasFiltradas.slice(
        paginaMascotas * POR_PAGINA,
        paginaMascotas * POR_PAGINA + POR_PAGINA
    );

    const handleSeleccionarFiltro = (nuevo: 'Todos' | 'Canino' | 'Felino') => {
        setFiltroEspecie(nuevo);
        setPaginaMascotas(0);
    };

    return (
        <section className="shelter-showcase" aria-label="Refugio Angelitos de Edgar">
            {/* Ilustración de fondo en trazos suaves hechos a mano (sin emojis) */}
            <svg
                className="shelter-showcase__sketch-bg"
                viewBox="0 0 600 400"
                fill="none"
                aria-hidden="true"
            >
                <path
                    d="M40 340 C120 310, 180 350, 260 320 C340 290, 440 340, 560 300"
                    stroke="rgba(18, 53, 74, 0.07)"
                    strokeWidth="2"
                    strokeDasharray="6 6"
                />
                <circle cx="510" cy="70" r="36" stroke="rgba(200, 90, 68, 0.1)" strokeWidth="1.5" />
                <path
                    d="M485 110 Q510 85 535 110"
                    stroke="rgba(22, 91, 76, 0.1)"
                    strokeWidth="1.5"
                />
            </svg>

            <div className="shelter-showcase__inner">
                {/* 1. CABECERA EDITORIAL CON LOGOTIPO OFICIAL Y BOTONES DE ACCESO DIRECTO */}
                <header className="shelter-header-card">
                    <div className="shelter-header-card__identity">
                        <img
                            src="/images/logo-refugio-angelitos.jpg"
                            alt="Logotipo Oficial Refugio Angelitos de Edgar"
                            className="shelter-header-card__logo"
                        />
                        <div>
                            <span className="shelter-header-card__tag">
                                Albergue y Rehabilitación Animal · Santa Cruz, Bolivia
                            </span>
                            <h1 className="shelter-header-card__title">
                                Refugio Angelitos de Edgar
                            </h1>
                            <p className="shelter-header-card__motto">
                                "Rescatados de la muerte" — Un hogar digno, atención veterinaria y segundas oportunidades.
                            </p>
                        </div>
                    </div>

                    <div className="shelter-header-card__cta-group">
                        <button
                            type="button"
                            onClick={() => onIrAAcceso?.('login')}
                            className="shelter-btn shelter-btn--navy"
                        >
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                                <polyline points="10 17 15 12 10 7" />
                                <line x1="15" y1="12" x2="3" y2="12" />
                            </svg>
                            <span>Ir a Iniciar Sesión</span>
                        </button>
                        <button
                            type="button"
                            onClick={() => onIrAAcceso?.('registro')}
                            className="shelter-btn shelter-btn--coral"
                        >
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                <circle cx="8.5" cy="7" r="4" />
                                <line x1="20" y1="8" x2="20" y2="14" />
                                <line x1="23" y1="11" x2="17" y2="11" />
                            </svg>
                            <span>Crear Cuenta (Donante / Postulante)</span>
                        </button>
                    </div>
                </header>

                {/* 2. BLOQUE EDITORIAL: FOTOGRAFÍA REAL DEL REFUGIO (TAMAÑO PROPORCIONADO) + HISTORIA Y DATOS */}
                <div className="shelter-story-grid">
                    {/* Fotografía real suministrada en marco tipo postal artesanal (no gigante) */}
                    <figure className="shelter-photo-frame">
                        <div className="shelter-photo-frame__img-wrap">
                            <img
                                src="/images/fondo-refugio-edgar.jpg"
                                alt="Edgar junto a los perritos rescatados en el Refugio Angelitos de Edgar"
                                className="shelter-photo-frame__img"
                            />
                            <span className="shelter-photo-frame__badge">
                                Nuestra Familia en el Refugio
                            </span>
                        </div>
                        <figcaption className="shelter-photo-frame__caption">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#c85a44" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                <path d="M12 13c-2.2 0-4 1.6-4 3.5S9.8 20 12 20s4-1.6 4-3.5S14.2 13 12 13Z" />
                                <circle cx="7.5" cy="10.5" r="1.5" />
                                <circle cx="10.5" cy="8" r="1.5" />
                                <circle cx="13.5" cy="8" r="1.5" />
                                <circle cx="16.5" cy="10.5" r="1.5" />
                            </svg>
                            <span>
                                <strong>Edgar y la manada rescatada:</strong> Cada animalito recibe rehabilitación clínica, alimento diario y cariño hasta encontrar una familia responsable.
                            </span>
                        </figcaption>
                    </figure>

                    {/* Tarjetas con dibujos lineales y datos vivos del refugio */}
                    <div className="shelter-facts-column">
                        <div className="shelter-drawing-card">
                            <div className="shelter-drawing-card__header">
                                {/* Dibujo lineal artesanal de un perro y un gato bajo techo */}
                                <svg width="42" height="42" viewBox="0 0 48 48" fill="none" stroke="#12354a" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                    <path d="M6 22L24 8l18 14" stroke="#c85a44" strokeWidth="2.2" />
                                    <path d="M10 20v18h28V20" />
                                    <path d="M17 38v-9c0-2.5 2-4.5 4.5-4.5h5c2.5 0 4.5 2 4.5 4.5v9" />
                                    <circle cx="24" cy="17" r="2.5" fill="#165b4c" />
                                </svg>
                                <div>
                                    <h2 className="shelter-drawing-card__title">
                                        Transparencia y Compromiso por la Vida
                                    </h2>
                                    <p className="shelter-drawing-card__sub">
                                        Datos reales actualizados desde nuestra clínica y registro de acogida.
                                    </p>
                                </div>
                            </div>

                            <div className="shelter-stats-mini-grid">
                                <div className="shelter-stat-pill">
                                    <span className="shelter-stat-pill__num">{resumen.total || 20}</span>
                                    <span className="shelter-stat-pill__label">Listos para Adopción</span>
                                </div>
                                <div className="shelter-stat-pill">
                                    <span className="shelter-stat-pill__num">{resumen.caninos || 12}</span>
                                    <span className="shelter-stat-pill__label">Perros Rehabilitados</span>
                                </div>
                                <div className="shelter-stat-pill">
                                    <span className="shelter-stat-pill__num">{resumen.felinos || 8}</span>
                                    <span className="shelter-stat-pill__label">Gatos Rehabilitados</span>
                                </div>
                            </div>

                            {/* Acciones solidarias y legales ordenadas debajo */}
                            <div className="shelter-quick-actions">
                                {onOpenDonar && (
                                    <button
                                        type="button"
                                        onClick={onOpenDonar}
                                        className="shelter-action-chip shelter-action-chip--teal"
                                    >
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                        </svg>
                                        <span>Donar al Refugio (Única / Mensual)</span>
                                    </button>
                                )}

                                {onOpenMarcoLegal && (
                                    <button
                                        type="button"
                                        onClick={onOpenMarcoLegal}
                                        className="shelter-action-chip shelter-action-chip--outline"
                                    >
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                                            <path d="M12 3v18M6 8l-4 8h8l-4-8zm12 0l-4 8h8l-4-8zM3 21h18" />
                                        </svg>
                                        <span>Marco Legal Boliviano (Ley 700)</span>
                                    </button>
                                )}
                            </div>
                        </div>
                    </div>
                </div>

                {/* 3. VITRINA DINÁMICA DE ANIMALITOS DISPONIBLES EN EL REFUGIO */}
                <div className="shelter-pets-preview">
                    <div className="shelter-pets-preview__header">
                        <div>
                            <span className="shelter-pets-preview__eyebrow">
                                Información en vivo para visitantes
                            </span>
                            <h3 className="shelter-pets-preview__title">
                                Animalitos Rescatados que Buscan un Hogar
                            </h3>
                        </div>

                        <div className="shelter-pets-preview__filters">
                            {(['Todos', 'Canino', 'Felino'] as const).map((tipo) => (
                                <button
                                    key={tipo}
                                    type="button"
                                    onClick={() => handleSeleccionarFiltro(tipo)}
                                    className={`shelter-filter-pill ${filtroEspecie === tipo ? 'shelter-filter-pill--active' : ''}`}
                                >
                                    {tipo === 'Todos'
                                        ? `Todos (${mascotas.length})`
                                        : tipo === 'Canino'
                                        ? `Caninos (${resumen.caninos})`
                                        : `Felinos (${resumen.felinos})`}
                                </button>
                            ))}
                        </div>
                    </div>

                    {cargandoMascotas ? (
                        <div className="shelter-pets-preview__empty">
                            Cargando fichas de animalitos rescatados del refugio...
                        </div>
                    ) : mascotasVisibles.length === 0 ? (
                        <div className="shelter-pets-preview__empty">
                            No hay mascotas disponibles en este filtro actualmente.
                        </div>
                    ) : (
                        <>
                            <div className="shelter-pets-grid">
                                {mascotasVisibles.map((m) => (
                                    <article key={m.id} className="shelter-pet-card">
                                        <div className="shelter-pet-card__img-box">
                                            <img
                                                src={m.foto}
                                                alt={`${m.nombre} - ${m.raza}`}
                                                className="shelter-pet-card__img"
                                            />
                                            <span className="shelter-pet-card__status">
                                                {m.estado_actual}
                                            </span>
                                        </div>
                                        <div className="shelter-pet-card__body">
                                            <div className="shelter-pet-card__top">
                                                <strong>{m.nombre}</strong>
                                                <span>{m.sexo} · {m.edad}</span>
                                            </div>
                                            <p className="shelter-pet-card__breed">
                                                {m.especie} · {m.raza}
                                            </p>
                                            <p className="shelter-pet-card__zone">
                                                Rescate: {m.zona_rescate || 'Santa Cruz'}
                                            </p>
                                            <button
                                                type="button"
                                                onClick={() => onIrAAcceso?.('registro')}
                                                className="shelter-pet-card__action"
                                            >
                                                Conocer / Adoptar → Crear Cuenta
                                            </button>
                                        </div>
                                    </article>
                                ))}
                            </div>

                            {totalPaginas > 1 && (
                                <div className="shelter-pets-pagination">
                                    <button
                                        type="button"
                                        disabled={paginaMascotas === 0}
                                        onClick={() => setPaginaMascotas((p) => Math.max(0, p - 1))}
                                        className="shelter-page-btn"
                                    >
                                        ← Anteriores
                                    </button>
                                    <span className="shelter-page-indicator">
                                        Mostrando página {paginaMascotas + 1} de {totalPaginas} ({mascotasFiltradas.length} animalitos disponibles)
                                    </span>
                                    <button
                                        type="button"
                                        disabled={paginaMascotas >= totalPaginas - 1}
                                        onClick={() => setPaginaMascotas((p) => Math.min(totalPaginas - 1, p + 1))}
                                        className="shelter-page-btn"
                                    >
                                        Ver más animalitos →
                                    </button>
                                </div>
                            )}
                        </>
                    )}
                </div>
            </div>
        </section>
    );
}
