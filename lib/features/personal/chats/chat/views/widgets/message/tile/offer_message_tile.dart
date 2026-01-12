import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../pinned_message/widgets/offer_buttons/offer_message_tile_buttons.dart';
import '../common/currency_display.dart';
import '../common/message_container.dart';

class OfferMessageTile extends StatelessWidget {
  const OfferMessageTile({
    required this.message,
    required this.showButtons,
    super.key,
  });

  final MessageEntity message;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
      showBorder: !showButtons,
      animate: true,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          OfferMessageTileDetail(message: message),
          const SizedBox(height: 6),
          // Smoothly appear/disappear buttons
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: showButtons
                ? OfferMessageTileButtons(message: message)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class OfferMessageTileDetail extends StatelessWidget {
  const OfferMessageTileDetail({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final offerDetail = message.offerDetail;

    return Row(
      children: <Widget>[
        // Product image
        SizedBox(
          height: 60,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(imageURL: message.fileUrl.first.url),
          ),
        ),
        const SizedBox(width: 8),

        // Title, price, and counter badge
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                offerDetail?.postTitle ?? 'na'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              CurrencyDisplay(
                currency: offerDetail?.currency,
                price: offerDetail?.price,
                suffix: ' X ${offerDetail?.quantity ?? 1}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorScheme.of(context).outline,
                  fontSize: 12,
                ),
              ),
              // Counter badge
              if (offerDetail?.counterBy != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context)
                        .outlineVariant
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: ColorScheme.of(context).outlineVariant,
                    ),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    children: <Widget>[
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: offerDetail?.counterBy?.color,
                      ),
                      Text(
                        offerDetail?.counterBy?.code.tr() ?? 'na'.tr(),
                        style: TextTheme.of(context).labelSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Offer price/status block
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: ColorScheme.of(context).outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CurrencyDisplayWithOriginal(
                currency: offerDetail?.currency,
                offerPrice: offerDetail?.offerPrice,
                originalPrice: offerDetail?.price,
                offerStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                originalStyle: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              // Status with animation for changes
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  offerDetail?.offerStatus?.code.tr() ?? 'na'.tr(),
                  key: ValueKey(offerDetail?.offerStatus?.code),
                  style: TextTheme.of(context).labelSmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
