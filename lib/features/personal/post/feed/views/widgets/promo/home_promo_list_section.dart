import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/loaders/promo_tile_loader.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/view/create_promo/provider/promo_provider.dart';
import '../../../../../promo/view/home_promo_screen/widgets/promo_grid_view.dart';
import 'widgets/create_promo_card.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 200), () {
        // ignore: use_build_context_synchronously
        Provider.of<PromoProvider>(context, listen: false).getPromoOfFollower();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PromoProvider promoProvider = Provider.of<PromoProvider>(context);
    final List<PromoEntity>? pro = promoProvider.promoList;
    final bool isLoading = promoProvider.isLoadig;
    final bool showMore = (pro?.length ?? 0) <= 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (!showMore && !isLoading)
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<PromoHomeGridView>(
                        builder: (BuildContext context) => PromoHomeGridView(
                          promos: pro,
                        ),
                      )),
                  child: Text(
                    'view_more'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 130,
          child: isLoading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 4, // Number of shimmer placeholders
                  itemBuilder: (BuildContext context, int index) {
                    return const PromoTileLoader();
                  },
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: (pro == null || pro.isEmpty) ? 1 : pro.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return const AddPromoCard();
                    } else {
                      final PromoEntity promo = pro![index - 1];
                      return PromoItemCard(title: promo.title, promo: promo);
                    }
                  },
                ),
        ),
      ],
    );
  }
}
