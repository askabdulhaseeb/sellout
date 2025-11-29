import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/views/params/review_list_param.dart';
import '../../../../review/views/screens/review_list_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';

class UserProfileHeaderSection extends StatelessWidget {
  const UserProfileHeaderSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double photoSize = screenWidth * 0.25;
    final double nameFontSize = screenWidth * 0.045;
    final double bioFontSize = screenWidth * 0.037;
    final double verticalGap = screenWidth * 0.03;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: photoSize,
            height: photoSize,
            child: ProfilePhoto(
              url: user?.profilePhotoURL,
              placeholder: user?.displayName ?? '',
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
                        user?.displayName ?? '',
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
                RatingDisplayWidget(
                  size: 16,
                  fontSize: 13,
                  ratingList: user?.listOfReviews ?? <double>[],
                  onTap: () async {
                    final List<ReviewEntity> reviews =
                        await Provider.of<ProfileProvider>(
                      context,
                      listen: false,
                    ).getReviews(user?.uid);
                    Navigator.of(context).push(
                      MaterialPageRoute<ReviewListScreenParam>(
                        builder: (BuildContext context) => ReviewListScreen(
                          param: ReviewListScreenParam(reviews: reviews),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: verticalGap),
                if ((user?.bio ?? '').isNotEmpty)
                  Text(
                    user?.bio ?? '',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: bioFontSize,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
