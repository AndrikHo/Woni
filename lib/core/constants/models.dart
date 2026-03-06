import 'package:flutter/material.dart';

// ─── MODELS ──────────────────────────────────────────────────────────────────

enum TransactionType { expense, income }
enum TransactionSource { manual, ai, shift, receipt }
enum TransactionScope { personal, family }

class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.occurredAt,
    this.source = TransactionSource.manual,
    this.scope = TransactionScope.personal,
    this.emoji,
    this.subcategory,
  });

  final String id;
  final String title;
  final String category;
  final String? subcategory;
  final int amount; // absolute value in KRW
  final TransactionType type;
  final DateTime occurredAt;
  final TransactionSource source;
  final TransactionScope scope;
  final String? emoji;

  int get signedAmount => type == TransactionType.income ? amount : -amount;
}

class ShiftEntry {
  const ShiftEntry({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.basePay,
    required this.bonusPay,
    this.breakMinutes = 0,
    this.hasJuyeok = false,
    this.presetId,
    this.customAmount,
  });

  final String id;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ShiftType type;
  final int basePay;
  final int bonusPay;
  final int breakMinutes;
  final bool hasJuyeok;
  final String? presetId;
  final int? customAmount;

  int get totalPay => basePay + bonusPay;

  double get hoursWorked {
    var startMin = startTime.hour * 60 + startTime.minute;
    var endMin = endTime.hour * 60 + endTime.minute;
    if (endMin <= startMin) endMin += 24 * 60;
    return (endMin - startMin - breakMinutes) / 60.0;
  }
}

enum ShiftType { regular, night, holiday, overtime, weekendOvertime }

// ─── CATEGORY META ───────────────────────────────────────────────────────────

class CategoryMeta {
  const CategoryMeta({
    required this.name,
    required this.emoji,
    required this.color,
    required this.korName,
  });
  final String name;
  final String emoji;
  final Color color;
  final String korName;
}

const Map<String, CategoryMeta> kCategories = {
  'food':      CategoryMeta(name: 'Еда',       emoji: '🍽', color: Color(0xFFFF6B6B), korName: '식비'),
  'transport': CategoryMeta(name: 'Транспорт', emoji: '🚇', color: Color(0xFF4F8EF7), korName: '교통'),
  'shopping':  CategoryMeta(name: 'Шопинг',    emoji: '🛍', color: Color(0xFF34C579), korName: '쇼핑'),
  'health':    CategoryMeta(name: 'Здоровье',  emoji: '💊', color: Color(0xFFFF6B6B), korName: '의료'),
  'housing':   CategoryMeta(name: 'Жильё',     emoji: '🏠', color: Color(0xFF7B6EF6), korName: '주거'),
  'utilities': CategoryMeta(name: 'ЖКХ',       emoji: '💡', color: Color(0xFF4F8EF7), korName: '공과금'),
  'leisure':   CategoryMeta(name: 'Досуг',     emoji: '❤️', color: Color(0xFFFF6B6B), korName: '여가'),
  'salary':    CategoryMeta(name: 'Зарплата',  emoji: '💼', color: Color(0xFF34C579), korName: '급여'),
  'mobile':    CategoryMeta(name: 'Связь',      emoji: '📱', color: Color(0xFF06B6D4), korName: '통신'),
  'other':     CategoryMeta(name: 'Прочее',    emoji: '📦', color: Color(0xFFB0B7C3), korName: '기타'),
};

final List<String> kCategoryKeys = kCategories.keys.toList();

// ─── SHIFT TYPE HELPERS ─────────────────────────────────────────────────────

String shiftTypeLabel(ShiftType type) => switch (type) {
  ShiftType.regular         => '일반',
  ShiftType.night           => '야간 ×1.5',
  ShiftType.holiday         => '휴일 ×1.5',
  ShiftType.overtime        => '연장 ×1.5',
  ShiftType.weekendOvertime => '주말연장 ×2.0',
};

String shiftTypeFull(ShiftType type) => switch (type) {
  ShiftType.regular         => '일반근무',
  ShiftType.night           => '야간수당 ×1.5',
  ShiftType.holiday         => '휴일수당 ×1.5',
  ShiftType.overtime        => '연장수당 ×1.5',
  ShiftType.weekendOvertime => '휴일+연장 ×2.0',
};

Color shiftTypeColor(ShiftType type) => switch (type) {
  ShiftType.regular         => const Color(0xFF4F8EF7),
  ShiftType.night           => const Color(0xFFF59E0B),
  ShiftType.holiday         => const Color(0xFFFF6B6B),
  ShiftType.overtime        => const Color(0xFF7B6EF6),
  ShiftType.weekendOvertime => const Color(0xFFFF6B6B),
};

// ─── FORMATTING ─────────────────────────────────────────────────────────────

String fmtKRW(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
  return n.toString();
}

String fmtKRWFull(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

String relDate(DateTime dt) {
  final diff = DateTime.now().difference(dt).inDays;
  if (diff == 0) return '오늘';
  if (diff == 1) return '어제';
  return '${diff}일 전';
}

String pad2(int n) => n.toString().padLeft(2, '0');

// ─── DUMMY DATA ───────────────────────────────────────────────────────────────

final kDummyTransactions = [
  Transaction(
    id: '1', title: 'Starbucks', category: 'food',
    amount: 4500, type: TransactionType.expense,
    occurredAt: DateTime.now(), source: TransactionSource.ai, emoji: '☕',
  ),
  Transaction(
    id: '2', title: '근무 수당 · 09–18', category: 'salary',
    amount: 92400, type: TransactionType.income,
    occurredAt: DateTime.now().subtract(const Duration(days: 1)),
    source: TransactionSource.shift, emoji: '💼',
  ),
  Transaction(
    id: '3', title: 'T-Money 교통', category: 'transport',
    amount: 1450, type: TransactionType.expense,
    occurredAt: DateTime.now().subtract(const Duration(days: 1)),
    source: TransactionSource.manual, emoji: '🚇',
  ),
  Transaction(
    id: '4', title: '편의점 영수증', category: 'food',
    amount: 8200, type: TransactionType.expense,
    occurredAt: DateTime.now().subtract(const Duration(days: 2)),
    source: TransactionSource.receipt, emoji: '🧾',
  ),
  Transaction(
    id: '5', title: '쿠팡 주문', category: 'shopping',
    amount: 34900, type: TransactionType.expense,
    occurredAt: DateTime.now().subtract(const Duration(days: 3)),
    source: TransactionSource.ai, emoji: '📦',
  ),
];

// ─── DASHBOARD BLOCKS ────────────────────────────────────────────────────────

enum BlockType { financialTips, quickAI, planner }

class DashboardBlock {
  const DashboardBlock({
    required this.id,
    required this.type,
    this.isVisible = true,
  });

  final String id;
  final BlockType type;
  final bool isVisible;

  DashboardBlock copyWith({bool? isVisible}) => DashboardBlock(
        id: id,
        type: type,
        isVisible: isVisible ?? this.isVisible,
      );
}

// ─── PLANNER ─────────────────────────────────────────────────────────────────

class PlannerItem {
  const PlannerItem({
    required this.id,
    required this.text,
    required this.createdAt,
    this.isDone = false,
    this.isStarred = false,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final bool isDone;
  final bool isStarred;

  PlannerItem copyWith({String? text, bool? isDone, bool? isStarred}) => PlannerItem(
        id: id,
        text: text ?? this.text,
        createdAt: createdAt,
        isDone: isDone ?? this.isDone,
        isStarred: isStarred ?? this.isStarred,
      );
}

// ─── EXPENSE CATEGORIES (mutable, user-editable) ─────────────────────────────

class ExpenseCategory {
  ExpenseCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.korName,
    this.isFixed = false,
    this.fixedAmount,
    List<ExpenseSubcategory>? subcategories,
  }) : subcategories = subcategories ?? [];

  final String id;
  final String name;
  final String emoji;
  final Color color;
  final String korName;
  final bool isFixed;
  final int? fixedAmount; // null = normal category, non-null = auto-included monthly
  final List<ExpenseSubcategory> subcategories;

  ExpenseCategory copyWith({
    String? name,
    String? emoji,
    Color? color,
    String? korName,
    bool? isFixed,
    int? fixedAmount,
    bool clearFixedAmount = false,
    List<ExpenseSubcategory>? subcategories,
  }) {
    return ExpenseCategory(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      korName: korName ?? this.korName,
      isFixed: isFixed ?? this.isFixed,
      fixedAmount: clearFixedAmount ? null : (fixedAmount ?? this.fixedAmount),
      subcategories: subcategories ?? this.subcategories,
    );
  }
}

class ExpenseSubcategory {
  const ExpenseSubcategory({
    required this.id,
    required this.name,
    required this.korName,
  });

  final String id;
  final String name;
  final String korName;
}

// ─── CARRY-OVER MODE ─────────────────────────────────────────────────────────

enum CarryOverMode { auto, manual, byBillingDate }

// ─── PAY MODE ────────────────────────────────────────────────────────────────

enum PayMode { hourly, fixedMonthly, fixedDaily, manualDaily }

// ─── SHIFT PRESETS ───────────────────────────────────────────────────────────

class ShiftPreset {
  const ShiftPreset({
    required this.id,
    required this.name,
    this.emoji = '',
    required this.color,
    required this.defaultStart,
    required this.defaultEnd,
    this.shiftType = ShiftType.regular,
    this.breakMinutes = 60,
    this.hourlyRate = 10030,
    this.overtimeMultiplier = 1.5,
    this.nightBonusStart = const TimeOfDay(hour: 22, minute: 0),
    this.nightBonusEnd = const TimeOfDay(hour: 6, minute: 0),
    this.nightMultiplier = 0.5,
    this.fixedDailyAmount,
    this.payMode = PayMode.hourly,
    this.fixedMonthlyAmount,
  });

  final String id;
  final String name;
  final String emoji;
  final Color color;
  final TimeOfDay defaultStart;
  final TimeOfDay defaultEnd;
  final ShiftType shiftType;
  final int breakMinutes;
  final int hourlyRate;
  final double overtimeMultiplier;
  final TimeOfDay nightBonusStart;
  final TimeOfDay nightBonusEnd;
  final double nightMultiplier;
  final int? fixedDailyAmount;
  final PayMode payMode;
  final int? fixedMonthlyAmount;

  ShiftPreset copyWith({
    String? name,
    String? emoji,
    Color? color,
    TimeOfDay? defaultStart,
    TimeOfDay? defaultEnd,
    ShiftType? shiftType,
    int? breakMinutes,
    int? hourlyRate,
    double? overtimeMultiplier,
    TimeOfDay? nightBonusStart,
    TimeOfDay? nightBonusEnd,
    double? nightMultiplier,
    int? fixedDailyAmount,
    bool clearFixedAmount = false,
    PayMode? payMode,
    int? fixedMonthlyAmount,
    bool clearFixedMonthly = false,
  }) {
    return ShiftPreset(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      defaultStart: defaultStart ?? this.defaultStart,
      defaultEnd: defaultEnd ?? this.defaultEnd,
      shiftType: shiftType ?? this.shiftType,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      overtimeMultiplier: overtimeMultiplier ?? this.overtimeMultiplier,
      nightBonusStart: nightBonusStart ?? this.nightBonusStart,
      nightBonusEnd: nightBonusEnd ?? this.nightBonusEnd,
      nightMultiplier: nightMultiplier ?? this.nightMultiplier,
      fixedDailyAmount: clearFixedAmount ? null : (fixedDailyAmount ?? this.fixedDailyAmount),
      payMode: payMode ?? this.payMode,
      fixedMonthlyAmount: clearFixedMonthly ? null : (fixedMonthlyAmount ?? this.fixedMonthlyAmount),
    );
  }
}

final kDefaultPresets = [
  ShiftPreset(
    id: 'preset_day',
    name: 'Дневная',
    color: const Color(0xFF4F8EF7),
    shiftType: ShiftType.regular,
    payMode: PayMode.hourly,
    defaultStart: const TimeOfDay(hour: 9, minute: 0),
    defaultEnd: const TimeOfDay(hour: 18, minute: 0),
  ),
  ShiftPreset(
    id: 'preset_night',
    name: 'Ночная',
    color: const Color(0xFFF59E0B),
    shiftType: ShiftType.night,
    payMode: PayMode.hourly,
    defaultStart: const TimeOfDay(hour: 22, minute: 0),
    defaultEnd: const TimeOfDay(hour: 6, minute: 0),
  ),
  ShiftPreset(
    id: 'preset_overtime',
    name: 'Переработка',
    color: const Color(0xFF7B6EF6),
    shiftType: ShiftType.overtime,
    payMode: PayMode.hourly,
    defaultStart: const TimeOfDay(hour: 18, minute: 0),
    defaultEnd: const TimeOfDay(hour: 22, minute: 0),
    breakMinutes: 0,
  ),
];

// ─── DUMMY DATA ───────────────────────────────────────────────────────────────

final kDummyShifts = [
  ShiftEntry(
    id: 's1',
    date: DateTime(2026, 2, 26),
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 18, minute: 0),
    type: ShiftType.regular,
    basePay: 92400,
    bonusPay: 0,
    hasJuyeok: true,
  ),
  ShiftEntry(
    id: 's2',
    date: DateTime(2026, 2, 25),
    startTime: const TimeOfDay(hour: 22, minute: 0),
    endTime: const TimeOfDay(hour: 6, minute: 0),
    type: ShiftType.night,
    basePay: 92400,
    bonusPay: 46200,
    hasJuyeok: false,
  ),
  ShiftEntry(
    id: 's3',
    date: DateTime(2026, 2, 22),
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 21, minute: 0),
    type: ShiftType.weekendOvertime,
    basePay: 92400,
    bonusPay: 129000,
    hasJuyeok: false,
  ),
];
