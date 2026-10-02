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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
  DateTime? _selectedMonthYear;
  DateTime? _selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picker Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(
            title: '1. Date Picker',
            subtitle: _selectedDate != null
                ? 'Selected: ${_selectedDate!.toLocal()}'.split(' ')[0]
                : 'No date selected',
            picker: CustomDatePicker(
              key: const Key('example_date_picker'),
              type: CustomDatePickerType.date,
              initialDate: _selectedDate ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedDate = date);
              },
              child: ElevatedButton.icon(
                onPressed: null, // CustomDatePicker handles tap
                icon: const Icon(Icons.calendar_today),
                label: const Text('Pick Date'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '2. Month & Year Picker (Normal Grid)',
            subtitle: _selectedMonthYear != null
                ? 'Selected: ${_selectedMonthYear!.year}-${_selectedMonthYear!.month.toString().padLeft(2, '0')}'
                : 'No month & year selected',
            picker: CustomDatePicker(
              key: const Key('example_month_year_picker_normal'),
              type: CustomDatePickerType.month,
              style: CustomDatePickerStyle.normal,
              initialDate: _selectedMonthYear ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedMonthYear = date);
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Pick Month & Year (Normal)'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '3. Month & Year Picker (Slider Columns)',
            subtitle: _selectedMonthYear != null
                ? 'Selected: ${_selectedMonthYear!.year}-${_selectedMonthYear!.month.toString().padLeft(2, '0')}'
                : 'No month & year selected',
            picker: CustomDatePicker(
              key: const Key('example_month_year_picker_slider'),
              type: CustomDatePickerType.month,
              style: CustomDatePickerStyle.slider,
              initialDate: _selectedMonthYear ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedMonthYear = date);
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.view_column_outlined),
                label: const Text('Pick Month & Year (Slider)'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '4. Year Picker (Normal Grid)',
            subtitle: _selectedYear != null
                ? 'Selected: ${_selectedYear!.year}'
                : 'No year selected',
            picker: CustomDatePicker(
              key: const Key('example_year_picker_normal'),
              type: CustomDatePickerType.year,
              style: CustomDatePickerStyle.normal,
              onlyCompletedYears: true,
              initialDate: _selectedYear ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedYear = date);
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.date_range),
                label: const Text('Pick Completed Year (Normal)'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '5. Year Picker (Slider Column)',
            subtitle: _selectedYear != null
                ? 'Selected: ${_selectedYear!.year}'
                : 'No year selected',
            picker: CustomDatePicker(
              key: const Key('example_year_picker_slider'),
              type: CustomDatePickerType.year,
              style: CustomDatePickerStyle.slider,
              onlyCompletedYears: true,
              initialDate: _selectedYear ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedYear = date);
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.unfold_more),
                label: const Text('Pick Completed Year (Slider)'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Direct Function API Demo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final result = await showCustomDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                  );
                  if (result != null) {
                    setState(() => _selectedDate = result);
                  }
                },
                child: const Text('showCustomDatePicker()'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await showCustomMonthYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    style: CustomDatePickerStyle.normal,
                  );
                  if (result != null) {
                    setState(() => _selectedMonthYear = result);
                  }
                },
                child: const Text('showCustomMonthYearPicker (normal)'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await showCustomMonthYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    style: CustomDatePickerStyle.slider,
                  );
                  if (result != null) {
                    setState(() => _selectedMonthYear = result);
                  }
                },
                child: const Text('showCustomMonthYearPicker (slider)'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await showCustomYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    style: CustomDatePickerStyle.normal,
                  );
                  if (result != null) {
                    setState(() => _selectedYear = result);
                  }
                },
                child: const Text('showCustomYearPicker (normal)'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await showCustomYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    style: CustomDatePickerStyle.slider,
                  );
                  if (result != null) {
                    setState(() => _selectedYear = result);
                  }
                },
                child: const Text('showCustomYearPicker (slider)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget picker,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 12),
            picker,
          ],
        ),
      ),
    );
  }
}
