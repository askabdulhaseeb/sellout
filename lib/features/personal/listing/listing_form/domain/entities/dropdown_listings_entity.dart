import 'package:hive/hive.dart';
part 'dropdown_listings_entity.g.dart';

@HiveType(typeId: 58)
class DropdownOptionEntity {
  const DropdownOptionEntity({
    required this.label,
    required this.value,
    this.children = const <DropdownOptionEntity>[],
  });

  factory DropdownOptionEntity.fromMap(MapEntry<String, dynamic> entry) {
    final String key = entry.key;
    final value = entry.value;

    if (value is Map<String, dynamic>) {
      if (value.containsKey('label') && value.containsKey('value')) {
        // It's a leaf node (final selectable option)
        return DropdownOptionEntity(
          label: value['label'] ?? key,
          value: value['value'] ?? key,
        );
      } else {
        // It's a group node (has nested children)
        return DropdownOptionEntity(
          label: key,
          value: key,
          children: value.entries.map(DropdownOptionEntity.fromMap).toList(),
        );
      }
    } else {
      // Defensive fallback: unexpected type, treat as a simple option
      return DropdownOptionEntity(
        label: key,
        value: key,
      );
    }
  }
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String value;

  @HiveField(2)
  final List<DropdownOptionEntity> children;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'value': value,
      if (children.isNotEmpty)
        'children': <String, Map<String, dynamic>>{
          for (final DropdownOptionEntity child in children)
            child.value: child.toMap(),
        }
    };
  }
}

@HiveType(typeId: 59)
class DropdownCategoryEntity {
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
  @HiveField(0)
  final String key;

  @HiveField(1)
  final List<DropdownOptionEntity> options;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      for (final DropdownOptionEntity opt in options) opt.value: opt.toMap(),
    };
  }
}
