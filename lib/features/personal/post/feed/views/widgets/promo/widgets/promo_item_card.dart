import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../../promo/view/home_promo_screen/promo_screen.dart';

class PromoItemCard extends StatelessWidget {
  const PromoItemCard({
    required this.title,
    required this.promo,
    super.key,
  });

  final String title;
  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (BuildContext context) => PromoScreen(promo: promo),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 80,
        child: Column(
          children: <Widget>[
            Container(
              width: 80,
              height: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: <Widget>[
                    CustomNetworkImage(
                        imageURL: promo.thumbnailUrl ?? 'na',
                        fit: BoxFit.cover,
                        placeholder: promo.title),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              maxLines: 1,
              title,
              style: TextTheme.of(context).bodySmall,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
