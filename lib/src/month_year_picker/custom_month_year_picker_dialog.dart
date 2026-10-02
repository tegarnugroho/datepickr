import 'package:flutter/material.dart';

import '../date_picker/custom_date_picker_type.dart';
import '../utils/custom_month_year_picker_utils.dart';

/// Shows a dialog for picking a month and year.
Future<DateTime?> showCustomMonthYearPicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? selectedDateTime,
  CustomDatePickerType type = CustomDatePickerType.month,
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
      return CustomMonthYearPickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
        selectedDateTime: selectedDateTime,
        type: type,
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

/// Dialog widget for month and year selection.
class CustomMonthYearPickerDialog extends StatefulWidget {
  const CustomMonthYearPickerDialog({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectedDateTime,
    this.type = CustomDatePickerType.month,
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
  final CustomDatePickerType type;
  final String? subTitle;
  final String? confirmText;
  final String? cancelText;
  final Locale? locale;
  final bool onlyCompletedYears;
  final Color? primaryColor;

  @override
  State<CustomMonthYearPickerDialog> createState() =>
      _CustomMonthYearPickerDialogState();
}

class _CustomMonthYearPickerDialogState
    extends State<CustomMonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  late DateTime _resolvedFirstDate;
  late DateTime _resolvedLastDate;
  bool _isYearSelecting = false;

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
      CustomMonthYearPickerUtils.getShortMonths(_effectiveLocale);

  List<String> get _fullMonths =>
      CustomMonthYearPickerUtils.getFullMonths(_effectiveLocale);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final effective = widget.selectedDateTime ?? widget.initialDate;
    _selectedYear = effective.year;
    _selectedMonth = effective.month;

    _resolvedFirstDate =
        widget.firstDate ?? DateTime(effective.year - 100, 1, 1);

    final maxAllowed = widget.onlyCompletedYears
        ? DateTime(now.year - 1, 12, 31)
        : (effective.isAfter(now)
            ? DateTime(effective.year, effective.month)
            : now);

    DateTime candidate = widget.lastDate ?? maxAllowed;
    if (widget.onlyCompletedYears && candidate.isAfter(maxAllowed)) {
      candidate = maxAllowed;
    }
    _resolvedLastDate =
        candidate.isBefore(_resolvedFirstDate) ? _resolvedFirstDate : candidate;

    _clampSelection();
  }

  void _clampSelection() {
    _selectedYear = _selectedYear.clamp(
      _resolvedFirstDate.year,
      _resolvedLastDate.year,
    );
    if (_isMonthDisabled(_selectedMonth)) {
      _selectedMonth = CustomMonthYearPickerUtils.getTargetValidMonth(
        currentMonth: _selectedMonth,
        selectedYear: _selectedYear,
        firstDate: _resolvedFirstDate,
        lastDate: _resolvedLastDate,
      );
    }
  }

  bool _isMonthDisabled(int month) =>
      CustomMonthYearPickerUtils.isMonthDisabled(
        month: month,
        selectedYear: _selectedYear,
        firstDate: _resolvedFirstDate,
        lastDate: _resolvedLastDate,
      );

  bool get _isPrevYearDisabled => _selectedYear <= _resolvedFirstDate.year;
  bool get _isNextYearDisabled => _selectedYear >= _resolvedLastDate.year;

  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
      _clampSelection();
    });
  }

  String get _displayTitle {
    final name = _fullMonths.length >= _selectedMonth
        ? _fullMonths[_selectedMonth - 1]
        : '$_selectedMonth';
    return '$name $_selectedYear';
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
                child:
                    _isYearSelecting ? _buildYearPicker() : _buildMonthPicker(),
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
          child: _isYearSelecting ? _buildYearPicker() : _buildMonthPicker(),
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
            widget.subTitle ?? 'Choose Month & Year',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _displayTitle,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: textColor,
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
                  widget.subTitle ?? 'Choose Month & Year',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  _displayTitle,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
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
    final primaryColor = _primary(context);
    final surfaceColor = _surface(context);
    final textColor = _onSurface(context);

    return Theme(
      data: ThemeData.light().copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          space: 0,
          thickness: 0,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          surface: surfaceColor,
          onSurface: textColor,
        ),
      ),
      child: YearPicker(
        firstDate: _resolvedFirstDate,
        lastDate: _resolvedLastDate,
        selectedDate: DateTime(_selectedYear, 1, 1),
        onChanged: (dateTime) {
          setState(() {
            _selectedYear = dateTime.year;
            _isYearSelecting = false;
            _clampSelection();
          });
        },
      ),
    );
  }

  Widget _buildMonthPicker() {
    final primaryColor = _primary(context);
    final textColor = _onSurface(context);
    final subtitleColor = _textGrey(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.chevron_left,
                  color: _isPrevYearDisabled
                      ? subtitleColor.withOpacity(0.3)
                      : textColor,
                ),
                onPressed: _isPrevYearDisabled ? null : () => _changeYear(-1),
              ),
              InkWell(
                onTap: () => setState(() => _isYearSelecting = true),
                borderRadius: BorderRadius.circular(4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$_selectedYear',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: textColor,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.chevron_right,
                  color: _isNextYearDisabled
                      ? subtitleColor.withOpacity(0.3)
                      : textColor,
                ),
                onPressed: _isNextYearDisabled ? null : () => _changeYear(1),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final isSelected = month == _selectedMonth;
                final isDisabled = _isMonthDisabled(month);
                final monthName = _shortMonths.length >= month
                    ? _shortMonths[month - 1]
                    : '$month';

                final itemTextColor = isSelected
                    ? Colors.white
                    : (isDisabled
                        ? subtitleColor.withOpacity(0.35)
                        : textColor);
                final bgColor = isSelected ? primaryColor : Colors.transparent;

                return Material(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(5.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5.0),
                    onTap: isDisabled
                        ? null
                        : () => setState(() => _selectedMonth = month),
                    child: Center(
                      child: Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: itemTextColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final primaryColor = _primary(context);
    final subtitleColor = _textGrey(context);
    final isConfirmDisabled = _isMonthDisabled(_selectedMonth);

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
            onPressed: isConfirmDisabled
                ? null
                : () => Navigator.of(context).pop(
                      DateTime(_selectedYear, _selectedMonth, 1),
                    ),
            child: Text(
              widget.confirmText ?? 'OK',
              style: TextStyle(
                color: isConfirmDisabled
                    ? subtitleColor.withOpacity(0.4)
                    : primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
