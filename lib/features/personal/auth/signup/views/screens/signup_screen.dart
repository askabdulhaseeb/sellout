import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  static const String routeName = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const Center(
        child: Text('Sign Up Screen'),
      ),
    );
  }
}
