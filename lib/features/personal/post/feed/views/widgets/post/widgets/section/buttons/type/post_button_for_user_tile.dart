import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../../../../../routes/app_linking.dart';
import '../../../../../../../../../visits/view/visit_calender.dart/screens/visit_calender_screen.dart';
import '../../../../../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../../../../../../listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../../../../../../../../domain/entities/post/post_entity.dart';

class PostButtonsForUser extends StatelessWidget {
  const PostButtonsForUser({
    required this.post,
    super.key,
  });

  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(spacing: 8, children: <Widget>[
          Expanded(
              child: InDevMode(
            child: CustomElevatedButton(
                isLoading: false,
                bgColor: Theme.of(context).colorScheme.secondary,
                onTap: () {},
                title: 'promote'.tr()),
          )),
          Expanded(
            child: CustomElevatedButton(
                textColor: Theme.of(context).colorScheme.onSurface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                bgColor: Theme.of(context).scaffoldBackgroundColor,
                isLoading: false,
                onTap: () {
                  final AddListingFormProvider pro =
                      Provider.of<AddListingFormProvider>(context,
                          listen: false);
                  pro.reset();
                  pro.setListingType(post?.type);
                  pro.setPost(post);
                  // pro.updateVariables();
                  AppNavigator.pushNamed(AddListingFormScreen.routeName);
                },
                title: 'edit_listing'.tr()),
          ),
        ]),
        if (ListingType.viewingList
            .contains(ListingType.fromJson(post?.listID)))
          CustomElevatedButton(
              textColor: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              bgColor: Colors.transparent,
              title: 'calender'.tr(),
              isLoading: false,
              onTap: () {
                Navigator.pushNamed(context, VisitCalenderScreen.routeName,
                    arguments: <String, String>{'pid': post?.postID ?? ''});
              })
      ],
    );
  }
}
