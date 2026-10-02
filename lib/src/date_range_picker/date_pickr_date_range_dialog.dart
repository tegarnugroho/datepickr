import 'package:flutter/material.dart';

import '../utils/date_pickr_utils.dart';

/// Shows a custom dialog for picking a date range.
Future<DateTimeRange?> showDatePickrDateRangeDialog({
  required BuildContext context,
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
  String? subTitle,
  String? confirmText,
  String? cancelText,
  Locale? locale,
  Color? primaryColor,
  ThemeData? theme,
}) {
  final now = DateTime.now();
  final effectiveFirst =
      firstDate ?? now.subtract(const Duration(days: 365 * 200));
  final effectiveLast = lastDate ?? now.add(const Duration(days: 365 * 200));

  return showDialog<DateTimeRange>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      Widget dialog = DatePickrDateRangeDialog(
        initialDateRange: initialDateRange,
        firstDate: effectiveFirst,
        lastDate: effectiveLast,
        subTitle: subTitle,
        confirmText: confirmText,
        cancelText: cancelText,
        locale: locale,
        primaryColor: primaryColor,
      );
      if (theme != null) {
        dialog = Theme(data: theme, child: dialog);
      }
      return dialog;
    },
  );
}

/// State model for [_DatePickrDateRangeDialogState].
class _DateRangeSelectionModel extends ChangeNotifier {
  _DateRangeSelectionModel({
    required DateTime? initialStart,
    required DateTime? initialEnd,
    required this.firstDate,
    required this.lastDate,
  })  : _startDate = initialStart,
        _endDate = initialEnd,
        _displayedMonth = DateTime(
          initialStart?.year ?? DateTime.now().year,
          initialStart?.month ?? DateTime.now().month,
          1,
        );

  final DateTime firstDate;
  final DateTime lastDate;

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _displayedMonth;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateTime get displayedMonth => _displayedMonth;

  bool get hasValidRange => _startDate != null && _endDate != null;

  bool get isPrevMonthDisabled {
    final prevMonthLastDay =
        DateTime(_displayedMonth.year, _displayedMonth.month, 0);
    return prevMonthLastDay.isBefore(firstDate);
  }

  bool get isNextMonthDisabled {
    final nextMonthFirstDay =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    return nextMonthFirstDay.isAfter(lastDate);
  }

  void prevMonth() {
    if (isPrevMonthDisabled) return;
    _displayedMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    if (isNextMonthDisabled) return;
    _displayedMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    notifyListeners();
  }

  void selectDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    if (isDateDisabled(normalized)) return;

    if (_startDate == null || (_startDate != null && _endDate != null)) {
      _startDate = normalized;
      _endDate = null;
    } else {
      if (normalized.isBefore(_startDate!)) {
        _endDate = _startDate;
        _startDate = normalized;
      } else {
        _endDate = normalized;
      }
    }
    notifyListeners();
  }

  bool isDateDisabled(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final f = DateTime(firstDate.year, firstDate.month, firstDate.day);
    final l = DateTime(lastDate.year, lastDate.month, lastDate.day);
    return d.isBefore(f) || d.isAfter(l);
  }
}

/// A custom, compact dialog for picking a date range with Material 3 styling.
class DatePickrDateRangeDialog extends StatefulWidget {
  const DatePickrDateRangeDialog({
    super.key,
    this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
    this.subTitle,
    this.confirmText,
    this.cancelText,
    this.locale,
    this.primaryColor,
  });

  final DateTimeRange? initialDateRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? subTitle;
  final String? confirmText;
  final String? cancelText;
  final Locale? locale;
  final Color? primaryColor;

  @override
  State<DatePickrDateRangeDialog> createState() =>
      _DatePickrDateRangeDialogState();
}

class _DatePickrDateRangeDialogState extends State<DatePickrDateRangeDialog> {
  late final _DateRangeSelectionModel _model;

  static const Size _portraitDialogSizeM2 = Size(330.0, 520.0);
  static const Size _portraitDialogSizeM3 = Size(350.0, 530.0);
  static const Size _landscapeDialogSize = Size(520.0, 360.0);

  @override
  void initState() {
    super.initState();
    _model = _DateRangeSelectionModel(
      initialStart: widget.initialDateRange?.start,
      initialEnd: widget.initialDateRange?.end,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

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
    return switch (orientation) {
      Orientation.portrait =>
        useMaterial3 ? _portraitDialogSizeM3 : _portraitDialogSizeM2,
      Orientation.landscape => _landscapeDialogSize,
    };
  }

  String? get _effectiveLocale =>
      widget.locale?.toString() ??
      Localizations.maybeLocaleOf(context)?.toString();

  List<String> get _shortMonths =>
      DatePickrUtils.getShortMonths(_effectiveLocale);

  List<String> get _fullMonths =>
      DatePickrUtils.getFullMonths(_effectiveLocale);

  String _formatDateShort(DateTime date) {
    final monthName = _shortMonths.length >= date.month
        ? _shortMonths[date.month - 1]
        : '${date.month}';
    return '${date.day.toString().padLeft(2, '0')} $monthName ${date.year}';
  }

  String _formatMonthYear(DateTime date) {
    final name = _fullMonths.length >= date.month
        ? _fullMonths[date.month - 1]
        : '${date.month}';
    return '$name ${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPortraitHeader(),
        Expanded(
          child: Column(
            children: [
              _buildMonthNavigator(),
              const SizedBox(height: 6.0),
              _buildWeekdayHeader(),
              const SizedBox(height: 4.0),
              Expanded(child: _buildDaysGrid()),
            ],
          ),
        ),
        _buildActions(),
      ],
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
              _buildMonthNavigator(),
              const SizedBox(height: 4.0),
              _buildWeekdayHeader(),
              const SizedBox(height: 2.0),
              Expanded(child: _buildDaysGrid()),
              _buildActions(),
            ],
          ),
        ),
      ],
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
                  widget.subTitle ?? 'Select Date Range',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4.0),
                ListenableBuilder(
                  listenable: _model,
                  builder: (context, _) {
                    String title;
                    if (_model.startDate != null && _model.endDate != null) {
                      title =
                          '${_formatDateShort(_model.startDate!)} – ${_formatDateShort(_model.endDate!)}';
                    } else if (_model.startDate != null) {
                      title =
                          '${_formatDateShort(_model.startDate!)} – Select End';
                    } else {
                      title = 'Start Date – End Date';
                    }
                    return Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
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
              Icons.date_range_outlined,
              size: 20.0,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeHeader() {
    final primaryColor = _primary(context);
    final textColor = _onSurface(context);
    final subtitleColor = _textGrey(context);

    return Container(
      width: 160.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subTitle ?? 'Select Range',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          ListenableBuilder(
            listenable: _model,
            builder: (context, _) {
              if (_model.startDate != null && _model.endDate != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDateShort(_model.startDate!),
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'to',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      _formatDateShort(_model.endDate!),
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ],
                );
              }
              if (_model.startDate != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDateShort(_model.startDate!),
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Select End Date',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                );
              }
              return Text(
                'Start – End',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              );
            },
          ),
          const Spacer(),
          Icon(
            Icons.date_range_outlined,
            size: 24.0,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator() {
    final textColor = _onSurface(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListenableBuilder(
        listenable: _model,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _model.isPrevMonthDisabled ? null : _model.prevMonth,
                color: textColor,
                disabledColor: _textGrey(context).withOpacity(0.3),
                tooltip: 'Previous month',
              ),
              Text(
                _formatMonthYear(_model.displayedMonth),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _model.isNextMonthDisabled ? null : _model.nextMonth,
                color: textColor,
                disabledColor: _textGrey(context).withOpacity(0.3),
                tooltip: 'Next month',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final subtitleColor = _textGrey(context);
    const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDaysGrid() {
    final primaryColor = _primary(context);
    final textColor = _onSurface(context);
    final subtitleColor = _textGrey(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListenableBuilder(
        listenable: _model,
        builder: (context, _) {
          final year = _model.displayedMonth.year;
          final month = _model.displayedMonth.month;

          // Day of week for 1st of month: DateTime.weekday returns 1 (Mon) to 7 (Sun)
          // We align Sunday as column 0:
          final firstDayOfWeek =
              DateTime(year, month, 1).weekday % 7; // 0=Sun, 1=Mon...
          final daysInMonth = DateTime(year, month + 1, 0).day;
          final totalCells = firstDayOfWeek + daysInMonth;
          final totalRows = (totalCells / 7).ceil();

          return LayoutBuilder(
            builder: (context, constraints) {
              final cellHeight =
                  (constraints.maxHeight / totalRows).clamp(32.0, 42.0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(totalRows, (rowIndex) {
                  return SizedBox(
                    height: cellHeight,
                    child: Row(
                      children: List.generate(7, (colIndex) {
                        final cellIndex = (rowIndex * 7) + colIndex;
                        if (cellIndex < firstDayOfWeek ||
                            cellIndex >= totalCells) {
                          return const Expanded(child: SizedBox());
                        }

                        final day = cellIndex - firstDayOfWeek + 1;
                        final date = DateTime(year, month, day);
                        final isDisabled = _model.isDateDisabled(date);
                        final isToday = _isSameDay(date, DateTime.now());

                        final isStart = _model.startDate != null &&
                            _isSameDay(date, _model.startDate!);
                        final isEnd = _model.endDate != null &&
                            _isSameDay(date, _model.endDate!);
                        final isRangeSelected = _model.hasValidRange &&
                            !_isSameDay(_model.startDate!, _model.endDate!);

                        final isInRange = isRangeSelected &&
                            date.isAfter(_model.startDate!) &&
                            date.isBefore(_model.endDate!);

                        // Background ribbon shape for range selection
                        Widget? rangeRibbon;
                        if (isInRange) {
                          // Connects left and right completely
                          final isRowStart = colIndex == 0 || day == 1;
                          final isRowEnd = colIndex == 6 || day == daysInMonth;
                          rangeRibbon = Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.18),
                              borderRadius: BorderRadius.horizontal(
                                left: isRowStart
                                    ? const Radius.circular(18.0)
                                    : Radius.zero,
                                right: isRowEnd
                                    ? const Radius.circular(18.0)
                                    : Radius.zero,
                              ),
                            ),
                          );
                        } else if (isStart && isRangeSelected) {
                          // Half ribbon to the right
                          rangeRibbon = Align(
                            alignment: Alignment.centerRight,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Container(
                                color: primaryColor.withOpacity(0.18),
                              ),
                            ),
                          );
                        } else if (isEnd && isRangeSelected) {
                          // Half ribbon to the left
                          rangeRibbon = Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Container(
                                color: primaryColor.withOpacity(0.18),
                              ),
                            ),
                          );
                        }

                        // Day circle color & text style
                        final isCircleActive = isStart || isEnd;
                        final Color circleColor = isCircleActive
                            ? primaryColor
                            : Colors.transparent;

                        final Color itemTextColor = isCircleActive
                            ? Colors.white
                            : (isDisabled
                                ? subtitleColor.withOpacity(0.35)
                                : (isInRange ? primaryColor : textColor));

                        final FontWeight fontWeight = isCircleActive
                            ? FontWeight.w700
                            : (isInRange
                                ? FontWeight.w600
                                : (isToday ? FontWeight.w700 : FontWeight.w500));

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap:
                                isDisabled ? null : () => _model.selectDate(date),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (rangeRibbon != null)
                                  Positioned.fill(child: rangeRibbon),
                                Container(
                                  width: 34.0,
                                  height: 34.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: circleColor,
                                    border: isToday && !isCircleActive
                                        ? Border.all(
                                            color: primaryColor,
                                            width: 1.2,
                                          )
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: fontWeight,
                                      color: itemTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    final primaryColor = _primary(context);
    final subtitleColor = _textGrey(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            key: const Key('custom_date_range_picker_cancel_button'),
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
          ListenableBuilder(
            listenable: _model,
            builder: (context, _) {
              final isConfirmDisabled = _model.startDate == null;
              return TextButton(
                key: const Key('custom_date_range_picker_confirm_button'),
                onPressed: isConfirmDisabled
                    ? null
                    : () {
                        final start = _model.startDate!;
                        final end = _model.endDate ?? start;
                        Navigator.of(context).pop(
                          DateTimeRange(start: start, end: end),
                        );
                      },
                child: Text(
                  widget.confirmText ?? 'OK',
                  style: TextStyle(
                    color: isConfirmDisabled
                        ? subtitleColor.withOpacity(0.4)
                        : primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
