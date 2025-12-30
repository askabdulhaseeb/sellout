import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
        Container(width: 40, height: 2, color: Colors.grey[300]),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.red[400],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '2',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
