import 'package:flutter/material.dart';

import '../../../../../../../../../core/helper_functions/currency_symbol_helper.dart';
import '../../../../../../domain/entities/post_entity.dart';

class HomePostTitleSection extends StatelessWidget {
  const HomePostTitleSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                post.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${currencySymbolHelper(post.currency)}${post.price.toString()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 8),
        // post.description.isEmpty
        //     ? const SizedBox()
        //     : LimitedLinesHtmlText(
        //         htmlData: post.description,
        //         maxLines: 3,
        //       ),
      ],
    );
  }
}
