// Woni App Localization — RU (default) / KO / EN
// To add a language: add key to AppLocale + add entries in each _t() map.

enum AppLocale { ru, ko, en }

class S {
  static AppLocale _locale = AppLocale.ru;

  static AppLocale get locale => _locale;
  static void setLocale(AppLocale l) => _locale = l;

  static String get _k => _locale.name;
  static String _t(Map<String, String> m) => m[_k] ?? m['en']!;

  // ── Navigation ──────────────────────────────────────────────────────────────
  static String get tabHome    => _t({'ru': 'Главная', 'ko': '홈', 'en': 'Home'});
  static String get tabFinance => _t({'ru': 'Финансы', 'ko': '재정', 'en': 'Finance'});
  static String get tabAccount => _t({'ru': 'Аккаунт', 'ko': '계정', 'en': 'Account'});

  // ── Home screen ─────────────────────────────────────────────────────────────
  static String get hello       => _t({'ru': 'Привет', 'ko': '안녕하세요', 'en': 'Hello'});
  static String get planner     => _t({'ru': 'Планер', 'ko': '플래너', 'en': 'Planner'});
  static String get today       => _t({'ru': 'Сегодня', 'ko': '오늘', 'en': 'Today'});
  static String get thisWeek    => _t({'ru': 'Неделя', 'ko': '이번 주', 'en': 'Week'});
  static String get all         => _t({'ru': 'Всё', 'ko': '전체', 'en': 'All'});
  static String get quickAI     => _t({'ru': 'AI ввод', 'ko': 'AI 입력', 'en': 'AI Input'});
  static String get tips        => _t({'ru': 'Советы', 'ko': '팁', 'en': 'Tips'});
  static String get addBlock    => _t({'ru': 'Добавить блок', 'ko': '블록 추가', 'en': 'Add block'});
  static String get addTask     => _t({'ru': 'Добавить задачу...', 'ko': '할 일 추가...', 'en': 'Add task...'});
  static String get nextTip     => _t({'ru': 'Следующий', 'ko': '다음', 'en': 'Next'});
  static String get noTasks     => _t({'ru': 'Нет задач', 'ko': '할 일 없음', 'en': 'No tasks'});
  static String get newTask     => _t({'ru': 'Новая задача', 'ko': '새 할 일', 'en': 'New task'});
  static String get outOf       => _t({'ru': 'из', 'ko': '중', 'en': 'of'});
  static String get completed   => _t({'ru': 'выполнено', 'ko': '완료', 'en': 'completed'});
  static String get swipeHint   => _t({'ru': 'свайп', 'ko': '스와이프', 'en': 'swipe'});
  static String get dragHint    => _t({'ru': 'перетащить', 'ko': '드래그', 'en': 'drag'});
  static String get financialTips => _t({'ru': 'Рекомендации', 'ko': '금융 팁', 'en': 'Tips'});

  // ── AI input ────────────────────────────────────────────────────────────────
  static String get aiPlaceholder => _t({
    'ru': '4500 кофе вчера...',
    'ko': '4500 커피 어제...',
    'en': '4500 coffee yesterday...',
  });
  static String get aiParsing    => _t({'ru': 'AI анализирует...', 'ko': 'AI 분석 중...', 'en': 'AI parsing...'});
  static String get aiConfirm    => _t({'ru': 'Подтвердить', 'ko': '확인', 'en': 'Confirm'});
  static String get aiCancel     => _t({'ru': 'Отмена', 'ko': '취소', 'en': 'Cancel'});
  static String get aiConfirmAll => _t({'ru': 'Подтвердить все', 'ko': '모두 확인', 'en': 'Confirm all'});
  static String get aiNoAmounts  => _t({'ru': 'Суммы не найдены', 'ko': '금액을 찾을 수 없습니다', 'en': 'No amounts found'});
  static String get confidence   => _t({'ru': 'Точность', 'ko': '정확도', 'en': 'Confidence'});

  // ── Finance ─────────────────────────────────────────────────────────────────
  static String get calendar    => _t({'ru': 'Календарь', 'ko': '캘린더', 'en': 'Calendar'});
  static String get expenses    => _t({'ru': 'Расходы', 'ko': '지출', 'en': 'Expenses'});
  static String get income      => _t({'ru': 'Доход', 'ko': '수입', 'en': 'Income'});
  static String get expense     => _t({'ru': 'Расход', 'ko': '지출', 'en': 'Expense'});
  static String get balance     => _t({'ru': 'Баланс', 'ko': '잔액', 'en': 'Balance'});
  static String get personal    => _t({'ru': 'Личный', 'ko': '개인', 'en': 'Personal'});
  static String get family      => _t({'ru': 'Семья', 'ko': '가족', 'en': 'Family'});

  // ── Calendar / Shifts ───────────────────────────────────────────────────────
  static String get shifts      => _t({'ru': 'Смены', 'ko': '근무', 'en': 'Shifts'});
  static String get addShift    => _t({'ru': 'Добавить смену', 'ko': '근무 추가', 'en': 'Add shift'});
  static String get salary      => _t({'ru': 'Зарплата', 'ko': '급여', 'en': 'Salary'});
  static String get estimatedPay => _t({'ru': 'Примерная зарплата', 'ko': '예상 급여', 'en': 'Estimated pay'});
  static String get basePay     => _t({'ru': 'Базовая', 'ko': '기본', 'en': 'Base'});
  static String get bonusPay    => _t({'ru': 'Бонус', 'ko': '보너스', 'en': 'Bonus'});
  static String get totalPay    => _t({'ru': 'Итог', 'ko': '합계', 'en': 'Total'});
  static String get shiftsCount => _t({'ru': 'Смены', 'ko': '근무', 'en': 'Shifts'});
  static String get hoursWorked => _t({'ru': 'Часы', 'ko': '시간', 'en': 'Hours'});
  static String get overtimeHours => _t({'ru': 'Переработка', 'ko': '연장', 'en': 'Overtime'});
  static String get nightHours    => _t({'ru': 'Ночные', 'ko': '야간', 'en': 'Night'});
  static String get presets     => _t({'ru': 'Пресеты', 'ko': '프리셋', 'en': 'Presets'});
  static String get presetSettings => _t({'ru': 'Настройки пресетов', 'ko': '프리셋 설정', 'en': 'Preset settings'});
  static String get juyeok      => _t({'ru': 'Отпускные', 'ko': '주휴수당', 'en': 'Weekly holiday pay'});

  // Shift types
  static String get shiftRegular  => _t({'ru': 'Дневная', 'ko': '일반', 'en': 'Regular'});
  static String get shiftNight    => _t({'ru': 'Ночная', 'ko': '야간', 'en': 'Night'});
  static String get shiftHoliday  => _t({'ru': 'Выходной', 'ko': '휴일', 'en': 'Holiday'});
  static String get shiftOvertime => _t({'ru': 'Переработка', 'ko': '연장', 'en': 'Overtime'});
  static String get shiftWeekendOT => _t({'ru': 'Вых+переработка', 'ko': '주말연장', 'en': 'Weekend OT'});

  // Preset editor
  static String get presetName   => _t({'ru': 'Название', 'ko': '이름', 'en': 'Name'});
  static String get presetIcon   => _t({'ru': 'Иконка', 'ko': '아이콘', 'en': 'Icon'});
  static String get workHours    => _t({'ru': 'Рабочие часы', 'ko': '근무 시간', 'en': 'Work hours'});
  static String get minWageKR    => _t({'ru': 'Мин. ставка (₩/час)', 'ko': '최저시급 (₩/시간)', 'en': 'Min wage (₩/hr)'});
  static String get overtimeRate => _t({'ru': 'Коэфф. переработки', 'ko': '연장 수당 배율', 'en': 'Overtime rate'});
  static String get nightShiftHrs => _t({'ru': 'Ночные часы', 'ko': '야간 시간', 'en': 'Night hours'});
  static String get nightRate    => _t({'ru': 'Коэфф. ночной', 'ko': '야간 수당 배율', 'en': 'Night rate'});
  static String get fixedDailyAmt => _t({'ru': 'Фикс. сумма/день', 'ko': '일당 고정 금액', 'en': 'Fixed daily amt'});
  static String get fixedAmtHint => _t({'ru': 'Оставьте пустым для ручного ввода', 'ko': '수동 입력시 비워두세요', 'en': 'Leave empty for manual input'});

  // Pay modes
  static String get payMode         => _t({'ru': 'Тип оплаты', 'ko': '급여 방식', 'en': 'Pay mode'});
  static String get payModeHourly   => _t({'ru': 'Почасовая', 'ko': '시급제', 'en': 'Hourly'});
  static String get payModeMonthly  => _t({'ru': 'Фикс/мес', 'ko': '월급제', 'en': 'Monthly'});
  static String get payModeDaily    => _t({'ru': 'Фикс/день', 'ko': '일당제', 'en': 'Daily'});
  static String get payModeManual   => _t({'ru': 'Вручную', 'ko': '수동', 'en': 'Manual'});
  static String get fixedMonthlyAmt => _t({'ru': 'Ежемесячная сумма', 'ko': '월급', 'en': 'Monthly amount'});
  static String get monthlyHint     => _t({'ru': 'Делится на 22 рабочих дня', 'ko': '22일 기준 나눔', 'en': 'Divided by 22 work days'});
  static String get manualEntryHint => _t({'ru': 'Сумма вводится при назначении смены в календаре', 'ko': '캘린더에서 근무 배정 시 금액 입력', 'en': 'Enter amount when assigning shift in calendar'});
  static String get from         => _t({'ru': 'с', 'ko': '부터', 'en': 'from'});
  static String get to           => _t({'ru': 'до', 'ko': '까지', 'en': 'to'});
  static String get multiplier   => _t({'ru': '×', 'ko': '×', 'en': '×'});
  static String get editPreset   => _t({'ru': 'Редактировать', 'ko': '수정', 'en': 'Edit'});
  static String get newPreset    => _t({'ru': 'Новый пресет', 'ko': '새 프리셋', 'en': 'New preset'});

  // Weekdays
  static String get mon => _t({'ru': 'Пн', 'ko': '월', 'en': 'Mo'});
  static String get tue => _t({'ru': 'Вт', 'ko': '화', 'en': 'Tu'});
  static String get wed => _t({'ru': 'Ср', 'ko': '수', 'en': 'We'});
  static String get thu => _t({'ru': 'Чт', 'ko': '목', 'en': 'Th'});
  static String get fri => _t({'ru': 'Пт', 'ko': '금', 'en': 'Fr'});
  static String get sat => _t({'ru': 'Сб', 'ko': '토', 'en': 'Sa'});
  static String get sun => _t({'ru': 'Вс', 'ko': '일', 'en': 'Su'});
  static List<String> get weekdays => [mon, tue, wed, thu, fri, sat, sun];

  // ── Expense sections ───────────────────────────────────────────────────────
  static String get mandatoryExp => _t({'ru': 'Обязательные', 'ko': '고정 지출', 'en': 'Mandatory'});
  static String get optionalExp  => _t({'ru': 'Прочие', 'ko': '변동 지출', 'en': 'Optional'});
  static String get editIncome   => _t({'ru': 'Изменить доход', 'ko': '수입 수정', 'en': 'Edit income'});
  static String get enterAmount  => _t({'ru': 'Введите сумму', 'ko': '금액 입력', 'en': 'Enter amount'});
  static String get catMobile    => _t({'ru': 'Связь', 'ko': '통신', 'en': 'Mobile'});

  // ── Categories ──────────────────────────────────────────────────────────────
  static String get addCategory => _t({'ru': 'Добавить категорию', 'ko': '카테고리 추가', 'en': 'Add category'});
  static String get deleteCategory => _t({'ru': 'Удалить категорию', 'ko': '카테고리 삭제', 'en': 'Delete category'});
  static String get subcategories  => _t({'ru': 'Подкатегории', 'ko': '하위 카테고리', 'en': 'Subcategories'});
  static String get addSubcategory => _t({'ru': 'Добавить подкатегорию', 'ko': '하위 카테고리 추가', 'en': 'Add subcategory'});
  static String get categoryName   => _t({'ru': 'Название', 'ko': '이름', 'en': 'Name'});
  static String get selectEmoji    => _t({'ru': 'Эмодзи', 'ko': '이모지', 'en': 'Emoji'});
  static String get selectColor    => _t({'ru': 'Цвет', 'ko': '색상', 'en': 'Color'});

  static String get configure     => _t({'ru': 'Настроить', 'ko': '설정', 'en': 'Configure'});
  static String get fixedAmountLabel => _t({'ru': 'Фикс. сумма', 'ko': '고정 금액', 'en': 'Fixed amount'});
  static String get fixedAmountDesc  => _t({
    'ru': 'Сумма автоматически учитывается каждый месяц',
    'ko': '매월 자동으로 포함되는 금액',
    'en': 'Amount automatically included every month',
  });
  static String get configureCat => _t({'ru': 'Настроить категорию', 'ko': '카테고리 설정', 'en': 'Configure category'});

  // Category names
  static String get catFood      => _t({'ru': 'Еда', 'ko': '식비', 'en': 'Food'});
  static String get catTransport => _t({'ru': 'Транспорт', 'ko': '교통', 'en': 'Transport'});
  static String get catShopping  => _t({'ru': 'Шопинг', 'ko': '쇼핑', 'en': 'Shopping'});
  static String get catHealth    => _t({'ru': 'Здоровье', 'ko': '의료', 'en': 'Health'});
  static String get catHousing   => _t({'ru': 'Жильё', 'ko': '주거', 'en': 'Housing'});
  static String get catUtilities => _t({'ru': 'ЖКХ', 'ko': '공과금', 'en': 'Utilities'});
  static String get catLeisure   => _t({'ru': 'Досуг', 'ko': '여가', 'en': 'Leisure'});
  static String get catSalary    => _t({'ru': 'Зарплата', 'ko': '급여', 'en': 'Salary'});
  static String get catOther     => _t({'ru': 'Прочее', 'ko': '기타', 'en': 'Other'});

  // ── Transactions ────────────────────────────────────────────────────────────
  static String get addTransaction => _t({'ru': 'Добавить запись', 'ko': '거래 추가', 'en': 'Add transaction'});
  static String get note           => _t({'ru': 'Заметка', 'ko': '메모', 'en': 'Note'});
  static String get amount         => _t({'ru': 'Сумма', 'ko': '금액', 'en': 'Amount'});
  static String get date           => _t({'ru': 'Дата', 'ko': '날짜', 'en': 'Date'});
  static String get save           => _t({'ru': 'Сохранить', 'ko': '저장', 'en': 'Save'});
  static String get cancel         => _t({'ru': 'Отмена', 'ko': '취소', 'en': 'Cancel'});
  static String get delete         => _t({'ru': 'Удалить', 'ko': '삭제', 'en': 'Delete'});
  static String get edit           => _t({'ru': 'Редактировать', 'ko': '수정', 'en': 'Edit'});
  static String get fieldRequired  => _t({'ru': 'Обязательное поле', 'ko': '필수 항목', 'en': 'Required field'});

  // ── Themes ─────────────────────────────────────────────────────────────────
  static String get themes      => _t({'ru': 'Темы', 'ko': '테마', 'en': 'Themes'});
  static String get selectTheme => _t({'ru': 'Выбрать тему', 'ko': '테마 선택', 'en': 'Select theme'});

  // ── Account ─────────────────────────────────────────────────────────────────
  static String get profile     => _t({'ru': 'Профиль', 'ko': '프로필', 'en': 'Profile'});
  static String get darkMode    => _t({'ru': 'Тёмная тема', 'ko': '다크 모드', 'en': 'Dark mode'});
  static String get language    => _t({'ru': 'Язык', 'ko': '언어', 'en': 'Language'});
  static String get resetData   => _t({'ru': 'Сбросить данные', 'ko': '데이터 초기화', 'en': 'Reset data'});
  static String get logout      => _t({'ru': 'Выйти', 'ko': '로그아웃', 'en': 'Logout'});
  static String get settings    => _t({'ru': 'Настройки', 'ko': '설정', 'en': 'Settings'});
  static String get salarySettings => _t({'ru': 'Настройки зарплаты', 'ko': '급여 설정', 'en': 'Salary settings'});
  static String get hourlyRate  => _t({'ru': 'Ставка/час', 'ko': '시급', 'en': 'Hourly rate'});
  static String get version     => _t({'ru': 'Версия', 'ko': '버전', 'en': 'Version'});
  static String get stats       => _t({'ru': 'Статистика', 'ko': '통계', 'en': 'Statistics'});
  static String get transactions => _t({'ru': 'Записи', 'ko': '거래', 'en': 'Transactions'});
  static String get notifications => _t({'ru': 'Уведомления', 'ko': '알림', 'en': 'Notifications'});

  // ── Balance carry-over ─────────────────────────────────────────────────────
  static String get carryOver         => _t({'ru': 'Перенос остатка', 'ko': '잔액 이월', 'en': 'Balance carry-over'});
  static String get carryOverAuto     => _t({'ru': 'Авто', 'ko': '자동', 'en': 'Auto'});
  static String get carryOverManual   => _t({'ru': 'Вручную', 'ko': '수동', 'en': 'Manual'});
  static String get carryOverBilling  => _t({'ru': 'По дате', 'ko': '결제일', 'en': 'By date'});
  static String get billingDay        => _t({'ru': 'День расчёта', 'ko': '결제일', 'en': 'Billing day'});
  static String get carryOverDesc     => _t({
    'ru': 'Остаток автоматически переносится на следующий месяц',
    'ko': '잔액이 자동으로 다음 달로 이월됩니다',
    'en': 'Balance automatically carries over to next month',
  });
  static String get carryOverManualDesc => _t({
    'ru': 'Нажмите кнопку для переноса остатка',
    'ko': '잔액 이월을 위해 버튼을 누르세요',
    'en': 'Press button to carry over balance',
  });
  static String get carryOverBillingDesc => _t({
    'ru': 'Расходы сбрасываются в выбранный день месяца',
    'ko': '선택한 날짜에 지출이 초기화됩니다',
    'en': 'Expenses reset on the selected day of month',
  });
  static String get transferBalance => _t({'ru': 'Перенести', 'ko': '이월', 'en': 'Transfer'});

  // ── Confirmations ───────────────────────────────────────────────────────────
  static String get confirmReset => _t({
    'ru': 'Вы уверены? Все данные будут удалены.',
    'ko': '정말 초기화하시겠습니까? 모든 데이터가 삭제됩니다.',
    'en': 'Are you sure? All data will be deleted.',
  });
  static String get yes => _t({'ru': 'Да', 'ko': '네', 'en': 'Yes'});
  static String get no  => _t({'ru': 'Нет', 'ko': '아니요', 'en': 'No'});

  // ── Shifts (for AddShiftSheet) ──────────────────────────────────────────────
  static String get startTime   => _t({'ru': 'Начало', 'ko': '시작 시간', 'en': 'Start time'});
  static String get endTime     => _t({'ru': 'Конец', 'ko': '종료 시간', 'en': 'End time'});
  static String get breakTime   => _t({'ru': 'Перерыв', 'ko': '휴식', 'en': 'Break'});
  static String get shiftType   => _t({'ru': 'Тип смены', 'ko': '근무 유형', 'en': 'Shift type'});
  static String get minutes     => _t({'ru': 'мин', 'ko': '분', 'en': 'min'});

  // ── Relative dates ──────────────────────────────────────────────────────────
  static String get relToday     => _t({'ru': 'сегодня', 'ko': '오늘', 'en': 'today'});
  static String get relYesterday => _t({'ru': 'вчера', 'ko': '어제', 'en': 'yesterday'});
  static String relDaysAgo(int d) => _t({
    'ru': '$d дн. назад',
    'ko': '${d}일 전',
    'en': '$d days ago',
  });

  // ── Onboarding ─────────────────────────────────────────────────────────────
  static String get onboardSkip     => _t({'ru': 'Пропустить', 'ko': '건너뛰기', 'en': 'Skip'});
  static String get onboardContinue => _t({'ru': 'Продолжить →', 'ko': '계속 →', 'en': 'Continue →'});
  static String get onboardStart    => _t({'ru': 'Начать →', 'ko': '시작하기 →', 'en': 'Get started →'});
  static String get onboardGoogleBtn => _t({'ru': 'Войти через Google', 'ko': 'Google로 시작하기', 'en': 'Sign in with Google'});

  static String get ob1Title => _t({'ru': 'Войди через Google', 'ko': 'Google로 시작하기', 'en': 'Sign in with Google'});
  static String get ob1Sub => _t({
    'ru': 'Контролируй расходы.\nБыстро и просто вместе с Woni.',
    'ko': '지출을 관리하세요.\nWoni와 함께 빠르고 간편하게.',
    'en': 'Control your expenses.\nQuick and simple with Woni.',
  });
  static String get ob2Title => _t({'ru': 'Выбери язык', 'ko': '언어를 선택하세요', 'en': 'Choose language'});
  static String get ob2Sub => _t({
    'ru': 'Русский · 한국어 · English\nМожно поменять в любой момент.',
    'ko': '한국어 · Русский · English\n언제든지 변경할 수 있습니다.',
    'en': 'English · 한국어 · Русский\nYou can change it anytime.',
  });
  static String get ob3Title => _t({'ru': 'Настрой зарплату', 'ko': '급여 설정', 'en': 'Set up salary'});
  static String get ob3Sub => _t({
    'ru': 'Укажи ставку или оклад.\nМы посчитаем всё автоматически.',
    'ko': '시급 또는 월급을 설정하세요.\n자동으로 계산합니다.',
    'en': 'Set your hourly rate or monthly salary.\nWe\'ll calculate everything.',
  });
  static String get ob4Title => _t({'ru': 'Первая запись', 'ko': '첫 번째 기록', 'en': 'First entry'});
  static String get ob4Sub => _t({
    'ru': 'Просто напиши текстом:\n"4500 кофе вчера" — AI сам разберёт.',
    'ko': '텍스트로 입력하세요:\n"4500 커피 어제" — AI가 분석합니다.',
    'en': 'Just type:\n"4500 coffee yesterday" — AI will parse it.',
  });
  static String get ob30daysFree => _t({'ru': '30 дней бесплатно', 'ko': '30일 무료 체험', 'en': '30 days free'});
  static String get obCardLater => _t({'ru': 'Карта только потом', 'ko': '카드는 나중에', 'en': 'Card needed later'});
  static String get obHourly  => _t({'ru': 'Почасовая', 'ko': '시급제', 'en': 'Hourly'});
  static String get obMonthly => _t({'ru': 'Месячный', 'ko': '월급제', 'en': 'Monthly'});
  static String get obManual  => _t({'ru': 'Вручную', 'ko': '수동', 'en': 'Manual'});
  static String get obTryNow  => _t({'ru': 'Попробуй сейчас', 'ko': '지금 시도해보세요', 'en': 'Try it now'});
  static String get obExamples => _t({'ru': 'Примеры:', 'ko': '예시:', 'en': 'Examples:'});
  static String get obAiUnderstood => _t({'ru': 'AI понял!', 'ko': 'AI가 이해했습니다!', 'en': 'AI understood!'});
  static String get obJuyeokCalc => _t({'ru': '주휴수당 расчёт', 'ko': '주휴수당 계산', 'en': 'Weekly holiday pay'});
  static String get obMinWageHint => _t({'ru': '2025 мин. ставка: 10,030₩/ч', 'ko': '2025 최저시급: 10,030₩/시간', 'en': '2025 min wage: 10,030₩/hr'});
  static String get obManualHint => _t({'ru': 'Вводи сумму вручную каждую смену', 'ko': '매 근무마다 수동으로 입력', 'en': 'Enter amount manually each shift'});

  // ── Splash / Auth ──────────────────────────────────────────────────────────
  static String get splashTagline1 => _t({
    'ru': 'контролируй расходы',
    'ko': '지출을 관리하세요',
    'en': 'control your expenses',
  });
  static String get splashTagline2 => _t({
    'ru': 'быстро и просто вместе с Woni',
    'ko': 'Woni와 함께 빠르고 간편하게',
    'en': 'quick and simple with Woni',
  });
  static String get authGoogleBtn => _t({
    'ru': 'Войти через Google',
    'ko': 'Google로 시작하기',
    'en': 'Sign in with Google',
  });
  static String get authBiometric => _t({
    'ru': 'Вход по Face ID / отпечатку',
    'ko': 'Face ID / 지문으로 로그인',
    'en': 'Sign in with Face ID / Fingerprint',
  });
  static String get authOr => _t({'ru': 'или', 'ko': '또는', 'en': 'or'});

  // ── Month names ─────────────────────────────────────────────────────────────
  static String monthName(int m) {
    const ru = ['', 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
                'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];
    const ko = ['', '1월', '2월', '3월', '4월', '5월', '6월',
                '7월', '8월', '9월', '10월', '11월', '12월'];
    const en = ['', 'January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'];
    return _t({'ru': ru[m], 'ko': ko[m], 'en': en[m]});
  }
}
