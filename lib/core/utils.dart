import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String messsage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(messsage)),
  );
}

String getNameFromeEmail(String email) {
  return email.split('@')[0];
}
