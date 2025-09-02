// import '../../domain/entities/dropdown_listings_entity.dart';

// class OptionModel extends OptionEntity {
//   OptionModel({
//     required super.key,
//     required super.label,
//     required super.value,
//   });

//   factory OptionModel.fromMap(String key, Map<String, dynamic> map) {
//     return OptionModel(
//       key: key,
//       label: map['label'] ?? '',
//       value: map['value'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'label': label,
//       'value': value,
//     };
//   }
// }

// class CategoryModel extends CategoryEntity {
//   CategoryModel({
//     required List<OptionModel> options,
//   }) : super(options: options);

//   factory CategoryModel.fromMap(Map<String, dynamic> map) {
//     return CategoryModel(
//       options:
//           map.entries.map((e) => OptionModel.fromMap(e.key, e.value)).toList(),
//     );
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       for (final opt in options) opt.key: (opt as OptionModel).toMap(),
//     };
//   }
// }
