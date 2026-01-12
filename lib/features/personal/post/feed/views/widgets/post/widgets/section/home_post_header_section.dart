import 'package:flutter/material.dart';
import '../../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../../business/business_page/views/screens/user_business_profile_screen.dart';
import '../../../../../../../../business/core/data/sources/local_business.dart';
import '../../../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../../user/profiles/views/user_profile/screens/user_profile_screen.dart';
import '../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../core/dialogs/post/home_post_tile_more_button_options.dart';

class PostHeaderSection extends StatelessWidget {
  const PostHeaderSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final bool isUserPost = post.businessID == null ||
        (post.businessID ?? '').isEmpty ||
        post.businessID == 'null';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isUserPost
          ? _Header<UserEntity?>(
              future: GetUserByUidUsecase(locator())(post.createdBy)
                  .then((DataState<UserEntity?> state) => state.entity)
                  .catchError((_) => null),
              localEntity: LocalUser().userState(post.createdBy).entity,
              name: (UserEntity? user) => user?.displayName ?? 'null',
              photoUrl: (UserEntity? user) => user?.profilePhotoURL,
              onTap: (UserEntity? user) => Navigator.of(context).push(
                MaterialPageRoute<UserProfileScreen>(
                  builder: (_) => UserProfileScreen(uid: post.createdBy),
                ),
              ),
              post: post,
            )
          : _Header<BusinessEntity?>(
              future: LocalBusiness().getBusiness(post.businessID ?? ''),
              localEntity: null,
              name: (BusinessEntity? business) =>
                  business?.displayName ?? 'null',
              photoUrl: (BusinessEntity? business) => business?.logo?.url,
              onTap: (BusinessEntity? business) => Navigator.of(context).push(
                MaterialPageRoute<UserBusinessProfileScreen>(
                  builder: (_) => UserBusinessProfileScreen(
                      businessID: post.businessID ?? ''),
                ),
              ),
              post: post,
              showBusinessBadge: true,
            ),
    );
  }
}

class _Header<T> extends StatelessWidget {
  const _Header({
    required this.future,
    required this.localEntity,
    required this.name,
    required this.photoUrl,
    required this.onTap,
    required this.post,
    this.showBusinessBadge = false,
  });

  final Future<T> future;
  final T? localEntity;
  final String Function(T? entity) name;
  final String? Function(T? entity) photoUrl;
  final void Function(T? entity) onTap;
  final PostEntity post;
  final bool showBusinessBadge;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      initialData: localEntity,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        final T? entity = snapshot.data;
        return SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () => onTap(entity),
            child: Row(
              children: <Widget>[
                ProfilePhoto(
                  url: photoUrl(entity),
                  placeholder: name(entity),
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
                              name(entity),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (showBusinessBadge) ...<Widget>[
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
                        ],
                      ),
                      Text(post.createdAt.timeAgo),
                    ],
                  ),
                ),
                _MoreButton(post.postID),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton(this.postID);
  final String postID;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final Offset position = button.localToGlobal(Offset.zero);
        homePostTileShowMoreButton(context, position, postID);
      },
      child: const CustomSvgIcon(assetPath: AppStrings.selloutMOreMenuIcon),
    );
  }
}
