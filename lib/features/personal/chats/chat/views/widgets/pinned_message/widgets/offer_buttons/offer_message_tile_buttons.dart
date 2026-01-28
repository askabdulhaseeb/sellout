import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../post/domain/entities/offer/offer_detail_entity.dart';
import '../../../../../../../home/view/enums/counter_offer_enum.dart';
import '../../../../../../../home/view/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_message_tile_buyer_buttons.dart';
import 'offer_message_tile_seller_buttons.dart';

class OfferMessageTileButtons extends HookWidget {
  const OfferMessageTileButtons({required this.message, super.key});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, _) {
        final OfferDetailEntity? offerDetail = message.offerDetail;
        if (offerDetail == null) return const SizedBox.shrink();

        final String? uid = LocalAuth.uid;
        final bool isBuyer = offerDetail.buyerId == uid;
        final bool isSeller = offerDetail.sellerId == uid;
        final bool isPending = offerDetail.offerStatus == StatusType.pending;
        final bool isAccepted = offerDetail.offerStatus == StatusType.accepted;

        //
        final CounterOfferEnum? counterBy = offerDetail.counterBy;

        //
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Show buttons to seller if counterBy is null or by buyer
            if (isSeller &&
                isPending &&
                (counterBy == null || counterBy == CounterOfferEnum.buyer))
              OfferTileUpdateButons(message: message, counterBy: counterBy),
            // Show buttons to buyer if counterBy is by seller
            if (isBuyer && isPending && counterBy == CounterOfferEnum.seller)
              OfferTileUpdateButons(message: message, counterBy: counterBy),
            // Buyer and offer accepted: show buy-now
            if (isBuyer && isAccepted) OfferTileBuyerButtons(message: message),
          ],
        );
      },
    );
  }
}
