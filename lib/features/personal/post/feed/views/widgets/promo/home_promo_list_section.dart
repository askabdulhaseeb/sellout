import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/view/provider/promo_provider.dart';
import 'widgets/add_promo_card.dart';
import 'widgets/promo_item_card.dart';

class HomePromoListSection extends StatefulWidget {
  const HomePromoListSection({super.key});

  @override
  State<HomePromoListSection> createState() => _HomePromoListSectionState();
}

class _HomePromoListSectionState extends State<HomePromoListSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PromoProvider>(context, listen: false).getPromoOfFollower();
    });
  }
@override
Widget build(BuildContext context) {
  final List<PromoEntity>? pro = Provider.of<PromoProvider>(context).promoList;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Header
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'promo'.tr(),
              style: TextTheme.of(context).titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InDevMode(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'view_more'.tr(),
                  style: TextTheme.of(context).bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.primaryColor,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),

      SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: (pro == null || pro.isEmpty) ? 1 : pro.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const AddPromoCard();
            } else {
              final PromoEntity promo = pro![index - 1];
              return PromoItemCard(title: promo.title, file: promo.fileUrl);
            }
          },
        ),
      ),

      if (pro != null && pro.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              'no_promos_found'.tr(),
              style: TextTheme.of(context).bodySmall,
            ),
          ),
        ),
    ],
  );
}
}