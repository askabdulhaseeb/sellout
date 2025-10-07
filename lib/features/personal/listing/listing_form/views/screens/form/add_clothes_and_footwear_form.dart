import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/cloth/add_listing_brand_field.dart';
import '../../widgets/cloth/add_listing_cloth_subcat_selection_section.dart';
import '../../widgets/cloth/size_color_widget.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/delivery_Section.dart/add_listing_delivery_selection_widget.dart';
import '../../widgets/core/add_listing_discount_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/add_listing_price_and_quantity_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';

class AddClothsAndFootwearForm extends StatefulWidget {
  const AddClothsAndFootwearForm({super.key});

  @override
  State<AddClothsAndFootwearForm> createState() =>
      _AddClothsAndFootwearFormState();
}

class _AddClothsAndFootwearFormState extends State<AddClothsAndFootwearForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        if (formPro.isDropdownLoading) {
          return const Center(
            child: Loader(),
          );
        }
        return Form(
          key: formPro.clothesAndFootKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const AddListingBasicInfoSection(),
                const AddListingClothSubcatSelectionSection(),
                SubCategorySelectableWidget<AddListingFormProvider>(
                  listType: formPro.listingType,
                  subCategory: formPro.selectedCategory,
                  onSelected: formPro.setSelectedCategory,
                  cid: formPro.selectedClothSubCategory,
                ),
                const AddListingSizeColorWidget(),
                const AddListingBrandField(),
                const AddListingPriceAndQuantityWidget(readOnly: true),
                const AddListingDiscountSection(),
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
