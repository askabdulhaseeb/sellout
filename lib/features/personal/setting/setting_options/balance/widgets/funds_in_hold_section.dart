import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../order/data/source/local/local_orders.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../payment/domain/entities/wallet_funds_in_hold_entity.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import 'funds_in_hold_item_card.dart';

class FundsInHoldSection extends StatefulWidget {
  const FundsInHoldSection({required this.fundsInHold, super.key});

  final List<WalletFundsInHoldEntity> fundsInHold;

  @override
  State<FundsInHoldSection> createState() => _FundsInHoldSectionState();
}

class _FundsInHoldSectionState extends State<FundsInHoldSection> {
  late final Future<void> _openBoxesFuture;

  @override
  void initState() {
    super.initState();
    _openBoxesFuture = Future.wait(<Future<dynamic>>[
      LocalOrders().refresh(),
      LocalPost().refresh(),
    ]).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'funds_in_hold'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (widget.fundsInHold.isEmpty)
          Text('no_funds_in_hold'.tr())
        else
          FutureBuilder<void>(
            future: _openBoxesFuture,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('loading'.tr());
              }

              return Column(
                children: widget.fundsInHold.map((
                  WalletFundsInHoldEntity hold,
                ) {
                  OrderEntity? order;
                  PostEntity? post;

                  try {
                    order = LocalOrders().get(hold.orderId);
                  } catch (_) {}

                  try {
                    post = LocalPost().post(hold.postId);
                  } catch (_) {}

                  return FundsInHoldItemCard(
                    hold: hold,
                    order: order,
                    post: post,
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }
}
