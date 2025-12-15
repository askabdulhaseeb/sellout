import 'package:flutter/material.dart';

class TwoStyleText extends StatelessWidget {
  const TwoStyleText({
    required this.firstText,
    required this.secondText,
    super.key,
  });

  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    final TextStyle? labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.w400,
        );
    final TextStyle? valueStyle = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurface);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              '$firstText:',
              style: labelStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: Text(secondText, style: valueStyle)),
        ],
      ),
    );
  }
}
