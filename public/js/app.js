(() => {
    setupAuthTabs();
    setupQuizStepper();
    setupLevelCardReveal();
})();

const LAUNCH_SOUND_STORAGE_KEY = 'inglescentral.launch-sound-enabled';

function setupAuthTabs() {
    const tabContainer = document.querySelector('[data-auth-tabs]');
    if (!(tabContainer instanceof HTMLElement)) {
        return;
    }

    const tabButtons = Array.from(tabContainer.querySelectorAll('[data-auth-target]'));
    const panes = Array.from(tabContainer.querySelectorAll('[data-auth-pane]'));

    if (tabButtons.length === 0 || panes.length === 0) {
        return;
    }

    tabButtons.forEach((button) => {
        button.addEventListener('click', () => {
            const target = button.getAttribute('data-auth-target');
            if (!target) {
                return;
            }

            tabButtons.forEach((tabButton) => {
                tabButton.classList.toggle('access-card__tab--active', tabButton === button);
                tabButton.setAttribute('aria-selected', String(tabButton === button));
            });

            panes.forEach((pane) => {
                const isActivePane = pane.getAttribute('data-auth-pane') === target;
                pane.classList.toggle('access-pane--active', isActivePane);
                pane.hidden = !isActivePane;
            });
        });
    });
}

function setupQuizStepper() {
    const quizContainer = document.querySelector('[data-quiz]');
    if (!(quizContainer instanceof HTMLElement)) {
        return;
    }

    const elements = collectQuizElements(quizContainer);
    if (elements.cards.length === 0) {
        return;
    }

    const quizState = createQuizSessionState(elements.cards.length);
    const launchState = {
        isAnimating: false,
        skipInterception: false,
    };
    const launchPreferences = {
        soundEnabled: getSavedLaunchSoundPreference(),
    };

    setupLaunchSoundToggle(elements.soundToggleButton, launchPreferences);

    refreshQuizUI(elements, quizState);

    elements.nextButton?.addEventListener('click', () => {
        const currentCard = getCurrentCard(elements.cards, quizState);
        if (!(currentCard instanceof HTMLElement)) {
            return;
        }

        if (quizState.awaitingAdvance) {
            if (isReadyToSubmit(quizState, elements.cards.length)) {
                return;
            }

            if (moveToNextQueueItem(quizState)) {
                refreshQuizUI(elements, quizState);
            }

            return;
        }

        if (!hasSelection(currentCard)) {
            setNotice(elements.noticeElement, 'Selecciona una opcion para continuar.');
            return;
        }

        evaluateCurrentAnswer(currentCard, quizState, elements.cards);
        quizState.awaitingAdvance = true;
        refreshQuizUI(elements, quizState, true);
        clearNotice(elements.noticeElement);
    });

    elements.prevButton?.addEventListener('click', () => {
        if (quizState.awaitingAdvance || quizState.queuePosition === 0) {
            return;
        }

        quizState.queuePosition -= 1;
        refreshQuizUI(elements, quizState);
    });

    elements.radioInputs.forEach((input) => {
        input.addEventListener('change', () => {
            clearNotice(elements.noticeElement);

            if (quizState.awaitingAdvance) {
                return;
            }

            const card = input.closest('[data-question-card]');
            if (!(card instanceof HTMLElement)) {
                return;
            }

            const panel = card.querySelector('[data-question-feedback]');
            if (panel instanceof HTMLElement) {
                setQuestionFeedbackNeutral(panel, quizState);
            }
        });
    });

    elements.form?.addEventListener('submit', (event) => {
        if (launchState.skipInterception) {
            return;
        }

        if (!isReadyToSubmit(quizState, elements.cards.length)) {
            event.preventDefault();
            setNotice(elements.noticeElement, 'Primero confirma todas las preguntas correctamente.');
            return;
        }

        if (!canLaunchToNext(elements)) {
            setAutoNextFlag(elements.autoNextInput, false);
            return;
        }

        event.preventDefault();
        if (launchState.isAnimating) {
            return;
        }

        launchState.isAnimating = true;
        setAutoNextFlag(elements.autoNextInput, true);
        setQuizControlsDisabled(elements, true);
        clearNotice(elements.noticeElement);

        startRocketLaunchSequence(elements, launchPreferences).then(() => {
            launchState.skipInterception = true;

            if (!(elements.form instanceof HTMLFormElement)) {
                return;
            }

            if (typeof elements.form.requestSubmit === 'function') {
                elements.form.requestSubmit();
                return;
            }

            elements.form.submit();
        });
    });
}

function createQuizSessionState(totalQuestions) {
    const questionQueue = Array.from({ length: totalQuestions }, (_, index) => index);

    return {
        questionQueue,
        queuePosition: 0,
        awaitingAdvance: false,
        currentStreak: 0,
        bestStreak: 0,
        solvedQuestions: new Set(),
        failedAttempts: new Map(),
    };
}

function collectQuizElements(quizContainer) {
    return {
        quizContainer,
        cards: Array.from(quizContainer.querySelectorAll('[data-question-card]')),
        form: quizContainer.querySelector('[data-quiz-form]'),
        nextButton: quizContainer.querySelector('[data-next-question]'),
        prevButton: quizContainer.querySelector('[data-prev-question]'),
        submitButton: quizContainer.querySelector('[data-submit-quiz]'),
        progressFill: quizContainer.querySelector('[data-progress-fill]'),
        progressCurrent: quizContainer.querySelector('[data-progress-current]'),
        noticeElement: quizContainer.querySelector('[data-quiz-notice]'),
        radioInputs: Array.from(quizContainer.querySelectorAll('input[type="radio"]')),
        nextLevelRoute: (quizContainer.dataset.nextLevelRoute ?? '').trim(),
        autoNextInput: quizContainer.querySelector('[data-auto-next-input]'),
        launchOverlay: quizContainer.querySelector('[data-launch-overlay]'),
        soundToggleButton: quizContainer.querySelector('[data-launch-sound-toggle]'),
    };
}

function setupLaunchSoundToggle(soundToggleButton, launchPreferences) {
    if (!(soundToggleButton instanceof HTMLButtonElement)) {
        return;
    }

    updateLaunchSoundToggleButton(soundToggleButton, launchPreferences.soundEnabled);

    soundToggleButton.addEventListener('click', () => {
        launchPreferences.soundEnabled = !launchPreferences.soundEnabled;
        updateLaunchSoundToggleButton(soundToggleButton, launchPreferences.soundEnabled);
        saveLaunchSoundPreference(launchPreferences.soundEnabled);
    });
}

function getSavedLaunchSoundPreference() {
    try {
        const savedValue = window.localStorage.getItem(LAUNCH_SOUND_STORAGE_KEY);
        return savedValue !== 'off';
    } catch (error) {
        return true;
    }
}

function saveLaunchSoundPreference(enabled) {
    try {
        window.localStorage.setItem(LAUNCH_SOUND_STORAGE_KEY, enabled ? 'on' : 'off');
    } catch (error) {
        // Sin persistencia disponible, se conserva solo en memoria durante la sesion.
    }
}

function updateLaunchSoundToggleButton(soundToggleButton, enabled) {
    if (!(soundToggleButton instanceof HTMLButtonElement)) {
        return;
    }

    soundToggleButton.setAttribute('aria-pressed', enabled ? 'true' : 'false');
    soundToggleButton.classList.toggle('launch-sound-toggle--off', !enabled);
    soundToggleButton.textContent = enabled
        ? 'Sonido de despegue: activo'
        : 'Sonido de despegue: silencio';
}

function refreshQuizUI(elements, quizState, preserveFeedback = false) {
    const total = elements.cards.length;
    const currentCardIndex = getCurrentCardIndex(quizState);
    const currentCard = elements.cards[currentCardIndex] ?? null;

    updateVisibleCard(elements.cards, currentCardIndex);
    updateProgressBar(elements.progressFill, elements.progressCurrent, quizState.solvedQuestions.size, total);
    updateActionButtons(elements.prevButton, elements.nextButton, elements.submitButton, quizState, total);

    if (currentCard instanceof HTMLElement) {
        disableCardInputs(currentCard, quizState.awaitingAdvance);

        if (!preserveFeedback) {
            const panel = currentCard.querySelector('[data-question-feedback]');
            if (panel instanceof HTMLElement) {
                setQuestionFeedbackNeutral(panel, quizState);
            }
        }
    }

    clearNotice(elements.noticeElement);
}

function getCurrentCard(cards, quizState) {
    const currentCardIndex = getCurrentCardIndex(quizState);
    return cards[currentCardIndex] ?? null;
}

function getCurrentCardIndex(quizState) {
    return quizState.questionQueue[quizState.queuePosition] ?? 0;
}

function updateVisibleCard(cards, currentIndex) {
    cards.forEach((card, index) => {
        card.classList.toggle('question-card--active', index === currentIndex);

        if (index !== currentIndex) {
            disableCardInputs(card, false);
        }
    });
}

function updateProgressBar(progressFill, progressCurrent, solvedCount, total) {
    const safeSolvedCount = Math.min(solvedCount, total);
    const percent = total > 0 ? Math.round((safeSolvedCount / total) * 100) : 0;
    const currentStep = total > 0 ? Math.min(safeSolvedCount + 1, total) : 0;

    if (progressFill instanceof HTMLElement) {
        progressFill.style.width = `${percent}%`;
    }

    if (progressCurrent instanceof HTMLElement) {
        progressCurrent.textContent = String(currentStep);
    }
}

function updateActionButtons(prevButton, nextButton, submitButton, quizState, total) {
    const readyToSubmit = isReadyToSubmit(quizState, total);

    if (prevButton instanceof HTMLButtonElement) {
        prevButton.disabled = quizState.awaitingAdvance || quizState.queuePosition === 0;
    }

    if (nextButton instanceof HTMLButtonElement) {
        nextButton.hidden = readyToSubmit;
        nextButton.textContent = quizState.awaitingAdvance ? 'Continuar' : 'Comprobar';
    }

    if (submitButton instanceof HTMLButtonElement) {
        submitButton.hidden = !readyToSubmit;
    }
}

function isReadyToSubmit(quizState, total) {
    const hasMasteredEverything = quizState.solvedQuestions.size === total;
    const isLastQueueItem = quizState.queuePosition >= quizState.questionQueue.length - 1;
    return hasMasteredEverything && isLastQueueItem && quizState.awaitingAdvance;
}

function canLaunchToNext(elements) {
    return elements.nextLevelRoute !== '' && elements.launchOverlay instanceof HTMLElement;
}

function setAutoNextFlag(autoNextInput, shouldTravelToNext) {
    if (!(autoNextInput instanceof HTMLInputElement)) {
        return;
    }

    autoNextInput.value = shouldTravelToNext ? '1' : '0';
}

function setQuizControlsDisabled(elements, shouldDisable) {
    const controls = [elements.prevButton, elements.nextButton, elements.submitButton];
    controls.forEach((control) => {
        if (control instanceof HTMLButtonElement) {
            control.disabled = shouldDisable;
        }
    });

    if (elements.quizContainer instanceof HTMLElement) {
        elements.quizContainer.classList.toggle('quiz--launching', shouldDisable);
    }
}

function startRocketLaunchSequence(elements, launchPreferences) {
    if (!(elements.launchOverlay instanceof HTMLElement)) {
        return Promise.resolve();
    }

    const overlay = elements.launchOverlay;
    const rocketShip = overlay.querySelector('.launch-overlay__ship');
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const fallbackDuration = prefersReducedMotion ? 240 : 2900;

    overlay.hidden = false;
    overlay.classList.add('launch-overlay--active');
    document.body.classList.add('app-shell--launching');

    if (launchPreferences.soundEnabled) {
        playLaunchSound(prefersReducedMotion);
    }

    if (!(rocketShip instanceof HTMLElement) || prefersReducedMotion) {
        return new Promise((resolve) => {
            window.setTimeout(() => {
                resolve();
            }, fallbackDuration);
        });
    }

    return new Promise((resolve) => {
        let isResolved = false;
        const finish = () => {
            if (isResolved) {
                return;
            }

            isResolved = true;
            rocketShip.removeEventListener('animationend', handleAnimationEnd);
            resolve();
        };

        const handleAnimationEnd = (event) => {
            if (!(event instanceof AnimationEvent)) {
                return;
            }

            if (event.animationName !== 'launch-ship-liftoff') {
                return;
            }

            // Da un micro-margen para asegurar que el cohete ya salio de escena.
            window.setTimeout(() => {
                finish();
            }, 90);
        };

        rocketShip.addEventListener('animationend', handleAnimationEnd);

        window.setTimeout(() => {
            finish();
        }, fallbackDuration);
    });
}

function playLaunchSound(prefersReducedMotion) {
    if (prefersReducedMotion) {
        return;
    }

    const AudioContextClass = window.AudioContext || window.webkitAudioContext;
    if (typeof AudioContextClass !== 'function') {
        return;
    }

    try {
        const audioContext = new AudioContextClass();
        const now = audioContext.currentTime;
        const soundDuration = 1.28;

        const masterGain = audioContext.createGain();
        masterGain.gain.setValueAtTime(0.0001, now);
        masterGain.gain.exponentialRampToValueAtTime(0.16, now + 0.08);
        masterGain.gain.exponentialRampToValueAtTime(0.0001, now + soundDuration);
        masterGain.connect(audioContext.destination);

        const oscillator = audioContext.createOscillator();
        oscillator.type = 'sawtooth';
        oscillator.frequency.setValueAtTime(118, now);
        oscillator.frequency.exponentialRampToValueAtTime(362, now + soundDuration);

        const oscillatorGain = audioContext.createGain();
        oscillatorGain.gain.setValueAtTime(0.85, now);
        oscillator.connect(oscillatorGain);
        oscillatorGain.connect(masterGain);

        const noiseBuffer = audioContext.createBuffer(1, Math.floor(audioContext.sampleRate * soundDuration), audioContext.sampleRate);
        const noiseChannel = noiseBuffer.getChannelData(0);
        for (let index = 0; index < noiseChannel.length; index += 1) {
            noiseChannel[index] = (Math.random() * 2 - 1) * 0.26;
        }

        const noiseSource = audioContext.createBufferSource();
        noiseSource.buffer = noiseBuffer;

        const noiseFilter = audioContext.createBiquadFilter();
        noiseFilter.type = 'bandpass';
        noiseFilter.frequency.setValueAtTime(660, now);
        noiseFilter.frequency.exponentialRampToValueAtTime(940, now + soundDuration);
        noiseFilter.Q.setValueAtTime(0.7, now);

        const noiseGain = audioContext.createGain();
        noiseGain.gain.setValueAtTime(0.0001, now);
        noiseGain.gain.exponentialRampToValueAtTime(0.085, now + 0.1);
        noiseGain.gain.exponentialRampToValueAtTime(0.0001, now + soundDuration);

        noiseSource.connect(noiseFilter);
        noiseFilter.connect(noiseGain);
        noiseGain.connect(audioContext.destination);

        oscillator.start(now);
        noiseSource.start(now);
        oscillator.stop(now + soundDuration);
        noiseSource.stop(now + soundDuration);

        window.setTimeout(() => {
            audioContext.close().catch(() => {});
        }, 1800);
    } catch (error) {
        // Si el navegador bloquea audio, la animacion continua sin sonido.
    }
}

function moveToNextQueueItem(quizState) {
    if (quizState.queuePosition >= quizState.questionQueue.length - 1) {
        return false;
    }

    quizState.queuePosition += 1;
    quizState.awaitingAdvance = false;
    return true;
}

function hasSelection(card) {
    if (!(card instanceof HTMLElement)) {
        return false;
    }

    return card.querySelector('input[type="radio"]:checked') instanceof HTMLInputElement;
}

function disableCardInputs(card, shouldDisable) {
    if (!(card instanceof HTMLElement)) {
        return;
    }

    const radioInputs = Array.from(card.querySelectorAll('input[type="radio"]'));
    radioInputs.forEach((input) => {
        if (input instanceof HTMLInputElement) {
            input.disabled = shouldDisable;
        }
    });
}

function setNotice(noticeElement, message) {
    if (noticeElement instanceof HTMLElement) {
        noticeElement.textContent = message;
    }
}

function clearNotice(noticeElement) {
    if (noticeElement instanceof HTMLElement) {
        noticeElement.textContent = '';
    }
}

function evaluateCurrentAnswer(card, quizState, cards) {
    if (!(card instanceof HTMLElement)) {
        return false;
    }

    const panel = card.querySelector('[data-question-feedback]');
    const selectedInput = card.querySelector('input[type="radio"]:checked');
    if (!(selectedInput instanceof HTMLInputElement)) {
        if (panel instanceof HTMLElement) {
            setQuestionFeedbackNeutral(panel, quizState);
        }

        return false;
    }

    const questionKey = getQuestionKey(card);
    const questionIndex = cards.indexOf(card);
    const selectedText = getSelectedOptionText(selectedInput);
    const isCorrect = selectedInput.dataset.isCorrect === '1';

    if (isCorrect) {
        trackCorrectSelection(quizState, questionKey);
        removeQueuedRetries(quizState, questionIndex);

        if (panel instanceof HTMLElement) {
            setQuestionFeedback(
                panel,
                'success',
                buildSuccessFeedbackTitle(quizState),
                buildSuccessFeedbackMessage(selectedText, quizState)
            );
        }

        return true;
    }

    trackWrongSelection(quizState, questionKey);
    enqueueQuestionRetry(quizState, questionIndex);
    const failedAttempts = getFailedAttempts(quizState, questionKey);
    const questionPrompt = card.dataset.questionPrompt ?? '';
    const tip = card.dataset.questionTip ?? '';

    if (panel instanceof HTMLElement) {
        setQuestionFeedback(
            panel,
            'error',
            buildErrorFeedbackTitle(failedAttempts),
            buildErrorFeedbackMessage({
                tip,
                failedAttempts,
                selectedText,
                questionPrompt,
            })
        );
    }

    return false;
}

function getQuestionKey(card) {
    if (!(card instanceof HTMLElement)) {
        return '';
    }

    return card.dataset.questionIndex ?? '';
}

function trackCorrectSelection(quizState, questionKey) {
    if (!isValidQuestionKey(questionKey)) {
        return;
    }

    if (quizState.solvedQuestions.has(questionKey)) {
        return;
    }

    quizState.solvedQuestions.add(questionKey);
    quizState.failedAttempts.delete(questionKey);
    quizState.currentStreak += 1;
    quizState.bestStreak = Math.max(quizState.bestStreak, quizState.currentStreak);
}

function trackWrongSelection(quizState, questionKey) {
    if (!isValidQuestionKey(questionKey)) {
        return;
    }

    const currentAttempts = quizState.failedAttempts.get(questionKey) ?? 0;
    quizState.failedAttempts.set(questionKey, currentAttempts + 1);
    quizState.currentStreak = 0;
}

function getFailedAttempts(quizState, questionKey) {
    if (!isValidQuestionKey(questionKey)) {
        return 1;
    }

    return quizState.failedAttempts.get(questionKey) ?? 1;
}

function enqueueQuestionRetry(quizState, questionIndex) {
    if (!Number.isInteger(questionIndex) || questionIndex < 0) {
        return;
    }

    const upcomingQueue = quizState.questionQueue.slice(quizState.queuePosition + 1);
    if (!upcomingQueue.includes(questionIndex)) {
        quizState.questionQueue.push(questionIndex);
    }
}

function removeQueuedRetries(quizState, questionIndex) {
    if (!Number.isInteger(questionIndex) || questionIndex < 0) {
        return;
    }

    quizState.questionQueue = quizState.questionQueue.filter((queuedIndex, queueIndex) => {
        if (queueIndex <= quizState.queuePosition) {
            return true;
        }

        return queuedIndex !== questionIndex;
    });
}

function isValidQuestionKey(questionKey) {
    return typeof questionKey === 'string' && questionKey !== '';
}

function buildSuccessFeedbackTitle(quizState) {
    const titles = [
        'Excelente, sigue asi',
        'Muy bien, lo lograste',
        'Perfecto, vas con ritmo',
    ];

    return titles[(quizState.bestStreak + quizState.currentStreak) % titles.length];
}

function buildSuccessFeedbackMessage(selectedText, quizState) {
    const combo = Math.max(1, quizState.currentStreak);
    const best = Math.max(combo, quizState.bestStreak);
    return `"${selectedText}" encaja con la frase. Racha actual x${combo}. Mejor racha x${best}.`;
}

function getSelectedOptionText(input) {
    const optionLabel = input.nextElementSibling;
    if (!(optionLabel instanceof HTMLElement)) {
        return 'Esa opcion';
    }

    const normalizedText = optionLabel.textContent?.trim() ?? '';
    return normalizedText !== '' ? normalizedText : 'Esa opcion';
}

function buildErrorFeedbackTitle(failedAttempts) {
    if (failedAttempts >= 3) {
        return 'Casi, ultima pista';
    }

    if (failedAttempts === 2) {
        return 'Vas cerca, prueba otra vez';
    }

    return 'Aun no, mira esta pista';
}

function buildErrorFeedbackMessage({ tip, failedAttempts, selectedText, questionPrompt }) {
    const coherentHint = buildCoherentHint(questionPrompt, selectedText, tip);

    if (failedAttempts >= 3) {
        return `${coherentHint} Esta pregunta volvera luego hasta que la contestes bien. Mini reto: descarta dos opciones y compara solo las restantes.`;
    }

    if (failedAttempts === 2) {
        return `${coherentHint} Esta pregunta volvera luego hasta que la contestes bien. Pista extra: valida sujeto, tiempo verbal y significado.`;
    }

    return `${coherentHint} Esta pregunta volvera luego hasta que la contestes bien. Intenta una opcion diferente.`;
}

function buildCoherentHint(questionPrompt, selectedText, fallbackTip) {
    const prompt = normalizeHintText(questionPrompt);
    const selected = normalizeHintText(selectedText);
    const safeFallbackTip = fallbackTip.trim() !== ''
        ? fallbackTip.trim()
        : 'Lee el enunciado completo y descarta opciones que cambian el sentido original.';

    if (prompt.includes('ella estudia ingles') && selected.startsWith('he ')) {
        return 'Revisa el sujeto: la frase base habla de "ella" y tu opcion cambia a masculino.';
    }

    if (prompt.includes('ella estudia ingles') && selected.includes('she study')) {
        return 'Vas cerca: con she/he en presente simple el verbo normalmente termina en -s.';
    }

    if (prompt.includes('ella estudia ingles') && selected.includes('spanish')) {
        return 'La estructura puede sonar bien, pero cambia el idioma del enunciado original.';
    }

    if (prompt.includes('i go to') && prompt.includes('700 am')) {
        return 'Piensa en una rutina escolar a primera hora y en el lugar tipico de estudio.';
    }

    if (prompt.includes('favorite subject') && (selected.includes('run') || selected.includes('door') || selected.includes('happy'))) {
        return 'El espacio se completa con una materia escolar, no con accion, objeto o adjetivo.';
    }

    if (prompt.includes('yesterday i') && prompt.includes('football')) {
        return 'La palabra "yesterday" marca pasado; revisa una forma verbal de pasado simple.';
    }

    if (prompt.includes('finished homework') && prompt.includes('watched a movie')) {
        return 'Necesitas un conector de secuencia temporal, no de causa, condicion o contraste.';
    }

    if (prompt.includes('did') && prompt.includes('not go to class')) {
        return 'En negativo de pasado simple se usa el auxiliar correspondiente antes de "not".';
    }

    if (prompt.includes('social media') && prompt.includes('useful for learning')) {
        return 'Revisa la concordancia: en este contexto el sujeto se trata como singular.';
    }

    if (prompt.includes('if i have enough time')) {
        return 'En primera condicional, tras "if + presente" suele ir estructura de futuro.';
    }

    if (prompt.includes('after graduation')) {
        return 'Para planes futuros, elige una estructura completa y natural para hablar de intenciones.';
    }

    if (prompt.includes('shows contrast')) {
        return 'Busca un conector que exprese oposicion entre dos ideas.';
    }

    return safeFallbackTip;
}

function normalizeHintText(value) {
    if (typeof value !== 'string') {
        return '';
    }

    const withoutAccents = value
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '');

    return withoutAccents
        .toLowerCase()
        .replace(/[^a-z0-9\s]/g, '')
        .replace(/\s+/g, ' ')
        .trim();
}

function setQuestionFeedbackNeutral(panel, quizState) {
    const hasCombo = quizState.currentStreak > 1;
    const neutralText = hasCombo
        ? `Racha activa x${quizState.currentStreak}. Elige y pulsa Comprobar para seguir sumando.`
        : 'Elige una opcion y pulsa Comprobar para recibir retroalimentacion.';

    setQuestionFeedback(
        panel,
        'neutral',
        'Selecciona una opcion',
        neutralText
    );
}

function setQuestionFeedback(panel, state, title, text) {
    panel.classList.remove('question-feedback--neutral', 'question-feedback--success', 'question-feedback--error');
    panel.classList.add(`question-feedback--${state}`);

    const titleElement = panel.querySelector('[data-feedback-title]');
    const textElement = panel.querySelector('[data-feedback-text]');

    if (titleElement instanceof HTMLElement) {
        titleElement.textContent = title;
    }

    if (textElement instanceof HTMLElement) {
        textElement.textContent = text;
    }
}

function setupLevelCardReveal() {
    const cards = Array.from(document.querySelectorAll('.level-card--interactive'));
    if (cards.length === 0) {
        return;
    }

    if (!('IntersectionObserver' in window)) {
        cards.forEach((card) => card.classList.add('level-card--visible'));
        return;
    }

    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach((entry) => {
                if (!entry.isIntersecting) {
                    return;
                }

                entry.target.classList.add('level-card--visible');
                observer.unobserve(entry.target);
            });
        },
        {
            threshold: 0.22,
            rootMargin: '0px 0px -10% 0px',
        }
    );

    cards.forEach((card) => observer.observe(card));
}
