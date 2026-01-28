import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/utilities/app_validators.dart';
import '../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../providers/add_listing_form_provider.dart';

class AddListingPriceAndQuantityWidget extends StatelessWidget {
  const AddListingPriceAndQuantityWidget({this.readOnly = false, super.key});
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        final bool isLoading = readOnly || formPro.isLoading;
        return Row(
          spacing: AppSpacing.vSm,
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                controller: formPro.price,
                labelText: 'price'.tr(),
                // hint: 'Ex. 12000.0',
                showSuffixIcon: false,
                prefixIcon: SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      CountryHelper.currencySymbolHelper(
                        LocalAuth.currency.toUpperCase(),
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) => AppValidator.isEmpty(value),
              ),
            ),
            Expanded(
              child: CustomTextFormField(
                controller: formPro.quantity,
                labelText: 'quantity'.tr(),
                showSuffixIcon: false,
                hint: '12.0',
                readOnly: isLoading,
                textAlign: TextAlign.center,
                prefixIcon: IconButton(
                  onPressed: formPro.decrementQuantity,
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: formPro.quantity.text == '1'
                        ? Theme.of(context).shadowColor
                        : null,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: formPro.incrementQuantity,
                  icon: Icon(
                    Icons.add_circle_outline_outlined,
                    color: isLoading ? null : Theme.of(context).primaryColor,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        );
      },
    );
  }
}
