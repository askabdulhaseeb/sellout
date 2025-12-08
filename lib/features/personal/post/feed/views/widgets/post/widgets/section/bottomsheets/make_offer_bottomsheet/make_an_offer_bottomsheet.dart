import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../buttons/type/widgets/counter_widget.dart';
import 'widgets/make_counter_offer_button.dart';
import '../../../../../../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../buttons/type/widgets/offer_creation_button.dart';
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle(
            titleKey: isCounterOffer ? 'counter_offer' : 'make_an_offer',
          ),
          leading: CloseButton(onPressed: () => Navigator.pop(context)),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: createOfferFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        /// Starting price
                        FutureBuilder<String>(
                          future: isCounterOffer
                              ? widget.message?.offerDetail?.getOfferPriceStr()
                              : widget.post.getOfferPriceStr(
                                  offerPrice: widget.post.minOfferAmount,
                                  quantity: 1,
                                ),
                          builder:
                              (
                                BuildContext context,
                                AsyncSnapshot<String> snapshot,
                              ) {
                                final String label = isCounterOffer
                                    ? 'offer_price'.tr()
                                    : 'starting_price'.tr();
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    '$label: ...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  );
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Text(
                                    '$label: na',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  );
                                }
                                return Text(
                                  isCounterOffer
                                      ? '$label: ${snapshot.data}'
                                      : '$label: ${snapshot.data} (${'per_unit'.tr()})',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                );
                              },
                        ),

                        /// Offer input
                        OfferPriceField(
                          onChanged: (String p0) {
                            setState(() {
                              priceController.text = p0;
                            });
                          },
                          currency: LocalAuth.currency,
                          controller: priceController,
                        ),

                        Divider(color: Theme.of(context).dividerColor),

                        /// Quantity Selector
                        Column(
                          children: <Widget>[
                            Text(
                              '${'you_are_offering'.tr()} '
                              '${CountryHelper.currencySymbolHelper(LocalAuth.currency)}${priceController.text} '
                              '× $quantity ${'units'.tr()} = '
                              '${CountryHelper.currencySymbolHelper(LocalAuth.currency)}${(int.tryParse(priceController.text) ?? 0) * quantity}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            PostCounterWidget(
                              initialQuantity: quantity,
                              maxQuantity:
                                  widget.selectedColor?.quantity ??
                                  widget.post.quantity,
                              onChanged: (int value) => setState(() {
                                quantity = value;
                              }),
                            ),
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
                                message: widget.message!,
                                counterOfferAmount:
                                    int.tryParse(priceController.text) ?? 0,
                                counterQuantity: quantity,
                              ),
                          ],
                        ),

                        /// Submit Button
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
