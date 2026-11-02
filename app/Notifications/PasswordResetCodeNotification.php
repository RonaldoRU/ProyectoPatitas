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
        $nombre = $notifiable->nombre ?? 'Usuario';

        return (new MailMessage)
            ->subject('Código de verificación para cambiar tu contraseña')
            ->greeting('Hola '.$nombre.',')
            ->line('Hemos recibido una solicitud para cambiar la contraseña de tu cuenta en el Sistema del Refugio "Los Angelitos de Edgar".')
            ->line('Tu código de verificación de 6 dígitos es:')
            ->line('**'.$this->code.'**')
            ->line('Este código vence en 10 minutos y solo puede ser utilizado una única vez.')
            ->line('Ingresa este código en la pantalla de recuperación junto con tu nueva contraseña.')
            ->line('Si no solicitaste este cambio, puedes ignorar este mensaje de manera segura. Tu contraseña actual no ha sido modificada.')
            ->salutation('Atentamente,'.PHP_EOL.'Equipo del Refugio Los Angelitos de Edgar');
    }
}
