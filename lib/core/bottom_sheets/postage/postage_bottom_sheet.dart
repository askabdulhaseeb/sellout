import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import 'widgets/postage_header.dart';
import 'widgets/postage_list.dart';
import 'widgets/postage_footer.dart';

// MARK: Postage Bottom Sheet
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
  }

  void _applySelection(
      PostageDetailResponseEntity postage, CartProvider cartPro) {
    // Ensure each postId has a selected rate; if not, pick the first available or synthesize free
    postage.detail.forEach((String postId, PostageItemDetailEntity detail) {
      if (!_selected.containsKey(postId)) {
        final List<RateEntity> rates = detail.shippingDetails
            .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
            .toList();
        if (rates.isNotEmpty) {
          _selected[postId] = rates.first;
        } else {
          final bool isFreeDelivery =
              detail.originalDeliveryType.toLowerCase() == 'free' ||
                  detail.originalDeliveryType.toLowerCase() == 'collection' ||
                  (detail.message != null &&
                      detail.message!.toLowerCase().contains('free'));
          if (isFreeDelivery) {
            final RateEntity freeRate = RateEntity(
              amount: '0.00',
              provider: '',
              providerImage75: '',
              providerImage200: '',
              amountBuffered: '0.00',
              serviceLevel: ServiceLevelEntity(name: 'Free', token: 'free'),
            );
            _selected[postId] = freeRate;
          }
        }
      }
    });

    _selected.forEach((String postId, RateEntity rate) {
      cartPro.selectPostageRate(postId, rate);
    });
    Navigator.of(context).pop(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartPro = context.read<CartProvider>();
    final PostageDetailResponseEntity postage =
        _cartPro.postageResponseEntity ?? widget.postage;
    final List<MapEntry<String, PostageItemDetailEntity>> entries =
        postage.detail.entries.toList();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const PostageHeader(),
            const SizedBox(height: 8),
            PostageList(
              entries: entries,
              selected: _selected,
              onSelect: _setSelected,
              cartPro: _cartPro,
            ),
            PostageFooter(
              postage: postage,
              cartPro: _cartPro,
              onApply: () => _applySelection(postage, _cartPro),
            ),
          ],
        ),
      ),
    );
  }
}
