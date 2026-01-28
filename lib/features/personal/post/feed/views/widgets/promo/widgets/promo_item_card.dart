import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../../promo/view/home_promo_screen/promo_feed_screen.dart';

class PromoItemCard extends StatelessWidget {
  const PromoItemCard({
    required this.title,
    required this.promo,
    this.promos,
    this.initialIndex,
    super.key,
  });

  final String title;
  final PromoEntity promo;
  final List<PromoEntity>? promos;
  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    final bool isImage = promo.promoType.toLowerCase() == 'image';
    final String displayUrl = isImage
        ? promo.fileUrl
        : (promo.thumbnailUrl ?? '');

    return GestureDetector(
      onTap: () {
        final List<PromoEntity>? list = promos;
        final int start = initialIndex ?? 0;
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          elevation: 0,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (_) {
            final List<PromoEntity> feed = (list != null && list.isNotEmpty)
                ? list
                : <PromoEntity>[promo];
            return PromoFeedScreen(promos: feed, initialIndex: start);
          },
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80,
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  imageURL: displayUrl,
                  fit: BoxFit.cover,
                  placeholder: promo.title,
                  size: double.infinity,
                ),
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
