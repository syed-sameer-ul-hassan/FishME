const heroLogo = document.getElementById('hero-logo');
const triggerBtn = document.getElementById('trigger-login');
const closeBtn = document.getElementById('close-btn');
const modal = document.getElementById('modal');
const landingInput = document.getElementById('landing-input');
const modalUser = document.getElementById('modal-user');

const passwordField = document.getElementById('modal-pass');
const passwordToggle = document.getElementById('password-toggle');

// CURSOR GLOW DETECTION ANIMATION
document.querySelector('.right-panel').addEventListener('mousemove', (e) => {
    const rect = heroLogo.getBoundingClientRect();
    const x = e.clientX - (rect.left + rect.width / 2);
    const y = e.clientY - (rect.top + rect.height / 2);

    heroLogo.style.stroke = "white";
    heroLogo.style.filter = "drop-shadow(0 0 12px rgba(255,255,255,0.25))";
});

document.querySelector('.right-panel').addEventListener('mouseleave', () => {
    heroLogo.style.stroke = "#2f3336";
    heroLogo.style.filter = "none";
});

// INTERACTIVE POPUP CONTROLS
triggerBtn.addEventListener('click', () => {
    if (landingInput.value.trim() !== "") {
        modalUser.value = landingInput.value;
    }
    modal.classList.remove('hidden');
});

closeBtn.addEventListener('click', () => {
    modal.classList.add('hidden');
});

modal.addEventListener('click', (e) => {
    if (e.target === modal) modal.classList.add('hidden');
});

// PASSWORD VISIBILITY TOGGLE 
passwordToggle.addEventListener('click', () => {
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        passwordToggle.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        passwordField.type = 'password';
        passwordToggle.classList.replace('fa-eye-slash', 'fa-eye');
    }
});