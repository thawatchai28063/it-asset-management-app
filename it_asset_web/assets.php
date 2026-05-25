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
<div class="page-head">
  <div>
    <h1>Assets</h1>
    <p>Search, filter, add, edit, and delete IT assets.</p>
  </div>
  <a class="btn" href="asset_form.php">Add Asset</a>
</div>

<form class="card filters" method="get">
  <div class="field">
    <label>Search</label>
    <input name="q" value="<?= h($q) ?>" placeholder="IT tag, serial, user, department">
  </div>
  <div class="field">
    <label>Department</label>
    <select name="department">
      <option value="">All departments</option>
      <?php foreach ($departments as $row): ?>
        <option value="<?= h($row['department']) ?>" <?= $department === $row['department'] ? 'selected' : '' ?>><?= h($row['department']) ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="field">
    <label>Asset Type</label>
    <select name="asset_type">
      <option value="">All types</option>
      <?php foreach ($assetTypes as $row): ?>
        <option value="<?= h($row['asset_type']) ?>" <?= $assetType === $row['asset_type'] ? 'selected' : '' ?>><?= h($row['asset_type']) ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="field">
    <label>Status</label>
    <select name="status">
      <option value="">All statuses</option>
      <?php foreach (['available', 'in_use', 'repair', 'retired'] as $value): ?>
        <option value="<?= $value ?>" <?= $status === $value ? 'selected' : '' ?>><?= $value ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="field full actions">
    <button type="submit">Search</button>
    <a class="btn secondary" href="assets.php">Clear</a>
  </div>
</form>

<div class="card" style="margin-top: 16px;">
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>IT Tag</th>
          <th>Asset</th>
          <th>Department</th>
          <th>User / Position</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <?php foreach ($assets as $asset): ?>
        <tr>
          <td><strong><?= h($asset['it_tag'] ?: $asset['serial_number']) ?></strong></td>
          <td>
            <a href="asset_detail.php?id=<?= (int) $asset['id'] ?>"><?= h($asset['asset_name']) ?></a><br>
            <small><?= h($asset['asset_type']) ?> / <?= h($asset['serial_number']) ?></small>
          </td>
          <td><?= h($asset['department']) ?></td>
          <td><?= h($asset['assigned_user']) ?><br><small><?= h($asset['position']) ?></small></td>
          <td><span class="pill status-<?= h($asset['status']) ?>"><?= h($asset['status']) ?></span></td>
          <td>
            <div class="actions">
              <a class="btn secondary" href="asset_detail.php?id=<?= (int) $asset['id'] ?>">View</a>
              <a class="btn secondary" href="asset_form.php?id=<?= (int) $asset['id'] ?>">Edit</a>
              <form method="post" onsubmit="return confirm('Delete this asset?');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<?= (int) $asset['id'] ?>">
                <button class="danger" type="submit">Delete</button>
              </form>
            </div>
          </td>
        </tr>
      <?php endforeach; ?>
      <?php if (!$assets): ?>
        <tr><td colspan="6">No assets found.</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</div>
<?php require __DIR__ . '/partials/footer.php'; ?>
