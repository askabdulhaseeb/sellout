import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/features/reivew_list/views/params/review_list_param.dart';
import '../../../../review/features/reivew_list/views/screens/review_list_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isMe = user?.uid == (LocalAuth.uid ?? '-');
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1 / 1,
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
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          user?.displayName ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isMe) const SizedBox(width: 8),
                      if (isMe)
                        TextButton(
                          onPressed: () {},
                          child: const Text('edit').tr(),
                        ),
                    ],
                  ),
                  RatingDisplayWidget(
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
                  const SizedBox(height: 8),
                  Text(
                    user?.username ?? '',
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
      ),
    );
  }
}
