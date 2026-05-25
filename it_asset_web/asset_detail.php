<?php
require_once __DIR__ . '/config/app.php';
require_login();

$id = (int) ($_GET['id'] ?? 0);
$stmt = db()->prepare('SELECT * FROM assets WHERE id = ? LIMIT 1');
$stmt->execute([$id]);
$asset = $stmt->fetch();

if (!$asset) {
    flash('Asset not found', 'error');
    redirect('assets.php');
}

$logStmt = db()->prepare('SELECT * FROM maintenance_logs WHERE asset_id = ? ORDER BY repair_date DESC, id DESC');
$logStmt->execute([$id]);
$logs = $logStmt->fetchAll();

$pageTitle = 'Asset Detail - IT Asset Control';
require __DIR__ . '/partials/header.php';
?>
<div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
  <div>
    <p class="text-sm font-bold uppercase tracking-wide text-indigo-600">Asset Detail</p>
    <h1 class="mt-1 text-3xl font-black text-slate-950"><?= h($asset['asset_name']) ?></h1>
    <div class="mt-3 flex flex-wrap gap-2">
      <span class="inline-flex rounded-full bg-indigo-50 px-3 py-1 text-xs font-black text-indigo-700 ring-1 ring-indigo-200"><?= h($asset['it_tag'] ?: $asset['serial_number']) ?></span>
      <span class="inline-flex rounded-full px-3 py-1 text-xs font-black ring-1 <?= asset_status_class($asset['status']) ?>"><?= h($asset['status']) ?></span>
    </div>
  </div>
  <div class="flex flex-wrap gap-2">
    <a class="rounded-xl bg-indigo-50 px-4 py-2.5 font-extrabold text-indigo-700 transition hover:bg-indigo-100" href="asset_form.php?id=<?= (int) $asset['id'] ?>">Edit</a>
    <a class="rounded-xl bg-indigo-600 px-4 py-2.5 font-extrabold text-white shadow-lg shadow-indigo-100 transition hover:bg-indigo-700" href="maintenance.php?asset_id=<?= (int) $asset['id'] ?>">Maintenance</a>
    <a class="rounded-xl bg-slate-100 px-4 py-2.5 font-extrabold text-slate-700 transition hover:bg-slate-200" href="assets.php">Back</a>
  </div>
</div>

<section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
  <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
    <?php
    $details = [
        'IT Tag' => $asset['it_tag'],
        'Asset Type' => $asset['asset_type'],
        'Serial Number' => $asset['serial_number'],
        'Department' => $asset['department'],
        'Status' => $asset['status'],
        'Assigned User' => $asset['assigned_user'],
        'Position' => $asset['position'],
        'Employee No.' => $asset['employee_no'],
        'Brand' => $asset['brand'],
        'Model' => $asset['model'],
        'OS / Version' => $asset['os_version'],
        'IP Address' => $asset['ip_address'],
        'Description' => $asset['description'],
        'Point / Image' => $asset['point_image'],
        'Purchase Date' => $asset['purchase_date'],
        'Note' => $asset['note'],
    ];
    foreach ($details as $label => $value):
    ?>
      <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
        <div class="mb-1 text-xs font-black uppercase tracking-wide text-slate-500"><?= h($label) ?></div>
        <div class="font-semibold text-slate-900"><?= nl2br(h($value ?: '-')) ?></div>
      </div>
    <?php endforeach; ?>
  </div>
</section>

<section class="mt-5 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
  <div class="flex flex-col gap-3 border-b border-slate-200 p-5 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <h2 class="text-xl font-black text-slate-950">Maintenance Logs</h2>
      <p class="text-sm text-slate-500">ประวัติการซ่อมของอุปกรณ์นี้</p>
    </div>
    <a class="rounded-xl bg-indigo-600 px-4 py-2.5 font-extrabold text-white shadow-lg shadow-indigo-100 transition hover:bg-indigo-700" href="maintenance.php?asset_id=<?= (int) $asset['id'] ?>">Add Log</a>
  </div>
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-slate-200">
      <thead class="bg-slate-50"><tr><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Date</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Problem</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Solution</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Repair By</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Status</th></tr></thead>
      <tbody class="divide-y divide-slate-100">
      <?php foreach ($logs as $log): ?>
        <tr class="hover:bg-slate-50">
          <td class="px-4 py-4"><?= h($log['repair_date']) ?></td>
          <td class="px-4 py-4"><?= h($log['problem']) ?></td>
          <td class="px-4 py-4"><?= h($log['solution']) ?></td>
          <td class="px-4 py-4"><?= h($log['repair_by']) ?></td>
          <td class="px-4 py-4"><span class="inline-flex rounded-full px-3 py-1 text-xs font-black ring-1 <?= maintenance_status_class($log['status']) ?>"><?= h($log['status']) ?></span></td>
        </tr>
      <?php endforeach; ?>
      <?php if (!$logs): ?>
        <tr><td class="px-4 py-10 text-center text-slate-500" colspan="5">No maintenance logs.</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
