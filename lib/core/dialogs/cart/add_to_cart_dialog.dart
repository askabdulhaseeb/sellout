import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/color_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/size_color_entity.dart';
import '../../../features/personal/post/domain/params/add_to_cart_param.dart';
import '../../../features/personal/post/domain/usecase/add_to_cart_usecase.dart';
import '../../../features/personal/post/feed/views/widgets/post/widgets/section/buttons/type/size_chart_button_tile.dart';
import '../../../services/get_it.dart';
import '../../extension/string_ext.dart';
import '../../functions/app_log.dart';
import '../../sources/api_call.dart';
import '../../widgets/app_snakebar.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_elevated_button.dart';

class AddToCartDialog extends StatefulWidget {
  const AddToCartDialog({required this.post, super.key});
  final PostEntity post;

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  bool showSizeColor = false;
  SizeColorEntity? selectedSize;
  ColorEntity? selectedColor;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(width: 24),
                const Text(
                  'select_size_color',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ).tr(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            // Sizing
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomDropdown<SizeColorEntity>(
                    title: 'size'.tr(),
                    hint: 'size'.tr(),
                    items: widget.post.clothFootInfo.sizeColors
                        .map((SizeColorEntity e) =>
                            DropdownMenuItem<SizeColorEntity>(
                              value: e,
                              child: Text(e.value),
                            ))
                        .toList(),
                    selectedItem: selectedSize,
                    onChanged: (SizeColorEntity? value) {
                      if (value != null) {
                        setState(() {
                          selectedSize = value;
                        });
                      }
                    },
                    validator: (_) => null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown<ColorEntity>(
                    title: 'color'.tr(),
                    hint: 'color'.tr(),
                    items: (selectedSize?.colors ?? <ColorEntity>[])
                        .where((ColorEntity e) => e.quantity > 0)
                        .map((ColorEntity e) => DropdownMenuItem<ColorEntity>(
                              value: e,
                              child: Text(
                                e.code,
                                style: TextStyle(
                                  color: e.code.toColor(),
                                ),
                              ),
                            ))
                        .toList(),
                    selectedItem: selectedColor,
                    onChanged: (ColorEntity? value) {
                      if (value != null) {
                        setState(() {
                          selectedColor = value;
                        });
                      }
                    },
                    validator: (_) => null,
                  ),
                ),
              ],
            ),
            // Chart
            if (widget.post.clothFootInfo.sizeChartUrl != null)
              SizeChartButtonTile(
                  sizeChartURL:
                      widget.post.clothFootInfo.sizeChartUrl?.url ?? ''), //
            // Add to cart button

            CustomElevatedButton(
              title: 'add_to_basket'.tr(),
              isLoading: isLoading,
              onTap: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  final AddToCartUsecase usecase = AddToCartUsecase(locator());
                  final DataState<bool> result = await usecase(
                    AddToCartParam(
                      post: widget.post,
                      size: selectedSize,
                      color: selectedColor,
                    ),
                  );
                  if (result is DataSuccess) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    AppLog.error(
                      result.exception?.detail ?? 'ERROR - AddToCartDialog',
                      name: 'AddToCartDialog',
                      error: result.exception,
                    );
                    AppSnackBar.showSnackBar(
                      // ignore: use_build_context_synchronously
                      context,
                      result.exception?.detail ?? 'something_wrong'.tr(),
                    );
                  }
                } catch (e) {
                  AppLog.error(
                    e.toString(),
                    name: 'AddToCartDialog',
                    error: e,
                  );
                  AppSnackBar.showSnackBar(
                    // ignore: use_build_context_synchronously
                    context,
                    e.toString(),
                  );
                }
                setState(() {
                  isLoading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
