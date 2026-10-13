<?php

namespace App\Notifications;

use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class PasswordResetCodeNotification extends Notification
{
    public function __construct(public readonly string $code) {}

    /**
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Código para recuperar tu contraseña')
            ->greeting('Recuperación de contraseña')
            ->line('Usa este código para definir una contraseña nueva:')
            ->line($this->code)
            ->line('El código vence en 10 minutos. Si no solicitaste este cambio, puedes ignorar este correo.');
    }
}
