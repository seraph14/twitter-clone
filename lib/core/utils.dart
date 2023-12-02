import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String messsage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(messsage)),
  );
}

String getNameFromeEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();

  for (final image in imageFiles) {
    images.add(File(image.path));
  }

  return images;
}
