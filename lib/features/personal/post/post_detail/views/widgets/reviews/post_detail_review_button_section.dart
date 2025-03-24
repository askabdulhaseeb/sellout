import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../review/features/reivew_list/views/screens/write_review_screen.dart';
import '../../../../domain/entities/post_entity.dart';

class PostDetailReviewButtonSection extends StatelessWidget {
  const PostDetailReviewButtonSection({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return Column(
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
            Navigator.pushNamed(
              context,
              WriteReviewScreen.routeName,
              arguments: <String, PostEntity>{'post': post},
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
