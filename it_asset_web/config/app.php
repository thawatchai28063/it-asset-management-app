<?php
session_start();

// Change these values when deploying to InfinityFree or a Windows server.
$dbHost = 'localhost';
$dbName = 'it_asset_management';
$dbUser = 'root';
$dbPass = '';

function db(): PDO
{
    static $pdo = null;
    global $dbHost, $dbName, $dbUser, $dbPass;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $pdo = new PDO(
        "mysql:host={$dbHost};dbname={$dbName};charset=utf8mb4",
        $dbUser,
        $dbPass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );

    return $pdo;
}

function h(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}

function redirect(string $path): void
{
    header("Location: {$path}");
    exit;
}

function current_user(): ?array
{
    return $_SESSION['user'] ?? null;
}

function require_login(): void
{
    if (!current_user()) {
        redirect('login.php');
    }
}

function flash(?string $message = null, string $type = 'success'): ?array
{
    if ($message !== null) {
        $_SESSION['flash'] = ['message' => $message, 'type' => $type];
        return null;
    }

    $flash = $_SESSION['flash'] ?? null;
    unset($_SESSION['flash']);
    return $flash;
}

function null_if_empty(?string $value): ?string
{
    $value = trim($value ?? '');
    return $value === '' ? null : $value;
}

function asset_status_class(?string $status): string
{
    switch ($status) {
        case 'available':
            return 'bg-emerald-50 text-emerald-700 ring-emerald-200';
        case 'in_use':
            return 'bg-blue-50 text-blue-700 ring-blue-200';
        case 'repair':
            return 'bg-amber-50 text-amber-700 ring-amber-200';
        case 'retired':
            return 'bg-slate-100 text-slate-600 ring-slate-200';
        default:
            return 'bg-indigo-50 text-indigo-700 ring-indigo-200';
    }
}

function maintenance_status_class(?string $status): string
{
    switch ($status) {
        case 'completed':
            return 'bg-emerald-50 text-emerald-700 ring-emerald-200';
        case 'in_progress':
            return 'bg-amber-50 text-amber-700 ring-amber-200';
        default:
            return 'bg-slate-100 text-slate-700 ring-slate-200';
    }
}
?>
