import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/sources/data_state.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/param/get_review_param.dart';

class LocalReview {
  static final String boxTitle = AppStrings.localReviewBox;
  static Box<ReviewEntity> get _box => Hive.box<ReviewEntity>(boxTitle);

  static Future<Box<ReviewEntity>> get openBox async =>
      await Hive.openBox<ReviewEntity>(boxTitle);

  Future<Box<ReviewEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ReviewEntity>(boxTitle);
    }
  }

  Future<void> save(ReviewEntity value) async {
    await _box.put(value.reviewID, value);
  }

  Future<void> clear() async => await _box.clear();

  ReviewEntity? entity(String value) => _box.get(value);

  List<ReviewEntity> reviewsWithQuery(GetReviewParam param) {
    switch (param.type) {
      case ReviewApiQueryOptionType.businessID:
        return _box.values
            .where((ReviewEntity review) => review.businessID == param.id)
            .toList();
      case ReviewApiQueryOptionType.customerID:
        return _box.values
            .where((ReviewEntity review) => review.sellerID == param.id)
            .toList();
      case ReviewApiQueryOptionType.reviewID:
        return _box.values
            .where((ReviewEntity review) => review.reviewID == param.id)
            .toList();
      case ReviewApiQueryOptionType.sellerID:
        return _box.values
            .where((ReviewEntity review) => review.sellerID == param.id)
            .toList();
      case ReviewApiQueryOptionType.serviceID:
        return _box.values
            .where((ReviewEntity review) => review.serviceID == param.id)
            .toList();
      case ReviewApiQueryOptionType.postID:
        return _box.values
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
