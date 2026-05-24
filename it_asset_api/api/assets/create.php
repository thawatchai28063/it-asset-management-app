<?php
require_once __DIR__ . '/../../config/database.php';

// Create an asset from JSON payload.
$input = getJsonInput();

// Validate required asset fields.
$required = ['asset_name', 'asset_type', 'serial_number', 'department', 'status'];
foreach ($required as $field) {
    if (trim($input[$field] ?? '') === '') {
        sendJson(false, "{$field} is required", null, 422);
    }
}

try {
    // Insert with named placeholders to prevent SQL injection.
    $stmt = $pdo->prepare(
        'INSERT INTO assets
        (asset_name, asset_type, it_tag, employee_no, description, os_version, brand, model, serial_number, ip_address, department, status, assigned_user, position, point_image, check_date, receipt_of_device, invoice_no, date2, vendor, checker_2025_03_31, check_result_2025_03_31, checker_2025_04_23, checker_2025_05_30, check_result_2025_04_30, purchase_date, note)
        VALUES
        (:asset_name, :asset_type, :it_tag, :employee_no, :description, :os_version, :brand, :model, :serial_number, :ip_address, :department, :status, :assigned_user, :position, :point_image, :check_date, :receipt_of_device, :invoice_no, :date2, :vendor, :checker_2025_03_31, :check_result_2025_03_31, :checker_2025_04_23, :checker_2025_05_30, :check_result_2025_04_30, :purchase_date, :note)'
    );
    $stmt->execute([
        ':asset_name' => trim($input['asset_name']),
        ':asset_type' => trim($input['asset_type']),
        ':it_tag' => trim($input['it_tag'] ?? '') ?: null,
        ':employee_no' => trim($input['employee_no'] ?? '') ?: null,
        ':description' => trim($input['description'] ?? '') ?: null,
        ':os_version' => trim($input['os_version'] ?? '') ?: null,
        ':brand' => trim($input['brand'] ?? '') ?: null,
        ':model' => trim($input['model'] ?? '') ?: null,
        ':serial_number' => trim($input['serial_number']),
        ':ip_address' => trim($input['ip_address'] ?? '') ?: null,
        ':department' => trim($input['department']),
        ':status' => trim($input['status']),
        ':assigned_user' => trim($input['assigned_user'] ?? '') ?: null,
        ':position' => trim($input['position'] ?? '') ?: null,
        ':point_image' => trim($input['point_image'] ?? '') ?: null,
        ':check_date' => trim($input['check_date'] ?? '') ?: null,
        ':receipt_of_device' => trim($input['receipt_of_device'] ?? '') ?: null,
        ':invoice_no' => trim($input['invoice_no'] ?? '') ?: null,
        ':date2' => trim($input['date2'] ?? '') ?: null,
        ':vendor' => trim($input['vendor'] ?? '') ?: null,
        ':checker_2025_03_31' => trim($input['checker_2025_03_31'] ?? '') ?: null,
        ':check_result_2025_03_31' => trim($input['check_result_2025_03_31'] ?? '') ?: null,
        ':checker_2025_04_23' => trim($input['checker_2025_04_23'] ?? '') ?: null,
        ':checker_2025_05_30' => trim($input['checker_2025_05_30'] ?? '') ?: null,
        ':check_result_2025_04_30' => trim($input['check_result_2025_04_30'] ?? '') ?: null,
        ':purchase_date' => trim($input['purchase_date'] ?? '') ?: null,
        ':note' => trim($input['note'] ?? '') ?: null,
    ]);

    sendJson(true, 'Asset created', ['id' => (int) $pdo->lastInsertId()], 201);
} catch (PDOException $e) {
    sendJson(false, 'Failed to create asset', $e->getMessage(), 500);
}
?>
