import '../../../../../../../../../../core/widgets/empty_page_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
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
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../domain/params/share_in_chat_params.dart';

class SharePostButton extends StatelessWidget {
  const SharePostButton(
      {required this.postId, required this.tappableWidget, super.key});
  final String postId;
  final Widget tappableWidget;

  String get postLink => '${AppRoutes.baseURL}/product/$postId';

  Future<void> _showShareBottomSheet({
    required BuildContext context,
    required Widget Function(String) bottomSheetBuilder,
  }) async {
    final List<String>? receiverIds = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext ctx) => bottomSheetBuilder(postLink),
    );
    if (receiverIds == null || receiverIds.isEmpty) return;
    debugPrint('✅ Selected IDs: $receiverIds');
    debugPrint('🔗 Link to share: $postLink');
  }

  void _handleShare(BuildContext context, String value) {
    if (value == 'message') {
      _showShareBottomSheet(
        context: context,
        bottomSheetBuilder: (String link) =>
            SelectReceiversBottomsheet(postLink: link),
      );
    } else if (value == 'group') {
      _showShareBottomSheet(
        context: context,
        bottomSheetBuilder: (String link) =>
            SelectGroupsBottomsheet(postLink: link),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Theme.of(context).scaffoldBackgroundColor,
      icon: tappableWidget,
      onSelected: (String value) => _handleShare(context, value),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildMenuItem(
          context,
          value: 'message',
          icon: AppStrings.selloutShareAsMessageIcon,
          text: 'share_as_message'.tr(),
        ),
        _buildMenuItem(
          context,
          value: 'group',
          icon: AppStrings.selloutShareInGroupIcon,
          text: 'share_in_group'.tr(),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context, {
    required String value,
    required String icon,
    required String text,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        spacing: 8,
        children: <Widget>[
          CustomSvgIcon(size: 16, assetPath: icon),
          Text(text, style: TextTheme.of(context).bodySmall),
        ],
      ),
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

  // 🔹 For searching
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureUsers = _loadSupporterUsers();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          title: const AppBarTitle(titleKey: 'chats'),
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

            // 🔹 Filter users based on search query
            final List<UserEntity> filteredUsers =
                users.where((UserEntity user) {
              final String name = user.displayName.toLowerCase();
              final String email = user.email.toLowerCase();
              return name.contains(_searchQuery) ||
                  email.contains(_searchQuery);
            }).toList();

            return Column(
              children: <Widget>[
                // 🔹 Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    controller: _searchController,
                    hint: 'search'.tr(),
                  ),
                ),
                if (filteredUsers.isEmpty)
                  Expanded(
                    child: EmptyPageWidget(
                      icon: Icons.person_off,
                      childBelow: Text('no_supporters_available'.tr()),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserEntity user = filteredUsers[index];
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
                    isDisable: selectedIds.isEmpty,
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
                      if (!context.mounted) return;
                      if (result is DataSuccess) {
                        Navigator.pop(context);
                        if (mounted) {
                          AppSnackBar.success(
                            context,
                            'post_shared_successfully'.tr(),
                          );
                        }
                      } else {
                        AppSnackBar.error(
                          context,
                          'something_went_wrong'.tr(),
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

  // 🔹 For searching groups
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGroupChats();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    // 🔹 Filter groups based on search query
    final List<ChatEntity> filteredGroups = groups.where((ChatEntity group) {
      final String title = (group.groupInfo?.title ?? '').toLowerCase();
      return title.contains(_searchQuery);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(onPressed: () => Navigator.pop(context)),
          title: const AppBarTitle(titleKey: 'select_group'),
        ),
        body: Column(
          children: <Widget>[
            // 🔹 Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextFormField(
                controller: _searchController,
                hint: 'search'.tr(),
              ),
            ),
            if (filteredGroups.isEmpty)
              Expanded(
                child: EmptyPageWidget(
                  icon: Icons.group_off,
                  childBelow: Text('no_groups_found'.tr()),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredGroups.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ChatEntity group = filteredGroups[index];
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
                isDisable: selectedGroupIds.isEmpty,
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
                  if (!context.mounted) return;
                  if (result is DataSuccess) {
                    Navigator.pop(context);
                    if (mounted) {
                      AppSnackBar.success(
                        context,
                        'post_shared_successfully'.tr(),
                      );
                    }
                  } else {
                    AppSnackBar.error(
                      context,
                      'something_went_wrong'.tr(),
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
