import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../../../post/post_detail/views/widgets/post_detail_postage_return_section.dart';

class CheckoutPaymentMethodSection extends StatefulWidget {
  const CheckoutPaymentMethodSection({super.key});

  @override
  State<CheckoutPaymentMethodSection> createState() =>
      _CheckoutPaymentMethodSectionState();
}

class _CheckoutPaymentMethodSectionState
    extends State<CheckoutPaymentMethodSection> {
  int? selectedIndex;

  final List<Map<String, String>> paymentMethods = <Map<String, String>>[
    <String, String>{
      'image': AppStrings.stripe,
      'title': 'stripe'.tr(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: paymentMethods.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> method = paymentMethods[index];
          final bool isSelected = selectedIndex == index;

          return ListTile(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            leading: Checkbox(
              value: isSelected,
              onChanged: (_) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            title: Row(
              children: <Widget>[
                PostDetailPaymentTile(
                  image: method['image']!,
                ),
                const SizedBox(width: 12),
                Text(method['title']!),
              ],
            ),
          );
        },
      ),
    );
  }
}
