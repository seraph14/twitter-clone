import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../theme/pallete.dart';
import '../widgets/auth_field.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: ((context) => const SignUpView()),
      );

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appBar = UIConstants.appBar();
  final emaillController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emaillController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSignUp() {
    ref.watch(authControllerProvider.notifier).signup(
          email: emaillController.text,
          password: passwordController.text,
          buildContext: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
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
                          onTap: onSignUp,
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: " Login",
                              style: TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    LoginView.route(),
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
