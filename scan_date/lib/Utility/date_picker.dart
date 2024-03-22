import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key, required this.client});

  final SupabaseClient client;

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  final TextEditingController _dateController = TextEditingController();
  late final SupabaseClient _client;

  @override
  void initState(){
    super.initState();
    //first is url, the second is the api key
    _client = SupabaseClient('https://uuxakdtrpgehzibjrhiw.supabase.co', 
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1eGFrZHRycGdlaHppYmpyaGl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA1ODc2MTAsImV4cCI6MjAyNjE2MzYxMH0.FLyh-u6ZTz6d--iPY-RJi_q9pUCNCztMRNhwA5CizPg'
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Date'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                readOnly: true,
                onTap: _showDatePicker,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // back to HomePage
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _showDatePicker() async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2022),
    lastDate: DateTime(2030),
  );

  if (picked != null) {
    setState(() {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    });

    // Insert the date into Supabase
    await _insertDateToSupabase(picked);

  }
}

Future<void> _insertDateToSupabase(DateTime date) async {
  final response = await _client.from('manual_date').upsert([
    {'expiration_date': date.toIso8601String()}
  ]);

  if (response.error != null) {
    log('Error inserting date: ${response.error?.message}');
    log('Error details: ${response.error?.details}');
  } else {
    log('Date insertion successful');

  }
}
}


