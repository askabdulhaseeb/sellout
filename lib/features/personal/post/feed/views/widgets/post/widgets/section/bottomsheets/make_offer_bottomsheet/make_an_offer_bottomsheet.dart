import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import 'widgets/make_counter_offer_button.dart';
import '../../../../../../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../buttons/type/widgets/offer_creation_button.dart';
import 'widgets/make_offer_quantity_counter.dart';
import 'widgets/offer_price_field.dart';

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
    final bool isCounterOffer = widget.message != null;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle(
              titleKey: isCounterOffer ? 'counter_offer' : 'make_an_offer'),
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
                      isCounterOffer
                          ? '${'offer_price'.tr()}: ${CountryHelper.currencySymbolHelper(widget.message?.offerDetail?.currency)}.${widget.message?.offerDetail?.offerPrice ?? 0}'
                          : '${'starting_price'.tr()}: ${CountryHelper.currencySymbolHelper(widget.post.currency)}.${widget.post.minOfferAmount} (${'per_unit'.tr()})',
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
                    if (!isCounterOffer)
                      OfferCreationButton(
                        post: widget.post,
                        formKey: createOfferFormKey,
                        widget: widget,
                        selectedSize: widget.selectedSize,
                        selectedColor: widget.selectedColor,
                        priceController: priceController,
                        quantity: quantity,
                      ),
                    if (isCounterOffer)
                      MakeCOunterOfferButton(
                          currency: widget.message?.offerDetail?.currency ?? '',
                          message: widget.message!,
                          counterOfferAmount:
                              int.tryParse(priceController.text) ?? 0,
                          counterQuantity: quantity)
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
