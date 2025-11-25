class BillingDetailsEntity {
  const BillingDetailsEntity({
    required this.subtotal,
    required this.deliveryTotal,
    required this.grandTotal,
    required this.currency,
  });

  final String subtotal;
  final String deliveryTotal;
  final String grandTotal;
  final String currency;
}
