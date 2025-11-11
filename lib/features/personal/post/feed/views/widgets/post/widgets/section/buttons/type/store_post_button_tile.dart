import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
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
  SizeColorEntity? selectedSize;
  ColorEntity? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.post.type == ListingType.clothAndFoot && widget.detailWidget)
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
        // Collection Section
        CollectionSection(
          post: widget.post,
          detailWidget: widget.detailWidget,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ),
        const SizedBox(height: 12),
        
        // Delivery Section
        DeliverySection(
          post: widget.post,
          detailWidget: widget.detailWidget,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ),
        if (widget.post.type == ListingType.clothAndFoot && widget.detailWidget)
          SizeChartButtonTile(
              sizeChartURL: widget.post.clothFootInfo?.sizeChartUrl?.url ?? '')
      ],
    );
  }
}


class DeliverySection extends StatelessWidget {
  const DeliverySection({
    required this.post,
    required this.detailWidget,
    this.selectedColor,
    this.selectedSize,
    super.key,
  });

  final PostEntity post;
  final bool detailWidget;
  final ColorEntity? selectedColor;
  final SizeColorEntity? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'delivery'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: PostBuyNowButton(
                  detailWidgetColor: selectedColor,
                  detailWidgetSize: selectedSize,
                  post: post,
                  detailWidget: detailWidget,
                ),
              ),
              if (post.acceptOffers == true)
                Expanded(
                  child: PostMakeOfferButton(
                    detailWidgetColor: selectedColor,
                    detailWidgetSize: selectedSize,
                    post: post,
                    detailWidget: detailWidget,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: PostAddToBasketButton(
                  detailWidget: detailWidget,
                  detailWidgetColor: selectedColor,
                  detailWidgetSize: selectedSize,
                  post: post,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CollectionSection extends StatelessWidget {
  const CollectionSection({
    required this.post,
    required this.detailWidget,
    this.selectedColor,
    this.selectedSize,
    super.key,
  });

  final PostEntity post;
  final bool detailWidget;
  final ColorEntity? selectedColor;
  final SizeColorEntity? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'collection'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Contact seller functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('contact_seller'.tr()),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect in-store functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('collect_in_store'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
