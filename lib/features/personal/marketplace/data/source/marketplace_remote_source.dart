import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../post/data/models/post/post_model.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../../domain/params/filter_params.dart';
import '../../domain/params/post_by_filter_params.dart';
import '../../views/enums/sort_enums.dart';

abstract class MarketPlaceRemoteSource {
  Future<DataState<List<PostEntity>>> postByFilters(PostByFiltersParams params);
}

class MarketPlaceRemoteSourceImpl implements MarketPlaceRemoteSource {
  @override
  Future<DataState<List<PostEntity>>> postByFilters(
      PostByFiltersParams params) async {
    try {
      String endpoint = 'post/filter?';
      if (params.sort != SortOption.newlyList && params.sort != null) {
        endpoint += 'sort=${params.sort?.json}&';
      }
      if (params.query != '' && params.query != null) {
        endpoint += 'query=${params.query}&';
      }
      if (params.distance != null) {
        endpoint += 'distance=${params.distance}&';
      }
      if (params.clientLat != null) {
        endpoint += 'clientLat=${params.clientLat}&';
      }
      if (params.clientLng != null) {
        endpoint += 'clientLng=${params.clientLng}&';
      }
      if (params.size.isNotEmpty) {
        endpoint += 'size=${json.encode(params.size)}&';
      }
      if (params.colors.isNotEmpty) {
        endpoint += 'color=${json.encode(params.colors)}&';
      }
      if (params.address != null && params.address!.isNotEmpty) {
        endpoint += 'address=${params.address}&';
      }
      if (params.category != null && params.category!.isNotEmpty) {
        endpoint += 'category=${params.category}&';
      }
      if (params.lastKey != null && params.lastKey!.isNotEmpty) {
        // Append raw lastKey JSON
        endpoint += 'lastKey=${jsonEncode(<String, String?>{
              'post_id': params.lastKey
            })}&';
      }
      if (params.filters.isNotEmpty) {
        final String filtersStr = jsonEncode(
          params.filters.map((FilterParam e) => e.toMap()).toList(),
        );
        // Append raw JSON
        endpoint += 'filters=$filtersStr&';
      }
      if (endpoint.endsWith('&')) {
        endpoint = endpoint.substring(0, endpoint.length - 1);
      }
      debugPrint('Final endpoint: $endpoint');
      final DataState<List<PostEntity>> result =
          await ApiCall<List<PostEntity>>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final dynamic jsonData = jsonDecode(result.data ?? '');
        final List<dynamic> items = jsonData['items'] ?? <dynamic>[];
        final List<PostEntity> posts = items
            .map((dynamic item) =>
                PostModel.fromJson(item as Map<String, dynamic>))
            .toList();
        final String pageKey = (jsonData.containsKey('lastKey') &&
                jsonData['lastKey'] != null &&
                jsonData['lastKey']['post_id'] != null)
            ? jsonData['lastKey']['post_id'] as String
            : '';
        return DataSuccess<List<PostEntity>>(pageKey, posts);
      } else {
        return DataFailer<List<PostEntity>>(
          CustomException('No data received from API.'),
        );
      }
    } catch (e, stc) {
      AppLog.error('',
          name: 'MarketPlaceRemoteSourceImpl.postByFilters - catch',
          error: e,
          stackTrace: stc);
      return DataFailer<List<PostEntity>>(
        CustomException('Failed to load posts'),
      );
    }
  }
}
