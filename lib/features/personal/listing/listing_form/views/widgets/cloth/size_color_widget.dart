import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../providers/add_listing_form_provider.dart';
import 'color_size_bottomsheet.dart';

class AddListingSizeColorWidget extends StatelessWidget {
  const AddListingSizeColorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider pro =
        Provider.of<AddListingFormProvider>(context);
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            pro.fetchColors();
            showBottomSheet(
                context: context,
                builder: (BuildContext context) =>
                    const SizeColorBottomSheet());
          },
          child: AbsorbPointer(
            child: CustomDropdown<int>(
              hint: 'tap_to_select'.tr(),
              title: 'select_size_color'.tr(),
              items: const <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(value: 2, child: Text('2')),
              ],
              selectedItem: null,
              onChanged: (int? p0) {},
              validator: (bool? value) {
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
