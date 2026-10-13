import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useState } from 'react';
import type { FormEvent } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { index as auditPage } from '@/routes/bitacora';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as usersPage } from '@/routes/usuarios';
import postulanteService from '@/services/postulanteService';
import type {
    Applicant,
    ApplicantInput,
    ApplicantState,
    ShelterPet,
} from '@/services/postulanteService';
import '../../css/dashboard.css';
import '../../css/users.css';
import '../../css/postulantes.css';

const applicantStates: ApplicantState[] = ['Pendiente', 'En evaluación', 'Aprobado', 'Rechazado'];

const initialForm: ApplicantInput = {
    ci: '',
    nombre: '',
    direccion: '',
    telefono: '',
    situacion_casa: '',
    referencias: '',
    puntaje_evaluacion: 0,
    estado: 'Pendiente',
};

function localDate(): string {
    const date = new Date();
    const offset = date.getTimezoneOffset();

    return new Date(date.getTime() - offset * 60_000).toISOString().slice(0, 10);
}

function effectiveState(applicant: Applicant): string {
    return applicant.adopciones.length > 0 ? 'Adoptado' : applicant.estado;
}

function stateClass(state: string): string {
    const stateClasses: Record<string, string> = {
        Pendiente: 'pending',
        'En evaluación': 'review',
        Aprobado: 'approved',
        Rechazado: 'rejected',
        Adoptado: 'adopted',
    };

    return `applicant-status applicant-status--${stateClasses[state] ?? 'pending'}`;
}

export default function Postulantes() {
    const [applicants, setApplicants] = useState<Applicant[]>([]);
    const [availablePets, setAvailablePets] = useState<ShelterPet[]>([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [modalOpen, setModalOpen] = useState(false);
    const [editingApplicant, setEditingApplicant] = useState<Applicant | null>(null);
    const [adoptingApplicant, setAdoptingApplicant] = useState<Applicant | null>(null);
    const [form, setForm] = useState<ApplicantInput>(initialForm);
    const [petId, setPetId] = useState('');
    const [adoptionDate, setAdoptionDate] = useState(localDate);
    const [search, setSearch] = useState('');
    const [stateFilter, setStateFilter] = useState('Todos');
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    useEffect(() => {
        let active = true;
        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return () => {
                active = false;
            };
        }

        const accessToken = token;

        async function loadApplicants() {
            try {
                const result = await postulanteService.index(accessToken);

                if (active) {
                    setApplicants(result.postulantes);
                    setAvailablePets(result.mascotasDisponibles);
                }
            } catch (cause) {
                if (cause instanceof Error && cause.message === 'Unauthenticated.') {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(cause instanceof Error ? cause.message : 'No se pudieron cargar los postulantes.');
                }
            } finally {
                if (active) {
                    setLoading(false);
                }
            }
        }

        void loadApplicants();

        return () => {
            active = false;
        };
    }, []);

    function openCreateModal() {
        setEditingApplicant(null);
        setForm(initialForm);
        setError('');
        setModalOpen(true);
    }

    function openEditModal(applicant: Applicant) {
        setEditingApplicant(applicant);
        setForm({
            ci: applicant.ci,
            nombre: applicant.nombre,
            direccion: applicant.direccion,
            telefono: applicant.telefono,
            situacion_casa: applicant.situacion_casa,
            referencias: applicant.referencias,
            puntaje_evaluacion: Number(applicant.puntaje_evaluacion),
            estado: applicant.adopciones.length > 0 ? 'Aprobado' : applicant.estado,
        });
        setError('');
        setModalOpen(true);
    }

    function closeModal() {
        if (submitting) {
            return;
        }

        setModalOpen(false);
        setEditingApplicant(null);
        setError('');
    }

    async function submitApplicant(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess('');
        setSubmitting(true);

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());
            setSubmitting(false);

            return;
        }

        try {
            if (editingApplicant) {
                const updatedApplicant = await postulanteService.update(token, editingApplicant.id, form);
                setApplicants((current) => current.map((applicant) => (
                    applicant.id === updatedApplicant.id ? updatedApplicant : applicant
                )));
                setSuccess(`Se actualizó la evaluación de ${updatedApplicant.nombre}.`);
            } else {
                const createdApplicant = await postulanteService.store(token, form);
                setApplicants((current) => [...current, createdApplicant].sort((a, b) => a.nombre.localeCompare(b.nombre)));
                setSuccess(`Se registró a ${createdApplicant.nombre}.`);
            }

            setModalOpen(false);
            setEditingApplicant(null);
        } catch (cause) {
            setError(cause instanceof Error ? cause.message : 'No se pudo guardar el postulante.');
        } finally {
            setSubmitting(false);
        }
    }

    async function submitAdoption(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();

        if (!adoptingApplicant || !petId) {
            return;
        }

        setError('');
        setSuccess('');
        setSubmitting(true);

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());
            setSubmitting(false);

            return;
        }

        try {
            await postulanteService.storeAdoption(token, adoptingApplicant.id, {
                id_mascota: Number(petId),
                fecha_adopcion: adoptionDate,
            });

            const result = await postulanteService.index(token);
            setApplicants(result.postulantes);
            setAvailablePets(result.mascotasDisponibles);
            setSuccess(`Adopción registrada para ${adoptingApplicant.nombre}.`);
            setAdoptingApplicant(null);
        } catch (cause) {
            setError(cause instanceof Error ? cause.message : 'No se pudo registrar la adopción.');
        } finally {
            setSubmitting(false);
        }
    }

    function closeAdoptionModal() {
        if (submitting) {
            return;
        }

        setAdoptingApplicant(null);
        setPetId('');
        setAdoptionDate(localDate());
        setError('');
    }

    const filteredApplicants = applicants.filter((applicant) => {
        const query = search.trim().toLocaleLowerCase('es');
        const matchesSearch = !query || [applicant.ci, applicant.nombre, applicant.telefono]
            .some((value) => value.toLocaleLowerCase('es').includes(query));
        const matchesState = stateFilter === 'Todos' || effectiveState(applicant) === stateFilter;

        return matchesSearch && matchesState;
    });

    return (
        <>
            <Head title="Postulantes" />
            <div className="dashboard-app">
                <aside className="dashboard-sidebar">
                    <Link className="dashboard-brand" href={dashboardPage.url()}>
                        <span className="dashboard-brand__badge">LA</span>
                        <span className="dashboard-brand__name">Los Angelitos</span>
                    </Link>

                    <nav className="dashboard-nav" aria-label="Navegación principal">
                        <Link className="dashboard-nav__item" href={dashboardPage.url()}>
                            <span className="user-nav-icon" aria-hidden="true">⌂</span>
                            <span>Inicio</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#ingresos`}>
                            <span className="user-nav-icon" aria-hidden="true">✿</span>
                            <span>Animales</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#adopciones`}>
                            <span className="user-nav-icon" aria-hidden="true">♡</span>
                            <span>Adopciones</span>
                        </Link>
                        <Link
                            className="dashboard-nav__item dashboard-nav__item--active"
                            href={applicantsPage.url()}
                            aria-current="page"
                        >
                            <span className="user-nav-icon" aria-hidden="true">♧</span>
                            <span>Postulantes</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={`${dashboardPage.url()}#inventario`}>
                            <span className="user-nav-icon" aria-hidden="true">◇</span>
                            <span>Inventario</span>
                        </Link>
                        <span className="dashboard-nav__item dashboard-nav__item--disabled" aria-disabled="true">
                            <span className="user-nav-icon" aria-hidden="true">▤</span>
                            <span>Donaciones</span>
                        </span>
                        <Link className="dashboard-nav__item" href={usersPage.url()}>
                            <span className="user-nav-icon" aria-hidden="true">▣</span>
                            <span>Usuarios</span>
                        </Link>
                        <Link className="dashboard-nav__item" href={auditPage.url()}>
                            <span className="user-nav-icon" aria-hidden="true">◷</span>
                            <span>Bitácora</span>
                        </Link>
                    </nav>

                    <div className="dashboard-sidebar__foot">
                        Refugio Los Angelitos de Edgar
                        <span>Santa Cruz de la Sierra</span>
                    </div>
                </aside>

                <main className="dashboard-main applicants-main">
                    <header className="dashboard-topbar">
                        <h1>Postulantes</h1>
                        <div className="dashboard-topbar__actions">
                            <span className="users-topbar-label">Evaluación de adopción</span>
                        </div>
                    </header>

                    <div className="dashboard-content users-content applicants-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">Proceso de adopción</p>
                                <h2>Postulantes</h2>
                                <p>Registra a las familias, revisa su evaluación y asigna mascotas aprobadas.</p>
                            </div>
                            <button className="users-add-button" type="button" onClick={openCreateModal}>
                                <span aria-hidden="true">+</span>
                                Nuevo postulante
                            </button>
                        </section>

                        {success && <p className="users-feedback users-feedback--success" role="status">{success}</p>}
                        {error && !modalOpen && !adoptingApplicant && (
                            <p className="users-feedback users-feedback--error" role="alert">{error}</p>
                        )}

                        <section className="applicant-toolbar" aria-label="Filtros de postulantes">
                            <label className="applicant-search">
                                <span>Buscar</span>
                                <input
                                    type="search"
                                    placeholder="Nombre, CI o teléfono"
                                    value={search}
                                    onChange={(event) => setSearch(event.target.value)}
                                />
                            </label>
                            <label className="applicant-state-filter">
                                <span>Estado</span>
                                <select value={stateFilter} onChange={(event) => setStateFilter(event.target.value)}>
                                    <option>Todos</option>
                                    <option>Pendiente</option>
                                    <option>En evaluación</option>
                                    <option>Aprobado</option>
                                    <option>Rechazado</option>
                                    <option>Adoptado</option>
                                </select>
                            </label>
                        </section>

                        <section className="users-table-wrap" aria-label="Registro de postulantes">
                            <table className="users-table applicants-table">
                                <thead>
                                    <tr>
                                        <th scope="col">CI</th>
                                        <th scope="col">Postulante</th>
                                        <th scope="col">Teléfono</th>
                                        <th scope="col">Evaluación</th>
                                        <th scope="col">Estado</th>
                                        <th scope="col">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr><td className="users-table-state" colSpan={6}>Cargando postulantes…</td></tr>
                                    ) : error && applicants.length === 0 ? (
                                        <tr><td className="users-table-state users-table-state--error" colSpan={6}>{error}</td></tr>
                                    ) : filteredApplicants.length === 0 ? (
                                        <tr>
                                            <td className="users-table-state" colSpan={6}>
                                                {applicants.length === 0 ? 'Todavía no hay postulantes registrados.' : 'No hay resultados para esos filtros.'}
                                            </td>
                                        </tr>
                                    ) : filteredApplicants.map((applicant) => {
                                        const state = effectiveState(applicant);
                                        const adoptedPet = applicant.adopciones[0]?.mascota;

                                        return (
                                            <tr key={applicant.id}>
                                                <td>{applicant.ci}</td>
                                                <td className="users-table-name">{applicant.nombre}</td>
                                                <td>{applicant.telefono}</td>
                                                <td><span className="applicant-score">{applicant.puntaje_evaluacion}/100</span></td>
                                                <td>
                                                    <span className={stateClass(state)}>{state}</span>
                                                    {adoptedPet && <small className="applicant-adopted-pet">{adoptedPet.nombre}</small>}
                                                </td>
                                                <td>
                                                    <div className="applicant-actions">
                                                        <button type="button" className="applicant-action" onClick={() => openEditModal(applicant)}>
                                                            Editar
                                                        </button>
                                                        {applicant.estado === 'Aprobado' && applicant.adopciones.length === 0 && (
                                                            <button
                                                                type="button"
                                                                className="applicant-action applicant-action--primary"
                                                                disabled={availablePets.length === 0}
                                                                title={availablePets.length === 0 ? 'No hay mascotas disponibles' : 'Registrar adopción'}
                                                                onClick={() => {
                                                                    setError('');
                                                                    setPetId('');
                                                                    setAdoptingApplicant(applicant);
                                                                }}
                                                            >
                                                                Adoptar
                                                            </button>
                                                        )}
                                                    </div>
                                                </td>
                                            </tr>
                                        );
                                    })}
                                </tbody>
                            </table>
                        </section>
                    </div>
                </main>
            </div>

            {modalOpen && (
                <div className="user-modal-backdrop" onMouseDown={(event) => {
                    if (event.target === event.currentTarget) {
                        closeModal();
                    }
                }}>
                    <section className="user-modal applicant-modal" role="dialog" aria-modal="true" aria-labelledby="applicant-modal-title">
                        <header className="user-modal__header">
                            <div>
                                <h2 id="applicant-modal-title">{editingApplicant ? 'Editar postulante' : 'Nuevo postulante'}</h2>
                                <p>Datos de contacto y resultado de la evaluación.</p>
                            </div>
                            <button className="user-modal__close" type="button" onClick={closeModal} aria-label="Cerrar" title="Cerrar">×</button>
                        </header>

                        <form className="user-form" onSubmit={submitApplicant}>
                            {error && <p className="users-feedback users-feedback--error user-form__error" role="alert">{error}</p>}
                            <div className="user-form__field">
                                <label htmlFor="applicant-ci">Carnet de identidad</label>
                                <input id="applicant-ci" maxLength={20} value={form.ci} onChange={(event) => setForm({ ...form, ci: event.target.value })} required />
                            </div>
                            <div className="user-form__field">
                                <label htmlFor="applicant-name">Nombre completo</label>
                                <input id="applicant-name" autoComplete="name" maxLength={255} value={form.nombre} onChange={(event) => setForm({ ...form, nombre: event.target.value })} required />
                            </div>
                            <div className="user-form__field">
                                <label htmlFor="applicant-phone">Teléfono</label>
                                <input id="applicant-phone" type="tel" autoComplete="tel" maxLength={30} value={form.telefono} onChange={(event) => setForm({ ...form, telefono: event.target.value })} required />
                            </div>
                            <div className="user-form__field">
                                <label htmlFor="applicant-address">Dirección</label>
                                <input id="applicant-address" autoComplete="street-address" maxLength={255} value={form.direccion} onChange={(event) => setForm({ ...form, direccion: event.target.value })} required />
                            </div>
                            <div className="user-form__field user-form__field--full">
                                <label htmlFor="applicant-home">Situación de vivienda</label>
                                <textarea id="applicant-home" maxLength={255} rows={2} value={form.situacion_casa} onChange={(event) => setForm({ ...form, situacion_casa: event.target.value })} required />
                            </div>
                            <div className="user-form__field user-form__field--full">
                                <label htmlFor="applicant-references">Referencias</label>
                                <textarea id="applicant-references" maxLength={255} rows={2} value={form.referencias} onChange={(event) => setForm({ ...form, referencias: event.target.value })} required />
                            </div>
                            <div className="user-form__field">
                                <label htmlFor="applicant-score">Puntaje (0–100)</label>
                                <input id="applicant-score" type="number" min={0} max={100} step={1} value={form.puntaje_evaluacion} onChange={(event) => setForm({ ...form, puntaje_evaluacion: Number(event.target.value) })} required />
                            </div>
                            <div className="user-form__field">
                                <label htmlFor="applicant-state">Estado</label>
                                <select id="applicant-state" value={form.estado} disabled={Boolean(editingApplicant?.adopciones.length)} onChange={(event) => setForm({ ...form, estado: event.target.value as ApplicantState })}>
                                    {applicantStates.map((state) => <option key={state} value={state}>{state}</option>)}
                                </select>
                            </div>
                            <div className="user-form__actions">
                                <button className="user-cancel-button" type="button" onClick={closeModal} disabled={submitting}>Cancelar</button>
                                <button className="users-add-button user-submit-button" type="submit" disabled={submitting}>
                                    {submitting ? 'Guardando…' : editingApplicant ? 'Guardar cambios' : 'Registrar postulante'}
                                </button>
                            </div>
                        </form>
                    </section>
                </div>
            )}

            {adoptingApplicant && (
                <div className="user-modal-backdrop" onMouseDown={(event) => {
                    if (event.target === event.currentTarget) {
                        closeAdoptionModal();
                    }
                }}>
                    <section className="user-modal" role="dialog" aria-modal="true" aria-labelledby="adoption-modal-title">
                        <header className="user-modal__header">
                            <div>
                                <h2 id="adoption-modal-title">Registrar adopción</h2>
                                <p>Postulante aprobado: {adoptingApplicant.nombre}</p>
                            </div>
                            <button className="user-modal__close" type="button" onClick={closeAdoptionModal} aria-label="Cerrar" title="Cerrar">×</button>
                        </header>

                        <form className="user-form" onSubmit={submitAdoption}>
                            {error && <p className="users-feedback users-feedback--error user-form__error" role="alert">{error}</p>}
                            <div className="user-form__field user-form__field--full">
                                <label htmlFor="adoption-pet">Mascota disponible</label>
                                <select id="adoption-pet" value={petId} onChange={(event) => setPetId(event.target.value)} required>
                                    <option value="">Selecciona una mascota</option>
                                    {availablePets.map((pet) => (
                                        <option key={pet.id} value={pet.id}>{pet.nombre} · {pet.especie} · {pet.raza}</option>
                                    ))}
                                </select>
                            </div>
                            <div className="user-form__field user-form__field--full">
                                <label htmlFor="adoption-date">Fecha de adopción</label>
                                <input id="adoption-date" type="date" value={adoptionDate} onChange={(event) => setAdoptionDate(event.target.value)} required />
                            </div>
                            <div className="user-form__actions">
                                <button className="user-cancel-button" type="button" onClick={closeAdoptionModal} disabled={submitting}>Cancelar</button>
                                <button className="users-add-button user-submit-button" type="submit" disabled={submitting || availablePets.length === 0}>
                                    {submitting ? 'Registrando…' : 'Confirmar adopción'}
                                </button>
                            </div>
                        </form>
                    </section>
                </div>
            )}
        </>
    );
}