import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../listing/listing_form/views/widgets/category/subcateogry_selectable_widget.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterClothFootCategoryAndLocationWIdget extends StatefulWidget {
  const MarketFilterClothFootCategoryAndLocationWIdget({super.key});

  @override
  State<MarketFilterClothFootCategoryAndLocationWIdget> createState() =>
      _MarketFilterClothFootCategoryAndLocationWIdgetState();
}

class _MarketFilterClothFootCategoryAndLocationWIdgetState
    extends State<MarketFilterClothFootCategoryAndLocationWIdget> {
  List<String> dropdownItems = <String>[];
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SubCategorySelectableWidget<MarketPlaceProvider>(
                  listenProvider:
                      Provider.of<MarketPlaceProvider>(context, listen: false),
                  title: false,
                  listType: marketPro.marketplaceCategory,
                  subCategory: marketPro.selectedSubCategory,
                  onSelected: marketPro.setSelectedCategory,
                  cid: marketPro.cLothFootCategory ?? '',
                ),
              ),
              const SizedBox(width: 4),
              const BrandDropdown()
            ],
          ),
        );
      },
    );
  }
}

class BrandDropdown extends StatefulWidget {
  const BrandDropdown({super.key});

  @override
  State<BrandDropdown> createState() => _BrandDropdownState();
}

class _BrandDropdownState extends State<BrandDropdown> {
  String? selectedItem;
  List<DropdownMenuItem<String>> dropdownItems = <DropdownMenuItem<String>>[];

  String? lastCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MarketPlaceProvider provider =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    final String category = provider.cLothFootCategory ?? 'clothes';
    lastCategory = category;
    loadBrands(category); // Initial load
  }

  Future<void> loadBrands(String type) async {
    final String fileName =
        type == 'footwear' ? 'foot_brands.json' : 'clothes_brands.json';
    final String response =
        await rootBundle.loadString('assets/jsons/$fileName');
    final Map<String, dynamic> jsonData = json.decode(response);
    final List<dynamic> data = jsonData['${type}_brands'];

    setState(() {
      dropdownItems = data.map((dynamic brand) {
        final Map<String, dynamic> brandMap = brand as Map<String, dynamic>;
        final String label = brandMap['label'] ?? '';
        return DropdownMenuItem<String>(
          value: label,
          child: Text(label),
        );
      }).toList();

      // Reset selected item when new items are loaded
      selectedItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<MarketPlaceProvider>(
        builder: (BuildContext context, MarketPlaceProvider provider, _) {
          final String currentCategory =
              provider.cLothFootCategory ?? 'clothes';

          // If category changed, reload the brands
          if (currentCategory != lastCategory) {
            lastCategory = currentCategory;
            loadBrands(currentCategory);
          }

          return CustomDropdown<String>(
            hint: 'Brands',
            title: '',
            selectedItem: provider.brand,
            items: dropdownItems,
            onChanged: (String? p0) => provider.setBrand(p0),
            validator: (bool? val) => null,
          );
        },
      ),
    );
  }
}
