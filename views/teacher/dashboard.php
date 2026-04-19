<?php
$global = $dashboard['global'] ?? [];
$students = $dashboard['students'] ?? [];
$levels = $dashboard['levels'] ?? [];
$skills = $dashboard['skills'] ?? [];
$recentAttempts = $dashboard['recent_attempts'] ?? [];
?>

<section class="teacher-hero">
    <div class="teacher-hero__copy">
        <p class="teacher-hero__kicker">Panel pedagogico</p>
        <h2 class="teacher-hero__title">Analitica de aprendizaje en tiempo real</h2>
        <p class="teacher-hero__text">Monitorea desempeno por estudiante, por nivel CEFR y por habilidad clave.</p>
    </div>
</section>

<section class="teacher-metrics">
    <article class="metric-card">
        <p class="metric-card__label">Estudiantes registrados</p>
        <p class="metric-card__value"><?= e((string) ($global['total_students'] ?? 0)) ?></p>
    </article>
    <article class="metric-card">
        <p class="metric-card__label">Intentos totales</p>
        <p class="metric-card__value"><?= e((string) ($global['total_attempts'] ?? 0)) ?></p>
    </article>
    <article class="metric-card">
        <p class="metric-card__label">Promedio global</p>
        <p class="metric-card__value"><?= e(number_format((float) ($global['average_score'] ?? 0), 1)) ?>%</p>
    </article>
    <article class="metric-card">
        <p class="metric-card__label">XP acumulado</p>
        <p class="metric-card__value"><?= e((string) ($global['total_xp'] ?? 0)) ?></p>
    </article>
</section>

<section class="teacher-grid">
    <article class="panel-card">
        <header class="panel-card__header">
            <h3 class="panel-card__title">Rendimiento por estudiante</h3>
            <p class="panel-card__subtitle">Ranking para detectar fortalezas y necesidades.</p>
        </header>

        <div class="table-wrap">
            <table class="panel-table">
                <thead>
                    <tr>
                        <th>Estudiante</th>
                        <th>Grupo</th>
                        <th>Intentos</th>
                        <th>Promedio</th>
                        <th>XP</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($students as $student): ?>
                        <tr>
                            <td><?= e((string) ($student['student_name'] ?? '')) ?></td>
                            <td><?= e((string) ($student['grade_group'] ?? '')) ?></td>
                            <td><?= e((string) ($student['attempts'] ?? 0)) ?></td>
                            <td><?= e(number_format((float) ($student['average_score'] ?? 0), 1)) ?>%</td>
                            <td><?= e((string) ($student['total_xp'] ?? 0)) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </article>

    <article class="panel-card">
        <header class="panel-card__header">
            <h3 class="panel-card__title">Rendimiento por nivel</h3>
            <p class="panel-card__subtitle">Compara avance entre A2, A2+ y B1.</p>
        </header>

        <div class="table-wrap">
            <table class="panel-table">
                <thead>
                    <tr>
                        <th>Nivel</th>
                        <th>Banda</th>
                        <th>Intentos</th>
                        <th>Promedio</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($levels as $level): ?>
                        <tr>
                            <td><?= e((string) ($level['level_name'] ?? '')) ?></td>
                            <td><?= e((string) ($level['cefr_band'] ?? '')) ?></td>
                            <td><?= e((string) ($level['attempts'] ?? 0)) ?></td>
                            <td><?= e(number_format((float) ($level['average_score'] ?? 0), 1)) ?>%</td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </article>
</section>

<section class="teacher-grid">
    <article class="panel-card">
        <header class="panel-card__header">
            <h3 class="panel-card__title">Rendimiento por habilidad</h3>
            <p class="panel-card__subtitle">Identifica habilidades con mejor o menor respuesta.</p>
        </header>

        <div class="skill-list">
            <?php foreach ($skills as $skill): ?>
                <?php $skillAverage = (float) ($skill['average_score'] ?? 0); ?>
                <div class="skill-item">
                    <div class="skill-item__top">
                        <p class="skill-item__name"><?= e((string) ($skill['skill_name'] ?? '')) ?></p>
                        <p class="skill-item__value"><?= e(number_format($skillAverage, 1)) ?>%</p>
                    </div>
                    <div class="skill-item__bar" style="--meter-value: <?= e((string) max(0, min(100, (int) round($skillAverage)))) ?>%;"></div>
                    <p class="skill-item__meta">Intentos relacionados: <?= e((string) ($skill['attempts'] ?? 0)) ?></p>
                </div>
            <?php endforeach; ?>
        </div>
    </article>

    <article class="panel-card">
        <header class="panel-card__header">
            <h3 class="panel-card__title">Intentos recientes</h3>
            <p class="panel-card__subtitle">Ultimos resultados reportados por los estudiantes.</p>
        </header>

        <div class="table-wrap">
            <table class="panel-table">
                <thead>
                    <tr>
                        <th>Estudiante</th>
                        <th>Nivel</th>
                        <th>Puntaje</th>
                        <th>XP</th>
                        <th>Fecha</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($recentAttempts as $attempt): ?>
                        <tr>
                            <td><?= e((string) ($attempt['student_name'] ?? '')) ?></td>
                            <td><?= e((string) ($attempt['level_name'] ?? '')) ?> (<?= e((string) ($attempt['cefr_band'] ?? '')) ?>)</td>
                            <td><?= e(number_format((float) ($attempt['score_percent'] ?? 0), 1)) ?>%</td>
                            <td><?= e((string) ($attempt['xp_earned'] ?? 0)) ?></td>
                            <td><?= e((string) ($attempt['ended_at'] ?? '')) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </article>
</section>
