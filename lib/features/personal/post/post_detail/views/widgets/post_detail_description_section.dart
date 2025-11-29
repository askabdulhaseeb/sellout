import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/expandable_text_widget.dart';
import '../../../domain/entities/post/post_entity.dart';

class PostDetailDescriptionSection extends StatelessWidget {
  const PostDetailDescriptionSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        Text(
          '''${'product_description'.tr()}:''',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          '''${'about_item'.tr()}:''',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        ExpandableText(
          text: post.description,
          isHtml: true,
        ),
      ],
    );
  }
}
