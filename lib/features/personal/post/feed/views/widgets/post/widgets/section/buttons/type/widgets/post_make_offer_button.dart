import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../../../bottomsheets/make_offer_bottomsheet/make_an_offer_bottomsheet.dart';
import '../size_chart_button_tile.dart';

class PostMakeOfferButton extends StatefulWidget {
  const PostMakeOfferButton(
      {required this.post,
      required this.detailWidget,
      this.detailWidgetColor,
      this.detailWidgetSize,
      super.key});
  final PostEntity post;
  final bool detailWidget;
  final SizeColorEntity? detailWidgetSize;
  final ColorEntity? detailWidgetColor;

  @override
  State<PostMakeOfferButton> createState() => _PostMakeOfferButtonState();
}

class _PostMakeOfferButtonState extends State<PostMakeOfferButton> {
  SizeColorEntity? get selectedSize => widget.detailWidgetSize;
  ColorEntity? get selectedColor => widget.detailWidgetColor;

  void _openMakeOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
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

  Future<void> _openSelectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SelectSizeColorDialog(
        post: widget.post,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      bgColor: Theme.of(context).primaryColor,
      onTap: () {
        if (widget.post.clothFootInfo?.sizeColors != null &&
            ListingType.fromJson(widget.post.listID) ==
                ListingType.clothAndFoot &&
            widget.detailWidget == false) {
          _openSelectionDialog(context);
        }
        if (ListingType.fromJson(widget.post.listID) !=
            ListingType.clothAndFoot) {
          _openMakeOfferBottomSheet(context);
        } else if (selectedColor != null &&
            selectedSize != null &&
            widget.detailWidget == true) {
          _openMakeOfferBottomSheet(context);
        } else if (widget.detailWidget == true &&
            selectedSize != null &&
            selectedColor == null) {
          AppSnackBar.showSnackBar(context, 'color_is_required'.tr());
        } else if (widget.detailWidget == true && selectedSize == null) {
          AppSnackBar.showSnackBar(context, 'size_is_required'.tr());
        } else {}
      },
      title: 'make_an_offer'.tr(),
      isLoading: false,
    );
  }
}

class SelectSizeColorDialog extends StatefulWidget {
  const SelectSizeColorDialog({required this.post, super.key});
  final PostEntity post;

  @override
  State<SelectSizeColorDialog> createState() => _SelectSizeColorDialogState();
}

class _SelectSizeColorDialogState extends State<SelectSizeColorDialog> {
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
                    items: widget.post.clothFootInfo!.sizeColors
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
            if (widget.post.clothFootInfo?.sizeChartUrl != null)
              SizeChartButtonTile(
                  sizeChartURL:
                      widget.post.clothFootInfo?.sizeChartUrl?.url ?? '') //
            ,
            CustomElevatedButton(
              title: 'make_offer'.tr(),
              isLoading: isLoading,
              onTap: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });

                  if (selectedSize != null && selectedColor != null) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (_) => MakeOfferBottomSheet(
                        post: widget.post,
                        selectedSize: selectedSize?.value,
                        selectedColor: selectedColor,
                      ),
                    );
                  } else if (selectedSize == null) {
                    AppSnackBar.showSnackBar(
                      context,
                      'size_is_required'.tr(),
                    );
                  } else if (selectedColor == null) {
                    AppSnackBar.showSnackBar(
                      context,
                      'color_is_required'.tr(),
                    );
                  }
                } catch (e) {
                  AppLog.error(
                    e.toString(),
                    name: 'SelectSizeColorDialog',
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
