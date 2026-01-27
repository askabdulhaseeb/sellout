import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../../../../../core/dialogs/post/post_tile_cloth_foot_dialog.dart';
import '../../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../../../../../../../../../domain/params/add_to_cart_param.dart';
import '../../../../../../../../../domain/usecase/add_to_cart_usecase.dart';

class PostBuyNowButton extends StatefulWidget {
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
  State<PostBuyNowButton> createState() => _PostBuyNowButtonState();
}

class _PostBuyNowButtonState extends State<PostBuyNowButton> {
  bool isLoading = false;

  Future<void> _buyNow(BuildContext context) async {
    if (isLoading) return; // Prevent double taps
    setState(() => isLoading = true);

    try {
      final AddToCartUsecase usecase = AddToCartUsecase(locator());
      // If product has variants but detailWidget is not showing, open selection dialog
      if (widget.post.type == ListingType.clothAndFoot &&
          !widget.detailWidget) {
        await showDialog(
          context: context,
          builder: (_) => PostTileClothFootDialog(
            post: widget.post,
            actionType: PostTileClothFootType.buy,
          ),
        );
      } else {
        // Prepare add to cart param
        final AddToCartParam param = AddToCartParam(
          post: widget.post,
          color: widget.detailWidgetColor,
          size: widget.detailWidgetSize,
          quantity: 1,
        );
        final DataState<bool> result = await usecase(param);
        if (result is DataSuccess) {
          if (mounted && widget.onSuccess != null) {
            widget.onSuccess!();
          }
        } else {
          AppLog.error(
            result.exception?.message ?? 'AddToCartError',
            name: 'post_buy_now_button.dart',
            error: result.exception?.reason,
          );
          if (mounted) {
            AppSnackBar.showSnackBar(
              context,
              result.exception?.detail ?? 'something_wrong'.tr(),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      AppLog.error(
        e.toString(),
        name: 'PostBuyNowButton._buyNow',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      border: widget.border,
      onTap: () => _buyNow(context),
      title: widget.buyNowText ?? 'buy_now'.tr(),
      isLoading: isLoading,
      loadingTitle: 'loading'.tr(),
      textStyle: widget.buyNowTextStyle,
      bgColor: widget.buyNowColor,
      padding: widget.padding,
      margin: widget.margin,
    );
  }
}
