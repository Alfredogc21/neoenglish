<?php
declare(strict_types=1);

class LessonController extends BaseController
{
    private LevelModel $levelModel;
    private ?ProgressModel $progressModel;

    public function __construct(?LevelModel $levelModel = null, ?ProgressModel $progressModel = null)
    {
        $this->levelModel = $levelModel ?? new LevelModel();

        if ($progressModel instanceof ProgressModel) {
            $this->progressModel = $progressModel;
            return;
        }

        try {
            $this->progressModel = new ProgressModel();
        } catch (Throwable $exception) {
            $this->progressModel = null;
        }
    }

    public function play(int $levelId): void
    {
        $this->requireStudentAuthentication();

        $user = current_user();
        $studentId = is_array($user) ? (int) ($user['id'] ?? 0) : 0;
        $nextLevelId = $this->resolveNextLevelId($levelId);

        $level = $this->levelModel->getLevelById($levelId);
        if ($level === null) {
            $this->abort(404, 'El nivel solicitado no fue encontrado.');
            return;
        }

        $result = null;
        $isPostRequest = ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST';

        if ($isPostRequest) {
            $submittedAnswers = $_POST['answers'] ?? [];
            $submittedAnswers = is_array($submittedAnswers) ? $submittedAnswers : [];
            $autoNextRequested = (string) ($_POST['auto_next'] ?? '0') === '1';

            $result = $this->levelModel->evaluateAnswers($level, $submittedAnswers);
            $shouldTravelToNext = $autoNextRequested
                && $nextLevelId !== null
                && (int) ($result['score_percent'] ?? 0) >= 100;

            if ($this->progressModel instanceof ProgressModel) {
                try {
                    $attemptId = $this->progressModel->saveStudentAttempt($studentId, $level, $result);
                    $result['attempt_id'] = $attemptId;
                    set_flash('success', 'Intento guardado correctamente. Tu progreso fue actualizado.');

                    if ($shouldTravelToNext) {
                        set_flash('success', 'Excelente trabajo. Despegando al siguiente reto.');
                        redirect_to('nivel/' . (string) $nextLevelId);
                    }
                } catch (Throwable $exception) {
                    set_flash('error', 'No fue posible guardar el intento en la base de datos.');
                }
            } else {
                set_flash('error', 'No hay conexion con la base de datos para guardar progreso real.');
            }
        }

        $this->view('lesson/play', [
            'title' => APP_NAME . ' | Nivel ' . $level['id'],
            'level' => $level,
            'result' => $result,
            'nextLevelId' => $nextLevelId,
        ]);
    }

    private function resolveNextLevelId(int $currentLevelId): ?int
    {
        $allLevels = $this->levelModel->getAllLevels();
        if (!is_array($allLevels) || $allLevels === []) {
            return null;
        }

        $orderedIds = [];
        foreach ($allLevels as $level) {
            if (!is_array($level)) {
                continue;
            }

            $levelId = (int) ($level['id'] ?? 0);
            if ($levelId > 0) {
                $orderedIds[] = $levelId;
            }
        }

        if ($orderedIds === []) {
            return null;
        }

        $orderedIds = array_values(array_unique($orderedIds));
        sort($orderedIds);

        foreach ($orderedIds as $levelId) {
            if ($levelId > $currentLevelId) {
                return $levelId;
            }
        }

        return null;
    }
}
