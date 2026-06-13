<?php


$uri  = $_SERVER['REQUEST_URI'];
$path = parse_url($uri, PHP_URL_PATH);


if (preg_match('#^/([a-z0-9]+)\.com-[a-z0-9]+\.[a-z0-9]+\.page\.dev(/.*)?$#', $path, $m)) {
    $site = $m[1];
    $rest = rtrim($m[2] ?? '', '/');
    $target = '/templates/' . preg_replace('/[^a-z0-9_-]/', '', $site) . '/' . ltrim($rest, '/');
    header('Location: ' . $target);
    exit;
}


return false;
