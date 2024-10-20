import 'package:flutter/material.dart';

import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../domain/entities/post_entity.dart';
import 'type/post_item_button_tile.dart';
import 'type/post_vehicle_button_tile.dart';

class HomePostButtonSection extends StatelessWidget {
  const HomePostButtonSection({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: post.type == ListingType.vehicle
          ? PostVehicleButtonTile(post: post)
          : PostItemButtonTile(post: post),
    );
  }
}
