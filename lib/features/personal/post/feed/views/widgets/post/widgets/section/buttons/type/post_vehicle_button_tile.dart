import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../domain/entities/post_entity.dart';
import 'widgets/post_make_offer_button.dart';

class PostVehicleButtonTile extends StatelessWidget {
  const PostVehicleButtonTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: PostMakeOfferButton(post: post)),
        const SizedBox(width: 12),
        Expanded(
          child: CustomElevatedButton(
            title: 'book-visit'.tr(),
            bgColor: Colors.transparent,
            border: Border.all(color: Theme.of(context).primaryColor),
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            isLoading: false,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
