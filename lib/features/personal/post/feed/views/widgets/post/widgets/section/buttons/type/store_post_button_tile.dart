import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import 'size_chart_button_tile.dart';
import 'widgets/post_add_to_basket_button.dart';
import 'widgets/post_buy_now_button.dart';
import 'widgets/post_make_offer_button.dart';

class StorePostButtonTile extends StatefulWidget {
  const StorePostButtonTile(
      {required this.post, required this.detailWidget, super.key});
  final PostEntity post;
  final bool detailWidget;

  @override
  State<StorePostButtonTile> createState() => _StorePostButtonTileState();
}

class _StorePostButtonTileState extends State<StorePostButtonTile> {
  // int quantity = 1;
  SizeColorEntity? selectedSize;
  ColorEntity? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.post.clothFootInfo?.sizeColors != [] && widget.detailWidget)
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: CustomDropdown<SizeColorEntity>(
                  title: '',
                  hint: 'select_your_size'.tr(),
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
                        selectedColor = null;
                      });
                    }
                  },
                  validator: (_) => null,
                ),
              ),
              Expanded(
                child: CustomDropdown<ColorEntity>(
                  title: '',
                  hint: 'select_color'.tr(),
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
        Row(
          spacing: 12,
          children: <Widget>[
            Expanded(
                child: PostBuyNowButton(
              detailWidgetColor: selectedColor,
              detailWidgetSize: selectedSize,
              post: widget.post,
              detailWidget: widget.detailWidget,
            )),
            if (widget.post.acceptOffers == true)
              Expanded(
                  child: PostMakeOfferButton(
                detailWidgetColor: selectedColor,
                detailWidgetSize: selectedSize,
                post: widget.post,
                detailWidget: widget.detailWidget,
              )),
          ],
        ),
        Row(
          spacing: 12,
          children: <Widget>[
            Expanded(
                child: PostAddToBasketButton(
              detailWidget: widget.detailWidget,
              detailWidgetColor: selectedColor,
              detailWidgetSize: selectedSize,
              post: widget.post,
            )),
          ],
        ),
        if (widget.post.clothFootInfo?.sizeColors != null &&
            widget.detailWidget &&
            widget.post.clothFootInfo?.sizeColors != null)
          SizeChartButtonTile(
              sizeChartURL: widget.post.clothFootInfo?.sizeChartUrl?.url ?? '')
      ],
    );
  }
}
