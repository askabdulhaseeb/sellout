import 'package:flutter/material.dart';
import '../../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../../business/business_page/views/screens/user_business_profile_screen.dart';
import '../../../../../../../../business/core/data/sources/local_business.dart';
import '../../../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../../user/profiles/views/screens/user_profile_screen.dart';
import '../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../../../core/dialogs/post/home_post_tile_more_button_options.dart';

class PostHeaderSection extends StatelessWidget {
  const PostHeaderSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: post.businessID == null ||
              (post.businessID ?? '').isEmpty ||
              post.businessID == 'null'
          ? _UserHeader(post: post)
          : _BusinessHeader(post: post),
    );
  }
}

class _UserHeader extends StatefulWidget {
  const _UserHeader({required this.post});
  final PostEntity post;

  @override
  State<_UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<_UserHeader> {
  late Future<DataState<UserEntity?>> _userFuture;

  @override
  void initState() {
    super.initState();
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    _userFuture = getUserByUidUsecase(widget.post.createdBy);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<UserEntity?>>(
      future: _userFuture,
      initialData: LocalUser().userState(widget.post.createdBy),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<UserEntity?>> snapshot) {
        final UserEntity? user = snapshot.data?.entity;
        return SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<UserProfileScreen>(
                builder: (_) => UserProfileScreen(uid: widget.post.createdBy),
              ),
            ),
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
                      Text(widget.post.createdAt.timeAgo),
                    ],
                  ),
                ),
                _MoreButton(widget.post.postID),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BusinessHeader extends StatefulWidget {
  const _BusinessHeader({required this.post});
  final PostEntity post;

  @override
  State<_BusinessHeader> createState() => _BusinessHeaderState();
}

class _BusinessHeaderState extends State<_BusinessHeader> {
  late Future<BusinessEntity?> _businessFuture;

  @override
  void initState() {
    super.initState();
    _businessFuture = LocalBusiness().getBusiness(widget.post.businessID ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessEntity?>(
      future: _businessFuture,
      builder: (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
        final BusinessEntity? business = snapshot.data;
        return SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<UserBusinessProfileScreen>(
                builder: (BuildContext context) => UserBusinessProfileScreen(
                    businessID: widget.post.businessID ?? ''),
              ),
            ),
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
                      Text(widget.post.createdAt.timeAgo),
                    ],
                  ),
                ),
                _MoreButton(widget.post.postID),
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
    return IconButton(
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final Offset position = button.localToGlobal(Offset.zero);
        homePostTileShowMoreButton(context, position, postID);
      },
      icon: Icon(Icons.adaptive.more),
    );
  }
}
