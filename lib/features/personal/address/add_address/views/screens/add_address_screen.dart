import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_radio_button_list_tile.dart';
import '../../../../../../core/widgets/custom_radio_toggle_tile.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../../../core/widgets/phone_number/views/countries_dropdown.dart';
import '../../../../../../core/widgets/phone_number/views/phone_number_input_field.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../provider/add_address_provider.dart';

class AddEditAddressScreen extends StatefulWidget {
  const AddEditAddressScreen({this.initAddress, super.key});
  final AddressEntity? initAddress;

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  @override
  Widget build(BuildContext context) {
    final AddAddressProvider provider =
        Provider.of<AddAddressProvider>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          provider.disposeControllers(),
      child: Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextFormField(
                    labelText: 'postcode'.tr(),
                    controller: provider.postalCodeController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    labelText: 'address'.tr(),
                    controller: provider.address1Controller,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    labelText: '${'town'.tr()}/${'city'.tr()}',
                    controller: provider.townCityController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'field_left_empty'.tr();
                      }
                      const String regex =
                          r'^[a-zA-Z]+/[a-zA-Z]+$'; // Strict city/town format without spaces
                      final RegExp regExp = RegExp(regex);
                      if (!regExp.hasMatch(value)) {
                        return 'please_follow_format_town'; // Adjust this message as needed
                      }
                      return null;
                    },
                  ),
                  Consumer<AddAddressProvider>(
                    builder: (BuildContext context, AddAddressProvider pros,
                            Widget? child) =>
                        CustomDropdown<String>(
                      title: 'address_category'.tr(),
                      items: <String>['home', 'work'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      selectedItem: pros.addressCategory,
                      onChanged: (String? value) {
                        if (value != null) {
                          pros.addressCategory = value;
                        }
                      },
                      validator: (_) => null,
                    ),
                  ),
                  PhoneNumberInputField(
                    initialValue: provider.phoneNumber,
                    labelText: 'phone_number'.tr(),
                    onChange: (PhoneNumberEntity? value) {
                      provider.phoneNumber = value;
                    },
                  ),
                  CountryDropdownField(
                    initialValue: provider.selectedCountry,
                    onChanged: (String value) {
                      provider.selectedCountry = value;
                    },
                  ),
                  Consumer<AddAddressProvider>(
                    builder:
                        (BuildContext context, AddAddressProvider provider, _) {
                      return CustomRadioToggleTile(
                        title: 'Make this default address',
                        selectedValue: provider.isDefault,
                        onChanged: () {
                          provider
                              .toggleDefault(); // Update the value when clicked
                        },
                      );
                    },
                  )
                ],
              ),
            )),
        bottomSheet: BottomAppBar(
            height: 100,
            elevation: 0,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: CustomElevatedButton(
              isLoading: false,
              onTap: () {
                if (formKey.currentState?.validate() ?? false) {
                  if (widget.initAddress?.addressID == null ||
                      widget.initAddress?.addressID == '') {
                    provider.saveAddress(context);
                  } else {
                    provider.action = 'update';
                    provider.updateAddress(context);
                  }
                }
              },
              title: 'save_address'.tr(),
            )),
      ),
    );
  }
}
