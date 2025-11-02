import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/dialogs/post/post_tile_cloth_foot_dialog.dart';
import '../../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import '../../../bottomsheets/make_offer_bottomsheet/make_an_offer_bottomsheet.dart';

class PostMakeOfferButton extends StatefulWidget {
  const PostMakeOfferButton(
      {required this.post,
      required this.detailWidget,
      this.detailWidgetColor,
      this.detailWidgetSize,
      super.key});
  final PostEntity post;
  final bool detailWidget;
  final SizeColorEntity? detailWidgetSize;
  final ColorEntity? detailWidgetColor;

  @override
  State<PostMakeOfferButton> createState() => _PostMakeOfferButtonState();
}

class _PostMakeOfferButtonState extends State<PostMakeOfferButton> {
  SizeColorEntity? get selectedSize => widget.detailWidgetSize;
  ColorEntity? get selectedColor => widget.detailWidgetColor;

  void _openMakeOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (_) => MakeOfferBottomSheet(
        post: widget.post,
        selectedSize: selectedSize?.value,
        selectedColor: selectedColor,
      ),
    );
  }

  Future<void> _openSelectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PostTileClothFootDialog(
        post: widget.post,
        actionType: PostTileClothFootType.offer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      bgColor: Theme.of(context).primaryColor,
      onTap: () {
        if (widget.post.type == ListingType.clothAndFoot &&
            ListingType.fromJson(widget.post.listID) ==
                ListingType.clothAndFoot &&
            widget.detailWidget == false) {
          _openSelectionDialog(context);
        }
        if (ListingType.fromJson(widget.post.listID) !=
            ListingType.clothAndFoot) {
          _openMakeOfferBottomSheet(context);
        } else if (selectedColor != null &&
            selectedSize != null &&
            widget.detailWidget == true) {
          _openMakeOfferBottomSheet(context);
        } else if (widget.detailWidget == true &&
            selectedSize != null &&
            selectedColor == null) {
          AppSnackBar.showSnackBar(context, 'color_is_required'.tr());
        } else if (widget.detailWidget == true && selectedSize == null) {
          AppSnackBar.showSnackBar(context, 'size_is_required'.tr());
        } else {}
      },
      title: 'make_an_offer'.tr(),
      isLoading: false,
    );
  }
}
