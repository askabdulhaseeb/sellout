import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../provider/promo_provider.dart';
import 'choose_post_bottomsheet.dart';

class ChoosePostForPromoDropDown extends StatelessWidget {
  const ChoosePostForPromoDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoProvider pro = Provider.of<PromoProvider>(context);

    return GestureDetector(
     onTap: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) => const ChoosePostBottomSheet(
      ),
    );
  },   child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Select a post'.tr(),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: const OutlineInputBorder(),
          ),
          validator: (String? value) {
            if (pro.referenceId.isEmpty) {
              return 'Please select a post';
            }
            return null;
          },
          readOnly: true,
        ),
      ),
    );
  }
}
