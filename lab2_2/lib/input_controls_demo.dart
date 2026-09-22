import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double rating = 50;

  bool isMovieActive = false;

  String? selectedGenre;

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Input Controls'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Rating (Slider)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Slider(
              value: rating,
              min: 0,
              max: 100,
              divisions: 100,
              label: rating.round().toString(),
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            Text(
              'Current value: ${rating.round()}',
            ),

            const SizedBox(height: 20),

            const Text(
              'Active (Switch)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Is movie active?'),
              value: isMovieActive,
              onChanged: (value) {
                setState(() {
                  isMovieActive = value;
                });
              },
            ),

            Text(
              'Current status: ${isMovieActive ? "Active" : "Inactive"}',
            ),

            const SizedBox(height: 20),

            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: selectedGenre,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: selectedGenre,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
            ),

            Text(
              'Selected genre: ${selectedGenre ?? "None"}',
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickDate,
              child: const Text('Open Date Picker'),
            ),

            const SizedBox(height: 10),

            Text(
              selectedDate == null
                  ? 'Selected date: None'
                  : 'Selected date: '
                  '${selectedDate!.day}/'
                  '${selectedDate!.month}/'
                  '${selectedDate!.year}',
            ),
          ],
        ),
      ),
    );
  }
}