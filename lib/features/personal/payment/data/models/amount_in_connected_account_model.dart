import '../../domain/entities/amount_in_connected_account_entity.dart';

class AmountInConnectedAccountModel extends AmountInConnectedAccountEntity {
  const AmountInConnectedAccountModel({
    required super.available,
    required super.currency,
    required super.lastSynced,
    required super.pending,
  });

  factory AmountInConnectedAccountModel.fromJson(Map<String, dynamic> json) {
    return AmountInConnectedAccountModel(
      available: (json['available'] ?? 0).toDouble(),
      currency: (json['currency'] ?? '').toString().toUpperCase(),
      lastSynced: (json['last_synced'] ?? '').toString(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }
}
