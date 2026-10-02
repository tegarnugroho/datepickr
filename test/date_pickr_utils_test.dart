import 'package:datepickr/datepickr.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePickrUtils', () {
    test('getShortMonths returns 12 items fallback', () {
      final months = DatePickrUtils.getShortMonths(null);
      expect(months.length, 12);
      expect(months.first, 'Jan');
    });

    test('getFullMonths returns 12 items fallback', () {
      final months = DatePickrUtils.getFullMonths(null);
      expect(months.length, 12);
      expect(months.first, 'January');
    });

    test('isMonthDisabled respects firstDate and lastDate boundaries', () {
      final firstDate = DateTime(2025, 3, 1);
      final lastDate = DateTime(2026, 9, 30);

      // Month before firstDate month in firstDate year
      expect(
        DatePickrUtils.isMonthDisabled(
          month: 2,
          selectedYear: 2025,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
        isTrue,
      );

      // Month in bounds
      expect(
        DatePickrUtils.isMonthDisabled(
          month: 5,
          selectedYear: 2025,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
        isFalse,
      );

      // Month after lastDate month in lastDate year
      expect(
        DatePickrUtils.isMonthDisabled(
          month: 10,
          selectedYear: 2026,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
        isTrue,
      );
    });

    test(
        'isYearDisabled honors explicit bounds by default and restricts when onlyCompletedYears is true',
        () {
      final now = DateTime.now();
      final firstDate = DateTime(2020, 1, 1);
      final lastDate = DateTime(now.year, 12, 31);

      // By default (onlyCompletedYears: false), explicitLastDate permitting now.year is honored
      expect(
        DatePickrUtils.isYearDisabled(
          year: now.year,
          type: DatePickrType.year,
          firstDate: firstDate,
          lastDate: lastDate,
          explicitLastDate: now,
          onlyCompletedYears: false,
        ),
        isFalse,
      );

      // When onlyCompletedYears: true, current unfinished year is disabled even with explicitLastDate
      expect(
        DatePickrUtils.isYearDisabled(
          year: now.year,
          type: DatePickrType.year,
          firstDate: firstDate,
          lastDate: lastDate,
          explicitLastDate: now,
          onlyCompletedYears: true,
        ),
        isTrue,
      );

      // In year picker mode with onlyCompletedYears: true, past completed year is enabled
      expect(
        DatePickrUtils.isYearDisabled(
          year: now.year - 1,
          type: DatePickrType.year,
          firstDate: firstDate,
          lastDate: lastDate,
          explicitLastDate: now,
          onlyCompletedYears: true,
        ),
        isFalse,
      );
    });

    test('getTargetValidYear respects onlyCompletedYears', () {
      final now = DateTime.now();
      final firstDate = DateTime(2020, 1, 1);
      final lastDate = DateTime(now.year, 12, 31);

      // Default (onlyCompletedYears: false) allows now.year when in bounds
      final defaultTarget = DatePickrUtils.getTargetValidYear(
        currentYear: now.year,
        type: DatePickrType.year,
        firstDate: firstDate,
        lastDate: lastDate,
        explicitLastDate: now,
        onlyCompletedYears: false,
      );
      expect(defaultTarget, now.year);

      // With onlyCompletedYears: true, clamps to now.year - 1
      final completedOnlyTarget = DatePickrUtils.getTargetValidYear(
        currentYear: now.year,
        type: DatePickrType.year,
        firstDate: firstDate,
        lastDate: lastDate,
        explicitLastDate: now,
        onlyCompletedYears: true,
      );
      expect(completedOnlyTarget, now.year - 1);
    });

    test('getTargetValidMonth clamps to boundaries', () {
      final firstDate = DateTime(2025, 4, 1);
      final lastDate = DateTime(2025, 8, 31);

      final clampedLow = DatePickrUtils.getTargetValidMonth(
        currentMonth: 2,
        selectedYear: 2025,
        firstDate: firstDate,
        lastDate: lastDate,
      );
      expect(clampedLow, 4);

      final clampedHigh = DatePickrUtils.getTargetValidMonth(
        currentMonth: 11,
        selectedYear: 2025,
        firstDate: firstDate,
        lastDate: lastDate,
      );
      expect(clampedHigh, 8);
    });
  });
}
