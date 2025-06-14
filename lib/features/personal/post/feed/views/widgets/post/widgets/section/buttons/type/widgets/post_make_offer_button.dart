import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
import '../../../bottomsheets/make_an_offer_bottomsheet.dart';

class PostMakeOfferButton extends StatelessWidget {
  const PostMakeOfferButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    void showOfferBottomSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return MakeOfferBottomSheet(post: post);
        },
      );
    }

    return CustomElevatedButton(
        bgColor: Theme.of(context).primaryColor,
        onTap: () => showOfferBottomSheet(context),
        title: 'make_an_offer'.tr(),
        isLoading: false);
  }
}
