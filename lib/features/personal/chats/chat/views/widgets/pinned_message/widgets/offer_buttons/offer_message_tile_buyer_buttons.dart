import 'package:flutter/material.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_buy_now_button.dart';

class OfferTileBuyerButtons extends StatelessWidget {
  const OfferTileBuyerButtons({required this.message, super.key});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final String offerId = message.offerDetail?.offerId ?? '';
    final String postId = message.offerDetail?.postId ?? '';

    // Show Buy Now directly; flow handles address, shipping, and payment sheet
    return Row(
      spacing: 4,
      children: <Widget>[
        OfferBuyNowButton(message: message, postId: postId, isOffer: true),
      ],
    );
  }
}
