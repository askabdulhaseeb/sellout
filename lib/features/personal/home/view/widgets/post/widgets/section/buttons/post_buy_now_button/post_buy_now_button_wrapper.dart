import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../type/widgets/buy_now_button.dart';
import 'post_buy_now_button_controller.dart';
import '../../../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../../../../../post/domain/entities/size_color/size_color_entity.dart';

/// View for the PostBuyNowButton. Handles UI and delegates logic to the controller.
class PostBuyNowButtonWrapper extends StatefulWidget {
  const PostBuyNowButtonWrapper({
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
  State<PostBuyNowButtonWrapper> createState() => _PostBuyNowButtonWrapperState();
}

class _PostBuyNowButtonWrapperState extends State<PostBuyNowButtonWrapper> {
  bool _isLoading = false;

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = PostBuyNowButtonController(
      context: context,
      post: widget.post,
      detailWidget: widget.detailWidget,
      detailWidgetColor: widget.detailWidgetColor,
      detailWidgetSize: widget.detailWidgetSize,
      onSuccess: widget.onSuccess,
      setLoading: _setLoading,
    );
    return BuyNowButton(
      border: widget.border,
      onTap: controller.buyNow,
      title: widget.buyNowText ?? 'buy_now'.tr(),
      isLoading: _isLoading,
      loadingTitle: 'loading'.tr(),
      textStyle: widget.buyNowTextStyle,
      bgColor: widget.buyNowColor,
      padding: widget.padding,
      margin: widget.margin,
    );
  }
}
