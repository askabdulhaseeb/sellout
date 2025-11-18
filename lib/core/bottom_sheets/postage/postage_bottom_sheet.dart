import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import 'widgets/postage_header.dart';
import 'widgets/postage_list.dart';

class PostageBottomSheet extends StatefulWidget {
  const PostageBottomSheet({required this.postage, super.key});
  final PostageDetailResponseEntity postage;

  @override
  State<PostageBottomSheet> createState() => _PostageBottomSheetState();
}

class _PostageBottomSheetState extends State<PostageBottomSheet> {
  late Map<String, RateEntity> _selected;

  @override
  void initState() {
    super.initState();
    final CartProvider cartPro = context.read<CartProvider>();
    _selected = Map<String, RateEntity>.from(cartPro.selectedPostageRates);
  }

  void _setSelected(String postId, RateEntity rate) {
    setState(() {
      _selected[postId] = rate;
    });
    // Persist selection immediately since footer actions were removed
    context.read<CartProvider>().selectPostageRate(postId, rate);
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();
    final PostageDetailResponseEntity postage =
        cartPro.postageResponseEntity ?? widget.postage;
    final List<MapEntry<String, PostageItemDetailEntity>> entries =
        postage.detail.entries.toList();

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
                  onPressed: () => Navigator.of(context).pop(_selected),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PostageList(
              entries: entries,
              selected: _selected,
              onSelect: _setSelected,
              cartPro: cartPro,
            ),
          ],
        ),
      ),
    );
  }
}
