import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/dialogs/post/buy_now_dailog.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../../cart/views/screens/personal_cart_screen.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
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
    this.padding,
    this.margin,
    super.key,
  });

  final PostEntity post;
  final bool detailWidget;
  final SizeColorEntity? detailWidgetSize;
  final ColorEntity? detailWidgetColor;
  final String? buyNowText;
  final TextStyle? buyNowTextStyle;
  final Color? buyNowColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

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
      if (widget.post.sizeColors.isNotEmpty && !widget.detailWidget) {
        await showDialog(
          context: context,
          builder: (_) => BuyNowDialog(post: widget.post),
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
          if (mounted) {
            await Navigator.of(context).pushNamed(PersonalCartScreen.routeName);
          }
        } else {
          AppLog.error(
            result.exception?.message ?? 'AddToCartError',
            name: 'post_buy_now_button.dart',
            error: result.exception,
          );
          if (mounted) {
            AppSnackBar.showSnackBar(
              context,
              result.exception?.message ?? 'something_wrong'.tr(),
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
      onTap: () => _buyNow(context),
      title: widget.buyNowText ?? 'buy_now'.tr(),
      isLoading: isLoading,
      textStyle: widget.buyNowTextStyle,
      bgColor: widget.buyNowColor,
      padding: widget.padding,
      margin: widget.margin,
    );
  }
}
