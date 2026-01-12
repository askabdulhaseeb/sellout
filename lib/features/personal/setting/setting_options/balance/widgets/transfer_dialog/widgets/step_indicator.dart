import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: currentStep >= 1 ? Colors.green : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: currentStep > 1
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: currentStep >= 1 ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
        ),
        Container(width: 40, height: 2, color: Colors.grey[300]),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: currentStep >= 2 ? Colors.red[400] : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '2',
              style: TextStyle(
                color: currentStep >= 2 ? Colors.white : Colors.grey[600],
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
