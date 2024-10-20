import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LimitedLinesHtmlText extends StatelessWidget {
  const LimitedLinesHtmlText({
    required this.htmlData,
    this.lineHeight = 20.0,
    this.maxLines = 3,
    super.key,
  });
  final String htmlData;
  final double lineHeight;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: lineHeight *
          maxLines, // Constrain the height based on the number of lines
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        child: Html(
          data: htmlData,
        ),
      ),
    );
  }
}
