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
            title: '2. Month & Year Picker',
            subtitle: _selectedMonthYear != null
                ? 'Selected: ${_selectedMonthYear!.year}-${_selectedMonthYear!.month.toString().padLeft(2, '0')}'
                : 'No month & year selected',
            picker: CustomDatePicker(
              key: const Key('example_month_year_picker'),
              type: CustomDatePickerType.month,
              initialDate: _selectedMonthYear ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedMonthYear = date);
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Pick Month & Year'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '3. Year Picker (Completed Years Only)',
            subtitle: _selectedYear != null
                ? 'Selected: ${_selectedYear!.year}'
                : 'No year selected',
            picker: CustomDatePicker(
              key: const Key('example_year_picker'),
              type: CustomDatePickerType.year,
              onlyCompletedYears: true,
              initialDate: _selectedYear ?? DateTime.now(),
              onSelected: (date) {
                setState(() => _selectedYear = date);
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.date_range),
                label: const Text('Pick Completed Year'),
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
                  );
                  if (result != null) {
                    setState(() => _selectedMonthYear = result);
                  }
                },
                child: const Text('showCustomMonthYearPicker()'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await showCustomYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                  );
                  if (result != null) {
                    setState(() => _selectedYear = result);
                  }
                },
                child: const Text('showCustomYearPicker()'),
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
