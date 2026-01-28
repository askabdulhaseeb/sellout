import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../../../listing/listing_form/data/sources/local/local_categories.dart';
import '../../../../../../../listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../../../../../listing/listing_form/views/widgets/custom_listing_dropdown.dart';
import '../../../../../providers/marketplace_provider.dart';
// import your DropdownOptionEntity wherever you defined it

class MarketFilterVehicleCategoryAndModalWidget extends StatelessWidget {
  const MarketFilterVehicleCategoryAndModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionEntity> vehiclecategory =
        LocalCategoriesSource.vehicles ?? <DropdownOptionEntity>[];
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Row(
          children: <Widget>[
            Expanded(
              child:
                  CustomListingDropDown<
                    MarketPlaceProvider,
                    DropdownOptionEntity
                  >(
                    // supply the options list from provider or wherever you keep them
                    options:
                        vehiclecategory, // e.g. a List<DropdownOptionEntity>
                    valueGetter: (DropdownOptionEntity opt) => opt.value.value,
                    labelGetter: (DropdownOptionEntity opt) => opt.label,
                    validator: (bool? p0) => null,
                    hint: 'category'.tr(),
                    selectedValue: marketPro.vehicleCatgory,
                    onChanged: (String? p0) => marketPro.setVehicleCategory(p0),
                  ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: CustomTextFormField(
                controller: marketPro.vehicleModel,
                hint: 'model'.tr(),
              ),
            ),
          ],
        );
      },
    );
  }
}
