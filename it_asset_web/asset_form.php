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

$inputClass = 'w-full rounded-xl border border-slate-200 px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100';
?>
<div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
  <div>
    <p class="text-sm font-bold uppercase tracking-wide text-indigo-600"><?= $isEdit ? 'Edit Asset' : 'Add Asset' ?></p>
    <h1 class="mt-1 text-3xl font-black text-slate-950"><?= $isEdit ? 'Update IT Asset' : 'Create IT Asset' ?></h1>
    <p class="mt-2 text-slate-500">บันทึกข้อมูลลงตาราง assets เดียวกับ REST API และแอพมือถือ</p>
  </div>
  <a class="rounded-xl bg-slate-100 px-5 py-3 font-extrabold text-slate-700 transition hover:bg-slate-200" href="assets.php">Back</a>
</div>

<?php if ($error): ?>
  <div class="mb-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700"><?= h($error) ?></div>
<?php endif; ?>

<form method="post" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
  <div class="grid gap-4 lg:grid-cols-3">
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
      <div>
        <label class="mb-1.5 block text-sm font-bold text-slate-600"><?= h($label) ?></label>
        <input class="<?= $inputClass ?>" type="<?= $type ?>" name="<?= h($name) ?>" value="<?= h($asset[$name] ?? '') ?>" <?= $required ? 'required' : '' ?>>
      </div>
    <?php endforeach; ?>
    <div>
      <label class="mb-1.5 block text-sm font-bold text-slate-600">Status</label>
      <select class="<?= $inputClass ?>" name="status">
        <?php foreach (['available', 'in_use', 'repair', 'retired'] as $value): ?>
          <option value="<?= $value ?>" <?= ($asset['status'] ?? '') === $value ? 'selected' : '' ?>><?= $value ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="lg:col-span-3">
      <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
        <div class="mb-3 border-b border-slate-200 pb-2 text-sm font-black uppercase tracking-wide text-slate-600">Note</div>
        <textarea class="min-h-32 w-full rounded-xl border border-slate-200 bg-white px-4 py-3 outline-none transition focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100" name="note"><?= h($asset['note'] ?? '') ?></textarea>
      </div>
    </div>
  </div>
  <div class="mt-5 flex flex-wrap gap-2">
    <button class="rounded-xl bg-indigo-600 px-5 py-3 font-extrabold text-white shadow-lg shadow-indigo-100 transition hover:bg-indigo-700" type="submit"><?= $isEdit ? 'Save Changes' : 'Create Asset' ?></button>
    <a class="rounded-xl bg-slate-100 px-5 py-3 font-extrabold text-slate-700 transition hover:bg-slate-200" href="assets.php">Cancel</a>
  </div>
</form>
<?php require __DIR__ . '/partials/footer.php'; ?>
