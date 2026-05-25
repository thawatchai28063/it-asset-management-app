<?php
require_once __DIR__ . '/config/app.php';
require_login();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'delete') {
    $id = (int) ($_POST['id'] ?? 0);
    if ($id > 0) {
        $stmt = db()->prepare('DELETE FROM assets WHERE id = ?');
        $stmt->execute([$id]);
        flash('Asset deleted');
    }
    redirect('assets.php');
}

$q = trim($_GET['q'] ?? '');
$department = trim($_GET['department'] ?? '');
$assetType = trim($_GET['asset_type'] ?? '');
$status = trim($_GET['status'] ?? '');

$where = [];
$params = [];

if ($q !== '') {
    $where[] = '(asset_name LIKE ? OR it_tag LIKE ? OR serial_number LIKE ? OR assigned_user LIKE ? OR department LIKE ?)';
    $needle = "%{$q}%";
    array_push($params, $needle, $needle, $needle, $needle, $needle);
}
if ($department !== '') {
    $where[] = 'department = ?';
    $params[] = $department;
}
if ($assetType !== '') {
    $where[] = 'asset_type = ?';
    $params[] = $assetType;
}
if ($status !== '') {
    $where[] = 'status = ?';
    $params[] = $status;
}

$sql = 'SELECT * FROM assets';
if ($where) {
    $sql .= ' WHERE ' . implode(' AND ', $where);
}
$sql .= ' ORDER BY COALESCE(it_tag, serial_number), id DESC';

$stmt = db()->prepare($sql);
$stmt->execute($params);
$assets = $stmt->fetchAll();

$departments = db()->query('SELECT DISTINCT department FROM assets WHERE department <> "" ORDER BY department')->fetchAll();
$assetTypes = db()->query('SELECT DISTINCT asset_type FROM assets WHERE asset_type <> "" ORDER BY asset_type')->fetchAll();

$pageTitle = 'Assets - IT Asset Control';
require __DIR__ . '/partials/header.php';
?>
<div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
  <div>
    <p class="text-sm font-bold uppercase tracking-wide text-indigo-600">Assets</p>
    <h1 class="mt-1 text-3xl font-black text-slate-950">Asset Inventory</h1>
    <p class="mt-2 text-slate-500">ค้นหา กรอง เพิ่ม แก้ไข และลบข้อมูลอุปกรณ์ IT</p>
  </div>
  <a class="inline-flex items-center justify-center rounded-xl bg-indigo-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-indigo-200 transition hover:bg-indigo-700" href="asset_form.php">Add Asset</a>
</div>

<form class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm" method="get">
  <div class="grid gap-4 lg:grid-cols-4">
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Search</label>
      <input class="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" name="q" value="<?= h($q) ?>" placeholder="IT tag, serial, user, department">
    </div>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Department</label>
      <select class="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" name="department">
        <option value="">All departments</option>
        <?php foreach ($departments as $row): ?>
          <option value="<?= h($row['department']) ?>" <?= $department === $row['department'] ? 'selected' : '' ?>><?= h($row['department']) ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Asset Type</label>
      <select class="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" name="asset_type">
        <option value="">All types</option>
        <?php foreach ($assetTypes as $row): ?>
          <option value="<?= h($row['asset_type']) ?>" <?= $assetType === $row['asset_type'] ? 'selected' : '' ?>><?= h($row['asset_type']) ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Status</label>
      <select class="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" name="status">
        <option value="">All statuses</option>
        <?php foreach (['available', 'in_use', 'repair', 'retired'] as $value): ?>
          <option value="<?= $value ?>" <?= $status === $value ? 'selected' : '' ?>><?= $value ?></option>
        <?php endforeach; ?>
      </select>
    </div>
  </div>
  <div class="mt-4 flex flex-wrap gap-2">
    <button class="rounded-xl bg-indigo-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-indigo-100 transition hover:bg-indigo-700" type="submit">Search</button>
    <a class="rounded-xl bg-slate-100 px-5 py-3 font-extrabold text-slate-700 transition hover:bg-slate-200" href="assets.php">Clear</a>
  </div>
</form>

<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-slate-200">
      <thead class="bg-slate-50">
        <tr>
          <th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">IT Tag</th>
          <th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Asset</th>
          <th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Department</th>
          <th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">User / Position</th>
          <th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Status</th>
          <th class="px-4 py-3 text-left text-xs font-black uppercase text-slate-500">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-slate-100">
      <?php foreach ($assets as $asset): ?>
        <tr class="hover:bg-slate-50">
          <td class="px-4 py-4"><span class="font-black text-slate-950"><?= h($asset['it_tag'] ?: $asset['serial_number']) ?></span></td>
          <td class="px-4 py-4">
            <a class="font-bold text-indigo-600 hover:text-indigo-800" href="asset_detail.php?id=<?= (int) $asset['id'] ?>"><?= h($asset['asset_name']) ?></a><br>
            <span class="text-sm text-slate-500"><?= h($asset['asset_type']) ?> / <?= h($asset['serial_number']) ?></span>
          </td>
          <td class="px-4 py-4 text-slate-700"><?= h($asset['department']) ?></td>
          <td class="px-4 py-4 text-slate-700"><?= h($asset['assigned_user']) ?><br><span class="text-sm text-slate-500"><?= h($asset['position']) ?></span></td>
          <td class="px-4 py-4"><span class="inline-flex rounded-full px-3 py-1 text-xs font-black ring-1 <?= asset_status_class($asset['status']) ?>"><?= h($asset['status']) ?></span></td>
          <td class="px-4 py-4">
            <div class="flex flex-wrap gap-2">
              <a class="rounded-lg bg-slate-100 px-3 py-2 text-sm font-bold text-slate-700 hover:bg-slate-200" href="asset_detail.php?id=<?= (int) $asset['id'] ?>">View</a>
              <a class="rounded-lg bg-indigo-50 px-3 py-2 text-sm font-bold text-indigo-700 hover:bg-indigo-100" href="asset_form.php?id=<?= (int) $asset['id'] ?>">Edit</a>
              <form method="post" onsubmit="return confirm('Delete this asset?');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<?= (int) $asset['id'] ?>">
                <button class="rounded-lg bg-red-50 px-3 py-2 text-sm font-bold text-red-700 hover:bg-red-100" type="submit">Delete</button>
              </form>
            </div>
          </td>
        </tr>
      <?php endforeach; ?>
      <?php if (!$assets): ?>
        <tr><td class="px-4 py-10 text-center text-slate-500" colspan="6">No assets found.</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</div>
<?php require __DIR__ . '/partials/footer.php'; ?>
