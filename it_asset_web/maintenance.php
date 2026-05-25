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
?>
<div class="page-head">
  <div>
    <h1>Maintenance</h1>
    <p><?= h($asset['asset_name']) ?> / <?= h($asset['it_tag'] ?: $asset['serial_number']) ?></p>
  </div>
  <a class="btn secondary" href="asset_detail.php?id=<?= (int) $assetId ?>">Back</a>
</div>

<form method="post" class="card form-grid two">
  <input type="hidden" name="asset_id" value="<?= (int) $assetId ?>">
  <div class="field full">
    <label>Problem</label>
    <textarea name="problem" required></textarea>
  </div>
  <div class="field full">
    <label>Solution</label>
    <textarea name="solution"></textarea>
  </div>
  <div class="field">
    <label>Repair By</label>
    <input name="repair_by" required>
  </div>
  <div class="field">
    <label>Repair Date</label>
    <input type="date" name="repair_date" value="<?= date('Y-m-d') ?>" required>
  </div>
  <div class="field">
    <label>Status</label>
    <select name="status">
      <?php foreach (['pending', 'in_progress', 'completed'] as $value): ?>
        <option value="<?= $value ?>"><?= $value ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="field actions">
    <button type="submit">Add Log</button>
  </div>
</form>

<div class="card" style="margin-top: 16px;">
  <div class="table-wrap">
    <table>
      <thead><tr><th>Date</th><th>Problem</th><th>Solution</th><th>Repair By</th><th>Status</th><th>Actions</th></tr></thead>
      <tbody>
      <?php foreach ($logs as $log): ?>
        <tr>
          <td><?= h($log['repair_date']) ?></td>
          <td><?= h($log['problem']) ?></td>
          <td><?= h($log['solution']) ?></td>
          <td><?= h($log['repair_by']) ?></td>
          <td><span class="pill"><?= h($log['status']) ?></span></td>
          <td>
            <form method="post" onsubmit="return confirm('Delete this log?');">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="asset_id" value="<?= (int) $assetId ?>">
              <input type="hidden" name="id" value="<?= (int) $log['id'] ?>">
              <button class="danger" type="submit">Delete</button>
            </form>
          </td>
        </tr>
      <?php endforeach; ?>
      <?php if (!$logs): ?>
        <tr><td colspan="6">No maintenance logs.</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</div>
<?php require __DIR__ . '/partials/footer.php'; ?>
