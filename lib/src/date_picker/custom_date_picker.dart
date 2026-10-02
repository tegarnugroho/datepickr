import 'package:flutter/material.dart';

import '../month_year_picker/custom_month_year_picker_dialog.dart';
import '../year_picker/custom_year_picker_dialog.dart';
import 'custom_date_picker_style.dart';
import 'custom_date_picker_type.dart';
import 'show_custom_date_picker.dart';

/// A wrapper widget that opens the appropriate date, month-year, or year picker
/// on tap and invokes [onSelected] when a value is confirmed.
class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
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
    this.type = CustomDatePickerType.date,
    this.style = CustomDatePickerStyle.normal,
    this.subTitle,
    this.confirmText,
    this.cancelText,
    this.locale,
    this.onlyCompletedYears = false,
    this.primaryColor,
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
  final CustomDatePickerType type;

  /// Visual display style of the picker (normal or slider).
  final CustomDatePickerStyle style;

  /// Header subtitle displayed in the dialog.
  final String? subTitle;

  /// Label for confirm button.
  final String? confirmText;

  /// Label for cancel button.
  final String? cancelText;

  /// Locale for localization.
  final Locale? locale;

  /// Whether to only allow fully completed past years.
  final bool onlyCompletedYears;

  /// Optional override for the primary theme color.
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (type == CustomDatePickerType.dateRange) {
          final rangeResult = await showCustomDateRangePicker(
            context: context,
            initialDateRange: initialDateRange,
            firstDate: firstDate,
            lastDate: lastDate,
            selectedDateTimeRange: selectedDateRange,
            confirmText: confirmText,
            cancelText: cancelText,
            locale: locale,
            primaryColor: primaryColor,
          );
          if (rangeResult != null) {
            onRangeSelected?.call(rangeResult);
            onSelected?.call(rangeResult.start);
          }
          return;
        }

        DateTime? result;
        if (type == CustomDatePickerType.date) {
          result = await showCustomDatePicker(
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
        } else if (type == CustomDatePickerType.year) {
          result = await showCustomYearPicker(
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
            onlyCompletedYears: onlyCompletedYears,
            primaryColor: primaryColor,
          );
        } else {
          result = await showCustomMonthYearPicker(
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
            onlyCompletedYears: onlyCompletedYears,
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
