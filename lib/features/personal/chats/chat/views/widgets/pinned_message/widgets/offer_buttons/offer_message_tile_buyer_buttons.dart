import 'package:flutter/material.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_buy_now_button.dart';
import 'offer_get_shipping_button.dart';

class OfferTileBuyerButtons extends StatefulWidget {
  const OfferTileBuyerButtons({required this.message, super.key});

  final MessageEntity message;

  @override
  State<OfferTileBuyerButtons> createState() => _OfferTileBuyerButtonsState();
}

class _OfferTileBuyerButtonsState extends State<OfferTileBuyerButtons> {
  bool _shippingAddedLocally = false;

  void _onShippingAdded() {
    setState(() => _shippingAddedLocally = true);
  }

  bool get _hasShipping =>
      widget.message.offerDetail?.shippingAdded == true || _shippingAddedLocally;

  @override
  Widget build(BuildContext context) {
    final String offerId = widget.message.offerDetail?.offerId ?? '';
    final String postId = widget.message.offerDetail?.postId ?? '';

    // Show Buy Now button if shipping has been added
    if (_hasShipping) {
      return Row(
        spacing: 4,
        children: <Widget>[
          OfferBuyNowButton(
            offerId: offerId,
            postId: postId,
          ),
        ],
      );
    }

    // Show Get Shipping button if shipping not yet added
    return Row(
      spacing: 4,
      children: <Widget>[
        OfferGetShippingButton(
          offerId: offerId,
          postId: postId,
          onShippingAdded: _onShippingAdded,
        ),
      ],
    );
  }
}
