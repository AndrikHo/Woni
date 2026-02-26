import 'dart:math';
import 'package:flutter/material.dart';
import 'package:woni/core/constants/models.dart';
import 'package:woni/core/l10n/strings.dart';

// ─── APP STATE ──────────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  AppLocale locale = AppLocale.ru;

  final List<Transaction> transactions = List.of(kDummyTransactions);
  final List<ShiftEntry> shifts = List.of(kDummyShifts);

  // Dashboard blocks (ordered — display order)
  final List<DashboardBlock> dashboardBlocks = [
    const DashboardBlock(id: 'block_tips', type: BlockType.financialTips),
    const DashboardBlock(id: 'block_ai', type: BlockType.quickAI),
    const DashboardBlock(id: 'block_planner', type: BlockType.planner),
  ];

  // Planner items
  final List<PlannerItem> plannerItems = [];

  // Mutable expense categories (seeded from kCategories)
  late final List<ExpenseCategory> expenseCategories = _seedCategories();

  // Shift presets
  final List<ShiftPreset> shiftPresets = List.of(kDefaultPresets);

  int _nextId = 100;
  String nextId() => '${_nextId++}';

  // ── Locale ──────────────────────────────────────────────────────────────

  void setLocale(AppLocale l) {
    locale = l;
    S.setLocale(l);
    notifyListeners();
  }

  // ── Theme ───────────────────────────────────────────────────────────────

  void toggleTheme() {
    themeMode =
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ── Manual income override ─────────────────────────────────────────────

  int? manualIncome; // null = use computed from transactions

  void setManualIncome(int? value) {
    manualIncome = value;
    notifyListeners();
  }

  // ── Computed ────────────────────────────────────────────────────────────

  int get monthIncome => manualIncome ?? transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  int get monthExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  int get monthBalance => monthIncome - monthExpense;

  int get shiftMonthTotal => shifts.fold(0, (sum, s) => sum + s.totalPay);

  Map<String, int> get categoryTotals {
    final map = <String, int>{};
    for (final tx in transactions) {
      map[tx.category] = (map[tx.category] ?? 0) + tx.amount;
    }
    return map;
  }

  // ── Transactions ───────────────────────────────────────────────────────

  void addTransaction(Transaction tx) {
    transactions.insert(0, tx);
    notifyListeners();
  }

  void removeTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ── Shifts ─────────────────────────────────────────────────────────────

  void addShift(ShiftEntry shift) {
    shifts.insert(0, shift);
    // Auto-create linked income transaction
    transactions.insert(
      0,
      Transaction(
        id: 'tx_shift_${shift.id}',
        title:
            '${S.shifts} · ${_pad(shift.startTime.hour)}:${_pad(shift.startTime.minute)}–${_pad(shift.endTime.hour)}:${_pad(shift.endTime.minute)}',
        category: 'salary',
        amount: shift.totalPay,
        type: TransactionType.income,
        occurredAt: shift.date,
        source: TransactionSource.shift,
        emoji: '💼',
      ),
    );
    notifyListeners();
  }

  void removeShift(String id) {
    shifts.removeWhere((s) => s.id == id);
    transactions.removeWhere((t) => t.id == 'tx_shift_$id');
    notifyListeners();
  }

  // ── Dashboard Blocks ───────────────────────────────────────────────────

  void reorderBlocks(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final block = dashboardBlocks.removeAt(oldIndex);
    dashboardBlocks.insert(newIndex, block);
    notifyListeners();
  }

  void toggleBlockVisibility(String blockId) {
    final i = dashboardBlocks.indexWhere((b) => b.id == blockId);
    if (i == -1) return;
    dashboardBlocks[i] =
        dashboardBlocks[i].copyWith(isVisible: !dashboardBlocks[i].isVisible);
    notifyListeners();
  }

  void removeBlock(String blockId) {
    dashboardBlocks.removeWhere((b) => b.id == blockId);
    notifyListeners();
  }

  void addBlock(BlockType type) {
    final id = 'block_${type.name}';
    final existing = dashboardBlocks.indexWhere((b) => b.id == id);
    if (existing != -1) {
      dashboardBlocks[existing] =
          dashboardBlocks[existing].copyWith(isVisible: true);
    } else {
      dashboardBlocks.add(DashboardBlock(id: id, type: type));
    }
    notifyListeners();
  }

  // ── Planner ────────────────────────────────────────────────────────────

  void addPlannerItem(String text) {
    plannerItems.insert(
      0,
      PlannerItem(
        id: 'plan_${nextId()}',
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void togglePlannerItem(String id) {
    final i = plannerItems.indexWhere((p) => p.id == id);
    if (i == -1) return;
    plannerItems[i] = plannerItems[i].copyWith(isDone: !plannerItems[i].isDone);
    notifyListeners();
  }

  void removePlannerItem(String id) {
    plannerItems.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ── Expense Categories ─────────────────────────────────────────────────

  static const _fixedCategoryIds = {'housing', 'utilities', 'mobile'};

  List<ExpenseCategory> _seedCategories() {
    return kCategories.entries
        .map(
          (e) => ExpenseCategory(
            id: e.key,
            name: e.value.name,
            emoji: e.value.emoji,
            color: e.value.color,
            korName: e.value.korName,
            isFixed: _fixedCategoryIds.contains(e.key),
          ),
        )
        .toList();
  }

  void addExpenseCategory(ExpenseCategory cat) {
    expenseCategories.add(cat);
    notifyListeners();
  }

  void removeExpenseCategory(String id) {
    expenseCategories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void addSubcategory(String categoryId, ExpenseSubcategory sub) {
    final cat = expenseCategories.firstWhere((c) => c.id == categoryId);
    cat.subcategories.add(sub);
    notifyListeners();
  }

  void removeSubcategory(String categoryId, String subId) {
    final cat = expenseCategories.firstWhere((c) => c.id == categoryId);
    cat.subcategories.removeWhere((s) => s.id == subId);
    notifyListeners();
  }

  // ── Shift Presets ──────────────────────────────────────────────────────

  void addPreset(ShiftPreset preset) {
    shiftPresets.add(preset);
    notifyListeners();
  }

  void updatePreset(ShiftPreset preset) {
    final i = shiftPresets.indexWhere((p) => p.id == preset.id);
    if (i != -1) shiftPresets[i] = preset;
    notifyListeners();
  }

  void removePreset(String id) {
    shiftPresets.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ── Reset ──────────────────────────────────────────────────────────────

  void resetAll() {
    transactions.clear();
    shifts.clear();
    plannerItems.clear();
    dashboardBlocks
      ..clear()
      ..addAll([
        const DashboardBlock(id: 'block_tips', type: BlockType.financialTips),
        const DashboardBlock(id: 'block_ai', type: BlockType.quickAI),
        const DashboardBlock(id: 'block_planner', type: BlockType.planner),
      ]);
    shiftPresets
      ..clear()
      ..addAll(kDefaultPresets);
    notifyListeners();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}

// ─── INHERITED NOTIFIER ─────────────────────────────────────────────────────

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    required AppState notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateScope>()!
        .notifier!;
  }

  static AppState read(BuildContext context) {
    return context
        .findAncestorWidgetOfExactType<AppStateScope>()!
        .notifier!;
  }
}

// ─── SIMPLE AI TEXT PARSER (simulation) ─────────────────────────────────────

class AIParsedItem {
  AIParsedItem({
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.type,
    required this.confidence,
  });

  int amount;
  String category;
  String note;
  DateTime date;
  TransactionType type;
  final double confidence;
}

class AIParser {
  static const _categoryKeywords = <String, String>{
    // Korean
    '커피': 'food', '카페': 'food', '스타벅스': 'food', '식사': 'food',
    '밥': 'food', '치킨': 'food', '편의점': 'food', '마트': 'food',
    '택시': 'transport', '버스': 'transport', '지하철': 'transport',
    '교통': 'transport',
    '쇼핑': 'shopping', '옷': 'shopping', '쿠팡': 'shopping',
    '병원': 'health', '약': 'health', '의료': 'health',
    '월급': 'salary', '급여': 'salary', '수입': 'salary',
    // Russian
    'кофе': 'food', 'еда': 'food', 'обед': 'food', 'завтрак': 'food',
    'ужин': 'food', 'продукты': 'food',
    'такси': 'transport', 'метро': 'transport', 'автобус': 'transport',
    'одежда': 'shopping', 'покупки': 'shopping',
    'аптека': 'health', 'врач': 'health',
    'зарплата': 'salary', 'доход': 'salary',
  };

  static const _incomeKeywords = [
    '월급', '급여', '수입', '보너스', 'зарплата', 'доход', 'бонус',
  ];

  static List<AIParsedItem> parse(String text) {
    if (text.trim().isEmpty) return [];
    final rng = Random();

    final amounts = RegExp(r'\d+')
        .allMatches(text)
        .map((m) => int.parse(m.group(0)!))
        .where((n) => n >= 100)
        .toList();

    if (amounts.isEmpty) return [];

    final lc = text.toLowerCase();
    DateTime date = DateTime.now();
    if (lc.contains('어제') || lc.contains('вчера') || lc.contains('yesterday')) {
      date = DateTime.now().subtract(const Duration(days: 1));
    } else if (lc.contains('그제') || lc.contains('позавчера')) {
      date = DateTime.now().subtract(const Duration(days: 2));
    }

    String category = 'other';
    String note = text.replaceAll(RegExp(r'\d+'), '').trim();
    for (final entry in _categoryKeywords.entries) {
      if (lc.contains(entry.key.toLowerCase())) {
        category = entry.value;
        note = entry.key;
        break;
      }
    }

    TransactionType type = TransactionType.expense;
    for (final kw in _incomeKeywords) {
      if (lc.contains(kw.toLowerCase())) {
        type = TransactionType.income;
        break;
      }
    }

    return amounts
        .map(
          (amt) => AIParsedItem(
            amount: amt,
            category: category,
            note: note.isEmpty ? 'other' : note,
            date: date,
            type: type,
            confidence: 0.80 + rng.nextDouble() * 0.19,
          ),
        )
        .toList();
  }
}

// ─── SHIFT PAY CALCULATOR ───────────────────────────────────────────────────

class ShiftCalculator {
  static const int defaultHourlyRate = 10030; // 2025 Korean min wage

  static ({int basePay, int bonusPay, double hours}) calculate({
    required TimeOfDay start,
    required TimeOfDay end,
    required ShiftType type,
    int breakMinutes = 0,
    int hourlyRate = defaultHourlyRate,
  }) {
    var startMin = start.hour * 60 + start.minute;
    var endMin = end.hour * 60 + end.minute;
    if (endMin <= startMin) endMin += 24 * 60;

    final totalMinutes = endMin - startMin - breakMinutes;
    if (totalMinutes <= 0) return (basePay: 0, bonusPay: 0, hours: 0);

    final totalHours = totalMinutes / 60.0;
    final baseHours = totalHours > 8 ? 8.0 : totalHours;
    final overtimeHours = totalHours > 8 ? totalHours - 8.0 : 0.0;

    final basePay = (baseHours * hourlyRate).round();
    int bonusPay = 0;

    switch (type) {
      case ShiftType.regular:
        bonusPay = (overtimeHours * hourlyRate * 0.5).round();
        break;
      case ShiftType.night:
        bonusPay = (totalHours * hourlyRate * 0.5).round();
        break;
      case ShiftType.holiday:
        bonusPay = (baseHours * hourlyRate * 0.5).round();
        break;
      case ShiftType.overtime:
        bonusPay = (overtimeHours * hourlyRate * 0.5).round();
        break;
      case ShiftType.weekendOvertime:
        bonusPay = (totalHours * hourlyRate * 1.0).round();
        break;
    }

    return (basePay: basePay, bonusPay: bonusPay, hours: totalHours);
  }

  static ShiftType detectType(TimeOfDay start, TimeOfDay end) {
    final sH = start.hour;
    final eH = end.hour;
    final overnight = eH < sH;
    if (sH >= 22 || eH <= 6 || overnight) return ShiftType.night;
    return ShiftType.regular;
  }
}
