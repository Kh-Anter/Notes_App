import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static Future pickImage(ImageSource source) async {
    try {
      final result = await ImagePicker().pickImage(source: source);
      if (result == null) return null;
      return File(result.path);
    } on PlatformException catch (e) {
      throw ("---Excetion when pickImage---$e");
    }
  }
}
