import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../data/sources/local/local_user.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/bottomsheets/block_user_bottomsheet.dart';
import '../widgets/bottomsheets/unblock_user_bottomsheet.dart';
import '../widgets/user_profile_grid_section.dart';
import '../widgets/user_profile_grid_type_selection_section.dart';
import '../widgets/user_profile_header_section.dart';
import '../widgets/user_profile_score_section.dart';

enum _ProfileMenuAction { blockToggle, close }

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.uid, super.key});
  final String uid;

  Future<void> _handleBlockToggle(
    BuildContext context, {
    required UserProfileProvider profileProvider,
    required UserEntity? user,
    bool? unblock,
  }) async {
    final String? targetUserId = user?.uid;
    if (targetUserId == null || targetUserId.isEmpty) {
      AppSnackBar.error(context, 'unable_to_find_user'.tr());
      return;
    }

    final bool willBlock = unblock != null
        ? !unblock
        : !(profileProvider.isBlocked || (user?.isBlocked ?? false));
    if (profileProvider.isProcessingBlock) return;

    final String name = user?.displayName ?? 'this_user'.tr();
    final bool? confirmed = willBlock
        ? await showBlockUserBottomSheet(context, name: name)
        : await showUnblockUserBottomSheet(context, name: name);

    if (confirmed != true) return;

    final DataState<bool?> result = await profileProvider.toggleBlockUser(
      userId: targetUserId,
      block: willBlock,
    );

    if (!context.mounted) return;

    if (result is DataSuccess<bool?>) {
      // Clear feed if blocking user
      if (willBlock) {
        context.read<FeedProvider>().removeBlockedUserPosts(targetUserId);
      }

      AppSnackBar.success(
        context,
        profileProvider.isBlocked
            ? 'user_blocked_successfully'.tr()
            : 'user_unblocked_successfully'.tr(),
      );
    } else {
      AppSnackBar.error(
        context,
        result.exception?.message ?? 'failed_to_update_block_state'.tr(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(LocalUser().userEntity(uid)?.username.toUpperCase() ?? ''),
        actions: <Widget>[
          Consumer<UserProfileProvider>(
            builder:
                (
                  BuildContext context,
                  UserProfileProvider profileProvider,
                  Widget? child,
                ) {
                  final UserEntity? cachedUser = LocalUser().userEntity(uid);
                  final bool isBlocked =
                      profileProvider.isBlocked ||
                      (profileProvider.user?.isBlocked ?? false) ||
                      (cachedUser?.isBlocked ?? false);

                  return PopupMenuButton<_ProfileMenuAction>(
                    onSelected: (_ProfileMenuAction action) async {
                      if (action == _ProfileMenuAction.blockToggle) {
                        final UserEntity? currentUser =
                            profileProvider.user ?? cachedUser;
                        await _handleBlockToggle(
                          context,
                          profileProvider: profileProvider,
                          user: currentUser,
                          unblock: isBlocked ? true : null,
                        );
                      }
                      // _ProfileMenuAction.close intentionally no-op; menu closes itself
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<_ProfileMenuAction>>[
                          PopupMenuItem<_ProfileMenuAction>(
                            value: _ProfileMenuAction.blockToggle,
                            child: profileProvider.isProcessingBlock
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isBlocked
                                        ? 'unblock_user'.tr()
                                        : 'block_user'.tr(),
                                  ),
                          ),
                          PopupMenuItem<_ProfileMenuAction>(
                            value: _ProfileMenuAction.close,
                            child: Text('cancel'.tr()),
                          ),
                        ],
                    icon: const Icon(Icons.more_vert),
                  );
                },
          ),
        ],
      ),
      body: FutureBuilder<DataState<UserEntity?>?>(
        future: Provider.of<UserProfileProvider>(
          context,
          listen: false,
        ).getUserByUid(uid),
        initialData: LocalUser().userState(uid),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<DataState<UserEntity?>?> snapshot,
            ) {
              final UserEntity? user = snapshot.data?.entity;
              final UserProfileProvider profileProvider = context
                  .watch<UserProfileProvider>();
              final bool isBlocked =
                  profileProvider.isBlocked || (user?.isBlocked ?? false);
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UserProfileHeaderSection(user: user),
                    UserProfileScoreSection(
                      user: user,
                      isBlocked: isBlocked,
                      isBusy: profileProvider.isProcessingBlock,
                      onUnblock: () async {
                        final String? targetUserId = user?.uid;
                        if (targetUserId == null || targetUserId.isEmpty) {
                          AppSnackBar.error(
                            context,
                            'unable_to_find_user'.tr(),
                          );
                          return;
                        }
                        final String name =
                            user?.displayName ?? 'this_user'.tr();
                        final bool? confirmed =
                            await showUnblockUserBottomSheet(
                              context,
                              name: name,
                            );
                        if (confirmed != true) return;
                        final result = await profileProvider.toggleBlockUser(
                          userId: targetUserId,
                          block: false,
                        );
                        if (!context.mounted) return;
                        if (result is DataSuccess<bool?>) {
                          AppSnackBar.success(
                            context,
                            'user_unblocked_successfully'.tr(),
                          );
                        } else {
                          AppSnackBar.error(
                            context,
                            result.exception?.message ??
                                'failed_to_update_block_state'.tr(),
                          );
                        }
                      },
                    ),
                    const UserProfileGridTypeSelectionSection(),
                    UserProfileGridSection(user: user),
                  ],
                ),
              );
            },
      ),
    );
  }
}
