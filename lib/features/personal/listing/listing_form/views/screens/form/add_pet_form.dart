import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/editable_availablity_widget.dart';
import '../../providers/add_listing_form_provider.dart';
import '../../widgets/category/subcateogry_selectable_widget.dart';
import '../../widgets/core/add_listing_update_button_widget.dart';
import '../../widgets/pet/add_listing_age_leave_section.dart';
import '../../widgets/core/add_listing_basic_info_section.dart';
import '../../widgets/core/add_listing_condition_offer_section.dart';
import '../../widgets/core/add_listing_post_button_widget.dart';
import '../../widgets/add_listing_price_and_quantity_widget.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadDropdowns());
  }

  Future<void> _loadDropdowns() async {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    await formPro.fetchDropdownListings('/category/pets?list-id=');
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    if (formPro.isDropdownLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro,
          Widget? child) {
        return Form(
          key: formPro.petKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: <Widget>[
              const AddListingBasicInfoSection(),
              const AddListingPetAgeLeaveWidget(),
              SubCategorySelectableWidget(
                listType: formPro.listingType,
                subCategory: formPro.selectedCategory,
                onSelected: formPro.setSelectedCategory,
              ),
              const AddListingPriceAndQuantityWidget(),
              const AddListingConditionOfferSection(),
              const EditableAvailabilityWidget(),
              if (formPro.post == null) const AddListingPostButtonWidget(),
              if (formPro.post != null) const AddListingUpdateButtons(),
            ],
          ),
        );
      },
    );
  }
}
