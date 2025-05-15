import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    super.key,
    this.maxLength = 200,
    this.isHtml = false,
  });

  final String text;
  final int maxLength;
  final bool isHtml;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isLong = widget.text.length > widget.maxLength;
    return widget.isHtml ? _buildHtmlText(isLong) : _buildPlainText(isLong);
  }

  // ✅ Handles Plain Text with Tappable "Show More"
  Widget _buildPlainText(bool isLong) {
    String displayedText = isExpanded || !isLong
        ? widget.text
        : '${widget.text.substring(0, widget.maxLength)}... ';
    return RichText(
      text: TextSpan(
        text: displayedText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(900),
            ),
        children: <TextSpan>[
          if (isLong)
            TextSpan(
              text: isExpanded
                  ? '...${'show_less'.tr()}'
                  : '...${'show_more'.tr()}',
              style: TextStyle(color: Theme.of(context).primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
            ),
        ],
      ),
    );
  }

  // ✅ Handles HTML Text with Tappable "Show More"
  Widget _buildHtmlText(bool isLong) {
    String textToShow = isExpanded || !isLong
        ? widget.text
        : '${widget.text.substring(0, widget.maxLength)}... ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Html(
          data: textToShow,
          style: <String, Style>{
            'body': Style(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(900),
              fontSize: FontSize.medium,
            ),
          },
        ),
        if (isLong)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'show_less'.tr() : 'show_more'.tr(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
