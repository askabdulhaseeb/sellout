import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/media/profile_photo.dart';
import '../../../../../../../core/widgets/indicators/rating_display_widget.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/views/params/review_list_param.dart';
import '../../../../../review/views/screens/review_list_screen.dart';
import '../../../domain/entities/user_entity.dart';
import '../providers/user_profile_provider.dart';

class UserProfileHeaderSection extends StatefulWidget {
  const UserProfileHeaderSection({required this.user, super.key});
  final UserEntity? user;

  @override
  State<UserProfileHeaderSection> createState() =>
      _UserProfileHeaderSectionState();
}

class _UserProfileHeaderSectionState extends State<UserProfileHeaderSection> {
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
    final bool isBlocked = profileProvider.isBlocked;
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
                    if ((widget.user?.bio ?? '').isNotEmpty) ...[
                      SizedBox(height: verticalGap),
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
