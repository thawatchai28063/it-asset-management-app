<?php
require_once __DIR__ . '/config/app.php';
require_login();

$id = (int) ($_GET['id'] ?? 0);
$isEdit = $id > 0;
$asset = [
    'asset_name' => '',
    'asset_type' => '',
    'it_tag' => '',
    'employee_no' => '',
    'description' => '',
    'os_version' => '',
    'brand' => '',
    'model' => '',
    'serial_number' => '',
    'ip_address' => '',
    'department' => '',
    'status' => 'in_use',
    'assigned_user' => '',
    'position' => '',
    'point_image' => '',
    'purchase_date' => '',
    'note' => '',
];
$error = '';

if ($isEdit) {
    $stmt = db()->prepare('SELECT * FROM assets WHERE id = ? LIMIT 1');
    $stmt->execute([$id]);
    $asset = $stmt->fetch();
    if (!$asset) {
        flash('Asset not found', 'error');
        redirect('assets.php');
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    foreach ($asset as $key => $_) {
        $asset[$key] = $_POST[$key] ?? '';
    }

    if (trim($asset['asset_name']) === '' || trim($asset['asset_type']) === '' || trim($asset['serial_number']) === '' || trim($asset['department']) === '') {
        $error = 'Asset name, type, serial number, and department are required.';
    } else {
        try {
            $params = [
                ':asset_name' => trim($asset['asset_name']),
                ':asset_type' => trim($asset['asset_type']),
                ':it_tag' => null_if_empty($asset['it_tag']),
                ':employee_no' => null_if_empty($asset['employee_no']),
                ':description' => null_if_empty($asset['description']),
                ':os_version' => null_if_empty($asset['os_version']),
                ':brand' => null_if_empty($asset['brand']),
                ':model' => null_if_empty($asset['model']),
                ':serial_number' => trim($asset['serial_number']),
                ':ip_address' => null_if_empty($asset['ip_address']),
                ':department' => trim($asset['department']),
                ':status' => trim($asset['status'] ?: 'in_use'),
                ':assigned_user' => null_if_empty($asset['assigned_user']),
                ':position' => null_if_empty($asset['position']),
                ':point_image' => null_if_empty($asset['point_image']),
                ':purchase_date' => null_if_empty($asset['purchase_date']),
                ':note' => null_if_empty($asset['note']),
            ];

            if ($isEdit) {
                $params[':id'] = $id;
                $sql = 'UPDATE assets SET
                    asset_name=:asset_name, asset_type=:asset_type, it_tag=:it_tag,
                    employee_no=:employee_no, description=:description, os_version=:os_version,
                    brand=:brand, model=:model, serial_number=:serial_number,
                    ip_address=:ip_address, department=:department, status=:status,
                    assigned_user=:assigned_user, position=:position, point_image=:point_image,
                    purchase_date=:purchase_date, note=:note
                    WHERE id=:id';
            } else {
                $sql = 'INSERT INTO assets
                    (asset_name, asset_type, it_tag, employee_no, description, os_version, brand, model, serial_number, ip_address, department, status, assigned_user, position, point_image, purchase_date, note)
                    VALUES
                    (:asset_name, :asset_type, :it_tag, :employee_no, :description, :os_version, :brand, :model, :serial_number, :ip_address, :department, :status, :assigned_user, :position, :point_image, :purchase_date, :note)';
            }

            $stmt = db()->prepare($sql);
            $stmt->execute($params);
            flash($isEdit ? 'Asset updated' : 'Asset created');
            redirect('assets.php');
        } catch (PDOException $e) {
            $error = $e->getMessage();
        }
    }
}

$pageTitle = ($isEdit ? 'Edit Asset' : 'Add Asset') . ' - IT Asset Control';
require __DIR__ . '/partials/header.php';
?>
<div class="page-head">
  <div>
    <h1><?= $isEdit ? 'Edit Asset' : 'Add Asset' ?></h1>
    <p>Use the same assets table as the REST API and mobile app.</p>
  </div>
  <a class="btn secondary" href="assets.php">Back</a>
</div>

<?php if ($error): ?>
  <div class="alert error"><?= h($error) ?></div>
<?php endif; ?>

<form method="post" class="card form-grid">
  <?php
  $fields = [
      ['asset_name', 'Asset Name', 'text', true],
      ['asset_type', 'Asset Type', 'text', true],
      ['it_tag', 'IT Tag', 'text', false],
      ['serial_number', 'Serial Number', 'text', true],
      ['department', 'Department', 'text', true],
      ['assigned_user', 'Assigned User', 'text', false],
      ['position', 'Position / Location', 'text', false],
      ['employee_no', 'Employee No.', 'text', false],
      ['brand', 'Brand', 'text', false],
      ['model', 'Model', 'text', false],
      ['os_version', 'OS / Version', 'text', false],
      ['ip_address', 'IP Address', 'text', false],
      ['description', 'Description', 'text', false],
      ['point_image', 'Point / Image', 'text', false],
      ['purchase_date', 'Purchase Date', 'date', false],
  ];
  foreach ($fields as [$name, $label, $type, $required]):
  ?>
    <div class="field">
      <label><?= h($label) ?></label>
      <input type="<?= $type ?>" name="<?= h($name) ?>" value="<?= h($asset[$name] ?? '') ?>" <?= $required ? 'required' : '' ?>>
    </div>
  <?php endforeach; ?>
  <div class="field">
    <label>Status</label>
    <select name="status">
      <?php foreach (['available', 'in_use', 'repair', 'retired'] as $value): ?>
        <option value="<?= $value ?>" <?= ($asset['status'] ?? '') === $value ? 'selected' : '' ?>><?= $value ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="field full">
    <label>Note</label>
    <textarea name="note"><?= h($asset['note'] ?? '') ?></textarea>
  </div>
  <div class="field full actions">
    <button type="submit"><?= $isEdit ? 'Save Changes' : 'Create Asset' ?></button>
    <a class="btn secondary" href="assets.php">Cancel</a>
  </div>
</form>
<?php require __DIR__ . '/partials/footer.php'; ?>
