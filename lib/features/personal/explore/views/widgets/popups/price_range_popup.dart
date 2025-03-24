import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../services/get_it.dart';
import '../../providers/explore_provider.dart';
import '../price_range_widget.dart';

class PriceRangePopup extends StatefulWidget {
  const PriceRangePopup({super.key});

  @override
  PriceRangePopupState createState() => PriceRangePopupState();
}

class PriceRangePopupState extends State<PriceRangePopup> {
  ExploreProvider pro = ExploreProvider(locator(),locator());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const PriceRangeWidget(),
      actions: <Widget>[
        CustomElevatedButton(
          isLoading: false,
          onTap: () {
            Navigator.pop(context);
          },
          title: 'Apply',
        ),
      ],
    );
  }
}
