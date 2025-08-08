import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../domain/entities/promo_entity.dart';
import '../promo_screen.dart';

class PromoHomeGridViewTile extends StatelessWidget {
  const PromoHomeGridViewTile({
    required this.promo,
    super.key,
  });

  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    final bool isImage = promo.promoType.toLowerCase() == 'image';
    final String imageUrl = isImage ? promo.fileUrl : promo.thumbnailUrl ?? '';

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          elevation: 0,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (_) => PromoScreen(promo: promo),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 120, // Add fixed/min height
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).dividerColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomNetworkImage(
                imageURL: imageUrl,
                fit: BoxFit.cover,
                placeholder: promo.title,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    promo.title,
                    style: TextTheme.of(context).bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${'na'.tr()} ${promo.price.toString()}',
                  style: TextTheme.of(context)
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
