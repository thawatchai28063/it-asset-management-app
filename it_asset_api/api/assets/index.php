<?php
require_once __DIR__ . '/../../config/database.php';

// List assets, optionally filtered by search keyword, department, and type.
$search = trim($_GET['search'] ?? '');
$department = trim($_GET['department'] ?? '');
$assetType = trim($_GET['asset_type'] ?? '');
$status = trim($_GET['status'] ?? '');

try {
    $where = [];
    $params = [];

    if ($search !== '') {
        // Search across important text fields.
        $keyword = "%{$search}%";
        $where[] = '(asset_name LIKE ?
            OR asset_type LIKE ?
            OR it_tag LIKE ?
            OR employee_no LIKE ?
            OR description LIKE ?
            OR os_version LIKE ?
            OR brand LIKE ?
            OR model LIKE ?
            OR serial_number LIKE ?
            OR ip_address LIKE ?
            OR department LIKE ?
            OR status LIKE ?
            OR assigned_user LIKE ?
            OR position LIKE ?
            OR point_image LIKE ?
            OR invoice_no LIKE ?
            OR vendor LIKE ?
            OR checker_2025_03_31 LIKE ?
            OR check_result_2025_03_31 LIKE ?
            OR checker_2025_04_23 LIKE ?
            OR checker_2025_05_30 LIKE ?
            OR check_result_2025_04_30 LIKE ?
            OR note LIKE ?)';
        $params = array_merge($params, [$keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword, $keyword]);
    }

    if ($department !== '') {
        // Filter a specific department from the department dropdown.
        $where[] = 'department = ?';
        $params[] = $department;
    }

    if ($assetType !== '') {
        // Filter a specific asset type from dashboard drill-down.
        $where[] = 'asset_type = ?';
        $params[] = $assetType;
    }

    if ($status !== '') {
        // Filter a specific status from dashboard overview cards.
        $where[] = 'status = ?';
        $params[] = $status;
    }

    $sql = 'SELECT * FROM assets';
    if (!empty($where)) {
        $sql .= ' WHERE ' . implode(' AND ', $where);
    }
    $sql .= ' ORDER BY id DESC';

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    $assets = $stmt->fetchAll();
    sendJson(true, 'Assets loaded', $assets);
} catch (PDOException $e) {
    sendJson(false, 'Failed to load assets', $e->getMessage(), 500);
}
?>
