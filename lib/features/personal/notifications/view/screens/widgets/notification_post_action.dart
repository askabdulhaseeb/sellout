import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/utils/app_snackbar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../post/post_detail/views/screens/post_detail_screen.dart';

class NotificationPostAction {
  const NotificationPostAction._();

  static Future<void> navigate({
    required BuildContext context,
    required String? postId,
  }) async {
    if (postId == null || postId.isEmpty) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'post_not_found'.tr());
      }
      return;
    }

    if (context.mounted) {
      AppNavigator.pushNamed(
        PostDetailScreen.routeName,
        arguments: <String, String>{'pid': postId},
      );
    }
  }

  static String getButtonText() => 'view'.tr();
}
