import 'package:hive/hive.dart';
part 'dropdown_listings_entity.g.dart';

@HiveType(typeId: 58)
class DropdownOptionEntity {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String value;

  @HiveField(2)
  final List<DropdownOptionEntity> children;

  const DropdownOptionEntity({
    required this.label,
    required this.value,
    this.children = const <DropdownOptionEntity>[],
  });

  factory DropdownOptionEntity.fromMap(MapEntry<String, dynamic> entry) {
    final valueMap = entry.value as Map<String, dynamic>;

    if (valueMap.containsKey('label')) {
      // This is a leaf node
      return DropdownOptionEntity(
        label: valueMap['label'] ?? entry.key,
        value: valueMap['value'] ?? entry.key,
        children: const [],
      );
    } else {
      // This is a group node
      return DropdownOptionEntity(
        label: entry.key,
        value: entry.key,
        children: valueMap.entries.map(DropdownOptionEntity.fromMap).toList(),
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      if (children.isNotEmpty)
        'children': {
          for (final child in children) child.value: child.toMap(),
        }
    };
  }
}

@HiveType(typeId: 59)
class DropdownCategoryEntity {
  @HiveField(0)
  final String key;

  @HiveField(1)
  final List<DropdownOptionEntity> options;

  const DropdownCategoryEntity({
    required this.key,
    required this.options,
  });

  factory DropdownCategoryEntity.fromMap(String key, Map<String, dynamic> map) {
    return DropdownCategoryEntity(
      key: key,
      options: map.entries.map(DropdownOptionEntity.fromMap).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      for (final opt in options) opt.value: opt.toMap(),
    };
  }
}
