<?php
declare(strict_types=1);

class AuthModel
{
    private PDO $pdo;

    public function __construct(?PDO $pdo = null)
    {
        $this->pdo = $pdo ?? getDatabaseConnection();
    }

    public function registerStudent(array $payload): array
    {
        $firstName = trim((string) ($payload['first_name'] ?? ''));
        $lastName = trim((string) ($payload['last_name'] ?? ''));
        $gradeGroup = trim((string) ($payload['grade_group'] ?? ''));
        $email = strtolower(trim((string) ($payload['email'] ?? '')));
        $password = (string) ($payload['password'] ?? '');

        if ($firstName === '' || $lastName === '' || $gradeGroup === '' || $email === '' || $password === '') {
            return [
                'ok' => false,
                'message' => 'Todos los campos son obligatorios para crear la cuenta.',
            ];
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return [
                'ok' => false,
                'message' => 'El correo electronico no tiene un formato valido.',
            ];
        }

        if (strlen($password) < 8) {
            return [
                'ok' => false,
                'message' => 'La contrasena debe tener al menos 8 caracteres.',
            ];
        }

        $existsQuery = $this->pdo->prepare('SELECT estudiante_id FROM estudiantes WHERE correo = :email LIMIT 1');
        $existsQuery->execute(['email' => $email]);
        if ($existsQuery->fetch() !== false) {
            return [
                'ok' => false,
                'message' => 'Ya existe una cuenta con ese correo.',
            ];
        }

        $insertQuery = $this->pdo->prepare(
            'INSERT INTO estudiantes (nombres, apellidos, grupo_grado, correo, hash_contrasena)
             VALUES (:first_name, :last_name, :grade_group, :email, :password_hash)'
        );

        $insertQuery->execute([
            'first_name' => $firstName,
            'last_name' => $lastName,
            'grade_group' => $gradeGroup,
            'email' => $email,
            'password_hash' => password_hash($password, PASSWORD_DEFAULT),
        ]);

        $studentId = (int) $this->pdo->lastInsertId();

        return [
            'ok' => true,
            'student' => [
                'id' => $studentId,
                'name' => $firstName . ' ' . $lastName,
                'email' => $email,
                'grade_group' => $gradeGroup,
            ],
            'message' => 'Cuenta creada correctamente. Ya puedes iniciar tu aventura.',
        ];
    }

    public function loginStudent(string $email, string $password): ?array
    {
        $email = strtolower(trim($email));

        $query = $this->pdo->prepare(
            'SELECT
                estudiante_id AS student_id,
                nombres AS first_name,
                apellidos AS last_name,
                grupo_grado AS grade_group,
                correo AS email,
                hash_contrasena AS password_hash
             FROM estudiantes
             WHERE correo = :email
             LIMIT 1'
        );
        $query->execute(['email' => $email]);

        $student = $query->fetch();
        if (!is_array($student)) {
            return null;
        }

        $passwordHash = (string) ($student['password_hash'] ?? '');
        if ($passwordHash === '' || !password_verify($password, $passwordHash)) {
            return null;
        }

        return [
            'id' => (int) $student['student_id'],
            'name' => trim((string) $student['first_name'] . ' ' . (string) $student['last_name']),
            'email' => (string) $student['email'],
            'grade_group' => (string) $student['grade_group'],
            'role' => 'student',
        ];
    }

    public function loginTeacher(string $email, string $password): ?array
    {
        $email = strtolower(trim($email));

        $query = $this->pdo->prepare(
            'SELECT
                docente_id AS teacher_id,
                nombre_completo AS full_name,
                correo AS email,
                hash_contrasena AS password_hash
             FROM docentes
             WHERE correo = :email
             LIMIT 1'
        );
        $query->execute(['email' => $email]);

        $teacher = $query->fetch();
        if (!is_array($teacher)) {
            return null;
        }

        $passwordHash = (string) ($teacher['password_hash'] ?? '');
        if ($passwordHash === '' || !password_verify($password, $passwordHash)) {
            return null;
        }

        return [
            'id' => (int) $teacher['teacher_id'],
            'name' => (string) $teacher['full_name'],
            'email' => (string) $teacher['email'],
            'role' => 'teacher',
        ];
    }
}
