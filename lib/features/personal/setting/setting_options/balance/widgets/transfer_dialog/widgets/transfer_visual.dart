import 'package:flutter/material.dart';

class TransferVisual extends StatelessWidget {
  const TransferVisual({
    required this.sourceLabel,
    required this.destinationLabel,
    required this.sourceColor,
    required this.destinationColor,
    required this.sourceIcon,
    required this.destinationIconText,
    super.key,
  });

  final String sourceLabel;
  final String destinationLabel;
  final Color sourceColor;
  final Color destinationColor;
  final IconData sourceIcon;
  final String destinationIconText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildIconBox(icon: sourceIcon, label: sourceLabel, color: sourceColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(width: 30, height: 2, color: Colors.grey[300]),
        ),
        _buildIconBox(
          iconText: destinationIconText,
          label: destinationLabel,
          color: destinationColor,
        ),
      ],
    );
  }

  Widget _buildIconBox({
    required String label,
    required Color color,
    IconData? icon,
    String? iconText,
  }) {
    return Column(
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: color, size: 28)
                : Text(
                    iconText ?? '',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
