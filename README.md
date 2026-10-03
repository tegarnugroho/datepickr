# datepickr

A customizable and responsive Flutter package for selecting **Date**, **Date Range**, **Month & Year**, and **Year**.

Designed with clean dialog layouts, smooth wheel-slider controls, adaptive Material 3 theming, boundary constraints, and full internationalization support.

---

## Preview

### Date Range & Month-Year Pickers

| Date Range (Custom Dialog) | Month & Year (Slider Wheel) | Month & Year (Normal Grid) |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/tegarnugroho/datepickr/main/doc/screenshots/date_range_dialog.png" width="240" alt="Date Range Dialog"/> | <img src="https://raw.githubusercontent.com/tegarnugroho/datepickr/main/doc/screenshots/month_year_slider.png" width="240" alt="Month Year Slider"/> | <img src="https://raw.githubusercontent.com/tegarnugroho/datepickr/main/doc/screenshots/month_year_grid.png" width="240" alt="Month Year Grid"/> |
| Compact dialog with continuous range ribbon | Dual wheel sliders for quick scrolling | Classic responsive month & year grid |

### Year Pickers & Fullscreen Range

| Year Picker (Slider Wheel) | Year Picker (Normal Grid) | Date Range (Fullscreen) |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/tegarnugroho/datepickr/main/doc/screenshots/year_slider.png" width="240" alt="Year Slider"/> | <img src="https://raw.githubusercontent.com/tegarnugroho/datepickr/main/doc/screenshots/year_grid.png" width="240" alt="Year Grid"/> | <img src="https://raw.githubusercontent.com/tegarnugroho/datepickr/main/doc/screenshots/date_range_fullscreen.png" width="240" alt="Date Range Fullscreen"/> |
| Single wheel year selector | Grid view with quick jump & constraints | Standard fullscreen Material range sheet |

---

## Features

- **Date Picker**: Flexible date picker wrapping Flutter's native date picker with custom themes, colors, and boundary restrictions.
- **Date Range Picker**:
  - **Custom Compact Dialog** (`fullScreen: false`): Compact centered dialog with continuous highlight ribbons and start/end badge indicators.
  - **Standard Fullscreen Modal** (`fullScreen: true`): Material calendar sheet for long scrolling date selections.
- **Month & Year Picker**: Dual-mode selector returning `DateTime(year, month, 1)`. Choose between **Normal Grid** or **Slider Columns** wheel scrolling, with support for restricting selection to completed past months (`onlyCompleted: true`).
- **Year Picker**: Select a year returning `DateTime(year, 1, 1)`. Supports restricting selection to completed past years (`onlyCompleted: true`) in both Grid and Slider styles.
- **Responsive Layouts**: Seamlessly adapts to portrait and landscape orientations across mobile and tablet screens.
- **Theme-Agnostic**: Fully integrates with your app's `ThemeData` and `ColorScheme` without hardcoded colors.
- **Localization**: Full locale and internationalization (`intl`) support for month names and symbols.
- **State Management Friendly**: Uses internal `ValueNotifier` patterns to avoid unnecessary parent rebuilds.
- **Widget & Function APIs**: Use as a tap-wrapper widget (`DatePickr`) or invoke directly via `show...` dialog functions.

---

## Installation

Add `datepickr` to your `pubspec.yaml`:

```yaml
dependencies:
  datepickr: ^0.0.3
```

Import the package in your Dart code:

```dart
import 'package:datepickr/datepickr.dart';
```

---

## Usage

You can use `datepickr` either as a **widget wrapper** (`DatePickr`) or by invoking **direct dialog functions** (`showDatePickr...`).

### 1. Direct Dialog Functions

#### Date Range Picker (Custom Compact Dialog)
```dart
final DateTimeRange? range = await showDatePickrRange(
  context: context,
  fullScreen: false, // Set false for compact dialog, true for fullscreen modal
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  ),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  subTitle: 'Select Date Range',
  confirmText: 'OK',
  cancelText: 'Cancel',
);
```

#### Month & Year Picker
Returns `DateTime(year, month, 1)`.
```dart
// Wheel Slider or Normal Grid style
final DateTime? monthYear = await showDatePickrMonthYear(
  context: context,
  style: DatePickrStyle.slider, // or DatePickrStyle.normal
  onlyCompleted: true,          // Disables ongoing month and future months
  initialDate: DateTime.now(),
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
  subTitle: 'Choose Month & Year',
);
```

#### Year Picker
Returns `DateTime(year, 1, 1)`.
```dart
final DateTime? year = await showDatePickrYear(
  context: context,
  style: DatePickrStyle.slider, // or DatePickrStyle.normal
  onlyCompleted: true,          // Disables current year and future years
  initialDate: DateTime.now(),
  subTitle: 'Choose Year',
);
```

#### Standard Date Picker
Returns `DateTime(year, month, day)`.
```dart
final DateTime? date = await showDatePickr(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);
```

---

### 2. Widget Wrapper (`DatePickr`)

Wrap any clickable widget (button, text field, card) with `DatePickr`:

```dart
// Date Range Picker (Compact Dialog)
DatePickr(
  type: DatePickrType.dateRange,
  fullScreen: false,
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 5)),
  ),
  onRangeSelected: (DateTimeRange range) {
    print('Selected Range: ${range.start} - ${range.end}');
  },
  child: const OutlinedButton(
    onPressed: null,
    child: Text('Pick Date Range'),
  ),
)

// Month & Year Picker (Slider Style)
DatePickr(
  type: DatePickrType.month,
  style: DatePickrStyle.slider,
  initialDate: DateTime.now(),
  onSelected: (DateTime date) {
    print('Selected Month & Year: $date');
  },
  child: const ElevatedButton(
    onPressed: null,
    child: Text('Pick Month & Year'),
  ),
)

// Year Picker (Only Completed Past Years)
DatePickr(
  type: DatePickrType.year,
  onlyCompleted: true,
  onSelected: (DateTime date) {
    print('Selected Year: $date');
  },
  child: const Text('Select Year'),
)
```

---

## API Reference

### DatePickr Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | *required* | The clickable trigger widget. |
| `type` | `DatePickrType` | `DatePickrType.date` | Type of picker: `date`, `dateRange`, `month`, or `year`. |
| `style` | `DatePickrStyle` | `DatePickrStyle.normal` | Visual style: `normal` (grid) or `slider` (wheel columns). |
| `fullScreen` | `bool` | `true` | For `dateRange`: `false` opens compact dialog, `true` opens fullscreen modal. |
| `initialDate` | `DateTime?` | `DateTime.now()` | Default date when picker opens. |
| `selectedDateTime` | `DateTime?` | `null` | Currently selected date value. |
| `initialDateRange` | `DateTimeRange?` | `null` | Default range when date range picker opens. |
| `selectedDateRange` | `DateTimeRange?` | `null` | Currently selected range value. |
| `firstDate` | `DateTime?` | 200 years past | Earliest selectable date boundary. |
| `lastDate` | `DateTime?` | 200 years future | Latest selectable date boundary. |
| `onlyCompleted` | `bool` | `false` | When `true`, disables ongoing/incomplete periods (current month & future for month picker; current year & future for year picker). |
| `onSelected` | `ValueChanged<DateTime>?` | `null` | Callback returning confirmed `DateTime`. |
| `onRangeSelected` | `ValueChanged<DateTimeRange>?` | `null` | Callback returning confirmed `DateTimeRange`. |
| `primaryColor` | `Color?` | `Theme primary` | Explicit theme accent color override. |
| `subTitle` | `String?` | `null` | Header subtitle label displayed inside the dialog. |
| `confirmText` | `String?` | `'OK'` / localized | Label for confirmation button. |
| `cancelText` | `String?` | `'Cancel'` / localized | Label for cancel button. |
| `locale` | `Locale?` | System locale | Locale for month names and labels. |

---

### Return Values

| Picker Type | Return Type | Format |
| :--- | :--- | :--- |
| `DatePickrType.date` | `DateTime` | `DateTime(year, month, day)` |
| `DatePickrType.dateRange` | `DateTimeRange` | `DateTimeRange(start: DateTime, end: DateTime)` |
| `DatePickrType.month` | `DateTime` | `DateTime(year, month, 1)` |
| `DatePickrType.year` | `DateTime` | `DateTime(year, 1, 1)` |

---

## Constraints and Boundaries

### Boundary Handling (`firstDate` and `lastDate`)
Months and years outside the range defined by `firstDate` and `lastDate` are automatically disabled and rendered with disabled styling. Navigation chevrons also respect boundaries to prevent navigating to inaccessible ranges.

### Completed Periods Filter (`onlyCompleted`)
When `onlyCompleted: true`:
- **Month Picker**: The current ongoing month and all future months are disabled. Only fully concluded past months can be selected. In January, rolls back automatically so that the latest selectable month is December of the previous year. Ideal for monthly financial closings, payroll cycles, billing statements, and monthly KPIs.
- **Year Picker**: The current ongoing year (e.g. 2026) and all future years are disabled. Only fully concluded past years (e.g. 2025 and earlier) can be selected. Ideal for annual financial statements, tax reporting, and historical audit periods.

---

## Theming and Customization

`datepickr` automatically inherits the typography, colors, and shapes of your application's `ThemeData`:

- **Primary Accent**: `Theme.of(context).colorScheme.primary` (or pass `primaryColor` to override).
- **Surface and Background**: `Theme.of(context).colorScheme.surface`.
- **Text and Labels**: `Theme.of(context).colorScheme.onSurface` and `onSurfaceVariant`.
- **Border Radius**: Defaults to `16.0` for dialogs and standard Material curves.

---

## Localization

The package supports localization out of the box using Flutter's `Locale` and `MaterialLocalizations`:

```dart
showDatePickrMonthYear(
  context: context,
  locale: const Locale('id', 'ID'), // Indonesian month names: Jan, Feb, Mar, Apr, Mei, Jun, ...
);
```

If no locale is explicitly passed, `Localizations.localeOf(context)` is used automatically.

---

## Backwards Compatibility

For existing projects migrating from earlier versions, type aliases are maintained:

```dart
typedef CustomDatePicker = DatePickr;
const showCustomDatePicker = showDatePickr;
const showCustomMonthYearPicker = showDatePickrMonthYear;
const showCustomYearPicker = showDatePickrYear;
const showCustomDateRangePicker = showDatePickrRange;
```

---

## Example Project

An example application demonstrating all picker variations is available in the `example/` directory.

To run the example app:

```bash
cd example
flutter run
```

---

## Requirements

- Flutter: `>=3.24.0`
- Dart: `>=3.5.0`

---

## License

MIT License. See [LICENSE](LICENSE) for details.
