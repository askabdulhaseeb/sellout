import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
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

  Widget _buildDiscountField({
    required double width,
    required int index,
    required DiscountEntity discount,
    required AddListingFormProvider provider,
  }) {
    _controllers.putIfAbsent(
      index,
      () => TextEditingController(
        text: discount.discount == 0.0 ? '' : discount.discount.toString(),
      ),
    );

    return SizedBox(
      width: width / 3,
      child: CustomTextFormField(
        validator: AppValidator.isEmpty,
        labelText: ' ${discount.quantity} ${'items'.tr()}',
        controller: _controllers[index],
        onChanged: (String value) {
          int parsed = int.tryParse(value) ?? 0;
          if (parsed > 100) {
            parsed = 100;
            _controllers[index]!.text = '100';
            _controllers[index]!.selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index]!.text.length),
            );
          }
          provider.setDiscounts(
            discount.copyWith(discount: parsed),
          );
        },
        hint: '0',
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
      builder: (BuildContext context, AddListingFormProvider provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomSwitchListTile(
              title: 'select_discount'.tr(),
              value: provider.isDiscounted,
              onChanged: provider.setIsDiscount,
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: provider.isDiscounted
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.vSm),
                        child: Wrap(
                          spacing: AppSpacing.hSm,
                          runSpacing: AppSpacing.vSm,
                          children: List<Widget>.generate(
                            provider.discounts.length,
                            (int index) => _buildDiscountField(
                              width: width,
                              index: index,
                              discount: provider.discounts[index],
                              provider: provider,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
          ],
        );
      },
    );
  }
}
