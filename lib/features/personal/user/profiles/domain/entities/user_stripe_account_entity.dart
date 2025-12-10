import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../core/enums/core/status_type.dart';
part 'user_stripe_account_entity.g.dart';

@HiveType(typeId: 45)
class UserStripeAccountEntity {
  UserStripeAccountEntity({
    required this.payoutEnabled,
    required this.chargesEnabled,
    required this.detailsSubmitted,
    required this.status,
  });

  @HiveField(0)
  final bool payoutEnabled;
  @HiveField(1)
  final bool chargesEnabled;
  @HiveField(2)
  final bool detailsSubmitted;
  @HiveField(3)
  final StatusType status;
}
