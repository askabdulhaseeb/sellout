import '../../../../../../core/enums/core/status_type.dart';
import '../../domain/entities/user_stripe_account_entity.dart';

class UserStripeAccountModel extends UserStripeAccountEntity {
  UserStripeAccountModel({
    required super.payoutEnabled,
    required super.chargesEnabled,
    required super.detailsSubmitted,
    required super.status,
  });

  factory UserStripeAccountModel.fromMap(Map<String, dynamic> map) {
    return UserStripeAccountModel(
      payoutEnabled: map['payouts_enabled'] ?? false,
      chargesEnabled: map['charges_enabled'] ?? false,
      detailsSubmitted: map['details_submitted'] ?? false,
      status: StatusType.fromJson(map['status']),
    );
  }
}
