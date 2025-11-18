import '../../../../../../core/enums/chat/chat_type.dart';
import '../../../domain/entities/offer/offer_amount_info_entity.dart';

class OfferAmountInfoModel extends OfferAmountInfoEntity {
  OfferAmountInfoModel({
    required super.offer,
    required super.currency,
    required super.isAccepted,
    required super.id,
    required super.type,
  });

  factory OfferAmountInfoModel.fromJson(Map<String, dynamic> json) =>
      OfferAmountInfoModel(
        offer: double.tryParse(json['offer']?.toString() ?? '0.0') ?? 0.0,
        currency: json['currency']?.toString() ?? '',
        isAccepted: json['is_accepted'] ?? false,
        id: json['id'] ?? '',
        type: ChatType.fromJson(json['type']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'offer': offer,
        'currency': currency,
        'is_accepted': isAccepted,
        'id': id,
        'type': type.json,
      };
}
