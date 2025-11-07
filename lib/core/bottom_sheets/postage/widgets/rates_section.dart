import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../enums/listing/core/delivery_type.dart';
import '../../../sources/data_state.dart';

class RatesSection extends StatelessWidget {
  const RatesSection({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    super.key,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    final List<RateEntity> rates = detail.shippingDetails
        .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
        .toList();

    if (rates.isEmpty) {
      final String rawType = detail.originalDeliveryType;
      final DeliveryType displayType = DeliveryType.fromJson(rawType);

      Widget tag = Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: displayType.bgColor.withOpacity(1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: displayType.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.circle,
              size: 8,
              color: displayType.color.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              displayType.code.tr(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: displayType.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      );

      final bool offerRemoval = displayType != DeliveryType.freeDelivery;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              tag,
              const SizedBox(width: 12),
              if (detail.message != null)
                Expanded(
                    child: Text(detail.message!,
                        style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
          const SizedBox(height: 8),
          if (offerRemoval)
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    final bool confirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext ctx) => AlertDialog(
                            title: Text('remove_item'.tr()),
                            content:
                                Text('remove_item_delivery_unavailable'.tr()),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text('cancel'.tr())),
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text('remove'.tr())),
                            ],
                          ),
                        ) ??
                        false;

                    if (!confirmed) return;

                    final DataState<bool> res =
                        await cartPro.removeItem(detail.id);
                    if (res is DataSuccess<bool> && res.entity == true) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('item_removed'.tr())));
                        Navigator.of(context).pop();
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(res.exception?.message ??
                                'remove_failed'.tr())));
                      }
                    }
                  },
                  child: Text('remove_item'.tr()),
                ),
              ],
            ),
        ],
      );
    }

    final RateEntity defaultRate = rates.first;
    final String defaultKey =
        '${defaultRate.provider}::${defaultRate.serviceLevel.token}::${defaultRate.amountBuffered.isNotEmpty ? defaultRate.amountBuffered : defaultRate.amount}';
    final String selectedKey = selected.containsKey(postId)
        ? '${selected[postId]!.provider}::${selected[postId]!.serviceLevel.token}::${selected[postId]!.amountBuffered.isNotEmpty ? selected[postId]!.amountBuffered : selected[postId]!.amount}'
        : defaultKey;

    return Column(
      children: rates.map((RateEntity rate) {
        final String label = '${rate.provider} · ${rate.serviceLevel.name}';
        final String key =
            '${rate.provider}::${rate.serviceLevel.token}::${rate.amountBuffered.isNotEmpty ? rate.amountBuffered : rate.amount}';
        return RadioListTile<String>(
          value: key,
          groupValue: selectedKey,
          onChanged: (String? k) {
            if (k == null) return;
            final RateEntity found = rates.firstWhere(
                (RateEntity rr) =>
                    '${rr.provider}::${rr.serviceLevel.token}::${rr.amountBuffered.isNotEmpty ? rr.amountBuffered : rr.amount}' ==
                    k,
                orElse: () => rate);
            onSelect(postId, found);
          },
          title: Row(
            children: <Widget>[
              if (rate.providerImage75.isNotEmpty)
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      rate.providerImage75,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (BuildContext ctx, Object err, StackTrace? st) =>
                              Container(
                        color: Theme.of(context).dividerColor,
                        child: const Icon(Icons.local_shipping, size: 16),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              Expanded(child: Text(label)),
            ],
          ),
          secondary: Text(
              rate.amountBuffered.isNotEmpty
                  ? rate.amountBuffered
                  : rate.amount,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          dense: true,
        );
      }).toList(),
    );
  }
}
