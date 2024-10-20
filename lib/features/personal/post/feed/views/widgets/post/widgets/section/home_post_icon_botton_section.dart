import 'package:flutter/material.dart';

import '../../../../../../domain/entities/post_entity.dart';

class HomePostIconBottonSection extends StatelessWidget {
  const HomePostIconBottonSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chat_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.adaptive.share),
          onPressed: () {},
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_add_outlined),
          onPressed: () {},
        ),
      ],
    );
  }
}
