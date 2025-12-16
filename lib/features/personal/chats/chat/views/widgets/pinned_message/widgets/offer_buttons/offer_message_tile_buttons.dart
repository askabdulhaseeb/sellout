import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../post/domain/entities/offer/offer_detail_entity.dart';
import '../../../../../../../post/feed/views/enums/counter_offer_enum.dart';
import '../../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_message_tile_buyer_buttons.dart';
import 'offer_message_tile_seller_buttons.dart';

class OfferMessageTileButtons extends HookWidget {
  const OfferMessageTileButtons({
    required this.message,
    super.key,
  });

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
            if (isSeller && counterBy == CounterOfferEnum.seller && isPending)
              OfferTileUpdateButons(message: message),
            if (isBuyer && counterBy == CounterOfferEnum.buyer && isPending)
              OfferTileUpdateButons(message: message),
            if (isSeller && counterBy == null && isPending)
              OfferTileUpdateButons(message: message),
            if (isBuyer && isAccepted) OfferTileBuyerButtons(message: message),
          ],
        );
      },
    );
  }
}
