import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A year grid picker widget that preserves scroll position when selecting years.
///
/// Unlike Flutter's default [YearPicker], this does not jump or reset the scroll
/// offset when [selectedDate] changes via user interaction.
class DatePickrYearGrid extends StatefulWidget {
  const DatePickrYearGrid({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.primaryColor,
  });

  /// Earliest selectable date.
  final DateTime firstDate;

  /// Latest selectable date.
  final DateTime lastDate;

  /// Currently selected date.
  final DateTime selectedDate;

  /// Callback when a year is selected.
  final ValueChanged<DateTime> onChanged;

  /// Primary theme color override.
  final Color? primaryColor;

  @override
  State<DatePickrYearGrid> createState() => _DatePickrYearGridState();
}

/// Backwards compatibility alias for [DatePickrYearGrid].
typedef CustomYearGridPicker = DatePickrYearGrid;

class _DatePickrYearGridState extends State<DatePickrYearGrid> {
  ScrollController? _scrollController;

  static const int _columnCount = 3;

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final totalYears =
        math.max(1, widget.lastDate.year - widget.firstDate.year + 1);
    final currentYear = DateTime.now().year;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (_scrollController == null) {
          const double paddingHorizontal = 32.0; // 16.0 * 2
          const double crossAxisSpacing = 8.0;
          const double mainAxisSpacing = 8.0;
          const double paddingVertical = 16.0; // 8.0 * 2

          final double maxWidth =
              constraints.hasBoundedWidth && constraints.maxWidth > 0
                  ? constraints.maxWidth
                  : 340.0;
          final double usableWidth = math.max(
            0.0,
            maxWidth -
                paddingHorizontal -
                (crossAxisSpacing * (_columnCount - 1)),
          );
          final double itemWidth = usableWidth / _columnCount;
          final double itemHeight = itemWidth / 2.1;
          final double rowHeight = itemHeight + mainAxisSpacing;

          final int totalRows = (totalYears + _columnCount - 1) ~/ _columnCount;
          final double totalGridHeight =
              (totalRows * rowHeight) - mainAxisSpacing + paddingVertical;
          final double viewportHeight =
              constraints.hasBoundedHeight && constraints.maxHeight > 0
                  ? constraints.maxHeight
                  : 300.0;
          final double maxScroll =
              math.max(0.0, totalGridHeight - viewportHeight);

          final int selectedIndex =
              (widget.selectedDate.year - widget.firstDate.year)
                  .clamp(0, totalYears - 1);
          final int selectedRow = selectedIndex ~/ _columnCount;

          final double targetOffset = (selectedRow * rowHeight) -
              (viewportHeight / 2) +
              (rowHeight / 2);

          final double initialOffset = targetOffset.clamp(0.0, maxScroll);

          _scrollController = ScrollController(
            initialScrollOffset: initialOffset,
          );
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnCount,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 2.1,
          ),
          itemCount: totalYears,
          itemBuilder: (context, index) {
            final year = widget.firstDate.year + index;
            final isSelected = year == widget.selectedDate.year;
            final isCurrentYear = year == currentYear;

            Color? backgroundColor;
            Color itemTextColor;
            Border? border;

            if (isSelected) {
              backgroundColor = primaryColor;
              itemTextColor = Colors.white;
            } else if (isCurrentYear) {
              backgroundColor = Colors.transparent;
              itemTextColor = primaryColor;
              border = Border.all(color: primaryColor, width: 1.0);
            } else {
              backgroundColor = Colors.transparent;
              itemTextColor = textColor;
            }

            return Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18.0),
                  onTap: () {
                    widget.onChanged(
                      DateTime(
                        year,
                        widget.selectedDate.month,
                        widget.selectedDate.day,
                      ),
                    );
                  },
                  child: Container(
                    height: 36.0,
                    width: 72.0,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(18.0),
                      border: border,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$year',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: itemTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
