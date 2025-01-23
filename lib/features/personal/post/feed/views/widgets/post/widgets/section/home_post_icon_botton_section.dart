import 'package:flutter/material.dart';

import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../domain/entities/post_entity.dart';

class HomePostIconBottonSection extends StatelessWidget {
  const HomePostIconBottonSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final bool isMine = post.createdBy == LocalAuth.uid;
    return Row(
      children: <Widget>[
        if (!isMine)
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () {},
          ),
        IconButton(
          icon: Icon(Icons.adaptive.share),
          onPressed: () {},
        ),
        const Spacer(),
        if (!isMine)
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () {},
          ),
      ],
    );
  }
}
