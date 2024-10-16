import 'package:flutter/material.dart';

class StartListingScreen extends StatelessWidget {
  const StartListingScreen({super.key});
  static const String routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StartListingScreen')),
      body: const Center(child: Text('StartListingScreen Screen')),
    );
  }
}
