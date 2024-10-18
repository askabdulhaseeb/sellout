import 'package:hive/hive.dart';

import '../../../../../../core/enums/chat/chat_type.dart';
part 'offer_amount_info_entity.g.dart';

@HiveType(typeId: 27)
class OfferAmountInfoEntity {
  const OfferAmountInfoEntity({
    required this.offer,
    required this.currency,
    required this.isAccepted,
    required this.id,
    required this.type,
  });

  @HiveField(0)
  final double? offer;
  @HiveField(1)
  final String? currency;
  @HiveField(2)
  final bool isAccepted;
  @HiveField(3)
  final String id;
  @HiveField(4)
  final ChatType type;
}
