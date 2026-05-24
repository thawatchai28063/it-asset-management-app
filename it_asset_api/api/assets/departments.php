<?php
require_once __DIR__ . '/../../config/database.php';

// Return distinct departments for the asset department filter menu.
try {
    $stmt = $pdo->query(
        "SELECT DISTINCT department
         FROM assets
         WHERE department IS NOT NULL AND department <> ''
         ORDER BY department ASC"
    );
    $departments = array_map(
        fn($row) => $row['department'],
        $stmt->fetchAll()
    );

    sendJson(true, 'Departments loaded', $departments);
} catch (PDOException $e) {
    sendJson(false, 'Failed to load departments', $e->getMessage(), 500);
}
?>
