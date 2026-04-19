<section class="access-hero">
    <div class="access-hero__copy">
        <p class="access-hero__kicker">Bienvenido a la arena del ingles</p>
        <h2 class="access-hero__title">Activa tu perfil y comienza la ruta gamificada</h2>
        <p class="access-hero__text">
            Inicia sesion como estudiante para jugar niveles y guardar progreso real.
            Si eres docente, entra al panel para monitorear resultados por estudiante, nivel y habilidad.
        </p>
    </div>
</section>

<section class="access-card" data-auth-tabs>
    <div class="access-card__tabs" role="tablist" aria-label="Tipos de acceso">
        <button class="access-card__tab access-card__tab--active" type="button" data-auth-target="student" role="tab" aria-selected="true">Estudiante</button>
        <button class="access-card__tab" type="button" data-auth-target="teacher" role="tab" aria-selected="false">Docente</button>
    </div>

    <div class="access-card__panes">
        <div class="access-pane access-pane--active" data-auth-pane="student">
            <div class="access-pane__grid">
                <article class="auth-block">
                    <h3 class="auth-block__title">Iniciar sesion</h3>
                    <p class="auth-block__text">Ingresa para continuar tus niveles y tu progreso guardado.</p>
                    <form class="auth-form" method="post" action="<?= e(route_url('login/estudiante')) ?>">
                        <label class="auth-form__label" for="student_email">Correo institucional o personal</label>
                        <input class="auth-form__input" id="student_email" type="email" name="student_email" required>

                        <label class="auth-form__label" for="student_password">Contrasena</label>
                        <input class="auth-form__input" id="student_password" type="password" name="student_password" required>

                        <button class="button button--primary auth-form__submit" type="submit">Entrar como estudiante</button>
                    </form>
                </article>

                <article class="auth-block">
                    <h3 class="auth-block__title">Crear cuenta nueva</h3>
                    <p class="auth-block__text">Registra un estudiante para iniciar la experiencia desde cero.</p>
                    <form class="auth-form" method="post" action="<?= e(route_url('registro/estudiante')) ?>">
                        <label class="auth-form__label" for="first_name">Nombre</label>
                        <input class="auth-form__input" id="first_name" type="text" name="first_name" required>

                        <label class="auth-form__label" for="last_name">Apellido</label>
                        <input class="auth-form__input" id="last_name" type="text" name="last_name" required>

                        <label class="auth-form__label" for="grade_group">Grupo</label>
                        <input class="auth-form__input" id="grade_group" type="text" name="grade_group" placeholder="11-01" required>

                        <label class="auth-form__label" for="register_email">Correo</label>
                        <input class="auth-form__input" id="register_email" type="email" name="email" required>

                        <label class="auth-form__label" for="register_password">Contrasena (minimo 8 caracteres)</label>
                        <input class="auth-form__input" id="register_password" type="password" name="password" minlength="8" required>

                        <button class="button button--secondary auth-form__submit" type="submit">Crear y entrar</button>
                    </form>
                </article>
            </div>
        </div>

        <div class="access-pane" data-auth-pane="teacher" hidden>
            <article class="auth-block auth-block--teacher">
                <h3 class="auth-block__title">Ingreso de docente</h3>
                <p class="auth-block__text">Accede al panel pedagogico con estadisticas y seguimiento integral.</p>
                <form class="auth-form" method="post" action="<?= e(route_url('login/docente')) ?>">
                    <label class="auth-form__label" for="teacher_email">Correo docente</label>
                    <input class="auth-form__input" id="teacher_email" type="email" name="teacher_email" required>

                    <label class="auth-form__label" for="teacher_password">Contrasena</label>
                    <input class="auth-form__input" id="teacher_password" type="password" name="teacher_password" required>

                    <button class="button button--primary auth-form__submit" type="submit">Entrar al panel docente</button>
                </form>
            </article>
        </div>
    </div>
</section>
