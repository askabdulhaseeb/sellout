import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../post/domain/entities/post_entity.dart';

class BookViewProductDetail extends StatelessWidget {
  const BookViewProductDetail({
    required this.post,
    required this.texttheme,
    super.key,
  });

  final PostEntity post;
  final TextTheme texttheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppTheme.darkScaffldColor.withAlpha(20),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  post.title,
                  style: texttheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Expanded(
                  child: Text(
                '\$${post.price.toString()}',
                maxLines: 1,
              ))
            ],
          ),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       SizedBox(
          //           child: Text(
          //         post.id,
          //         style: texttheme.bodyLarge?.copyWith(
          //             color: colorscheme.onSecondary.withAlpha(200)),
          //         overflow: TextOverflow.ellipsis,
          //       )),
          //       const Text('')
          //     ],
          //   )
        ],
      ),
    );
  }
}
