<?php
require_once __DIR__ . '/../config/database.php';

// Register a new user from JSON payload.
$input = getJsonInput();
$name = trim($input['name'] ?? '');
$email = trim($input['email'] ?? '');
$plainPassword = $input['password'] ?? '';
$role = $input['role'] ?? 'staff';

// Validate required fields before inserting.
if ($name === '' || $email === '' || $plainPassword === '') {
    sendJson(false, 'Name, email, and password are required', null, 422);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendJson(false, 'Invalid email format', null, 422);
}

if (!in_array($role, ['admin', 'staff'], true)) {
    $role = 'staff';
}

try {
    // Check duplicate email with a prepared statement.
    $check = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $check->execute([$email]);

    if ($check->fetch()) {
        sendJson(false, 'Email already exists', null, 409);
    }

    // Hash password before storing it.
    $passwordHash = password_hash($plainPassword, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)');
    $stmt->execute([$name, $email, $passwordHash, $role]);

    sendJson(true, 'Register successful', [
        'id' => (int) $pdo->lastInsertId(),
        'name' => $name,
        'email' => $email,
        'role' => $role,
    ], 201);
} catch (PDOException $e) {
    sendJson(false, 'Register failed', $e->getMessage(), 500);
}
?>
