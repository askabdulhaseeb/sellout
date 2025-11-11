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
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../domain/usecase/add_address_usecase.dart';
import '../../domain/usecase/update_address_usecase.dart';
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
    return ChangeNotifierProvider<AddAddressProvider>(
      create: (context) => AddAddressProvider(
        locator<AddAddressUsecase>(),
        locator<UpdateAddressUsecase>(),
      ),
      child: AddEditAddressView(initAddress: widget.initAddress),
    );
  }
}

class AddEditAddressView extends StatefulWidget {
  const AddEditAddressView({this.initAddress, super.key});
  final AddressEntity? initAddress;

  @override
  State<AddEditAddressView> createState() => _AddEditAddressViewState();
}

class _AddEditAddressViewState extends State<AddEditAddressView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AddAddressProvider pro = context.read<AddAddressProvider>();
      if (widget.initAddress != null) {
        pro.updateVariable(widget.initAddress!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Consumer<AddAddressProvider>(
      builder: (BuildContext context, AddAddressProvider pro, Widget? child) =>
          PopScope(
        onPopInvokedWithResult: (bool didPop, dynamic result) =>
            pro.disposeControllers(),
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
                      controller: pro.recipientNameController,
                      validator: (String? value) => AppValidator.isEmpty(value),
                    ),
                    const SizedBox(height: AppSpacing.vSm),
                    CountryDropdownField(
                      initialValue: pro.selectedCountryEntity,
                      onChanged: (CountryEntity value) {
                        pro.setCountryEntity(value);
                      },
                      validator: (bool? value) =>
                          AppValidator.requireSelection(value),
                    ),
                    const SizedBox(height: AppSpacing.vSm),
                    Consumer<AddAddressProvider>(
                      builder: (BuildContext context, AddAddressProvider pros,
                          Widget? child) {
                        final List<StateEntity> states =
                            pros.selectedCountryEntity?.states ??
                                <StateEntity>[];
                        final List<DropdownMenuItem<StateEntity>> items = states
                            .map((StateEntity s) =>
                                DropdownMenuItem<StateEntity>(
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
                              pros.setStateEntity(value);
                            }
                          },
                          validator: (bool? value) =>
                              AppValidator.requireSelection(value),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.vSm),
                    Consumer<AddAddressProvider>(
                      builder: (BuildContext context, AddAddressProvider pros,
                          Widget? child) {
                        final List<StateEntity> states =
                            pros.selectedCountryEntity?.states ??
                                <StateEntity>[];

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
                    CustomTextFormField(
                      labelText: 'address_1'.tr(),
                      controller: pro.address1Controller,
                      validator: (String? value) => AppValidator.isEmpty(value),
                    ),
                    const SizedBox(height: AppSpacing.vSm),
                    CustomTextFormField(
                        labelText: 'address_2'.tr(),
                        controller: pro.address2Controller,
                        validator: null),
                    const SizedBox(height: AppSpacing.vSm),
                    CustomTextFormField(
                      labelText: 'postal_code'.tr(),
                      controller: pro.postalCodeController,
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
                      initialValue: pro.phoneNumber,
                      labelText: 'phone_number'.tr(),
                      onChange: (PhoneNumberEntity? value) {
                        pro.phoneNumber = value;
                      },
                    ),

                    const SizedBox(height: AppSpacing.vSm),

                    Consumer<AddAddressProvider>(
                      builder: (BuildContext context,
                          AddAddressProvider provider, _) {
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
                    pro.saveAddress(context);
                  } else {
                    pro.action = 'update';
                    pro.updateAddress(context);
                  }
                }
              },
              title: widget.initAddress?.addressID == null
                  ? 'save_address'.tr()
                  : 'update_address'.tr(),
            ),
          ),
        ),
      ),
    );
  }
}
