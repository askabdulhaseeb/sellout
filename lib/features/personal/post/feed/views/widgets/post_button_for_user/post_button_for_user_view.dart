import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../domain/entities/post/post_entity.dart';
import 'post_button_for_user_controller.dart';

/// View for user post buttons. Handles UI and delegates logic to the controller.
class PostButtonForUserView extends StatelessWidget {
  final PostEntity? post;
  final PostButtonForUserController controller;

  const PostButtonForUserView({
    required this.post,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEditable = post != null;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                textColor: Theme.of(context).colorScheme.onSurface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                bgColor: Theme.of(context).scaffoldBackgroundColor,
                isLoading: false,
                onTap: () => isEditable
                    ? controller.onEditListing(context, post!)
                    : null,
                title: 'edit_listing'.tr(),
              ),
            ),
          ],
        ),
        if (isEditable && controller.shouldShowCalendar(post))
          CustomElevatedButton(
            textColor: Theme.of(context).primaryColor,
            border: Border.all(color: Theme.of(context).primaryColor),
            bgColor: Colors.transparent,
            title: 'calender'.tr(),
            isLoading: false,
            onTap: () => controller.onOpenCalendar(context, post!),
          ),
      ],
    );
  }
}
