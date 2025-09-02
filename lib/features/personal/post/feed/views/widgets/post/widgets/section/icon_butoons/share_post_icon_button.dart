import 'package:flutter/material.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../../routes/app_routes.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../../chats/chat/domain/usecase/share_to_chat_usecase.dart';
import '../../../../../../../../chats/chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../../../../../chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../../../../../chats/chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../../../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../../../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../domain/params/share_in_chat_params.dart';

class SharePostButton extends StatefulWidget {
  const SharePostButton({required this.post, super.key});
  final PostEntity post;

  @override
  State<SharePostButton> createState() => _SharePostButtonState();
}

class _SharePostButtonState extends State<SharePostButton> {
  String get postLink => '${AppRoutes.baseURL}/product/${widget.post.postID}';
  Future<void> _showPrivateChatBottomSheet(BuildContext context) async {
    final List<String>? receiverIds = await showModalBottomSheet<List<String>>(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SelectReceiversBottomsheet(postLink: postLink);
      },
    );
    if (receiverIds == null || receiverIds.isEmpty) return;
    debugPrint('✅ Selected IDs: $receiverIds');
    debugPrint('🔗 Link to share: $postLink');
  }

  Future<void> _showGroupChatBottomSheet(BuildContext context) async {
    final List<String>? receiverIds = await showModalBottomSheet<List<String>>(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SelectGroupsBottomsheet(postLink: postLink);
      },
    );
    if (receiverIds == null || receiverIds.isEmpty) return;
    debugPrint('✅ Selected IDs: $receiverIds');
    debugPrint('🔗 Link to share: $postLink');
  }

  void _handleShare(String value) {
    if (value == 'message') {
      _showPrivateChatBottomSheet(context);
    } else if (value == 'group') {
      _showGroupChatBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Theme.of(context).scaffoldBackgroundColor,
      icon: const CustomSvgIcon(assetPath: AppStrings.selloutShareIcon),
      onSelected: _handleShare,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'message',
          child: Row(
            spacing: 8,
            children: <Widget>[
              const CustomSvgIcon(
                  size: 16, assetPath: AppStrings.selloutShareAsMessageIcon),
              Text(
                'share_as_message'.tr(),
                style: TextTheme.of(context).bodySmall,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'group',
          child: Row(
            spacing: 8,
            children: <Widget>[
              const CustomSvgIcon(
                  size: 16, assetPath: AppStrings.selloutShareInGroupIcon),
              Text(
                'share_in_group'.tr(),
                style: TextTheme.of(context).bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectReceiversBottomsheet extends StatefulWidget {
  const SelectReceiversBottomsheet({required this.postLink, super.key});
  final String postLink;
  @override
  State<SelectReceiversBottomsheet> createState() =>
      _SelectReceiversBottomsheetState();
}

class _SelectReceiversBottomsheetState
    extends State<SelectReceiversBottomsheet> {
  final GetUserByUidUsecase getUserByUidUsecase =
      GetUserByUidUsecase(locator());
  final List<String> selectedIds = <String>[];
  late Future<List<UserEntity>> _futureUsers;
  @override
  void initState() {
    super.initState();
    _futureUsers = _loadSupporterUsers();
  }

  Future<List<UserEntity>> _loadSupporterUsers() async {
    final List<SupporterDetailEntity> supporters =
        LocalAuth.currentUser?.supporters ?? <SupporterDetailEntity>[];

    final List<UserEntity> users = <UserEntity>[];
    for (final SupporterDetailEntity supporter in supporters) {
      final DataState<UserEntity?> result =
          await getUserByUidUsecase(supporter.userID);
      if (result is DataSuccess && result.entity != null) {
        users.add(result.entity!);
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          title: Text('chats'.tr()),
          centerTitle: true,
          leading: BackButton(onPressed: () => Navigator.pop(context)),
        ),
        body: FutureBuilder<List<UserEntity>>(
          future: _futureUsers,
          builder:
              (BuildContext context, AsyncSnapshot<List<UserEntity>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<UserEntity> users = snapshot.data ?? <UserEntity>[];
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UserEntity user = users[index];
                      final bool isSelected = selectedIds.contains(user.uid);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              selectedIds.add(user.uid);
                            } else {
                              selectedIds.remove(user.uid);
                            }
                          });
                        },
                        title: Text(
                          user.displayName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(user.email),
                        secondary: ProfilePhoto(
                          size: 30,
                          url: user.profilePhotoURL,
                          placeholder: user.displayName,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomElevatedButton(
                    onTap: () async {
                      final ShareInChatUsecase shareInChatUsecase =
                          ShareInChatUsecase(locator());

                      final DataState<bool> result =
                          await shareInChatUsecase.call(
                        ShareInChatParams(
                          receiverIds: selectedIds,
                          text: widget.postLink,
                          shareType: 'chat',
                          endPointChatType: 'private',
                        ),
                      );
                      if (result is DataSuccess) {
                        Navigator.pop(context);
                        AppSnackBar.showSnackBar(
                          context,
                          'post_shared_successfully'.tr(),
                          backgroundColor: ColorScheme.of(context).tertiary,
                        );
                      } else {
                        AppSnackBar.showSnackBar(
                          context,
                          'something_went_wrong'.tr(),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                      }
                    },
                    title: 'share'.tr(),
                    isLoading: false,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SelectGroupsBottomsheet extends StatefulWidget {
  const SelectGroupsBottomsheet({required this.postLink, super.key});
  final String postLink;

  @override
  State<SelectGroupsBottomsheet> createState() =>
      _SelectGroupsBottomsheetState();
}

class _SelectGroupsBottomsheetState extends State<SelectGroupsBottomsheet> {
  final List<String> selectedGroupIds = <String>[];
  List<ChatEntity> groups = <ChatEntity>[];

  @override
  void initState() {
    super.initState();
    _loadGroupChats();
  }

  void _loadGroupChats() {
    final List<ChatEntity> allChats = LocalChat.boxLive.values.toList();

    groups = allChats.where((ChatEntity chat) {
      final bool isGroup = chat.type == ChatType.group;
      final bool isParticipant = chat.groupInfo?.participants
              .any((ChatParticipantEntity p) => p.uid == LocalAuth.uid) ??
          false;
      return isGroup && isParticipant;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(onPressed: () => Navigator.pop(context)),
          title: Text('select_group'.tr()),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (BuildContext context, int index) {
                  final ChatEntity group = groups[index];
                  final bool isSelected =
                      selectedGroupIds.contains(group.chatId);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedGroupIds.add(group.chatId);
                        } else {
                          selectedGroupIds.remove(group.chatId);
                        }
                      });
                    },
                    title: Text(
                      group.groupInfo?.title ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                        '${'members'.tr()}: ${group.groupInfo?.participants.length ?? 0}'),
                    secondary: ProfilePhoto(
                      size: 30,
                      url: group.groupInfo?.groupThumbnailURL,
                      placeholder: group.groupInfo?.title ?? '',
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomElevatedButton(
                onTap: () async {
                  final ShareInChatUsecase shareInChatUsecase =
                      ShareInChatUsecase(locator());

                  final DataState<bool> result = await shareInChatUsecase.call(
                    ShareInChatParams(
                      groupId: selectedGroupIds,
                      text: widget.postLink,
                      shareType: 'group',
                      endPointChatType: 'group',
                    ),
                  );

                  if (result is DataSuccess) {
                    Navigator.pop(context);
                    AppSnackBar.showSnackBar(
                      context,
                      'post_shared_successfully'.tr(),
                      backgroundColor: ColorScheme.of(context).tertiary,
                    );
                  } else {
                    AppSnackBar.showSnackBar(
                      context,
                      'something_went_wrong'.tr(),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    );
                  }
                },
                title: 'share'.tr(),
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
