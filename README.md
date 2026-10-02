# flutter_date_picker

A clean, customizable, and standalone Flutter package for selecting **Date**, **Month & Year**, and **Year**.

Designed with responsive dialog layouts for both Material 2 and Material 3, supporting portrait and landscape orientations, customizable themes, boundary constraints, and localization.

---

## Features

- **Date Picker**: Flexible date picker wrapping Flutter's native date picker with customizable defaults and themes.
- **Month & Year Picker**: Interactive month and year selector returning `DateTime(year, month, 1)`. Includes year navigation, quick year switcher, and month grid.
- **Year Picker**: Clean year selector returning `DateTime(year, 1, 1)`. Supports restricting selection to completed past years (`onlyCompletedYears`).
- **Responsive Layouts**: Adapts smoothly to portrait and landscape modes across phone and tablet screens.
- **Theme-agnostic**: Works directly with `Theme.of(context)` / `ColorScheme` without hardcoded app dependencies.
- **Localization**: Respects Flutter's `Locale` and `MaterialLocalizations`, supporting custom month symbols.
- **Widget & Function APIs**: Use as a tap-wrapper widget (`CustomDatePicker`) or invoke directly via `show...` dialog functions.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_date_picker:
    # Path or git reference
    path: ../flutter_date_picker
```

Import in your Dart code:

```dart
import 'package:flutter_date_picker/flutter_date_picker.dart';
```

---

## Usage

### 1. Using the Widget Wrapper (`CustomDatePicker`)

```dart
// Date Picker
CustomDatePicker(
  type: CustomDatePickerType.date,
  initialDate: DateTime.now(),
  onSelected: (DateTime date) {
    print('Selected Date: $date');
  },
  child: const Text('Select Date'),
)

// Month & Year Picker
CustomDatePicker(
  type: CustomDatePickerType.month,
  initialDate: DateTime(2026, 5, 1),
  onSelected: (DateTime date) {
    print('Selected Month & Year: $date');
  },
  child: const Text('Select Month & Year'),
)

// Year Picker (Only Completed Past Years)
CustomDatePicker(
  type: CustomDatePickerType.year,
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
final result = await showCustomMonthYearPicker(
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
final result = await showCustomYearPicker(
  context: context,
  initialDate: DateTime.now(),
  onlyCompletedYears: true,
  subTitle: 'Choose Year',
);
```

#### Date Picker:
```dart
final result = await showCustomDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
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
