import 'dart:developer';
import 'package:image_picker/image_picker.dart';

Future<String> pickImage({required ImageSource source}) async {
  final picker = ImagePicker();

  String path = '';

  try {
    final getImage = await picker.pickImage(source: source);

    if (getImage != null) {
      path = getImage.path;
    } else {
      path = ''; // Set path to empty string if no image is picked
    }
  } catch (e) {
    log(e.toString());
  }

  return path;
}
