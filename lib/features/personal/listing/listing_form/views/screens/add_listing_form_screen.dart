import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../providers/add_listing_form_provider.dart';
import 'form/add_cloths_and_footwear_form.dart';
import 'form/add_food_and_drink_form.dart';
import 'form/add_item_form.dart';
import 'form/add_pet_form.dart';
import 'form/add_property_form.dart';
import 'form/add_vehicle_form.dart';

class AddListingFormScreen extends StatelessWidget {
  const AddListingFormScreen({super.key});
  static const String routeName = '/add-listing-form';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<AddListingFormProvider>(context, listen: false)
                  .listingType
                  ?.code
                  .tr() ??
              'select-type'.tr(),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<AddListingFormProvider>(
          builder: (BuildContext context, AddListingFormProvider formPro, _) {
            switch (formPro.listingType) {
              case ListingType.items:
                return const AddItemForm();
              case ListingType.clothAndFoot:
                return const AddClothsAndFootwearForm();
              case ListingType.vehicle:
                return const AddVehicleForm();
              case ListingType.foodAndDrink:
                return const AddFoodAndDrinkForm();
              case ListingType.property:
                return const AddPropertyForm();
              case ListingType.pets:
                return const AddPetForm();
              default:
                return const AddItemForm();
            }
          },
        ),
      ),
    );
  }
}