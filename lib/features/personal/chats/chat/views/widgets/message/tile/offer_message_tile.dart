import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../pinned_message.dart/widgets/offer_buttons/offer_message_tile_buttons.dart';

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
    debugPrint(message.offerDetail?.offerId);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: showButtons
              ? Colors.transparent
              : ColorScheme.of(context).outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
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
    return Row(
      children: <Widget>[
        // Animate image size if you expect changes
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                // Title transition if it changes
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    message.offerDetail?.postTitle ?? 'na'.tr(),
                    key: ValueKey(message.offerDetail?.postTitle),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 4),
                // Price detail transition
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    '${CountryHelper.currencySymbolHelper(message.offerDetail?.currency)}.${message.offerDetail?.price} X ${message.offerDetail?.quantity}',
                    key: ValueKey(
                        '${message.offerDetail?.price}-${message.offerDetail?.quantity}'),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorScheme.of(context).outline,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Counter badge animated with fade
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: (message.offerDetail?.counterBy != null)
                      ? Container(
                          key: const ValueKey('counter'),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                            color: ColorScheme.of(context)
                                .outlineVariant
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: ColorScheme.of(context).outlineVariant),
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            spacing: 4,
                            children: <Widget>[
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: message.offerDetail?.counterBy?.color,
                              ),
                              Text(
                                message.offerDetail?.counterBy?.code.tr() ??
                                    'na'.tr(),
                                style: TextTheme.of(context).labelSmall,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Offer price/status block animated
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: ColorScheme.of(context).outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      '${CountryHelper.currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.offerPrice ?? ''}',
                      key: ValueKey(message.offerDetail?.offerPrice),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      '${CountryHelper.currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.price}',
                      key: ValueKey(message.offerDetail?.price),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  message.offerDetail?.offerStatus?.code.tr() ?? 'na'.tr(),
                  key: ValueKey(message.offerDetail?.offerStatus?.code),
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
