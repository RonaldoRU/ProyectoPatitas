import { Head, Link, router } from '@inertiajs/react';
import { Fragment } from 'react';
import { useEffect, useState  } from 'react';
import type {FormEvent} from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { index as inventoryPage } from '@/routes/articulos-inventario';
import { index as clinicalPage } from '@/routes/atenciones-clinicas';
import { index as auditPage } from '@/routes/bitacora';
import { index as entryPage } from '@/routes/entradas-insumos';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as stockoutPage } from '@/routes/salidas-inventario';
import { index as usersPage } from '@/routes/usuarios';
import userService from '@/services/userService';
import type {NewShelterUser, ShelterRole, ShelterUser} from '@/services/userService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';
import '../../../css/users.css';

const roles: ShelterRole[] = ['Administrador', 'Veterinario', 'Recepcionista', 'Voluntario'];
type UserModalMode = 'create' | 'edit' | 'role' | null;

const initialForm = {
    nombre: '',
    ci: '',
    email: '',
    telefono: '',
    rol: 'Recepcionista' as ShelterRole,
    password: '',
};

export default function Usuarios() {
    const [usuarios, setUsuarios] = useState<ShelterUser[]>([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [modalMode, setModalMode] = useState<UserModalMode>(null);
    const [selectedUser, setSelectedUser] = useState<ShelterUser | null>(null);
    const [expandedUserId, setExpandedUserId] = useState<number | null>(null);
    const [form, setForm] = useState(initialForm);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');
    const modalOpen = modalMode !== null;

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

        async function loadUsers() {
            try {
                const result = await userService.index(accessToken);

                if (active) {
setUsuarios(result);
}
            } catch (cause) {
                if (cause instanceof Error && cause.message === 'Unauthenticated.') {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(
                        cause instanceof Error
                            ? cause.message
                            : 'No se pudo cargar el catálogo de usuarios.',
                    );
                }
            } finally {
                if (active) {
setLoading(false);
}
            }
        }

        void loadUsers();

        return () => {
            active = false;
        };
    }, []);

    function closeModal() {
        if (submitting) {
            return;
        }

        setModalMode(null);
        setSelectedUser(null);
        setError('');
        setForm(initialForm);
    }

    function openCreateModal() {
        setError('');
        setSelectedUser(null);
        setForm(initialForm);
        setModalMode('create');
    }

    function openEditModal(user: ShelterUser) {
        setError('');
        setSelectedUser(user);
        setForm({ ...initialForm, nombre: user.nombre, telefono: user.telefono });
        setModalMode('edit');
    }

    function openRoleModal(user: ShelterUser) {
        setError('');
        setSelectedUser(user);
        setForm({ ...initialForm, rol: user.rol });
        setModalMode('role');
    }

    async function submitUser(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess('');

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        if (modalMode === null || (modalMode !== 'create' && selectedUser === null)) {
            return;
        }

        setSubmitting(true);

        try {
            if (modalMode === 'create') {
                const newUser: NewShelterUser = {
                    nombre: form.nombre,
                    ci: form.ci,
                    email: form.email,
                    telefono: form.telefono,
                    rol: form.rol,
                    password: form.password,
                };
                const createdUser = await userService.store(token, newUser);
                setUsuarios((current) => [...current, createdUser].sort((a, b) => a.nombre.localeCompare(b.nombre)));
                setSuccess(`Se registró a ${createdUser.nombre}.`);
            } else if (modalMode === 'edit' && selectedUser !== null) {
                const updatedUser = await userService.update(token, selectedUser.id, {
                    nombre: form.nombre,
                    telefono: form.telefono,
                });
                setUsuarios((current) => current
                    .map((user) => user.id === updatedUser.id ? updatedUser : user)
                    .sort((a, b) => a.nombre.localeCompare(b.nombre)));
                setSuccess(`Se actualizaron los datos de ${updatedUser.nombre}.`);
            } else if (modalMode === 'role' && selectedUser !== null) {
                const updatedUser = await userService.changeRole(token, selectedUser.id, form.rol);
                setUsuarios((current) => current.map((user) => user.id === updatedUser.id ? updatedUser : user));
                setSuccess(`Se actualizó el rol de ${updatedUser.nombre}.`);
            }

            setModalMode(null);
            setSelectedUser(null);
            setForm(initialForm);
        } catch (cause) {
            setError(
                cause instanceof Error
                    ? cause.message
                    : 'No se pudo registrar el usuario.',
            );
        } finally {
            setSubmitting(false);
        }
    }

    async function toggleUserStatus(user: ShelterUser) {
        const activo = !user.activo;
        const action = activo ? 'reactivar' : 'suspender';

        if (!window.confirm(`¿Confirmas ${action} la cuenta de ${user.nombre}?`)) {
            return;
        }

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        setError('');
        setSuccess('');
        setSubmitting(true);

        try {
            const updatedUser = await userService.setActive(token, user.id, activo);
            setUsuarios((current) => current.map((currentUser) => (
                currentUser.id === updatedUser.id ? updatedUser : currentUser
            )));
            setSuccess(activo
                ? `Se reactivó la cuenta de ${updatedUser.nombre}.`
                : `Se suspendió la cuenta de ${updatedUser.nombre} y se revocaron sus sesiones.`);
        } catch (cause) {
            setError(
                cause instanceof Error
                    ? cause.message
                    : `No se pudo ${action} la cuenta.`,
            );
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <>
            <Head title="Gestión de usuarios - Los Angelitos" />
            <div className="dashboard-app">
                <main className="dashboard-main users-main">
                    <DashboardTopNav title="Gestión de Usuarios (P2)" />

                    <div className="dashboard-content users-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">Administración del refugio</p>
                                <h2>Gestión de usuarios</h2>
                                <p>Catálogo del personal y voluntariado del refugio.</p>
                            </div>
                            <button
                                className="users-add-button"
                                type="button"
                                onClick={openCreateModal}
                            >
                                <span aria-hidden="true">+</span>
                                Nuevo usuario
                            </button>
                        </section>

                        {success && <p className="users-feedback users-feedback--success" role="status">{success}</p>}
                        {error && !modalOpen && <p className="users-feedback users-feedback--error" role="alert">{error}</p>}

                        <section className="users-table-wrap" aria-label="Catálogo de usuarios">
                            <table className="users-table">
                                <thead>
                                    <tr>
                                        <th scope="col">CI</th>
                                        <th scope="col">Nombre</th>
                                        <th scope="col">Correo electrónico</th>
                                        <th scope="col">Teléfono</th>
                                        <th scope="col">Rol</th>
                                        <th scope="col">Estado</th>
                                        <th scope="col">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr><td className="users-table-state" colSpan={7}>Cargando usuarios…</td></tr>
                                    ) : error && usuarios.length === 0 ? (
                                        <tr><td className="users-table-state users-table-state--error" colSpan={7}>{error}</td></tr>
                                    ) : usuarios.length === 0 ? (
                                        <tr><td className="users-table-state" colSpan={7}>Todavía no hay usuarios registrados.</td></tr>
                                    ) : (
                                        usuarios.map((usuario) => (
                                            <Fragment key={usuario.id}>
                                                <tr>
                                                    <td>{usuario.ci || '—'}</td>
                                                    <td className="users-table-name">
                                                        <button
                                                            className="users-profile-toggle"
                                                            type="button"
                                                            aria-expanded={expandedUserId === usuario.id}
                                                            onClick={() => setExpandedUserId(
                                                                expandedUserId === usuario.id ? null : usuario.id,
                                                            )}
                                                        >
                                                            {usuario.nombre}
                                                        </button>
                                                    </td>
                                                    <td>{usuario.email}</td>
                                                    <td>{usuario.telefono}</td>
                                                    <td><span className={`user-role-badge user-role-badge--${usuario.rol.toLowerCase()}`}>{usuario.rol}</span></td>
                                                    <td>
                                                        <span className={`user-status-badge ${usuario.activo ? 'user-status-badge--active' : 'user-status-badge--inactive'}`}>
                                                            {usuario.activo ? 'Activo' : 'Inactivo'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div className="users-row-actions">
                                                            <button className="users-action-button" type="button" onClick={() => openEditModal(usuario)} disabled={submitting}>
                                                                Editar
                                                            </button>
                                                            <button className="users-action-button" type="button" onClick={() => openRoleModal(usuario)} disabled={submitting}>
                                                                Rol
                                                            </button>
                                                            <button
                                                                className={`users-action-button ${usuario.activo ? 'users-action-button--danger' : ''}`}
                                                                type="button"
                                                                onClick={() => void toggleUserStatus(usuario)}
                                                                disabled={submitting}
                                                            >
                                                                {usuario.activo ? 'Suspender' : 'Reactivar'}
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                {expandedUserId === usuario.id && (
                                                    <tr key={`${usuario.id}-profile`} className="users-profile-row">
                                                        <td colSpan={7}>
                                                            <dl className="users-profile-details">
                                                                <div><dt>Nombre completo</dt><dd>{usuario.nombre}</dd></div>
                                                                <div><dt>Teléfono</dt><dd>{usuario.telefono}</dd></div>
                                                                <div><dt>Fecha de ingreso</dt><dd>{usuario.created_at ? new Intl.DateTimeFormat('es-BO', { dateStyle: 'medium' }).format(new Date(usuario.created_at)) : '—'}</dd></div>
                                                            </dl>
                                                        </td>
                                                    </tr>
                                                )}
                                            </Fragment>
                                        ))
                                    )}
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
                    <section
                        className="user-modal"
                        role="dialog"
                        aria-modal="true"
                        aria-labelledby="user-modal-title"
                    >
                        <header className="user-modal__header">
                            <div>
                                <h2 id="user-modal-title">
                                    {modalMode === 'create' ? 'Nuevo usuario' : modalMode === 'edit' ? 'Editar datos de usuario' : 'Cambiar rol operativo'}
                                </h2>
                                <p>
                                    {modalMode === 'create'
                                        ? 'Crea credenciales operativas para personal o voluntarios.'
                                        : modalMode === 'edit'
                                            ? `Actualiza el nombre o el teléfono de ${selectedUser?.nombre}.`
                                            : `Selecciona el nuevo rol para ${selectedUser?.nombre}.`}
                                </p>
                            </div>
                            <button className="user-modal__close" type="button" onClick={closeModal} aria-label="Cerrar" title="Cerrar">
                                ×
                            </button>
                        </header>

                        <form className="user-form" onSubmit={submitUser}>
                            {modalMode !== 'role' && (
                                <div className="user-form__field user-form__field--full">
                                    <label htmlFor="new-user-name">Nombre completo</label>
                                    <input
                                        id="new-user-name"
                                        autoComplete="name"
                                        placeholder="Ej. Miguel Rocha"
                                        value={form.nombre}
                                        onChange={(event) => setForm({ ...form, nombre: event.target.value })}
                                        required
                                    />
                                </div>
                            )}

                            {modalMode === 'create' && (
                                <>
                                    <div className="user-form__field">
                                        <label htmlFor="new-user-ci">Carnet de identidad</label>
                                        <input
                                            id="new-user-ci"
                                            placeholder="4521678 SC"
                                            value={form.ci}
                                            onChange={(event) => setForm({ ...form, ci: event.target.value })}
                                            required
                                        />
                                    </div>
                                    <div className="user-form__field">
                                        <label htmlFor="new-user-email">Correo electrónico</label>
                                        <input
                                            id="new-user-email"
                                            type="email"
                                            autoComplete="email"
                                            placeholder="nombre@refugio.org"
                                            value={form.email}
                                            onChange={(event) => setForm({ ...form, email: event.target.value })}
                                            required
                                        />
                                    </div>
                                    <div className="user-form__field user-form__field--full">
                                        <label htmlFor="new-user-password">Contraseña asignada</label>
                                        <input
                                            id="new-user-password"
                                            type="password"
                                            autoComplete="new-password"
                                            placeholder="Mínimo 8 caracteres"
                                            minLength={8}
                                            value={form.password}
                                            onChange={(event) => setForm({ ...form, password: event.target.value })}
                                            required
                                        />
                                    </div>
                                </>
                            )}

                            {(modalMode === 'create' || modalMode === 'role') && (
                                <div className={`user-form__field ${modalMode === 'role' ? 'user-form__field--full' : ''}`}>
                                    <label htmlFor="new-user-role">Rol</label>
                                    <select
                                        id="new-user-role"
                                        value={form.rol}
                                        onChange={(event) => setForm({ ...form, rol: event.target.value as ShelterRole })}
                                    >
                                        {roles.map((role) => <option key={role} value={role}>{role}</option>)}
                                    </select>
                                </div>
                            )}

                            {(modalMode === 'create' || modalMode === 'edit') && (
                                <div className={`user-form__field ${modalMode === 'edit' ? 'user-form__field--full' : ''}`}>
                                    <label htmlFor="new-user-phone">Teléfono</label>
                                    <input
                                        id="new-user-phone"
                                        type="tel"
                                        autoComplete="tel"
                                        placeholder="+591 70012345"
                                        value={form.telefono}
                                        onChange={(event) => setForm({ ...form, telefono: event.target.value })}
                                        required
                                    />
                                </div>
                            )}

                            {error && <p className="users-feedback users-feedback--error user-form__error" role="alert">{error}</p>}

                            <footer className="user-form__actions">
                                <button className="user-cancel-button" type="button" onClick={closeModal} disabled={submitting}>
                                    Cancelar
                                </button>
                                <button className="users-add-button user-submit-button" type="submit" disabled={submitting}>
                                    {submitting
                                        ? 'Guardando…'
                                        : modalMode === 'create'
                                            ? 'Registrar usuario'
                                            : modalMode === 'edit'
                                                ? 'Guardar cambios'
                                                : 'Cambiar rol'}
                                </button>
                            </footer>
                        </form>
                    </section>
                </div>
            )}
        </>
    );
}
