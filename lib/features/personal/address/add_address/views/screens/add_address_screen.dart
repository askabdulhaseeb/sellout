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
      create: (_) => AddAddressProvider(
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    final AddAddressProvider provider = context.read<AddAddressProvider>();

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
            key: _formKey,
            child: Column(
              spacing: AppSpacing.vSm,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextFormField(
                  labelText: 'recipient_name'.tr(),
                  controller: provider.recipientNameController,
                  validator: AppValidator.isEmpty,
                ),
                Consumer<AddAddressProvider>(
                  builder: (_, AddAddressProvider pro, __) =>
                      CountryDropdownField(
                    initialValue: pro.selectedCountryEntity,
                    onChanged: (CountryEntity value) {
                      pro.setCountryEntity(value);
                    },
                    validator: AppValidator.requireSelection,
                  ),
                ),
                Consumer<AddAddressProvider>(
                  builder: (_, AddAddressProvider pro, __) =>
                      CustomDropdown<StateEntity>(
                    title: 'state'.tr(),
                    items:
                        (pro.selectedCountryEntity?.states ?? <StateEntity>[])
                            .map((StateEntity state) =>
                                DropdownMenuItem<StateEntity>(
                                  value: state,
                                  child: Text(state.stateName),
                                ))
                            .toList(),
                    selectedItem: pro.state,
                    onChanged: (StateEntity? value) {
                      if (value != null) pro.setStateEntity(value);
                    },
                    validator: AppValidator.requireSelection,
                  ),
                ),
                Consumer<AddAddressProvider>(
                  builder: (_, AddAddressProvider pro, __) =>
                      CustomDropdown<String>(
                    title: 'city'.tr(),
                    items: (pro.state?.cities ?? <String>[])
                        .map((String city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ))
                        .toList(),
                    selectedItem: pro.city,
                    onChanged: (String? value) {
                      if (value != null) pro.setCity(value);
                    },
                    validator: AppValidator.requireSelection,
                  ),
                ),
                CustomTextFormField(
                  labelText: 'address_1'.tr(),
                  controller: provider.address1Controller,
                  validator: AppValidator.isEmpty,
                ),
                CustomTextFormField(
                  labelText: 'address_2'.tr(),
                  controller: provider.address2Controller,
                ),

                CustomTextFormField(
                  labelText: 'postal_code'.tr(),
                  controller: provider.postalCodeController,
                  validator: AppValidator.isEmpty,
                ),

                // 🟢 Consumer for Address Category Dropdown
                Consumer<AddAddressProvider>(
                  builder: (_, AddAddressProvider pro, __) =>
                      CustomDropdown<String>(
                    title: 'address_category'.tr(),
                    items: <String>['home', 'work']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr()),
                            ))
                        .toList(),
                    selectedItem: pro.addressCategory,
                    onChanged: (String? value) {
                      if (value != null) pro.setaddressCategory(value);
                    },
                    validator: AppValidator.requireSelection,
                  ),
                ),

                // 🟢 Consumer for Phone Number
                Consumer<AddAddressProvider>(
                  builder: (_, AddAddressProvider pro, __) =>
                      PhoneNumberInputField(
                    initialCountry: pro.selectedCountryEntity,
                    initialValue: pro.phoneNumber,
                    labelText: 'phone_number'.tr(),
                    onChange: (PhoneNumberEntity? value) {
                      pro.setPhoneNumber(value);
                    },
                  ),
                ),

                Consumer<AddAddressProvider>(
                  builder: (_, AddAddressProvider pro, __) =>
                      CustomRadioToggleTile(
                    title: 'Make this default address',
                    selectedValue: pro.isDefault,
                    onChanged: pro.toggleDefault,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AddAddressProvider>(
            builder: (_, AddAddressProvider pro, __) => CustomElevatedButton(
              isLoading: false,
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
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
