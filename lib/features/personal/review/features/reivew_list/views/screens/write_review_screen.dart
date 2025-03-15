import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../providers/review_provider.dart';
import '../widgets/rating_select_widget.dart';
import '../widgets/select_review_media_Section.dart';
import '../widgets/write_review_header.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key});

  static const String routeName = '/write-review';
  @override
  Widget build(BuildContext context) {
    final ReviewProvider provider = Provider.of<ReviewProvider>(context);
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final PostEntity post = args['post'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('leave_review'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WriteReviewHeaderSection(
              post: post,
            ),
            Text('rate_product'.tr()),
            RatingSelectWidget(
              size: 40,
              maxRating: 5,
              initialRating: 0,
              onRatingChanged: (double value) {
                value = value;
              },
            ),
            CustomTextFormField(
              controller: provider.reviewTitle,
              labelText: 'headline'.tr(),
            ),
            CustomTextFormField(
              controller: provider.reviewdescription,
              labelText: 'write_review'.tr(),
              maxLines: 5,
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            const SelectReviewMediaSection(),
            Center(
              child: CustomElevatedButton(
                onTap: () {
                  provider.updatePostidentity(post.postID);
                  provider.submitReview();
                },
                title: 'submit'.tr(),
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
