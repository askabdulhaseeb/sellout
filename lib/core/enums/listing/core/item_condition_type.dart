enum ItemConditionType {
  newC('new', 'new'),
  used('used', 'used');

  const ItemConditionType(this.code, this.json);
  final String code;
  final String json;

  static ItemConditionType? fromJson(String? json) {
    if (json == null) return null;
    for (final ItemConditionType item in ItemConditionType.values) {
      if (item.json == json) return item;
    }
    return null;
  }

  static List<ItemConditionType> get list => ItemConditionType.values;
}
