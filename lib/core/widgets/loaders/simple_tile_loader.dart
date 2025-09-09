import 'package:flutter/material.dart';

class SimpleTileLoader extends StatelessWidget {
  const SimpleTileLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Profile picture placeholder
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),

        // Name & last message
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 12,
                  width: double.infinity,
                  color: Theme.of(context).dividerColor),
              const SizedBox(height: 6),
              Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Theme.of(context).dividerColor),
            ],
          ),
        ),
      ],
    );
  }
}
