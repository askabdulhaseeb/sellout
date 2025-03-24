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
import '../screens/edit_profile_screen.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isMe = user?.uid == (LocalAuth.uid ?? '-');
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                          maxLines: 2,
                          user?.displayName ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isMe) const Spacer(),
                      if (isMe)
                        Row(
                          children: <Widget>[
                            const Icon(Icons.home_outlined),
                            GestureDetector(
                              onTap: () {},
                              child: PopupMenuButton<int>(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                onSelected: (int value) {
                                  if (value == 1) {
                                    Navigator.pushNamed(
                                        context, EditProfileScreen.routeName);
                                  } else if (value == 2) {}
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
                                  const PopupMenuItem<int>(
                                    value: 1,
                                    child: Text('Edit Profile'),
                                  ),
                                  const PopupMenuItem<int>(
                                    value: 2,
                                    child: Text('Settings'),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            )
                          ],
                        )
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

  void showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, '/editProfile'); // Replace with actual route
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, '/settings'); // Replace with actual route
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
