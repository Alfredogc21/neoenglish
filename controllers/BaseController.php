<?php
declare(strict_types=1);

abstract class BaseController
{
    protected function view(string $viewPath, array $data = []): void
    {
        render_view($viewPath, $data);
    }

    protected function requireStudentAuthentication(): void
    {
        if (is_student_authenticated()) {
            return;
        }

        set_flash('error', 'Debes iniciar sesion como estudiante para entrar al nivel.');
        redirect_to('acceso');
    }

    protected function requireTeacherAuthentication(): void
    {
        if (is_teacher_authenticated()) {
            return;
        }

        set_flash('error', 'Acceso restringido al panel docente.');
        redirect_to('acceso');
    }

    protected function abort(int $statusCode, string $message): void
    {
        http_response_code($statusCode);

        $this->view('errors/error', [
            'title' => 'Error',
            'statusCode' => $statusCode,
            'message' => $message,
        ]);
    }
}
