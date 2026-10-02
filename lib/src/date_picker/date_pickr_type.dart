/// Supported picker types for [DatePickr].
enum DatePickrType {
  /// Standard calendar date picker.
  date,

  /// Calendar date range picker.
  dateRange,

  /// Month and year picker.
  month,

  /// Year picker.
  year,
}

/// Backwards compatibility alias for [DatePickrType].
typedef CustomDatePickerType = DatePickrType;
