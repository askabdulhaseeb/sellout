import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_validators.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_radio_toggle_tile.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../../../core/widgets/phone_number/views/countries_dropdown.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../../../../../../core/widgets/phone_number/views/phone_number_input_field.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle(titleKey: 'address'.tr()),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextFormField(
                    labelText: 'recipient_name'.tr(),
                    controller: provider.recipientNameController,
                    validator: (String? value) => AppValidator.isEmpty(value),
                  ),
                  const SizedBox(height: AppSpacing.vSm),
                  CountryDropdownField(
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    initialValue: provider.selectedCountryEntity,
                    onChanged: (CountryEntity value) {
                      provider.selectedCountryEntity = value;
                    },
                  ),
                  const SizedBox(height: AppSpacing.vSm),
                  Consumer<AddAddressProvider>(
                    builder: (BuildContext context, AddAddressProvider pros,
                        Widget? child) {
                      final List<StateEntity> states =
                          pros.selectedCountryEntity?.states ?? <StateEntity>[];

                      final List<DropdownMenuItem<StateEntity>> items = states
                          .map((StateEntity s) => DropdownMenuItem<StateEntity>(
                              value: s, child: Text(s.stateName)))
                          .toList();

                      for (final StateEntity s in states) {
                        if (s.stateName == pros.state?.stateName) {
                          break;
                        }
                      }

                      return CustomDropdown<StateEntity>(
                        title: 'state'.tr(),
                        items: items,
                        selectedItem: pros.state,
                        onChanged: (StateEntity? value) {
                          if (value != null) {
                            pros.setState(value);
                          }
                        },
                        validator: (bool? value) =>
                            AppValidator.requireSelection(value),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.vSm),

                  // City selector: dropdown populated from selected state's cities
                  Consumer<AddAddressProvider>(
                    builder: (BuildContext context, AddAddressProvider pros,
                        Widget? child) {
                      final List<StateEntity> states =
                          pros.selectedCountryEntity?.states ?? <StateEntity>[];

                      StateEntity? selectedState;
                      for (final StateEntity s in states) {
                        if (s.stateName == pros.state?.stateName) {
                          selectedState = s;
                          break;
                        }
                      }

                      final List<String> cities =
                          selectedState?.cities ?? <String>[];

                      final List<DropdownMenuItem<String>> items = cities
                          .map((String city) => DropdownMenuItem<String>(
                              value: city, child: Text(city)))
                          .toList();

                      // selectedCity is intentionally not stored locally; use provider
                      // value directly (pros.city) for the dropdown's selectedItem.

                      return CustomDropdown<String>(
                        title: 'city'.tr(),
                        items: items,
                        selectedItem: pros.city,
                        onChanged: (String? value) {
                          if (value != null) pros.setCity(value);
                        },
                        validator: (bool? value) =>
                            AppValidator.requireSelection(value),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.vSm),
                  // State selector: show a dropdown of states for the selected country
                  CustomTextFormField(
                    labelText: 'address_1'.tr(),
                    controller: provider.address1Controller,
                    validator: (String? value) => AppValidator.isEmpty(value),
                  ),
                  const SizedBox(height: AppSpacing.vSm),
                  CustomTextFormField(
                      labelText: 'address_2'.tr(),
                      controller: provider.address2Controller,
                      validator: null),
                  const SizedBox(height: AppSpacing.vSm),
                  CustomTextFormField(
                    labelText: 'postal_code'.tr(),
                    controller: provider.postalCodeController,
                    validator: (String? value) => AppValidator.isEmpty(value),
                  ),
                  const SizedBox(height: AppSpacing.vSm),
                  // CustomTextFormField(
                  //   labelText: '${'town'.tr()}/${'city'.tr()}',
                  //   controller: provider.townCity,
                  //   validator: (String? value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'field_left_empty'.tr();
                  //     }
                  //     const String regex =
                  //         r'^[a-zA-Z]+/[a-zA-Z]+$'; // Strict city/town format without spaces
                  //     final RegExp regExp = RegExp(regex);
                  //     if (!regExp.hasMatch(value)) {
                  //       return 'please_follow_format_town'; // Adjust this message as needed
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                          pros.setaddressCategory(value);
                        }
                      },
                      validator: (bool? value) =>
                          AppValidator.requireSelection(value),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.vSm),
                  PhoneNumberInputField(
                    initialValue: provider.phoneNumber,
                    labelText: 'phone_number'.tr(),
                    onChange: (PhoneNumberEntity? value) {
                      provider.phoneNumber = value;
                    },
                  ),

                  const SizedBox(height: AppSpacing.vSm),

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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
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
            title: widget.initAddress?.addressID == null
                ? 'save_address'.tr()
                : 'update_address'.tr(),
          ),
        ),
      ),
    );
  }
}
