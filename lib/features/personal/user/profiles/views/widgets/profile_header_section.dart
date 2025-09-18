import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/views/params/review_list_param.dart';
import '../../../../review/views/screens/review_list_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';
import 'subwidgets/profile_edit_settings_widget.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isMe = user?.uid == (LocalAuth.uid ?? '-');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Profile photo
          Flexible(
            child: SizedBox(
              width: 110,
              height: 110,
              child: ProfilePhoto(
                url: user?.profilePhotoURL,
                placeholder: user?.displayName ?? '',
              ),
            ),
          ),
          // Info column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Top section with name + rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        user?.displayName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isMe) const ProfileEditAndSettingsWidget()
                  ],
                ),
                RatingDisplayWidget(
                  size: 12,
                  fontSize: 12,
                  ratingList: user?.listOfReviews ?? <double>[],
                  onTap: () async {
                    final List<ReviewEntity> reviews =
                        await Provider.of<ProfileProvider>(context,
                                listen: false)
                            .getReviews(user?.uid);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute<ReviewListScreenParam>(
                        builder: (BuildContext context) => ReviewListScreen(
                          param: ReviewListScreenParam(reviews: reviews),
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  user?.username ?? '',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
