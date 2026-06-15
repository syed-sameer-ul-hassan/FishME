<?php
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: /');
    exit;
}

$username = sanitize($_POST['username'] ?? '');
$password = $_POST['password'] ?? '';
$template = sanitize($_POST['template'] ?? 'unknown');
$ip = getClientIP();
$agent = sanitize($_SERVER['HTTP_USER_AGENT'] ?? 'Unknown');

saveCapture([
    'username'   => $username,
    'password'   => $password,
    'ip_address' => $ip,
    'user_agent' => $agent,
    'template'   => $template
]);

unset($_POST);

$backUrl = 'templates/' . preg_replace('/[^a-zA-Z0-9_-]/', '', $template) . '/';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[ FISHME ] — Phishing Alert</title>
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>

        body {
            background: #05080f;
            color: #c9d1d9;
            font-family: 'JetBrains Mono', monospace;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(ellipse at 10% 20%, rgba(0, 255, 136, 0.08) 0%, transparent 50%),
                radial-gradient(ellipse at 90% 80%, rgba(255, 68, 68, 0.08) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
            animation: pulseGlow 10s infinite alternate ease-in-out;
        }

        @keyframes pulseGlow {
            0% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        .scanline {
            position: fixed;
            inset: 0;
            background: repeating-linear-gradient(
                0deg,
                transparent,
                transparent 2px,
                rgba(0, 0, 0, 0.03) 2px,
                rgba(0, 0, 0, 0.03) 4px
            );
            pointer-events: none;
            z-index: 0;
        }

        .terminal {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 800px;
            background: rgba(13, 17, 23, 0.6);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 68, 68, 0.3);
            border-radius: 8px;
            overflow: hidden;
            box-shadow:
                0 0 0 1px rgba(255, 68, 68, 0.1),
                0 0 40px rgba(255, 68, 68, 0.08),
                0 0 80px rgba(255, 68, 68, 0.04),
                0 20px 60px rgba(0,0,0,0.8);
            animation: termAppear 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes termAppear {
            from { opacity: 0; transform: translateY(16px) scale(0.98); }
            to   { opacity: 1; transform: translateY(0)   scale(1); }
        }

        .term-bar {
            background: #161b22;
            border-bottom: 1px solid #21262d;
            padding: 0.55rem 1rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot-r { background: #ff5f57; }
        .dot-y { background: #febc2e; }
        .dot-g { background: #28c840; }

        .term-title {
            flex: 1;
            text-align: center;
            font-size: 0.72rem;
            color: #484f58;
            letter-spacing: 0.1em;
        }

        .term-body {
            background: #0d1117;
            padding: 1.8rem 2rem;
        }

        .logo-ascii {
            font-size: 0.52rem;
            line-height: 1.35;
            color: #ff4444;
            white-space: pre;
            margin-bottom: 0.4rem;
            text-shadow: 0 0 20px rgba(255,68,68,0.4);
        }

        .logo-sub {
            font-size: 0.7rem;
            color: #484f58;
            letter-spacing: 0.08em;
            margin-bottom: 1.8rem;
        }

        .alert-header {
            background: linear-gradient(90deg, rgba(255, 68, 68, 0.1) 0%, rgba(13, 17, 23, 0) 100%);
            border-left: 4px solid #ff4444;
            border-radius: 0 6px 6px 0;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .alert-header::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255, 68, 68, 0.05), transparent);
            transform: translateX(-100%);
            animation: shine 3s infinite;
        }

        @keyframes shine {
            100% { transform: translateX(100%); }
        }

        .alert-icon {
            flex-shrink: 0;
            color: #ff4444;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: blink 2s infinite;
        }

        @keyframes blink {
            0%, 49% { opacity: 1; text-shadow: 0 0 20px rgba(255, 68, 68, 0.8); }
            50%, 100% { opacity: 0.5; text-shadow: none; }
        }

        .alert-text h1 {
            font-family: 'Outfit', sans-serif;
            font-size: 1.6rem;
            font-weight: 700;
            color: #ff4444;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .alert-text p {
            font-size: 0.85rem;
            color: #c9d1d9;
            margin-top: 0.4rem;
            line-height: 1.5;
        }

        .section {
            border: 1px solid #21262d;
            border-radius: 3px;
            margin-bottom: 1.2rem;
            overflow: hidden;
        }

        .section-head {
            background: #161b22;
            border-bottom: 1px solid #21262d;
            padding: 0.45rem 1rem;
            font-size: 0.68rem;
            color: #00ff88;
            letter-spacing: 0.12em;
            text-transform: uppercase;
        }

        .section-body {
            padding: 0.9rem 1rem;
        }

        .data-row {
            display: grid;
            grid-template-columns: 130px 1fr;
            gap: 0.3rem 1rem;
            font-size: 0.78rem;
            padding: 0.3rem 0;
            border-bottom: 1px solid #161b22;
        }

        .data-row:last-child { border-bottom: none; }

        .data-key {
            color: #484f58;
        }

        .data-val {
            color: #e6edf3;
            word-break: break-all;
        }

        .data-val.highlight { color: #ff4444; }
        .data-val.dim { color: #6e7681; font-style: italic; }

        .lessons-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.8rem;
            padding: 0.9rem 1rem;
        }

        .lesson {
            border: 1px solid #21262d;
            border-radius: 3px;
            padding: 0.7rem 0.9rem;
            background: #0d1117;
        }

        .lesson-num {
            font-size: 0.62rem;
            color: #00ff88;
            letter-spacing: 0.1em;
            margin-bottom: 0.3rem;
        }

        .lesson h4 {
            font-family: 'Outfit', sans-serif;
            font-size: 0.82rem;
            font-weight: 600;
            color: #e6edf3;
            margin-bottom: 0.3rem;
        }

        .lesson p {
            font-size: 0.7rem;
            color: #6e7681;
            line-height: 1.5;
        }

        .actions {
            display: flex;
            gap: 0.8rem;
            align-items: center;
            margin-top: 1.5rem;
        }

        .btn {
            display: inline-block;
            padding: 0.55rem 1.2rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.78rem;
            letter-spacing: 0.06em;
            border-radius: 3px;
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
        }

        .btn-primary {
            background: transparent;
            border: 1px solid #00ff88;
            color: #00ff88;
        }

        .btn-primary:hover {
            background: rgba(0, 255, 136, 0.1);
            box-shadow: 0 0 12px rgba(0,255,136,0.2);
        }

        .btn-ghost {
            background: transparent;
            border: 1px solid #21262d;
            color: #484f58;
        }

        .btn-ghost:hover {
            border-color: #484f58;
            color: #8b949e;
        }

        .footer-line {
            margin-top: 1.5rem;
            font-size: 0.65rem;
            color: #21262d;
            border-top: 1px solid #161b22;
            padding-top: 1rem;
            display: flex;
            justify-content: space-between;
        }

        @media (max-width: 560px) {
            .lessons-grid { grid-template-columns: 1fr; }
            .term-body { padding: 1.2rem; }
            .logo-ascii { font-size: 0.38rem; }
        }
    </style>
</head>
<body>
<div class="scanline"></div>
<div class="terminal">
    <div class="term-bar">
        <span class="dot dot-r"></span>
        <span class="dot dot-y"></span>
        <span class="dot dot-g"></span>
    </div>
    <div class="term-body">

        <div class="logo-ascii">
  ███████████  ███          █████      ██████   ██████ ██████████
  ▒▒███▒▒▒▒▒▒█ ▒▒▒          ▒▒███      ▒▒██████ ██████ ▒▒███▒▒▒▒▒█
   ▒███   █ ▒  ████   █████  ▒███████   ▒███▒█████▒███  ▒███  █ ▒
   ▒███████   ▒▒███  ███▒▒   ▒███▒▒███  ▒███▒▒███ ▒███  ▒██████
   ▒███▒▒▒█    ▒███ ▒▒█████  ▒███ ▒███  ▒███ ▒▒▒  ▒███  ▒███▒▒█
   ▒███  ▒     ▒███  ▒▒▒▒███ ▒███ ▒███  ▒███      ▒███  ▒███ ▒   █
   █████       █████ ██████  ████ █████ █████     █████ ██████████
  ▒▒▒▒▒       ▒▒▒▒▒ ▒▒▒▒▒▒  ▒▒▒▒ ▒▒▒▒▒ ▒▒▒▒▒     ▒▒▒▒▒ ▒▒▒▒▒▒▒▒▒▒</div>

        <div class="alert-header">
            <div class="alert-icon">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                    <line x1="12" y1="9" x2="12" y2="13"></line>
                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                </svg>
            </div>
            <div class="alert-text">
                <h1>[ ACCESS INTERCEPTED ]</h1>
            </div>
        </div>

        <div class="section">
            <div class="section-head">// data_captured.log</div>
            <div class="section-body">
                <div class="data-row">
                    <span class="data-key">template</span>
                    <span class="data-val highlight"><?php echo $template; ?></span>
                </div>
                <div class="data-row">
                    <span class="data-key">username</span>
                    <span class="data-val"><?php echo $username ?: '<span class="dim">— empty —</span>'; ?></span>
                </div>
                <div class="data-row">
                    <span class="data-key">password</span>
                    <span class="data-val highlight"><?php echo str_repeat('●', min(strlen($password), 20)); ?> <span style="color:#484f58;font-size:0.7rem;">(<?php echo strlen($password); ?> chars)</span></span>
                </div>
                <div class="data-row">
                    <span class="data-key">ip_address</span>
                    <span class="data-val"><?php echo $ip; ?></span>
                </div>
                <div class="data-row">
                    <span class="data-key">user_agent</span>
                    <span class="data-val dim"><?php echo substr($agent, 0, 80) . (strlen($agent) > 80 ? '...' : ''); ?></span>
                </div>
            </div>
        </div>

        <div class="section">
            <div class="lessons-grid">
                    <div class="lesson-num">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        [ 01 ]
                    </div>
                    <h4>Verify the URL</h4>
                    <p>Always check the domain. Attackers use typosquatting and lookalike domains to deceive.</p>
                </div>
                <div class="lesson">
                    <div class="lesson-num">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        [ 02 ]
                    </div>
                    <h4>HTTPS ≠ Safe</h4>
                    <p>A padlock only means traffic is encrypted — not that the site is legitimate.</p>
                </div>
                <div class="lesson">
                    <div class="lesson-num">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        [ 03 ]
                    </div>
                    <h4>Resist Urgency</h4>
                    <p>Social engineering exploits fear and urgency. Slow down and verify before acting.</p>
                </div>
                <div class="lesson">
                    <div class="lesson-num">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path></svg>
                        [ 04 ]
                    </div>
                    <h4>Use a Password Manager</h4>
                    <p>Unique credentials per site prevent credential stuffing attacks across services.</p>
                </div>
            </div>
        </div>

        <div class="actions">
            <a href="<?php echo $backUrl; ?>" class="btn btn-primary">[ ↩ RETURN TO TARGET ]</a>
            <a href="/" class="btn btn-ghost">[ HOME ]</a>
        </div>

        <div class="footer-line">
            <span>FishMe</span>
            <span><?php echo date('Y-m-d H:i:s'); ?></span>
        </div>

    </div>
</div>
</body>
</html>
