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
                    'tipo_pregunta_id' => 1,
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
                    'tipo_pregunta_id' => 1,
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
                    'tipo_pregunta_id' => 1,
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
                    'tipo_pregunta_id' => 1,
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
                    'tipo_pregunta_id' => 1,
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
                    'tipo_pregunta_id' => 1,
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
                    'tipo_pregunta_id' => 1,
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

        $fallback = $this->fallbackLevels[$levelId] ?? null;
        if (!is_array($fallback)) {
            return null;
        }

        return $this->prepareFallbackLevelForPlay($fallback);
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
            $questionType = (int) ($question['tipo_pregunta_id'] ?? 1);
            $questionPrompt = (string) ($question['prompt'] ?? '');
            $questionTip = (string) ($question['tip'] ?? '');
            $options = $question['options'] ?? [];
            $options = is_array($options) ? $options : [];
            $isTextQuestion = $questionType === 3;
            $isBuildQuestion = $questionType === 4;

            $submittedRaw = $submittedAnswers[(string) $questionId] ?? null;
            $selectedOptionId = null;
            $selectedText = '';
            $selectedOption = null;
            $selectedFeedback = '';
            $correctOption = $this->findCorrectOption($options);
            $correctOptionId = is_array($correctOption) ? (int) ($correctOption['id'] ?? 0) : null;

            if ($isBuildQuestion) {
                $builtSentence = is_string($submittedRaw) ? trim($submittedRaw) : '';
                $correctSentence = is_array($correctOption) ? trim((string) ($correctOption['text'] ?? '')) : '';
                $selectedText = $builtSentence;
                $selectedFeedback = is_array($correctOption) ? (string) ($correctOption['retroalimentacion'] ?? '') : '';
                $isCorrect = $builtSentence !== ''
                    && $this->normalizeComparableText($builtSentence) === $this->normalizeComparableText($correctSentence);
            } elseif ($isTextQuestion) {
                $selectedText = is_string($submittedRaw) ? trim($submittedRaw) : '';
                $correctText = is_array($correctOption) ? trim((string) ($correctOption['text'] ?? '')) : '';
                $isCorrect = $selectedText !== ''
                    && $this->normalizeComparableText($selectedText) === $this->normalizeComparableText($correctText);
                $selectedOptionId = $correctOptionId;
                $selectedFeedback = is_array($correctOption) ? (string) ($correctOption['retroalimentacion'] ?? '') : '';
            } else {
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

                $isCorrect = $selectedOptionId !== null
                    && $correctOptionId !== null
                    && $selectedOptionId === $correctOptionId;

                $selectedFeedback = is_array($selectedOption) ? (string) ($selectedOption['retroalimentacion'] ?? '') : '';
                $selectedText = is_array($selectedOption) ? (string) ($selectedOption['text'] ?? '') : '';
            }

            if ($isCorrect) {
                $correctAnswers++;
            }

            $details[] = [
                'question_id' => $questionId,
                'prompt' => $questionPrompt,
                'selected_answer' => $selectedText,
                'expected_answer' => is_array($correctOption) ? (string) ($correctOption['text'] ?? '') : '',
                'is_correct' => $isCorrect,
                'tip' => $questionTip,
                'selected_feedback' => $selectedFeedback,
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
                                p.tipo_pregunta_id AS tipo_pregunta_id,
                                p.enunciado_pregunta AS prompt,
                                COALESCE(p.explicacion, "Revisa la estructura de la frase y vuelve a intentarlo.") AS tip
                            FROM preguntas p
                            WHERE p.leccion_id = :lesson_id
                            ORDER BY p.orden_secuencia'
                );
                $questionsQuery->execute(['lesson_id' => $lessonId]);
                $questionRows = $questionsQuery->fetchAll();

                // UNA sola query para TODAS las opciones de la leccion (elimina N+1)
                $allOptionsQuery = $this->pdo->prepare(
                    'SELECT
                        opcion_id AS id,
                        pregunta_id,
                        texto_opcion AS text,
                        es_correcta AS is_correct,
                        COALESCE(retroalimentacion, "") AS retroalimentacion
                    FROM opciones_pregunta
                    WHERE pregunta_id IN (
                        SELECT pregunta_id FROM preguntas WHERE leccion_id = :lesson_id
                    )
                    ORDER BY pregunta_id, opcion_id'
                );
                $allOptionsQuery->execute(['lesson_id' => $lessonId]);
                $allOptionRows = $allOptionsQuery->fetchAll();

                // Agrupar opciones por pregunta_id
                $optionsByQuestion = [];
                foreach ($allOptionRows as $optionRow) {
                    if (!is_array($optionRow)) {
                        continue;
                    }
                    $qId = (int) ($optionRow['pregunta_id'] ?? 0);
                    if (!isset($optionsByQuestion[$qId])) {
                        $optionsByQuestion[$qId] = [];
                    }
                    $optionsByQuestion[$qId][] = [
                        'id' => (int) ($optionRow['id'] ?? 0),
                        'text' => (string) ($optionRow['text'] ?? ''),
                        'is_correct' => (bool) ($optionRow['is_correct'] ?? false),
                        'retroalimentacion' => (string) ($optionRow['retroalimentacion'] ?? ''),
                    ];
                }

                foreach ($questionRows as $questionRow) {
                    if (!is_array($questionRow)) {
                        continue;
                    }

                    $questionId = (int) ($questionRow['id'] ?? 0);
                    $questionType = (int) ($questionRow['tipo_pregunta_id'] ?? 1);
                    $options = $optionsByQuestion[$questionId] ?? [];

                    if ($questionType === 4) {
                        $built = $this->buildTypeFourWordbank($options);
                        $questions[] = [
                            'id' => $questionId,
                            'tipo_pregunta_id' => $questionType,
                            'prompt' => (string) ($questionRow['prompt'] ?? ''),
                            'tip' => (string) ($questionRow['tip'] ?? ''),
                            'options' => $options,
                            'wordbank' => $built['wordbank'],
                            'correct_sentence' => $built['correct_sentence'],
                        ];
                    } else {
                        $shuffledOptions = $options;
                        shuffle($shuffledOptions);

                        $questions[] = [
                            'id' => $questionId,
                            'tipo_pregunta_id' => $questionType,
                            'prompt' => (string) ($questionRow['prompt'] ?? ''),
                            'tip' => (string) ($questionRow['tip'] ?? ''),
                            'options' => $shuffledOptions,
                        ];
                    }
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

    private function normalizeComparableText(string $value): string
    {
        $collapsed = preg_replace('/\s+/u', ' ', trim($value)) ?? trim($value);

        return mb_strtolower($collapsed, 'UTF-8');
    }

    /**
     * @param array<int, array<string, mixed>> $options
     * @return array{wordbank: array<int, string>, correct_sentence: string}
     */
    private function buildTypeFourWordbank(array $options): array
    {
        $correctOption = null;
        $distractorTexts = [];
        foreach ($options as $opt) {
            if (!empty($opt['is_correct'])) {
                $correctOption = $opt;
            } else {
                $distractorTexts[] = trim((string) ($opt['text'] ?? ''));
            }
        }

        $correctSentence = trim((string) ($correctOption['text'] ?? ''));
        $correctWords = $this->splitSentenceIntoWords($correctSentence);
        $distractorTexts = array_values(array_filter($distractorTexts, static fn(string $w): bool => $w !== ''));

        $tokens = array_merge($correctWords, $distractorTexts);
        shuffle($tokens);

        return [
            'wordbank' => $tokens,
            'correct_sentence' => $correctSentence,
        ];
    }

    /**
     * @return array<int, string>
     */
    private function splitSentenceIntoWords(string $sentence): array
    {
        $sentence = trim($sentence);
        if ($sentence === '') {
            return [];
        }

        $parts = preg_split('/\s+/u', $sentence) ?: [];

        return array_values(array_filter(array_map(static function (string $w): string {
            return trim($w);
        }, $parts), static fn(string $w): bool => $w !== ''));
    }

    /**
     * Aplica la misma logica de mezcla que la base de datos cuando no hay conexion.
     *
     * @param array<string, mixed> $level
     * @return array<string, mixed>
     */
    private function prepareFallbackLevelForPlay(array $level): array
    {
        $questions = $level['questions'] ?? [];
        if (!is_array($questions)) {
            return $level;
        }

        $prepared = [];
        foreach ($questions as $question) {
            if (!is_array($question)) {
                continue;
            }

            $options = $question['options'] ?? [];
            $options = is_array($options) ? $options : [];
            $questionType = (int) ($question['tipo_pregunta_id'] ?? 1);

            if ($questionType === 4) {
                $built = $this->buildTypeFourWordbank($options);
                $prepared[] = array_merge($question, [
                    'wordbank' => $built['wordbank'],
                    'correct_sentence' => $built['correct_sentence'],
                ]);
                continue;
            }

            $shuffled = $options;
            shuffle($shuffled);
            $prepared[] = array_merge($question, ['options' => $shuffled]);
        }

        return array_merge($level, ['questions' => $prepared]);
    }
}
