import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../payment/domain/entities/wallet_funds_in_hold_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import 'balance_detail_row.dart';

class FundsInHoldItemCard extends StatelessWidget {
  const FundsInHoldItemCard({
    required this.hold,
    required this.order,
    required this.post,
    super.key,
  });

  final WalletFundsInHoldEntity hold;
  final OrderEntity? order;
  final PostEntity? post;

  String _formatStatus(String status) {
    final String key = status.toLowerCase();
    // Try to get localized version, fallback to capitalized
    try {
      return key.tr();
    } catch (_) {
      return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = post?.title.trim().isNotEmpty == true
        ? post!.title
        : hold.postId;

    final String? imageUrl = (post?.fileUrls.isNotEmpty == true)
        ? post!.fileUrls.first.url
        : null;

    final String symbol = CountryHelper.currencySymbolHelper(hold.currency);
    final String amountStr = '$symbol${hold.amount.toStringAsFixed(2)}';

    final String releaseAtStr =
        hold.releaseAt.toDateTime()?.dateTime ?? hold.releaseAt;

    final String orderId = order?.orderId ?? hold.orderId;

    return ShadowContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: imageUrl == null
                      ? Container(
                          color: Colors.black12,
                          child: const Icon(Icons.image_not_supported),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return Container(
                                  color: Colors.black12,
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'order'.tr()}: $orderId',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amountStr,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          BalanceDetailRow(labelKey: 'amount', value: amountStr),
          BalanceDetailRow(
            labelKey: 'status',
            value: _formatStatus(hold.status),
          ),
          BalanceDetailRow(labelKey: 'release_at', value: releaseAtStr),
        ],
      ),
    );
  }
}
