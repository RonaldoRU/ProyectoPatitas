import { Head } from '@inertiajs/react';
import BrandPanel from '@/components/BrandPanel';
import LoginForm from '@/components/LoginForm';
import '../../../css/login.css';

export default function Login() {
    return (
        <>
            <Head title="Iniciar sesión" />
            <main className="login-screen">
                <BrandPanel />
                <LoginForm />
            </main>
        </>
    );
}
