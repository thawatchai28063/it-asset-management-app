<?php
require_once __DIR__ . '/../../config/database.php';

// Delete a maintenance log by id from JSON payload.
$input = getJsonInput();
$id = (int) ($input['id'] ?? 0);

if ($id <= 0) {
    sendJson(false, 'Maintenance id is required', null, 422);
}

try {
    // Delete maintenance record safely.
    $stmt = $pdo->prepare('DELETE FROM maintenance_logs WHERE id = ?');
    $stmt->execute([$id]);

    sendJson(true, 'Maintenance log deleted', ['id' => $id]);
} catch (PDOException $e) {
    sendJson(false, 'Failed to delete maintenance log', $e->getMessage(), 500);
}
?>
