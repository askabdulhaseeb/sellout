import 'package:flutter/material.dart';
import '../../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import 'postage_item_card.dart';

class PostageList extends StatelessWidget {
  const PostageList({
    required this.entries,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    Key? key,
  }) : super(key: key);

  final List<MapEntry<String, PostageItemDetailEntity>> entries;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final String postId = entries[index].key;
          final PostageItemDetailEntity detail = entries[index].value;
          return PostageItemCard(
            postId: postId,
            detail: detail,
            selected: selected,
            onSelect: onSelect,
            cartPro: cartPro,
          );
        },
      ),
    );
  }
}
