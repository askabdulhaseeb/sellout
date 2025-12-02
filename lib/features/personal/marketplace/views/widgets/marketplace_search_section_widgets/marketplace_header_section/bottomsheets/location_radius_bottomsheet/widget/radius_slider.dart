import 'package:flutter/material.dart';

class RadiusSlider extends StatelessWidget {
  const RadiusSlider({
    required this.selectedRadius, required this.onChanged, super.key,
  });

  final double selectedRadius;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Slider(
            thumbColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).primaryColor,
            value: selectedRadius,
            min: 1,
            max: 10,
            label: '${selectedRadius.toStringAsFixed(1)} km',
            onChanged: onChanged,
          ),
        ),
        Text(
          '${selectedRadius.toStringAsFixed(1)} km',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
