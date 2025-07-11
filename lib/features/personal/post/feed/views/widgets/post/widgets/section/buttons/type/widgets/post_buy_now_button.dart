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
import '../../../../../../../../../domain/params/add_to_cart_param.dart';
import '../../../../../../../../../domain/usecase/add_to_cart_usecase.dart';

class PostBuyNowButton extends StatefulWidget {
  const PostBuyNowButton({
    required this.post,
    required this.quantity,
    super.key,
  });

  final PostEntity post;
  final int quantity;

  @override
  State<PostBuyNowButton> createState() => _PostBuyNowButtonState();
}

class _PostBuyNowButtonState extends State<PostBuyNowButton> {
  bool isLoading = false;

  Future<void> _buyNow(BuildContext context) async {
    if (isLoading) return; // Prevent double taps
    setState(() => isLoading = true);

    try {
      if (widget.post.sizeColors.isNotEmpty) {
        // Show selection dialog
        await showDialog(
          context: context,
          builder: (_) => BuyNowDialog(post: widget.post),
        );
      } else {
        // Direct add to cart
        final AddToCartUsecase usecase = AddToCartUsecase(locator());
        final DataState<bool> result = await usecase(
          AddToCartParam(post: widget.post, quantity: widget.quantity),
        );

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
      title: 'buy_now'.tr(),
      isLoading: isLoading,
    );
  }
}
