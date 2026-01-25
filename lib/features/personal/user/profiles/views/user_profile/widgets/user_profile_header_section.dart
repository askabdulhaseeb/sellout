import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/views/params/review_list_param.dart';
import '../../../../../review/views/screens/review_list_screen.dart';
import '../../../domain/entities/user_entity.dart';
import '../providers/user_profile_provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import 'bottomsheets/block_user_bottomsheet.dart';
import 'bottomsheets/unblock_user_bottomsheet.dart';

enum _ProfileOverflowAction { blockToggle }

class UserProfileHeaderSection extends StatefulWidget {
  const UserProfileHeaderSection({required this.user, super.key});
  final UserEntity? user;

  @override
  State<UserProfileHeaderSection> createState() =>
      _UserProfileHeaderSectionState();
}

class _UserProfileHeaderSectionState extends State<UserProfileHeaderSection> {
  Future<void> _confirmBlockToggle(
    BuildContext context, {
    bool? unblock,
  }) async {
    final UserProfileProvider profileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final String? targetUserId = widget.user?.uid;

    if (targetUserId == null || targetUserId.isEmpty) {
      AppSnackBar.error(context, 'unable_to_find_user'.tr());
      return;
    }

    final bool willBlock = unblock ?? !profileProvider.isBlocked;
    if (profileProvider.isProcessingBlock) return;

    final String name = widget.user?.displayName ?? 'this_user'.tr();

    final bool? confirmed = willBlock
        ? await showBlockUserBottomSheet(context, name: name)
        : await showUnblockUserBottomSheet(context, name: name);

    if (confirmed != true) return;

    final DataState<bool?> result = await profileProvider.toggleBlockUser(
      userId: targetUserId,
      block: willBlock,
    );

    if (!mounted) return;

    if (result is DataSuccess<bool?>) {
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

  Future<void> _navigateToReviews(BuildContext context) async {
    final List<ReviewEntity> reviews = await Provider.of<UserProfileProvider>(
      context,
      listen: false,
    ).getReviews(widget.user?.uid);

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<ReviewListScreen>(
        builder: (BuildContext context) =>
            ReviewListScreen(param: ReviewListScreenParam(reviews: reviews)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileProvider profileProvider = context
        .watch<UserProfileProvider>();
    final bool isBlocked =
        profileProvider.isBlocked || (widget.user?.isBlocked ?? false);
    final bool isProcessingBlock = profileProvider.isProcessingBlock;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double photoSize = screenWidth * 0.25;
    final double nameFontSize = screenWidth * 0.045;
    final double bioFontSize = screenWidth * 0.037;
    final double verticalGap = screenWidth * 0.03;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[
          // if (isBlocked) ...<Widget>[
          //   _BlockedBanner(
          //     displayName: widget.user?.displayName,
          //     onUnblock: () => _confirmBlockToggle(context, unblock: true),
          //     busy: isProcessingBlock,
          //   ),
          //   const SizedBox(height: 12),
          // ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: photoSize,
                height: photoSize,
                child: ProfilePhoto(
                  url: widget.user?.profilePhotoURL,
                  placeholder: widget.user?.displayName ?? '',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.user?.displayName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: nameFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        PopupMenuButton<_ProfileOverflowAction>(
                          onSelected: (_ProfileOverflowAction action) {
                            if (action == _ProfileOverflowAction.blockToggle) {
                              _confirmBlockToggle(context);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<_ProfileOverflowAction>>[
                                PopupMenuItem<_ProfileOverflowAction>(
                                  value: _ProfileOverflowAction.blockToggle,
                                  child: isProcessingBlock
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
                              ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalGap),
                    IgnorePointer(
                      ignoring: isBlocked,
                      child: RatingDisplayWidget(
                        size: 16,
                        fontSize: 13,
                        ratingList: widget.user?.listOfReviews ?? <double>[],
                        onTap: () => _navigateToReviews(context),
                      ),
                    ),
                    SizedBox(height: verticalGap),
                    if ((widget.user?.bio ?? '').isNotEmpty)
                      IgnorePointer(
                        ignoring: isBlocked,
                        child: Text(
                          widget.user?.bio ?? '',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: bioFontSize,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
