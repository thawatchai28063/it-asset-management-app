<?php
require_once __DIR__ . '/config/app.php';
require_login();

$assetId = (int) ($_GET['asset_id'] ?? $_POST['asset_id'] ?? 0);
$stmt = db()->prepare('SELECT * FROM assets WHERE id = ? LIMIT 1');
$stmt->execute([$assetId]);
$asset = $stmt->fetch();

if (!$asset) {
    flash('Asset not found', 'error');
    redirect('assets.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? 'create';
    if ($action === 'delete') {
        $id = (int) ($_POST['id'] ?? 0);
        $stmt = db()->prepare('DELETE FROM maintenance_logs WHERE id = ? AND asset_id = ?');
        $stmt->execute([$id, $assetId]);
        flash('Maintenance log deleted');
        redirect("maintenance.php?asset_id={$assetId}");
    }

    $problem = trim($_POST['problem'] ?? '');
    $repairBy = trim($_POST['repair_by'] ?? '');
    $repairDate = trim($_POST['repair_date'] ?? '');
    $status = trim($_POST['status'] ?? 'pending');
    $solution = null_if_empty($_POST['solution'] ?? '');

    if ($problem !== '' && $repairBy !== '' && $repairDate !== '') {
        $stmt = db()->prepare(
            'INSERT INTO maintenance_logs (asset_id, problem, solution, repair_by, repair_date, status)
             VALUES (?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([$assetId, $problem, $solution, $repairBy, $repairDate, $status]);
        flash('Maintenance log added');
        redirect("maintenance.php?asset_id={$assetId}");
    }

    flash('Problem, repair by, and repair date are required', 'error');
    redirect("maintenance.php?asset_id={$assetId}");
}

$logStmt = db()->prepare('SELECT * FROM maintenance_logs WHERE asset_id = ? ORDER BY repair_date DESC, id DESC');
$logStmt->execute([$assetId]);
$logs = $logStmt->fetchAll();

$pageTitle = 'Maintenance - IT Asset Control';
require __DIR__ . '/partials/header.php';
$inputClass = 'w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100';
?>
<div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
  <div>
    <p class="text-sm font-bold uppercase tracking-wide text-indigo-600">Maintenance</p>
    <h1 class="mt-1 text-3xl font-black text-slate-950"><?= h($asset['asset_name']) ?></h1>
    <p class="mt-2 text-slate-500"><?= h($asset['it_tag'] ?: $asset['serial_number']) ?></p>
  </div>
  <a class="rounded-xl bg-slate-100 px-5 py-3 font-extrabold text-slate-700 transition hover:bg-slate-200" href="asset_detail.php?id=<?= (int) $assetId ?>">Back</a>
</div>

<form method="post" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
  <input type="hidden" name="asset_id" value="<?= (int) $assetId ?>">
  <div class="grid gap-4 lg:grid-cols-2">
    <div class="lg:col-span-2">
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Problem</label>
      <textarea class="min-h-28 <?= $inputClass ?>" name="problem" required></textarea>
    </div>
    <div class="lg:col-span-2">
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Solution</label>
      <textarea class="min-h-28 <?= $inputClass ?>" name="solution"></textarea>
    </div>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Repair By</label>
      <input class="<?= $inputClass ?>" name="repair_by" required>
    </div>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Repair Date</label>
      <input class="<?= $inputClass ?>" type="date" name="repair_date" value="<?= date('Y-m-d') ?>" required>
    </div>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Status</label>
      <select class="<?= $inputClass ?>" name="status">
        <?php foreach (['pending', 'in_progress', 'completed'] as $value): ?>
          <option value="<?= $value ?>"><?= $value ?></option>
        <?php endforeach; ?>
      </select>
    </div>
  </div>
  <div class="mt-5">
    <button class="rounded-xl bg-indigo-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-indigo-100 transition hover:bg-indigo-700" type="submit">Add Log</button>
  </div>
</form>

<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-slate-200">
      <thead class="bg-slate-50"><tr><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Date</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Problem</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Solution</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Repair By</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Status</th><th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Actions</th></tr></thead>
      <tbody class="divide-y divide-slate-100">
      <?php foreach ($logs as $log): ?>
        <tr class="hover:bg-slate-50">
          <td class="px-4 py-4"><?= h($log['repair_date']) ?></td>
          <td class="px-4 py-4"><?= h($log['problem']) ?></td>
          <td class="px-4 py-4"><?= h($log['solution']) ?></td>
          <td class="px-4 py-4"><?= h($log['repair_by']) ?></td>
          <td class="px-4 py-4"><span class="inline-flex rounded-full px-3 py-1 text-xs font-black ring-1 <?= maintenance_status_class($log['status']) ?>"><?= h($log['status']) ?></span></td>
          <td class="px-4 py-4">
            <form method="post" onsubmit="return confirm('Delete this log?');">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="asset_id" value="<?= (int) $assetId ?>">
              <input type="hidden" name="id" value="<?= (int) $log['id'] ?>">
              <button class="rounded-lg bg-red-50 px-3 py-2 text-sm font-bold text-red-700 hover:bg-red-100" type="submit">Delete</button>
            </form>
          </td>
        </tr>
      <?php endforeach; ?>
      <?php if (!$logs): ?>
        <tr><td class="px-4 py-10 text-center text-slate-500" colspan="6">No maintenance logs.</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</div>
<?php require __DIR__ . '/partials/footer.php'; ?>
