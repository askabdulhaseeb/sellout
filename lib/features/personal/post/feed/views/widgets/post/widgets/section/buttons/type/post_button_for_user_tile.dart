import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../../../book_visit/view/screens/view_booking_screen.dart';
import '../../../../../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../../../../../../listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../../domain/entities/visit/visiting_entity.dart';

class PostButtonsForUser extends StatelessWidget {
  const PostButtonsForUser({
    required this.post,
    this.visit,
    super.key,
  });

  final VisitingEntity? visit;
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
                bgColor: Colors.white,
                isLoading: false,
                onTap: () {
                  final AddListingFormProvider pro =
                      Provider.of<AddListingFormProvider>(context,
                          listen: false);
                  pro.reset();
                  pro.setListingType(post?.type);
                  pro.setPost(post);
                  pro.updateVariables();
                  Navigator.pushNamed(context, AddListingFormScreen.routeName);
                },
                title: 'edit_listing'.tr()),
          ),
        ]),
        if (visit?.visitingTime != null)
          CustomElevatedButton(
              textColor: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              bgColor: Theme.of(context).colorScheme.surface,
              title: 'calender'.tr(),
              isLoading: false,
              onTap: () {
                Navigator.pushNamed(context, BookingScreen.routeName,
                    arguments: <String, dynamic>{
                      'post': post,
                      'visit': visit,
                    });
              })
      ],
    );
  }
}
