import 'package:flutter/material.dart';

class PersonalCartStepButton extends StatelessWidget {
  const PersonalCartStepButton({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
    super.key,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;

    final double iconSize = compact ? 18 : 20;
    final double fontSize = compact ? 11 : 12;

    final BoxConstraints constraints = compact
        ? const BoxConstraints(minWidth: 60, minHeight: 48)
        : const BoxConstraints(minWidth: 72, minHeight: 56);

    return ConstrainedBox(
      constraints: constraints,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: color, size: iconSize),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: fontSize),
                maxLines: compact ? 2 : null,
                overflow:
                    compact ? TextOverflow.ellipsis : TextOverflow.visible,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
