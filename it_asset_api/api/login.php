<?php
require_once __DIR__ . '/../config/database.php';

// Login using email and password from JSON payload.
$input = getJsonInput();
$email = trim($input['email'] ?? '');
$plainPassword = $input['password'] ?? '';

// Validate basic credentials.
if ($email === '' || $plainPassword === '') {
    sendJson(false, 'Email and password are required', null, 422);
}

try {
    // Find user by email using a prepared statement.
    $stmt = $pdo->prepare('SELECT id, name, email, password, role, created_at FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($plainPassword, $user['password'])) {
        sendJson(false, 'Invalid email or password', null, 401);
    }

    // Remove password hash before sending user data to the app.
    unset($user['password']);
    $user['id'] = (int) $user['id'];

    sendJson(true, 'Login successful', $user);
} catch (PDOException $e) {
    sendJson(false, 'Login failed', $e->getMessage(), 500);
}
?>
