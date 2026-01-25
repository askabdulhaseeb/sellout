import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../data/sources/local/local_user.dart';
import '../../../domain/entities/user_entity.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/user_profile_grid_section.dart';
import '../widgets/user_profile_grid_type_selection_section.dart';
import '../widgets/user_profile_header_section.dart';
import '../widgets/user_profile_score_section.dart';
import 'package:sellout/core/widgets/app_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/bottomsheets/unblock_user_bottomsheet.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.uid, super.key});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(LocalUser().userEntity(uid)?.username.toUpperCase() ?? ''),
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
