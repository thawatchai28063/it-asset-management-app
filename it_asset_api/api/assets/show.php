<?php
require_once __DIR__ . '/../../config/database.php';

// Show one asset by id.
$id = (int) ($_GET['id'] ?? 0);

if ($id <= 0) {
    sendJson(false, 'Asset id is required', null, 422);
}

try {
    // Fetch asset and maintenance history in one endpoint-friendly response.
    $assetStmt = $pdo->prepare('SELECT * FROM assets WHERE id = ? LIMIT 1');
    $assetStmt->execute([$id]);
    $asset = $assetStmt->fetch();

    if (!$asset) {
        sendJson(false, 'Asset not found', null, 404);
    }

    $logStmt = $pdo->prepare('SELECT * FROM maintenance_logs WHERE asset_id = ? ORDER BY repair_date DESC, id DESC');
    $logStmt->execute([$id]);
    $asset['maintenance_logs'] = $logStmt->fetchAll();

    sendJson(true, 'Asset loaded', $asset);
} catch (PDOException $e) {
    sendJson(false, 'Failed to load asset', $e->getMessage(), 500);
}
?>
