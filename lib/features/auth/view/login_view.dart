import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appBar = UIConstants.appBar();
  final emaillController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // textfield 1
                AuthField(
                  controller: emaillController,
                  hintText: "Email",
                ),
                const SizedBox(height: 25),
                // textfield 2
                AuthField(
                  controller: passwordController,
                  hintText: "Password",
                ),
                const SizedBox(height: 40),
                // button
                // textspan
              ],
            ),
          ),
        ),
      ),
    );
  }
}
