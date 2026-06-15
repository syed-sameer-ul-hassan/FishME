<?php

require_once __DIR__ . '/config.php';

$uri  = $_SERVER['REQUEST_URI'] ?? '/';
$path = parse_url($uri, PHP_URL_PATH) ?: '/';
$path = rawurldecode($path);

$rootFile = __DIR__ . $path;
if ($path !== '/' && is_file($rootFile)) {
    return false;
}

if (strncmp($path, '/templates/', 11) === 0 && is_file($rootFile)) {
    return false;
}

foreach (loadSiteRoutes() as $allocatedUrl => $site) {
    $prefix = '/' . $allocatedUrl;
    if ($path === $prefix || $path === $prefix . '/') {
        serveTemplateFile($site['dir'], $site['entry_page']);
        return true;
    }

    if (strncmp($path, $prefix . '/', strlen($prefix) + 1) === 0) {
        $rest = substr($path, strlen($prefix) + 1);
        serveTemplateFile($site['dir'], $rest);
        return true;
    }
}

return false;
