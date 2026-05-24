<?php
require_once __DIR__ . '/../../config/database.php';

// Delete an asset by id from JSON payload.
$input = getJsonInput();
$id = (int) ($input['id'] ?? 0);

if ($id <= 0) {
    sendJson(false, 'Asset id is required', null, 422);
}

try {
    // Related maintenance logs are removed by ON DELETE CASCADE.
    $stmt = $pdo->prepare('DELETE FROM assets WHERE id = ?');
    $stmt->execute([$id]);

    sendJson(true, 'Asset deleted', ['id' => $id]);
} catch (PDOException $e) {
    sendJson(false, 'Failed to delete asset', $e->getMessage(), 500);
}
?>
