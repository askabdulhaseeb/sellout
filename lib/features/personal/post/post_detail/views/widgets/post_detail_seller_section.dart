import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/data/models/user_model.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../feed/views/widgets/post/widgets/section/icon_butoons/post_inquiry_buttons.dart';
import '../../../feed/views/widgets/post/widgets/section/icon_butoons/save_post_icon_button.dart';
import '../../../feed/views/widgets/post/widgets/section/icon_butoons/share_post_icon_button.dart';
import '../../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../../services/get_it.dart';

class PostDetailSellerSection extends StatefulWidget {
  const PostDetailSellerSection({required this.post, super.key});
  final PostEntity post;

  @override
  State<PostDetailSellerSection> createState() =>
      _PostDetailSellerSectionState();
}

class _PostDetailSellerSectionState extends State<PostDetailSellerSection> {
  UserEntity? user;
  BusinessEntity? business;

  @override
  void initState() {
    super.initState();

    final String? businessID = widget.post.businessID;
    if (businessID == null || businessID.isEmpty || businessID == 'null') {
      // Fetch user
      final GetUserByUidUsecase getUserByUid = GetUserByUidUsecase(locator());
      getUserByUid(widget.post.createdBy)
          .then((DataState<UserEntity?> dataState) {
        if (mounted) {
          setState(() {
            user = dataState.entity;
          });
        }
      });
    } else {
      final GetBusinessByIdUsecase getBusinessById =
          GetBusinessByIdUsecase(locator());
      getBusinessById(businessID).then((DataState<BusinessEntity?> dataState) {
        if (mounted) {
          setState(() {
            business = dataState.entity;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayName =
        user?.displayName ?? business?.displayName ?? 'Loading...';
    final String? photoUrl = user?.profilePhotoURL ?? business?.logo?.url;
    final bool isMine = widget.post.createdBy == LocalAuth.uid;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorScheme.of(context).outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(
                width: 50,
              ),
              Column(
                spacing: 6,
                children: <Widget>[
                  ProfilePhoto(
                    isCircle: true,
                    url: photoUrl ?? '',
                    placeholder: displayName,
                    size: 30,
                  ),
                  Text(
                    user?.displayName ?? business?.displayName ?? 'na'.tr(),
                    style: TextTheme.of(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
              Row(
                spacing: 4,
                children: <Widget>[
                  Icon(
                    CupertinoIcons.star_fill,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                  RatingDisplayWidget(
                      prefixColor: ColorScheme.of(context).outline,
                      displayStars: false,
                      displayPrefix: false,
                      ratingList: user?.listOfReviews ??
                          business?.listOfReviews ??
                          <double>[]),
                ],
              ),
            ],
          ),
          const Divider(thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (!isMine) CreatePostInquiryChatButton(post: widget.post),
              SharePostButton(
                post: widget.post,
              ),
              if (!isMine)
                SavePostIconButton(
                  postId: widget.post.postID,
                )
            ],
          ),
        ],
      ),
    );
  }
}
