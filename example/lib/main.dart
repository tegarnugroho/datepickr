import 'package:flutter/material.dart';
import 'package:datepickr/datepickr.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DatePickr Example',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
          primary: const Color(0xFF3B82F6),
          surface: const Color(0xFF1E293B),
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
          primary: const Color(0xFF3B82F6),
          surface: const Color(0xFF1E293B),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDate;
  DateTime? _selectedMonthYearNormal;
  DateTime? _selectedMonthYearSlider;
  DateTime? _selectedYearNormal;
  DateTime? _selectedYearSlider;
  DateTimeRange? _selectedDateRange;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String? _formatMonthYear(DateTime? date) {
    if (date == null) return null;
    final monthName = _monthNames[date.month - 1];
    return '$monthName ${date.year}';
  }

  String? _formatYear(DateTime? date) {
    if (date == null) return null;
    return '${date.year}';
  }

  String? _formatDateRange(DateTimeRange? range) {
    if (range == null) return null;
    return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          children: [
            // Header Section
            const Text(
              'PICKER EXAMPLES',
              style: TextStyle(
                color: Color(0xFF60A5FA),
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6.0),
            const Text(
              'Date Picker Examples',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 26.0,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6.0),
            const Text(
              'Basic examples of date pickers with different configurations.',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 24.0),

            // Grid of 6 Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                final int columns = maxWidth >= 900 ? 3 : (maxWidth >= 600 ? 2 : 1);
                const double spacing = 16.0;
                final double cardWidth =
                    (maxWidth - (spacing * (columns - 1))) / columns;

                final cards = [
                  // Card 1: Date Picker
                  _buildCard(
                    width: cardWidth,
                    number: '1',
                    title: 'Date Picker',
                    description:
                        'Select a specific date using the Material date picker.',
                    placeholder: 'Select date',
                    buttonLabel: 'Pick Date',
                    selectedText: _formatDate(_selectedDate),
                    picker: DatePickr(
                      key: const Key('example_date_picker'),
                      type: DatePickrType.date,
                      initialDate: _selectedDate ?? DateTime.now(),
                      onSelected: (date) {
                        setState(() => _selectedDate = date);
                      },
                      child: _buildCardInputs(
                        placeholder: 'Select date',
                        buttonLabel: 'Pick Date',
                        selectedText: _formatDate(_selectedDate),
                      ),
                    ),
                  ),

                  // Card 2: Month & Year Picker (Normal Grid)
                  _buildCard(
                    width: cardWidth,
                    number: '2',
                    title: 'Month & Year Picker\n(Normal Grid)',
                    description: 'Select month and year using a grid layout.',
                    placeholder: 'Select month & year',
                    buttonLabel: 'Pick Month & Year',
                    selectedText: _formatMonthYear(_selectedMonthYearNormal),
                    picker: DatePickr(
                      key: const Key('example_month_year_picker_normal'),
                      type: DatePickrType.month,
                      style: DatePickrStyle.normal,
                      initialDate: _selectedMonthYearNormal ?? DateTime.now(),
                      onSelected: (date) {
                        setState(() => _selectedMonthYearNormal = date);
                      },
                      child: _buildCardInputs(
                        placeholder: 'Select month & year',
                        buttonLabel: 'Pick Month & Year',
                        selectedText:
                            _formatMonthYear(_selectedMonthYearNormal),
                      ),
                    ),
                  ),

                  // Card 3: Month & Year Picker (Slider Columns)
                  _buildCard(
                    width: cardWidth,
                    number: '3',
                    title: 'Month & Year Picker\n(Slider Columns)',
                    description: 'Select month and year using slider columns.',
                    placeholder: 'Select month & year',
                    buttonLabel: 'Pick Month & Year',
                    selectedText: _formatMonthYear(_selectedMonthYearSlider),
                    picker: DatePickr(
                      key: const Key('example_month_year_picker_slider'),
                      type: DatePickrType.month,
                      style: DatePickrStyle.slider,
                      initialDate: _selectedMonthYearSlider ?? DateTime.now(),
                      onSelected: (date) {
                        setState(() => _selectedMonthYearSlider = date);
                      },
                      child: _buildCardInputs(
                        placeholder: 'Select month & year',
                        buttonLabel: 'Pick Month & Year',
                        selectedText:
                            _formatMonthYear(_selectedMonthYearSlider),
                      ),
                    ),
                  ),

                  // Card 4: Year Picker (Normal Grid)
                  _buildCard(
                    width: cardWidth,
                    number: '4',
                    title: 'Year Picker (Normal Grid)',
                    description: 'Select a year using a grid layout.',
                    placeholder: 'Select year',
                    buttonLabel: 'Pick Year',
                    selectedText: _formatYear(_selectedYearNormal),
                    picker: DatePickr(
                      key: const Key('example_year_picker_normal'),
                      type: DatePickrType.year,
                      style: DatePickrStyle.normal,
                      onlyCompletedYears: true,
                      initialDate: _selectedYearNormal ?? DateTime.now(),
                      onSelected: (date) {
                        setState(() => _selectedYearNormal = date);
                      },
                      child: _buildCardInputs(
                        placeholder: 'Select year',
                        buttonLabel: 'Pick Year',
                        selectedText: _formatYear(_selectedYearNormal),
                      ),
                    ),
                  ),

                  // Card 5: Year Picker (Slider Column)
                  _buildCard(
                    width: cardWidth,
                    number: '5',
                    title: 'Year Picker (Slider Column)',
                    description: 'Select a year using a slider column.',
                    placeholder: 'Select year',
                    buttonLabel: 'Pick Year',
                    selectedText: _formatYear(_selectedYearSlider),
                    picker: DatePickr(
                      key: const Key('example_year_picker_slider'),
                      type: DatePickrType.year,
                      style: DatePickrStyle.slider,
                      onlyCompletedYears: true,
                      initialDate: _selectedYearSlider ?? DateTime.now(),
                      onSelected: (date) {
                        setState(() => _selectedYearSlider = date);
                      },
                      child: _buildCardInputs(
                        placeholder: 'Select year',
                        buttonLabel: 'Pick Year',
                        selectedText: _formatYear(_selectedYearSlider),
                      ),
                    ),
                  ),

                  // Card 6: Date Picker (With Range)
                  _buildCard(
                    width: cardWidth,
                    number: '6',
                    title: 'Date Picker (With Range)',
                    description: 'Select a start and end date.',
                    placeholder: 'Select date range',
                    buttonLabel: 'Pick Date Range',
                    selectedText: _formatDateRange(_selectedDateRange),
                    picker: DatePickr(
                      key: const Key('example_date_range_picker'),
                      type: DatePickrType.dateRange,
                      initialDateRange: _selectedDateRange,
                      onRangeSelected: (range) {
                        setState(() => _selectedDateRange = range);
                      },
                      child: _buildCardInputs(
                        placeholder: 'Select date range',
                        buttonLabel: 'Pick Date Range',
                        selectedText: _formatDateRange(_selectedDateRange),
                      ),
                    ),
                  ),
                ];

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: cards,
                );
              },
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required double width,
    required String number,
    required String title,
    required String description,
    required String placeholder,
    required String buttonLabel,
    required String? selectedText,
    required Widget picker,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Number Badge + Title & Description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: const BoxDecoration(
                  color: Color(0x263B82F6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                  ),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF8FAFC),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF94A3B8),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          picker,
        ],
      ),
    );
  }

  Widget _buildCardInputs({
    required String placeholder,
    required String buttonLabel,
    required String? selectedText,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        children: [
          // Input Box with Calendar Icon
          Container(
            height: 44.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedText ?? placeholder,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: selectedText != null
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF64748B),
                      fontWeight: selectedText != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18.0,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          // Action Button with subtle dark blue accent background
          Container(
            width: double.infinity,
            height: 42.0,
            decoration: BoxDecoration(
              color: const Color(0x263B82F6),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              buttonLabel,
              style: const TextStyle(
                color: Color(0xFF60A5FA),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
