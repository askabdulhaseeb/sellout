// import '../../../../data/models/categories_models.dart/sub_models/dropdown_option.model.dart';
// import 'dropdown_option_entity.dart';

// class BodyTypeEntity {
//   final Map<String, Map<String, DropdownOptionEntity>> types;
//   BodyTypeEntity({required this.types});
// }

// class BodyTypeModel extends BodyTypeEntity {
//   BodyTypeModel({required super.types});

//   factory BodyTypeModel.fromJson(Map<String, dynamic> json) {
//     final Map<String, Map<String, DropdownOptionModel>> result = <String, Map<String, DropdownOptionModel>>{};
//     json.forEach((String category, subMap) {
//       final Map<String, DropdownOptionModel> subResult = <String, DropdownOptionModel>{};
//       (subMap as Map<String, dynamic>).forEach((String key, value) {
//         subResult[key] = DropdownOptionModel.fromJson(value);
//       });
//       result[category] = subResult;
//     });
//     return BodyTypeModel(types: result);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> result = <String, dynamic>{};
//     types.forEach((String category, Map<String, DropdownOptionEntity> subMap) {
//       result[category] =
//           subMap.map((String key, DropdownOptionEntity value) => MapEntry(key, value.toJson()));
//     });
//     return result;
//   }
// }
