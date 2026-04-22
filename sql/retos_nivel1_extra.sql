-- InglesCentral: retos adicionales Nivel 1 / Leccion 1 (orden 11-25)
-- Usar SOLO si la base ya tiene los retos 1-10 y no quieres reimportar inglescentral.sql completo.
--
-- Ejecutar en phpMyAdmin o: mysql -u root -p inglescentral < retos_nivel1_extra.sql

USE `inglescentral`;

SET FOREIGN_KEY_CHECKS = 0;

-- Nivel 1 / Leccion 1: retos 11-25 (School Life: lecturas mas largas, vocabulario y rutinas)

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 1, 'Lee el texto y elige la respuesta correcta (opciones en ingles). Texto: Every morning, my classmates and I meet at the school gate. We check the timetable on the board and then we walk to our classroom. Our teacher reminds us to turn in projects on Monday. Pregunta: According to the text, what do students check before going to the classroom?', 'Busca una idea explicita en la lectura.', 1.10, 11);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'the timetable', 1, 'Correcto: el texto dice check the timetable on the board.'),
(@pregunta_id, 'the projects', 0, 'Los proyectos se mencionan para entregar el lunes, no para revisar antes de entrar.'),
(@pregunta_id, 'the teacher', 0, 'El texto no dice que revisen al profesor en ese momento.'),
(@pregunta_id, 'the school gate', 0, 'El porton es el punto de encuentro, no lo que revisan en el tablero.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 1, 'Comprension lectora: Texto: During recess, students can eat a snack, play sports, or talk quietly in the courtyard. The bell rings after twenty minutes and everyone must line up before entering the building. Pregunta: How long does recess last according to the text?', 'Lee los datos numericos con cuidado.', 1.12, 12);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'twenty minutes', 1, 'Correcto: after twenty minutes aparece en el texto.'),
(@pregunta_id, 'one hour', 0, 'No coincide con twenty minutes.'),
(@pregunta_id, 'ten minutes', 0, 'Es un distractor numerico.'),
(@pregunta_id, 'until lunch', 0, 'El texto no dice que el recreo dure hasta el almuerzo.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 2, 'Completa con la mejor opcion: Our teacher always ____ us clear instructions before a test.', 'Presente simple con she/he/it: verbo con -s.', 1.05, 13);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'gives', 1, 'Correcto: teacher + gives + us + instructions.'),
(@pregunta_id, 'give', 0, 'Give no lleva -s con sujeto en tercera persona.'),
(@pregunta_id, 'giving', 0, 'Aquí necesitas presente simple, no forma continua sola.'),
(@pregunta_id, 'is give', 0, 'Estructura incorrecta en ingles estandar.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 2, 'Completa: If you forget your homework, you should ____ to the teacher after class.', 'Despues de should usa la base del verbo (sin to).', 1.05, 14);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'apologize', 1, 'Correcto: should + apologize (verbo base).'),
(@pregunta_id, 'apologizes', 0, 'No uses -s despues de should con you.'),
(@pregunta_id, 'apology', 0, 'Necesitas un verbo, no solo el sustantivo aqui.'),
(@pregunta_id, 'to apologize', 0, 'Should no va seguido de to + verbo en este patron basico.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 3, 'Escribe en ingles la palabra que falta: I usually ____ my locker before the first bell rings.', 'Verbo corto en presente con I: sin -s.', 1.05, 15);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'open', 1, 'Correcto: open my locker es natural en rutina escolar.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 3, 'Escribe en ingles: Please ____ your phone on silent mode during the lesson.', 'Verbo frecuente para mantener un estado: keep + objeto + on + modo.', 1.08, 16);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'keep', 1, 'Correcto: keep your phone on silent mode.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 4, 'Construye la traduccion: El director da un discurso en el gimnasio.', 'Orden SVO; principal = director en este contexto.', 1.12, 17);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'The principal gives a speech in the gym', 1, 'Correcto: principal + gives + a speech + in the gym.'),
(@pregunta_id, 'teacher', 0, 'Distractor: rol distinto.'),
(@pregunta_id, 'runs', 0, 'Distractor: verbo que no construye la traduccion.'),
(@pregunta_id, 'student', 0, 'Distractor: persona incorrecta.'),
(@pregunta_id, 'at', 0, 'Distractor: preposicion suelta.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 4, 'Construye: No tenemos clase de arte en la primera hora.', 'Negacion con do not + have + nombre de clase + in the first period.', 1.15, 18);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'We do not have art class in the first period', 1, 'Correcto: we do not have + art class + in the first period.'),
(@pregunta_id, 'science', 0, 'Distractor: otra materia.'),
(@pregunta_id, 'Monday', 0, 'Distractor: dia suelto.'),
(@pregunta_id, 'they', 0, 'Distractor: pronombre incorrecto.'),
(@pregunta_id, 'music', 0, 'Distractor: otra materia.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 1, 'Lee el texto. Texto: In PE class, we warm up, practice drills, and then play a short match. If you feel dizzy, you must tell the coach immediately. Pregunta: Who should you tell if you feel dizzy?', 'Identifica el rol mencionado para reportar malestar.', 1.08, 19);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'the coach', 1, 'Correcto: tell the coach aparece en el texto.'),
(@pregunta_id, 'the principal', 0, 'No aparece como destino inmediato en el fragmento.'),
(@pregunta_id, 'the librarian', 0, 'No encaja con educacion fisica.'),
(@pregunta_id, 'the referee', 0, 'Referee no se usa en el texto; coach si.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 2, 'Completa: My group needs to ____ a poster about healthy habits for the science fair.', 'Need to + verbo base.', 1.05, 20);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'make', 1, 'Correcto: make a poster es colocacion natural.'),
(@pregunta_id, 'makes', 0, 'No uses -s despues de to.'),
(@pregunta_id, 'making', 0, 'Despues de to va la base del verbo.'),
(@pregunta_id, 'made', 0, 'Made es pasado; aqui se pide infinitivo con to.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 3, 'Escribe la palabra en ingles: She ____ her notebook on the desk when the teacher starts the lesson.', 'Presente simple con she: verbo con -s.', 1.05, 21);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'puts', 1, 'Correcto: she puts her notebook on the desk.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 4, 'Construye la traduccion: Los examenes empiezan la proxima semana.', 'Plural Exams + presente simple + next week.', 1.10, 22);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'Exams start next week', 1, 'Correcto: exams start next week.'),
(@pregunta_id, 'test', 0, 'Distractor: singular parcial.'),
(@pregunta_id, 'Monday', 0, 'Distractor: dia concreto no pedido.'),
(@pregunta_id, 'they', 0, 'Distractor: pronombre.'),
(@pregunta_id, 'at', 0, 'Distractor: preposicion suelta.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 1, 'Lectura: The school library opens at 7:30 a.m. You can borrow two books for two weeks. If you return them late, you pay a small fine. Pregunta: How many books can you borrow at the same time?', 'Lee el numero permitido en la segunda oracion.', 1.10, 23);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'two books', 1, 'Correcto: two books aparece en el texto.'),
(@pregunta_id, 'one book', 0, 'No coincide con two books.'),
(@pregunta_id, 'three books', 0, 'No esta soportado por el texto.'),
(@pregunta_id, 'four books', 0, 'No esta soportado por el texto.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 2, 'Completa: After the lesson, we have to ____ our chairs before leaving the classroom.', 'Have to + verbo base; verbo para apilar sillas.', 1.05, 24);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'stack', 1, 'Correcto: stack our chairs es rutina comun al salir.'),
(@pregunta_id, 'stacks', 0, 'Sin -s despues de to.'),
(@pregunta_id, 'stacking', 0, 'Forma -ing no sigue a have to aqui.'),
(@pregunta_id, 'stacked', 0, 'Pasado no encaja con rutina general.');

INSERT INTO `preguntas` (`leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
(1, 4, 'Construye: No debemos correr en los pasillos.', 'Modal must + not + verbo base; hallways = pasillos.', 1.12, 25);
SET @pregunta_id = LAST_INSERT_ID();
INSERT INTO `opciones_pregunta` (`pregunta_id`, `texto_opcion`, `es_correcta`, `retroalimentacion`) VALUES
(@pregunta_id, 'We must not run in the hallways', 1, 'Correcto: must not run + in the hallways.'),
(@pregunta_id, 'walk', 0, 'Distractor: verbo distinto.'),
(@pregunta_id, 'classroom', 0, 'Distractor: lugar incorrecto para la regla.'),
(@pregunta_id, 'they', 0, 'Distractor: pronombre.'),
(@pregunta_id, 'quickly', 0, 'Distractor: adverbio suelto.');

SET FOREIGN_KEY_CHECKS = 1;
