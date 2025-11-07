import 'package:flutter/material.dart';
import '../../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import 'post_header_widget.dart';
import 'rates_section.dart';

class PostageItemCard extends StatelessWidget {
  const PostageItemCard({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    Key? key,
  }) : super(key: key);

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostHeaderWidget(postId: postId),
          const SizedBox(height: 8),
          RatesSection(
            postId: postId,
            detail: detail,
            selected: selected,
            onSelect: onSelect,
            cartPro: cartPro,
          ),
        ],
      ),
    );
  }
}
