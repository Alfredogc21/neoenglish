<?php
$questions = is_array($level['questions'] ?? null) ? $level['questions'] : [];
$totalQuestions = count($questions);
$nextLevelIdValue = isset($nextLevelId) ? (int) $nextLevelId : 0;
$nextLevelRoute = $nextLevelIdValue > 0 ? route_url('nivel/' . (string) $nextLevelIdValue) : '';
?>

<section class="lesson-hero">
    <div class="lesson-hero__content">
        <p class="lesson-hero__badge">Nivel <?= e((string) ($level['id'] ?? 0)) ?> | <?= e((string) ($level['difficulty'] ?? '')) ?></p>
        <h2 class="lesson-hero__title"><?= e((string) ($level['name'] ?? 'Nivel')) ?></h2>
        <p class="lesson-hero__description"><?= e((string) ($level['description'] ?? '')) ?></p>
    </div>

    <a class="button button--ghost" href="<?= e(route_url('')) ?>">Volver al mapa</a>
</section>

<?php if (is_array($result)): ?>
    <section class="result-card">
        <h3 class="result-card__title">Resultado del nivel</h3>
        <div class="result-card__metrics">
            <p class="result-card__metric"><strong><?= e((string) ($result['score_percent'] ?? 0)) ?>%</strong> de aciertos</p>
            <p class="result-card__metric"><strong><?= e((string) ($result['correct_answers'] ?? 0)) ?>/<?= e((string) ($result['total_questions'] ?? 0)) ?></strong> respuestas correctas</p>
            <p class="result-card__metric"><strong><?= e((string) ($result['earned_xp'] ?? 0)) ?> XP</strong> obtenidos</p>
            <p class="result-card__metric"><strong>+<?= e((string) ($result['bonus_xp'] ?? 0)) ?> XP</strong> bonus por precision</p>
            <?php if (isset($result['attempt_id'])): ?>
                <p class="result-card__metric">Intento #<?= e((string) $result['attempt_id']) ?></p>
            <?php endif; ?>
        </div>
        <p class="result-card__message"><?= e((string) ($result['message'] ?? '')) ?></p>

        <div class="result-card__details">
            <?php foreach (($result['details'] ?? []) as $detail): ?>
                <article class="feedback-item <?= !empty($detail['is_correct']) ? 'feedback-item--success' : 'feedback-item--error' ?>">
                    <h4 class="feedback-item__title"><?= e((string) ($detail['prompt'] ?? 'Pregunta')) ?></h4>
                    <p class="feedback-item__line">Tu respuesta: <?= e((string) (($detail['selected_answer'] ?? '') === '' ? 'Sin responder' : $detail['selected_answer'])) ?></p>
                    <p class="feedback-item__line">Respuesta correcta: <?= e((string) ($detail['expected_answer'] ?? '')) ?></p>
                    <?php if (!empty($detail['selected_feedback'])): ?>
                        <p class="feedback-item__feedback"><?= e((string) ($detail['selected_feedback'])) ?></p>
                    <?php endif; ?>
                    <?php if (empty($detail['is_correct'])): ?>
                        <p class="feedback-item__tip">Tip: <?= e((string) ($detail['tip'] ?? '')) ?></p>
                    <?php endif; ?>
                </article>
            <?php endforeach; ?>
        </div>

        <a class="button button--primary" href="<?= e(route_url('nivel/' . (string) ($level['id'] ?? 0))) ?>">Intentar otra vez</a>
    </section>
<?php endif; ?>

<?php if ($totalQuestions === 0): ?>
    <section class="result-card">
        <h3 class="result-card__title">Nivel sin preguntas cargadas</h3>
        <p class="result-card__message">Este nivel aun no tiene retos disponibles. Carga preguntas en la base de datos para activarlo.</p>
    </section>
<?php else: ?>
    <section
        class="quiz"
        data-quiz
        data-total-questions="<?= e((string) $totalQuestions) ?>"
        data-next-level-route="<?= e($nextLevelRoute) ?>"
    >
        <div class="quiz__progress">
            <div class="quiz__progress-track" aria-hidden="true">
                <span class="quiz__progress-fill" data-progress-fill></span>
            </div>
            <p class="quiz__progress-label">Pregunta <span data-progress-current>1</span> de <?= e((string) $totalQuestions) ?></p>
            <p class="quiz__notice" data-quiz-notice aria-live="polite"></p>
        </div>

        <form method="post" class="quiz__form" data-quiz-form>
            <input type="hidden" name="auto_next" value="0" data-auto-next-input>

            <?php foreach ($questions as $index => $question): ?>
                <?php
                $questionNumber = $index + 1;
                $isActive = $index === 0;
                $questionTip = (string) ($question['tip'] ?? '');
                $questionOptions = is_array($question['options'] ?? null) ? $question['options'] : [];
                $questionType = (int) ($question['tipo_pregunta_id'] ?? 1);
                $isTextQuestion = $questionType === 3;
                $isBuildQuestion = $questionType === 4;
                $questionWordbank = is_array($question['wordbank'] ?? null) ? $question['wordbank'] : [];
                $correctOptionUi = null;
                foreach ($questionOptions as $optRow) {
                    if (!empty($optRow['is_correct'])) {
                        $correctOptionUi = $optRow;
                        break;
                    }
                }
                ?>
                <article
                    class="question-card <?= $isActive ? 'question-card--active' : '' ?>"
                    data-question-card
                    data-question-index="<?= e((string) $questionNumber) ?>"
                    data-question-prompt="<?= e((string) ($question['prompt'] ?? '')) ?>"
                    data-question-tip="<?= e($questionTip) ?>"
                    data-question-type="<?= e((string) $questionType) ?>"
                >
                    <p class="question-card__counter">Reto <?= e((string) $questionNumber) ?></p>
                    <h3 class="question-card__prompt"><?= e((string) ($question['prompt'] ?? '')) ?></h3>
                    <?php if ($isTextQuestion): ?>
                        <p class="question-card__subtitle">Escribe la palabra faltante para completar la oracion.</p>
                    <?php elseif ($isBuildQuestion): ?>
                        <p class="question-card__subtitle">Haz clic en las palabras para construir la oracion correcta.</p>
                    <?php else: ?>
                        <p class="question-card__subtitle">Selecciona una opcion para continuar.</p>
                    <?php endif; ?>

                    <div class="question-card__body">
                        <?php if ($isTextQuestion): ?>
                            <div class="question-card__text-input">
                                <input
                                    type="text"
                                    name="answers[<?= e((string) ($question['id'] ?? 0)) ?>]"
                                    class="question-text-input"
                                    autocomplete="off"
                                    placeholder="Escribe tu respuesta aqui..."
                                    data-correct-text="<?= e((string) ($correctOptionUi['text'] ?? '')) ?>"
                                    data-option-feedback="<?= e((string) ($correctOptionUi['retroalimentacion'] ?? '')) ?>"
                                >
                                <p class="question-text-input__hint">Presiona Enter o haz clic en Siguiente para continuar</p>
                            </div>
                        <?php elseif ($isBuildQuestion): ?>
                            <input
                                type="hidden"
                                name="answers[<?= e((string) ($question['id'] ?? 0)) ?>]"
                                value=""
                                data-build-answer
                                data-correct-sentence="<?= e((string) ($question['correct_sentence'] ?? '')) ?>"
                                data-option-feedback="<?= e((string) ($correctOptionUi['retroalimentacion'] ?? '')) ?>"
                            >
                            <div class="question-card__build">
                                <div class="dropzone-container" data-dropzone>
                                    <span class="dropzone-placeholder" data-dropzone-placeholder>Aqui aparecera tu oracion...</span>
                                </div>
                                <div class="wordbank-container" data-wordbank>
                                    <?php foreach ($questionWordbank as $word): ?>
                                        <button type="button" class="word-btn" data-word="<?= e($word) ?>"><?= e($word) ?></button>
                                    <?php endforeach; ?>
                                </div>
                            </div>
                        <?php else: ?>
                            <div class="question-card__options">
                                <?php foreach ($questionOptions as $optionIndex => $option): ?>
                                    <?php $optionInputId = 'q' . (string) ($question['id'] ?? 0) . '_option_' . ($optionIndex + 1); ?>
                                    <label class="question-option" for="<?= e($optionInputId) ?>">
                                        <input
                                            class="question-option__input"
                                            type="radio"
                                            id="<?= e($optionInputId) ?>"
                                            name="answers[<?= e((string) ($question['id'] ?? 0)) ?>]"
                                            value="<?= e((string) ($option['id'] ?? 0)) ?>"
                                            data-is-correct="<?= !empty($option['is_correct']) ? '1' : '0' ?>"
                                            data-option-feedback="<?= e((string) ($option['retroalimentacion'] ?? '')) ?>"
                                        >
                                        <span class="question-option__label"><?= e((string) ($option['text'] ?? '')) ?></span>
                                    </label>
                                <?php endforeach; ?>
                            </div>
                        <?php endif; ?>

                        <aside class="question-feedback question-feedback--neutral" data-question-feedback aria-live="polite">
                            <div class="question-feedback__avatar" aria-hidden="true">
                                <span class="question-feedback__eye question-feedback__eye--left"></span>
                                <span class="question-feedback__eye question-feedback__eye--right"></span>
                                <span class="question-feedback__mouth"></span>
                            </div>
                            <?php if ($isTextQuestion): ?>
                                <h4 class="question-feedback__title" data-feedback-title>Escribe tu respuesta</h4>
                                <p class="question-feedback__text" data-feedback-text>Escribe la palabra y presiona Enter o clic en Siguiente.</p>
                            <?php elseif ($isBuildQuestion): ?>
                                <h4 class="question-feedback__title" data-feedback-title>Construye la oracion</h4>
                                <p class="question-feedback__text" data-feedback-text>Haz clic en las palabras para colocarlas en orden.</p>
                            <?php else: ?>
                                <h4 class="question-feedback__title" data-feedback-title>Selecciona una opcion</h4>
                                <p class="question-feedback__text" data-feedback-text>Te dare pistas utiles sin revelar la respuesta.</p>
                            <?php endif; ?>
                        </aside>
                    </div>
                </article>
            <?php endforeach; ?>

            <div class="quiz__actions">
                <button type="button" class="button button--ghost" data-prev-question disabled>Anterior</button>
                <button type="button" class="button button--secondary" data-next-question>Siguiente</button>
                <button type="submit" class="button button--primary" data-submit-quiz hidden>Finalizar nivel</button>

                <?php if ($nextLevelRoute !== ''): ?>
                    <button
                        type="button"
                        class="launch-sound-toggle"
                        data-launch-sound-toggle
                        aria-pressed="true"
                    >
                        Sonido de despegue: activo
                    </button>
                <?php endif; ?>
            </div>
        </form>

        <div class="launch-overlay" data-launch-overlay hidden aria-live="assertive">
            <div class="launch-overlay__space" aria-hidden="true">
                <span class="launch-overlay__star launch-overlay__star--a"></span>
                <span class="launch-overlay__star launch-overlay__star--b"></span>
                <span class="launch-overlay__star launch-overlay__star--c"></span>
                <span class="launch-overlay__star launch-overlay__star--d"></span>
                <span class="launch-overlay__star launch-overlay__star--e"></span>
            </div>
            <div class="launch-overlay__ship" aria-hidden="true">
                <span class="launch-overlay__window"></span>
                <span class="launch-overlay__fin launch-overlay__fin--left"></span>
                <span class="launch-overlay__fin launch-overlay__fin--right"></span>
                <span class="launch-overlay__flame"></span>
                <span class="launch-overlay__trail"></span>
            </div>
            <p class="launch-overlay__caption">Excelente trabajo. Preparando salto al siguiente reto...</p>
        </div>
    </section>
<?php endif; ?>
