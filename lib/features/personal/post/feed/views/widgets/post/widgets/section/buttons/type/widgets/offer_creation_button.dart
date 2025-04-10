import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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
    super.key,
  });

  final MakeOfferBottomSheet widget;
  final String? selectedSize;
  final String? selectedColor;
  final TextEditingController priceController;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, Widget? child) =>
          CustomElevatedButton(
        onTap: () {
          if (widget.post.sizeColors.isNotEmpty &&
              (selectedSize == null || selectedColor == null)) {
            AppSnackBar.showSnackBar(context, 'choose_size_color'.tr());
            return;
          }
          if (priceController.text.isEmpty ||
              double.tryParse(priceController.text) == null) {
            AppSnackBar.showSnackBar(
                context, 'choose_more_than_mini_price'.tr());
            return;
          }
          pro.createOffer(
            color: selectedColor,
            size: selectedSize,
            context: context,
            postId: widget.post.postID,
            offerAmount: double.parse(priceController.text),
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
