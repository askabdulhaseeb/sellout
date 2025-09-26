import 'package:hive/hive.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../domain/entites/service_employee_entity.dart';

part 'quote_detail_entity.g.dart';

@HiveType(typeId: 79)
class QuoteDetailEntity {
  QuoteDetailEntity({
    required this.serviceEmployee,
    required this.sellerId,
    required this.buyerId,
    required this.quoteId,
    required this.status,
    required this.price,
    required this.currency,
  });

  @HiveField(0)
  final List<ServiceEmployeeEntity> serviceEmployee;

  @HiveField(1)
  final String sellerId;

  @HiveField(2)
  final String buyerId;

  @HiveField(3)
  final String quoteId;

  @HiveField(4)
  final StatusType status;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final String currency;
}
