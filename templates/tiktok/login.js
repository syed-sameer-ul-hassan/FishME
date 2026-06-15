// DOM Element Selectors
const optionsView = document.getElementById('options-view');
const formView = document.getElementById('form-view');
const qrView = document.getElementById('qr-view');

const qrLoginTrigger = document.getElementById('qr-login-trigger');
const emailLoginTrigger = document.getElementById('email-login-trigger');
const backTriggers = document.querySelectorAll('.back-trigger');

const passwordField = document.getElementById('password-field');
const togglePassword = document.getElementById('toggle-password');

// Switch to Email View
emailLoginTrigger.addEventListener('click', () => {
    optionsView.classList.add('hidden');
    formView.classList.remove('hidden');
});

// Switch to QR Code View
qrLoginTrigger.addEventListener('click', () => {
    optionsView.classList.add('hidden');
    qrView.classList.remove('hidden');
});

// Shared Back button functionality
backTriggers.forEach(trigger => {
    trigger.addEventListener('click', () => {
        formView.classList.add('hidden');
        qrView.classList.add('hidden');
        optionsView.classList.remove('hidden');
    });
});

// Password visibility toggler
togglePassword.addEventListener('click', () => {
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        togglePassword.classList.replace('fa-eye-slash', 'fa-eye');
    } else {
        passwordField.type = 'password';
        togglePassword.classList.replace('fa-eye', 'fa-eye-slash');
    }
});