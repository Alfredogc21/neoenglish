<section class="error-view">
    <p class="error-view__badge">Estado <?= e((string) $statusCode) ?></p>
    <h2 class="error-view__title">No se pudo completar la solicitud</h2>
    <p class="error-view__message"><?= e((string) $message) ?></p>
    <div class="error-view__actions">
        <a class="button button--primary" href="<?= e(route_url('')) ?>">Volver al inicio</a>
        <a class="button button--ghost" href="<?= e(route_url('acceso')) ?>">Ir a acceso</a>
    </div>
</section>
