import { useState } from 'react';

interface LegalComplianceModalProps {
    open: boolean;
    onClose: () => void;
}

interface NormaBoliviana {
    id: string;
    titulo: string;
    subtitulo: string;
    normaPrincipal: string;
    reglamento: string;
    articulosClave: { articulo: string; detalle: string }[];
    porQueSeRealiza: string;
    comoSeImplementa: string[];
    moduloSistema: string;
}

const NORMATIVAS_BOLIVIANAS: NormaBoliviana[] = [
    {
        id: 'ley164',
        titulo: 'Ley N° 164 y D.S. N° 1793',
        subtitulo: 'Validez Jurídica Digital, Integridad de Datos y Auditoría Forense',
        normaPrincipal: 'Ley N° 164 (Ley General de Telecomunicaciones, Tecnologías de Información y Comunicación, 8 de agosto de 2011).',
        reglamento: 'Decreto Supremo N° 1793 (Reglamento para el Desarrollo de TIC, 13 de noviembre de 2013).',
        articulosClave: [
            {
                articulo: 'Art. 78 (Ley 164)',
                detalle: 'Otorga validez jurídica y probatoria a los actos realizados mediante documentos digitales y mensajes electrónicos de datos.',
            },
            {
                articulo: 'Art. 80 y 81 (Ley 164)',
                detalle: 'Define los principios de integridad, autenticidad y no repudio de los documentos electrónicos.',
            },
            {
                articulo: 'Art. 18 y 21 (D.S. 1793)',
                detalle: 'Establece la obligatoriedad de mecanismos de seguridad, trazabilidad y protección de datos personales en sistemas informáticos.',
            },
        ],
        porQueSeRealiza:
            'Para que los expedientes clínicos, actas de adopción, facturas y reportes emitidos por el refugio tengan valor probatorio ante autoridades judiciales o administrativas en Bolivia, demostrando que ningún registro fue alterado tras su creación.',
        comoSeImplementa: [
            'Tabla auditoria_forense inmutable en PostgreSQL (sin permisos de modificación ni eliminación).',
            'Cálculo de firma de integridad SHA-256 en cada registro crítico y documento PDF exportado.',
            'Registro cronológico de IP, usuario responsable, fecha/hora exacta y estados JSONB anterior y nuevo.',
        ],
        moduloSistema: 'Auditoría Forense y Bitácora Cronológica',
    },
    {
        id: 'ley2492',
        titulo: 'Ley N° 2492, Ley N° 843 y RND N° 102100000011',
        subtitulo: 'Facturación Legal, Código QR y Registro de Compras y Ventas (SIN)',
        normaPrincipal: 'Ley N° 2492 (Código Tributario Boliviano) y Ley N° 843 (Texto Ordenado de Reforma Tributaria).',
        reglamento: 'Resolución Normativa de Directorio (RND) N° 102100000011 del Servicio de Impuestos Nacionales (SIN) y Ley N° 453.',
        articulosClave: [
            {
                articulo: 'Art. 70 numeral 4 (Ley 2492)',
                detalle: 'Obligación de respaldar las actividades y operaciones gravadas mediante libros, registros, facturas y documentos equivalentes.',
            },
            {
                articulo: 'Art. 4 y 12 (Ley 843)',
                detalle: 'Perfeccionamiento del hecho generador del IVA y obligación de emisión de factura o nota fiscal.',
            },
            {
                articulo: 'Cap. IV y V (RND 102100000011)',
                detalle: 'Regulación de modalidades de facturación, Código QR, leyendas de protección al consumidor (Ley N° 453) y Registro de Compras y Ventas (RCV).',
            },
        ],
        porQueSeRealiza:
            'Cuando el refugio realiza prestaciones veterinarias externas, venta de accesorios o servicios sujetos a tributación, debe emitir comprobantes válidos ante el SIN, controlar el rango de dosificación, anular facturas sin perder correlativos y exportar el Registro de Compras y Ventas mensual.',
        comoSeImplementa: [
            'Bloqueo pesimista (lockForUpdate) en PostgreSQL sobre dosificaciones_fiscales para garantizar correlatividad única.',
            'Generación del Código de Control y cadena de Código QR delimitada por pipes (|) exigida por el SIN.',
            'Exportación del Libro de Compras y Ventas IVA (RCV) en CSV donde las facturas anuladas conservan su correlativo con estado A e importe 0.00.',
        ],
        moduloSistema: 'Dosificación Fiscal, Facturación Legal y Libro IVA',
    },
    {
        id: 'ley700',
        titulo: 'Ley N° 700 y Ley Municipal GAMSCS N° 038/2015',
        subtitulo: 'Defensa Animal, Tenencia Responsable y Trazabilidad de Adopciones',
        normaPrincipal: 'Ley N° 700 (Ley para la Defensa de los Animales contra Actos de Crueldad y Maltrato, 1 de junio de 2015).',
        reglamento: 'Ley Autonómica Municipal GAMSCS N° 038/2015 (Tenencia Responsable de Animales de Compañía — Santa Cruz de la Sierra).',
        articulosClave: [
            {
                articulo: 'Art. 3 y 4 (Ley 700)',
                detalle: 'Derecho de los animales a recibir atención veterinaria, alimentación adecuada y protección contra el abandono.',
            },
            {
                articulo: 'Art. 10 (Ley 700)',
                detalle: 'Tipificación y sanción penal de actos de crueldad y biocidio.',
            },
            {
                articulo: 'Art. 14, 18 y 22 (Ley Mun. 038/2015)',
                detalle: 'Registro obligatorio de animales rescatados, esterilización/vacunación antirrábica, compromiso de tenencia responsable y seguimiento post-adopción.',
            },
        ],
        porQueSeRealiza:
            'Para respaldar legalmente la evaluación de idoneidad de postulantes, exigir el compromiso firmado de esterilización/vacunación y obligar a las visitas periódicas de seguimiento post-adopción, sirviendo el expediente digital como prueba legal en caso de rescate por incumplimiento o maltrato.',
        comoSeImplementa: [
            'Validación obligatoria de puntaje de idoneidad antes de aprobar una solicitud de adopción.',
            'Generación automática del Acta de Compromiso de Tenencia Responsable en PDF citando la Ley N° 700 y la Ley Municipal GAMSCS N° 038/2015.',
            'Programación y registro de visitas de seguimiento post-adopción en el historial de la mascota.',
        ],
        moduloSistema: 'Rescate, Adopciones y Seguimiento Post-Adopción',
    },
    {
        id: 'ley830',
        titulo: 'Ley N° 830 y Normativa SENASAG',
        subtitulo: 'Sanidad Veterinaria, Control de Fármacos FEFO y Dosificación Clínica',
        normaPrincipal: 'Ley N° 830 (Ley de Sanidad Agropecuaria e Inocuidad Alimentaria, 6 de septiembre de 2016).',
        reglamento: 'SENASAG (Reglamento de Registro y Control de Productos de Uso Veterinario) y normativa COMVETBOL.',
        articulosClave: [
            {
                articulo: 'Art. 8 y 15 (Ley 830)',
                detalle: 'Control zoosanitario, trazabilidad de productos biológicos y fármacos veterinarios, y prohibición de uso o suministro de insumos vencidos.',
            },
            {
                articulo: 'Ejercicio Profesional (COMVETBOL)',
                detalle: 'Toda prescripción farmacológica debe ser calculada según peso y especie, respaldada por un Médico Veterinario.',
            },
        ],
        porQueSeRealiza:
            'Para prevenir negligencia médica por sobredosificación, bloquear automáticamente la administración de medicamentos caducados y garantizar trazabilidad exacta de qué lote de vacuna o fármaco se aplicó a cada animal rescatado.',
        comoSeImplementa: [
            'Calculadora posológica (mg/kg a ml) con alertas de toxicidad por especie (por ejemplo en felinos).',
            'Bloqueo estricto en servidor y base de datos que impide asignar lotes vencidos y aplica rotación FEFO (First Expired, First Out).',
            'Vinculación obligatoria del Médico Veterinario responsable y generación de cronograma de tomas.',
        ],
        moduloSistema: 'Dosificación Clínica FEFO e Historial Clínico',
    },
    {
        id: 'ley351',
        titulo: 'Ley N° 351 y Ley Departamental N° 50 (Santa Cruz)',
        subtitulo: 'Personalidades Jurídicas, Transparencia y Rendición de Cuentas',
        normaPrincipal: 'Ley N° 351 (Ley de Otorgación de Personalidades Jurídicas, 19 de marzo de 2013) y D.S. N° 1597.',
        reglamento: 'Ley Departamental N° 50 de Santa Cruz (Asociaciones y Fundaciones sin fines de lucro).',
        articulosClave: [
            {
                articulo: 'Art. 7 y 11 (Ley 351)',
                detalle: 'Obligación de destinar la totalidad de ingresos y donaciones exclusivamente al cumplimiento del objeto social (rescate y protección animal), prohibiendo su distribución entre miembros.',
            },
            {
                articulo: 'Transparencia y Control Social',
                detalle: 'Deber de rendir cuentas documentadas sobre el origen de donaciones (monetarias y en especie) y su ejecución operativa ante entidades reguladoras y benefactores.',
            },
        ],
        porQueSeRealiza:
            'Para dotar al refugio "Los Angelitos de Edgar" de transparencia institucional frente a donantes, empresas patrocinadoras, la Gobernación de Santa Cruz y el Viceministerio de Autonomías, demostrando que cada boliviano o insumo donado se invirtió íntegramente en los animales.',
        comoSeImplementa: [
            'Consolidación de ingresos por donaciones monetarias, valorización de insumos en especie y egresos operativos.',
            'Cierre de periodos y generación de Estados Financieros certificados con huella criptográfica SHA-256.',
            'Emisión de comprobantes oficiales de donación y reportes PDF con firma de transparencia institucional.',
        ],
        moduloSistema: 'Donaciones, Rendición de Cuentas y Reportes Oficiales',
    },
];

export default function LegalComplianceModal({ open, onClose }: LegalComplianceModalProps) {
    const [activaId, setActivaId] = useState<string>('ley164');

    if (!open) {
        return null;
    }

    const normaActiva = NORMATIVAS_BOLIVIANAS.find((n) => n.id === activaId) ?? NORMATIVAS_BOLIVIANAS[0];

    return (
        <div
            role="dialog"
            aria-modal="true"
            aria-labelledby="marco-legal-titulo"
            style={{
                position: 'fixed',
                inset: 0,
                zIndex: 10050,
                backgroundColor: 'rgba(20, 35, 30, 0.72)',
                backdropFilter: 'blur(4px)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                padding: '16px',
            }}
            onClick={onClose}
        >
            <div
                style={{
                    backgroundColor: '#ffffff',
                    color: '#1e293b',
                    borderRadius: '18px',
                    width: '100%',
                    maxWidth: '940px',
                    maxHeight: '90vh',
                    display: 'flex',
                    flexDirection: 'column',
                    overflow: 'hidden',
                    boxShadow: '0 24px 60px rgba(0, 0, 0, 0.28)',
                    border: '1px solid #d5e2dc',
                }}
                onClick={(e) => e.stopPropagation()}
            >
                <div
                    style={{
                        padding: '18px 24px',
                        background: 'linear-gradient(135deg, #243d34 0%, #376152 100%)',
                        color: '#ffffff',
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        gap: '12px',
                    }}
                >
                    <div>
                        <span style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', textTransform: 'uppercase', color: '#a7f3d0' }}>
                            Estado Plurinacional de Bolivia · Santa Cruz de la Sierra
                        </span>
                        <h2 id="marco-legal-titulo" style={{ margin: '2px 0 0', fontSize: '20px', fontWeight: 800 }}>
                            Marco Legal Boliviano y Transparencia del Refugio
                        </h2>
                    </div>
                    <button
                        type="button"
                        onClick={onClose}
                        aria-label="Cerrar marco legal"
                        style={{
                            border: 'none',
                            backgroundColor: 'rgba(255, 255, 255, 0.16)',
                            color: '#ffffff',
                            borderRadius: '10px',
                            padding: '8px 14px',
                            fontWeight: 700,
                            cursor: 'pointer',
                        }}
                    >
                        Cerrar
                    </button>
                </div>

                <div style={{ padding: '14px 24px', borderBottom: '1px solid #e2e8f0', backgroundColor: '#f8faf9', display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                    {NORMATIVAS_BOLIVIANAS.map((norma) => {
                        const seleccionada = norma.id === normaActiva.id;
                        return (
                            <button
                                key={norma.id}
                                type="button"
                                onClick={() => setActivaId(norma.id)}
                                style={{
                                    padding: '8px 13px',
                                    borderRadius: '999px',
                                    border: seleccionada ? '1px solid #243d34' : '1px solid #cbd5e1',
                                    backgroundColor: seleccionada ? '#243d34' : '#ffffff',
                                    color: seleccionada ? '#ffffff' : '#334155',
                                    fontSize: '12px',
                                    fontWeight: 700,
                                    cursor: 'pointer',
                                }}
                            >
                                {norma.titulo}
                            </button>
                        );
                    })}
                </div>

                <div style={{ padding: '22px 24px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '18px' }}>
                    <div style={{ padding: '16px', borderRadius: '12px', backgroundColor: '#f1f6f3', border: '1px solid #d5e2dc' }}>
                        <h3 style={{ margin: 0, fontSize: '18px', fontWeight: 800, color: '#1d352d' }}>{normaActiva.titulo}</h3>
                        <p style={{ margin: '4px 0 10px', fontSize: '14px', fontWeight: 600, color: '#376152' }}>{normaActiva.subtitulo}</p>
                        <div style={{ fontSize: '13px', lineHeight: 1.5, color: '#334155' }}>
                            <div><strong>Norma Principal:</strong> {normaActiva.normaPrincipal}</div>
                            <div><strong>Reglamentación:</strong> {normaActiva.reglamento}</div>
                            <div><strong>Aplicación en el Sistema:</strong> {normaActiva.moduloSistema}</div>
                        </div>
                    </div>

                    <div>
                        <h4 style={{ margin: '0 0 8px', fontSize: '14px', fontWeight: 800, color: '#0f172a', textTransform: 'uppercase' }}>
                            Artículos y Disposiciones que Respaldan el Sistema
                        </h4>
                        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '10px' }}>
                            {normaActiva.articulosClave.map((art) => (
                                <div key={art.articulo} style={{ padding: '12px', borderRadius: '10px', border: '1px solid #e2e8f0', backgroundColor: '#ffffff' }}>
                                    <div style={{ fontSize: '13px', fontWeight: 800, color: '#243d34', marginBottom: '4px' }}>{art.articulo}</div>
                                    <div style={{ fontSize: '12.5px', lineHeight: 1.45, color: '#475569' }}>{art.detalle}</div>
                                </div>
                            ))}
                        </div>
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '14px' }}>
                        <div style={{ padding: '14px', borderRadius: '10px', backgroundColor: '#fffbeb', border: '1px solid #fde68a' }}>
                            <h4 style={{ margin: '0 0 6px', fontSize: '13px', fontWeight: 800, color: '#92400e' }}>
                                ¿Por qué se implementa en "Los Angelitos de Edgar"?
                            </h4>
                            <p style={{ margin: 0, fontSize: '13px', lineHeight: 1.5, color: '#78350f' }}>{normaActiva.porQueSeRealiza}</p>
                        </div>

                        <div style={{ padding: '14px', borderRadius: '10px', backgroundColor: '#f8fafc', border: '1px solid #cbd5e1' }}>
                            <h4 style={{ margin: '0 0 6px', fontSize: '13px', fontWeight: 800, color: '#1e293b' }}>
                                Garantía Técnica en el Sistema
                            </h4>
                            <ul style={{ margin: 0, paddingLeft: '18px', fontSize: '12.5px', lineHeight: 1.55, color: '#334155' }}>
                                {normaActiva.comoSeImplementa.map((item) => (
                                    <li key={item}>{item}</li>
                                ))}
                            </ul>
                        </div>
                    </div>

                    <div>
                        <h4 style={{ margin: '0 0 8px', fontSize: '14px', fontWeight: 800, color: '#0f172a', textTransform: 'uppercase' }}>
                            Resumen Integral de Cumplimiento Normativo
                        </h4>
                        <div style={{ overflowX: 'auto' }}>
                            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '12.5px' }}>
                                <thead>
                                    <tr style={{ backgroundColor: '#f1f5f9', textAlign: 'left' }}>
                                        <th style={{ padding: '8px 10px', borderBottom: '1px solid #cbd5e1' }}>Ley / Normativa</th>
                                        <th style={{ padding: '8px 10px', borderBottom: '1px solid #cbd5e1' }}>Módulo del Sistema</th>
                                        <th style={{ padding: '8px 10px', borderBottom: '1px solid #cbd5e1' }}>Resguardo Legal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {NORMATIVAS_BOLIVIANAS.map((n) => (
                                        <tr key={n.id} style={{ borderBottom: '1px solid #e2e8f0' }}>
                                            <td style={{ padding: '8px 10px', fontWeight: 700, color: '#243d34' }}>{n.titulo}</td>
                                            <td style={{ padding: '8px 10px', color: '#334155' }}>{n.moduloSistema}</td>
                                            <td style={{ padding: '8px 10px', color: '#475569' }}>{n.subtitulo}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

