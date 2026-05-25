<?php
$pageTitle = $pageTitle ?? 'IT Asset Control';
$user = current_user();
$flash = flash();
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= h($pageTitle) ?></title>
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <header class="topbar">
    <a class="brand" href="index.php">
      <span class="brand-icon">IT</span>
      <span>Asset Control</span>
    </a>
    <?php if ($user): ?>
      <nav class="nav">
        <a href="index.php">Dashboard</a>
        <a href="assets.php">Assets</a>
        <a href="../it_asset_api/api/assets/index.php" target="_blank">API</a>
        <a class="danger-link" href="logout.php">Logout</a>
      </nav>
    <?php endif; ?>
  </header>
  <main class="shell">
    <?php if ($flash): ?>
      <div class="alert <?= h($flash['type']) ?>"><?= h($flash['message']) ?></div>
    <?php endif; ?>
