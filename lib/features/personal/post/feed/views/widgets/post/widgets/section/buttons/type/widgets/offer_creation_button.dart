import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../providers/feed_provider.dart';
import '../../../bottomsheets/create_offer_bottomsheet.dart';

class OfferCreationButton extends StatelessWidget {
  const OfferCreationButton({
    required this.widget,
    required this.selectedSize,
    required this.selectedColor,
    required this.priceController,
    required this.quantity,
    required this.formKey,
    super.key,
  });

  final MakeOfferBottomSheet widget;
  final String? selectedSize;
  final String? selectedColor;
  final TextEditingController priceController;
  final int quantity;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, Widget? child) =>
          CustomElevatedButton(
        onTap: () {
          // If the listing type is 'clothfoot', validate only the quantity
          if (widget.post.listID != ListingType.clothAndFoot.json) {
            if (priceController.text == '') {
              AppSnackBar.showSnackBar(
                  context, 'Quantity must be greater than 0');
              return; // If quantity is invalid, do nothing
            }
          } else {
            // Validate the form for other listing types
            if (!formKey.currentState!.validate()) {
              return; // If form validation fails, do nothing
            }

            // Additional validation for size and color
            if (selectedSize == null || selectedColor == null) {
              AppSnackBar.showSnackBar(
                  context, 'Please select both size and color');
              return; // If size or color is missing, show error and do nothing
            }
          }

          // Proceed if everything is valid
          pro.createOffer(
            color: selectedColor,
            size: selectedSize,
            context: context,
            postId: widget.post.postID,
            offerAmount: double.parse(priceController.text.trim()),
            currency: widget.post.currency!,
            quantity: quantity,
            listId: widget.post.listID,
          );
        },
        title: 'make_offer'.tr(),
        isLoading: pro.isLoading,
      ),
    );
  }
}
