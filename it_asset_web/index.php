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

$pageTitle = 'Dashboard - IT Asset Control';
require __DIR__ . '/partials/header.php';
?>
<div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
  <div>
    <p class="text-sm font-bold uppercase tracking-wide text-indigo-600">Dashboard</p>
    <h1 class="mt-1 text-3xl font-black text-slate-950">IT Asset Overview</h1>
    <p class="mt-2 text-slate-500">Same database as the PHP REST API and mobile app.</p>
  </div>
  <a class="inline-flex items-center justify-center rounded-xl bg-indigo-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-indigo-200 transition hover:bg-indigo-700" href="assets.php">View all assets</a>
</div>

<section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
  <?php
  $metrics = [
      ['Total assets', $total, 'assets.php', 'bg-indigo-600', 'All'],
      ['In use', $statusCounts['in_use'], 'assets.php?status=in_use', 'bg-blue-600', 'Active'],
      ['Available', $statusCounts['available'], 'assets.php?status=available', 'bg-emerald-600', 'Ready'],
      ['Repair', $statusCounts['repair'], 'assets.php?status=repair', 'bg-amber-500', 'Service'],
  ];
  foreach ($metrics as [$label, $value, $url, $color, $badge]):
  ?>
    <a class="group rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-xl" href="<?= h($url) ?>">
      <div class="flex items-start justify-between gap-4">
        <div>
          <div class="text-4xl font-black text-slate-950"><?= (int) $value ?></div>
          <div class="mt-1 text-sm font-bold text-slate-500"><?= h($label) ?></div>
        </div>
        <span class="rounded-full px-3 py-1 text-xs font-black text-white <?= h($color) ?>"><?= h($badge) ?></span>
      </div>
      <div class="mt-5 h-1.5 rounded-full bg-slate-100">
        <div class="h-1.5 w-2/3 rounded-full <?= h($color) ?>"></div>
      </div>
    </a>
  <?php endforeach; ?>
</section>

<section class="mt-6 grid gap-5 lg:grid-cols-2">
  <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
    <div class="mb-4 flex items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-black text-slate-950">Assets by Department</h2>
        <p class="text-sm text-slate-500">Click a department to filter the asset list.</p>
      </div>
    </div>
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-slate-200">
        <thead>
          <tr>
            <th class="px-3 py-3 text-left text-xs font-black uppercase text-slate-500">Department</th>
            <th class="px-3 py-3 text-right text-xs font-black uppercase text-slate-500">Total</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-100">
        <?php foreach ($departmentRows as $row): ?>
          <tr class="hover:bg-slate-50">
            <td class="px-3 py-3">
              <a class="font-bold text-indigo-600 hover:text-indigo-800" href="assets.php?department=<?= urlencode($row['department']) ?>"><?= h($row['department']) ?></a>
            </td>
            <td class="px-3 py-3 text-right font-black text-slate-900"><?= (int) $row['total'] ?></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>

  <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
    <div class="mb-4 flex items-center justify-between gap-4">
      <div>
        <h2 class="text-xl font-black text-slate-950">Assets by Type</h2>
        <p class="text-sm text-slate-500">Click a type to filter the asset list.</p>
      </div>
    </div>
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-slate-200">
        <thead>
          <tr>
            <th class="px-3 py-3 text-left text-xs font-black uppercase text-slate-500">Type</th>
            <th class="px-3 py-3 text-right text-xs font-black uppercase text-slate-500">Total</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-100">
        <?php foreach ($typeRows as $row): ?>
          <tr class="hover:bg-slate-50">
            <td class="px-3 py-3">
              <a class="font-bold text-indigo-600 hover:text-indigo-800" href="assets.php?asset_type=<?= urlencode($row['asset_type']) ?>"><?= h($row['asset_type']) ?></a>
            </td>
            <td class="px-3 py-3 text-right font-black text-slate-900"><?= (int) $row['total'] ?></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
