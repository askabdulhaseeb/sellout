import '../../../../functions/app_log.dart';
import '../../../../sources/api_call.dart';
import '../../../../sources/local/local_request_history.dart';
import '../../domain/entities/country_entity.dart';
import '../models/country_model.dart';
import 'local_country.dart';

abstract interface class CountryApi {
  Future<DataState<List<CountryEntity>>> countries(Duration duration);
}

class CountryApiImpl implements CountryApi {
  @override
  Future<DataState<List<CountryEntity>>> countries(Duration duration) async {
    try {
      //
      final List<CountryEntity> countries = await _localCounties(duration);
      if (countries.isNotEmpty) {
        return DataSuccess<List<CountryEntity>>('', countries);
      }

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/country',
        requestType: ApiRequestType.get,
        isAuth: false,
      );
      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataSuccess<List<CountryEntity>>('', countries);
        }

        // Try to decode the response into a List. Be defensive about types
        // because some APIs return wrapped objects or JSON-encoded strings.
        dynamic decoded;
        try {
          decoded = json.decode(raw);
        } catch (e) {
          // If json.decode fails, log and return empty list
          AppLog.error(
            'Failed to decode countries response: $e',
            name: 'CountryApiImpl.countries - decode',
            error: e,
          );
          return DataSuccess<List<CountryEntity>>('', countries);
        }

        List<dynamic>? list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map) {
          // Common case: { data: [...] } or similar
          if (decoded['data'] is List) {
            list = decoded['data'] as List<dynamic>;
          } else {
            // If map directly contains country entries, try to use values
            final Iterable<dynamic> values = decoded.values;
            list = values.where((e) => e != null).toList();
          }
        } else if (decoded is String) {
          // Sometimes the API returns a JSON encoded string; try decoding again
          try {
            final dynamic second = json.decode(decoded);
            if (second is List) {
              list = second;
            }
          } catch (_) {
            // ignore
          }
        }

        if (list == null || list.isEmpty) {
          return DataSuccess<List<CountryEntity>>('', countries);
        }

        for (dynamic item in list) {
          try {
            final CountryEntity country = CountryModel.fromMap(item);
            countries.add(country);
          } catch (e) {
            AppLog.error('Failed parse country item: $e',
                name: 'CountryApiImpl.countries - parse-item', error: e);
            // continue parsing other items
          }
        }
        return DataSuccess<List<CountryEntity>>('', countries);
      } else {
        AppLog.error(
          result.exception?.message ?? 'something went wrong',
          name: 'CountryApiImpl.countries - else',
          error: result.exception,
        );
        return DataSuccess<List<CountryEntity>>('', countries);
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CountryApiImpl.countries - catch',
        error: e,
      );
      return DataFailer<List<CountryEntity>>(CustomException(e.toString()));
    }
  }

  Future<List<CountryEntity>> _localCounties(Duration duration) async {
    final List<CountryEntity> countries = LocalCountry().activeCountries;
    if (countries.isNotEmpty) return countries;

    final ApiRequestEntity? local = await LocalRequestHistory()
        .request(endpoint: '/country', duration: duration);

    if (local == null) return countries;

    final dynamic decoded = local.decodedData;
    List<dynamic>? list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is String) {
      try {
        final dynamic second = json.decode(decoded);
        if (second is List) list = second;
      } catch (_) {}
    } else if (decoded is Map) {
      if (decoded['data'] is List) {
        list = decoded['data'] as List<dynamic>;
      } else {
        list = decoded.values.where((e) => e != null).toList();
      }
    }

    if (list == null) return countries;

    for (dynamic item in list) {
      try {
        final CountryEntity country = CountryModel.fromMap(item);
        countries.add(country);
      } catch (e) {
        AppLog.error('Failed parse local country item: $e',
            name: 'CountryApiImpl._localCounties - parse-item', error: e);
      }
    }
    return countries;
  }
}
