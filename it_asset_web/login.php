<?php
require_once __DIR__ . '/config/app.php';

if (current_user()) {
    redirect('index.php');
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    $stmt = db()->prepare('SELECT id, name, email, password, role FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {
        unset($user['password']);
        $_SESSION['user'] = $user;
        redirect('index.php');
    }

    $error = 'Invalid email or password';
}

$pageTitle = 'Login - IT Asset Control';
require __DIR__ . '/partials/header.php';
?>
<section class="login-page">
  <div class="card login-card">
    <div class="page-head">
      <div>
        <h1>Login</h1>
        <p>Sign in to manage IT assets.</p>
      </div>
    </div>
    <?php if ($error): ?>
      <div class="alert error"><?= h($error) ?></div>
    <?php endif; ?>
    <form method="post" class="form-grid">
      <div class="field full">
        <label>Email</label>
        <input type="email" name="email" value="<?= h($_POST['email'] ?? 'admin@example.com') ?>" required>
      </div>
      <div class="field full">
        <label>Password</label>
        <input type="password" name="password" value="password" required>
      </div>
      <div class="field full">
        <button type="submit">Login</button>
      </div>
    </form>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
