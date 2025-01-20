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

        final List<dynamic> list = json.decode(raw);
        for (dynamic item in list) {
          final CountryEntity country = CountryModel.fromMap(item);
          countries.add(country);
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
    final List<CountryEntity> countries = LocalCountry().activeCounties;
    if (countries.isNotEmpty) return countries;

    final ApiRequestEntity? local = await LocalRequestHistory()
        .request(endpoint: '/country', duration: duration);

    if (local == null) return countries;
    final List<dynamic> list = local.decodedData;

    for (dynamic item in list) {
      final CountryEntity country = CountryModel.fromMap(item);
      countries.add(country);
    }
    return countries;
  }
}
