import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_Switch_list_tile.dart';
import '../../../../../post/domain/entities/discount_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingDiscountSection extends StatefulWidget {
  const AddListingDiscountSection({super.key});

  @override
  State<AddListingDiscountSection> createState() =>
      _AddListingDiscountSectionState();
}

class _AddListingDiscountSectionState extends State<AddListingDiscountSection> {
  final Map<int, TextEditingController> _controllers =
      <int, TextEditingController>{};

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildDiscountField({
    required double width,
    required int index,
    required DiscountEntity discount,
    required AddListingFormProvider addPro,
  }) {
    // Initialize controller if not exists
    _controllers.putIfAbsent(
      index,
      () => TextEditingController(text: discount.discount.toString()),
    );

// Inside buildDiscountField:
    return SizedBox(
      width: width / 3,
      child: CustomTextFormField(
        labelText: ' ${discount.quantity} ${'items'.tr()}',
        controller: _controllers[index],
        onChanged: (String value) {
          double parsed = double.tryParse(value) ?? 0.0;
          if (parsed > 100) {
            parsed = 100;
            _controllers[index]!.text = '100';
            _controllers[index]!.selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index]!.text.length),
            );
          }
          addPro.setDiscounts(
            discount.copyWith(discount: parsed),
          );
        },
        hint: 'Ex.${discount.quantity * 5}',
        keyboardType: TextInputType.number,
        textAlign: TextAlign.end,
        suffixIcon: const Opacity(
          opacity: 0.7,
          child: Icon(Icons.percent),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width - 32 - 28;
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider addPro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomSwitchListTile(
              title: 'select_discount'.tr(),
              value: addPro.isDiscounted,
              onChanged: (bool value) => addPro.setIsDiscount(value),
            ),
            if (addPro.isDiscounted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List<Widget>.generate(
                  addPro.discounts.length,
                  (int index) => buildDiscountField(
                    width: width,
                    index: index,
                    discount: addPro.discounts[index],
                    addPro: addPro,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
