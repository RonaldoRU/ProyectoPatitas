/**
 * Componente VoiceCommandAssistant:
 * Asistente por Comando de Voz e Inteligencia Operativa especializado en generar Reportes PDF específicos
 * del Refugio Angelitos de Edgar con respuesta rápida.
 */
import { useEffect, useRef, useState } from 'react';

interface IWindowSpeech extends Window {
    SpeechRecognition?: any;
    webkitSpeechRecognition?: any;
}

interface ReporteResumenItem {
    etiqueta: string;
    valor: string;
}

interface ReportePDFPayload {
    tipo_reporte: string;
    titulo: string;
    subtitulo: string;
    generado_por: string;
    fecha_generacion: string;
    resumen: ReporteResumenItem[];
    columnas: string[];
    filas: string[][];
}

interface RespuestaIA {
    accion: string;
    mensaje_hablado: string;
    motor_usado?: string;
    herramienta_usada?: string | null;
    reporte?: ReportePDFPayload | null;
}

const COMANDOS_ESPECIFICOS = [
    { etiqueta: 'Perros en Adopción', comando: 'reporte de perros disponibles en adopcion' },
    { etiqueta: 'Gatos en Adopción', comando: 'reporte de gatos disponibles en adopcion' },
    { etiqueta: 'Stock Crítico', comando: 'reporte de inventario con stock bajo' },
    { etiqueta: 'Vencimientos FEFO', comando: 'reporte de medicamentos próximos a vencer' },
    { etiqueta: 'Visitas Pendientes', comando: 'reporte de visitas de seguimiento pendientes' },
    { etiqueta: 'Postulantes (Todos)', comando: 'reporte de postulantes a adopcion' },
    { etiqueta: 'Postulantes Pendientes', comando: 'reporte de postulantes pendientes' },
    { etiqueta: 'Atenciones Clínicas', comando: 'reporte de atenciones clínicas veterinarias' },
    { etiqueta: 'Donaciones', comando: 'reporte de donaciones recibidas' },
    { etiqueta: 'Libro IVA', comando: 'reporte de facturacion libro iva este mes' },
    { etiqueta: 'Compras a Proveedores', comando: 'reporte de compras a proveedores' },
    { etiqueta: 'Mermas de Inventario', comando: 'reporte de mermas de inventario' },
    { etiqueta: 'Informe Gerencial', comando: 'reporte gerencial consolidado' },
];

const escaparHtml = (valor: string): string =>
    valor
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');

export default function VoiceCommandAssistant() {
    const [escuchando, setEscuchando] = useState(false);
    const [procesandoIA, setProcesandoIA] = useState(false);
    const [mensaje, setMensaje] = useState<string>('');
    const [panelRapidoAbierto, setPanelRapidoAbierto] = useState(false);
    const [textoManual, setTextoManual] = useState('');
    const [reporteModal, setReporteModal] = useState<ReportePDFPayload | null>(null);

    const recognitionRef = useRef<any>(null);
    const mediaRecorderRef = useRef<MediaRecorder | null>(null);
    const audioChunksRef = useRef<Blob[]>([]);
    const timerSilencioRef = useRef<any>(null);
    const audioEnviadoRef = useRef<boolean>(false);

    // Inicializar reconocedor de voz Web Speech (motor instantáneo)
    useEffect(() => {
        const win = window as unknown as IWindowSpeech;
        const SpeechClass = win.SpeechRecognition || win.webkitSpeechRecognition;

        if (SpeechClass) {
            try {
                const recognition = new SpeechClass();
                recognition.lang = navigator.language || 'es-BO';
                recognition.continuous = false;
                recognition.interimResults = false;

                recognition.onresult = (event: any) => {
                    const transcript = event.results[0][0].transcript;
                    if (transcript && !audioEnviadoRef.current) {
                        audioEnviadoRef.current = true;
                        detenerGrabacion();
                        setMensaje(`"${transcript}"`);
                        enviarComandoTexto(transcript);
                    }
                };

                recognition.onerror = () => {
                    // MediaRecorder actúa como respaldo automático
                };

                recognitionRef.current = recognition;
            } catch {
                // Navegador sin soporte Web Speech API
            }
        }
    }, []);

    const darRespuestaVoz = (texto: string) => {
        if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
            const utterance = new SpeechSynthesisUtterance(texto);
            utterance.lang = 'es-ES';
            utterance.rate = 1.08;
            window.speechSynthesis.speak(utterance);
        }
    };

    const construirHtmlReporte = (reporte: ReportePDFPayload): string => {
        const tarjetasResumen = (reporte.resumen || [])
            .map(
                (item) => `
                <div class="kpi-card">
                    <div class="kpi-val">${escaparHtml(String(item.valor ?? '-'))}</div>
                    <div class="kpi-lbl">${escaparHtml(String(item.etiqueta ?? ''))}</div>
                </div>
            `,
            )
            .join('');

        const encabezados = (reporte.columnas || [])
            .map((col) => `<th>${escaparHtml(String(col))}</th>`)
            .join('');

        const filasHtml =
            (reporte.filas || []).length > 0
                ? reporte.filas
                      .map(
                          (fila) => `
                    <tr>
                        ${fila.map((celda) => `<td>${escaparHtml(String(celda ?? '-'))}</td>`).join('')}
                    </tr>
                `,
                      )
                      .join('')
                : `<tr><td colspan="${Math.max(1, (reporte.columnas || []).length)}" style="text-align:center; padding: 18px; color: #526068;">No se encontraron registros para los filtros solicitados.</td></tr>`;

        return `
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <title>${escaparHtml(reporte.titulo)} - Refugio Angelitos de Edgar</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@500;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
                <style>
                    body { font-family: 'Outfit', -apple-system, BlinkMacSystemFont, sans-serif; padding: 32px; color: #16262e; background: #ffffff; font-size: 14px; }
                    .header { border-bottom: 2px solid #12354a; padding-bottom: 14px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: flex-end; gap: 16px; }
                    .title { color: #12354a; font-size: 22px; font-weight: 800; margin: 0; }
                    .subtitle { margin: 4px 0 0; color: #526068; font-size: 13.5px; font-weight: 500; }
                    .meta { text-align: right; font-size: 12px; color: #526068; line-height: 1.5; font-family: 'JetBrains Mono', monospace; }
                    .kpis { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 12px; margin-bottom: 22px; }
                    .kpi-card { background: #ffffff; border: 1px solid #dde1e4; border-radius: 8px; padding: 12px; text-align: center; }
                    .kpi-val { font-size: 20px; font-weight: 700; color: #12354a; font-family: 'JetBrains Mono', monospace; }
                    .kpi-lbl { font-size: 11px; color: #526068; text-transform: uppercase; font-weight: 700; letter-spacing: 0.05em; margin-top: 4px; }
                    table { width: 100%; border-collapse: collapse; margin-bottom: 24px; font-size: 13px; }
                    th { background: #ffffff; color: #12354a; border-bottom: 2px solid #12354a; padding: 10px; text-align: left; font-size: 11.5px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; }
                    td { padding: 9px 10px; border-bottom: 1px solid #eef0f2; color: #16262e; }
                    @media print { .no-print { display: none; } body { padding: 14px; } }
                </style>
            </head>
            <body>
                <div class="no-print" style="margin-bottom: 20px; display: flex; gap: 10px;">
                    <button onclick="window.print()" style="padding: 10px 20px; background-color: #12354a; color: white; border: none; border-radius: 6px; font-weight: 700; cursor: pointer;">Imprimir / Guardar en PDF</button>
                    <button onclick="window.close()" style="padding: 10px 20px; background-color: #ffffff; color: #12354a; border: 1px solid #cbd5e1; border-radius: 6px; font-weight: 600; cursor: pointer;">Cerrar</button>
                </div>
                <div class="header">
                    <div>
                        <h1 class="title">REFUGIO ANGELITOS DE EDGAR — ${escaparHtml(reporte.titulo.toUpperCase())}</h1>
                        <p class="subtitle">${escaparHtml(reporte.subtitulo)}</p>
                    </div>
                    <div class="meta">
                        <div>Generado por: <strong>${escaparHtml(reporte.generado_por)}</strong></div>
                        <div>Fecha: ${escaparHtml(reporte.fecha_generacion)}</div>
                    </div>
                </div>
                ${tarjetasResumen ? `<div class="kpis">${tarjetasResumen}</div>` : ''}
                <table>
                    <thead>
                        <tr>${encabezados}</tr>
                    </thead>
                    <tbody>
                        ${filasHtml}
                    </tbody>
                </table>
            </body>
            </html>
        `;
    };

    const imprimirEnIframe = (reporte: ReportePDFPayload) => {
        const iframe = document.createElement('iframe');
        iframe.style.position = 'fixed';
        iframe.style.right = '0';
        iframe.style.bottom = '0';
        iframe.style.width = '0';
        iframe.style.height = '0';
        iframe.style.border = '0';
        document.body.appendChild(iframe);

        const doc = iframe.contentWindow?.document;
        if (doc) {
            doc.open();
            doc.write(construirHtmlReporte(reporte));
            doc.close();
            setTimeout(() => {
                iframe.contentWindow?.focus();
                iframe.contentWindow?.print();
                setTimeout(() => iframe.remove(), 1500);
            }, 250);
        } else {
            iframe.remove();
        }
    };

    const abrirReportePDF = (reporte: ReportePDFPayload) => {
        setReporteModal(reporte);
        setPanelRapidoAbierto(false);
    };

    // Iniciar captura de voz
    const iniciarVoz = async () => {
        audioEnviadoRef.current = false;
        setMensaje('Escuchando... Pide un reporte específico (ej: "reporte de perros disponibles", "visitas pendientes", "stock crítico")...');
        setEscuchando(true);

        if (recognitionRef.current) {
            try {
                recognitionRef.current.start();
            } catch {
                // Ignorar si ya estaba iniciado
            }
        }

        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
                audioChunksRef.current = [];

                let mimeType = 'audio/webm';
                if (MediaRecorder.isTypeSupported('audio/webm;codecs=opus')) {
                    mimeType = 'audio/webm;codecs=opus';
                } else if (MediaRecorder.isTypeSupported('audio/mp4')) {
                    mimeType = 'audio/mp4';
                }

                const recorder = new MediaRecorder(stream, { mimeType });

                recorder.ondataavailable = (e) => {
                    if (e.data.size > 0) {
                        audioChunksRef.current.push(e.data);
                    }
                };

                recorder.onstop = async () => {
                    stream.getTracks().forEach((track) => track.stop());

                    if (!audioEnviadoRef.current && audioChunksRef.current.length > 0) {
                        audioEnviadoRef.current = true;
                        const audioBlob = new Blob(audioChunksRef.current, { type: mimeType });
                        await enviarAudioGemini(audioBlob, mimeType);
                    }
                };

                recorder.start();
                mediaRecorderRef.current = recorder;

                timerSilencioRef.current = setTimeout(() => {
                    detenerGrabacion();
                }, 3200);
            } catch (err) {
                console.warn('Permiso de micrófono o MediaRecorder no disponible:', err);
                setMensaje('Habilita el micrófono o usa los reportes rápidos.');
                setEscuchando(false);
            }
        }
    };

    const detenerGrabacion = () => {
        if (timerSilencioRef.current) clearTimeout(timerSilencioRef.current);

        if (mediaRecorderRef.current && mediaRecorderRef.current.state !== 'inactive') {
            try {
                mediaRecorderRef.current.stop();
            } catch {
                // Ignorar si ya se detuvo
            }
        }

        if (recognitionRef.current) {
            try {
                recognitionRef.current.stop();
            } catch {
                // Ignorar si ya se detuvo
            }
        }

        setEscuchando(false);
    };

    const toggleEscuchar = () => {
        if (escuchando) {
            detenerGrabacion();
        } else {
            iniciarVoz();
        }
    };

    const procesarRespuestaServidor = (data: RespuestaIA) => {
        setMensaje(data.mensaje_hablado);
        darRespuestaVoz(data.mensaje_hablado);
        if (data.accion === 'generar_reporte_pdf' && data.reporte) {
            abrirReportePDF(data.reporte);
        }
    };

    const enviarAudioGemini = async (blob: Blob, mimeType: string) => {
        setProcesandoIA(true);
        setMensaje('Procesando solicitud de reporte...');

        const reader = new FileReader();
        reader.readAsDataURL(blob);
        reader.onloadend = async () => {
            const base64Data = (reader.result as string).split(',')[1];
            const token = localStorage.getItem('token');
            const contextoPantalla = window.location.pathname;

            try {
                const res = await fetch('/api/ia/comando-voz', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        Accept: 'application/json',
                        ...(token ? { Authorization: `Bearer ${token}` } : {}),
                    },
                    body: JSON.stringify({
                        audio: base64Data,
                        audio_mime: mimeType,
                        contexto_pantalla: contextoPantalla,
                    }),
                });

                if (!res.ok) {
                    throw new Error('Error al procesar el reporte');
                }

                const data: RespuestaIA = await res.json();
                procesarRespuestaServidor(data);
            } catch {
                const errorMsg = 'No se pudo generar el reporte en este momento. Intenta nuevamente.';
                setMensaje(errorMsg);
                darRespuestaVoz(errorMsg);
            } finally {
                setProcesandoIA(false);
            }
        };
    };

    const enviarComandoTexto = async (texto: string) => {
        if (!texto.trim()) return;
        setProcesandoIA(true);
        const token = localStorage.getItem('token');
        const contextoPantalla = window.location.pathname;

        try {
            const res = await fetch('/api/ia/comando-voz', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    ...(token ? { Authorization: `Bearer ${token}` } : {}),
                },
                body: JSON.stringify({
                    comando: texto,
                    contexto_pantalla: contextoPantalla,
                }),
            });

            if (!res.ok) {
                throw new Error('Error en el servidor de reportes');
            }

            const data: RespuestaIA = await res.json();
            procesarRespuestaServidor(data);
        } catch {
            const errorMsg = 'No se pudo generar el reporte en este momento. Intenta nuevamente.';
            setMensaje(errorMsg);
            darRespuestaVoz(errorMsg);
        } finally {
            setProcesandoIA(false);
        }
    };

    return (
        <div
            style={{
                position: 'fixed',
                bottom: '22px',
                right: '22px',
                zIndex: 9990,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'flex-end',
                gap: '8px',
                fontFamily: 'var(--font-outfit, Outfit, sans-serif)',
            }}
        >
            {/* Panel rápido de comandos específicos por voz o texto */}
            {panelRapidoAbierto && (
                <div
                    style={{
                        backgroundColor: '#ffffff',
                        border: '1px solid #dde1e4',
                        borderTop: '3px solid #12354a',
                        borderRadius: '12px',
                        padding: '14px',
                        width: '340px',
                        maxWidth: 'calc(100vw - 36px)',
                        boxShadow: '0 14px 36px rgba(18, 53, 74, 0.16)',
                    }}
                >
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
                        <strong style={{ fontSize: '13.5px', color: '#12354a' }}>
                            Reportes Específicos Instantáneos
                        </strong>
                        <button
                            type="button"
                            onClick={() => setPanelRapidoAbierto(false)}
                            style={{ background: 'none', border: 'none', color: '#526068', cursor: 'pointer', fontSize: '14px', fontWeight: 700 }}
                        >
                            ✕
                        </button>
                    </div>

                    <form
                        onSubmit={(e) => {
                            e.preventDefault();
                            if (textoManual.trim()) {
                                enviarComandoTexto(textoManual);
                                setTextoManual('');
                            }
                        }}
                        style={{ display: 'flex', gap: '6px', marginBottom: '10px' }}
                    >
                        <input
                            type="text"
                            placeholder="Ej: visitas pendientes, perros disponibles..."
                            value={textoManual}
                            onChange={(e) => setTextoManual(e.target.value)}
                            style={{
                                flex: 1,
                                padding: '7px 10px',
                                borderRadius: '6px',
                                border: '1px solid #cbd5e1',
                                fontSize: '12.5px',
                            }}
                        />
                        <button
                            type="submit"
                            disabled={procesandoIA}
                            style={{
                                padding: '7px 12px',
                                borderRadius: '6px',
                                border: 'none',
                                backgroundColor: '#12354a',
                                color: '#ffffff',
                                fontSize: '12px',
                                fontWeight: 700,
                                cursor: 'pointer',
                            }}
                        >
                            Generar
                        </button>
                    </form>

                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px', maxHeight: '190px', overflowY: 'auto' }}>
                        {COMANDOS_ESPECIFICOS.map((item) => (
                            <button
                                key={item.etiqueta}
                                type="button"
                                disabled={procesandoIA}
                                onClick={() => enviarComandoTexto(item.comando)}
                                style={{
                                    padding: '5px 9px',
                                    borderRadius: '6px',
                                    border: '1px solid #dde1e4',
                                    backgroundColor: '#ffffff',
                                    color: '#12354a',
                                    fontSize: '11.5px',
                                    fontWeight: 600,
                                    cursor: 'pointer',
                                }}
                            >
                                {item.etiqueta}
                            </button>
                        ))}
                    </div>
                </div>
            )}

            {(mensaje || procesandoIA || escuchando) && (
                <div
                    style={{
                        backgroundColor: '#ffffff',
                        color: '#12354a',
                        padding: '10px 14px',
                        borderRadius: '10px',
                        fontSize: '12.5px',
                        fontWeight: 500,
                        boxShadow: '0 10px 25px rgba(18, 53, 74, 0.14)',
                        maxWidth: '340px',
                        lineHeight: 1.45,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        gap: '10px',
                        border: '1px solid #dde1e4',
                        borderLeft: '4px solid #165b4c',
                    }}
                >
                    <span>{procesandoIA ? 'Generando reporte solicitado...' : mensaje}</span>
                    <button
                        type="button"
                        onClick={() => setMensaje('')}
                        style={{
                            background: 'none',
                            border: 'none',
                            color: '#526068',
                            cursor: 'pointer',
                            fontSize: '13px',
                            fontWeight: 700,
                        }}
                    >
                        ✕
                    </button>
                </div>
            )}

            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <button
                    type="button"
                    onClick={() => setPanelRapidoAbierto((v) => !v)}
                    title="Ver lista de reportes específicos rápidos"
                    style={{
                        padding: '10px 14px',
                        borderRadius: '10px',
                        border: '1px solid #dde1e4',
                        backgroundColor: '#ffffff',
                        color: '#12354a',
                        cursor: 'pointer',
                        fontWeight: 700,
                        fontSize: '12.5px',
                        boxShadow: '0 6px 18px rgba(18, 53, 74, 0.12)',
                    }}
                >
                    Reportes Rápidos
                </button>

                <button
                    type="button"
                    onClick={toggleEscuchar}
                    disabled={procesandoIA}
                    title={escuchando ? 'Detener micrófono' : 'Pedir un reporte específico por voz'}
                    style={{
                        padding: '11px 18px',
                        borderRadius: '10px',
                        border: 'none',
                        backgroundColor: escuchando ? '#c85a44' : '#12354a',
                        color: '#ffffff',
                        cursor: 'pointer',
                        display: 'inline-flex',
                        alignItems: 'center',
                        gap: '8px',
                        fontWeight: 700,
                        fontSize: '13px',
                        boxShadow: '0 8px 22px rgba(18, 53, 74, 0.25)',
                        transition: 'all 0.15s ease',
                    }}
                >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                        <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z" />
                        <path d="M19 10v2a7 7 0 0 1-14 0v-2" />
                        <line x1="12" y1="19" x2="12" y2="23" />
                        <line x1="8" y1="23" x2="16" y2="23" />
                    </svg>
                    <span>
                        {escuchando ? 'Escuchando...' : procesandoIA ? 'Generando...' : 'Voz Reportes'}
                    </span>
                </button>
            </div>

            {reporteModal && (
                <div
                    style={{
                        position: 'fixed',
                        inset: 0,
                        backgroundColor: 'rgba(15, 23, 42, 0.65)',
                        zIndex: 10000,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        padding: '20px',
                    }}
                >
                    <div
                        style={{
                            backgroundColor: '#ffffff',
                            color: '#16262e',
                            borderRadius: '14px',
                            maxWidth: '940px',
                            width: '100%',
                            maxHeight: '88vh',
                            display: 'flex',
                            flexDirection: 'column',
                            boxShadow: '0 24px 48px rgba(0, 0, 0, 0.28)',
                            overflow: 'hidden',
                            borderTop: '4px solid #12354a',
                        }}
                    >
                        <div
                            style={{
                                backgroundColor: '#ffffff',
                                color: '#12354a',
                                padding: '16px 20px',
                                borderBottom: '1px solid #dde1e4',
                                display: 'flex',
                                justifyContent: 'space-between',
                                alignItems: 'center',
                                gap: '12px',
                            }}
                        >
                            <div>
                                <div style={{ fontWeight: 800, fontSize: '18px' }}>{reporteModal.titulo}</div>
                                <div style={{ fontSize: '12.5px', color: '#526068', marginTop: '2px' }}>
                                    {reporteModal.subtitulo} • {reporteModal.fecha_generacion}
                                </div>
                            </div>
                            <div style={{ display: 'flex', gap: '8px' }}>
                                <button
                                    type="button"
                                    onClick={() => imprimirEnIframe(reporteModal)}
                                    style={{
                                        padding: '8px 14px',
                                        borderRadius: '8px',
                                        border: 'none',
                                        backgroundColor: '#12354a',
                                        color: '#ffffff',
                                        fontWeight: 700,
                                        fontSize: '12.5px',
                                        cursor: 'pointer',
                                    }}
                                >
                                    Imprimir / Guardar PDF
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setReporteModal(null)}
                                    style={{
                                        padding: '8px 12px',
                                        borderRadius: '8px',
                                        border: '1px solid #cbd5e1',
                                        backgroundColor: '#ffffff',
                                        color: '#12354a',
                                        cursor: 'pointer',
                                        fontSize: '12.5px',
                                        fontWeight: 700,
                                    }}
                                >
                                    ✕
                                </button>
                            </div>
                        </div>

                        <div style={{ padding: '20px', overflowY: 'auto' }}>
                            {reporteModal.resumen && reporteModal.resumen.length > 0 && (
                                <div
                                    style={{
                                        display: 'grid',
                                        gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
                                        gap: '10px',
                                        marginBottom: '18px',
                                    }}
                                >
                                    {reporteModal.resumen.map((item, idx) => (
                                        <div
                                            key={idx}
                                            style={{
                                                backgroundColor: '#ffffff',
                                                border: '1px solid #dde1e4',
                                                borderRadius: '8px',
                                                padding: '10px',
                                                textAlign: 'center',
                                            }}
                                        >
                                            <div style={{ fontSize: '18px', fontWeight: 700, color: '#12354a', fontFamily: 'var(--font-mono)' }}>
                                                {item.valor}
                                            </div>
                                            <div style={{ fontSize: '11px', color: '#526068', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', marginTop: '3px' }}>
                                                {item.etiqueta}
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            )}

                            <div style={{ overflowX: 'auto' }}>
                                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
                                    <thead>
                                        <tr>
                                            {reporteModal.columnas.map((col, idx) => (
                                                <th
                                                    key={idx}
                                                    style={{
                                                        backgroundColor: '#ffffff',
                                                        color: '#12354a',
                                                        borderBottom: '2px solid #12354a',
                                                        padding: '9px 10px',
                                                        textAlign: 'left',
                                                        fontSize: '11.5px',
                                                        textTransform: 'uppercase',
                                                        letterSpacing: '0.05em',
                                                    }}
                                                >
                                                    {col}
                                                </th>
                                            ))}
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {reporteModal.filas.length > 0 ? (
                                            reporteModal.filas.map((fila, rIdx) => (
                                                <tr key={rIdx}>
                                                    {fila.map((celda, cIdx) => (
                                                        <td
                                                            key={cIdx}
                                                            style={{
                                                                padding: '8px 10px',
                                                                borderBottom: '1px solid #eef0f2',
                                                            }}
                                                        >
                                                            {celda}
                                                        </td>
                                                    ))}
                                                </tr>
                                            ))
                                        ) : (
                                            <tr>
                                                <td
                                                    colSpan={Math.max(1, reporteModal.columnas.length)}
                                                    style={{
                                                        textAlign: 'center',
                                                        padding: '18px',
                                                        color: '#526068',
                                                    }}
                                                >
                                                    No se encontraron registros para los filtros solicitados.
                                                </td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
