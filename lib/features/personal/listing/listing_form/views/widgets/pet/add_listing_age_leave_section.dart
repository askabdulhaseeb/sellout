import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/enums/listing/pet/age_time_type.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingPetAgeLeaveWidget extends StatelessWidget {
  const AddListingPetAgeLeaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AgeTimeType> age = AgeTimeType.age;
    final List<AgeTimeType> time = AgeTimeType.time;
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Row(
          children: <Widget>[
            Expanded(
              child: CustomDropdown<AgeTimeType>(
                selectedItem: formPro.age,
                items: age.map((AgeTimeType value) {
                  return DropdownMenuItem<AgeTimeType>(
                    value: value,
                    child: Text(value.title),
                  );
                }).toList(),
                onChanged: formPro.setAge,
                validator: (_) =>
                    formPro.age == null ? 'Age is required' : null,
                title: 'Age',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomDropdown<AgeTimeType>(
                selectedItem: formPro.time,
                items: time.map((AgeTimeType value) {
                  return DropdownMenuItem<AgeTimeType>(
                    value: value,
                    child: Text(value.title),
                  );
                }).toList(),
                onChanged: formPro.setTime,
                validator: (_) =>
                    formPro.time == null ? 'Time is required' : null,
                title: 'Ready to Leave',
              ),
            ),
          ],
        );
      },
    );
  }
}
