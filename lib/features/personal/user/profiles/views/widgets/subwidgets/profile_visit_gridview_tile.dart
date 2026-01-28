import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/buttons/custom_icon_button.dart';
import '../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../data/sources/local/local_visits.dart';

class ProfileVisitGridviewTile extends StatelessWidget {
  const ProfileVisitGridviewTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<List<VisitingEntity>>>(
      future: LocalVisit().visitByPostId(post.postID),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<DataState<List<VisitingEntity>>> snapshot,
          ) {
            final List<VisitingEntity> visits =
                snapshot.data?.entity ?? <VisitingEntity>[];
            return Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      AppNavigator.pushNamed(
                        PostDetailScreen.routeName,
                        arguments: <String, dynamic>{
                          'pid': post.postID,
                          'visit': visits,
                        },
                      );
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomNetworkImage(imageURL: post.imageURL),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          FutureBuilder<String>(
                            future: post.getPriceStr(),
                            builder:
                                (
                                  BuildContext context,
                                  AsyncSnapshot<String> snapshot,
                                ) {
                                  if (!snapshot.hasData) {
                                    return const Text('...');
                                  }

                                  return Text(snapshot.data!);
                                },
                          ),
                        ],
                      ),
                    ),
                    CustomIconButton(
                      iconSize: 16,
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(6),
                      iconColor: Theme.of(context).primaryColor,
                      icon: AppStrings.selloutCalenderIcon,
                      onPressed: () {},
                      bgColor: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ],
            );
          },
    );
  }
}
