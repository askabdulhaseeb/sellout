import 'package:flutter/material.dart';
import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../domain/entities/visit/visiting_entity.dart';
import 'type/post_button_for_user_tile.dart';
import 'type/post_item_button_tile.dart';
import 'type/post_vehicle_button_tile.dart';

class PostButtonSection extends StatelessWidget {
  const PostButtonSection({
    required this.post,
    this.padding,
    this.visit,
    super.key,
  });
  final PostEntity post;
  final VisitingEntity? visit;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return post.createdBy == LocalAuth.currentUser?.userID ||
            post.createdBy == LocalAuth.currentUser?.businessID
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: PostButtonsForUser(visit: visit, post: post),
          )
        : Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: (post.type == ListingType.pets ||
                    post.type == ListingType.vehicle ||
                    post.type == ListingType.property)
                ? PostVehicleButtonTile(post: post)
                : PostItemButtonTile(post: post),
          );
  }
}
