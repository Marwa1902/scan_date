import 'dart:math';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RecognizePage extends StatefulWidget{
  final String? path;

  const RecognizePage({super.key, this.path});

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    processImageFromCamera();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(title: const Text("recognized page")),

      body: _isBusy == true ? 
      const Center(
        child: CircularProgressIndicator(),
      ) : Container(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
         decoration: const InputDecoration(hintText: "Text goes here"), 
          ),
      )
      );
  }
  
   void processImageFromCamera() async {
    setState(() {
      _isBusy = true;
    });
    
    final picker = ImagePicker();
    
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      // Now you have the image from the camera, you can process it as needed.
      final InputImage inputImage = InputImage(pickedImage.path);
      processImage(inputImage);
    } else {
      // Handle case when no image is picked
      setState(() {
        _isBusy = false;
      });
    }
  }

void processImage(InputImage image) async {
  try {
    // Perform text recognition using Tesseract OCR
    String recognizedText = await FlutterTesseractOcr.extractText(image.path);

    // Extract dates from the recognized text
    String recognizedDate = extractDateFromText(recognizedText);

    // Store the recognized date in Supabase
    storeDateInSupabase(recognizedDate);
  } 
  catch (e) {
    log("Error recognizing text: " as num);
  } 
  finally {
    setState(() {
      _isBusy = false;
    });
  }
}

String extractDateFromText(String text) {
    // Implement date extraction logic here
    // Use regular expressions or date parsing algorithms to extract dates from the text
    // For simplicity, let's assume a basic pattern matching
    RegExp datePattern = RegExp(r'\b\d{1,2}([/-])\d{1,2}\1\d{4}\b');
    Match? match = datePattern.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    } else {
      return ''; // Return empty string if no date is found
    }
  }

void storeDateInSupabase(String date) {
    // Store the recognized date in your Supabase database
    // Example:
    Supabase.instance.client.from('recognized_dates').insert({'extracted_date': date});
  }
}

class InputImage {
  final String path;

  InputImage(this.path);
}
