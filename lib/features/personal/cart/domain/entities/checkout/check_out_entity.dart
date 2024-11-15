import 'check_out_item_entity.dart';

class CheckOutEntity {
  CheckOutEntity({
    required this.items,
    required this.grandTotal,
    required this.currency,
  });

  final List<CheckOutItemEntity> items;
  final double grandTotal;
  final String currency;
}
