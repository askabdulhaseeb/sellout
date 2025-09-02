import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('promos'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              labelText: 'search'.tr(),
              controller: _controller,
              onChanged: _filterPromos,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        'no_promos_found'.tr(),
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final PromoEntity promo = filteredList[index];
                        return PromoHomeGridViewTile(promo: promo);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
