import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../promo/view/create_promo/screens/create_promo_screen.dart';

class AddPromoCard extends StatelessWidget {
  const AddPromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CreatePromoScreen.routeName);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 90,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  top: 0,
                  bottom: 25,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 45,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    'promo'.tr(),
                    style: TextTheme.of(context).bodyMedium?.copyWith(
                          color: ColorScheme.of(context).onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor,
                      border:
                          Border.all(color: ColorScheme.of(context).onPrimary),
                    ),
                    child: Icon(Icons.add,
                        size: 20, color: ColorScheme.of(context).onPrimary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              'create_yours'.tr(),
              style: TextTheme.of(context).bodySmall,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
