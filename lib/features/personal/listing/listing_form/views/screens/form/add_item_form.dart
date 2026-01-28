import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/widgets/utils/in_dev_mode.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/delivery_section/add_listing_delivery_selection_widget.dart';
import '../../widgets/core/add_listing_discount_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/add_listing_price_and_quantity_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        debugPrint(formPro.selectedCategory?.title);
        return Form(
          key: formPro.itemKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: AppSpacing.vMd,
              children: <Widget>[
                const AddListingBasicInfoSection(),
                SubCategorySelectableWidget<AddListingFormProvider>(
                  listType: formPro.listingType,
                  subCategory: formPro.selectedCategory,
                  onSelected: formPro.setSelectedCategory,
                ),
                const AddListingPriceAndQuantityWidget(),
                InDevMode(child: const AddListingDiscountSection()),
                const AddListingConditionOfferSection(),
                const AddListingDeliverySelectionWidget(),
                if (formPro.post == null) const AddListingPostButtonWidget(),
                if (formPro.post != null) const AddListingUpdateButtons(),
              ],
            ),
          ),
        );
      },
    );
  }
}
