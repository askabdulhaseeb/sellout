import 'package:flutter/material.dart';

import '../../../../../../../../domain/entities/post_entity.dart';
import 'widgets/post_add_to_basket_button.dart';
import 'widgets/post_buy_now_butto.dart';
import 'widgets/post_make_offer_button.dart';

class PostItemButtonTile extends StatelessWidget {
  const PostItemButtonTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: PostBuyNowButto(post: post)),
            const SizedBox(width: 12),
            Expanded(child: PostMakeOfferButton(post: post)),
          ],
        ),
        PostAddToBasketButton(post: post),
      ],
    );
  }
}
