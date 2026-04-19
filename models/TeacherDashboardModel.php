<?php
declare(strict_types=1);

class TeacherDashboardModel
{
    private PDO $pdo;

    public function __construct(?PDO $pdo = null)
    {
        $this->pdo = $pdo ?? getDatabaseConnection();
    }

    public function getOverview(): array
    {
        $globalQuery = $this->pdo->query(
            'SELECT
                (SELECT COUNT(*) FROM estudiantes) AS total_students,
                (SELECT COUNT(*) FROM intentos_estudiante) AS total_attempts,
                (SELECT COALESCE(AVG(porcentaje_puntaje), 0) FROM intentos_estudiante) AS average_score,
                (SELECT COALESCE(SUM(xp_ganada), 0) FROM intentos_estudiante) AS total_xp'
        );

        $global = $globalQuery->fetch() ?: [];

        $students = $this->pdo->query(
            'SELECT
                e.estudiante_id AS student_id,
                CONCAT(e.nombres, " ", e.apellidos) AS student_name,
                e.grupo_grado AS grade_group,
                COUNT(sa.intento_id) AS attempts,
                COALESCE(AVG(sa.porcentaje_puntaje), 0) AS average_score,
                COALESCE(SUM(sa.xp_ganada), 0) AS total_xp
             FROM estudiantes e
             LEFT JOIN intentos_estudiante sa ON sa.estudiante_id = e.estudiante_id
             GROUP BY e.estudiante_id, student_name, e.grupo_grado
             ORDER BY average_score DESC, total_xp DESC'
        )->fetchAll();

        $levels = $this->pdo->query(
            'SELECT
                n.nivel_id AS level_id,
                n.nombre_nivel AS level_name,
                n.banda_cefr AS cefr_band,
                COUNT(sa.intento_id) AS attempts,
                COALESCE(AVG(sa.porcentaje_puntaje), 0) AS average_score
             FROM niveles n
             LEFT JOIN lecciones le ON le.nivel_id = n.nivel_id
             LEFT JOIN intentos_estudiante sa ON sa.leccion_id = le.leccion_id
             GROUP BY n.nivel_id, n.nombre_nivel, n.banda_cefr
             ORDER BY n.nivel_id'
        )->fetchAll();

        $skills = $this->pdo->query(
            'SELECT
                h.habilidad_id AS skill_id,
                h.nombre_habilidad AS skill_name,
                COUNT(sa.intento_id) AS attempts,
                COALESCE(AVG(sa.porcentaje_puntaje), 0) AS average_score
             FROM habilidades h
             LEFT JOIN niveles_habilidades nh ON nh.habilidad_id = h.habilidad_id
             LEFT JOIN lecciones le ON le.nivel_id = nh.nivel_id
             LEFT JOIN intentos_estudiante sa ON sa.leccion_id = le.leccion_id
             GROUP BY h.habilidad_id, h.nombre_habilidad
             ORDER BY average_score DESC, attempts DESC'
        )->fetchAll();

        $recentAttempts = $this->pdo->query(
            'SELECT
                sa.intento_id AS attempt_id,
                sa.finalizado_en AS ended_at,
                sa.porcentaje_puntaje AS score_percent,
                sa.xp_ganada AS xp_earned,
                CONCAT(e.nombres, " ", e.apellidos) AS student_name,
                n.nombre_nivel AS level_name,
                n.banda_cefr AS cefr_band
             FROM intentos_estudiante sa
             INNER JOIN estudiantes e ON e.estudiante_id = sa.estudiante_id
             INNER JOIN lecciones le ON le.leccion_id = sa.leccion_id
             INNER JOIN niveles n ON n.nivel_id = le.nivel_id
             ORDER BY sa.intento_id DESC
             LIMIT 12'
        )->fetchAll();

        return [
            'global' => [
                'total_students' => (int) ($global['total_students'] ?? 0),
                'total_attempts' => (int) ($global['total_attempts'] ?? 0),
                'average_score' => (float) ($global['average_score'] ?? 0),
                'total_xp' => (int) ($global['total_xp'] ?? 0),
            ],
            'students' => $students,
            'levels' => $levels,
            'skills' => $skills,
            'recent_attempts' => $recentAttempts,
        ];
    }
}
