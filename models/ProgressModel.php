<?php
declare(strict_types=1);

class ProgressModel
{
    private PDO $pdo;

    public function __construct(?PDO $pdo = null)
    {
        $this->pdo = $pdo ?? getDatabaseConnection();
    }

    public function saveStudentAttempt(int $studentId, array $level, array $evaluation): int
    {
        $levelId = (int) ($level['id'] ?? 0);
        $lessonId = (int) ($level['lesson_id'] ?? 0);

        if ($levelId <= 0 || $lessonId <= 0) {
            throw new RuntimeException('No fue posible guardar el intento: nivel o leccion no validos.');
        }

        $scorePercent = (float) ($evaluation['score_percent'] ?? 0);
        $earnedXp = (int) ($evaluation['earned_xp'] ?? 0);
        $attemptAnswers = $evaluation['attempt_answers'] ?? [];

        $this->pdo->beginTransaction();

        try {
            $attemptInsert = $this->pdo->prepare(
                'INSERT INTO intentos_estudiante (estudiante_id, leccion_id, iniciado_en, finalizado_en, porcentaje_puntaje, xp_ganada)
                 VALUES (:student_id, :lesson_id, NOW(), NOW(), :score_percent, :xp_earned)'
            );

            $attemptInsert->execute([
                'student_id' => $studentId,
                'lesson_id' => $lessonId,
                'score_percent' => $scorePercent,
                'xp_earned' => $earnedXp,
            ]);

            $attemptId = (int) $this->pdo->lastInsertId();

            if ($attemptId <= 0) {
                throw new RuntimeException('No se pudo generar el identificador del intento.');
            }

            $answerInsert = $this->pdo->prepare(
                'INSERT INTO respuestas_intento_estudiante (intento_id, pregunta_id, opcion_seleccionada_id, es_correcta)
                 VALUES (:attempt_id, :question_id, :selected_option_id, :is_correct)'
            );

            foreach ($attemptAnswers as $answer) {
                $selectedOptionId = $answer['selected_option_id'] ?? null;
                $selectedOptionId = is_int($selectedOptionId) && $selectedOptionId > 0 ? $selectedOptionId : null;

                $answerInsert->execute([
                    'attempt_id' => $attemptId,
                    'question_id' => (int) ($answer['question_id'] ?? 0),
                    'selected_option_id' => $selectedOptionId,
                    'is_correct' => (bool) ($answer['is_correct'] ?? false) ? 1 : 0,
                ]);
            }

            $progressUpdate = $this->pdo->prepare(
                'INSERT INTO progreso_nivel_estudiante
                    (estudiante_id, nivel_id, desbloqueado_en, completado_en, mejor_porcentaje, xp_ganada)
                 VALUES
                    (:student_id, :level_id, NOW(), :completed_at, :best_score_percent, :earned_xp)
                 ON DUPLICATE KEY UPDATE
                    completado_en = CASE
                        WHEN VALUES(completado_en) IS NULL THEN progreso_nivel_estudiante.completado_en
                        WHEN progreso_nivel_estudiante.completado_en IS NULL THEN VALUES(completado_en)
                        ELSE progreso_nivel_estudiante.completado_en
                    END,
                    mejor_porcentaje = GREATEST(progreso_nivel_estudiante.mejor_porcentaje, VALUES(mejor_porcentaje)),
                    xp_ganada = progreso_nivel_estudiante.xp_ganada + VALUES(xp_ganada)'
            );

            $completedAt = $scorePercent >= 70 ? date('Y-m-d H:i:s') : null;

            $progressUpdate->execute([
                'student_id' => $studentId,
                'level_id' => $levelId,
                'completed_at' => $completedAt,
                'best_score_percent' => $scorePercent,
                'earned_xp' => $earnedXp,
            ]);

            $this->pdo->commit();

            return $attemptId;
        } catch (Throwable $exception) {
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }

            throw $exception;
        }
    }

    public function getStudentSummary(int $studentId): array
    {
        $summaryQuery = $this->pdo->prepare(
            'SELECT
                COALESCE(SUM(slp.xp_ganada), 0) AS total_xp,
                COALESCE(SUM(CASE WHEN slp.completado_en IS NOT NULL THEN 1 ELSE 0 END), 0) AS completed_levels,
                COALESCE(MAX(slp.mejor_porcentaje), 0) AS best_score,
                COUNT(slp.nivel_id) AS unlocked_levels
             FROM progreso_nivel_estudiante slp
             WHERE slp.estudiante_id = :student_id'
        );
        $summaryQuery->execute(['student_id' => $studentId]);
        $summary = $summaryQuery->fetch() ?: [];

        $recentAttemptsQuery = $this->pdo->prepare(
            'SELECT
                sa.intento_id AS attempt_id,
                sa.finalizado_en AS ended_at,
                sa.porcentaje_puntaje AS score_percent,
                sa.xp_ganada AS xp_earned,
                n.nombre_nivel AS level_name,
                n.banda_cefr AS cefr_band
             FROM intentos_estudiante sa
             INNER JOIN lecciones le ON le.leccion_id = sa.leccion_id
             INNER JOIN niveles n ON n.nivel_id = le.nivel_id
             WHERE sa.estudiante_id = :student_id
             ORDER BY sa.intento_id DESC
             LIMIT 5'
        );
        $recentAttemptsQuery->execute(['student_id' => $studentId]);

        return [
            'totals' => [
                'total_xp' => (int) ($summary['total_xp'] ?? 0),
                'completed_levels' => (int) ($summary['completed_levels'] ?? 0),
                'best_score' => (float) ($summary['best_score'] ?? 0),
                'unlocked_levels' => (int) ($summary['unlocked_levels'] ?? 0),
            ],
            'recent_attempts' => $recentAttemptsQuery->fetchAll(),
        ];
    }
}
