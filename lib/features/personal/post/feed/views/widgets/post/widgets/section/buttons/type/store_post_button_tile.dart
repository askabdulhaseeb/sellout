import 'package:flutter/material.dart';
import '../../../../../../../../domain/entities/post_entity.dart';
import 'widgets/counter_widget.dart';
import 'widgets/post_add_to_basket_button.dart';
import 'widgets/post_buy_now_button.dart';
import 'widgets/post_make_offer_button.dart';

class StorePostButtonTile extends StatefulWidget {
  const StorePostButtonTile({required this.post, super.key});
  final PostEntity post;

  @override
  State<StorePostButtonTile> createState() => _StorePostButtonTileState();
}

class _StorePostButtonTileState extends State<StorePostButtonTile> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          spacing: 12,
          children: <Widget>[
            Expanded(
                child: PostBuyNowButton(post: widget.post, quantity: quantity)),
            if (widget.post.acceptOffers == true)
              Expanded(child: PostMakeOfferButton(post: widget.post)),
          ],
        ),
        Row(
          spacing: 12,
          children: <Widget>[
            Expanded(
              child: PostCounterWidget(
                initialQuantity: quantity,
                maxQuantity: widget.post.quantity,
                onChanged: (int value) {
                  setState(() {
                    quantity = value;
                  });
                },
              ),
            ),
            Expanded(
                child: PostAddToBasketButton(
                    post: widget.post, quantity: quantity)),
          ],
        )
      ],
    );
  }
}
