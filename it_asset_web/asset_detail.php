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
<div class="page-head">
  <div>
    <h1><?= h($asset['asset_name']) ?></h1>
    <p><?= h($asset['it_tag'] ?: $asset['serial_number']) ?></p>
  </div>
  <div class="actions">
    <a class="btn secondary" href="asset_form.php?id=<?= (int) $asset['id'] ?>">Edit</a>
    <a class="btn" href="maintenance.php?asset_id=<?= (int) $asset['id'] ?>">Maintenance</a>
    <a class="btn secondary" href="assets.php">Back</a>
  </div>
</div>

<section class="card detail-list">
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
    <div class="detail-item">
      <span><?= h($label) ?></span>
      <?= nl2br(h($value ?: '-')) ?>
    </div>
  <?php endforeach; ?>
</section>

<section class="card" style="margin-top: 16px;">
  <div class="page-head">
    <div>
      <h1>Maintenance Logs</h1>
      <p>Repair history for this asset.</p>
    </div>
    <a class="btn" href="maintenance.php?asset_id=<?= (int) $asset['id'] ?>">Add Log</a>
  </div>
  <div class="table-wrap">
    <table>
      <thead><tr><th>Date</th><th>Problem</th><th>Solution</th><th>Repair By</th><th>Status</th></tr></thead>
      <tbody>
      <?php foreach ($logs as $log): ?>
        <tr>
          <td><?= h($log['repair_date']) ?></td>
          <td><?= h($log['problem']) ?></td>
          <td><?= h($log['solution']) ?></td>
          <td><?= h($log['repair_by']) ?></td>
          <td><span class="pill"><?= h($log['status']) ?></span></td>
        </tr>
      <?php endforeach; ?>
      <?php if (!$logs): ?>
        <tr><td colspan="5">No maintenance logs.</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
