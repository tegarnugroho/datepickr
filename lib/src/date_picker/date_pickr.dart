import 'package:flutter/material.dart';

import '../month_year_picker/date_pickr_month_year_dialog.dart';
import '../year_picker/date_pickr_year_dialog.dart';
import 'date_pickr_style.dart';
import 'date_pickr_type.dart';
import 'show_date_pickr.dart';

/// A wrapper widget that opens the appropriate date, month-year, or year picker
/// on tap and invokes [onSelected] when a value is confirmed.
class DatePickr extends StatelessWidget {
  const DatePickr({
    super.key,
    required this.child,
    this.onSelected,
    this.onRangeSelected,
    this.selectedDateTime,
    this.initialDate,
    this.selectedDateRange,
    this.initialDateRange,
    this.firstDate,
    this.lastDate,
    this.type = DatePickrType.date,
    this.style = DatePickrStyle.normal,
    this.subTitle,
    this.confirmText,
    this.cancelText,
    this.locale,
    this.onlyCompleted = false,
    this.primaryColor,
    this.fullScreen = true,
  });

  /// The child widget that triggers the picker when tapped.
  final Widget child;

  /// Callback invoked when a single date is selected and confirmed.
  final void Function(DateTime)? onSelected;

  /// Callback invoked when a date range is selected and confirmed.
  final void Function(DateTimeRange)? onRangeSelected;

  /// Currently selected date/time.
  final DateTime? selectedDateTime;

  /// Initial date/time when picker opens.
  final DateTime? initialDate;

  /// Currently selected date range.
  final DateTimeRange? selectedDateRange;

  /// Initial date range when picker opens.
  final DateTimeRange? initialDateRange;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Type of picker to display.
  final DatePickrType type;

  /// Visual display style of the picker (normal or slider).
  final DatePickrStyle style;

  /// Header subtitle displayed in the dialog.
  final String? subTitle;

  /// Label for confirm button.
  final String? confirmText;

  /// Label for cancel button.
  final String? cancelText;

  /// Locale for localization.
  final Locale? locale;

  /// Whether to only allow fully completed past periods.
  ///
  /// For [DatePickrType.year], this disables the current ongoing year and future years.
  /// For [DatePickrType.month], this disables the current ongoing month and future months.
  final bool onlyCompleted;

  /// Optional override for the primary theme color.
  final Color? primaryColor;

  /// Whether the date range picker should open in fullscreen mode.
  ///
  /// Defaults to `true`. If set to `false`, it opens as a centered dialog.
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (type == DatePickrType.dateRange) {
          final rangeResult = await showDatePickrRange(
            context: context,
            initialDateRange: initialDateRange,
            firstDate: firstDate,
            lastDate: lastDate,
            selectedDateTimeRange: selectedDateRange,
            subTitle: subTitle,
            confirmText: confirmText,
            cancelText: cancelText,
            locale: locale,
            primaryColor: primaryColor,
            fullScreen: fullScreen,
          );
          if (rangeResult != null) {
            onRangeSelected?.call(rangeResult);
            onSelected?.call(rangeResult.start);
          }
          return;
        }

        DateTime? result;
        if (type == DatePickrType.date) {
          result = await showDatePickr(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: firstDate,
            lastDate: lastDate,
            selectedDateTime: selectedDateTime,
            confirmText: confirmText,
            cancelText: cancelText,
            locale: locale,
            primaryColor: primaryColor,
          );
        } else if (type == DatePickrType.year) {
          result = await showDatePickrYear(
            context: context,
            initialDate: selectedDateTime ?? initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            selectedDateTime: selectedDateTime,
            style: style,
            subTitle: subTitle,
            confirmText: confirmText,
            cancelText: cancelText,
            locale: locale,
            onlyCompleted: onlyCompleted,
            primaryColor: primaryColor,
          );
        } else {
          result = await showDatePickrMonthYear(
            context: context,
            initialDate: selectedDateTime ?? initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            selectedDateTime: selectedDateTime,
            type: type,
            style: style,
            subTitle: subTitle,
            confirmText: confirmText,
            cancelText: cancelText,
            locale: locale,
            onlyCompleted: onlyCompleted,
            primaryColor: primaryColor,
          );
        }

        if (result != null) {
          onSelected?.call(result);
        }
      },
      child: child,
    );
  }
}

/// Backwards compatibility alias for [DatePickr].
typedef CustomDatePicker = DatePickr;
