import '../../../signin/domain/entities/stripe_connect_account_entity.dart';

class StripeConnectAccountModel extends StripeConnectAccountEntity {
  StripeConnectAccountModel({
    required super.payoutsEnabled,
    required super.id,
    required super.chargesEnabled,
    required super.detailsSubmitted,
    required super.status,
  });

  factory StripeConnectAccountModel.fromJson(Map<String, dynamic> json) {
    return StripeConnectAccountModel(
      payoutsEnabled: json['payouts_enabled'] ?? false,
      id: json['id'] ?? '',
      chargesEnabled: json['charges_enabled'] ?? false,
      detailsSubmitted: json['details_submitted'] ?? false,
      status: json['status'] ?? '',
    );
  }
}
