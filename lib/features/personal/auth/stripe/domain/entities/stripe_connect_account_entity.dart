import 'package:hive_ce/hive.dart';
part '../../../signin/domain/entities/stripe_connect_account_entity.g.dart';

@HiveType(typeId: 88)
class StripeConnectAccountEntity {
  const StripeConnectAccountEntity({
    required this.payoutsEnabled,
    required this.id,
    required this.chargesEnabled,
    required this.detailsSubmitted,
    required this.status,
  });

  @HiveField(0)
  final bool payoutsEnabled;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final bool chargesEnabled;
  @HiveField(3)
  final bool detailsSubmitted;
  @HiveField(4)
  final String status;
}
