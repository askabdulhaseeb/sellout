import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/sources/local/local_request_history.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/param/get_review_param.dart';
import '../models/review_model.dart';
import 'local_review.dart';

abstract interface class ReviewRemoteApi {
  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam params);
}

class ReviewRemoteApiImpl implements ReviewRemoteApi {
  @override
  Future<DataState<List<ReviewEntity>>> getReviews(
      GetReviewParam params) async {
    try {
      final String endpoint = '/review/get?${params.query}';
      //
      // LOCAL History
      ApiRequestEntity? request = await LocalRequestHistory().request(
        endpoint: endpoint,
        duration: params.duration ?? const Duration(days: 1),
      );
      if (request != null) {
        final List<dynamic> decoded = request.decodedData;
        final List<ReviewEntity> reviews = <ReviewEntity>[];
        if (decoded.isNotEmpty) {
          for (dynamic element in decoded) {
            final ReviewEntity review = ReviewModel.fromJson(element);
            await LocalReview().save(review);
            reviews.add(review);
          }
          return DataSuccess<List<ReviewEntity>>('', reviews);
        }
      }
      //
      // Cloud Fresh Data
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
      );
      if (response is DataSuccess) {
        final String raw = response.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'empty-data'.tr(),
            name: 'ReviewRemoteApiImpl.getReviews - if',
            error: CustomException('empty-data'.tr()),
          );
          return DataSuccess<List<ReviewEntity>>(raw, <ReviewEntity>[]);
        }

        final List<dynamic> decoded = json.decode(raw);
        final List<ReviewEntity> reviews = <ReviewEntity>[];

        for (dynamic element in decoded) {
          final ReviewEntity review = ReviewModel.fromJson(element);
          await LocalReview().save(review);
          reviews.add(review);
        }
        return DataSuccess<List<ReviewEntity>>(raw, reviews);
      } else {
        AppLog.error(
          response.exception?.message ?? 'something-wrong'.tr(),
          name: 'ReviewRemoteApiImpl.getReviews - else',
          error: response.exception,
        );
        return DataFailer<List<ReviewEntity>>(CustomException(''));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'ReviewRemoteApiImpl.getReviews - catch',
        error: e,
      );
      return DataFailer<List<ReviewEntity>>(CustomException(e.toString()));
    }
  }
}
