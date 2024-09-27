import 'package:flutter/material.dart';

class SellOutTitle extends StatelessWidget {
  const SellOutTitle({this.size = 24, this.fontWeight, this.color, super.key});
  final double size;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'SellOut',
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
