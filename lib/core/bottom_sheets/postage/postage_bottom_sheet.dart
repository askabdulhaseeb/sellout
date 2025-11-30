import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../features/postage/domain/entities/postage_detail_response_entity.dart';
import 'widgets/postage_header.dart';
import 'widgets/postage_item_card.dart';

class PostageBottomSheet extends StatefulWidget {
  const PostageBottomSheet({super.key});

  @override
  State<PostageBottomSheet> createState() => _PostageBottomSheetState();
}

class _PostageBottomSheetState extends State<PostageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();
    final PostageDetailResponseEntity? postage = cartPro.postageResponseEntity;
    final List<PostageItemDetailEntity>? entries = postage?.detail;

    if (postage == null || entries == null || entries.isEmpty) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No shipping options available.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(child: PostageHeader()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      Navigator.of(context).pop(cartPro.selectedShippingItems),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                cacheExtent: 5000,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final String cartItemId = entries[index].cartItemId;
                  final PostageItemDetailEntity detail = entries[index];
                  return PostageItemCard(
                    cartItemId: cartItemId,
                    detail: detail,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
