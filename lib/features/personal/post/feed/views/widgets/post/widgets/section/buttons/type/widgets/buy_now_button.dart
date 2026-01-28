import 'package:flutter/material.dart';

import '../../../../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';

class BuyNowButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isLoading;
  final String loadingTitle;
  final TextStyle? textStyle;
  final Color? bgColor;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const BuyNowButton({
    required this.onTap,
    required this.title,
    required this.isLoading,
    required this.loadingTitle,
    this.textStyle,
    this.bgColor,
    this.border,
    this.padding,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      border: border,
      onTap: onTap,
      title: title,
      isLoading: isLoading,
      loadingTitle: loadingTitle,
      textStyle: textStyle,
      bgColor: bgColor,
      padding: padding,
      margin: margin,
    );
  }
}
