import { login as loginRoute, logout as logoutRoute } from '@/routes/api';
import {
    request as requestRecoveryCodeRoute,
    reset as resetPasswordRoute,
} from '@/routes/api/password';

export type AuthenticatedUser = {
    id: number;
    nombre: string;
    email: string;
    rol: string;
};

export type LoginResponse = {
    token: string;
    usuario: AuthenticatedUser;
};

type ErrorResponse = {
    mensaje?: string;
    message?: string;
    espera_segundos?: number;
    errors?: Record<string, string[]>;
};

function getErrorMessage(result: ErrorResponse, fallback: string): string {
    const validationMessage = Object.values(result.errors ?? {})[0]?.[0];

    return result.message ?? result.mensaje ?? validationMessage ?? fallback;
}

function buildLoginError(result: ErrorResponse, fallback: string): Error {
    const message = getErrorMessage(result, fallback);

    if (typeof result.espera_segundos === 'number') {
        return Object.assign(new Error(message), { retryAfter: result.espera_segundos });
    }

    return new Error(message);
}

const authService = {
    getToken(): string | null {
        if (typeof window === 'undefined') {
            return null;
        }

        return localStorage.getItem('token');
    },

    async login(usuario: string, password: string): Promise<LoginResponse> {
        const response = await fetch(loginRoute.url(), {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ usuario, password }),
        });

        const result = (await response.json()) as LoginResponse | ErrorResponse;

        if (!response.ok) {
            throw buildLoginError(result as ErrorResponse, 'Revisa tus datos e inténtalo otra vez.');
        }

        return result as LoginResponse;
    },

    async solicitarCodigo(ciEmail: string): Promise<void> {
        const response = await fetch(requestRecoveryCodeRoute.url(), {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ ci_email: ciEmail }),
        });

        const result = (await response.json()) as ErrorResponse;

        if (!response.ok) {
            throw new Error(getErrorMessage(result, 'No fue posible solicitar el código.'));
        }
    },

    async restablecerPassword(
        ciEmail: string,
        codigo: string,
        password: string,
        passwordConfirmation: string,
    ): Promise<void> {
        const response = await fetch(resetPasswordRoute.url(), {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                ci_email: ciEmail,
                codigo,
                password,
                password_confirmation: passwordConfirmation,
            }),
        });

        const result = (await response.json()) as ErrorResponse;

        if (!response.ok) {
            throw new Error(getErrorMessage(result, 'No fue posible restablecer la contraseña.'));
        }
    },

    async logout(token: string): Promise<void> {
        const response = await fetch(logoutRoute.url(), {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                Authorization: `Bearer ${token}`,
            },
        });

        if (!response.ok) {
            throw new Error('No fue posible cerrar la sesión en el servidor.');
        }
    },
};

export default authService;