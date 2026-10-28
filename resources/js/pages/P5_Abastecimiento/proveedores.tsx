import { Head, Link, router } from '@inertiajs/react';
import { useEffect, useMemo, useState } from 'react';
import type { FormEvent } from 'react';
import { dashboard as dashboardPage, login as loginPage } from '@/routes';
import { index as inventoryPage } from '@/routes/articulos-inventario';
import { index as clinicalPage } from '@/routes/atenciones-clinicas';
import { index as auditPage } from '@/routes/bitacora';
import { index as entryPage } from '@/routes/entradas-insumos';
import { index as applicantsPage } from '@/routes/postulantes';
import { index as suppliersPage } from '@/routes/proveedores';
import { index as stockoutPage } from '@/routes/salidas-inventario';
import { index as usersPage } from '@/routes/usuarios';
import proveedorService from '@/services/proveedorService';
import type { Supplier, SupplierInput } from '@/services/proveedorService';
import DashboardTopNav from '@/components/DashboardTopNav';
import '../../../css/dashboard.css';
import '../../../css/users.css';
import '../../../css/inventario.css';

type ModalMode = 'create' | 'edit' | null;

const initialForm: SupplierInput = {
    nombre_empresa: '',
    nombre_contacto: '',
    telefono: '',
    direccion: '',
    identificacion: '',
    tipo_insumo_provisto: '',
};

export default function Proveedores() {
    const [suppliers, setSuppliers] = useState<Supplier[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [modalMode, setModalMode] = useState<ModalMode>(null);
    const [selectedSupplier, setSelectedSupplier] = useState<Supplier | null>(
        null,
    );
    const [form, setForm] = useState<SupplierInput>(initialForm);
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

        async function loadSuppliers() {
            try {
                const result = await proveedorService.index(accessToken);

                if (active) {
                    setSuppliers(result);
                }
            } catch (cause) {
                if (
                    cause instanceof Error &&
                    cause.message === 'Unauthenticated.'
                ) {
                    localStorage.removeItem('token');
                    router.visit(loginPage.url());

                    return;
                }

                if (active) {
                    setError(
                        cause instanceof Error
                            ? cause.message
                            : 'No se pudo cargar el directorio de proveedores.',
                    );
                }
            } finally {
                if (active) {
                    setLoading(false);
                }
            }
        }

        void loadSuppliers();

        return () => {
            active = false;
        };
    }, []);

    const filteredSuppliers = useMemo(() => {
        const query = search.trim().toLocaleLowerCase('es');

        if (!query) {
            return suppliers;
        }

        return suppliers.filter((supplier) =>
            [
                supplier.nombre_empresa,
                supplier.nombre_contacto,
                supplier.telefono,
                supplier.identificacion ?? '',
                supplier.tipo_insumo_provisto ?? '',
            ].some((value) => value.toLocaleLowerCase('es').includes(query)),
        );
    }, [search, suppliers]);

    const activeCount = suppliers.filter((supplier) => supplier.activo).length;

    function openCreateModal() {
        setError('');
        setForm(initialForm);
        setSelectedSupplier(null);
        setModalMode('create');
    }

    function openEditModal(supplier: Supplier) {
        setError('');
        setForm({
            nombre_empresa: supplier.nombre_empresa,
            nombre_contacto: supplier.nombre_contacto,
            telefono: supplier.telefono,
            direccion: supplier.direccion,
            identificacion: supplier.identificacion ?? '',
            tipo_insumo_provisto: supplier.tipo_insumo_provisto ?? '',
        });
        setSelectedSupplier(supplier);
        setModalMode('edit');
    }

    function closeModal() {
        if (submitting) {
            return;
        }

        setModalMode(null);
        setSelectedSupplier(null);
        setForm(initialForm);
        setError('');
    }

    async function submitSupplier(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        setError('');
        setSuccess('');

        const token = localStorage.getItem('token');

        if (!token) {
            router.visit(loginPage.url());

            return;
        }

        const supplierToEdit = selectedSupplier;

        if (
            modalMode === null ||
            (modalMode === 'edit' && supplierToEdit === null)
        ) {
            return;
        }

        setSubmitting(true);

        try {
            const payload: SupplierInput = {
                ...form,
                nombre_empresa: form.nombre_empresa.trim(),
                nombre_contacto: form.nombre_contacto.trim(),
                telefono: form.telefono.trim(),
                direccion: form.direccion.trim(),
                identificacion: form.identificacion?.trim() || null,
                tipo_insumo_provisto: form.tipo_insumo_provisto.trim(),
            };
            let savedSupplier: Supplier;

            if (modalMode === 'create') {
                savedSupplier = await proveedorService.store(token, payload);
            } else if (supplierToEdit !== null) {
                savedSupplier = await proveedorService.update(
                    token,
                    supplierToEdit.id,
                    payload,
                );
            } else {
                return;
            }

            setSuppliers((current) => {
                const next =
                    modalMode === 'create'
                        ? [...current, savedSupplier]
                        : current.map((supplier) =>
                              supplier.id === savedSupplier.id
                                  ? savedSupplier
                                  : supplier,
                          );

                return next.sort(
                    (first, second) =>
                        Number(second.activo) - Number(first.activo) ||
                        first.nombre_empresa.localeCompare(
                            second.nombre_empresa,
                            'es',
                        ),
                );
            });
            setSuccess(
                modalMode === 'create'
                    ? `Se registró ${savedSupplier.nombre_empresa} en el directorio.`
                    : `Se actualizaron los datos de ${savedSupplier.nombre_empresa}.`,
            );
            setModalMode(null);
            setSelectedSupplier(null);
            setForm(initialForm);
        } catch (cause) {
            if (
                cause instanceof Error &&
                cause.message === 'Unauthenticated.'
            ) {
                localStorage.removeItem('token');
                router.visit(loginPage.url());

                return;
            }

            setError(
                cause instanceof Error
                    ? cause.message
                    : 'No se pudo guardar el proveedor.',
            );
        } finally {
            setSubmitting(false);
        }
    }

    async function toggleSupplierStatus(supplier: Supplier) {
        const active = !supplier.activo;
        const action = active ? 'activar' : 'desactivar';

        if (
            !window.confirm(
                `¿Confirmas ${action} a ${supplier.nombre_empresa}?`,
            )
        ) {
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
            const updatedSupplier = await proveedorService.setActive(
                token,
                supplier.id,
                active,
            );
            setSuppliers((current) =>
                current
                    .map((item) =>
                        item.id === updatedSupplier.id ? updatedSupplier : item,
                    )
                    .sort(
                        (first, second) =>
                            Number(second.activo) - Number(first.activo) ||
                            first.nombre_empresa.localeCompare(
                                second.nombre_empresa,
                                'es',
                            ),
                    ),
            );
            setSuccess(
                active
                    ? `Se activó ${updatedSupplier.nombre_empresa}.`
                    : `Se desactivó ${updatedSupplier.nombre_empresa}; sus compras históricas se conservaron.`,
            );
        } catch (cause) {
            setError(
                cause instanceof Error
                    ? cause.message
                    : `No se pudo ${action} el proveedor.`,
            );
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <>
            <Head title="Directorio de proveedores - Los Angelitos" />
            <div className="dashboard-app">
                <main className="dashboard-main inventory-main">
                    <DashboardTopNav title="Directorio de Proveedores (P5)" />
                    <div className="dashboard-content users-content inventory-content">
                        <section className="users-heading">
                            <div>
                                <p className="dashboard-eyebrow">
                                    Administración del refugio
                                </p>
                                <h2>Directorio de proveedores</h2>
                                <p>
                                    Registra y mantiene los contactos que
                                    suministran artículos al refugio.
                                </p>
                            </div>
                            <button
                                className="users-add-button"
                                type="button"
                                onClick={openCreateModal}
                            >
                                <span aria-hidden="true">+</span>
                                Nuevo proveedor
                            </button>
                        </section>

                        {success && (
                            <p
                                className="users-feedback users-feedback--success"
                                role="status"
                            >
                                {success}
                            </p>
                        )}
                        {error && modalMode === null && (
                            <p
                                className="users-feedback users-feedback--error"
                                role="alert"
                            >
                                {error}
                            </p>
                        )}

                        <section
                            className="inventory-summary"
                            aria-label="Resumen del directorio"
                        >
                            <article className="inventory-summary__card">
                                <span>Proveedores registrados</span>
                                <strong>{suppliers.length}</strong>
                            </article>
                            <article className="inventory-summary__card inventory-summary__card--alert">
                                <span>Proveedores activos</span>
                                <strong>{activeCount}</strong>
                            </article>
                        </section>

                        <section
                            className="inventory-toolbar"
                            aria-label="Búsqueda de proveedores"
                        >
                            <label className="inventory-search">
                                <span>Buscar proveedor</span>
                                <input
                                    type="search"
                                    value={search}
                                    onChange={(event) =>
                                        setSearch(event.target.value)
                                    }
                                    placeholder="Empresa, identificación, contacto o insumo"
                                />
                            </label>
                        </section>

                        <section
                            className="users-table-wrap"
                            aria-label="Directorio de proveedores"
                        >
                            <table className="users-table supplier-table">
                                <thead>
                                    <tr>
                                        <th scope="col">Empresa</th>
                                        <th scope="col">Identificación</th>
                                        <th scope="col">Contacto</th>
                                        <th scope="col">Teléfono</th>
                                        <th scope="col">Dirección</th>
                                        <th scope="col">Tipo de insumo</th>
                                        <th scope="col">Estado</th>
                                        <th scope="col">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr>
                                            <td
                                                className="users-table-state"
                                                colSpan={8}
                                            >
                                                Cargando directorio…
                                            </td>
                                        </tr>
                                    ) : error && suppliers.length === 0 ? (
                                        <tr>
                                            <td
                                                className="users-table-state users-table-state--error"
                                                colSpan={8}
                                            >
                                                {error}
                                            </td>
                                        </tr>
                                    ) : filteredSuppliers.length === 0 ? (
                                        <tr>
                                            <td
                                                className="users-table-state"
                                                colSpan={8}
                                            >
                                                {search
                                                    ? 'No hay proveedores que coincidan con la búsqueda.'
                                                    : 'Todavía no hay proveedores registrados.'}
                                            </td>
                                        </tr>
                                    ) : (
                                        filteredSuppliers.map((supplier) => (
                                            <tr key={supplier.id}>
                                                <td className="users-table-name">
                                                    {supplier.nombre_empresa}
                                                </td>
                                                <td>
                                                    {supplier.identificacion ||
                                                        '—'}
                                                </td>
                                                <td>
                                                    {supplier.nombre_contacto}
                                                </td>
                                                <td>{supplier.telefono}</td>
                                                <td>{supplier.direccion}</td>
                                                <td>
                                                    {supplier.tipo_insumo_provisto ||
                                                        'No especificado'}
                                                </td>
                                                <td>
                                                    <span
                                                        className={`inventory-status ${supplier.activo ? 'inventory-status--ok' : 'inventory-status--low'}`}
                                                    >
                                                        {supplier.activo
                                                            ? 'Activo'
                                                            : 'Inactivo'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div className="users-row-actions">
                                                        <button
                                                            className="users-action-button"
                                                            type="button"
                                                            disabled={
                                                                submitting
                                                            }
                                                            onClick={() =>
                                                                openEditModal(
                                                                    supplier,
                                                                )
                                                            }
                                                        >
                                                            Editar
                                                        </button>
                                                        <button
                                                            className="users-action-button"
                                                            type="button"
                                                            disabled={
                                                                submitting
                                                            }
                                                            onClick={() =>
                                                                void toggleSupplierStatus(
                                                                    supplier,
                                                                )
                                                            }
                                                        >
                                                            {supplier.activo
                                                                ? 'Desactivar'
                                                                : 'Activar'}
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </section>
                    </div>
                </main>
            </div>

            {modalMode !== null && (
                <div
                    className="user-modal-backdrop"
                    onMouseDown={(event) => {
                        if (event.target === event.currentTarget) {
                            closeModal();
                        }
                    }}
                >
                    <section
                        className="user-modal inventory-modal"
                        role="dialog"
                        aria-modal="true"
                        aria-labelledby="supplier-modal-title"
                    >
                        <header className="user-modal__header">
                            <div>
                                <h2 id="supplier-modal-title">
                                    {modalMode === 'create'
                                        ? 'Nuevo proveedor'
                                        : 'Editar proveedor'}
                                </h2>
                                <p>
                                    Los datos registrados se usarán para
                                    identificar proveedores en las compras.
                                </p>
                            </div>
                            <button
                                className="user-modal__close"
                                type="button"
                                onClick={closeModal}
                                aria-label="Cerrar formulario"
                            >
                                ×
                            </button>
                        </header>

                        <form className="user-form" onSubmit={submitSupplier}>
                            <label className="user-form__field user-form__field--full">
                                <span>Nombre comercial de la empresa</span>
                                <input
                                    required
                                    maxLength={255}
                                    value={form.nombre_empresa}
                                    onChange={(event) =>
                                        setForm((current) => ({
                                            ...current,
                                            nombre_empresa: event.target.value,
                                        }))
                                    }
                                />
                            </label>
                            <label className="user-form__field">
                                <span>Número de identificación (opcional)</span>
                                <input
                                    maxLength={50}
                                    value={form.identificacion ?? ''}
                                    onChange={(event) =>
                                        setForm((current) => ({
                                            ...current,
                                            identificacion: event.target.value,
                                        }))
                                    }
                                    placeholder="NIT u otro identificador"
                                />
                            </label>
                            <label className="user-form__field">
                                <span>Nombre de contacto</span>
                                <input
                                    required
                                    maxLength={255}
                                    value={form.nombre_contacto}
                                    onChange={(event) =>
                                        setForm((current) => ({
                                            ...current,
                                            nombre_contacto: event.target.value,
                                        }))
                                    }
                                />
                            </label>
                            <label className="user-form__field">
                                <span>Teléfono</span>
                                <input
                                    required
                                    maxLength={255}
                                    value={form.telefono}
                                    onChange={(event) =>
                                        setForm((current) => ({
                                            ...current,
                                            telefono: event.target.value,
                                        }))
                                    }
                                />
                            </label>
                            <label className="user-form__field">
                                <span>Dirección</span>
                                <input
                                    required
                                    maxLength={255}
                                    value={form.direccion}
                                    onChange={(event) =>
                                        setForm((current) => ({
                                            ...current,
                                            direccion: event.target.value,
                                        }))
                                    }
                                />
                            </label>
                            <label className="user-form__field user-form__field--full">
                                <span>Tipo de insumo que provee</span>
                                <input
                                    required
                                    maxLength={255}
                                    value={form.tipo_insumo_provisto}
                                    onChange={(event) =>
                                        setForm((current) => ({
                                            ...current,
                                            tipo_insumo_provisto:
                                                event.target.value,
                                        }))
                                    }
                                    placeholder="Ej. alimentos, medicamentos o material de limpieza"
                                />
                            </label>
                            {error && (
                                <p
                                    className="users-feedback users-feedback--error user-form__error"
                                    role="alert"
                                >
                                    {error}
                                </p>
                            )}
                            <div className="user-form__actions">
                                <button
                                    className="user-cancel-button"
                                    type="button"
                                    onClick={closeModal}
                                    disabled={submitting}
                                >
                                    Cancelar
                                </button>
                                <button
                                    className="btn-primary user-submit-button"
                                    type="submit"
                                    disabled={submitting}
                                >
                                    {submitting
                                        ? 'Guardando…'
                                        : modalMode === 'create'
                                          ? 'Registrar proveedor'
                                          : 'Guardar cambios'}
                                </button>
                            </div>
                        </form>
                    </section>
                </div>
            )}
        </>
    );
}
