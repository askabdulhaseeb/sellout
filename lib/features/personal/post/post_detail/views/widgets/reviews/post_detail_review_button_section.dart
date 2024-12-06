import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_elevated_button.dart';

class PostDetailReviewButtonSection extends StatelessWidget {
  const PostDetailReviewButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'rate-this-product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Text('share-your-thoughs-with-other-customers').tr(),
        CustomElevatedButton(
          bgColor: Colors.transparent,
          border: Border.all(color: Theme.of(context).disabledColor),
          title: 'write-a-customer-review'.tr(),
          isLoading: false,
          onTap: () {
            // TODO: Write a review
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}