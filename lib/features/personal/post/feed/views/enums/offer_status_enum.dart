enum OfferStatus {
  cancel('cancel'),
  reject('reject'),
  pending('pending'),
  accept('accept');

  final String value;
  const OfferStatus(this.value);
}
extension OfferStatusExtension on OfferStatus {
  String toJson() {
    return value; // Use the assigned string value
  }

  static OfferStatus fromJson(String status) {
    return OfferStatus.values.firstWhere(
      (OfferStatus e) => e.value == status,
      orElse: () => OfferStatus.pending, // Default value if unknown status
    );
  }
}
