import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../providers/chat_provider.dart';

class CounterBottomSheet extends StatelessWidget {
  const CounterBottomSheet({
    required this.offerController,
    required this.quantityController,
    required this.message,
    super.key,
  });

  final TextEditingController offerController;
  final TextEditingController quantityController;
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title
          Text('Counter Offer', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          TextField(
            controller: offerController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<FeedProvider>(
            builder: (BuildContext context, FeedProvider pro, Widget? child) =>
                CustomElevatedButton(
              onTap: () {
                pro.updateOffer(
                  chatId: message.chatId,
                  quantity: int.parse(quantityController.text),
                  businessId: 'null',
                  context: context,
                  offerStatus: OfferStatus.accept.value,
                  offerId: message.offerDetail!.offerId,
                  messageID: message.messageId,
                  minoffer: message.offerDetail!.minOfferAmount,
                  offerAmount: int.parse(offerController.text),
                );
                Provider.of<ChatProvider>(context, listen: false).getMessages();
                Navigator.pop(context);
              },
              title: 'make_offer'.tr(),
              isLoading: false,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('${'quantity'.tr()}:',
                  style: Theme.of(context).textTheme.titleMedium),
              Expanded(
                child: CustomTextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 18),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(width: 10),
              InDevMode(
                child: Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Add Message',
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
