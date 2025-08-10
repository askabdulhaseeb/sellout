import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/entities/visit/visiting_entity.dart';
import '../providers/post_detail_provider.dart';
import '../widgets/post_details_sections/general/general_post_detail_section.dart';
import '../widgets/post_details_sections/pets/pets_post_detail_section.dart';
import '../widgets/post_details_sections/property/property_post_detail_section.dart';
import '../widgets/post_details_sections/vehicle/vehicle_post_detail_section.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});
  static const String routeName = '/product';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String postID = args['pid'] ?? '';
    final VisitingEntity? visit = args['visit'] as VisitingEntity?;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                Text('go_back'.tr()),
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
          final bool isMe =
              post?.createdBy == (LocalAuth.currentUser?.businessID ?? '-');
          return post == null
              ? const SizedBox()
              : (post.listID == ListingType.pets.json
                  ? PetsPostDetailSection(post: post, isMe: isMe, visit: visit)
                  : post.listID == ListingType.vehicle.json
                      ? VehiclePostDetailSection(
                          post: post, isMe: isMe, visit: visit)
                      : post.listID == ListingType.property.json
                          ? PropertyPostDetailSection(
                              post: post, isMe: isMe, visit: visit)
                          : GeneralPostDetailSection(
                              post: post, isMe: isMe, visit: visit));
        },
      ),
    );
  }
}
