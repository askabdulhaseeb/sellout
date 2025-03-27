import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';

class PostGridViewTile extends StatelessWidget {
  const PostGridViewTile({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    final bool isMe = post.createdBy == (LocalAuth.uid ?? '-');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostDetailScreen.routeName,
          arguments: <String, dynamic>{'pid': post.postID},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(imageURL: post.imageURL),
                  ),
                ),
                if (isMe != true)
                  CustomIconButton(icon: CupertinoIcons.cart, onPressed: () {})
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      post.title,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RatingDisplayWidget(
                    size: 12,
                    ratingList: post.listOfReviews!,
                  ),
                  Text(
                    post.priceStr,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 100,
                child: Column(
                  children: <Widget>[
                    if (isMe == true)
                      CustomIconButton(
                        iconColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        bgColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 200),
                        icon: CupertinoIcons.pencil_ellipsis_rectangle,
                        onPressed: () {},
                      ),
                    if (isMe == true)
                      CustomIconButton(
                        iconColor: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        bgColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 200),
                        icon: CupertinoIcons.speaker,
                        onPressed: () {},
                      ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
