<?php
require_once __DIR__ . '/config/app.php';
require_login();

$total = (int) db()->query('SELECT COUNT(*) FROM assets')->fetchColumn();
$statusRows = db()->query('SELECT status, COUNT(*) total FROM assets GROUP BY status')->fetchAll();
$typeRows = db()->query('SELECT asset_type, COUNT(*) total FROM assets GROUP BY asset_type ORDER BY total DESC, asset_type')->fetchAll();
$departmentRows = db()->query('SELECT department, COUNT(*) total FROM assets GROUP BY department ORDER BY total DESC, department')->fetchAll();

$statusCounts = ['available' => 0, 'in_use' => 0, 'repair' => 0, 'retired' => 0];
foreach ($statusRows as $row) {
    $statusCounts[$row['status']] = (int) $row['total'];
}

$typeStyles = [
    ['bg-indigo-300', 'bg-indigo-50 text-indigo-700 ring-indigo-100', 'border-indigo-100', 'bg-indigo-200'],
    ['bg-emerald-300', 'bg-emerald-50 text-emerald-700 ring-emerald-100', 'border-emerald-100', 'bg-emerald-200'],
    ['bg-amber-300', 'bg-amber-50 text-amber-700 ring-amber-100', 'border-amber-100', 'bg-amber-200'],
    ['bg-rose-300', 'bg-rose-50 text-rose-700 ring-rose-100', 'border-rose-100', 'bg-rose-200'],
    ['bg-sky-300', 'bg-sky-50 text-sky-700 ring-sky-100', 'border-sky-100', 'bg-sky-200'],
    ['bg-violet-300', 'bg-violet-50 text-violet-700 ring-violet-100', 'border-violet-100', 'bg-violet-200'],
];

$pageTitle = 'Dashboard - IT Asset Control';
require __DIR__ . '/partials/header.php';
?>
<div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
  <div>
    <p class="text-sm font-bold uppercase tracking-wide text-indigo-600">Dashboard</p>
    <h1 class="mt-1 text-3xl font-black text-slate-950">IT Asset Overview</h1>
    <p class="mt-2 text-slate-500">Same database as the PHP REST API and mobile app.</p>
  </div>
  <div class="flex flex-wrap gap-2">
    <a class="inline-flex items-center justify-center rounded-xl bg-emerald-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-emerald-200 transition hover:bg-emerald-700" href="assets_export.php">Export Excel</a>
    <a class="inline-flex items-center justify-center rounded-xl bg-indigo-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-indigo-200 transition hover:bg-indigo-700" href="assets.php">View all assets</a>
  </div>
</div>

<section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
  <?php
  $metrics = [
      ['Total assets', $total, 'assets.php', 'All', 'bg-indigo-50', 'border-indigo-100', 'text-indigo-700', 'bg-indigo-200'],
      ['In use', $statusCounts['in_use'], 'assets.php?status=in_use', 'Active', 'bg-sky-50', 'border-sky-100', 'text-sky-700', 'bg-sky-200'],
      ['Available', $statusCounts['available'], 'assets.php?status=available', 'Ready', 'bg-emerald-50', 'border-emerald-100', 'text-emerald-700', 'bg-emerald-200'],
      ['Repair', $statusCounts['repair'], 'assets.php?status=repair', 'Service', 'bg-amber-50', 'border-amber-100', 'text-amber-700', 'bg-amber-200'],
  ];
  foreach ($metrics as [$label, $value, $url, $badge, $bg, $border, $text, $accent]):
  ?>
    <a class="group overflow-hidden rounded-2xl border <?= h($border) ?> <?= h($bg) ?> p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg" href="<?= h($url) ?>">
      <div class="flex items-start justify-between gap-4">
        <div>
          <div class="text-4xl font-black text-slate-950"><?= (int) $value ?></div>
          <div class="mt-1 text-sm font-bold text-slate-500"><?= h($label) ?></div>
        </div>
        <span class="rounded-full bg-white px-3 py-1 text-xs font-black <?= h($text) ?> ring-1 <?= h($border) ?>"><?= h($badge) ?></span>
      </div>
      <div class="mt-5 h-1.5 rounded-full bg-white">
        <div class="h-1.5 w-2/3 rounded-full <?= h($accent) ?>"></div>
      </div>
    </a>
  <?php endforeach; ?>
</section>

<section class="mt-6 grid gap-5 lg:grid-cols-2">
  <div class="overflow-hidden rounded-2xl border border-indigo-100 bg-white shadow-sm">
    <div class="h-2 bg-indigo-200"></div>
    <div class="p-5">
    <div class="mb-4 flex items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-black text-slate-950">Assets by Department</h2>
        <p class="text-sm text-slate-500">Click a department to filter the asset list.</p>
      </div>
    </div>
    <div class="overflow-x-auto">
      <table class="min-w-full border-separate border-spacing-y-2">
        <thead>
          <tr class="bg-indigo-50">
            <th class="rounded-l-xl px-4 py-3 text-left text-xs font-black uppercase tracking-wide text-indigo-700 ring-1 ring-inset ring-indigo-100">Department</th>
            <th class="rounded-r-xl px-4 py-3 text-right text-xs font-black uppercase tracking-wide text-indigo-700 ring-1 ring-inset ring-indigo-100">Total</th>
          </tr>
        </thead>
        <tbody>
        <?php foreach ($departmentRows as $row): ?>
          <tr class="group">
            <td class="rounded-l-xl border border-r-0 border-slate-100 bg-slate-50 px-4 py-3 transition group-hover:border-indigo-100 group-hover:bg-indigo-50">
              <a class="font-bold text-slate-700 transition hover:text-indigo-800" href="assets.php?department=<?= urlencode($row['department']) ?>"><?= h($row['department']) ?></a>
            </td>
            <td class="rounded-r-xl border border-l-0 border-slate-100 bg-slate-50 px-4 py-3 text-right transition group-hover:border-indigo-100 group-hover:bg-indigo-50">
              <span class="rounded-full bg-indigo-50 px-3 py-1 text-sm font-black text-indigo-700 ring-1 ring-indigo-100"><?= (int) $row['total'] ?></span>
            </td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>
    </div>
  </div>

  <div class="overflow-hidden rounded-2xl border border-emerald-100 bg-white shadow-sm">
    <div class="h-2 bg-emerald-200"></div>
    <div class="p-5">
    <div class="mb-4 flex items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-black text-slate-950">Assets by Type</h2>
        <p class="text-sm text-slate-500">Click a type to filter the asset list.</p>
      </div>
    </div>
    <div class="grid gap-3 sm:grid-cols-2">
      <?php foreach ($typeRows as $index => $row): ?>
        <?php $style = $typeStyles[$index % count($typeStyles)]; ?>
        <a class="group overflow-hidden rounded-2xl border <?= h($style[2]) ?> bg-white shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg" href="assets.php?asset_type=<?= urlencode((string) $row['asset_type']) ?>">
          <div class="h-1.5 <?= h($style[0]) ?>"></div>
          <div class="p-4">
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <p class="truncate text-sm font-black text-slate-900"><?= h($row['asset_type'] ?: 'Unknown') ?></p>
                <p class="mt-1 text-xs font-semibold text-slate-500">Asset type</p>
              </div>
              <span class="shrink-0 rounded-full px-3 py-1 text-sm font-black ring-1 <?= h($style[1]) ?>"><?= (int) $row['total'] ?></span>
            </div>
            <div class="mt-4 h-2 rounded-full bg-slate-100">
              <div class="h-2 rounded-full <?= h($style[3]) ?>" style="width: <?= $total > 0 ? max(8, min(100, ((int) $row['total'] / $total) * 100)) : 0 ?>%;"></div>
            </div>
          </div>
        </a>
      <?php endforeach; ?>
    </div>
    </div>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
