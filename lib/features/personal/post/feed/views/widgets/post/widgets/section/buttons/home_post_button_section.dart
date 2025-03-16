import 'package:flutter/material.dart';

import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import 'type/post_item_button_tile.dart';
import 'type/post_vehicle_button_tile.dart';

class PostButtonSection extends StatelessWidget {
  const PostButtonSection({
    required this.post,
    this.padding,
    super.key,
  });
  final PostEntity post;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return post.createdBy == LocalAuth.uid && post.businessID == null
        ? const SizedBox(height: 8)
        : Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: post.type == ListingType.pets
                ? PostVehicleButtonTile(post: post)
                : PostItemButtonTile(post: post),
          );
  }
}
