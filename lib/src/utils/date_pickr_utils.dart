import 'dart:math';

import 'package:intl/intl.dart';

import '../date_picker/date_pickr_type.dart';

/// Utility methods for Month & Year pickers calculations and localization.
class DatePickrUtils {
  const DatePickrUtils._();

  /// Default short month names in English (fallback).
  static const List<String> fallbackShortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Default full month names in English (fallback).
  static const List<String> fallbackFullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Returns 12 localized short month names for [locale], or [fallbackShortMonths] if unavailable.
  static List<String> getShortMonths(String? locale) {
    try {
      final m = DateFormat(null, locale).dateSymbols.SHORTMONTHS;
      return m.length >= 12 ? m.sublist(0, 12) : m;
    } catch (_) {
      return fallbackShortMonths;
    }
  }

  /// Returns 12 localized full month names for [locale], or [fallbackFullMonths] if unavailable.
  static List<String> getFullMonths(String? locale) {
    try {
      final m = DateFormat(null, locale).dateSymbols.MONTHS;
      return m.length >= 12 ? m.sublist(0, 12) : m;
    } catch (_) {
      return fallbackFullMonths;
    }
  }

  /// Checks if [month] is outside the [firstDate] and [lastDate] boundary for [selectedYear].
  static bool isMonthDisabled({
    required int month,
    required int selectedYear,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    if (selectedYear < firstDate.year || selectedYear > lastDate.year) {
      return true;
    }
    if (selectedYear == firstDate.year && month < firstDate.month) {
      return true;
    }
    if (selectedYear == lastDate.year && month > lastDate.month) {
      return true;
    }
    return false;
  }

  /// Checks if [year] is disabled according to picker boundaries and options.
  static bool isYearDisabled({
    required int year,
    required DatePickrType type,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? explicitLastDate,
    bool onlyCompletedYears = false,
  }) {
    final maxYear = getTargetValidYear(
      currentYear: year,
      type: type,
      firstDate: firstDate,
      lastDate: lastDate,
      explicitLastDate: explicitLastDate,
      onlyCompletedYears: onlyCompletedYears,
    );
    return year < firstDate.year || year > maxYear;
  }

  /// Computes the valid target year within allowed ranges.
  static int getTargetValidYear({
    required int currentYear,
    required DatePickrType type,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? explicitLastDate,
    bool onlyCompletedYears = false,
  }) {
    final now = DateTime.now();
    final maxYear = (type == DatePickrType.year && onlyCompletedYears)
        ? min(explicitLastDate?.year ?? now.year - 1, now.year - 1)
        : (explicitLastDate?.year ?? lastDate.year);
    return currentYear.clamp(firstDate.year, maxYear);
  }

  /// Computes the valid target month within allowed bounds for [selectedYear].
  static int getTargetValidMonth({
    required int currentMonth,
    required int selectedYear,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    final minMonth = selectedYear == firstDate.year ? firstDate.month : 1;
    final maxMonth = selectedYear == lastDate.year ? lastDate.month : 12;
    return currentMonth.clamp(minMonth, maxMonth);
  }
}

/// Backwards compatibility alias for [DatePickrUtils].
typedef CustomMonthYearPickerUtils = DatePickrUtils;
