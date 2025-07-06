import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/location_input_button.dart';
import '../../providers/services_page_provider.dart';

class ServicesPageExploreSearchingSection extends StatelessWidget {
  const ServicesPageExploreSearchingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              controller: pro.search,
              prefixIcon: const Icon(Icons.search),
              hint: 'search'.tr(),
              onChanged: (String value) {
                pro.searchServices(value.trim());
              },
            ),
            LocationInputButton(
              validator: (_) => null,
            ),
          ],
        );
      },
    );
  }
}
