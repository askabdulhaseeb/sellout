import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/post_entity.dart';

class PostDetailTileListSection extends StatelessWidget {
  const PostDetailTileListSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    const Divider divider = Divider(height: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Tile(title: 'condition', trailingText: post.condition.code.tr()),
        divider,
        _Tile(title: 'privacy', trailingText: post.privacy.code.tr()),
        divider,
        _Tile(title: 'type', trailingText: post.type.code.tr()),
        divider,
        _Tile(title: 'delivery_fee', trailingText: post.deliveryType.code.tr()),
        divider,
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.title, this.trailingText});
  final String title;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          '${title.tr()}: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (trailingText != null) Text(trailingText ?? ''),
      ],
    );
  }
}
