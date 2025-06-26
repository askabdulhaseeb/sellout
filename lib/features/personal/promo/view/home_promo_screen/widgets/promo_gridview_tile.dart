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
          builder: (_) {
            return PromoScreen(promo: promo);
          },
        );
      },
      child: Container(
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
    );
  }
}
