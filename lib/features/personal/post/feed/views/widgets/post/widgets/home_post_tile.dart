import 'package:flutter/material.dart';

import '../../../../../../../../core/widgets/attachment_slider.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../domain/entities/post_entity.dart';
import 'section/home_post_header_section.dart';

class HomePostTile extends StatelessWidget {
  const HomePostTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ShadowContainer(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            HomePostHeaderSection(post: post),
            AttachmentsSlider(urls: post.fileUrls),
          ],
        ),
      ),
    );
  }
}
