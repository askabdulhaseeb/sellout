import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/view/home_promo_screen/promo_screen.dart';

class PromoGridViewTile extends StatelessWidget {
  const PromoGridViewTile({
    required this.promo,
    super.key,
  });

  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<PromoScreen>(
            builder: (_) => PromoScreen(promo: promo),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  fit: BoxFit.fill,
                  imageURL: promo.fileUrl,
                ),
              ),
            ),
          ),
          InDevMode(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(200),
                    ),
                    child: Text(
                      'promote'.tr(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    onPressed: () {
                      // TODO: Handle promote action
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor.withAlpha(200),
                    ),
                    child: Text(
                      'edit'.tr(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    onPressed: () {
                      // TODO: Handle edit action
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
