import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class OfferMessageTile extends StatelessWidget {
  const OfferMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final String price = message.visitingDetail?.post.price.toString() ??
        message.offerDetail?.post.price.toString() ??
        'na'.tr();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ShadowContainer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        CustomNetworkImage(imageURL: message.postImage ?? ''),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        message.visitingDetail?.post.title ??
                            message.offerDetail?.post.title ??
                            'na'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${message.offerDetail?.currency.toUpperCase()} $price',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
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
                            '${message.offerDetail?.currency.toUpperCase()} ${message.offerDetail?.offerPrice.toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            price,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(message.offerDetail?.offerStatus ?? 'na'.tr()),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: 0.6,
                child: Text(message.createdAt.timeAgo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}