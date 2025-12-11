import 'package:hive_ce/hive.dart';
part 'postage_entity.g.dart';

@HiveType(typeId: 101)
class PostageEntity {
  @HiveField(0)
  final Map<String, dynamic>? parcel;
  @HiveField(1)
  final String? provider;
  @HiveField(2)
  final num? convertedBufferAmount;
  @HiveField(3)
  final String? serviceName;
  @HiveField(4)
  final String? rateObjectId;
  @HiveField(5)
  final String? nativeCurrency;
  @HiveField(6)
  final String? convertedCurrency;
  @HiveField(7)
  final num? nativeBufferAmount;
  @HiveField(8)
  final num? coreAmount;
  @HiveField(9)
  final String? shipmentId;
  @HiveField(10)
  final String? serviceToken;

  const PostageEntity({
    this.parcel,
    this.provider,
    this.convertedBufferAmount,
    this.serviceName,
    this.rateObjectId,
    this.nativeCurrency,
    this.convertedCurrency,
    this.nativeBufferAmount,
    this.coreAmount,
    this.shipmentId,
    this.serviceToken,
  });
}
