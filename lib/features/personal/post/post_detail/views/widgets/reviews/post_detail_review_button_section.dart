import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';

class PostDetailReviewButtonSection extends StatelessWidget {
  const PostDetailReviewButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return InDevMode(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'rate_this_product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          const Text('share_your_thoughs_with_other_customers').tr(),
          CustomElevatedButton(
            bgColor: Colors.transparent,
            border: Border.all(color: Theme.of(context).disabledColor),
            title: 'write_a_customer_review'.tr(),
            isLoading: false,
            onTap: () {
              // TODO: Write a review
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
