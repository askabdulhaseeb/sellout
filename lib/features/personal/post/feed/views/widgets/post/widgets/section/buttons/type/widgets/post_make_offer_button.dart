import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../../../../../../../providers/feed_provider.dart';

class PostMakeOfferButton extends StatelessWidget {
  const PostMakeOfferButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    void showOfferBottomSheet(BuildContext context, String startingPrice) {
      TextEditingController priceController = TextEditingController();
      int quantity = 1;
      String? selectedSize;
      String? selectedColor;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          final BorderRadius borderRadius = BorderRadius.circular(8);
          final BoxDecoration decoration = BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: borderRadius,
          );
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                  title: Text(
                    'make_an_offer'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Text(
                        '${'starting_price:'.tr()} $startingPrice',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'minimum_offer_price'.tr(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${post.currency}. ${post.minOfferAmount}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Expanded(
                        child: CustomDropdown<String>(
                          validator: (bool? value) => null,
                          title: 'Select Color',
                          items: (selectedSize != null)
                              ? post.sizeColors
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
                                                    '0xFF${color.code.substring(1)}')), // Remove "#" from color code
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
                      ),
                      Expanded(
                        child: CustomDropdown<String>(
                          title: 'size'.tr(),
                          items: post.sizeColors
                              .map((SizeColorEntity size) =>
                                  DropdownMenuItem<String>(
                                    value: size.value,
                                    child: Text(size.value),
                                  ))
                              .toList(),
                          selectedItem: selectedSize,
                          onChanged: (String? value) {
                            setState(() {
                              selectedSize = value;
                              selectedColor = null;
                            });
                          },
                          validator: (bool? value) =>
                              value == null ? 'Please select a size' : null,
                        ),
                      ),
                      Row(
                        spacing: 8,
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
                                      if (quantity == 1) return;
                                      setState(() {
                                        quantity--;
                                      });
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
                                      if (quantity == post.quantity) return;
                                      setState(() {
                                        quantity++;
                                      });
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
                          const SizedBox(height: 10),
                          Expanded(
                            child: CustomTextFormField(
                              prefixText: post.currency,
                              controller: priceController,
                              hint: 'enter_offer_amount'.tr(),
                              validator: (String? value) =>
                                  AppValidator.greaterThen(priceController.text,
                                      post.minOfferAmount),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        onTap: () {
                          if (post.sizeColors.isNotEmpty &&
                              (selectedSize == null || selectedColor == null)) {
                            AppSnackBar.showSnackBar(context,
                                'Please choose size and color to make an offer');
                            return;
                          }
                          if (priceController.text.isEmpty ||
                              double.tryParse(priceController.text) == null) {
                            AppSnackBar.showSnackBar(context,
                                'Price should be more than minimum offered price');
                            return;
                          }
                          Provider.of<FeedProvider>(context, listen: false)
                              .createOffer(
                            color: selectedColor,
                            size: selectedSize,
                            context: context,
                            postId: post.postID,
                            offerAmount: double.parse(priceController.text),
                            currency: post.currency!,
                            quantity: quantity,
                            listId: post.listID,
                          );
                        },
                        title: 'Enter',
                        isLoading: false,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return CustomElevatedButton(
        bgColor: post.acceptOffers == true
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.outlineVariant,
        onTap: () => post.acceptOffers == true
            ? showOfferBottomSheet(context, post.price.toString())
            : null,
        title: 'make_an_offer'.tr(),
        isLoading: false);
  }
}
