import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/widgets/inputs/custom_dropdown.dart';
import '../../../enums/added_filter_options.dart';
import '../../../providers/marketplace_provider.dart';

class AddedFilterDropdown extends StatelessWidget {
  const AddedFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, _) {
        return CustomDropdown<AddedFilterOption>(
          title: '',
          hint: 'added_to_site'.tr(),
          items: AddedFilterOption.values.map((AddedFilterOption option) {
            return DropdownMenuItem<AddedFilterOption>(
              value: option,
              child: Text(
                option.localizationKey.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
          selectedItem: marketPro.addedFilterOption,
          onChanged: (AddedFilterOption? selectedOption) {
            marketPro.setAddedFilterOption(selectedOption);
          },
          validator: (_) => null,
        );
      },
    );
  }
}
