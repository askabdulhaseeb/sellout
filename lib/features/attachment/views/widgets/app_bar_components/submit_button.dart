import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.onPressed,
    required this.isActive,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isActive ? onPressed : null,
      icon: Icon(
        isActive ? Icons.check_rounded : Icons.add_rounded,
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
        size: 28,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
              : Colors.grey.withOpacity(0.1),
        ),
        shape: const WidgetStatePropertyAll(
          CircleBorder(),
        ),
      ),
    );
  }
}
