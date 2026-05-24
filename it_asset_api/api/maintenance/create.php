<?php
require_once __DIR__ . '/../../config/database.php';

// Create a maintenance log from JSON payload.
$input = getJsonInput();

// Validate required maintenance fields.
$required = ['asset_id', 'problem', 'repair_by', 'repair_date', 'status'];
foreach ($required as $field) {
    if (trim((string) ($input[$field] ?? '')) === '') {
        sendJson(false, "{$field} is required", null, 422);
    }
}

try {
    // Insert maintenance record with prepared placeholders.
    $stmt = $pdo->prepare(
        'INSERT INTO maintenance_logs (asset_id, problem, solution, repair_by, repair_date, status)
         VALUES (:asset_id, :problem, :solution, :repair_by, :repair_date, :status)'
    );
    $stmt->execute([
        ':asset_id' => (int) $input['asset_id'],
        ':problem' => trim($input['problem']),
        ':solution' => trim($input['solution'] ?? '') ?: null,
        ':repair_by' => trim($input['repair_by']),
        ':repair_date' => trim($input['repair_date']),
        ':status' => trim($input['status']),
    ]);

    sendJson(true, 'Maintenance log created', ['id' => (int) $pdo->lastInsertId()], 201);
} catch (PDOException $e) {
    sendJson(false, 'Failed to create maintenance log', $e->getMessage(), 500);
}
?>
