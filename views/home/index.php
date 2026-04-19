<?php
$isStudent = is_student_authenticated();
$isTeacher = is_teacher_authenticated();

$summary = is_array($studentSummary ?? null) ? $studentSummary : [];

$totals = $summary['totals'] ?? [
    'total_xp' => 0,
    'completed_levels' => 0,
    'best_score' => 0,
    'unlocked_levels' => 0,
];
$recentAttempts = $summary['recent_attempts'] ?? [];
?>

<section class="hero-section hero-section--impact">
    <div class="hero-section__content">
        <p class="hero-section__kicker">Ruta gamificada para grado 11</p>
        <h2 class="hero-section__title">aprende ingles con retos que te motivan de verdad</h2>
        <p class="hero-section__description">
            Entrena con microdesafios, gana puntos de experiencia y avanza por niveles entre A2 y B1.
            Tu progreso se registra en tiempo real para estudiantes y docentes.
        </p>

        <div class="hero-section__actions">
            <?php if ($isStudent): ?>
                <a class="button button--primary" href="<?= e(route_url('nivel/1')) ?>">Empieza ahora</a>
            <?php else: ?>
                <a class="button button--primary" href="<?= e(route_url('acceso')) ?>">Empieza ahora</a>
            <?php endif; ?>

            <?php if ($isTeacher): ?>
                <a class="button button--ghost" href="<?= e(route_url('docente/panel')) ?>">Panel docente</a>
            <?php else: ?>
                <a class="button button--ghost" href="#niveles">Ver ruta de niveles</a>
            <?php endif; ?>
        </div>
    </div>

    <div class="hero-section__visual" aria-hidden="true">
        <span class="hero-scene__token hero-scene__token--one"></span>
        <span class="hero-scene__token hero-scene__token--two"></span>
        <span class="hero-scene__token hero-scene__token--three"></span>
        <span class="hero-scene__spark hero-scene__spark--one"></span>
        <span class="hero-scene__spark hero-scene__spark--two"></span>

        <div class="hero-scene__ring hero-scene__ring--one"></div>
        <div class="hero-scene__ring hero-scene__ring--two"></div>
        <div class="hero-scene__path"></div>

        <div class="hero-scene__rocket">
            <span class="hero-scene__rocket-window"></span>
            <span class="hero-scene__rocket-fin hero-scene__rocket-fin--left"></span>
            <span class="hero-scene__rocket-fin hero-scene__rocket-fin--right"></span>
            <span class="hero-scene__rocket-flame"></span>
        </div>

        <span class="hero-scene__badge hero-scene__badge--xp">+10 XP</span>
        <span class="hero-scene__badge hero-scene__badge--racha">Racha x7</span>
    </div>

    <div class="hero-section__cards">
        <article class="impact-card">
            <p class="impact-card__label">Niveles activos</p>
            <p class="impact-card__value"><?= e((string) count($levels)) ?></p>
        </article>
        <article class="impact-card">
            <p class="impact-card__label">Meta diaria</p>
            <p class="impact-card__value">20 min</p>
        </article>
        <article class="impact-card">
            <p class="impact-card__label">Racha recomendada</p>
            <p class="impact-card__value">7 dias</p>
        </article>
    </div>
</section>

<?php if ($isStudent): ?>
    <section id="progreso" class="student-progress">
        <header class="student-progress__header">
            <h3 class="student-progress__title">Tu progreso real</h3>
            <p class="student-progress__subtitle">Tu desempeno se registra en cada intento para medir avance continuo.</p>
        </header>

        <div class="student-progress__stats">
            <article class="progress-stat">
                <p class="progress-stat__label">XP acumulado</p>
                <p class="progress-stat__value"><?= e((string) ($totals['total_xp'] ?? 0)) ?></p>
            </article>
            <article class="progress-stat">
                <p class="progress-stat__label">Niveles completados</p>
                <p class="progress-stat__value"><?= e((string) ($totals['completed_levels'] ?? 0)) ?></p>
            </article>
            <article class="progress-stat">
                <p class="progress-stat__label">Mejor puntaje</p>
                <p class="progress-stat__value"><?= e(number_format((float) ($totals['best_score'] ?? 0), 1)) ?>%</p>
            </article>
            <article class="progress-stat">
                <p class="progress-stat__label">Niveles desbloqueados</p>
                <p class="progress-stat__value"><?= e((string) ($totals['unlocked_levels'] ?? 0)) ?></p>
            </article>
        </div>

        <div class="student-progress__history">
            <h4 class="student-progress__history-title">Intentos recientes</h4>
            <?php if ($recentAttempts === []): ?>
                <p class="student-progress__empty">Aun no tienes intentos registrados. Inicia tu primer nivel.</p>
            <?php else: ?>
                <div class="history-list">
                    <?php foreach ($recentAttempts as $attempt): ?>
                        <article class="history-item">
                            <p class="history-item__title"><?= e((string) ($attempt['level_name'] ?? 'Nivel')) ?> (<?= e((string) ($attempt['cefr_band'] ?? '')) ?>)</p>
                            <p class="history-item__meta">Puntaje: <?= e(number_format((float) ($attempt['score_percent'] ?? 0), 1)) ?>% | XP: <?= e((string) ($attempt['xp_earned'] ?? 0)) ?></p>
                        </article>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    </section>
<?php endif; ?>

<section id="niveles" class="levels-section">
    <header class="levels-section__header">
        <h3 class="levels-section__title">Ruta de aprendizaje por niveles</h3>
        <p class="levels-section__subtitle">Cada nivel combina vocabulario, gramatica funcional y comprension contextual.</p>
    </header>

    <div class="levels-section__grid">
        <?php foreach ($levels as $level): ?>
            <article class="level-card level-card--interactive">
                <header class="level-card__header">
                    <p class="level-card__difficulty"><?= e((string) ($level['difficulty'] ?? '')) ?></p>
                    <p class="level-card__xp">Meta <?= e((string) ($level['xp_goal'] ?? 0)) ?> XP</p>
                </header>

                <h4 class="level-card__title">Nivel <?= e((string) ($level['id'] ?? 0)) ?>: <?= e((string) ($level['name'] ?? '')) ?></h4>
                <p class="level-card__description"><?= e((string) ($level['description'] ?? '')) ?></p>

                <ul class="level-card__skills">
                    <?php foreach (($level['skills'] ?? []) as $skill): ?>
                        <li class="level-card__skill-item"><?= e((string) $skill) ?></li>
                    <?php endforeach; ?>
                </ul>

                <div class="level-card__footer">
                    <span class="level-card__questions"><?= e((string) ($level['question_count'] ?? 0)) ?> retos</span>
                    <?php if ($isStudent): ?>
                        <a class="button button--secondary" href="<?= e(route_url('nivel/' . (string) ($level['id'] ?? 0))) ?>">Jugar nivel</a>
                    <?php else: ?>
                        <a class="button button--secondary" href="<?= e(route_url('acceso')) ?>">Entrar para jugar</a>
                    <?php endif; ?>
                </div>
            </article>
        <?php endforeach; ?>
    </div>
</section>
