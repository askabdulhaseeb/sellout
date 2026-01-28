import 'package:flutter/material.dart';
import '../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../domain/entities/size_color/size_color_entity.dart';


import 'post_buy_now_button_wrapper.dart';

class PostBuyNowButton extends StatelessWidget {
  const PostBuyNowButton({
    required this.post,
    required this.detailWidget,
    required this.detailWidgetSize,
    required this.detailWidgetColor,
    this.buyNowText,
    this.buyNowTextStyle,
    this.buyNowColor,
    this.border,
    this.padding,
    this.margin,
    this.onSuccess,
    super.key,
  });

  final PostEntity post;
  final bool detailWidget;
  final SizeColorEntity? detailWidgetSize;
  final ColorEntity? detailWidgetColor;
  final String? buyNowText;
  final TextStyle? buyNowTextStyle;
  final Color? buyNowColor;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return PostBuyNowButtonWrapper(
      post: post,
      detailWidget: detailWidget,
      detailWidgetSize: detailWidgetSize,
      detailWidgetColor: detailWidgetColor,
      buyNowText: buyNowText,
      buyNowTextStyle: buyNowTextStyle,
      buyNowColor: buyNowColor,
      border: border,
      padding: padding,
      margin: margin,
      onSuccess: onSuccess,
    );
  }
}
