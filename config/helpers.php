<?php
declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Helpers de vistas, sesiones y seguridad
|--------------------------------------------------------------------------
*/

function render_view(string $viewPath, array $data = []): void
{
    extract($data, EXTR_SKIP);

    require __DIR__ . '/../views/layout/header.php';
    require __DIR__ . '/../views/' . $viewPath . '.php';
    require __DIR__ . '/../views/layout/footer.php';
}

function e(mixed $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

function asset_url(string $assetPath): string
{
    return APP_BASE_URL . '/public/' . ltrim($assetPath, '/');
}

function route_url(string $route = ''): string
{
    $normalizedRoute = trim($route, '/');
    if ($normalizedRoute === '') {
        return APP_BASE_URL . '/';
    }

    return APP_BASE_URL . '/' . $normalizedRoute;
}

function redirect_to(string $route = ''): void
{
    header('Location: ' . route_url($route));
    exit;
}

function current_user(): ?array
{
    $auth = $_SESSION['auth'] ?? null;

    return is_array($auth) ? $auth : null;
}

function set_auth_session(array $auth): void
{
    $_SESSION['auth'] = [
        'id' => (int) ($auth['id'] ?? 0),
        'name' => (string) ($auth['name'] ?? ''),
        'email' => (string) ($auth['email'] ?? ''),
        'role' => (string) ($auth['role'] ?? ''),
        'grade_group' => (string) ($auth['grade_group'] ?? ''),
    ];
}

function clear_auth_session(): void
{
    unset($_SESSION['auth']);
}

function is_authenticated(): bool
{
    $user = current_user();

    return is_array($user) && isset($user['id']) && (int) $user['id'] > 0;
}

function is_student_authenticated(): bool
{
    $user = current_user();

    return is_array($user)
        && isset($user['role'])
        && (string) $user['role'] === 'student'
        && isset($user['id'])
        && (int) $user['id'] > 0;
}

function is_teacher_authenticated(): bool
{
    $user = current_user();

    return is_array($user)
        && isset($user['role'])
        && (string) $user['role'] === 'teacher'
        && isset($user['id'])
        && (int) $user['id'] > 0;
}

function set_flash(string $type, string $message): void
{
    if (!isset($_SESSION['flash_messages']) || !is_array($_SESSION['flash_messages'])) {
        $_SESSION['flash_messages'] = [];
    }

    $_SESSION['flash_messages'][] = [
        'type' => $type,
        'message' => $message,
    ];
}

function pull_flash_messages(): array
{
    $messages = $_SESSION['flash_messages'] ?? [];
    unset($_SESSION['flash_messages']);

    return is_array($messages) ? $messages : [];
}
