import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/add_listing_price_and_quantity_widget.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_discount_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/core/delivery_section/add_listing_delivery_selection_widget.dart';
import '../../widgets/food_drink/food_drink_sub_selection_widget.dart';

class AddFoodAndDrinkForm extends StatefulWidget {
  const AddFoodAndDrinkForm({super.key});

  @override
  State<AddFoodAndDrinkForm> createState() => _AddFoodAndDrinkFormState();
}

class _AddFoodAndDrinkFormState extends State<AddFoodAndDrinkForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Form(
          key: formPro.foodAndDrinkKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: AppSpacing.vSm,
              children: <Widget>[
                const AddListingBasicInfoSection(),
                const AddListingFoodDrinkSubcatSelectionSection(),
                SubCategorySelectableWidget<AddListingFormProvider>(
                  cid: formPro.selectedFoodDrinkSubCategory,
                  listType: formPro.listingType,
                  subCategory: formPro.selectedCategory,
                  onSelected: formPro.setSelectedCategory,
                ),
                const AddListingPriceAndQuantityWidget(),
                const AddListingConditionOfferSection(),
                InDevMode(child: const AddListingDiscountSection()),
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
