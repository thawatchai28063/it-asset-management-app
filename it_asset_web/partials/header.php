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
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            brand: {
              50: '#eef2ff',
              500: '#4f46e5',
              600: '#4338ca',
              700: '#3730a3'
            }
          }
        }
      }
    }
  </script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900 antialiased">
  <header class="sticky top-0 z-30 border-b border-slate-200 bg-white/95 shadow-sm backdrop-blur">
    <div class="mx-auto flex w-full max-w-7xl flex-col gap-3 px-4 py-3 sm:flex-row sm:items-center sm:justify-between">
    <a class="inline-flex items-center gap-3 text-lg font-extrabold text-slate-950" href="index.php">
      <span class="grid h-10 w-10 place-items-center rounded-xl bg-gradient-to-br from-indigo-600 to-teal-500 text-sm font-black text-white shadow-lg shadow-indigo-200">IT</span>
      <span>Asset Control</span>
    </a>
    <?php if ($user): ?>
      <nav class="flex flex-wrap items-center gap-2">
        <a class="rounded-lg px-3 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-100 hover:text-slate-950" href="index.php">Dashboard</a>
        <a class="rounded-lg px-3 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-100 hover:text-slate-950" href="assets.php">Assets</a>
        <a class="rounded-lg px-3 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-100 hover:text-slate-950" href="../it_asset_api/api/assets/index.php" target="_blank">API</a>
        <a class="rounded-lg bg-red-50 px-3 py-2 text-sm font-bold text-red-600 hover:bg-red-100" href="logout.php">Logout</a>
      </nav>
    <?php endif; ?>
    </div>
  </header>
  <main class="mx-auto w-full max-w-7xl px-4 py-6 sm:py-8">
    <?php if ($flash): ?>
      <?php $flashClass = $flash['type'] === 'error' ? 'border-red-200 bg-red-50 text-red-700' : 'border-emerald-200 bg-emerald-50 text-emerald-700'; ?>
      <div class="mb-4 rounded-xl border px-4 py-3 text-sm font-semibold <?= $flashClass ?>"><?= h($flash['message']) ?></div>
    <?php endif; ?>
