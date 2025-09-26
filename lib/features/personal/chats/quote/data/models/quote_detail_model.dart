import 'package:hive/hive.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../domain/entites/quote_detail_entity.dart';
import 'service_employee_model.dart';

@HiveType(typeId: 21)
class QuoteDetailModel extends QuoteDetailEntity {
  QuoteDetailModel({
    required super.serviceEmployee,
    required super.sellerId,
    required super.buyerId,
    required super.quoteId,
    required super.status,
    required super.price,
    required super.currency,
  });

  /// --- From Map ---
  factory QuoteDetailModel.fromMap(Map<String, dynamic> map) {
    return QuoteDetailModel(
      serviceEmployee: (map['services_and_employees'] as List? ?? [])
          .map((e) => ServiceEmployeeModel.fromMap(e))
          .toList(),
      sellerId: map['seller_id']?.toString() ?? '',
      buyerId: map['buyer_id']?.toString() ?? '',
      quoteId: map['quote_id']?.toString() ?? '',
      status: StatusType.fromJson(map['status']?.toString()),
      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price']?.toString() ?? '0') ?? 0,
      currency: map['currency']?.toString() ?? '',
    );
  }
}
