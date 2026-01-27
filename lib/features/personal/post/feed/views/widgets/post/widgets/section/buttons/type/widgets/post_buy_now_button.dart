import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../../../../../core/dialogs/post/post_tile_cloth_foot_dialog.dart';
import '../../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../core/widgets/app_radio_tile.dart';
import '../../../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../../../postage/domain/entities/service_point_entity.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../../../../../../../../../domain/params/add_to_cart_param.dart';
import '../../../../../../../../../domain/usecase/add_to_cart_usecase.dart';
import '../../../../../../../../../../basket/views/screens/shopping/checkout/widgets/checkout_items_list/components/service_points_dialog.dart';
import '../../../../../../../../../../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../../../../../../features/personal/auth/signin/domain/entities/address_entity.dart';

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

  AddressEntity? get _defaultAddress {
    // Use the default address from LocalAuth
    final List<AddressEntity> addresses =
        LocalAuth.currentUser?.address ?? <AddressEntity>[];
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (AddressEntity a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }

  Future<bool?> _askDeliveryMethod(BuildContext context) async {
    // Returns true for Pickup, false for Home Delivery, null if cancelled
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selected = 0;
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Product Card
                        Row(
                          children: <Widget>[
                            // Product image
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.post.imageURL,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.post.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  FutureBuilder<double?>(
                                    future: widget.post.getLocalPrice(),
                                    builder: (BuildContext context, AsyncSnapshot<double?> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox(
                                          height: 18,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error'.tr(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xFFD32F2F),
                                          ),
                                        );
                                      } else {
                                        final double? price = snapshot.data;
                                        return Text(
                                          price != null
                                              ? NumberFormat.simpleCurrency()
                                                    .format(price)
                                              : '-',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xFFD32F2F),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'How would you like to receive your order?'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppRadioTile<int>(
                          value: 0,
                          groupValue: selected,
                          onChanged: (int? v) => setState(() => selected = v!),
                          icon: Icons.local_shipping_outlined,
                          title: 'Home Delivery'.tr(),
                          subtitle: 'Delivered to your address'.tr(),
                        ),
                        const SizedBox(height: 12),
                        AppRadioTile<int>(
                          value: 1,
                          groupValue: selected,
                          onChanged: (int? v) => setState(() => selected = v!),
                          icon: Icons.location_on_outlined,
                          title: 'Pickup Point'.tr(),
                          subtitle: 'Collect from a nearby location'.tr(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context, null),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade400),
                                  textStyle: const TextStyle(fontSize: 16),
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                child: Text('Cancel'.tr()),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: <Color>[
                                      Color(0xFFD32F2F),
                                      Color(0xFF009688),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, selected == 1),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48),
                                    textStyle: const TextStyle(fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Continue'.tr(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  Future<void> _handlePickupDelivery(BuildContext context) async {
    final AddressEntity? address = _defaultAddress;
    if (address == null || address.postalCode.isEmpty) {
      if (mounted) {
        AppSnackBar.showSnackBar(
          context,
          'please_add_delivery_address_before_selecting_pickup'.tr(),
        );
      }
      setState(() => isLoading = false);
      return;
    }

    final ServicePointEntity? servicePoint = await ServicePointsDialog.show(
      context: context,
      cartItemIds: <String>[widget.post.postID],
      postalCode: address.postalCode,
    );

    if (servicePoint == null) {
      setState(() => isLoading = false);
      return;
    }

    // TODO: Store servicePoint.id for use in your order payload
    // After selection, continue with your flow (e.g., shipping option, summary, etc.)
    // You might want to navigate to checkout with the service point information
    _proceedToCheckoutWithServicePoint(servicePoint);
  }

  Future<void> _handleHomeDelivery() async {
    final AddToCartUsecase usecase = AddToCartUsecase(locator());
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

  void _proceedToCheckoutWithServicePoint(ServicePointEntity servicePoint) {
    // TODO: Implement your checkout flow with the selected service point
    // This could involve navigating to a checkout screen with the service point info
    // or storing it in some state management solution
    debugPrint('Selected service point: ${servicePoint.id}');

    // For now, we'll just show a success message
    if (mounted && widget.onSuccess != null) {
      widget.onSuccess!();
    }
  }

  Future<void> _buyNow(BuildContext context) async {
    if (isLoading) return; // Prevent double taps

    setState(() => isLoading = true);

    try {
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
        setState(() => isLoading = false);
        return;
      }

      // Ask user for delivery method
      final bool? isPickup = await _askDeliveryMethod(context);
      if (isPickup == null) {
        setState(() => isLoading = false);
        return;
      }

      if (isPickup) {
        await _handlePickupDelivery(context);
      } else {
        await _handleHomeDelivery();
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
