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
    required String label,
    required num value,
    required Function(num) onChanged,
    required int index,
  }) {
    _controllers.putIfAbsent(
      index,
      () => TextEditingController(
        text: value == 0 ? '' : value.toString(),
      ),
    );

    return SizedBox(
      width: width / 3,
      child: CustomTextFormField(
        validator: AppValidator.isEmpty,
        labelText: label,
        controller: _controllers[index],
        onChanged: (String val) {
          num parsed = num.tryParse(val) ?? 0;
          if (parsed > 100) {
            parsed = 100;
            _controllers[index]!.text = '100';
            _controllers[index]!.selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index]!.text.length),
            );
          }
          onChanged(parsed);
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
        final DiscountEntity discount = provider.discounts ??
            DiscountEntity(twoItems: 0, threeItems: 0, fiveItems: 0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomSwitchListTile(
              title: 'select_discount'.tr(),
              value: provider.isDiscounted,
              onChanged: (bool value) => provider.setIsDiscount(value),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: provider.isDiscounted
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.vSm),
                      child: Wrap(
                        spacing: AppSpacing.hSm,
                        runSpacing: AppSpacing.vSm,
                        children: <Widget>[
                          _buildDiscountField(
                            width: width,
                            label: '2 ${'items'.tr()}',
                            value: discount.twoItems,
                            index: 0,
                            onChanged: (num val) {
                              provider.setDiscounts(
                                discount.copyWith(twoItems: val),
                              );
                            },
                          ),
                          _buildDiscountField(
                            width: width,
                            label: '3 ${'items'.tr()}',
                            value: discount.threeItems,
                            index: 1,
                            onChanged: (num val) {
                              provider.setDiscounts(
                                discount.copyWith(threeItems: val),
                              );
                            },
                          ),
                          _buildDiscountField(
                            width: width,
                            label: '5 ${'items'.tr()}',
                            value: discount.fiveItems,
                            index: 2,
                            onChanged: (num val) {
                              provider.setDiscounts(
                                discount.copyWith(fiveItems: val),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
