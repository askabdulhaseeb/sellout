import 'package:flutter/material.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';

class BookViewProductDetail extends StatelessWidget {
  const BookViewProductDetail({
    required this.texttheme,
    this.post,
    super.key,
    this.service,
  });

  final PostEntity? post;
  final ServiceEntity? service;

  final TextTheme texttheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  post?.title ?? service?.name ?? 'null',
                  style: texttheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${post?.price.toString() ?? service?.price.toString() ?? 'null'}',
                maxLines: 1,
              )
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
