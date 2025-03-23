import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    super.key,
    this.maxLength = 200,
  });
  final String text;
  final int maxLength;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isLong = widget.text.length > widget.maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isExpanded || !isLong
              ? widget.text
              : '${widget.text.substring(0, widget.maxLength)}...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(900),
              ),
        ),
        if (isLong) // Show button only if text is long
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "show_less".tr() : "show_more".tr(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
      ],
    );
  }
}
