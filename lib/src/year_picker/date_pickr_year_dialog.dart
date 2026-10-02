import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../date_picker/date_pickr_style.dart';
import 'date_pickr_year_grid.dart';

/// Shows a dialog for picking a year.
Future<DateTime?> showDatePickrYear({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? selectedDateTime,
  DatePickrStyle style = DatePickrStyle.normal,
  String? subTitle,
  String? confirmText,
  String? cancelText,
  Locale? locale,
  bool onlyCompletedYears = false,
  Color? primaryColor,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return DatePickrYearDialog(
        initialDate: initialDate ?? DateTime.now(),
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
    },
  );
}

/// Backwards compatibility alias for [showDatePickrYear].
const showCustomYearPicker = showDatePickrYear;

/// Dialog widget for year selection.
class DatePickrYearDialog extends StatefulWidget {
  const DatePickrYearDialog({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectedDateTime,
    this.style = DatePickrStyle.normal,
    this.subTitle,
    this.confirmText,
    this.cancelText,
    this.locale,
    this.onlyCompletedYears = false,
    this.primaryColor,
  });

  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? selectedDateTime;
  final DatePickrStyle style;
  final String? subTitle;
  final String? confirmText;
  final String? cancelText;
  final Locale? locale;
  final bool onlyCompletedYears;
  final Color? primaryColor;

  @override
  State<DatePickrYearDialog> createState() => _DatePickrYearDialogState();
}

/// Backwards compatibility alias for [DatePickrYearDialog].
typedef CustomYearPickerDialog = DatePickrYearDialog;

class _DatePickrYearDialogState extends State<DatePickrYearDialog> {
  late final ValueNotifier<DateTime> _selectedDateNotifier;
  late DateTime _resolvedFirstDate;
  late DateTime _resolvedLastDate;
  FixedExtentScrollController? _yearScrollController;

  static const Size _portraitDialogSizeM2 = Size(330.0, 518.0);
  static const Size _portraitDialogSizeM3 = Size(360.0, 568.0);
  static const Size _landscapeDialogSize = Size(496.0, 346.0);

  Color _primary(BuildContext context) =>
      widget.primaryColor ?? Theme.of(context).colorScheme.primary;

  Color _surface(BuildContext context) => Theme.of(context).colorScheme.surface;

  Color _onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  Color _textGrey(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  Size _dialogSize(BuildContext context) {
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final Orientation orientation = MediaQuery.orientationOf(context);
    if (widget.style == DatePickrStyle.slider) {
      return switch (orientation) {
        Orientation.portrait => const Size(340.0, 380.0),
        Orientation.landscape => _landscapeDialogSize,
      };
    }
    return switch (orientation) {
      Orientation.portrait =>
        useMaterial3 ? _portraitDialogSizeM3 : _portraitDialogSizeM2,
      Orientation.landscape => _landscapeDialogSize,
    };
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final effectiveSelected = widget.selectedDateTime ?? widget.initialDate;

    _resolvedFirstDate =
        widget.firstDate ?? DateTime(effectiveSelected.year - 100, 1, 1);

    final DateTime defaultLastDate = widget.onlyCompletedYears
        ? DateTime(now.year - 1, 12, 31)
        : (effectiveSelected.year > now.year
            ? DateTime(effectiveSelected.year, 12, 31)
            : DateTime(now.year, 12, 31));

    DateTime targetLastDate = widget.lastDate ?? defaultLastDate;
    if (widget.onlyCompletedYears) {
      final completedYearEnd = DateTime(now.year - 1, 12, 31);
      if (targetLastDate.isAfter(completedYearEnd)) {
        targetLastDate = completedYearEnd;
      }
    }

    if (targetLastDate.isBefore(_resolvedFirstDate)) {
      targetLastDate = _resolvedFirstDate;
    }
    _resolvedLastDate = targetLastDate;

    DateTime initial = effectiveSelected;
    if (initial.isBefore(_resolvedFirstDate)) {
      initial = _resolvedFirstDate;
    }
    if (initial.isAfter(_resolvedLastDate)) {
      initial = _resolvedLastDate;
    }
    _selectedDateNotifier = ValueNotifier<DateTime>(initial);

    if (widget.style == DatePickrStyle.slider) {
      final maxIndex =
          math.max<int>(0, _resolvedLastDate.year - _resolvedFirstDate.year);
      final initialYearIndex =
          (initial.year - _resolvedFirstDate.year).clamp(0, maxIndex);
      _yearScrollController = FixedExtentScrollController(
        initialItem: initialYearIndex.toInt(),
      );
    }
  }

  @override
  void dispose() {
    _selectedDateNotifier.dispose();
    _yearScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = _dialogSize(context);
    final orientation = MediaQuery.orientationOf(context);
    final surfaceColor = _surface(context);

    return Dialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: AnimatedContainer(
        width: size.width,
        height: size.height,
        duration: const Duration(milliseconds: 200),
        child: orientation == Orientation.landscape
            ? _buildLandscapeLayout()
            : _buildPortraitLayout(),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    final dividerColor = _textGrey(context).withOpacity(0.12);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLandscapeHeader(),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: dividerColor,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: widget.style == DatePickrStyle.slider
                    ? _buildYearSlider()
                    : _buildYearPicker(),
              ),
              _buildActions(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPortraitHeader(),
        Expanded(
          child: widget.style == DatePickrStyle.slider
              ? _buildYearSlider()
              : _buildYearPicker(),
        ),
        _buildActions(),
      ],
    );
  }

  Widget _buildLandscapeHeader() {
    final primaryColor = _primary(context);
    final textColor = _onSurface(context);
    final subtitleColor = _textGrey(context);

    return Container(
      width: 152.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subTitle ?? 'Choose Year',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<DateTime>(
            valueListenable: _selectedDateNotifier,
            builder: (context, selectedDate, _) => Text(
              '${selectedDate.year}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.calendar_month_outlined,
            size: 24.0,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitHeader() {
    final primaryColor = _primary(context);
    final textColor = _onSurface(context);
    final subtitleColor = _textGrey(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subTitle ?? 'Choose Year',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4.0),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedDateNotifier,
                  builder: (context, selectedDate, _) => Text(
                    '${selectedDate.year}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 20.0,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearPicker() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDateNotifier,
      builder: (context, selectedDate, _) {
        return DatePickrYearGrid(
          firstDate: _resolvedFirstDate,
          lastDate: _resolvedLastDate,
          selectedDate: selectedDate,
          primaryColor: _primary(context),
          onChanged: (DateTime dateTime) {
            _selectedDateNotifier.value = dateTime;
          },
        );
      },
    );
  }

  Widget _buildYearSlider() {
    final primaryColor = _primary(context);
    final textColor = _onSurface(context);
    final yearCount =
        math.max(1, _resolvedLastDate.year - _resolvedFirstDate.year + 1);

    return CupertinoPicker.builder(
      key: const Key('custom_year_slider_picker'),
      scrollController: _yearScrollController,
      itemExtent: 44.0,
      squeeze: 1.25,
      diameterRatio: 1.2,
      selectionOverlay: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: primaryColor.withOpacity(0.25),
            width: 1.0,
          ),
        ),
      ),
      childCount: yearCount,
      onSelectedItemChanged: (int index) {
        final year = _resolvedFirstDate.year + index;
        _selectedDateNotifier.value = DateTime(
          year,
          _selectedDateNotifier.value.month,
          _selectedDateNotifier.value.day,
        );
      },
      itemBuilder: (context, index) {
        final year = _resolvedFirstDate.year + index;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _yearScrollController?.animateToItem(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          },
          child: Center(
            child: ValueListenableBuilder<DateTime>(
              valueListenable: _selectedDateNotifier,
              builder: (context, selectedDate, _) {
                final isSelected = year == selectedDate.year;
                return Text(
                  '$year',
                  style: TextStyle(
                    fontSize: isSelected ? 19.0 : 16.0,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color:
                        isSelected ? primaryColor : textColor.withOpacity(0.65),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions() {
    final primaryColor = _primary(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            key: const Key('custom_month_year_picker_cancel_button'),
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(
              widget.cancelText ?? 'Cancel',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            key: const Key('custom_month_year_picker_confirm_button'),
            onPressed: () {
              Navigator.of(context).pop(
                DateTime(_selectedDateNotifier.value.year, 1, 1),
              );
            },
            child: Text(
              widget.confirmText ?? 'OK',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
