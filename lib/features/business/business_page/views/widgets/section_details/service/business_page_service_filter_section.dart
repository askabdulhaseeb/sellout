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
    // final BusinessPageProvider pro =
    //     Provider.of<BusinessPageProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 4,
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
            // Expanded(
            //   child: CustomTextFormField(
            //     controller: TextEditingController(),
            //     hint: 'search'.tr(),
            //     onChanged: (String value) {},
            //   ),
            // ),
            CustomElevatedButton(
              title: '+ ${'add_service'.tr()}',
              bgColor: Colors.transparent,
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
              borderRadius: BorderRadius.circular(6),
              textColor: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              isLoading: false,
              onTap: () => Navigator.of(context).pushNamed(
                AddServiceScreen.routeName,
                arguments: business,
              ),
            ),
            InDevMode(
              child: CustomElevatedButton(
                title: 'promotion_boost'.tr(),
                bgColor: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                isLoading: false,
                onTap: () {},
              ),
            ),
            // CustomElevatedButton(
            //     bgColor: Colors.transparent,
            //     borderRadius: BorderRadius.circular(12),
            //     textColor: Theme.of(context).primaryColor,
            //     border: Border.all(color: Theme.of(context).primaryColor),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            //     title: 'request_quote',
            //     isLoading: false,
            //     onTap: () {pro.createPrivateChat(context);
            //     })
          ],
        ),
      ),
    );
  }
}
