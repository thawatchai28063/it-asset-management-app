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
<section class="grid min-h-[calc(100vh-120px)] place-items-center">
  <div class="w-full max-w-md overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl shadow-slate-200/70">
    <div class="bg-gradient-to-br from-indigo-600 via-indigo-600 to-teal-500 px-7 py-8 text-white">
      <div class="mb-4 grid h-14 w-14 place-items-center rounded-2xl bg-white/15 text-lg font-black ring-1 ring-white/25">IT</div>
      <h1 class="text-2xl font-black">IT Asset Control</h1>
      <p class="mt-2 text-sm text-indigo-100">Sign in to manage assets, departments, and maintenance history.</p>
    </div>
    <div class="p-7">
      <?php if ($error): ?>
        <div class="mb-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700"><?= h($error) ?></div>
      <?php endif; ?>
      <form method="post" class="space-y-4">
        <div>
          <label class="mb-1.5 block text-sm font-bold text-slate-600">Email</label>
          <input class="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" type="email" name="email" value="<?= h($_POST['email'] ?? 'admin@example.com') ?>" required>
        </div>
        <div>
          <label class="mb-1.5 block text-sm font-bold text-slate-600">Password</label>
          <input class="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" type="password" name="password" value="password" required>
        </div>
        <button class="flex w-full items-center justify-center rounded-xl bg-indigo-600 px-4 py-3 font-extrabold text-white shadow-lg shadow-indigo-200 transition hover:bg-indigo-700" type="submit">Login</button>
      </form>
    </div>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
