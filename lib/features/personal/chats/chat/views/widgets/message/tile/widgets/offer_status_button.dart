import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'counter_offer_bottomsheet.dart';

class OfferStatusButtons extends StatelessWidget {
  const OfferStatusButtons({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  void showOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        TextEditingController offerController = TextEditingController(
            text: message.offerDetail?.offerPrice.toString());
        TextEditingController quantityController = TextEditingController(
          text: '1',
        );
        return CounterBottomSheet(
            offerController: offerController,
            quantityController: quantityController,
            message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, _) {
        return Row(
          spacing: 4,
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  textColor: Theme.of(context).primaryColor,
                  bgColor: Colors.transparent,
                  title: 'decline'.tr(),
                  isLoading: false,
                  onTap: () {
                    pro.updateOfferStatus(
                        chatId: message.chatId,
                        context: context,
                        offerStatus: OfferStatus.accept.value,
                        offerId: message.offerDetail!.offerId);
                  }),
            ),
            Expanded(
              child: CustomElevatedButton(
                  borderRadius: BorderRadius.circular(10),
                  textColor: Theme.of(context).primaryColor,
                  bgColor: Theme.of(context).primaryColor.withAlpha(20),
                  title: 'counter'.tr(),
                  isLoading: false,
                  onTap: () {
                    showOfferBottomSheet(context);
                  }),
            ),
            Expanded(
              child: CustomElevatedButton(
                  borderRadius: BorderRadius.circular(10),
                  title: 'accept'.tr(),
                  isLoading: false,
                  onTap: () {
                    pro.updateOfferStatus(
                        chatId: message.chatId,
                        context: context,
                        offerStatus: OfferStatus.accept.value,
                        offerId: message.offerDetail!.offerId);
                  }),
            )
          ],
        );
      },
    );
  }
}
