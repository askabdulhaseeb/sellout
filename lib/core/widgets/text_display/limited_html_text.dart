// import 'package:flutter/material.dart';
// import 'package:html/parser.dart' as html_parser;

// class LimitedLinesHtmlText extends StatelessWidget {
//   const LimitedLinesHtmlText({
//     required this.htmlData,
//     this.lineHeight = 20.0,
//     this.maxLines = 3,
//     super.key,
//   });
//   final String htmlData;
//   final double lineHeight;
//   final int maxLines;

//   @override
//   Widget build(BuildContext context) {
//     final plainText = html_parser.parse(htmlData).body?.text ?? htmlData;
//     return Text(
//       plainText,
//       maxLines: maxLines,
//       overflow: TextOverflow.ellipsis,
//       style: TextStyle(height: lineHeight / 14.0), // 14.0 is default font size
//     );
//   }
// }
