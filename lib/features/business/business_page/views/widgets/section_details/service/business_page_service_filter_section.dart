import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../core/domain/entity/business_entity.dart';
import '../../../../../service/views/screens/add_service_screen.dart';

class BusinessPageServiceFilterSection extends StatelessWidget {
  const BusinessPageServiceFilterSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            // SizedBox(
            //   width: 200,
            //   child: CustomDropdown<ListingType?>(
            //     title: 'category'.tr(),
            //     items: ListingType.list.map((ListingType type) {
            //       return DropdownMenuItem<ListingType>(
            //         value: type,
            //         child: Text(type.name),
            //       );
            //     }).toList(),
            //     selectedItem: null,
            //     onChanged: (_) {},
            //     validator: (_) {
            //       return null;
            //     },
            //   ),
            // ),
            CustomElevatedButton(
              title: '+ ${'add-service'.tr()}',
              bgColor: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              textColor: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              isLoading: false,
              onTap: () => Navigator.of(context).pushNamed(
                AddServiceScreen.routeName,
                arguments: business,
              ),
            ),
            const SizedBox(width: 8),
            InDevMode(
              child: CustomElevatedButton(
                title: 'promotion-boost'.tr(),
                bgColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                textColor: Theme.of(context).colorScheme.secondary,
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                isLoading: false,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
