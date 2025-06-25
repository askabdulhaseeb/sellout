import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../features/personal/post/feed/views/widgets/post/widgets/section/bottomsheets/post_report_bottomsheet.dart';
import '../../widgets/in_dev_mode.dart';

void homePostTileShowMoreButton(
    BuildContext context, Offset position, String postId) {
  showMenu(
    color: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
    items: <PopupMenuItem<ListTile>>[
      PopupMenuItem<ListTile>(
        child: InDevMode(
          child: ListTile(
            leading: const Icon(Icons.add),
            title: Text(
              'show_more'.tr(),
              style: TextTheme.of(context).bodySmall,
            ),
            subtitle: Text(
              'show_more_subtitle'.tr(),
              style: TextTheme.of(context).bodySmall?.copyWith(fontSize: 10),
            ),
            onTap: () {
              Navigator.pop(context);
              // Handle action
            },
          ),
        ),
      ),
      PopupMenuItem<ListTile>(
        child: InDevMode(
          child: ListTile(
            leading: const Icon(Icons.remove),
            title: Text(
              'show_less'.tr(),
              style: TextTheme.of(context).bodySmall,
            ),
            subtitle: Text(
              'show_less_subtitle'.tr(),
              style: TextTheme.of(context).bodySmall?.copyWith(fontSize: 10),
            ),
            onTap: () {
              Navigator.pop(context);
              // Handle action
            },
          ),
        ),
      ),
      PopupMenuItem<ListTile>(
        child: InDevMode(
          child: ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: Text(
              'save_post'.tr(),
              style: TextTheme.of(context).bodySmall,
            ),
            subtitle: Text(
              'save_post_subtitle'.tr(),
              style: TextTheme.of(context).bodySmall?.copyWith(fontSize: 10),
            ),
            onTap: () {
              Navigator.pop(context);
              // Handle action
            },
          ),
        ),
      ),
      PopupMenuItem<ListTile>(
        child: InDevMode(
          child: ListTile(
            leading: const Icon(Icons.share),
            title: Text(
              'share'.tr(),
              style: TextTheme.of(context).bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              // Handle action
            },
          ),
        ),
      ),
      PopupMenuItem<ListTile>(
        child: InDevMode(
          child: ListTile(
            leading: const Icon(Icons.close),
            title: Text(
              'i_dont_want_to_see_this'.tr(),
              style: TextTheme.of(context).bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              // Handle action
            },
          ),
        ),
      ),
      PopupMenuItem<ListTile>(
        child: ListTile(
          leading: const Icon(Icons.report),
          title: Text(
            'report_post'.tr(),
            style: TextTheme.of(context).bodySmall,
          ),
          subtitle: Text(
            'report_post_subtitle'.tr(),
            style: TextTheme.of(context).bodySmall?.copyWith(fontSize: 10),
          ),
          onTap: () {
            Navigator.pop(context);
            showPostReportBottomSheet(context, postId);
          },
        ),
      ),
    ],
  );
}
