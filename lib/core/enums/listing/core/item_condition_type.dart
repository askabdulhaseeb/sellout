enum ConditionType {
  newC('new', 'new'),
  used('used', 'used');

  const ConditionType(this.code, this.json);
  final String code;
  final String json;

  static ConditionType? fromJson(String? json) {
    if (json == null) return null;
    for (final ConditionType item in ConditionType.values) {
      if (item.json == json) return item;
    }
    return null;
  }

  static List<ConditionType> get list => ConditionType.values;
}
