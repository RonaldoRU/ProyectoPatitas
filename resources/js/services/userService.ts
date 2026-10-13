import {
    index as indexUsersRoute,
    role as changeRoleRoute,
    store as storeUserRoute,
    status as setUserStatusRoute,
    update as updateUserRoute,
} from '@/routes/api/usuarios';

export type ShelterRole = 'Administrador' | 'Veterinario' | 'Recepcionista' | 'Voluntario';

export type ShelterUser = {
    id: number;
    ci: string | null;
    nombre: string;
    email: string;
    telefono: string;
    rol: ShelterRole;
    activo: boolean;
    created_at: string | null;
};

export type NewShelterUser = Pick<ShelterUser, 'ci' | 'nombre' | 'email' | 'telefono' | 'rol'> & {
    password: string;
};

export type UserProfileChanges = Pick<ShelterUser, 'nombre' | 'telefono'>;

type ApiError = {
    message?: string;
    errors?: Record<string, string[]>;
};

async function readError(response: Response): Promise<Error> {
    const result = (await response.json()) as ApiError;
    const fieldMessage = Object.values(result.errors ?? {})[0]?.[0];

    return new Error(fieldMessage ?? result.message ?? 'No se pudo completar la operación.');
}

const userService = {
    async index(token: string): Promise<ShelterUser[]> {
        const response = await fetch(indexUsersRoute.url(), {
            headers: {
                Accept: 'application/json',
                Authorization: `Bearer ${token}`,
            },
        });

        if (!response.ok) {
throw await readError(response);
}

        const result = (await response.json()) as { usuarios: ShelterUser[] };

        return result.usuarios;
    },

    async store(token: string, user: NewShelterUser): Promise<ShelterUser> {
        const response = await fetch(storeUserRoute.url(), {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
            },
            body: JSON.stringify(user),
        });

        if (!response.ok) {
throw await readError(response);
}

        const result = (await response.json()) as { usuario: ShelterUser };

        return result.usuario;
    },

    async update(token: string, userId: number, changes: UserProfileChanges): Promise<ShelterUser> {
        const response = await fetch(updateUserRoute.url(userId), {
            method: 'PATCH',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
            },
            body: JSON.stringify(changes),
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as { usuario: ShelterUser };

        return result.usuario;
    },

    async changeRole(token: string, userId: number, rol: ShelterRole): Promise<ShelterUser> {
        const response = await fetch(changeRoleRoute.url(userId), {
            method: 'PATCH',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
            },
            body: JSON.stringify({ rol }),
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as { usuario: ShelterUser };

        return result.usuario;
    },

    async setActive(token: string, userId: number, activo: boolean): Promise<ShelterUser> {
        const response = await fetch(setUserStatusRoute.url(userId), {
            method: 'PATCH',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
            },
            body: JSON.stringify({ activo }),
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as { usuario: ShelterUser };

        return result.usuario;
    },
};

export default userService;