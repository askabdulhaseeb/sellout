import 'package:hive/hive.dart';
import '../../domain/entites/quote_detail_entity.dart';
import 'service_employee_model.dart';

@HiveType(typeId: 21) // Pick a unique typeId
class QuoteDetailModel extends QuoteDetailEntity {
  QuoteDetailModel({required super.serviceEmployee});

  /// --- From Map ---
  factory QuoteDetailModel.fromMap(Map<String, dynamic> map) {
    return QuoteDetailModel(
      serviceEmployee: (map['services_and_employees'] as List?)
              ?.map((e) => ServiceEmployeeModel.fromMap(e))
              .toList() ??
          [],
    );
  }
}
