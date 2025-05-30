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
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          maxLines: 2,
                          user?.displayName ?? '',
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
                  const Spacer(),
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

  // void showMenuDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         contentPadding: EdgeInsets.zero,
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             ListTile(
  //               leading: const Icon(Icons.edit, color: Colors.blue),
  //               title: const Text('Edit Profile'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 Navigator.pushNamed(
  //                     context, '/editProfile'); // Replace with actual route
  //               },
  //             ),
  //             const Divider(height: 1),
  //             ListTile(
  //               leading: const Icon(Icons.settings, color: Colors.blue),
  //               title: const Text('Settings'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 Navigator.pushNamed(
  //                     context, '/settings'); // Replace with actual route
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
