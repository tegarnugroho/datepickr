import 'package:flutter/material.dart';
import 'package:flutter_date_picker/flutter_date_picker.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Date Picker Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          surface: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          children: [
            // Header
            const Text(
              'PICKER EXAMPLES',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6.0),
            const Text(
              'Date Picker Examples',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 26.0,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6.0),
            const Text(
              'Basic examples of date pickers with different configurations.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 24.0),

            // Card 1: Date Picker
            _buildPickerCard(
              title: '1. Date Picker',
              description:
                  'Select a specific date using the Material date picker.',
              placeholder: 'Select date',
              buttonLabel: 'Pick Date',
              selectedText: _formatDate(_selectedDate),
              picker: CustomDatePicker(
                key: const Key('example_date_picker'),
                type: CustomDatePickerType.date,
                initialDate: _selectedDate ?? DateTime.now(),
                onSelected: (date) {
                  setState(() => _selectedDate = date);
                },
                child: _buildInputRow(
                  placeholder: 'Select date',
                  buttonLabel: 'Pick Date',
                  selectedText: _formatDate(_selectedDate),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Card 2: Month & Year Picker (Normal Grid)
            _buildPickerCard(
              title: '2. Month & Year Picker (Normal Grid)',
              description: 'Select month and year using a grid layout.',
              placeholder: 'Select month & year',
              buttonLabel: 'Pick Month & Year',
              selectedText: _formatMonthYear(_selectedMonthYearNormal),
              picker: CustomDatePicker(
                key: const Key('example_month_year_picker_normal'),
                type: CustomDatePickerType.month,
                style: CustomDatePickerStyle.normal,
                initialDate: _selectedMonthYearNormal ?? DateTime.now(),
                onSelected: (date) {
                  setState(() => _selectedMonthYearNormal = date);
                },
                child: _buildInputRow(
                  placeholder: 'Select month & year',
                  buttonLabel: 'Pick Month & Year',
                  selectedText: _formatMonthYear(_selectedMonthYearNormal),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Card 3: Month & Year Picker (Slider Columns)
            _buildPickerCard(
              title: '3. Month & Year Picker (Slider Columns)',
              description: 'Select month and year using slider columns.',
              placeholder: 'Select month & year',
              buttonLabel: 'Pick Month & Year',
              selectedText: _formatMonthYear(_selectedMonthYearSlider),
              picker: CustomDatePicker(
                key: const Key('example_month_year_picker_slider'),
                type: CustomDatePickerType.month,
                style: CustomDatePickerStyle.slider,
                initialDate: _selectedMonthYearSlider ?? DateTime.now(),
                onSelected: (date) {
                  setState(() => _selectedMonthYearSlider = date);
                },
                child: _buildInputRow(
                  placeholder: 'Select month & year',
                  buttonLabel: 'Pick Month & Year',
                  selectedText: _formatMonthYear(_selectedMonthYearSlider),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Card 4: Year Picker (Normal Grid)
            _buildPickerCard(
              title: '4. Year Picker (Normal Grid)',
              description: 'Select a year using a grid layout.',
              placeholder: 'Select year',
              buttonLabel: 'Pick Year',
              selectedText: _formatYear(_selectedYearNormal),
              picker: CustomDatePicker(
                key: const Key('example_year_picker_normal'),
                type: CustomDatePickerType.year,
                style: CustomDatePickerStyle.normal,
                initialDate: _selectedYearNormal ?? DateTime.now(),
                onSelected: (date) {
                  setState(() => _selectedYearNormal = date);
                },
                child: _buildInputRow(
                  placeholder: 'Select year',
                  buttonLabel: 'Pick Year',
                  selectedText: _formatYear(_selectedYearNormal),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Card 5: Year Picker (Slider Column)
            _buildPickerCard(
              title: '5. Year Picker (Slider Column)',
              description: 'Select a year using a slider column.',
              placeholder: 'Select year',
              buttonLabel: 'Pick Year',
              selectedText: _formatYear(_selectedYearSlider),
              picker: CustomDatePicker(
                key: const Key('example_year_picker_slider'),
                type: CustomDatePickerType.year,
                style: CustomDatePickerStyle.slider,
                initialDate: _selectedYearSlider ?? DateTime.now(),
                onSelected: (date) {
                  setState(() => _selectedYearSlider = date);
                },
                child: _buildInputRow(
                  placeholder: 'Select year',
                  buttonLabel: 'Pick Year',
                  selectedText: _formatYear(_selectedYearSlider),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerCard({
    required String title,
    required String description,
    required String placeholder,
    required String buttonLabel,
    required String? selectedText,
    required Widget picker,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13.0,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16.0),
          picker,
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required String placeholder,
    required String buttonLabel,
    required String? selectedText,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46.0,
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedText ?? placeholder,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: selectedText != null
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF94A3B8),
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
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              buttonLabel,
              style: const TextStyle(
                color: Color(0xFF2563EB),
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
