<?php
require_once __DIR__ . '/../../config/database.php';

// List maintenance logs, optionally filtered by asset_id.
$assetId = (int) ($_GET['asset_id'] ?? 0);

try {
    if ($assetId > 0) {
        // Return logs for one asset.
        $stmt = $pdo->prepare('SELECT * FROM maintenance_logs WHERE asset_id = ? ORDER BY repair_date DESC, id DESC');
        $stmt->execute([$assetId]);
    } else {
        // Return all logs with asset name for admin overview.
        $stmt = $pdo->query(
            'SELECT maintenance_logs.*, assets.asset_name
             FROM maintenance_logs
             INNER JOIN assets ON assets.id = maintenance_logs.asset_id
             ORDER BY repair_date DESC, maintenance_logs.id DESC'
        );
    }

    sendJson(true, 'Maintenance logs loaded', $stmt->fetchAll());
} catch (PDOException $e) {
    sendJson(false, 'Failed to load maintenance logs', $e->getMessage(), 500);
}
?>
