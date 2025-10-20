import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.title,
    required this.isLoading,
    required this.onTap,
    this.isDisable = false,
    this.prefix,
    this.suffix,
    this.rowAlignment,
    this.mWidth,
    this.margin,
    this.padding,
    this.bgColor,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.textColor,
    this.prefixSuffixPadding,
    this.fontWeight = FontWeight.w400,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDisable;
  final bool isLoading;
  final double? mWidth;
  final Widget? prefix;
  final Widget? suffix;
  final MainAxisAlignment? rowAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Color? textColor;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? prefixSuffixPadding;

  @override
  Widget build(BuildContext context) {
    final Color bgColorCore = isDisable
        ? Theme.of(context).colorScheme.outlineVariant
        : bgColor ?? Theme.of(context).primaryColor;
    return isLoading
        ? const SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : Container(
            margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
            // constraints: BoxConstraints(maxWidth: mWidth ?? maxWidth),
            decoration: BoxDecoration(
              color: bgColorCore,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              border: border,
            ),
            child: Material(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              color: bgColorCore,
              child: InkWell(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                onTap: isDisable ? null : onTap,
                child: Padding(
                  padding: padding ??
                      const EdgeInsets.symmetric(
                          vertical: 6), //zubair's recommended design
                  child: Row(
                    mainAxisAlignment: rowAlignment ?? MainAxisAlignment.center,
                    children: <Widget>[
                      if (prefix != null)
                        Padding(
                          padding:
                              prefixSuffixPadding ?? const EdgeInsets.all(8.0),
                          child: prefix!,
                        ),
                      Text(
                        title,
                        style: textStyle ??
                            TextStyle(
                                color: textColor ??
                                    (bgColor == Colors.transparent
                                        ? null
                                        : Colors.white),
                                fontSize: 16,
                                fontWeight: fontWeight),
                      ),
                      if (suffix != null)
                        Padding(
                          padding:
                              prefixSuffixPadding ?? const EdgeInsets.all(8.0),
                          child: suffix!,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
