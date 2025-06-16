import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../domain/entities/promo_entity.dart';
import '../promo_screen.dart';

class PromoGridViewTile extends StatelessWidget {
  const PromoGridViewTile({
    super.key,
    required this.promo,
    required this.height,
  });

  final PromoEntity promo;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
          enableDrag: false,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) {
            return PromoScreen(
              promo: promo,
            );
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
            imageURL: promo.thumbnailUrl!,
            fit: BoxFit.cover,
            placeholder: promo.title,
          ),
        ),
      ),
    );
  }
}
