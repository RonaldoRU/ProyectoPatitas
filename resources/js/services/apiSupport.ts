type ApiError = {
    message?: string;
    errors?: Record<string, string[]>;
};

export async function readApiError(response: Response): Promise<Error> {
    let result: ApiError;

    try {
        result = (await response.json()) as ApiError;
    } catch {
        return new Error(
            `El servidor respondió con el código ${response.status}.`,
        );
    }

    const fieldMessage = Object.values(result.errors ?? {})[0]?.[0];

    return new Error(
        result.message ?? fieldMessage ?? 'No se pudo completar la operación.',
    );
}

export function authHeaders(token: string): HeadersInit {
    return {
        Accept: 'application/json',
        Authorization: `Bearer ${token}`,
    };
}
