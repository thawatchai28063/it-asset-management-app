<?php
require_once __DIR__ . '/config/app.php';
require_login();

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

$exportRowCount = count($assets);
$filename = 'it_asset_export_' . $exportRowCount . '_rows_' . date('Ymd_His') . '.xls';

header('Content-Type: application/vnd.ms-excel; charset=utf-8');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Cache-Control: max-age=0');

$columns = [
    'id' => 'ID',
    'it_tag' => 'IT Tag',
    'asset_name' => 'Asset Name',
    'asset_type' => 'Asset Type',
    'serial_number' => 'Serial Number',
    'employee_no' => 'Employee No.',
    'department' => 'Department',
    'status' => 'Status',
    'assigned_user' => 'Assigned User',
    'position' => 'Position',
    'description' => 'Description',
    'os_version' => 'OS / Version',
    'brand' => 'Brand',
    'model' => 'Model',
    'ip_address' => 'IP Address',
    'point_image' => 'Point / Image',
    'purchase_date' => 'Purchase Date',
    'note' => 'Note',
    'created_at' => 'Created At',
    'updated_at' => 'Updated At',
];
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    table { border-collapse: collapse; font-family: Arial, sans-serif; }
    th { background: #1f4e79; color: #ffffff; font-weight: bold; }
    th, td { border: 1px solid #b7c9d6; padding: 6px; vertical-align: top; }
    td { mso-number-format: "\@"; }
  </style>
</head>
<body>
  <table>
    <thead>
      <tr>
        <?php foreach ($columns as $label): ?>
          <th><?= h($label) ?></th>
        <?php endforeach; ?>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($assets as $asset): ?>
        <tr>
          <?php foreach ($columns as $key => $_label): ?>
            <td><?= nl2br(h((string) ($asset[$key] ?? ''))) ?></td>
          <?php endforeach; ?>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</body>
</html>
