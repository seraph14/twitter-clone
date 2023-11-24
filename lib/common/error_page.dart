import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String error;
  const Error({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Text(error);
  }
}

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Error(error: error),
    );
  }
}
