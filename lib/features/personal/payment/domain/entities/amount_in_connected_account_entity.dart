abstract class AmountInConnectedAccountEntity {
  const AmountInConnectedAccountEntity({
    required this.available,
    required this.currency,
    required this.lastSynced,
    required this.pending,
  });

  final double available;
  final String currency;
  final String lastSynced;
  final double pending;
}
