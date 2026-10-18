<?php
declare(strict_types=1);

/**
 * To-Do Task REST API, Stage 1 (raw PHP + MySQL via PDO, served through NGINX).
 * Routing and response style adapted from ase230 module1/code/6_RestAPI/api/index.php.
 *
 *  Public:     POST /api/register, POST /api/login,
 *              GET  /api/categories, /api/categories/{id}, /api/categories/{id}/tasks,
 *              GET  /api/tasks, /api/tasks/{id}
 *  Protected:  POST /api/tasks, PUT /api/tasks/{id}, DELETE /api/tasks/{id}   (Bearer token)
 */

require_once __DIR__ . '/database.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// ---------------------------------------------------------------- helpers

function respond(int $status, array $body): void
{
    http_response_code($status);
    echo json_encode($body, JSON_UNESCAPED_SLASHES);
    exit;
}

function fail(int $status, string $message): void
{
    respond($status, ['success' => false, 'error' => $message]);
}

/** Decode the JSON request body. Empty body => []. Malformed or non-object JSON => 400. */
function json_body(): array
{
    $raw = file_get_contents('php://input');
    if ($raw === false || trim($raw) === '') {
        return [];
    }
    $data = json_decode($raw, true);
    if (json_last_error() !== JSON_ERROR_NONE || !is_array($data) || ($data !== [] && array_is_list($data))) {
        fail(400, 'Request body must be a valid JSON object');
    }
    return $data;
}

function bearer_token(): ?string
{
    $header = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '';
    if (preg_match('/^Bearer\s+(\S+)$/i', trim($header), $m)) {
        return $m[1];
    }
    return null;
}

/** Returns the authenticated user row, or ends the request with 401. */
function require_user(): array
{
    $token = bearer_token();
    if ($token === null) {
        fail(401, 'Missing bearer token');
    }
    $stmt = db()->prepare(
        'SELECT u.id, u.name, u.email FROM api_tokens t JOIN users u ON u.id = t.user_id WHERE t.token_hash = :h'
    );
    $stmt->execute([':h' => hash('sha256', $token)]);
    $user = $stmt->fetch();
    if (!$user) {
        fail(401, 'Invalid token');
    }
    return $user;
}

function parse_id(string $segment): int
{
    if (!ctype_digit($segment)) {
        fail(400, 'Invalid id');
    }
    return (int)$segment;
}

function format_task(array $row): array
{
    $row['done'] = (bool)$row['done'];
    return $row;
}

const TASK_COLUMNS = 'id, title, done, category_id, user_id, created_at, updated_at';

function find_task(int $id): ?array
{
    $stmt = db()->prepare('SELECT ' . TASK_COLUMNS . ' FROM tasks WHERE id = :id');
    $stmt->execute([':id' => $id]);
    $row = $stmt->fetch();
    return $row ? format_task($row) : null;
}

function category_exists(int $id): bool
{
    $stmt = db()->prepare('SELECT 1 FROM categories WHERE id = :id');
    $stmt->execute([':id' => $id]);
    return (bool)$stmt->fetchColumn();
}

/** Validate task fields. $requireAll=true for PUT (full replace). Returns an error string or null. */
function validate_task(array $in, bool $requireAll): ?string
{
    $required = $requireAll ? ['title', 'category_id', 'done'] : ['title', 'category_id'];
    foreach ($required as $field) {
        if (!array_key_exists($field, $in)) {
            return "{$field} is required";
        }
    }
    if (!is_string($in['title']) || trim($in['title']) === '' || mb_strlen($in['title']) > 200) {
        return 'title must be a non-empty string of at most 200 characters';
    }
    if (!is_int($in['category_id']) || $in['category_id'] < 1) {
        return 'category_id must be a positive integer';
    }
    if (array_key_exists('done', $in) && !is_bool($in['done'])) {
        return 'done must be true or false';
    }
    if (!category_exists($in['category_id'])) {
        return 'category_id does not exist';
    }
    return null;
}

// ---------------------------------------------------------------- handlers

function register(): void
{
    $in = json_body();
    foreach (['name', 'email', 'password'] as $field) {
        if (!array_key_exists($field, $in)) {
            fail(400, "{$field} is required");
        }
    }
    if (!is_string($in['name']) || trim($in['name']) === '' || mb_strlen($in['name']) > 100) {
        fail(400, 'name must be a non-empty string of at most 100 characters');
    }
    if (!is_string($in['email']) || !filter_var($in['email'], FILTER_VALIDATE_EMAIL)) {
        fail(400, 'email is not a valid email address');
    }
    if (!is_string($in['password']) || strlen($in['password']) < 6) {
        fail(400, 'password must be at least 6 characters');
    }

    $email = strtolower(trim($in['email']));
    $check = db()->prepare('SELECT 1 FROM users WHERE email = :e');
    $check->execute([':e' => $email]);
    if ($check->fetchColumn()) {
        fail(409, 'Email is already registered');
    }

    $stmt = db()->prepare('INSERT INTO users (name, email, password_hash) VALUES (:n, :e, :p)');
    $stmt->execute([
        ':n' => trim($in['name']),
        ':e' => $email,
        ':p' => password_hash($in['password'], PASSWORD_BCRYPT),
    ]);

    respond(201, [
        'success' => true,
        'message' => 'User registered',
        'data' => ['id' => (int)db()->lastInsertId(), 'name' => trim($in['name']), 'email' => $email],
    ]);
}

function login(): void
{
    $in = json_body();
    if (!isset($in['email'], $in['password']) || !is_string($in['email']) || !is_string($in['password'])) {
        fail(400, 'email and password are required');
    }

    $stmt = db()->prepare('SELECT id, name, email, password_hash FROM users WHERE email = :e');
    $stmt->execute([':e' => strtolower(trim($in['email']))]);
    $user = $stmt->fetch();
    if (!$user || !password_verify($in['password'], $user['password_hash'])) {
        fail(401, 'Invalid credentials');
    }

    $token = bin2hex(random_bytes(32));
    db()->prepare('INSERT INTO api_tokens (user_id, token_hash) VALUES (:u, :h)')
        ->execute([':u' => $user['id'], ':h' => hash('sha256', $token)]);

    respond(200, [
        'success' => true,
        'token' => $token,
        'data' => ['id' => (int)$user['id'], 'name' => $user['name'], 'email' => $user['email']],
    ]);
}

function list_categories(): void
{
    $rows = db()->query('SELECT id, name, created_at FROM categories ORDER BY id')->fetchAll();
    respond(200, ['success' => true, 'data' => $rows, 'count' => count($rows)]);
}

function get_category(int $id): void
{
    $stmt = db()->prepare('SELECT id, name, created_at FROM categories WHERE id = :id');
    $stmt->execute([':id' => $id]);
    $row = $stmt->fetch();
    if (!$row) {
        fail(404, 'Category not found');
    }
    respond(200, ['success' => true, 'data' => $row]);
}

function list_category_tasks(int $id): void
{
    if (!category_exists($id)) {
        fail(404, 'Category not found');
    }
    $stmt = db()->prepare('SELECT ' . TASK_COLUMNS . ' FROM tasks WHERE category_id = :id ORDER BY id');
    $stmt->execute([':id' => $id]);
    $rows = array_map('format_task', $stmt->fetchAll());
    respond(200, ['success' => true, 'data' => $rows, 'count' => count($rows)]);
}

function list_tasks(): void
{
    $rows = array_map('format_task', db()->query('SELECT ' . TASK_COLUMNS . ' FROM tasks ORDER BY id')->fetchAll());
    respond(200, ['success' => true, 'data' => $rows, 'count' => count($rows)]);
}

function get_task(int $id): void
{
    $task = find_task($id);
    if ($task === null) {
        fail(404, 'Task not found');
    }
    respond(200, ['success' => true, 'data' => $task]);
}

function create_task(array $user): void
{
    $in = json_body();
    $error = validate_task($in, false);
    if ($error !== null) {
        fail(400, $error);
    }
    $stmt = db()->prepare(
        'INSERT INTO tasks (title, done, category_id, user_id) VALUES (:t, :d, :c, :u)'
    );
    $stmt->execute([
        ':t' => trim($in['title']),
        ':d' => !empty($in['done']) ? 1 : 0,
        ':c' => $in['category_id'],
        ':u' => $user['id'],
    ]);
    respond(201, [
        'success' => true,
        'message' => 'Task created',
        'data' => find_task((int)db()->lastInsertId()),
    ]);
}

function update_task(int $id): void
{
    $in = json_body();
    $error = validate_task($in, true);
    if ($error !== null) {
        fail(400, $error);
    }
    if (find_task($id) === null) {
        fail(404, 'Task not found');
    }
    db()->prepare('UPDATE tasks SET title = :t, done = :d, category_id = :c WHERE id = :id')
        ->execute([
            ':t' => trim($in['title']),
            ':d' => $in['done'] ? 1 : 0,
            ':c' => $in['category_id'],
            ':id' => $id,
        ]);
    respond(200, ['success' => true, 'message' => 'Task updated', 'data' => find_task($id)]);
}

function delete_task(int $id): void
{
    $task = find_task($id);
    if ($task === null) {
        fail(404, 'Task not found');
    }
    db()->prepare('DELETE FROM tasks WHERE id = :id')->execute([':id' => $id]);
    respond(200, ['success' => true, 'message' => 'Task deleted', 'data' => $task]);
}

// ---------------------------------------------------------------- routing

$method = $_SERVER['REQUEST_METHOD'];
$path = trim((string)parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
$segments = $path === '' ? [] : explode('/', $path);

if (($segments[0] ?? '') !== 'api') {
    fail(404, 'Resource not found');
}
array_shift($segments);               // drop "api"
$resource = $segments[0] ?? '';
$idSeg = $segments[1] ?? null;
$sub = $segments[2] ?? null;

function require_method(array $allowed, string $method): void
{
    if (!in_array($method, $allowed, true)) {
        header('Allow: ' . implode(', ', $allowed));
        fail(405, 'Method not allowed');
    }
}

try {
    switch (true) {
        case $resource === '' && count($segments) === 0:
            require_method(['GET'], $method);
            respond(200, [
                'success' => true,
                'message' => 'To-Do Task API (Stage 1: PHP + MySQL)',
                'endpoints' => [
                    'POST /api/register', 'POST /api/login',
                    'GET /api/categories', 'GET /api/categories/{id}', 'GET /api/categories/{id}/tasks',
                    'GET /api/tasks', 'GET /api/tasks/{id}',
                    'POST /api/tasks (bearer)', 'PUT /api/tasks/{id} (bearer)', 'DELETE /api/tasks/{id} (bearer)',
                ],
            ]);
            break;

        case $resource === 'register' && count($segments) === 1:
            require_method(['POST'], $method);
            register();
            break;

        case $resource === 'login' && count($segments) === 1:
            require_method(['POST'], $method);
            login();
            break;

        case $resource === 'categories' && count($segments) === 1:
            require_method(['GET'], $method);
            list_categories();
            break;

        case $resource === 'categories' && count($segments) === 2:
            require_method(['GET'], $method);
            get_category(parse_id($idSeg));
            break;

        case $resource === 'categories' && count($segments) === 3 && $sub === 'tasks':
            require_method(['GET'], $method);
            list_category_tasks(parse_id($idSeg));
            break;

        case $resource === 'tasks' && count($segments) === 1:
            require_method(['GET', 'POST'], $method);
            if ($method === 'POST') {
                create_task(require_user());     // auth is checked before the body is read
            }
            list_tasks();
            break;

        case $resource === 'tasks' && count($segments) === 2:
            require_method(['GET', 'PUT', 'DELETE'], $method);
            if ($method === 'GET') {
                get_task(parse_id($idSeg));
            }
            require_user();                      // PUT and DELETE are protected
            $id = parse_id($idSeg);
            $method === 'PUT' ? update_task($id) : delete_task($id);
            break;

        default:
            fail(404, 'Resource not found');
    }
} catch (PDOException $e) {
    error_log('DB error: ' . $e->getMessage());
    fail(500, 'Database error');
}
