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
<div class="page-head">
  <div>
    <h1>Dashboard</h1>
    <p>Overview from the same MySQL database used by the REST API.</p>
  </div>
  <a class="btn" href="assets.php">View all assets</a>
</div>

<section class="grid">
  <a class="card metric" href="assets.php">
    <div><strong><?= $total ?></strong><span>Total assets</span></div>
    <span class="pill">All</span>
  </a>
  <a class="card metric" href="assets.php?status=in_use">
    <div><strong><?= $statusCounts['in_use'] ?></strong><span>In use</span></div>
    <span class="pill status-in_use">active</span>
  </a>
  <a class="card metric" href="assets.php?status=available">
    <div><strong><?= $statusCounts['available'] ?></strong><span>Available</span></div>
    <span class="pill status-available">ready</span>
  </a>
  <a class="card metric" href="assets.php?status=repair">
    <div><strong><?= $statusCounts['repair'] ?></strong><span>Repair</span></div>
    <span class="pill status-repair">service</span>
  </a>
</section>

<section class="grid two" style="margin-top: 16px;">
  <div class="card">
    <div class="page-head">
      <div>
        <h1>Assets by Type</h1>
        <p>Click a type to filter the asset list.</p>
      </div>
    </div>
    <div class="table-wrap">
      <table>
        <thead><tr><th>Type</th><th>Total</th></tr></thead>
        <tbody>
        <?php foreach ($typeRows as $row): ?>
          <tr>
            <td><a href="assets.php?asset_type=<?= urlencode($row['asset_type']) ?>"><?= h($row['asset_type']) ?></a></td>
            <td><?= (int) $row['total'] ?></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
  <div class="card">
    <div class="page-head">
      <div>
        <h1>Assets by Department</h1>
        <p>Click a department to filter the asset list.</p>
      </div>
    </div>
    <div class="table-wrap">
      <table>
        <thead><tr><th>Department</th><th>Total</th></tr></thead>
        <tbody>
        <?php foreach ($departmentRows as $row): ?>
          <tr>
            <td><a href="assets.php?department=<?= urlencode($row['department']) ?>"><?= h($row['department']) ?></a></td>
            <td><?= (int) $row['total'] ?></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</section>
<?php require __DIR__ . '/partials/footer.php'; ?>
