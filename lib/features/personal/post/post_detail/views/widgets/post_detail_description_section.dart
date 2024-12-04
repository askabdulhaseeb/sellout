import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../domain/entities/post_entity.dart';

class PostDetailDescriptionSection extends StatelessWidget {
  const PostDetailDescriptionSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '''${'description'.tr()}:''',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Html(data: post.description),
      ],
    );
  }
}
