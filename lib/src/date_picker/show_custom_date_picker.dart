import 'package:flutter/material.dart';

/// Shows a Material Date Picker dialog.
///
/// Wraps Flutter's native [showDatePicker] while providing sensible defaults
/// and theme customization without project-specific dependencies.
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? selectedDateTime,
  Locale? locale,
  String? confirmText,
  String? cancelText,
  Color? primaryColor,
  ThemeData? theme,
  TransitionBuilder? builder,
}) {
  final now = DateTime.now();
  final effectiveInitial = selectedDateTime ?? initialDate ?? now;
  final effectiveFirst =
      firstDate ?? now.subtract(const Duration(days: 365 * 200));
  final effectiveLast = lastDate ?? now.add(const Duration(days: 365 * 200));

  return showDatePicker(
    context: context,
    initialDate: effectiveInitial,
    firstDate: effectiveFirst,
    lastDate: effectiveLast,
    locale: locale,
    confirmText: confirmText,
    cancelText: cancelText,
    builder: builder ??
        (BuildContext context, Widget? child) {
          if (theme != null) {
            return Theme(data: theme, child: child!);
          }
          if (primaryColor != null) {
            final currentTheme = Theme.of(context);
            return Theme(
              data: currentTheme.copyWith(
                colorScheme: currentTheme.colorScheme.copyWith(
                  primary: primaryColor,
                ),
              ),
              child: child!,
            );
          }
          return child!;
        },
  );
}
