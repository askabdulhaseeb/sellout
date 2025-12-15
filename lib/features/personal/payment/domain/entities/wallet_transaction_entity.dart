abstract class WalletTransactionEntity {
  const WalletTransactionEntity({required this.raw});

  /// Unknown/variable payload shape; preserved for forward compatibility.
  final Map<String, dynamic> raw;
}
