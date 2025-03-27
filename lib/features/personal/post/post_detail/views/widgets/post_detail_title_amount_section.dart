import 'package:flutter/material.dart';

import '../../../domain/entities/post_entity.dart';

class PostDetailTitleAmountSection extends StatelessWidget {
  const PostDetailTitleAmountSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            post.title,
            maxLines: 3,
            style: TextTheme.of(context)
                .titleSmall
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          post.priceStr.toString(),
          style: TextTheme.of(context)
              .titleSmall
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
