import 'package:flutter/material.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_buy_now_button.dart';

class OfferTileBuyerButtons extends StatelessWidget {
  const OfferTileBuyerButtons({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: <Widget>[
        OfferBuyNowButton(
          offerId: message.offerDetail?.offerId ?? '',
        ),
      ],
    );
  }
}
