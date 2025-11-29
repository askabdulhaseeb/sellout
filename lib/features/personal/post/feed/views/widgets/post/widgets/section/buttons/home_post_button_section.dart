import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../domain/entities/post/post_entity.dart';
import 'type/post_button_for_user_tile.dart';
import 'type/store_post_button_tile.dart';
import 'type/viewing_post_button_tile.dart';

class PostButtonSection extends StatelessWidget {
  const PostButtonSection({
    required this.post,
    required this.detailWidget,
    super.key,
  });
  final PostEntity post;
  final bool detailWidget;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: post.createdBy == LocalAuth.currentUser?.userID ||
                post.createdBy == LocalAuth.currentUser?.businessID
            ? PostButtonsForUser(post: post)
            : GestureDetector(
                onTap: () {
                  if (LocalAuth.uid == null) {
                    AppSnackBar.showSnackBar(
                        context, 'please_login_first'.tr());
                  }
                },
                child: LocalAuth.uid == post.createdBy
                    ? PostButtonsForUser(post: post)
                    : AbsorbPointer(
                        absorbing: LocalAuth.uid == null,
                        child: (post.type == ListingType.pets ||
                                post.type == ListingType.vehicle ||
                                post.type == ListingType.property)
                            ? ViewingPostButtonTile(
                                post: post,
                                detailWidget: detailWidget,
                              )
                            : StorePostButtonTile(
                                post: post,
                                detailWidget: detailWidget,
                              ),
                      ),
              ));
  }
}
