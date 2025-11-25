import 'package:flutter/material.dart';
import '../../../domain/entities/post/post_entity.dart';

class PostDetailTitleAmountSection extends StatelessWidget {
  const PostDetailTitleAmountSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
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
          FutureBuilder<String>(
            future: post.getPriceStr(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return const Text('...');
              }

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
