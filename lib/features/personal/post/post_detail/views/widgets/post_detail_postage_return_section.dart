import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/post_entity.dart';

class PostDetailPostageReturnSection extends StatelessWidget {
  const PostDetailPostageReturnSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'postage_return_and_payment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        //
        const _Tile(
          title: 'est_delivery',
          trailing: Column(
            children: <Widget>[
              //
            ],
          ),
        ),
        _Tile(
          title: 'collection',
          trailing: const Text(
            'click_collect_at_checkout',
            style: TextStyle(fontWeight: FontWeight.w500),
          ).tr(),
        ),
        _Tile(
          title: 'returns',
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'accepted_within_30_days',
                style: TextStyle(fontWeight: FontWeight.w500),
              ).tr(),
              Opacity(
                opacity: 0.7,
                child: const Text('buyer_pays_return_postage').tr(),
              ),
            ],
          ),
        ),
        _Tile(
          title: 'payments',
          trailing: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: <Widget>[
              _PaymentTile(image: AppStrings.visa),
              _PaymentTile(image: AppStrings.paypal),
              _PaymentTile(image: AppStrings.amex, bgColor: Colors.blue),
              _PaymentTile(image: AppStrings.applePayBlack),
              _PaymentTile(image: AppStrings.dinersClub),
              _PaymentTile(image: AppStrings.mastercard),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.title, required this.trailing});
  final String title;
  final Widget trailing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Opacity(
              opacity: 0.6,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
            ),
          ),
          Expanded(flex: 3, child: trailing),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.image, this.bgColor});
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
