import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_date/Screen/recognition_page.dart';
import 'package:scan_date/Utility/date_picker.dart';
import 'package:scan_date/Utility/image_cropper.dart';
import 'package:scan_date/Utility/image_picker.dart';
import 'package:scan_date/Widgets/camera_popup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uuxakdtrpgehzibjrhiw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1eGFrZHRycGdlaHppYmpyaGl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA1ODc2MTAsImV4cCI6MjAyNjE2MzYxMH0.FLyh-u6ZTz6d--iPY-RJi_q9pUCNCztMRNhwA5CizPg',
  );
  runApp(MyApp(supabaseClient: Supabase.instance.client));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required SupabaseClient supabaseClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FresherKeep',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client
      .from('manual_date')
      .select();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Keeper'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          // Call your function here
          imagePickerModal(context, onCameraTap: () {
            log("Camera");
            pickImage(source: ImageSource.camera).then((value) {
              if (value.isNotEmpty) {
                imageCropperView(value, context).then((value) {
                  if (value == '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(path: value),
                      ),
                    );
                  }
                });
              }
            });
          }, onAddManuallyTap: () {
            log("Date Picker");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DatePickerScreen(client: Supabase.instance.client)),
            );
          });
        },
        label: const Text("Add Expiry Date"),
      ),
body: FutureBuilder(
  future: _future,
  builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    final data = snapshot.data; // Access the data directly

    if (data == null || data is! List) {
      return const Center(child: Text('No data available'));
    }

    final date = data; // Cast data to List
    return ListView.builder(
      itemCount: date.length,
      itemBuilder: (context, index) {
        final expirydate = date[index];
        return ListTile(
          title: Text(expirydate['expiration_date']),
        );
      },
    );
  },
),
      );
  }
}
