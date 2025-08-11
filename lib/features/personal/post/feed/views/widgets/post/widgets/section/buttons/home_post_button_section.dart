import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../domain/entities/visit/visiting_entity.dart';
import 'type/post_button_for_user_tile.dart';
import 'type/post_item_button_tile.dart';
import 'type/post_vehicle_button_tile.dart';

class PostButtonSection extends StatelessWidget {
  const PostButtonSection({
    required this.post,
    this.visit,
    super.key,
  });
  final PostEntity post;
  final List<VisitingEntity>? visit;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: post.createdBy == LocalAuth.currentUser?.userID ||
                post.createdBy == LocalAuth.currentUser?.businessID
            ? PostButtonsForUser(visit: visit, post: post)
            : GestureDetector(
                onTap: () {
                  if (LocalAuth.currentUser?.userID == null) {
                    AppSnackBar.showSnackBar(
                        context, 'please_login_first'.tr());
                  }
                },
                child: AbsorbPointer(
                  absorbing: LocalAuth.currentUser?.userID == null,
                  child: (post.type == ListingType.pets ||
                          post.type == ListingType.vehicle ||
                          post.type == ListingType.property)
                      ? PostVehicleButtonTile(post: post)
                      : PostItemButtonTile(post: post),
                ),
              ));
  }
}
