import applicantRoutes from '@/routes/api/postulantes';
import {
    index as indexApplicantsRoute,
    store as storeApplicantRoute,
    update as updateApplicantRoute,
} from '@/routes/api/postulantes';

export type ApplicantState = 'Pendiente' | 'En evaluación' | 'Aprobado' | 'Rechazado';

export type ApplicantAdoption = {
    id: number;
    fecha_adopcion: string;
    id_mascota: number;
    mascota: Pick<ShelterPet, 'id' | 'nombre' | 'especie' | 'raza'>;
};

export type Applicant = {
    id: number;
    ci: string;
    nombre: string;
    direccion: string;
    telefono: string;
    situacion_casa: string;
    referencias: string;
    puntaje_evaluacion: number | string;
    estado: ApplicantState;
    adopciones: ApplicantAdoption[];
};

export type ShelterPet = {
    id: number;
    nombre: string;
    especie: string;
    raza: string;
};

export type ApplicantInput = Omit<Applicant, 'id' | 'adopciones'>;

export type ApplicantAdoptionInput = {
    id_mascota: number;
    fecha_adopcion: string;
};

type ApiError = {
    message?: string;
    errors?: Record<string, string[]>;
};

async function readError(response: Response): Promise<Error> {
    const result = (await response.json()) as ApiError;
    const fieldMessage = Object.values(result.errors ?? {})[0]?.[0];

    return new Error(result.message ?? fieldMessage ?? 'No se pudo completar la operación.');
}

function authHeaders(token: string): HeadersInit {
    return {
        Accept: 'application/json',
        Authorization: `Bearer ${token}`,
    };
}

const postulanteService = {
    async index(token: string): Promise<{ postulantes: Applicant[]; mascotasDisponibles: ShelterPet[] }> {
        const response = await fetch(indexApplicantsRoute.url(), {
            headers: authHeaders(token),
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as {
            postulantes: Applicant[];
            mascotas_disponibles: ShelterPet[];
        };

        return {
            postulantes: result.postulantes,
            mascotasDisponibles: result.mascotas_disponibles,
        };
    },

    async store(token: string, applicant: ApplicantInput): Promise<Applicant> {
        const response = await fetch(storeApplicantRoute.url(), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(applicant),
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as { postulante: Applicant };

        return { ...result.postulante, adopciones: [] };
    },

    async update(token: string, id: number, applicant: ApplicantInput): Promise<Applicant> {
        const response = await fetch(updateApplicantRoute.url(id), {
            method: 'PATCH',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(applicant),
        });

        if (!response.ok) {
            throw await readError(response);
        }

        const result = (await response.json()) as { postulante: Applicant };

        return result.postulante;
    },

    async storeAdoption(token: string, id: number, adoption: ApplicantAdoptionInput): Promise<void> {
        const response = await fetch(applicantRoutes.adopciones.store.url(id), {
            method: 'POST',
            headers: {
                ...authHeaders(token),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(adoption),
        });

        if (!response.ok) {
            throw await readError(response);
        }
    },
};

export default postulanteService;