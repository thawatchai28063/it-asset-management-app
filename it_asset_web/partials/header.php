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
  <header class="sticky top-0 z-30 border-b border-slate-200 bg-white/90 shadow-sm backdrop-blur-xl">
    <div class="mx-auto w-full max-w-7xl px-3 py-2 sm:px-4 sm:py-3">
      <div class="flex flex-col gap-2 rounded-xl border border-slate-200 bg-slate-50/80 px-2.5 py-2.5 shadow-sm sm:flex-row sm:items-center sm:justify-between sm:gap-3 sm:rounded-2xl sm:px-3 sm:py-3">
    <a class="group inline-flex items-center gap-2.5 text-base font-extrabold text-slate-950 sm:gap-3 sm:text-lg" href="index.php">
      <span class="grid h-10 w-10 place-items-center rounded-xl bg-indigo-50 text-sm font-black text-indigo-700 ring-1 ring-indigo-100 transition group-hover:bg-indigo-100 sm:h-11 sm:w-11 sm:rounded-2xl">IT</span>
      <span class="leading-tight">
        <span class="block">Asset Control</span>
        <span class="block text-[11px] font-bold uppercase tracking-wide text-slate-400 sm:text-xs">IT Inventory</span>
      </span>
    </a>
    <?php if ($user): ?>
      <nav class="-mx-0.5 flex max-w-full flex-nowrap items-center gap-2 overflow-x-auto px-0.5 pb-1 sm:mx-0 sm:flex-wrap sm:overflow-visible sm:px-0 sm:pb-0">
        <a class="inline-flex shrink-0 items-center gap-1.5 rounded-xl bg-white px-2.5 py-2 text-xs font-bold text-slate-600 ring-1 ring-slate-200 transition hover:bg-indigo-50 hover:text-indigo-700 hover:ring-indigo-100 sm:gap-2 sm:px-3 sm:text-sm" href="index.php">
          <span class="grid h-5 w-5 place-items-center rounded-lg bg-indigo-50 text-[10px] text-indigo-600 sm:h-6 sm:w-6 sm:text-xs">D</span>
          Dashboard
        </a>
        <a class="inline-flex shrink-0 items-center gap-1.5 rounded-xl bg-white px-2.5 py-2 text-xs font-bold text-slate-600 ring-1 ring-slate-200 transition hover:bg-sky-50 hover:text-sky-700 hover:ring-sky-100 sm:gap-2 sm:px-3 sm:text-sm" href="assets.php">
          <span class="grid h-5 w-5 place-items-center rounded-lg bg-sky-50 text-[10px] text-sky-600 sm:h-6 sm:w-6 sm:text-xs">A</span>
          Assets
        </a>
        <a class="inline-flex shrink-0 items-center gap-1.5 rounded-xl bg-emerald-50 px-2.5 py-2 text-xs font-bold text-emerald-700 ring-1 ring-emerald-100 transition hover:bg-emerald-100 sm:gap-2 sm:px-3 sm:text-sm" href="assets_export.php">
          <span class="grid h-5 w-5 place-items-center rounded-lg bg-white text-[10px] text-emerald-600 sm:h-6 sm:w-6 sm:text-xs">X</span>
          Export Excel
        </a>
        <a class="inline-flex shrink-0 items-center gap-1.5 rounded-xl bg-white px-2.5 py-2 text-xs font-bold text-slate-600 ring-1 ring-slate-200 transition hover:bg-violet-50 hover:text-violet-700 hover:ring-violet-100 sm:gap-2 sm:px-3 sm:text-sm" href="../it_asset_api/api/assets/index.php" target="_blank">
          <span class="grid h-5 w-5 place-items-center rounded-lg bg-violet-50 text-[10px] text-violet-600 sm:h-6 sm:w-6 sm:text-xs">API</span>
          API
        </a>
        <a class="inline-flex shrink-0 items-center gap-1.5 rounded-xl bg-red-50 px-2.5 py-2 text-xs font-bold text-red-600 ring-1 ring-red-100 transition hover:bg-red-100 sm:gap-2 sm:px-3 sm:text-sm" href="logout.php">
          <span class="grid h-5 w-5 place-items-center rounded-lg bg-white text-[10px] text-red-500 sm:h-6 sm:w-6 sm:text-xs">!</span>
          Logout
        </a>
      </nav>
    <?php endif; ?>
      </div>
    </div>
  </header>
  <main class="mx-auto w-full max-w-7xl px-4 py-6 sm:py-8">
    <?php if ($flash): ?>
      <?php $flashClass = $flash['type'] === 'error' ? 'border-red-200 bg-red-50 text-red-700' : 'border-emerald-200 bg-emerald-50 text-emerald-700'; ?>
      <div class="mb-4 rounded-xl border px-4 py-3 text-sm font-semibold <?= $flashClass ?>"><?= h($flash['message']) ?></div>
    <?php endif; ?>
