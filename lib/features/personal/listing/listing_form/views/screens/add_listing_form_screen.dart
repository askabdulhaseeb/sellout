import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../providers/add_listing_form_provider.dart';
import 'form/add_clothes_and_footwear_form.dart';
import 'form/add_food_and_drink_form.dart';
import 'form/add_item_form.dart';
import 'form/add_pet_form.dart';
import 'form/add_property_form.dart';
import 'form/add_vehicle_form.dart';

class AddListingFormScreen extends StatefulWidget {
  const AddListingFormScreen({super.key});
  static const String routeName = '/add-listing-form';

  @override
  State<AddListingFormScreen> createState() => _AddListingFormScreenState();
}

class _AddListingFormScreenState extends State<AddListingFormScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<AddListingFormProvider>(context, listen: false).reset();
        });
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
              color: Theme.of(context).primaryColor,
            ),
            title: const AppBarTitle(
              titleKey: 'start_listing',
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    Provider.of<AddListingFormProvider>(context, listen: false)
                            .listingType
                            ?.code
                            .tr() ??
                        'select_type'.tr(),
                    style: TextTheme.of(context).bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Theme.of(context).dividerColor,
                  )
                ],
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Selector<AddListingFormProvider, ListingType?>(
            selector: (_, AddListingFormProvider pro) => pro.listingType,
            builder: (BuildContext context, ListingType? listingType, _) {
              switch (listingType) {
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
      ),
    );
  }
}
