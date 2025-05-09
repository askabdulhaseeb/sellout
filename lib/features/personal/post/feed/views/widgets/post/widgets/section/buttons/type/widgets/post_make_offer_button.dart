import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
import '../../../bottomsheets/create_offer_bottomsheet.dart';

class PostMakeOfferButton extends StatelessWidget {
  const PostMakeOfferButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    void showOfferBottomSheet(BuildContext context) {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return MakeOfferBottomSheet(post: post);
        },
      );
    }

    return CustomElevatedButton(
        bgColor: post.acceptOffers == true
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor,
        onTap: () =>
            post.acceptOffers == true ? showOfferBottomSheet(context) : null,
        title: 'make_an_offer'.tr(),
        isLoading: false);
  }
}
