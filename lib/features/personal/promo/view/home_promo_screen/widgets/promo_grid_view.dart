import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../domain/entities/promo_entity.dart';
import 'promo_gridview_tile.dart';

class PromoHomeGridView extends StatefulWidget {
  const PromoHomeGridView({
    required this.promos,
    super.key,
  });

  final List<PromoEntity>? promos;

  @override
  State<PromoHomeGridView> createState() => _PromoHomeGridViewState();
}

class _PromoHomeGridViewState extends State<PromoHomeGridView> {
  late List<PromoEntity> promoList;
  late List<PromoEntity> filteredList;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    promoList = widget.promos ?? <PromoEntity>[];
    filteredList = promoList;
  }

  void _filterPromos(String query) {
    final String lowerQuery = query.toLowerCase();
    setState(() {
      filteredList = promoList
          .where(
            (PromoEntity promo) =>
                promo.title.toLowerCase().contains(lowerQuery),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarTitle(titleKey: 'promos'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              hint: 'search_promos'.tr(),
              controller: _controller,
              onChanged: _filterPromos,
            ),
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        'no_promos_found'.tr(),
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  : SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount: 3, // 3 columns
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: List.generate(
                          filteredList.length,
                          (int index) {
                            final PromoEntity promo = filteredList[index];

                            // Make every 5th tile "big" (2x2)
                            final bool isBig = index % 5 == 0;

                            return StaggeredGridTile.count(
                              crossAxisCellCount: isBig ? 2 : 1,
                              mainAxisCellCount: isBig ? 2 : 1,
                              child: PromoHomeGridViewTile(promo: promo),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
