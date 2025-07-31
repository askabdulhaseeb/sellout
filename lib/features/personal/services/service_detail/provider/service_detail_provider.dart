import 'package:flutter/foundation.dart';
import '../../../../../core/functions/app_log.dart' show AppLog;
import '../../../../../core/usecase/usecase.dart';
import '../../../review/domain/entities/review_entity.dart';
import '../../../review/domain/param/get_review_param.dart';
import '../../../review/domain/usecase/get_reviews_usecase.dart';

class ServiceDetailProvider extends ChangeNotifier {
  final GetReviewsUsecase _getReviewsUsecase;

  ServiceDetailProvider(this._getReviewsUsecase);

  List<ReviewEntity> _reviews = [];

  List<ReviewEntity> get reviews => _reviews;

  void setReviews(List<ReviewEntity> reviews) {
    _reviews = reviews;
    notifyListeners();
  }

  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam param) async {
    try {
      if (_reviews.isNotEmpty) {
        return DataSuccess<List<ReviewEntity>>('', _reviews);
      }

      final result = await _getReviewsUsecase(param);

      if (result is DataSuccess<List<ReviewEntity>>) {
        setReviews(result.entity ?? <ReviewEntity>[]);
        return result;
      } else {
        return result;
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'ServiceDetailProvider.getReviews - catch',
        error: e,
      );
      return DataFailer<List<ReviewEntity>>(CustomException(e.toString()));
    }
  }
}
