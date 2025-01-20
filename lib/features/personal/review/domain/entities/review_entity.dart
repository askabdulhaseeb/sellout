import 'package:hive/hive.dart';

import '../../../../attachment/domain/entities/attachment_entity.dart';
import '../enums/review_type.dart';
part 'review_entity.g.dart';

@HiveType(typeId: 47)
class ReviewEntity {
  ReviewEntity({
    required this.postID,
    required this.reviewID,
    required this.sellerID,
    required this.businessID,
    required this.serviceID,
    required this.rating,
    required this.title,
    required this.text,
    required this.typeSTR,
    required this.reviewBy,
    // required this.comments,
    required this.fileUrls,
    required this.createdAt,
  }) : inHiveAt = DateTime.now();

  @HiveField(0)
  final String? postID;
  @HiveField(1)
  final String reviewID;
  @HiveField(2)
  final String? sellerID;
  @HiveField(3)
  final String? businessID;
  @HiveField(4)
  final String? serviceID;
  @HiveField(5)
  final double rating;
  @HiveField(6)
  final String title;
  @HiveField(7)
  final String text;
  @HiveField(8)
  final String typeSTR;
  @HiveField(9)
  final String reviewBy;
  // @HiveField(10)
  // final List<dynamic> comments;
  @HiveField(11)
  final List<AttachmentEntity> fileUrls;
  @HiveField(12)
  final DateTime createdAt;
  @HiveField(99)
  final DateTime inHiveAt;

  ReviewType get type => ReviewType.fromJson(typeSTR);
}
