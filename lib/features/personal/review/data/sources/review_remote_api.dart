import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/sources/local/local_request_history.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/param/create_review_params.dart';
import '../../domain/param/get_review_param.dart';
import '../models/review_model.dart';
import 'local_review.dart';

abstract interface class ReviewRemoteApi {
  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam params);
  Future<DataState<bool>> postReview(CreateReviewParams params);
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
          response.exception?.message ?? 'something_wrong'.tr(),
          name: 'ReviewRemoteApiImpl.getReviews - else',
          error: response.exception?.message,
        );
        return DataFailer<List<ReviewEntity>>(CustomException(''));
      }
    } catch (e) {
      print('');
      AppLog.error(
        e.toString(),
        name: 'ReviewRemoteApiImpl.getReviews - catch',
        error: e,
      );
      return DataFailer<List<ReviewEntity>>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> postReview(CreateReviewParams params) async {
    try {
      const String endpoints = '/review/create';
      final DataState<bool> response = await ApiCall<bool>().callFormData(
          endpoint: endpoints,
          requestType: ApiRequestType.post,
          fieldsMap: params.toMap(),
          attachments: params.attachments,
          isAuth: true,
          isConnectType: false);
      debugPrint('API Response: $response');
      if (response is DataSuccess<bool>) {
        AppLog.info(
          'review_posted_successfully'.tr(),
          name: 'ReviewRemoteApiImpl.postReview - Success: ${response.data}',
        );
        return response;
      } else if (response is DataFailer<ReviewEntity>) {
        AppLog.error(
          'something_wrong'.tr(),
          name:
              'ReviewRemoteApiImpl.postReview - Error: ${response.exception?.message ?? "Unknown error"}',
        );
        return DataFailer<bool>(
          CustomException(
              response.exception?.message ?? 'Unknown error occurred'),
        );
      } else {
        return DataFailer<bool>(
          CustomException('Unexpected response type'),
        );
      }
    } catch (e, stackTrace) {
      AppLog.error(
        'something_wrong'.tr(),
        name: 'ReviewRemoteApiImpl.postReview - Exception: $e',
      );
      debugPrint('Stack Trace: $stackTrace');
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
