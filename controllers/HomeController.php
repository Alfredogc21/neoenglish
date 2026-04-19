<?php
declare(strict_types=1);

class HomeController extends BaseController
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

    public function index(): void
    {
        $levels = $this->levelModel->getAllLevels();
        $studentSummary = null;
        $user = current_user();

        if (is_student_authenticated() && is_array($user) && $this->progressModel instanceof ProgressModel) {
            try {
                $studentSummary = $this->progressModel->getStudentSummary((int) $user['id']);
            } catch (Throwable $exception) {
                set_flash('error', 'No se pudo cargar tu progreso. Revisa la conexion a la base de datos.');
            }
        }

        $this->view('home/index', [
            'title' => APP_NAME . ' | Aprende Ingles Jugando',
            'levels' => $levels,
            'studentSummary' => $studentSummary,
            'currentUser' => $user,
        ]);
    }

    public function notFound(): void
    {
        $this->abort(404, 'La ruta solicitada no existe.');
    }
}
