import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../domain/entities/size_color/color_entity.dart';
import '../buttons/type/widgets/offer_creation_button.dart';

class MakeOfferBottomSheet extends StatefulWidget {
  const MakeOfferBottomSheet({
    required this.post,
    this.message,
    this.selectedSize,
    this.selectedColor,
    super.key,
  });
  final PostEntity post;
  final MessageEntity? message;
  final String? selectedSize;
  final ColorEntity? selectedColor;
  @override
  State<MakeOfferBottomSheet> createState() => _MakeOfferBottomSheetState();
}

class _MakeOfferBottomSheetState extends State<MakeOfferBottomSheet> {
  TextEditingController priceController = TextEditingController();
  int quantity = 1;
  final GlobalKey<FormState> createOfferFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle(titleKey: 'make_an_offer'),
          leading: CloseButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: createOfferFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /// Starting price
                    Text(
                      '${'starting_price'.tr()}: ${CountryHelper.currencySymbolHelper(widget.post.currency)}.${widget.post.minOfferAmount} (${'per_unit'.tr()})',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),

                    /// Offer input
                    OfferPriceField(
                      onChanged: (String p0) {
                        setState(() {
                          priceController.text = p0;
                        });
                      },
                      currency: widget.post.currency ?? '',
                      controller: priceController,
                    ),
                    const SizedBox(height: 24),

                    /// Divider
                    Divider(color: Theme.of(context).dividerColor),
                    const SizedBox(height: 16),

                    /// Quantity info
                    Text(
                      'how_many_units_you_want_to_make_offer'.tr(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${'you_are_offering'.tr()} '
                      '${CountryHelper.currencySymbolHelper(widget.post.currency)}${priceController.text} '
                      '× $quantity ${'units'.tr()} = '
                      '${CountryHelper.currencySymbolHelper(widget.post.currency)}${(int.tryParse(priceController.text) ?? 0) * quantity}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),

                    /// Quantity Selector
                    QuantityCounter(
                      quantity: quantity,
                      maxQuantity: widget.selectedColor?.quantity ??
                          widget.post.quantity,
                      onChanged: (int newValue) {
                        setState(() {
                          quantity = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    /// Submit Button
                    OfferCreationButton(
                      post: widget.post,
                      formKey: createOfferFormKey,
                      widget: widget,
                      selectedSize: widget.selectedSize,
                      selectedColor: widget.selectedColor,
                      priceController: priceController,
                      quantity: quantity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OfferPriceField extends StatelessWidget {
  const OfferPriceField({
    required this.currency,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String currency;
  final TextEditingController controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String offerNote = tr('offer_note'); // Full localized string
    final List<String> parts = offerNote.split('per unit'); // Split once

    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    CountryHelper.currencySymbolHelper(currency),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              IntrinsicWidth(
                child: TextField(
                  autofocus: true,
                  onChanged: onChanged,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hint: Text(
                      '0',
                      style: TextTheme.of(context).headlineSmall?.copyWith(
                            color: ColorScheme.of(context).outlineVariant,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                children: <InlineSpan>[
                  TextSpan(text: parts.first),
                  TextSpan(
                    text: 'per unit',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  if (parts.length > 1) TextSpan(text: parts.last),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    super.key,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(4);
    final BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      borderRadius: borderRadius,
    );

    return IntrinsicWidth(
      child: Row(
        children: <Widget>[
          InkWell(
            borderRadius: borderRadius,
            onTap: () {
              if (quantity > 1) {
                onChanged(quantity - 1);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: decoration,
              child: const Icon(Icons.remove),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Center(
              child: Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: borderRadius,
            onTap: () {
              if (quantity < maxQuantity) {
                onChanged(quantity + 1);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: decoration,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
