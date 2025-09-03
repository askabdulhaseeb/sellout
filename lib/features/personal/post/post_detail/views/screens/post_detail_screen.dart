import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../providers/post_detail_provider.dart';
import '../widgets/post_details_sections/cloth_foot_post_detail_section.dart';
import '../widgets/post_details_sections/food_drink_post_Detail_section.dart';
import '../widgets/post_details_sections/item_post_detail_section.dart';
import '../widgets/post_details_sections/pets_post_detail_section.dart';
import '../widgets/post_details_sections/property_post_detail_section.dart';
import '../widgets/post_details_sections/vehicle_post_detail_section.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});
  static const String routeName = '/product';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String postID = args['pid'] ?? '';
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                Text('back'.tr()),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<DataState<PostEntity>>(
        future: Provider.of<PostDetailProvider>(context, listen: false)
            .getPost(postID),
        initialData: LocalPost().dataState(postID),
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState<PostEntity>> snapshot,
        ) {
          final PostEntity? post =
              snapshot.data?.entity ?? LocalPost().post(postID);
          return post == null
              ? const SizedBox()
              : post.listID == ListingType.items.json
                  ? ItemPostDetailSection(
                      post: post,
                    )
                  : post.listID == ListingType.clothAndFoot.json
                      ? ClothFootPostDetailSection(
                          post: post,
                        )
                      : post.listID == ListingType.foodAndDrink.json
                          ? FoodDrinkPostDetailSection(post: post)
                          : post.listID == ListingType.property.json
                              ? PropertyPostDetailSection(
                                  post: post,
                                )
                              : post.listID == ListingType.pets.json
                                  ? PetsPostDetailSection(
                                      post: post,
                                    )
                                  : post.listID == ListingType.vehicle.json
                                      ? VehiclePostDetailSection(
                                          post: post,
                                        )
                                      : const SizedBox.shrink();
        },
      ),
    );
  }
}
