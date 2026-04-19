<?php
declare(strict_types=1);

require_once __DIR__ . '/config/app.php';
require_once __DIR__ . '/config/helpers.php';
require_once __DIR__ . '/config/database.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

spl_autoload_register(static function (string $className): void {
    $directories = [
        __DIR__ . '/controllers/',
        __DIR__ . '/models/',
    ];

    foreach ($directories as $directory) {
        $classFile = $directory . $className . '.php';
        if (is_file($classFile)) {
            require_once $classFile;
            return;
        }
    }
});

$requestedPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);
$requestedPath = is_string($requestedPath) ? $requestedPath : '/';

if (APP_BASE_PATH !== '' && strpos($requestedPath, APP_BASE_PATH) === 0) {
    $requestedPath = substr($requestedPath, strlen(APP_BASE_PATH));
}

$routeFromPath = trim($requestedPath, '/');
$routeFromQuery = $_GET['route'] ?? '';
$route = is_string($routeFromQuery) && $routeFromQuery !== ''
    ? trim($routeFromQuery, '/')
    : $routeFromPath;

try {
    if ($route === '' || $route === 'index.php' || $route === 'inicio') {
        $controller = new HomeController();
        $controller->index();
        exit;
    }

    if ($route === 'acceso') {
        $controller = new AuthController();
        $controller->access();
        exit;
    }

    if ($route === 'registro/estudiante') {
        $controller = new AuthController();
        $controller->registerStudent();
        exit;
    }

    if ($route === 'login/estudiante') {
        $controller = new AuthController();
        $controller->loginStudent();
        exit;
    }

    if ($route === 'login/docente') {
        $controller = new AuthController();
        $controller->loginTeacher();
        exit;
    }

    if ($route === 'salir') {
        $controller = new AuthController();
        $controller->logout();
        exit;
    }

    if ($route === 'docente/panel') {
        $controller = new TeacherController();
        $controller->dashboard();
        exit;
    }

    if (preg_match('/^nivel\/(\d+)$/', $route, $matches) === 1) {
        $controller = new LessonController();
        $controller->play((int) $matches[1]);
        exit;
    }

    $controller = new HomeController();
    $controller->notFound();
} catch (Throwable $exception) {
    http_response_code(500);
    render_view('errors/error', [
        'title' => 'Error interno',
        'statusCode' => 500,
        'message' => 'Se produjo un error inesperado. Revisa el codigo y vuelve a intentar.',
    ]);
}
