import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../../listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';

class PostGridViewTile extends StatelessWidget {
  const PostGridViewTile({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    final bool isMe = (post.createdBy == (LocalAuth.uid ?? '') ||
        post.createdBy == LocalAuth.currentUser?.businessID);

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
                  height: 330,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(imageURL: post.imageURL),
                  ),
                ),
                if (isMe != true)
                  CustomIconButton(
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                      icon: CupertinoIcons.cart,
                      onPressed: () {})
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Column(
                spacing: 2,
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
                height: 80,
                child: Column(
                  children: <Widget>[
                    if (isMe == true)
                      CustomIconButton(
                        iconColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        bgColor: Theme.of(context).primaryColor.withAlpha(40),
                        icon: CupertinoIcons.pencil_circle,
                        onPressed: () {
                          final AddListingFormProvider pro =
                              Provider.of<AddListingFormProvider>(context,
                                  listen: false);
                          pro.reset();
                          pro.setListingType(post.type);
                          pro.setPost(post);
                          pro.updateVariables();
                          Navigator.pushNamed(
                              context, AddListingFormScreen.routeName);
                        },
                      ),
                    if (isMe == true)
                      CustomIconButton(
                        iconColor: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        bgColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(40),
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
