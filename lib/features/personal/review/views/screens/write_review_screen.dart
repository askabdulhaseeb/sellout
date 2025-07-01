import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../providers/review_provider.dart';
import '../widgets/rating_select_widget.dart';
import '../widgets/select_review_media_section.dart';
import '../widgets/write_review_header.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key});

  static const String routeName = '/write-review';
  @override
  Widget build(BuildContext context) {
    final ReviewProvider provider =
        Provider.of<ReviewProvider>(context, listen: false);
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final PostEntity? post = args['post'];
    final ServiceEntity? service = args['service'];
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          provider.disposed(),
      child: Scaffold(
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
                service: service,
              ),
              Text('rate_product'.tr()),
              const RatingSelectWidget(
                size: 40,
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
                    if (post != null) {
                      provider.setPost(post);
                      provider.submitProductReview(context);
                    } else if (service != null) {
                      provider.setService(service);
                      provider.submitServiceReview(context);
                    }
                  },
                  title: 'submit'.tr(),
                  isLoading: provider.isloading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
