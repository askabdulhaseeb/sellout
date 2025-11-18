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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: <Widget>[
            /// Background image
            Positioned.fill(
              child: CustomNetworkImage(
                imageURL: imageUrl,
                fit: BoxFit.cover,
                placeholder: promo.title,
              ),
            ),

            /// Gradient overlay (for text readability)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// Title + price at the bottom
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black38,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (promo.price != null)
                    Text(
                      '${promo.price}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
