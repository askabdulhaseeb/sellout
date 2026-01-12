import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../features/personal/basket/views/screens/personal_shopping_basket_screen.dart';
import '../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/color_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/size_color_entity.dart';
import '../../../features/personal/post/feed/views/widgets/post/widgets/section/bottomsheets/make_offer_bottomsheet/make_an_offer_bottomsheet.dart';
import '../../../features/personal/post/feed/views/widgets/post/widgets/section/buttons/type/size_chart_button_tile.dart';
import '../../../services/get_it.dart';
import '../../extension/string_ext.dart';
import '../../functions/app_log.dart';
import '../../sources/data_state.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../../features/personal/post/domain/usecase/add_to_cart_usecase.dart';
import '../../../features/personal/post/domain/params/add_to_cart_param.dart';

/// Unified dialog for Add to Cart, Buy Now, and Make Offer
enum PostTileClothFootType { add, buy, offer }

class PostTileClothFootDialog extends StatefulWidget {
  const PostTileClothFootDialog({
    required this.post,
    required this.actionType,
    super.key,
  });
  final PostEntity post;

  /// Use [PostTileClothFootType] to indicate which primary action the dialog should perform.
  final PostTileClothFootType actionType;

  @override
  State<PostTileClothFootDialog> createState() =>
      _PostTileClothFootDialogState();
}

class _PostTileClothFootDialogState extends State<PostTileClothFootDialog> {
  SizeColorEntity? selectedSize;
  ColorEntity? selectedColor;
  bool isLoading = false;

  Widget _colorTile(String code) {
    return Container(
      width: double.infinity,
      height: 32,
      decoration: BoxDecoration(
        color: code.toColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }

  String get _buttonTitle {
    switch (widget.actionType) {
      case PostTileClothFootType.buy:
        return 'buy_now'.tr();
      case PostTileClothFootType.offer:
        return 'make_offer'.tr();
      case PostTileClothFootType.add:
        return 'add_to_basket'.tr();
    }
  }

  Future<void> _handleAction(BuildContext context) async {
    if (isLoading) return;
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      if (widget.actionType == PostTileClothFootType.offer) {
        if (selectedSize == null) {
          if (mounted) {
            AppSnackBar.showSnackBar(context, 'size_is_required'.tr());
          }
        } else if (selectedColor == null) {
          if (mounted) {
            AppSnackBar.showSnackBar(context, 'color_is_required'.tr());
          }
        } else {
          await showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (_) => MakeOfferBottomSheet(
              post: widget.post,
              selectedSize: selectedSize?.value,
              selectedColor: selectedColor,
            ),
          );
        }
      } else {
        final AddToCartUsecase usecase = AddToCartUsecase(locator());
        final DataState<bool> result = await usecase(
          AddToCartParam(
            post: widget.post,
            size: selectedSize,
            color: selectedColor,
          ),
        );

        if (!context.mounted) return;
        if (result is DataSuccess) {
          if (widget.actionType == PostTileClothFootType.buy) {
            await Navigator.of(
              context,
            ).pushNamed(PersonalShoppingBasketScreen.routeName);
            if (!mounted) return;
          } else {
            if (context.mounted) {
              Navigator.of(context).pop();
              AppSnackBar.success(context, 'successfull_add_to_basket'.tr());
            }
          }
        } else {
          AppLog.error(
            result.exception?.detail ?? 'Action Failed',
            name: 'PostTileClothFootDialog',
          );
          if (mounted) {
            AppSnackBar.error(
              context,
              result.exception?.detail ?? 'something_wrong'.tr(),
            );
          }
        }
      }
    } catch (e, stack) {
      AppLog.error(
        e.toString(),
        name: 'PostTileClothFootDialog',
        stackTrace: stack,
      );
      if (context.mounted) AppSnackBar.error(context, 'something_wrong'.tr());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: <Widget>[
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(width: 24),
                Text(
                  'select_size_color'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            // Dropdowns
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<SizeColorEntity>(
                    title: 'size'.tr(),
                    hint: 'size'.tr(),
                    items:
                        widget.post.clothFootInfo?.sizeColors
                            .map(
                              (SizeColorEntity e) =>
                                  DropdownMenuItem<SizeColorEntity>(
                                    value: e,
                                    child: Text(e.value),
                                  ),
                            )
                            .toList() ??
                        <DropdownMenuItem<SizeColorEntity>>[],
                    selectedItem: selectedSize,
                    onChanged: (SizeColorEntity? value) => setState(() {
                      selectedSize = value;
                      selectedColor = null;
                    }),
                    validator: (_) => null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown<ColorEntity>(
                    title: 'color'.tr(),
                    hint: 'color'.tr(),
                    selectedItemBuilder: (ColorEntity? value) =>
                        value == null ? null : _colorTile(value.code),
                    items: (selectedSize?.colors ?? <ColorEntity>[])
                        .where((ColorEntity e) => e.quantity > 0)
                        .map(
                          (ColorEntity e) => DropdownMenuItem<ColorEntity>(
                            value: e,
                            child: _colorTile(e.code),
                          ),
                        )
                        .toList(),
                    selectedItem: selectedColor,
                    onChanged: (ColorEntity? value) =>
                        setState(() => selectedColor = value),
                    validator: (_) => null,
                  ),
                ),
              ],
            ),

            // Size Chart if present
            if (widget.post.clothFootInfo?.sizeChartUrl != null)
              SizeChartButtonTile(
                sizeChartURL:
                    widget.post.clothFootInfo?.sizeChartUrl?.url ?? '',
              ),

            // Action button
            CustomElevatedButton(
              title: _buttonTitle,
              isLoading: isLoading,
              onTap: () => _handleAction(context),
            ),
          ],
        ),
      ),
    );
  }
}
