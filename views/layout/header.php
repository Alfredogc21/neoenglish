<?php
declare(strict_types=1);

$pageTitle = isset($title) && is_string($title) ? $title : APP_NAME;
$flashMessages = pull_flash_messages();
$user = current_user();
$isStudent = is_student_authenticated();
$isTeacher = is_teacher_authenticated();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= e($pageTitle) ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Changa:wght@500;700;800&family=Nunito:wght@600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<?= e(asset_url('css/styles.css')) ?>">
</head>
<body class="app-shell">
    <div class="sky-effects" aria-hidden="true">
        <span class="sky-effects__orb sky-effects__orb--a"></span>
        <span class="sky-effects__orb sky-effects__orb--b"></span>
        <span class="sky-effects__orb sky-effects__orb--c"></span>
    </div>

    <header class="topbar">
        <div class="topbar__brand">
            <span class="topbar__logo">IQ</span>
            <div>
                <h1 class="topbar__title">InglesCentral Quest</h1>
                <p class="topbar__subtitle">Tu aventura bilingue para grado 11</p>
            </div>
        </div>
        <nav class="topbar__nav">
            <a class="topbar__link" href="<?= e(route_url('')) ?>">Inicio</a>

            <?php if (!$isStudent && !$isTeacher): ?>
                <a class="topbar__link topbar__link--cta" href="<?= e(route_url('acceso')) ?>">Empieza ahora</a>
            <?php endif; ?>

            <?php if ($isTeacher): ?>
                <a class="topbar__link" href="<?= e(route_url('docente/panel')) ?>">Panel docente</a>
            <?php endif; ?>

            <?php if ($isStudent): ?>
                <a class="topbar__link" href="<?= e(route_url('inicio')) ?>#progreso">Mi progreso</a>
            <?php endif; ?>

            <?php if (is_array($user)): ?>
                <span class="topbar__user"><?= e((string) ($user['name'] ?? 'Usuario')) ?></span>
                <a class="topbar__link topbar__link--danger" href="<?= e(route_url('salir')) ?>">Salir</a>
            <?php endif; ?>
        </nav>
    </header>

    <?php if ($flashMessages !== []): ?>
        <section class="flash-stack">
            <?php foreach ($flashMessages as $flash): ?>
                <?php
                $flashType = (string) ($flash['type'] ?? 'info');
                if (!in_array($flashType, ['success', 'error', 'info'], true)) {
                    $flashType = 'info';
                }
                ?>
                <article class="flash flash--<?= e($flashType) ?>">
                    <p class="flash__text"><?= e((string) ($flash['message'] ?? '')) ?></p>
                </article>
            <?php endforeach; ?>
        </section>
    <?php endif; ?>

    <main class="page-main">
