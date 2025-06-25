import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/view/create_promo/provider/promo_provider.dart';
import '../../../../../promo/view/home_promo_screen/widgets/promo_grid_view.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PromoProvider>(context, listen: false).getPromoOfFollower();
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
              const Spacer(),
              if (!showMore && !isLoading)
                TextButton(
                  onPressed: () => showBottomSheet(
                    context: context,
                    builder: (BuildContext context) => PromoHomeGridView(
                      promos: pro,
                    ),
                  ),
                  child: Text(
                    'view_more'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.primaryColor,
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
                    return const _PromoShimmerPlaceholder();
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

class _PromoShimmerPlaceholder extends StatefulWidget {
  const _PromoShimmerPlaceholder();

  @override
  State<_PromoShimmerPlaceholder> createState() =>
      _PromoShimmerPlaceholderState();
}

class _PromoShimmerPlaceholderState extends State<_PromoShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacityAnim = Tween<double>(begin: 0.3, end: 0.6).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
