import 'package:hive/hive.dart';
import '../../domain/entites/service_employee_entity.dart';
part 'quote_detail_entity.g.dart';

@HiveType(typeId: 79)
class QuoteDetailEntity {
  QuoteDetailEntity({required this.serviceEmployee});

  @HiveField(0)
  final List<ServiceEmployeeEntity> serviceEmployee;
}
