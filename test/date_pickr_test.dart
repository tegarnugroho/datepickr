import 'package:flutter/material.dart';
import 'package:datepickr/datepickr.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePickr Widget & Dialogs', () {
    testWidgets('DatePickr shows selected date when provided',
        (WidgetTester tester) async {
      final selectedDateTime = DateTime(2026, 4, 15);
      DateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('date_picker_trigger'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
              selectedDateTime: selectedDateTime,
              child: const Text('Pick a date'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Pick a date'), findsOneWidget);

      await tester.tap(find.text('Pick a date'));
      await tester.pumpAndSettle();

      // Verify the day is visible
      expect(find.text('15'), findsAtLeast(1));

      // Tap OK
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result?.year, equals(2026));
      expect(result?.month, equals(4));
      expect(result?.day, equals(15));
    });

    testWidgets('DatePickr selects date when tapped',
        (WidgetTester tester) async {
      DateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('date_picker_tap'),
              initialDate: DateTime(2026, 5, 10),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              child: const Text('Pick a date'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a date'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result?.day, equals(1));
    });

    testWidgets(
        'DatePickr with month type shows dialog and selects month & year when OK tapped',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2026, 5, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('month_picker'),
              type: DatePickrType.month,
              initialDate: initialDate,
              child: const Text('Pick a month'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a month'));
      await tester.pumpAndSettle();

      // Verify dialog header displays current month & year
      expect(find.text('May 2026'), findsOneWidget);
      expect(find.text('Choose Month & Year'), findsOneWidget);

      // Verify month item exists
      expect(find.text('May'), findsOneWidget);

      // Tap OK
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(2026, 5, 1)));
    });

    testWidgets(
        'DatePickr with month type cancels when Cancel button tapped',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2026, 5, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('month_picker_cancel'),
              type: DatePickrType.month,
              initialDate: initialDate,
              child: const Text('Pick a month'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a month'));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets(
        'DatePickr with month type can toggle YearPicker, change year, select month and confirm',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2026, 5, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('month_picker_toggle_year'),
              type: DatePickrType.month,
              initialDate: initialDate,
              firstDate: DateTime(2020, 1, 1),
              lastDate: DateTime(2030, 12, 31),
              child: const Text('Pick a month'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a month'));
      await tester.pumpAndSettle();

      // Tap year in navigation bar to switch to YearPicker
      await tester.tap(find.text('2026').last);
      await tester.pumpAndSettle();

      // Verify YearPicker is visible
      expect(find.byType(YearPicker), findsOneWidget);

      // Select 2025 in YearPicker
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();

      // Now back to Month grid, select Jun (June)
      await tester.tap(find.text('Jun'));
      await tester.pumpAndSettle();

      // Tap OK
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(2025, 6, 1)));
    });

    testWidgets(
        'DatePickr with year type shows YearPicker and selects completed year',
        (WidgetTester tester) async {
      DateTime? result;
      final now = DateTime.now();
      final completedYear = now.year - 1;
      final initialDate = DateTime(completedYear, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('year_picker'),
              type: DatePickrType.year,
              initialDate: initialDate,
              child: const Text('Pick a year'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a year'));
      await tester.pumpAndSettle();

      expect(find.text('$completedYear'), findsNWidgets(2));
      expect(find.text('Choose Year'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(completedYear, 1, 1)));
    });

    testWidgets(
        'DatePickr with year type disables current year when onlyCompletedYears is true',
        (WidgetTester tester) async {
      DateTime? result;
      final now = DateTime.now();
      final initialDate = DateTime(now.year, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('unfinished_year_picker'),
              type: DatePickrType.year,
              onlyCompletedYears: true,
              initialDate: initialDate,
              child: const Text('Pick a year'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a year'));
      await tester.pumpAndSettle();

      final completedYear = now.year - 1;
      expect(find.text('$completedYear'), findsNWidgets(2));

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(completedYear, 1, 1)));
    });

    testWidgets(
        'DatePickr supports custom confirmText, cancelText, and subTitle',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2026, 3, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('custom_labels_picker'),
              type: DatePickrType.month,
              initialDate: initialDate,
              subTitle: 'Custom Subtitle',
              confirmText: 'Done',
              cancelText: 'Dismiss',
              child: const Text('Pick a month'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a month'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Subtitle'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(2026, 3, 1)));
    });

    testWidgets(
        'DatePickr with month type and slider style renders month & year columns and selects date',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2026, 5, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('month_slider_picker'),
              type: DatePickrType.month,
              style: DatePickrStyle.slider,
              initialDate: initialDate,
              firstDate: DateTime(2020, 1, 1),
              lastDate: DateTime(2030, 12, 31),
              child: const Text('Pick a month slider'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a month slider'));
      await tester.pumpAndSettle();

      // Verify the slider pickers exist
      expect(
        find.byKey(const Key('custom_month_year_slider_month_picker')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('custom_month_year_slider_year_picker')),
        findsOneWidget,
      );

      // Verify dialog header displays May 2026
      expect(find.text('May 2026'), findsOneWidget);

      // Tap OK
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(2026, 5, 1)));
    });

    testWidgets(
        'DatePickr with month type and slider style cancels when Cancel tapped',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2026, 5, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('month_slider_cancel'),
              type: DatePickrType.month,
              style: DatePickrStyle.slider,
              initialDate: initialDate,
              child: const Text('Pick a month slider'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a month slider'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets(
        'DatePickr with year type and slider style renders year slider and selects year',
        (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2025, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              key: const Key('year_slider_picker'),
              type: DatePickrType.year,
              style: DatePickrStyle.slider,
              initialDate: initialDate,
              child: const Text('Pick a year slider'),
              onSelected: (DateTime dateTime) {
                result = dateTime;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick a year slider'));
      await tester.pumpAndSettle();

      // Verify year slider picker exists
      expect(
        find.byKey(const Key('custom_year_slider_picker')),
        findsOneWidget,
      );

      // Verify year 2025 in header
      expect(find.text('2025'), findsAtLeast(1));

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(DateTime(2025, 1, 1)));
    });

    testWidgets(
        'DatePickrYearDialog preserves scroll offset when changing selected years',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDatePickrYear(
                      context: context,
                      initialDate: DateTime(2024, 1, 1),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: DateTime(2030, 12, 31),
                    );
                  },
                  child: const Text('Open Year Picker'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Year Picker'));
      await tester.pumpAndSettle();

      // Find the scrollable GridView
      final scrollableFinder = find.byType(Scrollable);
      expect(scrollableFinder, findsOneWidget);

      final scrollableState = tester.state<ScrollableState>(scrollableFinder);
      final initialOffset = scrollableState.position.pixels;

      // Tap another visible year (e.g. 2023 or 2022)
      if (find.text('2023').evaluate().isNotEmpty) {
        await tester.tap(find.text('2023'));
        await tester.pumpAndSettle();

        // Offset should not have jumped to a different position
        expect(scrollableState.position.pixels, equals(initialOffset));
      }
    });

    testWidgets('DatePickr with dateRange opens date range picker',
        (WidgetTester tester) async {
      DateTimeRange? selectedRange;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickr(
              type: DatePickrType.dateRange,
              initialDateRange: DateTimeRange(
                start: DateTime(2026, 5, 1),
                end: DateTime(2026, 5, 10),
              ),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onRangeSelected: (range) {
                selectedRange = range;
              },
              child: const Text('Pick Range'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick Range'));
      await tester.pumpAndSettle();

      // Verify date range picker is presented (Save button or calendar headers)
      expect(find.text('Save'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(selectedRange, isNotNull);
      expect(selectedRange?.start, equals(DateTime(2026, 5, 1)));
      expect(selectedRange?.end, equals(DateTime(2026, 5, 10)));
    });

    testWidgets('Backwards compatibility aliases work as expected',
        (WidgetTester tester) async {
      expect(CustomDatePicker, equals(DatePickr));
      expect(CustomDatePickerType.date, equals(DatePickrType.date));
      expect(CustomDatePickerStyle.slider, equals(DatePickrStyle.slider));
      expect(showCustomDatePicker, equals(showDatePickr));
      expect(showCustomDateRangePicker, equals(showDatePickrRange));
      expect(showCustomMonthYearPicker, equals(showDatePickrMonthYear));
      expect(showCustomYearPicker, equals(showDatePickrYear));
    });
  });
}
