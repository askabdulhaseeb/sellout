import 'package:hive_ce/hive.dart';
import 'postage_entity.dart';
import 'fast_delivery_entity.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';

part 'shipping_detail_entity.g.dart';

@HiveType(typeId: 100)
class ShippingDetailEntity {

  const ShippingDetailEntity({
    required this.postage,
    this.fastDelivery,
    this.fromAddress,
    this.toAddress,
  });
  @HiveField(0)
  final List<PostageEntity> postage;
  @HiveField(1)
  final FastDeliveryEntity? fastDelivery;
  @HiveField(2)
  final AddressEntity? fromAddress;
  @HiveField(3)
  final AddressEntity? toAddress;
}
