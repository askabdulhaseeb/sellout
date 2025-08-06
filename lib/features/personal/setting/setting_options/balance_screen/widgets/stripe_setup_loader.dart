import 'package:flutter/material.dart';

class StripeSetupLoader extends StatelessWidget {
  const StripeSetupLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Setting up your Stripe account...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
