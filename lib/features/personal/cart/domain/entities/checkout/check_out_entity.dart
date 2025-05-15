import '../../../../auth/signin/data/models/address_model.dart';
import 'check_out_item_entity.dart';

class CheckOutEntity {
  CheckOutEntity(
      {required this.items,
      required this.grandTotal,
      required this.currency,
      required this.buyerId,
      required this.buyerAddress});

  final List<CheckOutItemEntity> items;
  final double grandTotal;
  final String currency;
  final String buyerId;
  final AddressEntity? buyerAddress;
}
