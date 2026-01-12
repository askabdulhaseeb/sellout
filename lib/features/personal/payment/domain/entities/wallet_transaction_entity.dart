import 'package:hive_ce/hive.dart';
import '../../../../../../core/enums/core/status_type.dart';
part 'wallet_transaction_entity.g.dart';

@HiveType(typeId: 93)
class WalletTransactionEntity  {
  WalletTransactionEntity({
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

  @HiveField(0)
  String id;
  @HiveField(1)
  double transferAmount;
  @HiveField(2)
  double payoutAmount;
  @HiveField(3)
  String currency;
  @HiveField(4)
  StatusType status;
  @HiveField(5)
  String type;
  @HiveField(6)
  String createdAt;
  @HiveField(7)
  String stripeTransferId;
  @HiveField(8)
  String stripePayoutId;
  @HiveField(9)
  String paidAt;
  @HiveField(10)
  String payoutType;
  @HiveField(11)
  String description;
  @HiveField(12)
  String fundId;
  @HiveField(13)
  String releasedAt;

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
