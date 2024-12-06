import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../data/sources/remote/get_access_code_api.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingConditionOfferSection extends StatelessWidget {
  const AddListingConditionOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomToggleSwitch<ConditionType>(
              labels: ConditionType.list,
              labelStrs: ConditionType.list
                  .map<String>((ConditionType e) => e.code.tr())
                  .toList(),
              labelText: 'condition'.tr(),
              initialValue: formPro.condition,
              onToggle: formPro.setCondition,
            ),
            CustomToggleSwitch<bool>(
              labels: const <bool>[true, false],
              labelStrs: <String>['yes'.tr(), 'no'.tr()],
              labelText: 'accept-offers'.tr(),
              initialValue: formPro.acceptOffer,
              onToggle: formPro.setAcceptOffer,
            ),
            if (formPro.acceptOffer)
              CustomTextFormField(
                controller: formPro.minimumOffer,
                labelText: 'minimum-offerd-amount'.tr(),
                showSuffixIcon: false,
                // prefixText: LocalState.getCurrency().toUpperCase(),
                prefixText: '₹',
                hint: '8.0',
                keyboardType: TextInputType.number,
                validator: (String? value) => AppValidator.isEmpty(value),
              ),
            CustomToggleSwitch<PrivacyType>(
              labels: PrivacyType.list,
              labelStrs: PrivacyType.list
                  .map<String>((PrivacyType e) => e.code.tr())
                  .toList(),
              labelText: 'privacy-type'.tr(),
              initialValue: formPro.privacy,
              onToggle: formPro.setPrivacy,
            ),
            if (formPro.privacy == PrivacyType.private)
              FutureBuilder<String?>(
                future: GetAccessCodeApi().getCode(oldCode: formPro.accessCode),
                initialData: formPro.accessCode,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<String?> snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data != null) {
                    formPro.setAccessCode(snapshot.data!);
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${'access-code'.tr()}: ${snapshot.data ?? '...'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
