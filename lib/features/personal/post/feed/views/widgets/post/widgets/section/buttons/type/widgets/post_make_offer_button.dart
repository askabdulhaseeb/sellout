import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../../../bottomsheets/make_offer_bottomsheet/make_an_offer_bottomsheet.dart';
import '../size_chart_button_tile.dart';

class PostMakeOfferButton extends StatefulWidget {
  const PostMakeOfferButton(
      {required this.post, required this.detailWidget, super.key});
  final PostEntity post;
  final bool detailWidget;

  @override
  State<PostMakeOfferButton> createState() => _PostMakeOfferButtonState();
}

class _PostMakeOfferButtonState extends State<PostMakeOfferButton> {
  String? selectedSize;
  ColorEntity? selectedColor;

  void _openMakeOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (_) => MakeOfferBottomSheet(
        post: widget.post,
        selectedSize: selectedSize,
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
        onNextTap: (String? size, String? color) {
          selectedSize = size;
          selectedColor = widget.post.sizeColors
              .firstWhere((SizeColorEntity e) => e.value == size)
              .colors
              .firstWhere((ColorEntity c) => c.code == color);
          _openMakeOfferBottomSheet(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      bgColor: Theme.of(context).primaryColor,
      onTap: () {
        if (widget.post.sizeColors.isNotEmpty && widget.detailWidget == false) {
          _openSelectionDialog(context);
        } else {
          _openMakeOfferBottomSheet(context);
        }
      },
      title: 'make_an_offer'.tr(),
      isLoading: false,
    );
  }
}

class SelectSizeColorDialog extends StatefulWidget {
  const SelectSizeColorDialog({
    required this.post,
    required this.onNextTap,
    super.key,
  });

  final PostEntity post;
  final Function(String? size, String? color) onNextTap;

  @override
  State<SelectSizeColorDialog> createState() => _SelectSizeColorDialogState();
}

class _SelectSizeColorDialogState extends State<SelectSizeColorDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SizeColorEntity? selectedSize;
  ColorEntity? selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: <Widget>[
          CloseButton(),
          SizedBox(width: 10),
          Flexible(child: AppBarTitle(titleKey: 'select_size_color')),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomDropdown<SizeColorEntity>(
                      title: 'size'.tr(),
                      hint: 'size'.tr(),
                      items: widget.post.sizeColors
                          .map(
                            (SizeColorEntity e) =>
                                DropdownMenuItem<SizeColorEntity>(
                              value: e,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      selectedItem: selectedSize,
                      onChanged: (SizeColorEntity? value) {
                        setState(() {
                          selectedSize = value;
                          selectedColor = null;
                        });
                      },
                      validator: (_) {
                        if (selectedSize == null) {
                          return 'size_is_required'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDropdown<ColorEntity>(
                      title: 'color'.tr(),
                      hint: 'color'.tr(),
                      items: (selectedSize?.colors ?? <ColorEntity>[])
                          .where((ColorEntity e) => e.quantity > 0)
                          .map(
                            (ColorEntity e) => DropdownMenuItem<ColorEntity>(
                              value: e,
                              child: Text(
                                e.code,
                                style: TextStyle(color: e.code.toColor()),
                              ),
                            ),
                          )
                          .toList(),
                      selectedItem: selectedColor,
                      onChanged: (ColorEntity? value) {
                        setState(() {
                          selectedColor = value;
                        });
                      },
                      validator: (_) {
                        if (selectedColor == null) {
                          return 'color_is_required'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizeChartButtonTile(
                  sizeChartURL: widget.post.sizeChartUrl?.url ?? ''),
              CustomElevatedButton(
                isLoading: false,
                title: 'next'.tr(),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    widget.onNextTap(
                      selectedSize?.value ?? '',
                      selectedColor?.code,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
