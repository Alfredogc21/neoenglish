<?php
declare(strict_types=1);

class LevelModel
{
    private ?PDO $pdo = null;

    private array $fallbackLevels = [
        1 => [
            'id' => 1,
            'name' => 'A2 Starter: School Life',
            'difficulty' => 'A2',
            'description' => 'Vocabulario cotidiano sobre colegio, rutinas y lugares frecuentes.',
            'xp_goal' => 30,
            'lesson_id' => 1,
            'lesson_title' => 'School Basics',
            'skills' => ['Vocabulario', 'Lectura corta', 'Comprension basica'],
            'questions' => [
                [
                    'id' => 101,
                    'prompt' => 'Choose the correct word: "I go to ____ at 7:00 a.m."',
                    'tip' => 'Piensa en el lugar donde estudias todos los dias.',
                    'options' => [
                        ['id' => 1001, 'text' => 'school', 'is_correct' => true],
                        ['id' => 1002, 'text' => 'hospital', 'is_correct' => false],
                        ['id' => 1003, 'text' => 'market', 'is_correct' => false],
                        ['id' => 1004, 'text' => 'airport', 'is_correct' => false],
                    ],
                ],
                [
                    'id' => 102,
                    'prompt' => 'Select the best translation: "Ella estudia ingles".',
                    'tip' => 'Recuerda agregar -s al verbo con she/he en presente simple.',
                    'options' => [
                        ['id' => 1005, 'text' => 'She studies English.', 'is_correct' => true],
                        ['id' => 1006, 'text' => 'She study English.', 'is_correct' => false],
                        ['id' => 1007, 'text' => 'He studies English.', 'is_correct' => false],
                        ['id' => 1008, 'text' => 'She studies spanish.', 'is_correct' => false],
                    ],
                ],
                [
                    'id' => 103,
                    'prompt' => 'Complete: "My favorite subject is ____ because it is interesting."',
                    'tip' => 'Debe ser una materia del colegio.',
                    'options' => [
                        ['id' => 1009, 'text' => 'math', 'is_correct' => true],
                        ['id' => 1010, 'text' => 'run', 'is_correct' => false],
                        ['id' => 1011, 'text' => 'door', 'is_correct' => false],
                        ['id' => 1012, 'text' => 'happy', 'is_correct' => false],
                    ],
                ],
            ],
        ],
        2 => [
            'id' => 2,
            'name' => 'A2+ Communicator: Daily Stories',
            'difficulty' => 'A2+',
            'description' => 'Practica pasado simple y conectores para contar experiencias.',
            'xp_goal' => 40,
            'lesson_id' => 2,
            'lesson_title' => 'Tell me your day',
            'skills' => ['Pasado simple', 'Narracion corta', 'Conectores'],
            'questions' => [
                [
                    'id' => 201,
                    'prompt' => 'Choose the correct past form: "Yesterday I ____ football with my friends."',
                    'tip' => 'Cuando dices yesterday, normalmente usas pasado simple.',
                    'options' => [
                        ['id' => 2001, 'text' => 'play', 'is_correct' => false],
                        ['id' => 2002, 'text' => 'played', 'is_correct' => true],
                        ['id' => 2003, 'text' => 'plays', 'is_correct' => false],
                        ['id' => 2004, 'text' => 'playing', 'is_correct' => false],
                    ],
                ],
                [
                    'id' => 202,
                    'prompt' => 'Select the connector to complete: "I finished homework, ____ I watched a movie."',
                    'tip' => 'La segunda accion ocurre despues de la primera.',
                    'options' => [
                        ['id' => 2005, 'text' => 'then', 'is_correct' => true],
                        ['id' => 2006, 'text' => 'because', 'is_correct' => false],
                        ['id' => 2007, 'text' => 'but', 'is_correct' => false],
                        ['id' => 2008, 'text' => 'if', 'is_correct' => false],
                    ],
                ],
            ],
        ],
        3 => [
            'id' => 3,
            'name' => 'B1 Challenger: Opinions & Plans',
            'difficulty' => 'B1',
            'description' => 'Expresa opiniones y planes usando estructuras de nivel intermedio.',
            'xp_goal' => 50,
            'lesson_id' => 3,
            'lesson_title' => 'Future and opinion',
            'skills' => ['Opiniones', 'Futuro', 'Comprension contextual'],
            'questions' => [
                [
                    'id' => 301,
                    'prompt' => 'Choose the best expression: "In my opinion, social media ____ useful for learning."',
                    'tip' => 'Social media se considera singular en este contexto.',
                    'options' => [
                        ['id' => 3001, 'text' => 'is', 'is_correct' => true],
                        ['id' => 3002, 'text' => 'are', 'is_correct' => false],
                        ['id' => 3003, 'text' => 'be', 'is_correct' => false],
                        ['id' => 3004, 'text' => 'am', 'is_correct' => false],
                    ],
                ],
                [
                    'id' => 302,
                    'prompt' => 'Complete: "If I have enough time, I ____ join the English club."',
                    'tip' => 'Primera condicional: If + presente, ... will + verbo.',
                    'options' => [
                        ['id' => 3005, 'text' => 'will', 'is_correct' => true],
                        ['id' => 3006, 'text' => 'am', 'is_correct' => false],
                        ['id' => 3007, 'text' => 'did', 'is_correct' => false],
                        ['id' => 3008, 'text' => 'has', 'is_correct' => false],
                    ],
                ],
            ],
        ],
    ];

    public function __construct(?PDO $pdo = null)
    {
        if ($pdo instanceof PDO) {
            $this->pdo = $pdo;
            return;
        }

        try {
            $this->pdo = getDatabaseConnection();
        } catch (Throwable $exception) {
            $this->pdo = null;
        }
    }

    public function getAllLevels(): array
    {
        $levels = $this->getAllLevelsFromDatabase();
        if ($levels !== []) {
            return $levels;
        }

        return $this->getAllLevelsFromFallback();
    }

    public function getLevelById(int $levelId): ?array
    {
        $level = $this->getLevelByIdFromDatabase($levelId);
        if (is_array($level)) {
            return $level;
        }

        return $this->fallbackLevels[$levelId] ?? null;
    }

    public function evaluateAnswers(array $level, array $submittedAnswers): array
    {
        $questions = $level['questions'] ?? [];
        if (!is_array($questions)) {
            $questions = [];
        }

        $details = [];
        $attemptAnswers = [];
        $correctAnswers = 0;

        foreach ($questions as $question) {
            $questionId = (int) ($question['id'] ?? 0);
            $questionPrompt = (string) ($question['prompt'] ?? '');
            $questionTip = (string) ($question['tip'] ?? '');
            $options = $question['options'] ?? [];
            $options = is_array($options) ? $options : [];

            $submittedRaw = $submittedAnswers[(string) $questionId] ?? null;
            $selectedOptionId = null;
            if (is_string($submittedRaw) || is_int($submittedRaw)) {
                $filtered = filter_var((string) $submittedRaw, FILTER_VALIDATE_INT, [
                    'options' => ['min_range' => 1],
                ]);
                if ($filtered !== false) {
                    $selectedOptionId = (int) $filtered;
                }
            }

            $selectedOption = $selectedOptionId !== null
                ? $this->findOptionById($options, $selectedOptionId)
                : null;
            $correctOption = $this->findCorrectOption($options);
            $correctOptionId = is_array($correctOption) ? (int) ($correctOption['id'] ?? 0) : null;

            $isCorrect = $selectedOptionId !== null
                && $correctOptionId !== null
                && $selectedOptionId === $correctOptionId;

            if ($isCorrect) {
                $correctAnswers++;
            }

            $details[] = [
                'question_id' => $questionId,
                'prompt' => $questionPrompt,
                'selected_answer' => is_array($selectedOption) ? (string) ($selectedOption['text'] ?? '') : '',
                'expected_answer' => is_array($correctOption) ? (string) ($correctOption['text'] ?? '') : '',
                'is_correct' => $isCorrect,
                'tip' => $questionTip,
            ];

            $attemptAnswers[] = [
                'question_id' => $questionId,
                'selected_option_id' => $selectedOptionId,
                'is_correct' => $isCorrect,
            ];
        }

        $totalQuestions = count($questions);
        $scorePercent = $totalQuestions > 0 ? (int) round(($correctAnswers / $totalQuestions) * 100) : 0;

        $bonusXp = $scorePercent >= 85 ? 10 : 0;
        $earnedXp = ($correctAnswers * 10) + $bonusXp;

        $message = 'Sigue practicando, vas por buen camino.';
        if ($scorePercent >= 90) {
            $message = 'Excelente trabajo, tu precision es de nivel alto.';
        } elseif ($scorePercent >= 70) {
            $message = 'Muy bien, ya tienes buen dominio de este nivel.';
        }

        return [
            'total_questions' => $totalQuestions,
            'correct_answers' => $correctAnswers,
            'score_percent' => $scorePercent,
            'earned_xp' => $earnedXp,
            'bonus_xp' => $bonusXp,
            'message' => $message,
            'details' => $details,
            'attempt_answers' => $attemptAnswers,
        ];
    }

    private function getAllLevelsFromDatabase(): array
    {
        if (!$this->pdo instanceof PDO) {
            return [];
        }

        try {
            $query = $this->pdo->query(
                'SELECT
                    n.nivel_id AS id,
                    n.nombre_nivel AS name,
                    n.banda_cefr AS difficulty,
                    n.descripcion_nivel AS description,
                    n.meta_xp AS xp_goal,
                    COUNT(DISTINCT p.pregunta_id) AS question_count,
                    GROUP_CONCAT(DISTINCT h.nombre_habilidad ORDER BY h.nombre_habilidad SEPARATOR "||") AS skills
                 FROM niveles n
                 LEFT JOIN lecciones le ON le.nivel_id = n.nivel_id
                 LEFT JOIN preguntas p ON p.leccion_id = le.leccion_id
                 LEFT JOIN niveles_habilidades nh ON nh.nivel_id = n.nivel_id
                 LEFT JOIN habilidades h ON h.habilidad_id = nh.habilidad_id
                 GROUP BY n.nivel_id, n.nombre_nivel, n.banda_cefr, n.descripcion_nivel, n.meta_xp
                 ORDER BY n.nivel_id'
            );

            $rows = $query->fetchAll();
            if (!is_array($rows) || $rows === []) {
                return [];
            }

            return array_map(function (array $row): array {
                $skillString = (string) ($row['skills'] ?? '');
                $skills = $skillString !== '' ? explode('||', $skillString) : [];

                return [
                    'id' => (int) ($row['id'] ?? 0),
                    'name' => (string) ($row['name'] ?? ''),
                    'difficulty' => (string) ($row['difficulty'] ?? ''),
                    'description' => (string) ($row['description'] ?? ''),
                    'xp_goal' => (int) ($row['xp_goal'] ?? 0),
                    'question_count' => (int) ($row['question_count'] ?? 0),
                    'skills' => $skills,
                ];
            }, $rows);
        } catch (Throwable $exception) {
            return [];
        }
    }

    private function getLevelByIdFromDatabase(int $levelId): ?array
    {
        if (!$this->pdo instanceof PDO) {
            return null;
        }

        try {
            $levelQuery = $this->pdo->prepare(
                'SELECT
                    n.nivel_id AS id,
                    n.nombre_nivel AS name,
                    n.banda_cefr AS difficulty,
                    n.descripcion_nivel AS description,
                    n.meta_xp AS xp_goal,
                    le.leccion_id AS lesson_id,
                    le.titulo_leccion AS lesson_title
                 FROM niveles n
                 LEFT JOIN lecciones le ON le.nivel_id = n.nivel_id
                 WHERE n.nivel_id = :level_id
                 ORDER BY le.orden_secuencia ASC
                 LIMIT 1'
            );
            $levelQuery->execute(['level_id' => $levelId]);

            $levelRow = $levelQuery->fetch();
            if (!is_array($levelRow)) {
                return null;
            }

            $skillsQuery = $this->pdo->prepare(
                 'SELECT h.nombre_habilidad AS skill_name
                  FROM niveles_habilidades nh
                  INNER JOIN habilidades h ON h.habilidad_id = nh.habilidad_id
                  WHERE nh.nivel_id = :level_id
                  ORDER BY h.nombre_habilidad'
            );
            $skillsQuery->execute(['level_id' => $levelId]);
            $skillRows = $skillsQuery->fetchAll();

            $skills = [];
            foreach ($skillRows as $row) {
                if (is_array($row) && isset($row['skill_name'])) {
                    $skills[] = (string) $row['skill_name'];
                }
            }

            $lessonId = (int) ($levelRow['lesson_id'] ?? 0);
            $questions = [];

            if ($lessonId > 0) {
                $questionsQuery = $this->pdo->prepare(
                    'SELECT
                                p.pregunta_id AS id,
                                p.enunciado_pregunta AS prompt,
                                COALESCE(p.explicacion, "Revisa la estructura de la frase y vuelve a intentarlo.") AS tip
                            FROM preguntas p
                            WHERE p.leccion_id = :lesson_id
                            ORDER BY p.orden_secuencia'
                );
                $questionsQuery->execute(['lesson_id' => $lessonId]);
                $questionRows = $questionsQuery->fetchAll();

                $optionsQuery = $this->pdo->prepare(
                    'SELECT
                                opcion_id AS id,
                                texto_opcion AS text,
                                es_correcta AS is_correct
                            FROM opciones_pregunta
                            WHERE pregunta_id = :question_id
                            ORDER BY opcion_id'
                );

                foreach ($questionRows as $questionRow) {
                    if (!is_array($questionRow)) {
                        continue;
                    }

                    $questionId = (int) ($questionRow['id'] ?? 0);
                    $optionsQuery->execute(['question_id' => $questionId]);
                    $optionRows = $optionsQuery->fetchAll();

                    $options = [];
                    foreach ($optionRows as $optionRow) {
                        if (!is_array($optionRow)) {
                            continue;
                        }

                        $options[] = [
                            'id' => (int) ($optionRow['id'] ?? 0),
                            'text' => (string) ($optionRow['text'] ?? ''),
                            'is_correct' => (bool) ($optionRow['is_correct'] ?? false),
                        ];
                    }

                    $questions[] = [
                        'id' => $questionId,
                        'prompt' => (string) ($questionRow['prompt'] ?? ''),
                        'tip' => (string) ($questionRow['tip'] ?? ''),
                        'options' => $options,
                    ];
                }
            }

            return [
                'id' => (int) ($levelRow['id'] ?? 0),
                'name' => (string) ($levelRow['name'] ?? ''),
                'difficulty' => (string) ($levelRow['difficulty'] ?? ''),
                'description' => (string) ($levelRow['description'] ?? ''),
                'xp_goal' => (int) ($levelRow['xp_goal'] ?? 0),
                'lesson_id' => $lessonId,
                'lesson_title' => (string) ($levelRow['lesson_title'] ?? ''),
                'skills' => $skills,
                'questions' => $questions,
                'question_count' => count($questions),
            ];
        } catch (Throwable $exception) {
            return null;
        }
    }

    private function getAllLevelsFromFallback(): array
    {
        $summary = [];

        foreach ($this->fallbackLevels as $level) {
            $questions = $level['questions'] ?? [];

            $summary[] = [
                'id' => (int) ($level['id'] ?? 0),
                'name' => (string) ($level['name'] ?? ''),
                'difficulty' => (string) ($level['difficulty'] ?? ''),
                'description' => (string) ($level['description'] ?? ''),
                'xp_goal' => (int) ($level['xp_goal'] ?? 0),
                'question_count' => is_array($questions) ? count($questions) : 0,
                'skills' => is_array($level['skills'] ?? null) ? $level['skills'] : [],
            ];
        }

        return $summary;
    }

    private function findOptionById(array $options, int $optionId): ?array
    {
        foreach ($options as $option) {
            if (!is_array($option)) {
                continue;
            }

            if ((int) ($option['id'] ?? 0) === $optionId) {
                return $option;
            }
        }

        return null;
    }

    private function findCorrectOption(array $options): ?array
    {
        foreach ($options as $option) {
            if (!is_array($option)) {
                continue;
            }

            if ((bool) ($option['is_correct'] ?? false) === true) {
                return $option;
            }
        }

        return null;
    }
}
