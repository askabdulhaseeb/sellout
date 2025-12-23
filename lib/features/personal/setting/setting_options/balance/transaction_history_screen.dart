import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../order/data/source/local/local_orders.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../payment/domain/entities/wallet_transaction_entity.dart';
import '../../../post/data/sources/local/local_post.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import 'widgets/transaction_item_card.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({
    required this.transactionHistory,
    super.key,
  });

  final List<WalletTransactionEntity> transactionHistory;

  static String routeName = '/transaction-history';

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
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
    return Scaffold(
      appBar: AppBar(title: Text('transaction_history'.tr())),
      body: widget.transactionHistory.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_transaction_history'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder<void>(
              future: _openBoxesFuture,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.transactionHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    final WalletTransactionEntity transaction =
                        widget.transactionHistory[index];

                    OrderEntity? order;
                    PostEntity? post;

                    try {
                      order = LocalOrders().get(transaction.orderId);
                    } catch (_) {}

                    try {
                      post = LocalPost().post(transaction.postId);
                    } catch (_) {}

                    return TransactionItemCard(
                      transaction: transaction,
                      order: order,
                      post: post,
                    );
                  },
                );
              },
            ),
    );
  }
}
