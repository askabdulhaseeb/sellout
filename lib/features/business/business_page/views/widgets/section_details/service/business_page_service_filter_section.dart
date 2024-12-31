import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../core/domain/entity/business_entity.dart';

class BusinessPageServiceFilterSection extends StatelessWidget {
  const BusinessPageServiceFilterSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 200,
            child: CustomDropdown<ListingType?>(
              title: 'category'.tr(),
              items: ListingType.list.map((ListingType type) {
                return DropdownMenuItem<ListingType>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              selectedItem: null,
              onChanged: (_) {},
              validator: (_) {
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
