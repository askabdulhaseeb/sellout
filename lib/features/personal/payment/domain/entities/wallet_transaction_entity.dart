import '../../../../../../core/enums/core/status_type.dart';

class WalletTransactionEntity {
  const WalletTransactionEntity({
    required this.id,
    required this.transferAmount,
    required this.payoutAmount,
    required this.currency,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.stripeTransferId,
    required this.stripePayoutId,
    required this.paidAt,
    required this.payoutType,
    required this.description,
    required this.fundId,
    required this.releasedAt,
  });

  final String id;
  final double transferAmount;
  final double payoutAmount;
  final String currency;
  final StatusType status;
  final String type;
  final String createdAt;
  final String stripeTransferId;
  final String stripePayoutId;
  final String paidAt;
  final String payoutType;
  final String description;
  final String fundId;
  final String releasedAt;

  double get amount {
    final String typeL = type.toLowerCase();
    if (typeL == 'payout-to-bank') {
      return payoutAmount;
    }
    if (typeL == 'release') {
      // For release type, both amounts should be the same
      return transferAmount > 0 ? transferAmount : payoutAmount;
    }
    return transferAmount;
  }
}
