<?php
declare(strict_types=1);

class TeacherController extends BaseController
{
    private ?TeacherDashboardModel $dashboardModel;

    public function __construct(?TeacherDashboardModel $dashboardModel = null)
    {
        if ($dashboardModel instanceof TeacherDashboardModel) {
            $this->dashboardModel = $dashboardModel;
            return;
        }

        try {
            $this->dashboardModel = new TeacherDashboardModel();
        } catch (Throwable $exception) {
            $this->dashboardModel = null;
        }
    }

    public function dashboard(): void
    {
        $this->requireTeacherAuthentication();

        if (!$this->dashboardModel instanceof TeacherDashboardModel) {
            $this->abort(500, 'No existe conexion activa para consultar estadisticas docentes.');
            return;
        }

        try {
            $dashboard = $this->dashboardModel->getOverview();
        } catch (Throwable $exception) {
            $this->abort(500, 'No fue posible cargar el panel docente. Revisa que la base de datos este lista.');
            return;
        }

        $this->view('teacher/dashboard', [
            'title' => APP_NAME . ' | Panel docente',
            'dashboard' => $dashboard,
        ]);
    }
}
