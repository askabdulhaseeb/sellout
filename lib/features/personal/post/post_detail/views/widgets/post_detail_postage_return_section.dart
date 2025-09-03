import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/post/post_entity.dart';

class PostDetailPostageReturnSection extends StatelessWidget {
  const PostDetailPostageReturnSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'postage_return_and_payment',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ).tr(),
          const Divider(),
          //
          Text(
            'est_delivery',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4)),
          ),
          const SizedBox(
            height: 8,
          ),
          //TODO:delivey and postage not finalized
          Text(
            'Thu 23 Nov - Fri 14 December',
            style: TextTheme.of(context)
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            'From EdenBUrg United Kingdom',
            style: TextTheme.of(context).titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
          ),

          const SizedBox(
            height: 6,
          ),
          Text(
            'collection'.tr(),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4)),
          ),
          Text(
            'click_collect_at_checkout'.tr(),
            style: TextTheme.of(context)
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.normal),
          ),
          const Divider(),
          // _Tile(
          //   title: 'collection',
          //   trailing: const Text(
          //     'click_collect_at_checkout',
          //     style: TextStyle(fontWeight: FontWeight.w500),
          //   ).tr(),
          // ),
          // _Tile(
          //   title: 'returns',
          //   trailing: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //       const Text(
          //         'accepted_within_30_days',
          //         style: TextStyle(fontWeight: FontWeight.w500),
          //       ).tr(),
          //       Opacity(
          //         opacity: 0.7,
          //         child: const Text('buyer_pays_return_postage').tr(),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PostDetailTile extends StatelessWidget {
  const PostDetailTile({
    required this.title,
    required this.trailing,
    super.key,
  });

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Opacity(
            opacity: 0.6,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ).tr(),
          ),
          const SizedBox(height: 4),
          trailing, // Now placed below the title
        ],
      ),
    );
  }
}

class PostDetailPaymentTile extends StatelessWidget {
  const PostDetailPaymentTile({required this.image, super.key, this.bgColor});
  final String image;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).disabledColor),
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Image.asset(image),
    );
  }
}
