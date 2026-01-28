import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../features/personal/home/view/widgets/post/widgets/section/bottomsheets/post_report_bottomsheet.dart';
import '../../../features/personal/home/view/widgets/post/widgets/section/icon_butoons/share_post_icon_button.dart';
import '../../utilities/app_string.dart';
import '../../widgets/custom_svg_icon.dart';

void homePostTileShowMoreButton(
  BuildContext context,
  Offset position,
  String postId,
) {
  showMenu(
    color: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
    items: <PopupMenuItem<ListTile>>[
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
    if (!context.mounted) return;
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
    if (!context.mounted) return;
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
