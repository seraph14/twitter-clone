import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/view/singup_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallete.dart';

class LoginView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: ((context) => const LoginView()),
      );
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appBar = UIConstants.appBar();
  final emaillController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emaillController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    label: "Done",
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: " Sign up",
                        style: TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              SignUpView.route(),
                            );
                          },
                      )
                    ],
                  ),
                ),
                // textspan
              ],
            ),
          ),
        ),
      ),
    );
  }
}
