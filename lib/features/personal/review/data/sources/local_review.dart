import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/param/get_review_param.dart';

class LocalReview extends LocalHiveBox<ReviewEntity> {
 @override
  String get boxName => AppStrings.localReviewBox;

  static Future<Box<ReviewEntity>> get openBox async =>
      await Hive.openBox<ReviewEntity>(AppStrings.localReviewBox);

  ReviewEntity? entity(String value) => box.get(value);

  List<ReviewEntity> reviewsWithQuery(GetReviewParam param) {
    switch (param.type) {
      case ReviewApiQueryOptionType.businessID:
        return box.values
            .where((ReviewEntity review) => review.businessID == param.id)
            .toList();
      case ReviewApiQueryOptionType.customerID:
        return box.values
            .where((ReviewEntity review) => review.sellerID == param.id)
            .toList();
      case ReviewApiQueryOptionType.reviewID:
        return box.values
            .where((ReviewEntity review) => review.reviewID == param.id)
            .toList();
      case ReviewApiQueryOptionType.sellerID:
        return box.values
            .where((ReviewEntity review) => review.sellerID == param.id)
            .toList();
      case ReviewApiQueryOptionType.serviceID:
        return box.values
            .where((ReviewEntity review) => review.serviceID == param.id)
            .toList();
      case ReviewApiQueryOptionType.postID:
        return box.values
            .where((ReviewEntity review) => review.postID == param.id)
            .toList();
      // default:
      //   return <ReviewEntity>[];
    }
  }

  DataState<List<ReviewEntity>> dataState(GetReviewParam param) {
    try {
      final List<ReviewEntity> result = reviewsWithQuery(param);
      return DataSuccess<List<ReviewEntity>>('', result);
    } catch (e) {
      return DataFailer<List<ReviewEntity>>(CustomException(e.toString()));
    }
  }
}
