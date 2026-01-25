import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../../../features/postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../constants/app_spacings.dart';

/// Widget displaying a single shipping rate option as a selectable tile
class SingleRateTile extends StatelessWidget {
  const SingleRateTile({
    required this.rate,
    required this.isSelected,
    required this.cartItemId,
    super.key,
  });

  final RateEntity rate;
  final bool isSelected;
  final String cartItemId;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          final CartProvider cartPro = Provider.of<CartProvider>(
            context,
            listen: false,
          );
          cartPro.updateShippingSelection(cartItemId, rate.objectId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: <Widget>[
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (_) {
                  final CartProvider cartPro = Provider.of<CartProvider>(
                    context,
                    listen: false,
                  );
                  cartPro.updateShippingSelection(cartItemId, rate.objectId);
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      rate.serviceLevel.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rate.durationTerms,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<String>(
                future: rate.getPriceStr(),
                builder: (_, AsyncSnapshot<String> snapshot) => Text(
                  snapshot.data ?? '...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
