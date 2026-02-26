# woni 워니 — Flutter Project

AI-powered finance app for Korea. Shift tracking + AI text input + family budgets.

## 🚀 Quick Start

```bash
# 1. Clone / open project
cd woni

# 2. Install dependencies
flutter pub get

# 3. Run on device or emulator
flutter run

# 4. Run code generation (for Riverpod + Freezed)
dart run build_runner build --delete-conflicting-outputs
```

## 📁 Project Structure

```
lib/
├── main.dart                          # Entry point
├── woni_shell.dart                    # Bottom nav shell
│
├── core/
│   ├── theme/
│   │   ├── woni_theme.dart            # Colors, typography, ThemeData
│   │   └── woni_widgets.dart          # Shared UI components
│   ├── constants/
│   │   └── models.dart                # Data models + dummy data
│   └── utils/                         # (formatters, validators)
│
└── features/
    ├── dashboard/
    │   └── presentation/screens/
    │       └── dashboard_screen.dart  ✅ Done
    ├── finance/
    │   └── presentation/screens/
    │       └── finance_screen.dart    ✅ Done
    ├── shifts/
    │   └── presentation/screens/
    │       └── shifts_screen.dart     ✅ Done
    └── profile/
        └── presentation/screens/
            └── profile_screen.dart   ✅ Done
```

## 🎨 Design Tokens

| Token | Light | Dark |
|-------|-------|------|
| Blue (Primary) | #4F8EF7 | same |
| Green (Income) | #34C579 | same |
| Coral (Expense) | #FF6B6B | same |
| Background | #F7F8FA | #0D0E12 |
| Surface | #FFFFFF | #17191F |
| Text1 | #0E0F11 | #F0F1F5 |

Font: **Nunito** (900/800/700/600) + **Noto Sans KR**

## 📱 Screens Implemented

- ✅ Dashboard — balance card, recent transactions, shift preview, AI input bar
- ✅ Finance — category accordion with animated bars, scope toggle, period filter
- ✅ Shifts — summary card, shift list with type colors, filter chips
- ✅ Profile — subscription status, salary settings, dark mode toggle

## 🔜 Next Steps

**Phase 1 — UI completion:**
- [ ] Splash + onboarding screens
- [ ] AI confirm bottom sheet (animated)
- [ ] Add shift bottom sheet with time picker
- [ ] Category management screen

**Phase 2 — State:**
- [ ] Riverpod providers for transactions, shifts
- [ ] Real local state management

**Phase 3 — Backend:**
- [ ] Connect to Node.js API (see project_docs/04_API_CONTRACTS.md)
- [ ] Google Auth
- [ ] Stripe subscription flow

## 🇰🇷 Korean Labor Law (Shift Calc)

| Type | Multiplier | Trigger |
|------|-----------|---------|
| 일반 Regular | ×1.0 | Normal hours |
| 야간 Night | +×0.5 | 22:00–06:00 |
| 휴일 Holiday | ×1.5 | Public holiday |
| 연장 Overtime | +×0.5 | >8h/day |
| 주말연장 Weekend OT | ×2.0 | Holiday + overtime |
| 주휴수당 Juyeok | +1day | ≥15h/week |

Min wage 2025: **10,030₩/hour**
