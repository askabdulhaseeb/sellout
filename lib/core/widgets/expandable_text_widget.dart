import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart' as html_parser;

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

  Widget _buildHtmlText(bool isLong) {
    // Convert HTML to plain text
    final Document document = html_parser.parse(widget.text);
    final String plainText = document.body?.text ?? widget.text;

    if (!isLong) {
      // If text is short, show plain text (no HTML rendering)
      return Text(
        plainText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(900),
        ),
      );
    }

    if (!isExpanded) {
      // Collapsed mode: RichText with "show more" inline
      final int endIndex = plainText.length < widget.maxLength
          ? plainText.length
          : widget.maxLength;
      final String displayedText = plainText.substring(0, endIndex);
      return RichText(
        text: TextSpan(
          text: '$displayedText... ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(900),
          ),
          children: <InlineSpan>[
            TextSpan(
              text: 'show_more'.tr(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = true;
                  });
                },
            ),
          ],
        ),
      );
    } else {
      // Expanded mode: show full plain text (no HTML rendering)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            plainText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(900),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = false;
              });
            },
            child: Text(
              'show_less'.tr(),
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
}
