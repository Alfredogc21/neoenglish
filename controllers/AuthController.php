<?php
declare(strict_types=1);

class AuthController extends BaseController
{
    private ?AuthModel $authModel;

    public function __construct(?AuthModel $authModel = null)
    {
        if ($authModel instanceof AuthModel) {
            $this->authModel = $authModel;
            return;
        }

        try {
            $this->authModel = new AuthModel();
        } catch (Throwable $exception) {
            $this->authModel = null;
        }
    }

    public function access(): void
    {
        if (is_student_authenticated()) {
            redirect_to('inicio');
            return;
        }

        if (is_teacher_authenticated()) {
            redirect_to('docente/panel');
            return;
        }

        $this->view('auth/access', [
            'title' => APP_NAME . ' | Acceso',
        ]);
    }

    public function registerStudent(): void
    {
        if (($this->getMethod() !== 'POST')) {
            redirect_to('acceso');
            return;
        }

        if (!$this->authModel instanceof AuthModel) {
            set_flash('error', 'No hay conexion con la base de datos para registrar estudiantes.');
            redirect_to('acceso');
            return;
        }

        try {
            $result = $this->authModel->registerStudent($_POST);
        } catch (Throwable $exception) {
            set_flash('error', 'No fue posible registrar el estudiante. Verifica la base de datos.');
            redirect_to('acceso');
            return;
        }

        if (!$result['ok']) {
            set_flash('error', (string) ($result['message'] ?? 'No se pudo crear la cuenta.'));
            redirect_to('acceso');
            return;
        }

        $student = $result['student'] ?? [];
        set_auth_session([
            'id' => (int) ($student['id'] ?? 0),
            'name' => (string) ($student['name'] ?? ''),
            'email' => (string) ($student['email'] ?? ''),
            'role' => 'student',
            'grade_group' => (string) ($student['grade_group'] ?? ''),
        ]);

        set_flash('success', (string) ($result['message'] ?? 'Registro exitoso.'));
        redirect_to('inicio');
    }

    public function loginStudent(): void
    {
        if (($this->getMethod() !== 'POST')) {
            redirect_to('acceso');
            return;
        }

        if (!$this->authModel instanceof AuthModel) {
            set_flash('error', 'No hay conexion con la base de datos para iniciar sesion.');
            redirect_to('acceso');
            return;
        }

        $email = trim((string) ($_POST['student_email'] ?? ''));
        $password = (string) ($_POST['student_password'] ?? '');

        if ($email === '' || $password === '') {
            set_flash('error', 'Ingresa correo y contrasena para continuar.');
            redirect_to('acceso');
            return;
        }

        try {
            $student = $this->authModel->loginStudent($email, $password);
        } catch (Throwable $exception) {
            set_flash('error', 'No fue posible iniciar sesion como estudiante.');
            redirect_to('acceso');
            return;
        }

        if ($student === null) {
            set_flash('error', 'Credenciales de estudiante invalidas.');
            redirect_to('acceso');
            return;
        }

        set_auth_session($student);
        set_flash('success', 'Bienvenido de nuevo. Continua tu ruta de aprendizaje.');
        redirect_to('inicio');
    }

    public function loginTeacher(): void
    {
        if (($this->getMethod() !== 'POST')) {
            redirect_to('acceso');
            return;
        }

        if (!$this->authModel instanceof AuthModel) {
            set_flash('error', 'No hay conexion con la base de datos para autenticar docentes.');
            redirect_to('acceso');
            return;
        }

        $email = trim((string) ($_POST['teacher_email'] ?? ''));
        $password = (string) ($_POST['teacher_password'] ?? '');

        if ($email === '' || $password === '') {
            set_flash('error', 'Ingresa correo y contrasena del docente.');
            redirect_to('acceso');
            return;
        }

        try {
            $teacher = $this->authModel->loginTeacher($email, $password);
        } catch (Throwable $exception) {
            set_flash('error', 'No fue posible iniciar sesion como docente.');
            redirect_to('acceso');
            return;
        }

        if ($teacher === null) {
            set_flash('error', 'Credenciales de docente invalidas.');
            redirect_to('acceso');
            return;
        }

        set_auth_session($teacher);
        set_flash('success', 'Panel docente habilitado correctamente.');
        redirect_to('docente/panel');
    }

    public function logout(): void
    {
        clear_auth_session();
        set_flash('success', 'Sesion cerrada correctamente.');
        redirect_to('acceso');
    }

    private function getMethod(): string
    {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        return is_string($method) ? strtoupper($method) : 'GET';
    }
}
