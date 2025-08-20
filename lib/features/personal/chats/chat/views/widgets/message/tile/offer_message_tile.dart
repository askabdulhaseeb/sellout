import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'widgets/offer_status_button.dart';

class OfferMessageTile extends StatelessWidget {
  const OfferMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    // final FeedProvider pro = Provider.of<FeedProvider>(context, listen: false);
    final String? offerStatus = message.offerDetail?.offerStatus;
    debugPrint(message.offerDetail?.offerId);
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        spacing: 6,
        children: <Widget>[
          Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).dividerColor),
          OfferMessageTileDetail(message: message, offerStatus: offerStatus),
          OfferMessageTileButtons(message: message),
          Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }
}

class OfferMessageTileDetail extends StatelessWidget {
  const OfferMessageTileDetail({
    required this.message,
    required this.offerStatus,
    super.key,
  });

  final MessageEntity message;
  final String? offerStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 60,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(imageURL: message.fileUrl.first.url),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.offerDetail?.postTitle ?? 'na'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${CountryHelper.currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.price}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${CountryHelper.currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.offerPrice ?? ''}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 2,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${CountryHelper.currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.price}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(offerStatus ?? 'na'.tr()),
            ],
          ),
        ),
      ],
    );
  }
}
