import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../post/domain/entities/discount_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingDiscountSection extends StatelessWidget {
  const AddListingDiscountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width - 32 - 28;

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider addPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.all(0),
              title: const Text(
                'select_discount',
                style: TextStyle(fontWeight: FontWeight.w500),
              ).tr(),
              value: addPro.isDiscounted,
              onChanged: (bool value) => addPro.setIsDiscount(value),
            ),
            if (addPro.isDiscounted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: addPro.discounts
                    .map(
                      (DiscountEntity e) => SizedBox(
                        width: width / 3,
                        child: CustomTextFormField(
                          labelText: ' ${e.quantity} ${'items'.tr()}',
                          controller: TextEditingController(
                            text: e.discount.toString(),
                          ),
                          onChanged: (String p0) => addPro.setDiscounts(
                            e.copyWith(discount: double.tryParse(p0) ?? 0.0),
                          ),
                          hint: 'Ex.${e.quantity * 5}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          suffixIcon: const Opacity(
                            opacity: 0.7,
                            child: Icon(Icons.percent),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        );
      },
    );
  }
}
