import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../buttons/type/widgets/offer_creation_button.dart';

class MakeOfferBottomSheet extends StatefulWidget {
  const MakeOfferBottomSheet({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  State<MakeOfferBottomSheet> createState() => _MakeOfferBottomSheetState();
}

class _MakeOfferBottomSheetState extends State<MakeOfferBottomSheet> {
  TextEditingController priceController = TextEditingController();
  int quantity = 1;
  String? selectedSize;
  String? selectedColor;
  final GlobalKey<FormState> createOfferFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8);
    final BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: borderRadius,
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            backgroundBlendMode: BlendMode.color,
          ),
          padding: const EdgeInsets.only(bottom: 20),
          child: Form(
            key: createOfferFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                ListTile(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  title: Text(
                    'make_an_offer'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Text(
                        '${'starting_price:'.tr()} ${widget.post.price}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'minimum_offer_price'.tr(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.post.currency}. ${widget.post.minOfferAmount}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 20),
                      if (widget.post.listID == ListingType.clothAndFoot.json)
                        Column(
                          children: <Widget>[
                            CustomDropdown<String>(
                              title: 'size'.tr(),
                              items: widget.post.sizeColors
                                  .map((SizeColorEntity size) {
                                return DropdownMenuItem<String>(
                                  value: size.value,
                                  child: Text(size.value),
                                );
                              }).toList(),
                              selectedItem: selectedSize,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSize = value;
                                });
                              },
                              validator: (bool? value) {
                                // Perform a check to validate whether a size has been selected.
                                if (selectedSize == null ||
                                    selectedSize!.isEmpty) {
                                  return 'Please select a size'; // Return error message if not selected
                                }
                                return null; // Return null if it's valid
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomDropdown<String>(
                              validator: (bool? value) => null,
                              title: 'Select Color',
                              items: (selectedSize != null)
                                  ? widget.post.sizeColors
                                      .firstWhere((SizeColorEntity size) =>
                                          size.value == selectedSize)
                                      .colors
                                      .map((ColorEntity color) =>
                                          DropdownMenuItem<String>(
                                            value: color.code,
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                        '0xFF${color.code.substring(1)}')),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(color.code),
                                              ],
                                            ),
                                          ))
                                      .toList()
                                  : <DropdownMenuItem<String>>[],
                              selectedItem: selectedColor,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedColor = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: decoration,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    borderRadius: borderRadius,
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: decoration,
                                      child: const Icon(Icons.remove),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: borderRadius,
                                    onTap: () {
                                      if (quantity < widget.post.quantity) {
                                        setState(() {
                                          quantity++;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: decoration,
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              autoFocus: true,
                              keyboardType: TextInputType.number,
                              prefixText: widget.post.currency,
                              controller: priceController,
                              hint: 'enter_offer_amount'.tr(),
                              validator: (String? value) =>
                                  AppValidator.greaterThen(priceController.text,
                                      widget.post.minOfferAmount),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OfferCreationButton(
                        formKey: createOfferFormKey,
                        widget: widget,
                        selectedSize: selectedSize,
                        selectedColor: selectedColor,
                        priceController: priceController,
                        quantity: quantity,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
