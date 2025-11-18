import 'package:flutter/material.dart';
import '../../../../core/widgets/loaders/loader.dart';

class InitialLoadingState extends StatelessWidget {
  const InitialLoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Loader()),
      );
}
