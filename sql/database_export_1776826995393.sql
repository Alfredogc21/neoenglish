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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=349 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- Registros de: preguntas (100)
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
  (25, 1, 4, 'Construye: No debemos correr en los pasillos.', 'Modal must + not + verbo base; hallways = pasillos.', '1.12', 25),
  (26, 2, 1, 'Elige el conector correcto: I got home late, ____ I took a quick shower and went to bed.', 'Necesitas un conector de consecuencia para cerrar la idea.', '1.15', 1),
  (27, 2, 2, 'Completa: Yesterday we ____ my grandparents and had dinner with them.', 'Pasado simple del verbo visit.', '1.15', 2),
  (28, 2, 3, 'Escribe en ingles la palabra que falta: After dinner, we ____ a movie and talked about school.', 'Verbo regular en pasado para ver una pelicula.', '1.18', 3),
  (29, 2, 4, 'Construye la traduccion: Primero termine mi tarea y despues sali con mis amigos.', 'Usa conectores de secuencia: First ... then ...', '1.20', 4),
  (30, 2, 1, 'Lee el texto y elige la respuesta correcta. Texto: On Saturday, Laura woke up early, made breakfast, and cleaned the kitchen. Then she took the bus to visit her cousin. In the evening, they watched a comedy and ate pizza. Pregunta: What did Laura do right after breakfast?', 'Sigue el orden cronologico del texto.', '1.18', 5),
  (31, 2, 2, 'Completa: My brother ____ his phone at home, so he came back for it.', 'Necesitas pasado simple para una accion terminada.', '1.15', 6),
  (32, 2, 3, 'Escribe en ingles: Last Saturday, they ____ to the park because the weather was perfect.', 'Pasado de go.', '1.18', 7),
  (33, 2, 4, 'Construye la traduccion: Aunque estaba cansada, termine el reporte antes de dormir.', 'Although introduce contraste en una historia.', '1.22', 8),
  (34, 2, 1, 'Elige el conector correcto: We missed the bus, ____ we arrived late to class.', 'La segunda parte muestra consecuencia.', '1.15', 9),
  (35, 2, 2, 'Completa: I ____ the story, so I asked a question.', 'Forma negativa en pasado simple: did not + verbo base.', '1.18', 10),
  (36, 2, 1, 'Comprension lectora: Texto: Yesterday, Diego and Ana visited the science museum. First, they watched a robot show. Next, they had lunch at a small food truck near the museum and took many notes. Pregunta: Where did they have lunch?', 'Busca el lugar exacto mencionado en el texto.', '1.20', 11),
  (37, 2, 1, 'Lee el texto. Texto: We celebrated my sisters birthday at home. We decorated the living room, played board games, and took six photos before cake time. Pregunta: How many photos did we take before the cake?', 'Identifica el numero en la ultima parte del texto.', '1.20', 12),
  (38, 2, 3, 'Escribe en ingles la palabra que falta: She ____ her keys on the table before leaving.', 'Verbo irregular en pasado para dejar algo en un lugar.', '1.18', 13),
  (39, 2, 3, 'Escribe en ingles: We ____ a new cafe downtown last night.', 'Pasado simple del verbo try.', '1.18', 14),
  (40, 2, 2, 'Completa: Before I went to bed, I ____ my alarm for 6:00 a.m.', 'Verbo irregular en pasado para configurar una alarma.', '1.18', 15),
  (41, 2, 2, 'Completa: They ____ soccer after school, and then they did homework.', 'Pasado regular del verbo play.', '1.15', 16),
  (42, 2, 4, 'Construye la traduccion: Despues de que termine la reunion, llame a mi mama.', 'Usa after para conectar acciones en secuencia.', '1.22', 17),
  (43, 2, 4, 'Construye la traduccion: No salimos porque empezo a llover muy fuerte.', 'Combina negacion en pasado y because.', '1.22', 18),
  (44, 2, 1, 'Lectura: In the afternoon, Diego went to the supermarket with his father. They bought bread and milk, then returned home to cook soup. Pregunta: What did they buy at the supermarket?', 'La respuesta esta explicita en la segunda oracion.', '1.18', 19),
  (45, 2, 2, 'Completa: While I was cooking, my sister ____ the table.', 'Pasado simple de set (misma forma en presente y pasado).', '1.20', 20),
  (46, 2, 3, 'Escribe en ingles: Yesterday, our teacher ____ us a short story about friendship.', 'Pasado de tell.', '1.20', 21),
  (47, 2, 4, 'Construye la traduccion: Luego vimos un capitulo y comentamos el final.', 'Usa Then para continuar la narracion.', '1.22', 22),
  (48, 2, 1, 'Elige el conector correcto: I wanted to go out, ____ it was raining all evening.', 'Necesitas un conector de contraste.', '1.15', 23),
  (49, 2, 2, 'Completa: My parents ____ home early because the movie ended at 8:30.', 'Pasado simple del verbo come.', '1.18', 24),
  (50, 2, 4, 'Construye la traduccion: Al final del dia, me senti orgulloso porque complete todo.', 'Usa At the end of the day + past simple + because.', '1.25', 25),
  (51, 2, 1, 'Elige el conector correcto: I finished my project early, ____ I helped my classmate.', 'La segunda accion es consecuencia de terminar temprano.', '1.20', 26),
  (52, 2, 2, 'Completa: Last night, we ____ dinner at my uncles house.', 'Pasado simple irregular del verbo eat.', '1.20', 27),
  (53, 2, 3, 'Escribe en ingles: After school, I ____ my cousin at the bus stop.', 'Pasado simple de meet.', '1.22', 28),
  (54, 2, 4, 'Construye la traduccion: Primero lavamos los platos y luego vimos una serie.', 'Usa conectores de secuencia en pasado simple.', '1.25', 29),
  (55, 2, 1, 'Elige el conector correcto: She wanted to buy the jacket, ____ it was too expensive.', 'Necesitas contraste entre deseo y precio.', '1.20', 30),
  (56, 2, 2, 'Completa: They ____ to music while they cleaned the room.', 'Pasado simple regular del verbo listen.', '1.20', 31),
  (57, 2, 3, 'Escribe en ingles la palabra que falta: My dad ____ the car before work yesterday.', 'Pasado regular del verbo wash.', '1.22', 32),
  (58, 2, 4, 'Construye la traduccion: Aunque llovia, jugamos futbol en el parque.', 'Although introduce contraste en pasado.', '1.25', 33),
  (59, 2, 1, 'Lee el texto y elige la respuesta correcta. Texto: On Sunday, we visited my aunt. We arrived at 10:00, had lunch, and left at 3:00. Pregunta: At what time did we leave?', 'Busca la hora final de salida.', '1.22', 34),
  (60, 2, 2, 'Completa: I ____ my notebook on the bus, so I borrowed one at school.', 'Pasado simple irregular del verbo forget.', '1.22', 35),
  (61, 2, 1, 'Comprension lectora: Texto: Yesterday, Sofia woke up early, made breakfast, and then took the bus to school. Pregunta: What did Sofia do first?', 'Identifica la primera accion en secuencia.', '1.24', 36),
  (62, 2, 1, 'Elige el conector correcto: I was very tired, ____ I went to bed early.', 'La segunda parte expresa resultado.', '1.20', 37),
  (63, 2, 3, 'Escribe en ingles: We ____ photos during the trip to the lake.', 'Pasado simple irregular del verbo take.', '1.24', 38),
  (64, 2, 3, 'Escribe en ingles la palabra que falta: She ____ her grandmother after dinner.', 'Pasado regular del verbo call.', '1.24', 39),
  (65, 2, 2, 'Completa: We ____ not watch TV because we had a lot of homework.', 'Negacion en pasado simple: did not + verbo base.', '1.24', 40),
  (66, 2, 2, 'Completa: My friends ____ a cake for the party yesterday.', 'Pasado simple irregular del verbo make.', '1.24', 41),
  (67, 2, 4, 'Construye la traduccion: Despues de clase, fuimos a la biblioteca y estudiamos juntos.', 'Usa after class y verbos en pasado simple.', '1.28', 42),
  (68, 2, 4, 'Construye la traduccion: No fui al cine porque tenia fiebre.', 'Combina negacion en pasado y because.', '1.28', 43),
  (69, 2, 1, 'Lectura: In the evening, Maria went to the store with her brother. They bought milk and eggs, and then they cooked dinner. Pregunta: What did they buy?', 'La respuesta aparece de forma explicita.', '1.24', 44),
  (70, 2, 2, 'Completa: Before the game started, the coach ____ us a short talk.', 'Pasado simple irregular del verbo give.', '1.24', 45),
  (71, 2, 3, 'Escribe en ingles: At night, I ____ my room and prepared my backpack.', 'Pasado regular del verbo clean.', '1.24', 46),
  (72, 2, 4, 'Construye la traduccion: Finalmente llegamos a casa y descansamos un rato.', 'Usa Finally para cerrar la narracion.', '1.28', 47),
  (73, 2, 1, 'Elige el conector correcto: We did not have umbrellas, ____ we got wet.', 'Necesitas un conector de consecuencia.', '1.20', 48),
  (74, 2, 2, 'Completa: My sister ____ me with math, and then we reviewed for the quiz.', 'Pasado regular del verbo help.', '1.24', 49),
  (75, 2, 4, 'Construye la traduccion: Al final, entendimos la historia porque el profesor la explico otra vez.', 'Usa In the end + because para cerrar la secuencia.', '1.30', 50),
  (76, 3, 1, 'Elige la mejor opcion: In my opinion, online learning is flexible, ____ students need strong time management.', 'Necesitas un conector de contraste para completar la idea.', '1.30', 1),
  (77, 3, 2, 'Completa: Next semester, I ____ taking an elective course in robotics.', 'Estructura de plan futuro con going to.', '1.28', 2),
  (78, 3, 3, 'Escribe en ingles la palabra que falta: By 2030, many people ____ work remotely.', 'Futuro simple para predicciones.', '1.30', 3),
  (79, 3, 4, 'Construye la traduccion: Creo que deberiamos empezar el proyecto esta semana.', 'Usa I think + should para expresar opinion y plan.', '1.35', 4),
  (80, 3, 1, 'Lee el texto y elige la respuesta correcta. Texto: In our class debate, Lucia said we should reduce homework on Fridays because students need time for sports and family. Marco agreed with the idea but suggested keeping short reading tasks. Pregunta: What did Marco suggest?', 'Identifica la opinion especifica de Marco.', '1.32', 5),
  (81, 3, 2, 'Completa: From my point of view, the city ____ invest more in public transport.', 'Expresion de recomendacion en opiniones: should + verbo base.', '1.30', 6),
  (82, 3, 3, 'Escribe en ingles: Our team ____ to launch the app in July.', 'Verbo frecuente para planes: plan en tercera persona singular.', '1.30', 7),
  (83, 3, 1, 'Elige el conector correcto: I prefer studying in the morning ____ I can focus better.', 'Necesitas un conector de causa.', '1.30', 8),
  (84, 3, 2, 'Completa: We ____ meeting the principal at 9:00 tomorrow.', 'Presente continuo para plan ya acordado.', '1.30', 9),
  (85, 3, 3, 'Escribe en ingles la palabra que falta: To be honest, I ____ rather study in the morning.', 'Estructura de preferencia: would rather + verbo base.', '1.32', 10),
  (86, 3, 4, 'Construye la traduccion: No estoy totalmente de acuerdo, pero entiendo tu punto.', 'Desacuerdo respetuoso con but para contraste.', '1.36', 11),
  (87, 3, 2, 'Completa: If I were you, I ____ compare at least three universities before applying.', 'Condicional para consejos: If I were you, I would...', '1.34', 12),
  (88, 3, 3, 'Escribe en ingles la palabra que falta: She liked the idea, ____ she suggested a cheaper version.', 'Conector de contraste entre dos ideas.', '1.30', 13),
  (89, 3, 1, 'Lee el texto. Texto: The environmental club planned a weekend campaign. First, they will design posters on Friday. Next, they will share them online, and on Sunday they will clean the park. Pregunta: What will they do first?', 'Sigue la secuencia del plan futuro.', '1.34', 14),
  (90, 3, 2, 'Completa: This weekend we ____ going to visit the science fair.', 'Plan cercano: be going to.', '1.30', 15),
  (91, 3, 4, 'Construye la traduccion: En mi opinion, el transporte publico sera mas eficiente en el futuro.', 'Usa In my opinion + will para prediccion.', '1.38', 16),
  (92, 3, 1, 'Elige la opcion que expresa desacuerdo respetuoso:', 'Debes identificar una formula cortes de desacuerdo.', '1.34', 17),
  (93, 3, 2, 'Completa: Our teacher thinks we ____ support our opinions with clear evidence.', 'Recomendacion academica con should.', '1.32', 18),
  (94, 3, 4, 'Construye la traduccion: Si terminamos hoy, enviaremos el informe manana por la manana.', 'Condicional real: If + presente, will + verbo base.', '1.38', 19),
  (95, 3, 1, 'Lectura: We wanted to have a picnic on Saturday, but the forecast predicted heavy rain. Therefore, we moved it to Sunday and prepared indoor games just in case. Pregunta: Why did they postpone the picnic?', 'Busca la causa principal en el texto.', '1.34', 20),
  (96, 3, 2, 'Completa: At the end of the meeting, everyone ____ on the final plan.', 'Pasado simple para decision tomada y cerrada.', '1.32', 21),
  (97, 3, 3, 'Escribe en ingles la palabra que falta: In the future, electric cars ____ become cheaper.', 'Prediccion en futuro simple.', '1.32', 22),
  (98, 3, 1, 'Elige el conector correcto: The plan is ambitious; ____, it is realistic if we organize well.', 'Necesitas un conector de contraste formal.', '1.34', 23),
  (99, 3, 2, 'Completa: By next year, the company ____ open two new offices.', 'Futuro simple para proyeccion institucional.', '1.32', 24),
  (100, 3, 4, 'Construye la traduccion: Aunque el proyecto es dificil, estoy seguro de que podemos lograrlo.', 'Usa Although para contraste y can para posibilidad real.', '1.40', 25);

-- Registros de: opciones_pregunta (348)
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
  (91, 25, 'quickly', 'Distractor: adverbio suelto.', 0),
  (92, 26, 'so', 'Correcto: so conecta causa y consecuencia en la historia.', 1),
  (93, 26, 'because', 'Because introduce causa y no encaja despues de la coma en este patron.', 0),
  (94, 26, 'before', 'Before expresa tiempo, no consecuencia aqui.', 0),
  (95, 26, 'or', 'Or indica alternativa, no resultado.', 0),
  (96, 27, 'visited', 'Correcto: pasado simple regular de visit.', 1),
  (97, 27, 'visit', 'Falta marcar pasado simple.', 0),
  (98, 27, 'visiting', 'Forma en -ing no corresponde aqui.', 0),
  (99, 27, 'visits', 'Tercera persona singular, no pasado.', 0),
  (100, 29, 'First, I finished my homework and then I went out with my friends', 'Correcto: secuencia clara en pasado con conectores.', 1),
  (101, 29, 'yesterday', 'Distractor: palabra suelta.', 0),
  (102, 29, 'finish', 'Distractor: verbo en base sin estructura.', 0),
  (103, 29, 'because', 'Distractor: conector incorrecto para esta traduccion.', 0),
  (104, 29, 'with', 'Distractor: preposicion suelta.', 0),
  (105, 30, 'She cleaned the kitchen.', 'Correcto: despues de breakfast, limpio la cocina.', 1),
  (106, 30, 'She went to the gym.', 'No aparece en el texto.', 0),
  (107, 30, 'She called her aunt.', 'No aparece en el texto.', 0),
  (108, 30, 'She studied for three hours.', 'No aparece en el texto.', 0),
  (109, 31, 'left', 'Correcto: pasado de leave.', 1),
  (110, 31, 'leave', 'Falta pasado simple.', 0),
  (111, 31, 'leaves', 'Forma de presente en tercera persona.', 0),
  (112, 31, 'leaving', 'Forma en -ing incorrecta aqui.', 0),
  (113, 33, 'Although she was tired, she finished the report before bed', 'Correcto: contraste con although y verbo en pasado.', 1),
  (114, 33, 'then', 'Distractor: conector suelto.', 0),
  (115, 33, 'report', 'Distractor: sustantivo suelto.', 0),
  (116, 33, 'sleeping', 'Distractor: forma en -ing suelta.', 0),
  (117, 33, 'because', 'Distractor: conector no pedido en la traduccion.', 0),
  (118, 34, 'so', 'Correcto: expresa consecuencia de perder el bus.', 1),
  (119, 34, 'but', 'But expresa contraste, no resultado directo.', 0),
  (120, 34, 'after', 'After expresa tiempo, no consecuencia.', 0),
  (121, 34, 'if', 'If expresa condicion, no esta relacion.', 0),
  (122, 35, 'did not understand', 'Correcto: negativo en pasado = did not + verbo base.', 1),
  (123, 35, 'do not understand', 'Eso esta en presente, no en pasado.', 0),
  (124, 35, 'not understood', 'Estructura incompleta para esta oracion.', 0),
  (125, 35, 'did not understood', 'Despues de did not va verbo base, no pasado.', 0),
  (126, 36, 'at a small food truck near the museum', 'Correcto: el lugar se menciona de forma literal.', 1),
  (127, 36, 'at Diego house', 'No coincide con el texto.', 0),
  (128, 36, 'at school', 'No coincide con el texto.', 0),
  (129, 36, 'at the train station', 'No coincide con el texto.', 0),
  (130, 37, 'six', 'Correcto: tomaron six photos.', 1),
  (131, 37, 'two', 'No coincide con el numero del texto.', 0),
  (132, 37, 'ten', 'No coincide con el numero del texto.', 0),
  (133, 37, 'none', 'No coincide con el texto.', 0),
  (134, 40, 'set', 'Correcto: set mantiene la misma forma en pasado.', 1),
  (135, 40, 'setting', 'Forma en -ing no corresponde.', 0),
  (136, 40, 'sets', 'Presente tercera persona, no pasado.', 0),
  (137, 40, 'setted', 'Forma incorrecta del verbo set.', 0),
  (138, 41, 'played', 'Correcto: pasado regular de play.', 1),
  (139, 41, 'play', 'Falta pasado simple.', 0),
  (140, 41, 'plays', 'Presente en tercera persona.', 0),
  (141, 41, 'playing', 'Forma en -ing incorrecta para este hueco.', 0),
  (142, 42, 'After I finished the meeting, I called my mom', 'Correcto: secuencia en pasado con after.', 1),
  (143, 42, 'meeting', 'Distractor: sustantivo suelto.', 0),
  (144, 42, 'call', 'Distractor: verbo en base suelto.', 0),
  (145, 42, 'before', 'Distractor: conector incorrecto para esta traduccion.', 0),
  (146, 42, 'at', 'Distractor: preposicion suelta.', 0),
  (147, 43, 'We did not go out because it started to rain heavily', 'Correcto: negacion en pasado + because.', 1),
  (148, 43, 'rain', 'Distractor: palabra suelta.', 0),
  (149, 43, 'yesterday', 'Distractor: adverbio suelto.', 0),
  (150, 43, 'they', 'Distractor: pronombre suelto.', 0),
  (151, 43, 'quickly', 'Distractor: adverbio suelto.', 0),
  (152, 44, 'bread and milk', 'Correcto: esos son los productos mencionados.', 1),
  (153, 44, 'rice and chicken', 'No aparece en el texto.', 0),
  (154, 44, 'only fruit', 'No aparece en el texto.', 0),
  (155, 44, 'nothing', 'Si compraron productos, no es correcto.', 0),
  (156, 45, 'set', 'Correcto: set the table en pasado tambien es set.', 1),
  (157, 45, 'sets', 'Presente en tercera persona.', 0),
  (158, 45, 'setting', 'Forma en -ing no corresponde.', 0),
  (159, 45, 'setted', 'Forma incorrecta del verbo set.', 0),
  (160, 47, 'Then we watched an episode and discussed the ending', 'Correcto: Then + pasado simple para continuar la historia.', 1),
  (161, 47, 'episode', 'Distractor: sustantivo suelto.', 0),
  (162, 47, 'after', 'Distractor: conector no pedido aqui.', 0),
  (163, 47, 'watching', 'Distractor: forma en -ing suelta.', 0),
  (164, 47, 'story', 'Distractor: sustantivo suelto.', 0),
  (165, 48, 'but', 'Correcto: but expresa contraste con la lluvia.', 1),
  (166, 48, 'so', 'So expresa resultado, no contraste.', 0),
  (167, 48, 'and', 'And solo agrega informacion sin contraste.', 0),
  (168, 48, 'because', 'Because introduce causa y no encaja en este patron.', 0),
  (169, 49, 'came', 'Correcto: pasado simple de come.', 1),
  (170, 49, 'come', 'Falta pasado simple.', 0),
  (171, 49, 'comes', 'Presente tercera persona.', 0),
  (172, 49, 'coming', 'Forma en -ing no corresponde.', 0),
  (173, 50, 'At the end of the day, I felt proud because I completed everything', 'Correcto: traduccion completa con conector y pasado simple.', 1),
  (174, 50, 'proud', 'Distractor: adjetivo suelto.', 0),
  (175, 50, 'finish', 'Distractor: verbo en base suelto.', 0),
  (176, 50, 'yesterday', 'Distractor: adverbio suelto.', 0),
  (177, 50, 'at', 'Distractor: preposicion suelta.', 0),
  (178, 51, 'so', 'Correcto: so conecta causa y consecuencia.', 1),
  (179, 51, 'but', 'But expresa contraste, no resultado.', 0),
  (180, 51, 'because', 'Because introduce causa y no encaja aqui.', 0),
  (181, 51, 'or', 'Or indica alternativa, no consecuencia.', 0),
  (182, 52, 'ate', 'Correcto: pasado irregular de eat.', 1),
  (183, 52, 'eat', 'Forma base, no pasado.', 0),
  (184, 52, 'eating', 'Forma en -ing no corresponde.', 0),
  (185, 52, 'eats', 'Presente en tercera persona.', 0),
  (186, 54, 'First, we washed the dishes and then we watched a series', 'Correcto: secuencia completa en pasado.', 1),
  (187, 54, 'first', 'Distractor: palabra suelta.', 0),
  (188, 54, 'dishes', 'Distractor: sustantivo suelto.', 0),
  (189, 54, 'because', 'Distractor: conector no pedido.', 0),
  (190, 54, 'watching', 'Distractor: forma en -ing suelta.', 0),
  (191, 55, 'but', 'Correcto: muestra contraste entre deseo y precio.', 1),
  (192, 55, 'so', 'So expresa resultado, no contraste.', 0),
  (193, 55, 'and', 'And solo agrega informacion.', 0),
  (194, 55, 'because', 'Because cambia la relacion esperada.', 0),
  (195, 56, 'listened', 'Correcto: pasado regular de listen.', 1),
  (196, 56, 'listen', 'Falta pasado simple.', 0),
  (197, 56, 'listening', 'Forma en -ing no corresponde.', 0),
  (198, 56, 'listens', 'Presente tercera persona.', 0),
  (199, 58, 'Although it was raining, we played soccer in the park', 'Correcto: contraste con although y pasado simple.', 1),
  (200, 58, 'although', 'Distractor: conector suelto.', 0),
  (201, 58, 'rain', 'Distractor: sustantivo/verbo suelto.', 0),
  (202, 58, 'yesterday', 'Distractor: adverbio suelto.', 0),
  (203, 58, 'because', 'Distractor: conector incorrecto.', 0),
  (204, 59, 'at 3:00', 'Correcto: el texto dice que salieron a las 3:00.', 1),
  (205, 59, 'at 10:00', 'Esa es la hora de llegada.', 0),
  (206, 59, 'at 12:00', 'No aparece en el texto.', 0),
  (207, 59, 'at 5:00', 'No coincide con el dato textual.', 0),
  (208, 60, 'forgot', 'Correcto: pasado irregular de forget.', 1),
  (209, 60, 'forget', 'Forma base, no pasado.', 0),
  (210, 60, 'forgets', 'Presente tercera persona.', 0),
  (211, 60, 'forgotten', 'Participio, no pasado simple en esta estructura.', 0),
  (212, 61, 'She made breakfast.', 'Correcto: esa fue la primera accion.', 1),
  (213, 61, 'She went to bed.', 'No aparece en el texto.', 0),
  (214, 61, 'She took the bus.', 'Eso paso despues de desayunar.', 0),
  (215, 61, 'She watched a movie.', 'No aparece en el texto.', 0),
  (216, 62, 'so', 'Correcto: expresa consecuencia.', 1),
  (217, 62, 'because', 'Because introduce causa en vez de resultado.', 0),
  (218, 62, 'but', 'But expresa contraste, no resultado.', 0),
  (219, 62, 'after', 'After expresa tiempo, no consecuencia.', 0),
  (220, 65, 'did', 'Correcto: did not + verbo base.', 1),
  (221, 65, 'do', 'Do not se usa en presente.', 0),
  (222, 65, 'was', 'No se usa para esta negacion verbal.', 0),
  (223, 65, 'were', 'No se usa para esta negacion verbal.', 0),
  (224, 66, 'made', 'Correcto: pasado irregular de make.', 1),
  (225, 66, 'make', 'Forma base, no pasado.', 0),
  (226, 66, 'makes', 'Presente tercera persona.', 0),
  (227, 66, 'making', 'Forma en -ing incorrecta para este hueco.', 0),
  (228, 67, 'After class, we went to the library and studied together', 'Correcto: traduccion completa y natural.', 1),
  (229, 67, 'after', 'Distractor: conector suelto.', 0),
  (230, 67, 'class', 'Distractor: sustantivo suelto.', 0),
  (231, 67, 'library', 'Distractor: sustantivo suelto.', 0),
  (232, 67, 'study', 'Distractor: verbo base suelto.', 0),
  (233, 68, 'I did not go to the movies because I had a fever', 'Correcto: negacion en pasado + causa.', 1),
  (234, 68, 'movies', 'Distractor: sustantivo suelto.', 0),
  (235, 68, 'fever', 'Distractor: sustantivo suelto.', 0),
  (236, 68, 'because', 'Distractor: conector suelto.', 0),
  (237, 68, 'yesterday', 'Distractor: adverbio suelto.', 0),
  (238, 69, 'milk and eggs', 'Correcto: esos son los productos del texto.', 1),
  (239, 69, 'rice and chicken', 'No aparece en el texto.', 0),
  (240, 69, 'juice and bread', 'No coincide con el texto.', 0),
  (241, 69, 'nothing', 'Si compraron productos, no es correcto.', 0),
  (242, 70, 'gave', 'Correcto: pasado irregular de give.', 1),
  (243, 70, 'give', 'Forma base, no pasado.', 0),
  (244, 70, 'gives', 'Presente tercera persona.', 0),
  (245, 70, 'giving', 'Forma en -ing no corresponde.', 0),
  (246, 72, 'Finally, we arrived home and rested for a while', 'Correcto: cierre de narracion en pasado.', 1),
  (247, 72, 'finally', 'Distractor: adverbio suelto.', 0),
  (248, 72, 'home', 'Distractor: sustantivo/adverbio suelto.', 0),
  (249, 72, 'resting', 'Distractor: forma en -ing suelta.', 0),
  (250, 72, 'after', 'Distractor: conector no pedido.', 0),
  (251, 73, 'so', 'Correcto: conecta causa con consecuencia.', 1),
  (252, 73, 'but', 'But introduce contraste, no consecuencia.', 0),
  (253, 73, 'and', 'And solo agrega informacion.', 0),
  (254, 73, 'because', 'Because cambia la estructura esperada aqui.', 0),
  (255, 74, 'helped', 'Correcto: pasado regular de help.', 1),
  (256, 74, 'help', 'Forma base, no pasado.', 0),
  (257, 74, 'helping', 'Forma en -ing no corresponde.', 0),
  (258, 74, 'helps', 'Presente tercera persona.', 0),
  (259, 75, 'In the end, we understood the story because the teacher explained it again', 'Correcto: traduccion completa con because.', 1),
  (260, 75, 'story', 'Distractor: sustantivo suelto.', 0),
  (261, 75, 'because', 'Distractor: conector suelto.', 0),
  (262, 75, 'understood', 'Distractor: verbo suelto.', 0),
  (263, 75, 'end', 'Distractor: palabra suelta.', 0),
  (264, 76, 'but', 'Correcto: but introduce contraste entre dos ideas.', 1),
  (265, 76, 'so', 'So expresa consecuencia, no contraste.', 0),
  (266, 76, 'because', 'Because introduce causa y cambia la estructura.', 0),
  (267, 76, 'and', 'And solo suma ideas, no contrapone.', 0),
  (268, 77, 'am going to', 'Correcto: plan futuro con be going to + verbo en -ing aqui.', 1),
  (269, 77, 'will', 'Will no encaja en esta estructura con taking.', 0),
  (270, 77, 'am', 'Am solo queda incompleto antes de taking.', 0),
  (271, 77, 'did', 'Did expresa pasado, no plan futuro.', 0),
  (272, 79, 'I think we should start the project this week', 'Correcto: opinion + recomendacion en forma natural.', 1),
  (273, 79, 'project', 'Distractor: sustantivo suelto.', 0),
  (274, 79, 'start', 'Distractor: verbo suelto.', 0),
  (275, 79, 'because', 'Distractor: conector no solicitado.', 0),
  (276, 79, 'tomorrow', 'Distractor: adverbio suelto.', 0),
  (277, 80, 'He suggested keeping short reading tasks.', 'Correcto: esa fue la propuesta de Marco.', 1),
  (278, 80, 'He suggested canceling all homework.', 'No coincide con el texto.', 0),
  (279, 80, 'He suggested adding more math tests.', 'No coincide con el texto.', 0),
  (280, 80, 'He suggested starting classes later.', 'No coincide con el texto.', 0),
  (281, 81, 'should', 'Correcto: should + verbo base para recomendacion.', 1),
  (282, 81, 'must', 'Must suena obligacion fuerte, no recomendacion principal aqui.', 0),
  (283, 81, 'can', 'Can expresa posibilidad/capacidad, no consejo directo.', 0),
  (284, 81, 'had', 'Had no encaja con invest en este contexto.', 0),
  (285, 83, 'because', 'Correcto: explica la razon de la preferencia.', 1),
  (286, 83, 'so', 'So daria resultado, no causa en esta posicion.', 0),
  (287, 83, 'but', 'But indica contraste, no causa.', 0),
  (288, 83, 'or', 'Or indica alternativa, no razon.', 0),
  (289, 84, 'are', 'Correcto: We are meeting...', 1),
  (290, 84, 'is', 'Is no concuerda con we.', 0),
  (291, 84, 'be', 'Be no funciona sin auxiliar correcto.', 0),
  (292, 84, 'were', 'Were no encaja para plan futuro en presente continuo.', 0),
  (293, 86, 'I do not completely agree, but I understand your point', 'Correcto: desacuerdo respetuoso y claro.', 1),
  (294, 86, 'agree', 'Distractor: palabra suelta.', 0),
  (295, 86, 'point', 'Distractor: sustantivo suelto.', 0),
  (296, 86, 'because', 'Distractor: conector suelto.', 0),
  (297, 86, 'yesterday', 'Distractor: adverbio suelto.', 0),
  (298, 87, 'would', 'Correcto: If I were you, I would...', 1),
  (299, 87, 'should', 'Should no es la forma esperada tras If I were you en este patron.', 0),
  (300, 87, 'will', 'Will no se usa en esta estructura condicional.', 0),
  (301, 87, 'had', 'Had no encaja en esta construccion.', 0),
  (302, 89, 'They will design posters on Friday.', 'Correcto: es la primera accion del plan.', 1),
  (303, 89, 'They will clean the park.', 'Eso ocurre al final, no primero.', 0),
  (304, 89, 'They will share videos at school.', 'No coincide con el texto.', 0),
  (305, 89, 'They will visit a museum.', 'No coincide con el texto.', 0),
  (306, 90, 'are', 'Correcto: We are going to visit...', 1),
  (307, 90, 'is', 'Is no concuerda con we.', 0),
  (308, 90, 'be', 'Be solo no completa la estructura.', 0),
  (309, 90, 'were', 'Were no corresponde a este plan futuro.', 0),
  (310, 91, 'In my opinion, public transportation will be more efficient in the future', 'Correcto: opinion + prediccion en futuro.', 1),
  (311, 91, 'future', 'Distractor: palabra suelta.', 0),
  (312, 91, 'transportation', 'Distractor: sustantivo suelto.', 0),
  (313, 91, 'better', 'Distractor: adjetivo suelto.', 0),
  (314, 91, 'because', 'Distractor: conector suelto.', 0),
  (315, 92, 'I see your point, but I am not sure I agree.', 'Correcto: formula cortesa de desacuerdo.', 1),
  (316, 92, 'You are wrong. Stop talking.', 'Es agresivo, no respetuoso.', 0),
  (317, 92, 'That is nonsense.', 'Es descalificacion directa, no formula cortesa.', 0),
  (318, 92, 'I do not care about your idea.', 'No expresa intercambio respetuoso.', 0),
  (319, 93, 'should', 'Correcto: consejo academico en contexto de opinion.', 1),
  (320, 93, 'will', 'Will expresa futuro, no recomendacion.', 0),
  (321, 93, 'had', 'Had no encaja en esta estructura.', 0),
  (322, 93, 'are', 'Are no corresponde antes de support en esta idea.', 0),
  (323, 94, 'If we finish today, we will send the report tomorrow morning', 'Correcto: condicional real bien formado.', 1),
  (324, 94, 'if', 'Distractor: conector suelto.', 0),
  (325, 94, 'report', 'Distractor: sustantivo suelto.', 0),
  (326, 94, 'today', 'Distractor: adverbio suelto.', 0),
  (327, 94, 'morning', 'Distractor: palabra suelta.', 0),
  (328, 95, 'Because heavy rain was predicted.', 'Correcto: esa fue la causa del cambio.', 1),
  (329, 95, 'Because nobody was available on Saturday.', 'No aparece en el texto.', 0),
  (330, 95, 'Because they forgot to buy food.', 'No aparece en el texto.', 0),
  (331, 95, 'Because the park was closed for renovation.', 'No aparece en el texto.', 0),
  (332, 96, 'agreed', 'Correcto: pasado simple para decision final.', 1),
  (333, 96, 'agree', 'Forma base, no pasado.', 0),
  (334, 96, 'agreeing', 'Forma en -ing no corresponde.', 0),
  (335, 96, 'agrees', 'Presente tercera persona, no pasado.', 0),
  (336, 98, 'however', 'Correcto: conector formal de contraste.', 1),
  (337, 98, 'because', 'Because expresa causa, no contraste.', 0),
  (338, 98, 'so', 'So expresa consecuencia, no contraste.', 0),
  (339, 98, 'and', 'And solo agrega informacion.', 0),
  (340, 99, 'will', 'Correcto: futuro simple para proyeccion.', 1),
  (341, 99, 'opened', 'Pasado simple, no futuro.', 0),
  (342, 99, 'opens', 'Presente simple, no proyeccion futura aqui.', 0),
  (343, 99, 'is', 'Is no completa la estructura con open.', 0),
  (344, 100, 'Although the project is difficult, I am sure we can achieve it', 'Correcto: contraste + seguridad + posibilidad.', 1),
  (345, 100, 'although', 'Distractor: conector suelto.', 0),
  (346, 100, 'project', 'Distractor: sustantivo suelto.', 0),
  (347, 100, 'sure', 'Distractor: adjetivo suelto.', 0),
  (348, 100, 'yesterday', 'Distractor: adverbio suelto.', 0);

-- respuestas_intento_estudiante: sin registros

-- ==========================================================
-- Fin del script
-- ==========================================================
