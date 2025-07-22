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
  void initState() {
    super.initState();
    loadFootBrands();
  }

  Future<void> loadFootBrands() async {
    final String response =
        await rootBundle.loadString('assets/jsons/foot_brands.json');
    final List<dynamic> data = json.decode(response);
    final List<Map<String, dynamic>> brands =
        List<Map<String, dynamic>>.from(data);

    setState(() {
      dropdownItems = brands
          .map((Map<String, dynamic> brand) => brand['label'].toString())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
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
            const SizedBox(width: 10),
            FootBrandDropdown()
          ],
        );
      },
    );
  }
}

class FootBrandDropdown extends StatefulWidget {
  const FootBrandDropdown({super.key});

  @override
  State<FootBrandDropdown> createState() => _FootBrandDropdownState();
}

class _FootBrandDropdownState extends State<FootBrandDropdown> {
  String? selectedItem;
  List<DropdownMenuItem<String>> dropdownItems = <DropdownMenuItem<String>>[];

  @override
  void initState() {
    super.initState();
    loadFootBrands();
  }

  Future<void> loadFootBrands() async {
    final String response =
        await rootBundle.loadString('assets/jsons/foot_brands.json');
    final List<dynamic> data = json.decode(response);
    final List<Map<String, dynamic>> brands =
        List<Map<String, dynamic>>.from(data);

    setState(() {
      dropdownItems = brands.map((Map<String, dynamic> brand) {
        final String label = brand['label'] ?? '';
        return DropdownMenuItem<String>(
          value: label,
          child: Text(label),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomDropdown<String>(
          title: '',
          selectedItem: selectedItem,
          items: dropdownItems,
          onChanged: (String? value) {
            setState(() {
              selectedItem = value;
            });
          },
          validator: (bool? val) => null),
    );
  }
}
