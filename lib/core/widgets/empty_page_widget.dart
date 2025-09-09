import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({
    required this.icon,
    this.iconColor = AppTheme.primaryColor,
    this.backgroundColor = AppTheme.primaryColor,
    this.childBelow,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Widget? childBelow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          width: double.infinity,
          height: 20,
        ),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Big faint circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor.withValues(alpha: 0.15),
              ),
            ),
            // Smaller solid circle with icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor.withValues(alpha: 0.2),
              ),
              child: Icon(icon, color: iconColor, size: 40),
            ),
          ],
        ),
        if (childBelow != null) ...<Widget>[
          const SizedBox(height: 16),
          childBelow!,
        ],
      ],
    );
  }
}
