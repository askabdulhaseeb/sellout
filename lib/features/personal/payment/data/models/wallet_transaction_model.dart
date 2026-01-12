import '../../../../../../core/enums/core/status_type.dart';
import '../../domain/entities/wallet_transaction_entity.dart';

class WalletTransactionModel extends WalletTransactionEntity {
   WalletTransactionModel({
    required super.id,
    required super.transferAmount,
    required super.payoutAmount,
    required super.currency,
    required super.status,
    required super.type,
    required super.createdAt,
    required super.stripeTransferId,
    required super.stripePayoutId,
    required super.paidAt,
    required super.payoutType,
    required super.description,
    required super.fundId,
    required super.releasedAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    // Handle both old format (transfer_amount/payout_amount) and new format (amount)
    final double amount = (json['amount'] ?? 0).toDouble();
    final String type = (json['type'] ?? '').toString();

    // Determine default status based on type if not provided
    String statusStr = (json['status'] ?? '').toString();
    if (statusStr.isEmpty) {
      // Release transactions without explicit status should be "released"
      if (type.toLowerCase() == 'release') {
        statusStr = 'released';
      }
    }

    // Determine transfer vs payout amounts based on transaction type
    double transferAmt = 0;
    double payoutAmt = 0;

    if (type.toLowerCase() == 'payout-to-bank') {
      payoutAmt = (json['payout_amount'] ?? amount).toDouble();
    } else if (type.toLowerCase() == 'release') {
      transferAmt = (json['transfer_amount'] ?? amount).toDouble();
    } else {
      // transfer-to-connect-account or other types
      transferAmt = (json['transfer_amount'] ?? amount).toDouble();
    }

    return WalletTransactionModel(
      id: (json['id'] ?? '').toString(),
      transferAmount: transferAmt,
      payoutAmount: payoutAmt,
      currency: (json['currency'] ?? '').toString().toUpperCase(),
      status: StatusType.fromJson(statusStr),
      type: type,
      createdAt: (json['created_at'] ?? '').toString(),
      stripeTransferId: (json['stripe_transfer_id'] ?? '').toString(),
      stripePayoutId: (json['stripe_payout_id'] ?? '').toString(),
      paidAt: (json['paid_at'] ?? '').toString(),
      payoutType: (json['payout_type'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      fundId: (json['fund_id'] ?? '').toString(),
      releasedAt: (json['released_at'] ?? '').toString(),
    );
  }
}
