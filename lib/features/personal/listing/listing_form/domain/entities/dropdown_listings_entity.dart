import 'package:hive/hive.dart';
part 'dropdown_listings_entity.g.dart';

@HiveType(typeId: 58)
class DropdownOptionEntity {
  const DropdownOptionEntity({
    required this.label,
    required this.value,
    this.children = const <DropdownOptionEntity>[],
  });

  /// Parses dynamic input (Map, List, or single value)
  factory DropdownOptionEntity.fromDynamic(dynamic data, {String? key}) {
    if (data is Map<String, dynamic>) {
      // Leaf node
      if (data.containsKey('label') && data.containsKey('value')) {
        return DropdownOptionEntity(
          label: data['label'] ?? key ?? '',
          value: data['value'] ?? key ?? '',
          children: (data['children'] as List?)
                  ?.map((e) => DropdownOptionEntity.fromDynamic(e))
                  .toList() ??
              [],
        );
      } else {
        // Group node with nested map
        return DropdownOptionEntity(
          label: key ?? 'unknown',
          value: key ?? 'unknown',
          children: data.entries
              .map((e) => DropdownOptionEntity.fromDynamic(e.value, key: e.key))
              .toList(),
        );
      }
    } else if (data is List) {
      // List of options
      return DropdownOptionEntity(
        label: key ?? 'unknown',
        value: key ?? 'unknown',
        children: data.map((e) => DropdownOptionEntity.fromDynamic(e)).toList(),
      );
    } else {
      // Fallback for simple values
      return DropdownOptionEntity(
        label: data.toString(),
        value: data.toString(),
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
        'children': children.map((c) => c.toMap()).toList(),
    };
  }
}

@HiveType(typeId: 59)
class DropdownCategoryEntity {
  const DropdownCategoryEntity({
    required this.key,
    required this.options,
  });

  /// Parses dynamic input for category (Map or List)
  factory DropdownCategoryEntity.fromDynamic(String key, dynamic data) {
    if (data is Map<String, dynamic>) {
      return DropdownCategoryEntity(
        key: key,
        options: data.entries
            .map((e) => DropdownOptionEntity.fromDynamic(e.value, key: e.key))
            .toList(),
      );
    } else if (data is List) {
      return DropdownCategoryEntity(
        key: key,
        options: data.map((e) => DropdownOptionEntity.fromDynamic(e)).toList(),
      );
    } else {
      // Fallback
      return DropdownCategoryEntity(
        key: key,
        options: [],
      );
    }
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
