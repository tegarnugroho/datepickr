# datepickr

A clean, customizable, and standalone Flutter package for selecting **Date**, **Date Range**, **Month & Year**, and **Year**.

Designed with responsive dialog layouts for both Material 2 and Material 3, supporting portrait and landscape orientations, customizable themes, boundary constraints, and localization.

---

## Features

- **Date Picker**: Flexible date picker wrapping Flutter's native date picker with customizable defaults and themes.
- **Date Range Picker**: Native Material date range picker with theme customization.
- **Month & Year Picker**: Interactive month and year selector returning `DateTime(year, month, 1)`. Includes year navigation, quick year switcher, and month grid or slider columns.
- **Year Picker**: Clean year selector returning `DateTime(year, 1, 1)`. Supports restricting selection to completed past years (`onlyCompletedYears`) and normal grid or slider view.
- **Responsive Layouts**: Adapts smoothly to portrait and landscape modes across phone and tablet screens.
- **Theme-agnostic**: Works directly with `Theme.of(context)` / `ColorScheme` without hardcoded app dependencies.
- **Localization**: Respects Flutter's `Locale` and `MaterialLocalizations`, supporting custom month symbols.
- **Widget & Function APIs**: Use as a tap-wrapper widget (`DatePickr`) or invoke directly via `show...` dialog functions.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  datepickr:
    # Path or git reference
    path: ../datepickr
```

Import in your Dart code:

```dart
import 'package:datepickr/datepickr.dart';
```

---

## Usage

### 1. Using the Widget Wrapper (`DatePickr`)

```dart
// Date Picker
DatePickr(
  type: DatePickrType.date,
  initialDate: DateTime.now(),
  onSelected: (DateTime date) {
    print('Selected Date: $date');
  },
  child: const Text('Select Date'),
)

// Date Range Picker
DatePickr(
  type: DatePickrType.dateRange,
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  ),
  onRangeSelected: (DateTimeRange range) {
    print('Selected Range: $range');
  },
  child: const Text('Select Date Range'),
)

// Month & Year Picker
DatePickr(
  type: DatePickrType.month,
  initialDate: DateTime(2026, 5, 1),
  onSelected: (DateTime date) {
    print('Selected Month & Year: $date');
  },
  child: const Text('Select Month & Year'),
)

// Year Picker (Only Completed Past Years)
DatePickr(
  type: DatePickrType.year,
  onlyCompletedYears: true,
  initialDate: DateTime.now(),
  onSelected: (DateTime date) {
    print('Selected Year: $date');
  },
  child: const Text('Select Year'),
)
```

---

### 2. Using Direct Dialog Functions

#### Month & Year Picker:
```dart
final result = await showDatePickrMonthYear(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
  subTitle: 'Choose Month & Year',
  confirmText: 'OK',
  cancelText: 'Cancel',
);
```

#### Year Picker:
```dart
final result = await showDatePickrYear(
  context: context,
  initialDate: DateTime.now(),
  onlyCompletedYears: true,
  subTitle: 'Choose Year',
);
```

#### Date Picker:
```dart
final result = await showDatePickr(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);
```

#### Date Range Picker:
```dart
final result = await showDatePickrRange(
  context: context,
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  ),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);
```

---

### 3. Normal vs Slider Style

Both Month-Year and Year pickers support two display styles via `DatePickrStyle`:
- `DatePickrStyle.normal`: Default grid-based view.
- `DatePickrStyle.slider`: Vertical wheel scroll view (Month and Year side-by-side columns for month picker, or single column for year picker).

```dart
// Using widget wrapper
DatePickr(
  type: DatePickrType.month,
  style: DatePickrStyle.slider, // or DatePickrStyle.normal
  onSelected: (date) => print(date),
  child: const Text('Pick Month & Year'),
)

// Using dialog function
final result = await showDatePickrMonthYear(
  context: context,
  style: DatePickrStyle.slider,
);
```

---

## Customization

The pickers inherit the colors and shapes of your application's `ThemeData`:
- **Primary Color**: `Theme.of(context).colorScheme.primary` or explicitly pass `primaryColor`.
- **Surface & Background**: `Theme.of(context).colorScheme.surface`.
- **Text & Accents**: `Theme.of(context).colorScheme.onSurface` and `onSurfaceVariant`.

---

## Requirements

- Flutter: `>=3.24.0`
- Dart: `>=3.5.0`

---

## License

MIT License. See [LICENSE](LICENSE) for details.
