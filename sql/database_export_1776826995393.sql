-- ==========================================================
-- Basify Export
-- Base de datos : inglescentral
-- Motor         : MariaDB
-- Generado      : 21/4/2026, 10:03:15 p. m.
-- ==========================================================

-- CREATE DATABASE IF NOT EXISTS `inglescentral`;
-- USE `inglescentral`;

-- ==========================================================
-- Estructura de tablas
-- ==========================================================

-- Tabla: docentes
CREATE TABLE IF NOT EXISTS `docentes` (
  `docente_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `nombre_completo` varchar(120) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `hash_contrasena` varchar(255) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`docente_id`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: estudiantes
CREATE TABLE IF NOT EXISTS `estudiantes` (
  `estudiante_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `nombres` varchar(80) NOT NULL,
  `apellidos` varchar(80) NOT NULL,
  `grupo_grado` varchar(20) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `hash_contrasena` varchar(255) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`estudiante_id`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: habilidades
CREATE TABLE IF NOT EXISTS `habilidades` (
  `habilidad_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `nombre_habilidad` varchar(90) NOT NULL,
  PRIMARY KEY (`habilidad_id`),
  UNIQUE KEY `nombre_habilidad` (`nombre_habilidad`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: niveles
CREATE TABLE IF NOT EXISTS `niveles` (
  `nivel_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `codigo_nivel` varchar(20) NOT NULL,
  `nombre_nivel` varchar(120) NOT NULL,
  `banda_cefr` varchar(10) NOT NULL,
  `descripcion_nivel` varchar(300) NOT NULL,
  `meta_xp` int(11) NOT NULL CHECK (`meta_xp` >= 0),
  PRIMARY KEY (`nivel_id`),
  UNIQUE KEY `codigo_nivel` (`codigo_nivel`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: lecciones
CREATE TABLE IF NOT EXISTS `lecciones` (
  `leccion_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `nivel_id` int(11) NOT NULL,
  `titulo_leccion` varchar(160) NOT NULL,
  `objetivo_leccion` varchar(300) NOT NULL,
  `orden_secuencia` int(11) NOT NULL,
  PRIMARY KEY (`leccion_id`),
  UNIQUE KEY `uq_lecciones_nivel_orden` (`nivel_id`,`orden_secuencia`),
  CONSTRAINT `fk_lecciones_nivel` FOREIGN KEY (`nivel_id`) REFERENCES `niveles` (`nivel_id`) ON DELETE CASCADE    -- FK -> niveles.nivel_id
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: intentos_estudiante
CREATE TABLE IF NOT EXISTS `intentos_estudiante` (
  `intento_id` bigint(20) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `estudiante_id` int(11) NOT NULL,
  `leccion_id` int(11) NOT NULL,
  `iniciado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `finalizado_en` timestamp NULL DEFAULT NULL,
  `porcentaje_puntaje` decimal(5,2) NOT NULL DEFAULT 0.00,
  `xp_ganada` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`intento_id`),
  KEY `fk_intentos_estudiante` (`estudiante_id`),
  KEY `fk_intentos_leccion` (`leccion_id`),
  CONSTRAINT `fk_intentos_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`) ON DELETE CASCADE,    -- FK -> estudiantes.estudiante_id
  CONSTRAINT `fk_intentos_leccion` FOREIGN KEY (`leccion_id`) REFERENCES `lecciones` (`leccion_id`) ON DELETE CASCADE    -- FK -> lecciones.leccion_id
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: niveles_habilidades
CREATE TABLE IF NOT EXISTS `niveles_habilidades` (
  `nivel_id` int(11) NOT NULL,
  `habilidad_id` int(11) NOT NULL,
  PRIMARY KEY (`nivel_id`,`habilidad_id`),
  KEY `fk_niveles_habilidades_habilidad` (`habilidad_id`),
  CONSTRAINT `fk_niveles_habilidades_habilidad` FOREIGN KEY (`habilidad_id`) REFERENCES `habilidades` (`habilidad_id`),    -- FK -> habilidades.habilidad_id
  CONSTRAINT `fk_niveles_habilidades_nivel` FOREIGN KEY (`nivel_id`) REFERENCES `niveles` (`nivel_id`) ON DELETE CASCADE    -- FK -> niveles.nivel_id
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: progreso_nivel_estudiante
CREATE TABLE IF NOT EXISTS `progreso_nivel_estudiante` (
  `estudiante_id` int(11) NOT NULL,
  `nivel_id` int(11) NOT NULL,
  `desbloqueado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `completado_en` timestamp NULL DEFAULT NULL,
  `mejor_porcentaje` decimal(5,2) NOT NULL DEFAULT 0.00,
  `xp_ganada` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`estudiante_id`,`nivel_id`),
  KEY `fk_progreso_nivel` (`nivel_id`),
  CONSTRAINT `fk_progreso_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`) ON DELETE CASCADE,    -- FK -> estudiantes.estudiante_id
  CONSTRAINT `fk_progreso_nivel` FOREIGN KEY (`nivel_id`) REFERENCES `niveles` (`nivel_id`) ON DELETE CASCADE    -- FK -> niveles.nivel_id
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: tipos_pregunta
CREATE TABLE IF NOT EXISTS `tipos_pregunta` (
  `tipo_pregunta_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `nombre_tipo_pregunta` varchar(90) NOT NULL,
  PRIMARY KEY (`tipo_pregunta_id`),
  UNIQUE KEY `nombre_tipo_pregunta` (`nombre_tipo_pregunta`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: preguntas
CREATE TABLE IF NOT EXISTS `preguntas` (
  `pregunta_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `leccion_id` int(11) NOT NULL,
  `tipo_pregunta_id` int(11) NOT NULL,
  `enunciado_pregunta` varchar(500) NOT NULL,
  `explicacion` varchar(320) DEFAULT NULL,
  `peso_dificultad` decimal(4,2) NOT NULL DEFAULT 1.00,
  `orden_secuencia` int(11) NOT NULL,
  PRIMARY KEY (`pregunta_id`),
  UNIQUE KEY `uq_preguntas_leccion_orden` (`leccion_id`,`orden_secuencia`),
  KEY `fk_preguntas_tipo` (`tipo_pregunta_id`),
  CONSTRAINT `fk_preguntas_leccion` FOREIGN KEY (`leccion_id`) REFERENCES `lecciones` (`leccion_id`) ON DELETE CASCADE,    -- FK -> lecciones.leccion_id
  CONSTRAINT `fk_preguntas_tipo` FOREIGN KEY (`tipo_pregunta_id`) REFERENCES `tipos_pregunta` (`tipo_pregunta_id`)    -- FK -> tipos_pregunta.tipo_pregunta_id
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: opciones_pregunta
CREATE TABLE IF NOT EXISTS `opciones_pregunta` (
  `opcion_id` int(11) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `pregunta_id` int(11) NOT NULL,
  `texto_opcion` varchar(250) NOT NULL,
  `retroalimentacion` varchar(500) DEFAULT NULL,
  `es_correcta` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`opcion_id`),
  KEY `fk_opciones_pregunta` (`pregunta_id`),
  CONSTRAINT `fk_opciones_pregunta` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`) ON DELETE CASCADE    -- FK -> preguntas.pregunta_id
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: respuestas_intento_estudiante
CREATE TABLE IF NOT EXISTS `respuestas_intento_estudiante` (
  `respuesta_id` bigint(20) NOT NULL AUTO_INCREMENT,    -- Clave primaria
  `intento_id` bigint(20) NOT NULL,
  `pregunta_id` int(11) NOT NULL,
  `opcion_seleccionada_id` int(11) DEFAULT NULL,
  `es_correcta` tinyint(1) NOT NULL,
  PRIMARY KEY (`respuesta_id`),
  KEY `fk_respuestas_intento` (`intento_id`),
  KEY `fk_respuestas_pregunta` (`pregunta_id`),
  KEY `fk_respuestas_opcion` (`opcion_seleccionada_id`),
  CONSTRAINT `fk_respuestas_intento` FOREIGN KEY (`intento_id`) REFERENCES `intentos_estudiante` (`intento_id`) ON DELETE CASCADE,    -- FK -> intentos_estudiante.intento_id
  CONSTRAINT `fk_respuestas_opcion` FOREIGN KEY (`opcion_seleccionada_id`) REFERENCES `opciones_pregunta` (`opcion_id`) ON DELETE SET NULL,    -- FK -> opciones_pregunta.opcion_id
  CONSTRAINT `fk_respuestas_pregunta` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`) ON DELETE CASCADE    -- FK -> preguntas.pregunta_id
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==========================================================
-- Datos
-- ==========================================================

-- docentes: sin registros

-- Registros de: estudiantes (1)
INSERT INTO `estudiantes` (`estudiante_id`, `nombres`, `apellidos`, `grupo_grado`, `correo`, `hash_contrasena`, `creado_en`) VALUES
  (1, 'Maribel', 'Barreto', '11.2', 'maribel@gmail.com', '$2y$10$0xPuoui0lxSpBSswjQXx6e/ATM3ck9cpcWr4p45AgaLvxPt2hdihS', '2026-04-15T12:49:14.000Z');

-- Registros de: habilidades (9)
INSERT INTO `habilidades` (`habilidad_id`, `nombre_habilidad`) VALUES
  (9, 'Comprension contextual'),
  (2, 'Comprension lectora'),
  (4, 'Conectores'),
  (6, 'Futuro'),
  (7, 'Gramatica funcional'),
  (5, 'Opiniones'),
  (3, 'Pasado simple'),
  (8, 'Speaking prompt'),
  (1, 'Vocabulario');

-- Registros de: niveles (3)
INSERT INTO `niveles` (`nivel_id`, `codigo_nivel`, `nombre_nivel`, `banda_cefr`, `descripcion_nivel`, `meta_xp`) VALUES
  (1, 'L1_A2', 'A2 Starter: School Life', 'A2', 'Vocabulario cotidiano, rutinas y contexto escolar.', 30),
  (2, 'L2_A2P', 'A2+ Communicator: Daily Stories', 'A2+', 'Pasado simple y conectores para narrar experiencias.', 40),
  (3, 'L3_B1', 'B1 Challenger: Opinions and Plans', 'B1', 'Opiniones, planes y estructuras de nivel intermedio.', 50);

-- Registros de: lecciones (3)
INSERT INTO `lecciones` (`leccion_id`, `nivel_id`, `titulo_leccion`, `objetivo_leccion`, `orden_secuencia`) VALUES
  (1, 1, 'School Basics', 'Identificar vocabulario del colegio y rutinas simples.', 1),
  (2, 2, 'Tell me your day', 'Narrar acciones pasadas usando conectores.', 1),
  (3, 3, 'Future and opinion', 'Expresar opiniones y planes de manera clara.', 1);

-- intentos_estudiante: sin registros

-- Registros de: niveles_habilidades (9)
INSERT INTO `niveles_habilidades` (`nivel_id`, `habilidad_id`) VALUES
  (1, 1),
  (1, 2),
  (1, 7),
  (2, 3),
  (2, 4),
  (2, 7),
  (3, 5),
  (3, 6),
  (3, 9);

-- progreso_nivel_estudiante: sin registros

-- Registros de: tipos_pregunta (4)
INSERT INTO `tipos_pregunta` (`tipo_pregunta_id`, `nombre_tipo_pregunta`) VALUES
  (2, 'completar_oracion'),
  (4, 'construir_oracion'),
  (3, 'escribir_respuesta'),
  (1, 'seleccion_multiple_respuesta_unica');

-- Registros de: preguntas (25)
INSERT INTO `preguntas` (`pregunta_id`, `leccion_id`, `tipo_pregunta_id`, `enunciado_pregunta`, `explicacion`, `peso_dificultad`, `orden_secuencia`) VALUES
  (1, 1, 1, 'Elige la palabra correcta: I go to ____ at 7:00 a.m.', 'Piensa en el lugar principal donde estudias entre semana.', '1.00', 1),
  (2, 1, 2, 'Completa la oracion: My favorite subject is ____ because it is interesting.', 'Elige una materia escolar real, no un adjetivo suelto.', '1.00', 2),
  (3, 1, 3, 'Escribe en ingles la palabra que falta: I ____ my homework every evening.', 'Verbo basico en presente simple para rutina (sin -s con I).', '1.05', 3),
  (4, 1, 4, 'Construye la traduccion correcta: Ella estudia ingles.', 'Presente simple con she: el verbo lleva -s; English con mayuscula.', '1.10', 4),
  (5, 1, 1, 'Elige la mejor opcion: She ____ a pencil case in her backpack.', 'She va con has en presente (tercera persona).', '1.00', 5),
  (6, 1, 2, 'Completa: We have lunch in the ____ at 12:30.', 'Lugar dentro del colegio donde se almuerza.', '1.00', 6),
  (7, 1, 3, 'Escribe en ingles: The teacher ____ the attendance every morning.', 'Verbo habitual para lista/pase de lista en presente (he/she + -s).', '1.05', 7),
  (8, 1, 4, 'Construye la traduccion: Nosotros tenemos clase de ciencias los martes.', 'Orden natural en ingles: dia de la semana al final con on.', '1.10', 8),
  (9, 1, 1, 'Elige: They ____ to school by bus every day.', 'They concuerda con verbo base en presente (sin -s).', '1.00', 9),
  (10, 1, 2, 'Completa: I need to ____ my notebook before the exam.', 'Verbo para repasar / revisar apuntes.', '1.00', 10),
  (11, 1, 1, 'Lee el texto y elige la respuesta correcta (opciones en ingles). Texto: Every morning, my classmates and I meet at the school gate. We check the timetable on the board and then we walk to our classroom. Our teacher reminds us to turn in projects on Monday. Pregunta: According to the text, what do students check before going to the classroom?', 'Busca una idea explicita en la lectura.', '1.10', 11),
  (12, 1, 1, 'Comprension lectora: Texto: During recess, students can eat a snack, play sports, or talk quietly in the courtyard. The bell rings after twenty minutes and everyone must line up before entering the building. Pregunta: How long does recess last according to the text?', 'Lee los datos numericos con cuidado.', '1.12', 12),
  (13, 1, 2, 'Completa con la mejor opcion: Our teacher always ____ us clear instructions before a test.', 'Presente simple con she/he/it: verbo con -s.', '1.05', 13),
  (14, 1, 2, 'Completa: If you forget your homework, you should ____ to the teacher after class.', 'Despues de should usa la base del verbo (sin to).', '1.05', 14),
  (15, 1, 3, 'Escribe en ingles la palabra que falta: I usually ____ my locker before the first bell rings.', 'Verbo corto en presente con I: sin -s.', '1.05', 15),
  (16, 1, 3, 'Escribe en ingles: Please ____ your phone on silent mode during the lesson.', 'Verbo frecuente para mantener un estado: keep + objeto + on + modo.', '1.08', 16),
  (17, 1, 4, 'Construye la traduccion: El director da un discurso en el gimnasio.', 'Orden SVO; principal = director en este contexto.', '1.12', 17),
  (18, 1, 4, 'Construye: No tenemos clase de arte en la primera hora.', 'Negacion con do not + have + nombre de clase + in the first period.', '1.15', 18),
  (19, 1, 1, 'Lee el texto. Texto: In PE class, we warm up, practice drills, and then play a short match. If you feel dizzy, you must tell the coach immediately. Pregunta: Who should you tell if you feel dizzy?', 'Identifica el rol mencionado para reportar malestar.', '1.08', 19),
  (20, 1, 2, 'Completa: My group needs to ____ a poster about healthy habits for the science fair.', 'Need to + verbo base.', '1.05', 20),
  (21, 1, 3, 'Escribe la palabra en ingles: She ____ her notebook on the desk when the teacher starts the lesson.', 'Presente simple con she: verbo con -s.', '1.05', 21),
  (22, 1, 4, 'Construye la traduccion: Los examenes empiezan la proxima semana.', 'Plural Exams + presente simple + next week.', '1.10', 22),
  (23, 1, 1, 'Lectura: The school library opens at 7:30 a.m. You can borrow two books for two weeks. If you return them late, you pay a small fine. Pregunta: How many books can you borrow at the same time?', 'Lee el numero permitido en la segunda oracion.', '1.10', 23),
  (24, 1, 2, 'Completa: After the lesson, we have to ____ our chairs before leaving the classroom.', 'Have to + verbo base; verbo para apilar sillas.', '1.05', 24),
  (25, 1, 4, 'Construye: No debemos correr en los pasillos.', 'Modal must + not + verbo base; hallways = pasillos.', '1.12', 25);

-- Registros de: opciones_pregunta (91)
INSERT INTO `opciones_pregunta` (`opcion_id`, `pregunta_id`, `texto_opcion`, `retroalimentacion`, `es_correcta`) VALUES
  (1, 1, 'school', 'Correcto: school es el colegio; encaja con go to + lugar.', 1),
  (2, 1, 'hospital', 'Hospital es atencion medica, no tu rutina escolar diaria.', 0),
  (3, 1, 'market', 'Market es mercado; no describe el destino tipico a las 7:00 a.m. para estudiar.', 0),
  (4, 1, 'airport', 'Airport es aeropuerto; no es el lugar cotidiano de clases.', 0),
  (5, 2, 'math', 'Correcto: math es una materia; concuerda con subject.', 1),
  (6, 2, 'running', 'Running es una actividad, no el nombre de una materia aqui.', 0),
  (7, 2, 'door', 'Door es objeto; no completa el sentido de materia favorita.', 0),
  (8, 2, 'happy', 'Happy es adjetivo; necesitas un sustantivo de materia.', 0),
  (9, 3, 'do', 'Correcto: do my homework es la colocacion natural con I.', 1),
  (10, 4, 'She studies English', 'Correcto: she + studies + English (idioma con mayuscula).', 1),
  (11, 4, 'study', 'Distractor: falta -s y sujeto.', 0),
  (12, 4, 'He', 'Distractor: pronombre incorrecto para ella.', 0),
  (13, 4, 'spanish', 'Distractor: otro idioma; no forma la oracion.', 0),
  (14, 4, 'studying', 'Distractor: forma en -ing no basta sola para esta estructura.', 0),
  (15, 5, 'has', 'Correcto: she has (have -> has).', 1),
  (16, 5, 'have', 'Have no concuerda con she en presente.', 0),
  (17, 5, 'is', 'Is no expresa posesion aqui.', 0),
  (18, 5, 'are', 'Are no concuerda con she.', 0),
  (19, 6, 'cafeteria', 'Correcto: cafeteria es el comedor escolar.', 1),
  (20, 6, 'library', 'Library es biblioteca; no el lugar tipico de almuerzo.', 0),
  (21, 6, 'classroom', 'Classroom es aula; menos natural para lunch.', 0),
  (22, 6, 'gym', 'Gym es gimnasio; no encaja con have lunch.', 0),
  (23, 7, 'takes', 'Correcto: take attendance es colocacion frecuente; takes con teacher.', 1),
  (24, 8, 'We have science class on Tuesdays', 'Correcto: we have + science class + on Tuesdays.', 1),
  (25, 8, 'Monday', 'Distractor: otro dia.', 0),
  (26, 8, 'Wednesday', 'Distractor: otro dia.', 0),
  (27, 8, 'they', 'Distractor: pronombre incorrecto (we).', 0),
  (28, 8, 'at', 'Distractor: preposicion suelta; no sustituye on + dia.', 0),
  (29, 9, 'go', 'Correcto: they go (presente, verbo base).', 1),
  (30, 9, 'goes', 'Goes lleva -s para he/she/it, no para they.', 0),
  (31, 9, 'going', 'Going necesita verbo auxiliar aqui.', 0),
  (32, 9, 'are', 'Are no va con go to school de esta forma.', 0),
  (33, 10, 'review', 'Correcto: review notebook encaja con estudiar antes del examen.', 1),
  (34, 10, 'repeat', 'Repeat es repetir; menos preciso que review aqui.', 0),
  (35, 10, 'remember', 'Remember no completa bien la idea de preparar el cuaderno.', 0),
  (36, 10, 'return', 'Return no expresa preparar o repasar.', 0),
  (37, 11, 'the timetable', 'Correcto: el texto dice check the timetable on the board.', 1),
  (38, 11, 'the projects', 'Los proyectos se mencionan para entregar el lunes, no para revisar antes de entrar.', 0),
  (39, 11, 'the teacher', 'El texto no dice que revisen al profesor en ese momento.', 0),
  (40, 11, 'the school gate', 'El porton es el punto de encuentro, no lo que revisan en el tablero.', 0),
  (41, 12, 'twenty minutes', 'Correcto: after twenty minutes aparece en el texto.', 1),
  (42, 12, 'one hour', 'No coincide con twenty minutes.', 0),
  (43, 12, 'ten minutes', 'Es un distractor numerico.', 0),
  (44, 12, 'until lunch', 'El texto no dice que el recreo dure hasta el almuerzo.', 0),
  (45, 13, 'gives', 'Correcto: teacher + gives + us + instructions.', 1),
  (46, 13, 'give', 'Give no lleva -s con sujeto en tercera persona.', 0),
  (47, 13, 'giving', 'Aquí necesitas presente simple, no forma continua sola.', 0),
  (48, 13, 'is give', 'Estructura incorrecta en ingles estandar.', 0),
  (49, 14, 'apologize', 'Correcto: should + apologize (verbo base).', 1),
  (50, 14, 'apologizes', 'No uses -s despues de should con you.', 0),
  (51, 14, 'apology', 'Necesitas un verbo, no solo el sustantivo aqui.', 0),
  (52, 14, 'to apologize', 'Should no va seguido de to + verbo en este patron basico.', 0),
  (53, 15, 'open', 'Correcto: open my locker es natural en rutina escolar.', 1),
  (54, 16, 'keep', 'Correcto: keep your phone on silent mode.', 1),
  (55, 17, 'The principal gives a speech in the gym', 'Correcto: principal + gives + a speech + in the gym.', 1),
  (56, 17, 'teacher', 'Distractor: rol distinto.', 0),
  (57, 17, 'runs', 'Distractor: verbo que no construye la traduccion.', 0),
  (58, 17, 'student', 'Distractor: persona incorrecta.', 0),
  (59, 17, 'at', 'Distractor: preposicion suelta.', 0),
  (60, 18, 'We do not have art class in the first period', 'Correcto: we do not have + art class + in the first period.', 1),
  (61, 18, 'science', 'Distractor: otra materia.', 0),
  (62, 18, 'Monday', 'Distractor: dia suelto.', 0),
  (63, 18, 'they', 'Distractor: pronombre incorrecto.', 0),
  (64, 18, 'music', 'Distractor: otra materia.', 0),
  (65, 19, 'the coach', 'Correcto: tell the coach aparece en el texto.', 1),
  (66, 19, 'the principal', 'No aparece como destino inmediato en el fragmento.', 0),
  (67, 19, 'the librarian', 'No encaja con educacion fisica.', 0),
  (68, 19, 'the referee', 'Referee no se usa en el texto; coach si.', 0),
  (69, 20, 'make', 'Correcto: make a poster es colocacion natural.', 1),
  (70, 20, 'makes', 'No uses -s despues de to.', 0),
  (71, 20, 'making', 'Despues de to va la base del verbo.', 0),
  (72, 20, 'made', 'Made es pasado; aqui se pide infinitivo con to.', 0),
  (73, 21, 'puts', 'Correcto: she puts her notebook on the desk.', 1),
  (74, 22, 'Exams start next week', 'Correcto: exams start next week.', 1),
  (75, 22, 'test', 'Distractor: singular parcial.', 0),
  (76, 22, 'Monday', 'Distractor: dia concreto no pedido.', 0),
  (77, 22, 'they', 'Distractor: pronombre.', 0),
  (78, 22, 'at', 'Distractor: preposicion suelta.', 0),
  (79, 23, 'two books', 'Correcto: two books aparece en el texto.', 1),
  (80, 23, 'one book', 'No coincide con two books.', 0),
  (81, 23, 'three books', 'No esta soportado por el texto.', 0),
  (82, 23, 'four books', 'No esta soportado por el texto.', 0),
  (83, 24, 'stack', 'Correcto: stack our chairs es rutina comun al salir.', 1),
  (84, 24, 'stacks', 'Sin -s despues de to.', 0),
  (85, 24, 'stacking', 'Forma -ing no sigue a have to aqui.', 0),
  (86, 24, 'stacked', 'Pasado no encaja con rutina general.', 0),
  (87, 25, 'We must not run in the hallways', 'Correcto: must not run + in the hallways.', 1),
  (88, 25, 'walk', 'Distractor: verbo distinto.', 0),
  (89, 25, 'classroom', 'Distractor: lugar incorrecto para la regla.', 0),
  (90, 25, 'they', 'Distractor: pronombre.', 0),
  (91, 25, 'quickly', 'Distractor: adverbio suelto.', 0);

-- respuestas_intento_estudiante: sin registros

-- ==========================================================
-- Fin del script
-- ==========================================================
