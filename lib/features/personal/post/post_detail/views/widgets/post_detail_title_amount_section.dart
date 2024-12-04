import 'package:flutter/material.dart';

import '../../../domain/entities/post_entity.dart';

class PostDetailTitleAmountSection extends StatelessWidget {
  const PostDetailTitleAmountSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                post.title,
                maxLines: 3,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Text(
                post.priceStr.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.adaptive.share),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
