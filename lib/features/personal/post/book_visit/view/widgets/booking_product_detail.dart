
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/post_entity.dart';

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
      padding: const EdgeInsets.all(16),
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
              SizedBox(
                width: 200,
                child: Text(
                  post.title,
                  style: texttheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('\$${post.price.toString()} ')
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
