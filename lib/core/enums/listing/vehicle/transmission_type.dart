enum TransmissionType {
  auto('Auto', 'auto'),
  manual('Manual', 'manual');

  const TransmissionType(this.title, this.json);
  final String title;
  final String json;

  static TransmissionType? fromJson(String? json) {
    if (json == null) return null;
    for (final TransmissionType item in TransmissionType.values) {
      if (item.json == json) return item;
    }
    return null;
  }

  static List<TransmissionType> get list => TransmissionType.values;
}
