import 'package:flutter/material.dart';

import '../../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/widgets/loader.dart';
import '../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../../user/profiles/views/screens/user_profile_screen.dart';
import '../../../../../../domain/entities/post_entity.dart';

class HomePostHeaderSection extends StatelessWidget {
  const HomePostHeaderSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<DataState<UserEntity?>>(
          future: getUserByUidUsecase(post.createdBy),
          initialData: LocalUser().userState(post.createdBy),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<UserEntity?>> snapshot) {
            final DataState<UserEntity?>? result = snapshot.data;
            final UserEntity? user = result?.entity;
            return snapshot.connectionState == ConnectionState.waiting
                ? const Loader()
                : GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute<UserProfileScreen>(
                      builder: (BuildContext context) =>
                          UserProfileScreen(uid: post.createdBy),
                    )),
                    child: Row(
                      children: <Widget>[
                        ProfilePhoto(
                          url: user?.profilePhotoURL,
                          placeholder: user?.displayName ?? '',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user?.displayName ?? 'null',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                post.createdAt.timeAgo,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.adaptive.more),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
