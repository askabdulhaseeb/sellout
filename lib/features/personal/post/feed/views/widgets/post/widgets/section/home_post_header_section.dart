import 'package:flutter/material.dart';

import '../../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/widgets/loader.dart';
import '../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../../business/business_page/views/screens/business_page_screen.dart';
import '../../../../../../../../business/core/data/sources/local_business.dart';
import '../../../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../../user/profiles/views/screens/user_profile_screen.dart';
import '../../../../../../domain/entities/post_entity.dart';

class PostHeaderSection extends StatelessWidget {
  const PostHeaderSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: post.businessID == null || (post.businessID ?? '').isEmpty
          ? _UserHeader(post: post)
          : _BusinessHeader(post: post),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({required this.post});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    return FutureBuilder<DataState<UserEntity?>>(
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
                            Text(post.createdAt.timeAgo),
                          ],
                        ),
                      ),
                      const _MoreButton(),
                    ],
                  ),
                );
        });
  }
}

class _BusinessHeader extends StatelessWidget {
  const _BusinessHeader({required this.post});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessEntity?>(
      future: LocalBusiness().getBusiness(post.businessID ?? ''),
      builder: (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
        final BusinessEntity? business = snapshot.data;
        return snapshot.connectionState == ConnectionState.waiting
            ? const Loader()
            : GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute<BusinessPageScreen>(
                  builder: (BuildContext context) =>
                      BusinessPageScreen(businessID: post.businessID ?? ''),
                )),
                child: Row(
                  children: <Widget>[
                    ProfilePhoto(
                      url: business?.logo?.url,
                      placeholder: business?.displayName ?? '',
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  business?.displayName ?? 'null',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const FittedBox(
                                  child: Text(
                                    'B',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(post.createdAt.timeAgo),
                        ],
                      ),
                    ),
                    const _MoreButton(),
                  ],
                ),
              );
      },
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.adaptive.more),
    );
  }
}
