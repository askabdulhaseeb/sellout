import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

class PostAddToBasketButton extends StatefulWidget {
  const PostAddToBasketButton({
    required this.post,
    required this.detailWidget,
    required this.detailWidgetColor,
    required this.detailWidgetSize,
    super.key,
  });

  final PostEntity post;
  final bool detailWidget;
  final SizeColorEntity? detailWidgetSize;
  final ColorEntity? detailWidgetColor;

  @override
  State<PostAddToBasketButton> createState() => _PostAddToBasketButtonState();
}

class _PostAddToBasketButtonState extends State<PostAddToBasketButton> {
  bool isLoading = false;

  Future<void> _addToBasket(BuildContext context) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      if (widget.post.type == ListingType.clothAndFoot &&
          !widget.detailWidget) {
        await showDialog(
          context: context,
          builder: (_) => PostTileClothFootDialog(
            post: widget.post,
            actionType: PostTileClothFootType.add,
          ),
        );
      } else if (widget.post.listID == ListingType.clothAndFoot.json) {
        final AddToCartUsecase usecase = AddToCartUsecase(locator());
        final DataState<bool> result = await usecase(
          AddToCartParam(
              post: widget.post,
              color: widget.detailWidgetColor,
              size: widget.detailWidgetSize,
              quantity: 1),
        );
        if (result is DataSuccess) {
          if (mounted) {
            AppSnackBar.info(
              context,
              'successfull_add_to_basket'.tr(),
            );
          }
        } else {
          AppLog.error(
            result.exception?.message ?? 'AddToCartError',
            name: 'post_add_to_basket_button.dart',
            error: result.exception,
          );
          if (context.mounted) {
            AppSnackBar.showSnackBar(
              context,
              result.exception?.detail ?? 'something_wrong'.tr(),
            );
          }
        }
      } else {
        final AddToCartUsecase usecase = AddToCartUsecase(locator());
        final DataState<bool> result = await usecase(
          AddToCartParam(post: widget.post),
        );
        if (result is DataSuccess) {
          if (mounted) {
            AppSnackBar.success(
              context,
              'successfull_add_to_basket'.tr(),
            );
          }
        } else {
          AppLog.error(
            result.exception?.message ?? 'AddToCartError',
            name: 'post_add_to_basket_button.dart',
            error: result.exception, 
          );
          if (mounted) {
            AppSnackBar.error(
              context,
              result.exception?.detail ?? 'something_wrong'.tr(),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      AppLog.error(
        e.toString(),
        name: 'PostAddToBasketButton._addToBasket',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      }
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;

    return CustomElevatedButton(
      margin: const EdgeInsets.symmetric(vertical: 8),
      onTap: () => _addToBasket(context),
      title: 'add_to_basket'.tr(),
      isLoading: isLoading,
      bgColor: Colors.transparent,
      border: Border.all(color: color, width: 2),
      textColor: color,
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }
}
