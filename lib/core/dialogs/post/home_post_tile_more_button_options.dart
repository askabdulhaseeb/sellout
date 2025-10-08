import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../features/personal/post/domain/usecase/save_post_usecase.dart';
import '../../../features/personal/post/feed/views/widgets/post/widgets/section/bottomsheets/post_report_bottomsheet.dart';
import '../../../features/personal/post/feed/views/widgets/post/widgets/section/icon_butoons/share_post_icon_button.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../services/get_it.dart';
import '../../sources/data_state.dart';
import '../../utilities/app_string.dart';
import '../../widgets/app_snakebar.dart';
import '../../widgets/custom_svg_icon.dart';

void homePostTileShowMoreButton(
  BuildContext context,
  Offset position,
  String postId,
) {
  final bool isSaved = LocalAuth.currentUser?.saved.contains(postId) ?? false;

  showMenu(
    color: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
    items: <PopupMenuItem<ListTile>>[
      // PopupMenuItem<ListTile>(
      //   child: InDevMode(
      //     child: ListTile(
      //       leading: const Icon(Icons.add),
      //       title: Text(
      //         'show_more'.tr(),
      //         style: Theme.of(context).textTheme.bodySmall,
      //       ),
      //       subtitle: Text(
      //         'show_more_subtitle'.tr(),
      //         style:
      //             Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      //       ),
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ),
      // ),
      // PopupMenuItem<ListTile>(
      //   child: InDevMode(
      //     child: ListTile(
      //       leading: const Icon(Icons.remove),
      //       title: Text(
      //         'show_less'.tr(),
      //         style: Theme.of(context).textTheme.bodySmall,
      //       ),
      //       subtitle: Text(
      //         'show_less_subtitle'.tr(),
      //         style:
      //             Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      //       ),
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ),
      // ),
      PopupMenuItem<ListTile>(
        child: ListTile(
          leading: Icon(
            isSaved ? Icons.bookmark_added : Icons.bookmark_border,
            color: isSaved ? Theme.of(context).primaryColor : null,
          ),
          title: Text(
            isSaved ? 'unsave_post'.tr() : 'save_post'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () async {
            Navigator.pop(context);
            if (isSaved) {
              LocalAuth.currentUser?.saved.remove(postId);
              final UserEntity? user =
                  LocalUser().userEntity(LocalAuth.uid ?? '');
              user?.saved.remove(postId);
              LocalUser().save(user!);
              AppSnackBar.showSnackBar(context, 'post_unsaved_success'.tr());
            } else {
              final SavePostUsecase savePostUsecase =
                  SavePostUsecase(locator());
              final DataState<bool> result = await savePostUsecase.call(postId);

              if (result is DataSuccess && result.entity == true) {
                final UserEntity? user =
                    LocalUser().userEntity(LocalAuth.uid ?? '');
                user?.saved.add(postId);
                LocalUser().save(user!);
              } else {
                AppSnackBar.showSnackBar(
                  context,
                  'something_wrong'.tr(),
                );
              }
            }
          },
        ),
      ),
      PopupMenuItem<ListTile>(
        child: ListTile(
          leading: const Icon(Icons.report),
          title: Text(
            'report_post'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
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

Future<void> openShareOptions(
    BuildContext context, Offset position, String postLink) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final String? result = await showMenu<String>(
    context: context,
    color: Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      overlay.size.width - position.dx,
      overlay.size.height - position.dy,
    ),
    items: <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'message',
        child: Row(
          spacing: 8,
          children: <Widget>[
            const CustomSvgIcon(
              size: 18,
              assetPath: AppStrings.selloutShareAsMessageIcon,
            ),
            Text('share_as_message'.tr(),
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'group',
        child: Row(
          spacing: 8,
          children: <Widget>[
            const CustomSvgIcon(
              size: 18,
              assetPath: AppStrings.selloutShareInGroupIcon,
            ),
            Text('share_in_group'.tr(),
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    ],
  );

  if (result == 'message') {
    final List<String>? receiverIds = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SelectReceiversBottomsheet(postLink: postLink);
      },
    );
    if (receiverIds != null && receiverIds.isNotEmpty) {
      debugPrint('✅ Selected IDs: $receiverIds');
      debugPrint('🔗 Link to share: $postLink');
    }
  } else if (result == 'group') {
    final List<String>? receiverIds = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SelectGroupsBottomsheet(postLink: postLink);
      },
    );
    if (receiverIds != null && receiverIds.isNotEmpty) {
      debugPrint('✅ Selected IDs: $receiverIds');
      debugPrint('🔗 Link to share: $postLink');
    }
  }
}
