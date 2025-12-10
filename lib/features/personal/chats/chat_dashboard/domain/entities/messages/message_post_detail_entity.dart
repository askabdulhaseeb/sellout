import 'package:hive_ce/hive.dart';
part 'message_post_detail_entity.g.dart';

@HiveType(typeId: 87)
class MessagePostDetailEntity {
  MessagePostDetailEntity({this.postId, this.title, this.price, this.currency});

  factory MessagePostDetailEntity.fromJson(Map<String, dynamic> json) {
    return MessagePostDetailEntity(
      postId: json['post_id'] as String?,
      title: json['title'] as String?,
      price: json['price'] as num?,
      currency: json['currency'] as String?,
    );
  }
  @HiveField(0)
  final String? postId;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final num? price;
  @HiveField(3)
  final String? currency;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'post_id': postId,
    'title': title,
    'price': price,
    'currency': currency,
  };
}
