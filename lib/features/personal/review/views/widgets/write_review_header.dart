import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../post/domain/entities/post_entity.dart';

class WriteReviewHeaderSection extends StatelessWidget {
  const WriteReviewHeaderSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: 150,
            width: 150,
            child: ProfilePhoto(url: post.imageURL, placeholder: post.title)),
        const SizedBox(height: 4),
        Text(
          textAlign: TextAlign.center,
          post.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 6,
        ),
        const Divider(),
      ],
    );
  }
}
