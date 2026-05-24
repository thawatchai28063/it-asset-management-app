<?php
require_once __DIR__ . '/../../config/database.php';

// Update maintenance log from JSON payload.
$input = getJsonInput();
$id = (int) ($input['id'] ?? 0);

if ($id <= 0) {
    sendJson(false, 'Maintenance id is required', null, 422);
}

// Validate required maintenance fields.
$required = ['asset_id', 'problem', 'repair_by', 'repair_date', 'status'];
foreach ($required as $field) {
    if (trim((string) ($input[$field] ?? '')) === '') {
        sendJson(false, "{$field} is required", null, 422);
    }
}

try {
    // Update maintenance record with prepared placeholders.
    $stmt = $pdo->prepare(
        'UPDATE maintenance_logs SET
            asset_id = :asset_id,
            problem = :problem,
            solution = :solution,
            repair_by = :repair_by,
            repair_date = :repair_date,
            status = :status
         WHERE id = :id'
    );
    $stmt->execute([
        ':id' => $id,
        ':asset_id' => (int) $input['asset_id'],
        ':problem' => trim($input['problem']),
        ':solution' => trim($input['solution'] ?? '') ?: null,
        ':repair_by' => trim($input['repair_by']),
        ':repair_date' => trim($input['repair_date']),
        ':status' => trim($input['status']),
    ]);

    sendJson(true, 'Maintenance log updated', ['id' => $id]);
} catch (PDOException $e) {
    sendJson(false, 'Failed to update maintenance log', $e->getMessage(), 500);
}
?>
