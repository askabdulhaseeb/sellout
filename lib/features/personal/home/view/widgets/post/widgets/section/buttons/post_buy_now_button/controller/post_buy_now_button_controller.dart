import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../../../../../core/dialogs/post/post_tile_cloth_foot_dialog.dart';
import '../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../../../core/widgets/utils/app_snackbar.dart';
import '../../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../../../../../../../postage/domain/entities/service_point_entity.dart';
import '../../../../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../../../../../basket/domain/param/get_postage_detail_params.dart';
import '../../../../../../../../../basket/views/providers/cart_provider.dart';
import '../../../../../../../../../basket/views/screens/shopping/checkout/widgets/checkout_items_list/components/service_points_dialog.dart';
import '../../../../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../../../../../../../post/domain/params/add_to_cart_param.dart';
import '../../../../../../../../../post/domain/usecase/add_to_cart_usecase.dart';
import '../../type/widgets/address_utils.dart';
import '../widgets/delivery_method/delivery_method_dialog.dart';

class PostBuyNowButtonController {
  PostBuyNowButtonController({
    required this.context,
    required this.post,
    required this.detailWidget,
    required this.setLoading,
    this.detailWidgetColor,
    this.detailWidgetSize,
    this.onSuccess,
  });
  final BuildContext context;
  final PostEntity post;
  final bool detailWidget;
  final ColorEntity? detailWidgetColor;
  final SizeColorEntity? detailWidgetSize;
  final VoidCallback? onSuccess;
  final void Function(bool) setLoading;

  Future<void> buyNow() async {
    setLoading(true);
    try {
      if (post.type == ListingType.clothAndFoot && !detailWidget) {
        await showDialog(
          context: context,
          builder: (_) => PostTileClothFootDialog(
            post: post,
            actionType: PostTileClothFootType.buy,
          ),
        );
        return;
      }
      final bool? isPickup = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ChangeNotifierProvider<DeliveryMethodModel>(
              create: (_) => DeliveryMethodModel(),
              child: DeliveryMethodDialog(post: post),
            ),
      );
      if (!context.mounted) return;
      if (isPickup == null) return;
      if (isPickup) {
        await _handlePickupDelivery();
      } else {
        await _handleHomeDelivery();
      }
    } catch (e, stackTrace) {
      AppLog.error(
        e.toString(),
        name: 'PostBuyNowButtonController.buyNow',
        error: e,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        AppSnackBar.show('something_wrong'.tr());
      }
    } finally {
      if (context.mounted) {
        setLoading(false);
      }
    }
  }

  Future<void> _handlePickupDelivery() async {
    final AddressEntity? address = AddressUtils.getDefaultAddress();
    if (address == null || address.postalCode.isEmpty) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(
          context,
          'please_add_delivery_address_before_selecting_pickup'.tr(),
        );
      }
      return;
    }
    final ServicePointEntity? servicePoint = await ServicePointsDialog.show(
      context: context,
      cartItemIds: <String>[post.postID],
      postalCode: address.postalCode,
    );
    if (!context.mounted) return;
    if (servicePoint == null) return;
    debugPrint('Selected service point: ${servicePoint.id}');
    onSuccess?.call();
  }

  Future<void> _handleHomeDelivery() async {
    final AddressEntity? address = AddressUtils.getDefaultAddress();
    if (address == null) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(
          context,
          'please_add_delivery_address_before_selecting_delivery'.tr(),
        );
      }
      return;
    }
    final bool added = await _addToCart();
    if (!context.mounted) return;
    if (!added) return;
    final CartProvider cartPro = context.read<CartProvider>();
    cartPro.addOrUpdateDeliveryItem(
      ItemDeliveryPreference(
        cartItemId: post.postID,
        deliveryMode: 'delivery',
        servicePoint: null,
      ),
    );
    final DataState<PostageDetailResponseEntity> rates = await cartPro
        .getRates();
    if (!context.mounted) return;
    if (rates is! DataSuccess) {
      AppSnackBar.showSnackBar(
        context,
        rates.exception?.reason ?? 'failed_to_get_postage'.tr(),
      );
      return;
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const PostageBottomSheet(),
    );
    if (context.mounted) {
      onSuccess?.call();
    }
  }

  Future<bool> _addToCart() async {
    final AddToCartUsecase usecase = AddToCartUsecase(locator());
    final AddToCartParam param = AddToCartParam(
      post: post,
      color: detailWidgetColor,
      size: detailWidgetSize,
      quantity: 1,
    );
    final DataState<bool> result = await usecase(param);
    if (!context.mounted) return false;
    if (result is! DataSuccess) {
      AppSnackBar.showSnackBar(
        context,
        result.exception?.detail ?? 'something_wrong'.tr(),
      );
      return false;
    }
    return true;
  }
}
