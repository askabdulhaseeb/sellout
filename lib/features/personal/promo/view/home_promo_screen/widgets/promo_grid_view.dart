import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../domain/entities/promo_entity.dart';

class PromoHomeGridView extends StatefulWidget {
  const PromoHomeGridView({
    required this.promos,
    super.key,
  });

  final List<PromoEntity>? promos;

  @override
  State<PromoHomeGridView> createState() => _PromoGridViewState();
}

class _PromoGridViewState extends State<PromoHomeGridView> {
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
      filteredList = promoList.where((PromoEntity promo) {
        return promo.title.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('promos'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextFormField(
              labelText: '',
              controller: _controller,
              onChanged: _filterPromos,
            ),
            const SizedBox(height: 12),
            if (filteredList.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'no_promos_found'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PromoEntity promo = filteredList[index];
                    return PromoHomeGridView(
                      promos: <PromoEntity>[promo],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
