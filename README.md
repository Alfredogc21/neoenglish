# NeoEnglish

Aplicacion web educativa para el aprendizaje de ingles en grado 11. Diseñada para seguir la ruta A2-B1 del marco comun europeo de referencia linguistica.

Los estudiantes avanzan por niveles resolviendo preguntas de opcion multiple. El docente puede hacer seguimiento del progreso de cada estudiante.

---

## Tecnologias

| Tecnologia | Uso |
|---|---|
| **PHP 8+** | Lenguaje del servidor |
| **PDO / MySQL** | Conexion a base de datos |
| **Apache** | Servidor web (via XAMPP) |
| **HTML / CSS / JS** | Frontend sin frameworks |

---

## Estructura de carpetas

```
/inglescentral
|
+-- config/
|   +-- app.php         Configuracion general (nombre de la app, base path, URL base)
|   +-- database.php    Conexion PDO a MySQL (host, puerto, usuario, contrasena)
|   +-- helpers.php     Funciones reutilizables: renderizar vistas, escapar texto,
|                       generar URLs, manejar sesiones y autenticacion
|
+-- controllers/
|   +-- BaseController.php  Clase base con metodos comunes (autenticacion, abort)
|   +-- AuthController.php  Login y registro de estudiantes y docentes
|   +-- HomeController.php  Pagina de inicio
|   +-- LessonController.php  Vista de una leccion con preguntas
|   +-- TeacherController.php  Panel del docente
|
+-- models/
|   +-- AuthModel.php          Registro y login de usuarios
|   +-- LevelModel.php         Informacion de niveles y preguntas
|   +-- ProgressModel.php      Registro de intentos y respuestas
|   +-- TeacherDashboardModel.php  Estadisticas para el panel docente
|
+-- public/
|   +-- css/
|   |   +-- styles.css         Estilos de toda la aplicacion
|   +-- js/
|       +-- app.js            JavaScript del frontend (sin dependencias)
|
+-- views/
|   +-- auth/
|   |   +-- access.php        Formulario de login y registro
|   +-- errors/
|   |   +-- error.php         Pagina de error generica
|   +-- home/
|   |   +-- index.php         Pagina de inicio publica
|   +-- layout/
|   |   +-- header.php        Encabezado comun (topbar, navegacion)
|   |   +-- footer.php        Pie comun
|   +-- lesson/
|   |   +-- play.php          Vista de una leccion con preguntas
|   +-- teacher/
|       +-- dashboard.php     Panel de seguimiento del docente
|
+-- sql/
|   +-- database_export_*.sql  Export de la base de datos
|   +-- inglescentral_3fn.txt  Funciones/triggers de la DB (si existen)
|
+-- .htaccess       Reglas de reescritura para Apache (URLs limpias)
+-- index.php       Punto de entrada. Carga config, autoloader y enrutador
```

---

## Archivos clave

### `index.php`
Punto de entrada. Incluye config, autoloader de clases, inicia sesion y enruta la peticion al controlador correspondiente segun la URL.

### `config/app.php`
Define el nombre de la app y calcula la URL base automaticamente segun donde se ejecute.

### `config/database.php`
Parametros de conexion MySQL. Cambiar aqui si se mueve a otro servidor.

### `config/helpers.php`
Funciones disponibles en todo el proyecto:
- `render_view()` — assembla header + vista + footer
- `e()` — escapa texto para evitar XSS
- `route_url()` — genera URLs internas
- `asset_url()` — genera rutas a archivos publicos
- `redirect_to()` — redirige al navegador
- `current_user()` / `is_student_authenticated()` / `is_teacher_authenticated()` — checa sesion
- `set_flash()` / `pull_flash_messages()` — mensajes temporales entre peticiones

### `.htaccess`
Traduce URLs como `/nivel/3` a `index.php?route=nivel/3` para que todo pase por `index.php`.

### `public/css/styles.css`
Todos los estilos. Usa variables CSS, un diseno con cielo animado de fondo y colores oscuros con acentos en morado.

---

## Rutas

| URL | Descripcion |
|---|---|
| `/` | Inicio |
| `/acceso` | Login y registro |
| `/registro/estudiante` | Crea cuenta estudiante |
| `/login/estudiante` | Inicia sesion estudiante |
| `/login/docente` | Inicia sesion docente |
| `/nivel/1`, `/nivel/2`... | Jugar una leccion |
| `/docente/panel` | Panel del docente |
| `/salir` | Cerrar sesion |

---

## Base de datos

MySQL con estas tablas principales:

- `estudiantes` — usuarios de los estudiantes
- `docentes` — usuarios de los docentes
- `niveles` — niveles de leccion (titulo, descripcion, idioma)
- `preguntas` — preguntas de cada nivel
- `opciones_pregunta` — opciones de respuesta
- `intentos` — registro de cada vez que un estudiante juega un nivel
- `respuestas_intento` — respuesta elegida por el estudiante en cada pregunta